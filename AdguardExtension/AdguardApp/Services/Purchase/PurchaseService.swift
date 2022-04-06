//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import StoreKit
import CommonCrypto
import Setapp
import class SharedAdGuardSDK.Atomic

typealias Period = (unit: PurchasePeriod, numberOfUnits: Int)

enum PurchasePeriod {
    case day, week, month, year
}

enum ProductType {
    case subscription, lifetime
}

enum SocialProvider: String {
    case google
    case apple
    case facebook
}

typealias Product = (type: ProductType, price: String, period: Period?, trialPeriod: Period?, productId: String)

// MARK:  service protocol -
/**
 PurchaseService is a service responsible for all purchases.
 The user can get professional status through renewable subscriptions(in-app purchases) or through an Adguard license.
 In-app purchases are carried out directly in this service.
 Work with Adguard Licenses is delegated to EmailSignInController
 */

// MARK: - service implementation -
final class PurchaseService: NSObject, PurchaseServiceProtocol, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    // MARK: constants -
    // store kit constants

    // product id for renewable annual subscription
    private let annualSubscriptionProductID = "com.adguard.annual"

    // product id for renewable monthly subscription
    private let monthlySubscriptionProductID = "com.adguard.monthly"

    // product id for non-consumable in app purchase
    private let lifetimeProductID = "com.adguard.lifetimePurchase"

    // product id for alternate non-consumable in app purchase. We use it for rub or uah currency
    private let lifetimeAlternateProductID = "com.adguard.lifetimeAlternate"

    // product id for 'free' non-consumable in app purchase. We use it for AdGuard Pro license migration
    private let migrationProductID = "com.adguard.AdGuardApp.nonconsumable.free"

    // Flag meaning that this app belongs to AdGuard Software Limited developer account
    private let isAslApp = Bundle.main.bundleIdentifier == "com.adguard.AdGuardApp"

    private lazy var allProducts: Set<String> = { [annualSubscriptionProductID, monthlySubscriptionProductID, lifetimeProductID, lifetimeAlternateProductID, migrationProductID] }()

    // ios_validate_receipt request

    private let RECEIPT_DATA_PARAM = "receipt_data"
    private let APP_ID_PARAM = "app_id"
    private let APP_VERSION_PARAM = "app_version"
    private let APP_NAME_PARAM = "app_name"
    private let VALIDATE_RECEIPT_URL = "https://mobile-api.adguard.com/api/1.0/ios_validate_receipt"
    private let VALIDATE_NON_CONSUMABLE_FREE_RECEIPT_URL = "https://testmobile.adtidy.org/api/1.0/ios_validate_receipt" // FIXME replace with the real URL when it's ready

    // premium values
    private let PREMIUM_STATUS_ACTIVE = "ACTIVE"
    private let PREMIUM_STATUS_FREE = "FREE"

    // validate receipt params

    private let PRODUCTS_PARAM = "products"
    private let PRODUCT_ID_PARAM = "product_id"
    private let PREMIUM_STATUS_PARAM = "premium_status"
    private let EXPIRATION_DATE_PARAM = "expiration_date"

    private let AUTH_RESPONSE_TYPE_PARAM = "response_type"
    private let AUTH_CLIENT_ID_PARAM = "client_id"
    private let AUTH_SCOPE_PARAM = "scope"
    private let AUTH_REDIRECT_URI_PARAM = "redirect_uri"
    private let AUTH_STATE_PARAM = "state"
    private let AUTH_SOCIAL_PROVIDER = "social_provider"
    private let AUTH_REG_MODE = "reg_mode"

    private let authUrl = "https://auth.adguard.com/oauth/authorize"

    // MARK: - private properties
    private let network: ACNNetworkingProtocol
    private let resources: AESharedResourcesProtocol
    private let keychain: KeychainServiceProtocol
    private let productInfo: ADProductInfoProtocol
    private let appleSearchAdsService: AppleSearchAdsServiceProtocol?

    private var productRequest: SKProductsRequest?
    private var productsToPurchase: [SKProduct] { _atomicProductsToPurchase.wrappedValue }
    @Atomic private var atomicProductsToPurchase: [SKProduct] = []
    private var nonConsumableProduct: SKProduct?
    private var refreshRequest: SKReceiptRefreshRequest?

    private var freeLifeTimeSubscription: SKProduct? { _atomicFreeLifeTimeSubscription.wrappedValue }
    @Atomic private var atomicFreeLifeTimeSubscription: SKProduct? = nil

    private var loginService: LoginServiceProtocol

    private var purchasedThroughInApp: Bool {
        get {
            return resources.purchasedThroughInApp
        }
        set {
            resources.purchasedThroughInApp = newValue
        }
    }

    private var standardPeriod: Period = (unit: PurchasePeriod.day, numberOfUnits: 7)

    private let reachability = Reachability.forInternetConnection()

    private var notificationToken: NotificationToken?

    // MARK: - public properties

    var isProPurchased: Bool {
        purchasedThroughInApp || resources.purchasedThroughSetapp || loginService.hasActiveLicense
    }

    var purchasedThroughLogin: Bool { loginService.loggedIn }

    var licenseKey: String? { loginService.licenseKey }

    var purchasedThroughSetapp: Bool { resources.purchasedThroughSetapp }

    var purchasedThoughInApp: Bool { purchasedThroughInApp }

    var standardProduct: Product? {
        let pr = products.first(where: { $0.productId == annualSubscriptionProductID })
        return pr
    }

    var products: [Product] {
        var products = [Product]()
        for product in productsToPurchase {
            var type: ProductType!

            switch product.productIdentifier {
            case annualSubscriptionProductID, monthlySubscriptionProductID:
                type = .subscription
            case lifetimeProductID, lifetimeAlternateProductID:
                type = .lifetime
            default:
                DDLogError("(PurchaseService) error, product with unknown product id: \(product.productIdentifier)")
                assertionFailure("product with unknown product id: \(product.productIdentifier)")
                continue
            }

            let price = priceOfProduct(product)
            let period = periodOfProduct(product)
            let trialPeriod = trialPeriodOfProduct(product)

            products.append((type: type, price:price, period: period, trialPeriod: trialPeriod, productId: product.productIdentifier))
        }

        products = products.sorted(by: { (product1, product2) -> Bool in
            switch (product1.type, product2.type) {
            case (.subscription, .lifetime):
                return true
            case (.lifetime, .subscription):
                return false
            default:
                break
            }

            // compare two subscriptions
            guard let period1 = product1.period?.unit, let period2 = product2.period?.unit else { return true }
            switch (period1, period2) {
            case (.week, .month):
                return true
            case (.week, .year):
                return true
            case (.month, .year):
                return true
            default:
                return false
            }
        })

        return products
    }

    func requestPurchase(productId: String) {
        for product in productsToPurchase {
            if product.productIdentifier == productId {
                requestPurchase(product: product)
                return
            }
        }
    }

    func requestNonConsumableFreePurchase() {
        requestPurchase(product: freeLifeTimeSubscription)
    }

    func reset(completion: @escaping () -> Void) {
        loginService.reset(completion: completion)
    }

    // MARK: - public methods
    init(network: ACNNetworkingProtocol, resources: AESharedResourcesProtocol, productInfo: ADProductInfoProtocol, appleSearchAdsService: AppleSearchAdsServiceProtocol? = nil) {
        self.network = network
        self.resources = resources
        self.keychain = KeychainService(resources: resources)
        self.productInfo = productInfo
        loginService = LoginService(resources: resources, network: network, keychain: keychain, productInfo: productInfo)
        self.appleSearchAdsService = appleSearchAdsService

        super.init()

        start()

        loginService.activeChanged = { [weak self] in
            self?.postNotification(PurchaseAssistant.kPSNotificationPremiumStatusChanged)
        }
    }

    func start() {
        setObserver()
        requestProducts()
    }

    func checkLicenseStatus() {
        checkStatusInternal { [weak self] error in
            self?.processLoginResult(error)
        }
    }

    func login(withLicenseKey key: String, completion: @escaping (Bool)->Void) {
        appleSearchAdsService?.provideAttributionRecords { [weak self] attributionRecords in
            self?.loginService.login(licenseKey: key, attributionRecords: attributionRecords) { error in
                let result = self?.processLoginResult(error) ?? false
                completion(result)
            }
        }
    }

    func startProductRequest() {
        if productRequest != nil {
            productRequest?.cancel()

        }
        productRequest = SKProductsRequest(productIdentifiers: allProducts)
        productRequest?.delegate = self
        productRequest?.start()
    }

    func login(withAccessToken token: String?, state: String?) {

        let expectedState = resources.sharedDefaults().string(forKey: AEDefaultsAuthStateString)

        if token == nil || state == nil || expectedState == nil || state! != expectedState! {
            DDLogError("(PurchaseService) login with access token failed " + (token == nil ? "token == nil" : "") + (state == nil ? "state == nil" : "") + (expectedState == nil ? "expectedState == nil" : "") + (state != expectedState ? "state != expectedState" : ""))
            postNotification(PurchaseAssistant.kPSNotificationLoginFailure, nil)
            return
        }

        postNotification(PurchaseAssistant.kPSNotificationOauthSucceeded, nil)

        appleSearchAdsService?.provideAttributionRecords { [weak self] attributionRecords in
            self?.loginService.login(accessToken: token!, attributionRecords: attributionRecords) { (error) in
                self?.processLoginResult(error)
            }
        }
    }

    func login(name: String, password: String, code2fa: String?) {
        appleSearchAdsService?.provideAttributionRecords { [weak self] attributionRecords in
            self?.loginService.login(name: name, password: password, code2fa: code2fa, attributionRecords: attributionRecords) { (error) in
                self?.processLoginResult(error)
            }
        }
    }

    func validateReceipt(onComplete complete:@escaping ((Error?)->Void)){
        // get receipt
        guard let base64Str = getInAppPurchaseReceiptBase64() else {
            complete(NSError(domain: PurchaseAssistant.AEPurchaseErrorDomain, code: PurchaseAssistant.AEConfirmReceiptError, userInfo: nil))
            return
        }
        // post receipt to our backend

        guard let appId = keychain.appId else {
            DDLogError("(LoginService) loginInternal error - can not obtain appId)")
            complete(NSError(domain: PurchaseAssistant.AEPurchaseErrorDomain, code: PurchaseAssistant.AEConfirmReceiptError, userInfo: [:]))
            return
        }

        let jsonToSend = """
        {
        "\(APP_ID_PARAM)":"\(appId)",
        "\(APP_VERSION_PARAM)":"\(productInfo.version()!)",
        "\(APP_NAME_PARAM)":"\(LoginService.APP_NAME_VALUE)",
        "\(RECEIPT_DATA_PARAM)":"\(base64Str)"
        }
        """

        // The url to validate the receipt is different for different targets
        let backendUrl = isAslApp ? VALIDATE_NON_CONSUMABLE_FREE_RECEIPT_URL : VALIDATE_RECEIPT_URL
        guard let url = URL(string: backendUrl) else  {

            DDLogError("(PurchaseService) validateReceipt error. Can not make URL from String \(VALIDATE_RECEIPT_URL)")
            return
        }

        let request: URLRequest = ABECRequest.post(for: url, json: jsonToSend)

        network.data(with: request) { [weak self] (dataOrNil, response, error) in
            guard let strongSelf = self else {
                return
            }

            if error != nil {
                complete(error!)
                return
            }

            guard let data = dataOrNil  else{
                complete(NSError(domain: PurchaseAssistant.AEPurchaseErrorDomain, code: PurchaseAssistant.AEConfirmReceiptError, userInfo: nil))
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String: Any]

                let validateSuccess = strongSelf.processValidateResponse(json: jsonResponse)

                if !validateSuccess {
                    complete(NSError(domain: PurchaseAssistant.AEPurchaseErrorDomain, code: PurchaseAssistant.AEConfirmReceiptError, userInfo: nil))
                    return
                }

                strongSelf.purchasedThroughInApp = strongSelf.isInAppPurchaseActive()

                strongSelf.postNotification(PurchaseAssistant.kPSNotificationPremiumStatusChanged)
                complete(nil)
            }
            catch {
                complete(NSError(domain: PurchaseAssistant.AEPurchaseErrorDomain, code: PurchaseAssistant.AEConfirmReceiptError, userInfo: nil))
            }
        }
    }

    func logout()->Bool {
        return loginService.logout()
    }

    func requestRestore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func checkPremiumStatusChanged() {

        DDLogInfo("(PurchaseService) checkPremiumExpired")

        // we must validate receipts not only to check the expiration of the subscription,
        // but also for restoring purchases after reinstalling the application
        DDLogInfo("(PurchaseService) checkPremiumExpired - validateReceipt")
        let wasActive = self.isInAppPurchaseActive()
        validateReceipt { [weak self] _ in
            guard let self = self else { return }

            if wasActive && !self.isInAppPurchaseActive() {
                self.postNotification(PurchaseAssistant.kPSNotificationPremiumExpired)
            }
            else if !wasActive && self.isInAppPurchaseActive() {
                self.postNotification(PurchaseAssistant.kPSNotificationSilentRestoreSuccess)
            }
        }

        if loginService.loggedIn && loginService.hasPremiumLicense {
            DDLogInfo("(PurchaseService) checkPremiumExpired - сheck adguard license status")

            checkStatusInternal { [weak self] error in
                if error != nil || !(self?.loginService.active ?? false) {
                    if !(self?.loginService.hasPremiumLicense ?? true) {
                        self?.postNotification(PurchaseAssistant.kPSNotificationPremiumExpired)
                    }
                }
            }
        }
    }

    func generateAuthURL(state: String, socialProvider: SocialProvider) -> URL? {
        let params =
            [AUTH_RESPONSE_TYPE_PARAM : "token",
            AUTH_CLIENT_ID_PARAM : "adguard-ios",
            AUTH_SCOPE_PARAM : "trust",
            AUTH_REDIRECT_URI_PARAM : "adguard://auth",
            AUTH_STATE_PARAM : state,
            AUTH_SOCIAL_PROVIDER : socialProvider.rawValue,
            AUTH_REG_MODE: "NEVER"]

        guard let urlString = params.constructLink(url: authUrl) else { return nil }
        guard let url = URL(string: urlString) else { return nil }
        return url
    }

    func getInAppPurchaseReceiptBase64() -> String? {
        guard let receiptUrlStr = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: receiptUrlStr.path),
              let data = try? Data(contentsOf: receiptUrlStr) else { return nil }

        return data.base64EncodedString()
    }

    // MARK: - private methods
    // MARK: storekit
    private func setObserver() {
        SKPaymentQueue.default().add(self)
    }

    private func requestProducts() {
        productRequest = SKProductsRequest(productIdentifiers: allProducts)
        productRequest?.delegate = self
        productRequest?.start()
        if reachability?.isReachable() ?? false{
            startProductRequest()
        } else if notificationToken == nil {
            notificationToken = NotificationCenter.default.observe(name: .reachabilityChanged, object: nil, queue: nil) {[weak self] (notification) in
                guard let sSelf = self else { return }
                guard let reach = notification.object as? Reachability else { return }
                if reach.isReachable() {
                    sSelf.startProductRequest()
                    sSelf.reachability?.stopNotifier()
                    sSelf.notificationToken = nil
                }
            }
            reachability?.startNotifier()
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

        DDLogInfo("(PurchaseService) paymentQueue updatedTransactions")
        var restored = false
        var purchased = false

        for transaction in transactions {

            let error = transaction.error as NSError?

            if let error = error {
                DDLogError("(PurchaseService) payment Queue error \(error.localizedDescription)")
            }

            if !allProducts.contains(transaction.payment.productIdentifier) {
                SKPaymentQueue.default().finishTransaction(transaction)
                continue
            }

            switch transaction.transactionState {
            case .purchasing, .deferred:
                DDLogInfo("(PurchaseService) Transaction deffered or purchasing for product: \(transaction.payment.productIdentifier)")
                break

            case .failed:
                DDLogInfo("(PurchaseService) Transaction failed for product: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                if error?.code == SKError.paymentCancelled.rawValue {
                    postNotification(PurchaseAssistant.kPSNotificationCanceled, nil)
                    break
                }
                postNotification(PurchaseAssistant.kPSNotificationPurchaseFailure, transaction.error)

            case .purchased:
                DDLogInfo("(PurchaseService) Transaction purchased for product: \(transaction.payment.productIdentifier)")
                purchased = true
                SKPaymentQueue.default().finishTransaction(transaction)

            case .restored:
                DDLogInfo("(PurchaseService) Transaction restored for product: \(transaction.payment.productIdentifier)")
                restored = true
                SKPaymentQueue.default().finishTransaction(transaction)

            default:
                break
            }
        }

        if purchased || restored {
            validateReceipt { [weak self](error) in
                guard let sSelf = self else { return }

                if error == nil && sSelf.purchasedThroughInApp {
                    let result = purchased ? PurchaseAssistant.kPSNotificationPurchaseSuccess : PurchaseAssistant.kPSNotificationRestorePurchaseSuccess

                    sSelf.postNotification(result)
                }

                if error == nil && !sSelf.purchasedThroughInApp {
                    sSelf.postNotification(PurchaseAssistant.kPSNotificationRestorePurchaseNothingToRestore)
                }
            }
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        DDLogInfo("(PurchaseService)productsRequest didReceive products count: \(response.products.count) ")
        _atomicProductsToPurchase.mutate { $0.removeAll() }

        for product in response.products {

            switch product.productIdentifier {
            case annualSubscriptionProductID, monthlySubscriptionProductID:
                _atomicProductsToPurchase.mutate { $0.append(product) }
            case lifetimeProductID:
                // chose what product use for lifetime license.
                if !isDiscountCurrencyLocale(locale: product.priceLocale.identifier) {
                    _atomicProductsToPurchase.mutate { $0.append(product) }
                }
            case lifetimeAlternateProductID:
                if isDiscountCurrencyLocale(locale: product.priceLocale.identifier) {
                    _atomicProductsToPurchase.mutate { $0.append(product) }
                }
            case migrationProductID:
                _atomicFreeLifeTimeSubscription.mutate { $0 = product }
            default:
                DDLogError("(PurchaseService) productsRequest didReceive error. Unknown productId \(product.productIdentifier)")
                assertionFailure("Unknown productId \(product.productIdentifier)")
            }
        }

        if productsToPurchase.count > 0 {
            postNotification(PurchaseAssistant.kPSNotificationReadyToPurchase)
            productRequest = nil
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DDLogError("(PurchaseServie) request did fail with error: \(error.localizedDescription)")
        productRequest = nil
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {

        DDLogInfo("(PurchaseServie) restore completed")
        for transaction in queue.transactions {
            if allProducts.contains(transaction.payment.productIdentifier)  {
                return
            }
        }

        // nothing to restore
        postNotification(PurchaseAssistant.kPSNotificationRestorePurchaseNothingToRestore)
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {

        DDLogError("(PurchaseServie) restore failed with error: \(error.localizedDescription)")
        let nsError = error as NSError
        if nsError.code == SKError.paymentCancelled.rawValue {
            postNotification(PurchaseAssistant.kPSNotificationCanceled, nil)
            return
        }
        postNotification(PurchaseAssistant.kPSNotificationRestorePurchaseFailure, error)
    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }

    // MARK: helper methods

    @discardableResult private func processLoginResult(_ error: Error?)->Bool {

        DDLogInfo("(PurchaseService) processLoginResult")
        if error != nil {

            DDLogError("(PurchaseService) processLoginResult error \(error!.localizedDescription)")
            postNotification(PurchaseAssistant.kPSNotificationLoginFailure, error)
            return false
        }

        // check state
        if !loginService.hasPremiumLicense {
            postNotification(PurchaseAssistant.kPSNotificationLoginNotPremiumAccount)
            return false
        }

        let userInfo = [PurchaseAssistant.kPSNotificationTypeKey: PurchaseAssistant.kPSNotificationLoginSuccess,
                        PurchaseAssistant.kPSNotificationLoginPremiumExpired: !loginService.active] as [String : Any]

        NotificationCenter.default.post(name: Notification.Name(PurchaseAssistant.kPurchaseServiceNotification), object: self, userInfo: userInfo)
        return true
    }

    private func isInAppPurchaseActive()->Bool {

        // check subscription
        if let expirationDate = resources.sharedDefaults().object(forKey: AEDefaultsRenewableSubscriptionExpirationDate) as? Date {
            if expirationDate > Date() {
                return true
            }
        }

        // check non-consumable purchase
        if let purchased = resources.sharedDefaults().object(forKey: AEDefaultsNonConsumableItemPurchased) as? Bool {
            return purchased
        }

        return false
    }

    private func processValidateResponse(json: [String: Any])->Bool {

        guard let products = json[PRODUCTS_PARAM] as? [[String: Any]] else { return false }

        for product in products {
            let status = product[PREMIUM_STATUS_PARAM] as? String
            let expirationDate = product[EXPIRATION_DATE_PARAM] as? Double
            guard let productId = product[PRODUCT_ID_PARAM] as? String else { continue }

            if status == PREMIUM_STATUS_ACTIVE {

                switch productId {
                case annualSubscriptionProductID, monthlySubscriptionProductID:
                    if expirationDate == nil { continue }

                    if (expirationDate! / 1000) > Date().timeIntervalSince1970 {

                        let date = Date(timeIntervalSince1970: expirationDate! / 1000)
                        resources.sharedDefaults().set(date, forKey: AEDefaultsRenewableSubscriptionExpirationDate)
                    }

                    // FIXME check this part when backend is ready
                case lifetimeProductID, lifetimeAlternateProductID, migrationProductID:
                    resources.sharedDefaults().set(true, forKey: AEDefaultsNonConsumableItemPurchased)

                default:
                    DDLogInfo("(PurchaseService) processValidateResponse - error. Unknown product ID: \(productId)")
                    // It is not an error. There we can recieve old product identifiers

                    if expirationDate == nil {
                        resources.sharedDefaults().set(true, forKey: AEDefaultsNonConsumableItemPurchased)
                        continue
                    }

                    if (expirationDate! / 1000) > Date().timeIntervalSince1970 {

                        let date = Date(timeIntervalSince1970: expirationDate! / 1000)
                        resources.sharedDefaults().set(date, forKey: AEDefaultsRenewableSubscriptionExpirationDate)
                    }
                }
            }
        }

        return true
    }

    private func postNotification(_ type: String,_ error: Any? = nil) {
        var userInfo = [PurchaseAssistant.kPSNotificationTypeKey: type] as [String: Any]
        if(error != nil) {
            userInfo[PurchaseAssistant.kPSNotificationErrorKey] = error!
        }

        NotificationCenter.default.post(name: Notification.Name(PurchaseAssistant.kPurchaseServiceNotification), object: self, userInfo: userInfo)
    }

    private func priceOfProduct(_ product: SKProduct)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale

        return formatter.string(from: product.price) ?? ""
    }

    func periodOfProduct(_ product: SKProduct)->Period {
        return getPeriod(product.subscriptionPeriod)
    }

    func trialPeriodOfProduct(_ product: SKProduct)->Period {
        return getPeriod(product.introductoryPrice?.subscriptionPeriod)
    }

    private func getPeriod(_ period: SKProductSubscriptionPeriod?)-> Period {

        guard let periodUnit = period?.unit else { return standardPeriod }
        var returnPeriodUnit: PurchasePeriod = .day

        switch periodUnit {
        case .day:
            returnPeriodUnit = .day
        case .week:
            returnPeriodUnit = .week
        case .month:
            returnPeriodUnit = .month
        case .year:
            returnPeriodUnit = .year
        @unknown default:
            DDLogError("(PurchaseService) getPeriod - unknown period")
            returnPeriodUnit = .day
        }

        guard let numberOfUnits = period?.numberOfUnits else { return standardPeriod }

        return (unit: returnPeriodUnit, numberOfUnits: numberOfUnits)
    }

    private func requestPurchase(product: SKProduct?) {
        if product == nil {
            postNotification(PurchaseAssistant.kPSNotificationPurchaseFailure)
        }
        else  {
            let payment = SKMutablePayment(product: product!)
            payment.quantity = 1
            SKPaymentQueue.default().add(payment)
        }
    }

    private func isDiscountCurrencyLocale(locale: String)->Bool {
        return locale.contains("_RU") || locale.contains("_UA")
    }

    private func checkStatusInternal(completion: @escaping (_ error: Error?) -> Void) {
        appleSearchAdsService?.provideAttributionRecords { [weak self] attributionRecords in
            self?.loginService.checkStatus(attributionRecords: attributionRecords) { (error) in
                completion(error)
            }
        }
    }

    func updateSetappState(subscription: SetappSubscription) {
        DDLogInfo("(PurchaseService) - updateSetappState; sub is active = \(subscription.isActive); saved state = \(resources.purchasedThroughSetapp)")

        if (subscription.isActive && !resources.purchasedThroughSetapp) ||
            !subscription.isActive && resources.purchasedThroughSetapp {
            resources.purchasedThroughSetapp = subscription.isActive
            postNotification(PurchaseAssistant.kPSNotificationPremiumStatusChanged)
        }
    }
}
