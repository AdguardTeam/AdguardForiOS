/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.
 
       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.
 
       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.
 
       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation
import StoreKit
import CommonCrypto
import Setapp

typealias Period = (unit: PurchasePeriod, numberOfUnits: Int)

enum PurchasePeriod {
    case day, week, month, year
}

enum ProductType {
    case subscription, lifetime
}

typealias Product = (type: ProductType, price: String, period: Period?, trialPeriod: Period?, productId: String)

// MARK:  service protocol -
/**
 PurchaseService is a service responsible for all purchases.
 The user can get professional status through renewable subscriptions(in-app purchases) or through an Adguard license.
 In-app purchases are carried out directly in this service.
 Work with Adguard Licenses is delegated to LoginController
 */

protocol PurchaseServiceProtocol {
    
    /* star service. It request SKProducts  */
    func start()
    
    /* request SKProducts. If SKProducts failed on start we must repeat this request  */
    func startProductRequest()
   
    /**
     returns true if user has valid renewable subscription or valid adguard license
     */
    var isProPurchased: Bool {get}
    
    /**
     returns true if user has been logged in through login
     */
    var purchasedThroughLogin: Bool {get}
    
    /**
     returns true if user has been logged in through Setapp
     */
    var purchasedThroughSetapp: Bool {get}
    
    /**
     returns true if premium expired. It works both for in-app purchases and for adguard licenses
     */
    func checkPremiumStatusChanged()
    
    /**
     returns standart product (currently it is Year subscribtion )
     */
    var standardProduct: Product? { get }
    
    /**
     return array of products
     */
    var products: [Product] { get }
    
    /*  login on backend server and check license information
        the results will be posted through notification center
     
        we can use adguard license in two ways
        1) login through oauth in safari and get access_token. Then we make auth_token request and get license key. Then bind this key to user device id(app_id) through status request with license key in params
        2) login directly with license key. In this case we immediately send status request with this license key
     */
    func login(withAccessToken token: String?, state: String?)
    func login(withLicenseKey key: String, completion: @escaping (Bool)->Void)
    
    /**
     Log with name and password
     */
    func login(name: String, password: String, code2fa: String?)
    
    /**
     checks the status of adguard license
     */
    func checkLicenseStatus()
    
    /**
     deletes all login information
     */
    func logout()->Bool
    
    /**
     requests an renewable or non-consumable subscription purchase
     */
    func requestPurchase(productId: String)
    
    /**
     requests restore in-app purchases
     */
    func requestRestore()
    
    /** resets all login data */
    func reset(completion: @escaping ()->Void )
    
    /** handle setapp subscription changes */
    func updateSetappState(subscription: SetappSubscription)
}

// MARK: - public constants -
extension PurchaseService {
    
    /// NSNotificationCenter notification name
    static let kPurchaseServiceNotification = "kPurchaseServiceNotification"
    
    /// notification user data keys
    static let kPSNotificationTypeKey = "kPSNotificationTypeKey"
    static let kPSNotificationErrorKey = "kPSNotificationErrorKey"
    static let kPSNotificationPremiumExpiredKey = "kPSNotificationPremiumExpiredKey"
    
    /// notification types
    static let kPSNotificationPurchaseSuccess = "kPSNotificationPurchaseSuccess"
    static let kPSNotificationPurchaseFailure = "kPSNotificationPurchaseFailure"
    static let kPSNotificationRestorePurchaseSuccess = "kPSNotificationRestorePurchaseSuccess"
    static let kPSNotificationRestorePurchaseFailure = "kPSNotificationRestorePurchaseFailure"
    static let kPSNotificationSilentRestoreSuccess = "kPSNotificationSilentRestoreSuccess"
    static let kPSNotificationRestorePurchaseNothingToRestore = "kPSNotificationRestorePurchaseNothingToRestore"
    static let kPSNotificationLoginSuccess = "kPSNotificationLoginSuccess"
    static let kPSNotificationLoginFailure = "kPSNotificationLoginFailure"
    static let kPSNotificationLoginPremiumExpired = "kPSNotificationLoginPremiumExpired"
    static let kPSNotificationLoginNotPremiumAccount = "kPSNotificationLoginNotPremiumAccount"
    static let kPSNotificationReadyToPurchase = "kPSNotificationReadyToPurchase"
    static let kPSNotificationPremiumExpired = "kPSNotificationPremiumExpired"
    
    /// Cancel button tapped notification
    static let kPSNotificationCanceled = "kPSNotificationCanceled"
    
    static let kPSNotificationPremiumStatusChanged = "kPSNotificationPremiumStatusChanged"
    
    static let kPSNotificationOauthSucceeded = "kPSNotificationOauthSucceeded"
    
    /// errors
    static let AEPurchaseErrorDomain = "AEPurchaseErrorDomain"
    
    static let AEPurchaseErrorAuthFailed = -1
    static let AEConfirmReceiptError = -2
}

// MARK: - service implementation -
class PurchaseService: NSObject, PurchaseServiceProtocol, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
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
    
    private lazy var allProducts: Set<String> = { [annualSubscriptionProductID, monthlySubscriptionProductID, lifetimeProductID, lifetimeAlternateProductID] }()
    
    // ios_validate_receipt request
    
    private let RECEIPT_DATA_PARAM = "receipt_data"
    private let APP_ID_PARAM = "app_id"
    private let APP_VERSION_PARAM = "app_version"
    private let APP_NAME_PARAM = "app_name"
    private let VALIDATE_RECEIPT_URL = "https://mobile-api.adguard.com/api/1.0/ios_validate_receipt"
    
    // premium values
    private let PREMIUM_STATUS_ACTIVE = "ACTIVE"
    private let PREMIUM_STATUS_FREE = "FREE"
    
    // validate receipt params
    
    private let PRODUCTS_PARAM = "products"
    private let PRODUCT_ID_PARAM = "product_id"
    private let PREMIUM_STATUS_PARAM = "premium_status"
    private let EXPIRATION_DATE_PARAM = "expiration_date"
    
    private let authUrl = "https://auth.adguard.com/oauth/authorize"
    
    // MARK: - private properties
    private let network: ACNNetworkingProtocol
    private let resources: AESharedResourcesProtocol
    private let keychain: KeychainServiceProtocol
    private let productInfo: ADProductInfoProtocol

    private var productRequest: SKProductsRequest?
    private var productsToPurchase = [SKProduct]()
    private var nonConsumableProduct: SKProduct?
    private var refreshRequest: SKReceiptRefreshRequest?

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
        return isProPurchasedInternal
    }
    
    var purchasedThroughLogin: Bool {
        get {
            return loginService.loggedIn
        }
    }
    
    var purchasedThroughSetapp: Bool {
        return resources.purchasedThroughSetapp
    }
    
    @objc dynamic var isProPurchasedInternal: Bool {
        get {
            return purchasedThroughInApp || resources.purchasedThroughSetapp || loginService.hasActiveLicense;
        }
    }
    
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
    
    func reset(completion: @escaping () -> Void) {
        loginService.reset(completion: completion)
    }

    // MARK: - public methods
    init(network: ACNNetworkingProtocol, resources: AESharedResourcesProtocol, productInfo: ADProductInfoProtocol) {
        self.network = network
        self.resources = resources
        self.keychain = KeychainService(resources: resources)
        self.productInfo = productInfo
        loginService = LoginService(defaults: resources.sharedDefaults(), network: network, keychain: keychain, productInfo: productInfo)
        
        super.init()
        
        start()
        
        loginService.activeChanged = { [weak self] in
            self?.postNotification(PurchaseService.kPSNotificationPremiumStatusChanged)
        }
    }
    
    func start() {
        setObserver()
        requestProducts()
    }
    
    @objc
    func checkLicenseStatus() {
        loginService.checkStatus { [weak self] (error) in
            _ = self?.processLoginResult(error)
        }
    }   
    
    func login(withLicenseKey key: String, completion: @escaping (Bool)->Void) {
        loginService.login(licenseKey: key){ [weak self] (error) in
            let result = self?.processLoginResult(error) ?? false
            completion(result)
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
    
    @objc
    func login(withAccessToken token: String?, state: String?) {
        
        let expectedState = resources.sharedDefaults().string(forKey: AEDefaultsAuthStateString)
        
        if token == nil || state == nil || expectedState == nil || state! != expectedState! {
            DDLogError("(PurchaseService) login with access token failed " + (token == nil ? "token == nil" : "") + (state == nil ? "state == nil" : "") + (expectedState == nil ? "expectedState == nil" : "") + (state != expectedState ? "state != expectedState" : ""))
            postNotification(PurchaseService.kPSNotificationLoginFailure, nil)
            return
        }
        
        postNotification(PurchaseService.kPSNotificationOauthSucceeded, nil)
        
        loginService.login(accessToken: token!) { [weak self]  (error) in
            guard let sSelf = self else { return }
            
            sSelf.processLoginResult(error)
        }
    }
    
    func login(name: String, password: String, code2fa: String?) {
        loginService.login(name: name, password: password, code2fa: code2fa) { [weak self] (error) in
            self?.processLoginResult(error)
        }
    }
    
    func validateReceipt(onComplete complete:@escaping ((Error?)->Void)){
        
        // get receipt
        guard let receiptUrlStr = Bundle.main.appStoreReceiptURL else { return }
        if !FileManager.default.fileExists(atPath: receiptUrlStr.path) { return }
        guard let data = try? Data(contentsOf: receiptUrlStr) else {
            complete(NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEConfirmReceiptError, userInfo: nil))
            return
        }
        
        let base64Str = data.base64EncodedString()
        
        // post receipt to our backend
        
        guard let appId = keychain.appId else {
            DDLogError("(LoginService) loginInternal error - can not obtain appId)")
            complete(NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEConfirmReceiptError, userInfo: [:]))
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
        
        guard let url = URL(string: VALIDATE_RECEIPT_URL) else  {
            
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
                complete(NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEConfirmReceiptError, userInfo: nil))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                let validateSuccess = strongSelf.processValidateResponse(json: jsonResponse)
                
                if !validateSuccess {
                    complete(NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEConfirmReceiptError, userInfo: nil))
                    return
                }

                strongSelf.purchasedThroughInApp = strongSelf.isInAppPurchaseActive()

                strongSelf.postNotification(PurchaseService.kPSNotificationPremiumStatusChanged)
                complete(nil)
            }
            catch {
                complete(NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEConfirmReceiptError, userInfo: nil))
            }
        }
    }
    
    func logout()->Bool {
        return loginService.logout()
    }
    
    func requestRestore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @objc
    func checkPremiumStatusChanged() {
        
        DDLogInfo("(PurchaseService) checkPremiumExpired")
            
        // we must validate receipts not only to check the expiration of the subscription,
        // but also for restoring purchases after reinstalling the application
        DDLogInfo("(PurchaseService) checkPremiumExpired - validateReceipt")
        let wasActive = self.isInAppPurchaseActive()
        validateReceipt { [weak self] (error) in
            guard let sSelf = self else { return }
            if wasActive && !sSelf.isInAppPurchaseActive() {
                sSelf.postNotification(PurchaseService.kPSNotificationPremiumExpired)
            }
            else if !wasActive && sSelf.isInAppPurchaseActive() {
                sSelf.postNotification(PurchaseService.kPSNotificationSilentRestoreSuccess)
            }
        }
    
        if(loginService.loggedIn && loginService.hasPremiumLicense) {
            
            DDLogInfo("(PurchaseService) checkPremiumExpired - сheck adguard license status")
            loginService.checkStatus { [weak self] (error) in
                if error != nil || !(self?.loginService.active ?? false) {
                    if !(self?.loginService.hasPremiumLicense ?? true) {
                        self?.postNotification(PurchaseService.kPSNotificationPremiumExpired)
                    }
                }
            }
        }
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
                    postNotification(PurchaseService.kPSNotificationCanceled, nil)
                    break
                }
                postNotification(PurchaseService.kPSNotificationPurchaseFailure, transaction.error)
                
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
                    let result = purchased ? PurchaseService.kPSNotificationPurchaseSuccess : PurchaseService.kPSNotificationRestorePurchaseSuccess
                    
                    sSelf.postNotification(result)
                }
                
                if error == nil && !sSelf.purchasedThroughInApp {
                    sSelf.postNotification(PurchaseService.kPSNotificationRestorePurchaseNothingToRestore)
                }
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        DDLogInfo("(PurchaseService)productsRequest didReceive products count: \(response.products.count) ")
        productsToPurchase.removeAll()
        
        for product in response.products {
            
            switch product.productIdentifier {
            case annualSubscriptionProductID, monthlySubscriptionProductID:
                productsToPurchase.append(product)
            case lifetimeProductID:
                // chose what product use for lifetime license.
                if !isDiscountCurrencyLocale(locale: product.priceLocale.identifier) {
                    productsToPurchase.append(product)
                }
            case lifetimeAlternateProductID:
                if isDiscountCurrencyLocale(locale: product.priceLocale.identifier) {
                    productsToPurchase.append(product)
                }
            default:
                DDLogError("(PurchaseService) productsRequest didReceive error. Unknown productId \(product.productIdentifier)")
                assertionFailure("Unknown productId \(product.productIdentifier)")
            }
        }
        
        if productsToPurchase.count > 0 {
            postNotification(PurchaseService.kPSNotificationReadyToPurchase)
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
        postNotification(PurchaseService.kPSNotificationRestorePurchaseNothingToRestore)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        DDLogError("(PurchaseServie) restore failed with error: \(error.localizedDescription)")
        let nsError = error as NSError
        if nsError.code == SKError.paymentCancelled.rawValue {
            postNotification(PurchaseService.kPSNotificationCanceled, nil)
            return
        }
        postNotification(PurchaseService.kPSNotificationRestorePurchaseFailure, error)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
     
    // MARK: helper methods
    
    private func processLoginResult(_ error: Error?)->Bool {
        
        DDLogInfo("(PurchaseService) processLoginResult")
        if error != nil {
            
            DDLogError("(PurchaseService) processLoginResult error \(error!.localizedDescription)")
            postNotification(PurchaseService.kPSNotificationLoginFailure, error)
            return false
        }
        
        // check state
        if !loginService.hasPremiumLicense {
            postNotification(PurchaseService.kPSNotificationLoginNotPremiumAccount)
            return false
        }
        
        let userInfo = [PurchaseService.kPSNotificationTypeKey: PurchaseService.kPSNotificationLoginSuccess,
                        PurchaseService.kPSNotificationLoginPremiumExpired: !loginService.active] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)
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
                case lifetimeProductID, lifetimeAlternateProductID:
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
        var userInfo = [PurchaseService.kPSNotificationTypeKey: type] as [String: Any]
        if(error != nil) {
            userInfo[PurchaseService.kPSNotificationErrorKey] = error!
        }
        
        NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)
    }
    
    private func priceOfProduct(_ product: SKProduct)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? ""
    }
    
    func periodOfProduct(_ product: SKProduct)->Period {
        
        if #available(iOS 11.2, *) {
            return getPeriod(product.subscriptionPeriod)
        } else {
            return standardPeriod
        }
    }
    
    func trialPeriodOfProduct(_ product: SKProduct)->Period {
        
        if #available(iOS 11.2, *) {
            return getPeriod(product.introductoryPrice?.subscriptionPeriod)
        } else {
            return standardPeriod
        }
    }
    
    @available(iOS 11.2, *)
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
            postNotification(PurchaseService.kPSNotificationPurchaseFailure)
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
    
    func updateSetappState(subscription: SetappSubscription) {
        if (subscription.isActive && !resources.purchasedThroughSetapp) ||
            !subscription.isActive && resources.purchasedThroughSetapp {
            resources.purchasedThroughSetapp = subscription.isActive
            postNotification(PurchaseService.kPSNotificationPremiumStatusChanged)
        }
    }
}
