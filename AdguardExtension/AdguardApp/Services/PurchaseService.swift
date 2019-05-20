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

// MARK:  service protocol -
protocol PurchaseServiceProtocol {
    var isProPurchased: Bool {get}
    var purchasedThroughLogin: Bool {get}
    var ready: Bool {get}
    var price: String {get}
    var period: String {get}
    
    func start()
    
    /*  login on backend server and check licens information
        the results will be posted through notification center
     */
    func login(withName name: String?, password: String)
    func logout()->Bool
    func requestPurchase()
    func requestRestore()
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
    static let kPSNotificationRestorePurchaseNothingToRestore = "kPSNotificationRestorePurchaseNothingToRestore"
    static let kPSNotificationLoginSuccess = "kPSNotificationLoginSuccess"
    static let kPSNotificationLoginFailure = "kPSNotificationLoginFailure"
    static let kPSNotificationLoginPremiumExpired = "kPSNotificationLoginPremiumExpired"
    static let kPSNotificationLoginNotPremiumAccount = "kPSNotificationLoginNotPremiumAccount"
    static let kPSNotificationReadyToPurchase = "kPSNotificationReadyToPurchase"
    static let kPSNotificationPremiumExpired = "kPSNotificationPremiumExpired"
    
    static let kPSNotificationPremiumStatusChanged = "kPSNotificationPremiumStatusChanged"
    
    /// errors
    static let AEPurchaseErrorDomain = "AEPurchaseErrorDomain"
    
    static let AEPurchaseErrorAuthFailed = -1
    static let AEConfirmReceiptError = -2
}

// MARK: - service implementation -
class PurchaseService: NSObject, PurchaseServiceProtocol, SKPaymentTransactionObserver, SKProductsRequestDelegate{
    
    // MARK: constants -
    // store kit constants
    private let kGetProProductID = "com.adguard.AdguardExtension.GetProSubscriptionTest"
    
    
    // ios_validate_receipt request
    
    private let RECEIPT_DATA_PARAM = "receipt_data"
    private let VALIDATE_RECEIPT_URL = "https://mobile-api.adguard.com/api/1.0/ios_validate_receipt"
    
    // license status
    private let LICENSE_STATUS_NOT_EXISTS = "NOT_EXISTS"
    private let LICENSE_STATUS_EXPIRED = "EXPIRED"
    private let LICENSE_STATUS_MAX_COMPUTERS_EXCEED = "MAX_COMPUTERS_EXCEED"
    private let LICENSE_STATUS_BLOCKED = "BLOCKED"
    private let LICENSE_STATUS_VALID = "VALID"
    
    // subscription status
    private let SIBSCRIPTION_STATUS_ACTIVE = "ACTIVE"
    private let SIBSCRIPTION_STATUS_PAST_DUE = "PAST_DUE"
    private let SIBSCRIPTION_STATUS_DELETED = "DELETED"
    
    // premium values
    private let PREMIUM_STATUS_ACTIVE = "ACTIVE"
    private let PREMIUM_STATUS_FREE = "FREE"
    
    // validate receipt params
    
    private let PRODUCTS_PARAM = "products"
    private let PRODUCT_ID_PARAM = "product_id"
    private let PREMIUM_STATUS_PARAM = "premium_status"
    private let EXPIRATION_DATE_PARAM = "expiration_date"
    
    // MARK: - private properties
    private let network: ACNNetworkingProtocol
    private let resources: AESharedResourcesProtocol
    private var productRequest: SKProductsRequest?
    private var product: SKProduct?
    private var refreshRequest: SKReceiptRefreshRequest?

    private let loginService: LoginService
    
    private var purchasedThroughInApp: Bool {
        get {
            return resources.sharedDefaults().bool(forKey: AEDefaultsIsProPurchasedThroughInApp)
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsIsProPurchasedThroughInApp)
        }
    }
    
    // MARK: - public properties
    
    var isProPurchased: Bool {
        return isProPurchasedInternal
    }
    
    var purchasedThroughLogin: Bool {
        get {
            return loginService.loggedIn
        }
    }
    
    @objc dynamic var isProPurchasedInternal: Bool {
        get {
            return (purchasedThroughInApp) ||
                (loginService.loggedIn && loginService.hasPremiumLicense && loginService.active);
        }
    }
    
    var ready: Bool { return product != nil }
    var price: String {
        guard let product = self.product else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? ""
    }
    
    var period: String {
        guard let product = self.product else { return "" }
        
        
        if #available(iOS 11.2, *) {
            guard let periodUnit = product.subscriptionPeriod?.unit,
                let numberOfUnits = product.subscriptionPeriod?.numberOfUnits else { return "" }
            
            var unitString = ""
            switch periodUnit {
            case .day:
                unitString = ACLocalizedString("day_period", nil)
            case .week:
                unitString = ACLocalizedString("week_period", nil)
            case .month:
                unitString = ACLocalizedString("month_period", nil)
            case .year:
                unitString = ACLocalizedString("year_period", nil)
            }
            
            let format = ACLocalizedString("period_format", nil)
            
            return String(format: format, numberOfUnits, unitString)
        } else {
            return ""
        }
    }
    
    // MARK: - public methods
    init(network: ACNNetworkingProtocol, resources: AESharedResourcesProtocol) {
        self.network = network
        self.resources = resources
        loginService = LoginService(defaults: resources.sharedDefaults(), network: network, keychain: KeychainService())
        
        super.init()
        
        loginService.activeChanged = { [weak self] in
            self?.postNotification(PurchaseService.kPSNotificationPremiumStatusChanged)
        }
    }
    
    func start() {
        setObserver()
        requestProduct()
        checkPremiumExpired()
    }
    
    func login(withName name: String?, password: String) {
        
        loginService.login(name: name, password: password) { [weak self] (error) in
            guard let sSelf = self else { return }
            
            if error != nil {
                sSelf.postNotification(PurchaseService.kPSNotificationLoginFailure, error)
                return
            }
            
            // check state
            if !sSelf.loginService.hasPremiumLicense {
                sSelf.postNotification(PurchaseService.kPSNotificationLoginNotPremiumAccount)
                return
            }
            
            let userInfo = [PurchaseService.kPSNotificationTypeKey: PurchaseService.kPSNotificationLoginSuccess,
                            PurchaseService.kPSNotificationLoginPremiumExpired: !sSelf.loginService.active] as [String : Any]
            
            NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)
            
            return
        }
        
    }
    
    func validateReceipt(onComplete complete:@escaping ((Error?)->Void)){
        
        // get receipt
        guard let receiptUrlStr = Bundle.main.appStoreReceiptURL,
            let data = try? Data(contentsOf: receiptUrlStr)
        else {
            complete(NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEConfirmReceiptError, userInfo: nil))
            return
        }
        
        let base64Str = data.base64EncodedString()
        
        // post receipt to our backend
        
        let jsonToSend = "{\"\(RECEIPT_DATA_PARAM)\":\"\(base64Str)\"}"
        
        guard let url = URL(string: VALIDATE_RECEIPT_URL) else  {
            
            DDLogError("(PurchaseService) validateReceipt error. Can not make URL from String \(VALIDATE_RECEIPT_URL)")
            return
        }
        
        let request: URLRequest = ABECRequest.post(for: url, json: jsonToSend)
        
        network.data(with: request) { [weak self] (dataOrNil, responce, error) in
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
                let jsonResponce = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                let validateSuccess = strongSelf.processValidateResponce(json: jsonResponce)
                
                if !validateSuccess {
                    complete(NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEConfirmReceiptError, userInfo: nil))
                    return
                }

                strongSelf.purchasedThroughInApp = strongSelf.isRenewableSubscriptionActive()

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
    
    func requestPurchase() {
        if product == nil {
            postNotification(PurchaseService.kPSNotificationPurchaseFailure)
        }
        else  {
            let payment = SKMutablePayment(product: product!)
            payment.quantity = 1
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func requestRestore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getReceipt() -> String? {
        // Load the receipt from the app bundle.
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else { return nil }
        let encReceipt = receiptData.base64EncodedString()
        
        return encReceipt
    }
    
    // MARK: - private methods
    // MARK: storekit
    private func setObserver() {
        SKPaymentQueue.default().add(self)
    }
    
    private func requestProduct() {
        productRequest = SKProductsRequest(productIdentifiers: [kGetProProductID])
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        var restored = false
        var purchased = false
        
        for transaction in transactions {
            if(transaction.payment.productIdentifier != kGetProProductID) { continue }
            
            switch transaction.transactionState {
            case .purchasing, .deferred:
                break
                
            case .failed:
                postNotification(PurchaseService.kPSNotificationPurchaseFailure, transaction.error)
                
            case .purchased:
                purchased = true
                SKPaymentQueue.default().finishTransaction(transaction)
                    
            case .restored:
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
        product = response.products.first
        postNotification(PurchaseService.kPSNotificationReadyToPurchase)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        productRequest = nil
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        for transaction in queue.transactions {
            if transaction.payment.productIdentifier == kGetProProductID { return }
        }
        
        // nothing to restore
        postNotification(PurchaseService.kPSNotificationRestorePurchaseNothingToRestore)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        postNotification(PurchaseService.kPSNotificationRestorePurchaseFailure, error)
    }
    
     
    // MARK: helper methods
    private func checkPremiumExpired() {
        if(purchasedThroughInApp && !isRenewableSubscriptionActive()) {
            validateReceipt { [weak self] (error) in
                if self?.isRenewableSubscriptionActive() ?? false {
                    self?.notifyPremiumExpired()
                }
            }
        }
        
        if(loginService.loggedIn && loginService.hasPremiumLicense && !loginService.active) {
            
            loginService.relogin() { [weak self] (error) in
                if error != nil || !(self?.loginService.active ?? false) {
                    self?.notifyPremiumExpired()
                }
            }
        }
    }
    
    private func isRenewableSubscriptionActive()->Bool {
        
        if let expirationDate = resources.sharedDefaults().object(forKey: AEDefaultsRenewableSubscriptionExpirationDate) as? Date {
            return expirationDate > Date()
        }
        
        return false
    }
    
    private func processValidateResponce(json: [String: Any])->Bool {
        
        guard let products = json[PRODUCTS_PARAM] as? [[String: Any]] else { return false }
        
        for product in products {
            let status = product[PREMIUM_STATUS_PARAM] as? String
            guard let expirationDate = product[EXPIRATION_DATE_PARAM] as? Double else { continue }
            
            if status == PREMIUM_STATUS_ACTIVE {
                if (expirationDate / 1000) > Date().timeIntervalSince1970 {
                    
                    let date = Date(timeIntervalSince1970: expirationDate / 1000)
                    resources.sharedDefaults().set(date, forKey: AEDefaultsRenewableSubscriptionExpirationDate)
                    
                    break
                }
            }
        }
        
        return true
    }
    
    private func checkExpired() -> Bool{
        
        let expired = !loginService.active;
        
        let userInfo = [PurchaseService.kPSNotificationTypeKey: PurchaseService.kPSNotificationLoginSuccess,
                        PurchaseService.kPSNotificationLoginPremiumExpired: expired] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)
        
        return !expired;
    }
    
    private func notifyPremiumExpired() {
        
        postNotification(PurchaseService.kPSNotificationPremiumExpired)
    }
    
    private func postNotification(_ type: String,_ error: Any? = nil) {
        var userInfo = [PurchaseService.kPSNotificationTypeKey: type] as [String: Any]
        if(error != nil) {
            userInfo[PurchaseService.kPSNotificationErrorKey] = error!
        }
        
        NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)
    }
}
