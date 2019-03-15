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
    var ready: Bool {get}
    var price: String {get}
    
    func start()
    func login(withName name: String, password: String, onSuccess success: ((Bool)->Void )?)
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
}

// MARK: - service implementation -
class PurchaseService: NSObject, PurchaseServiceProtocol, SKPaymentTransactionObserver, SKProductsRequestDelegate{
    
    // MARK: constants -
    // store kit constants
    private let kGetProProductID = "com.adguard.AdguardExtension.GetProFeature4"
    
    // keychain constants
    private let LOGIN_SERVER = "http://testmobile.adtidy.org"
    
    private let LOGIN_URL = "http://testmobile.adtidy.org/api/2.0/auth"
    private let LOGIN_EMAIL_PARAM = "email"
    private let LOGIN_PASSWORD_PARAM = "password"
    
    // login response params
    
    // keys
    private let LOGIN_AUTH_STATUS_KEY = "authStatus"
    private let LOGIN_PREMIUM_STATUS_KEY = "premiumStatus"
    private let LOGIN_EXPIRATION_DATE_KEY = "expirationDate"
    
    // auth status values
    private let AUTH_SUCCESS = "success"
    private let AUTH_BAD_CREDINTIALS = "bad_credentials"
    
    // premium values
    private let PREMIUM_STATUS_ACTIVE = "active"
    private let PREMIUM_STATUS_EXPIRED = "expired"
    private let PREMIUM_STATUS_FREE = "free"
    
    // MARK: - private properties
    private let network: ACNNetworkingProtocol
    private let resources: AESharedResourcesProtocol
    private var productRequest: SKProductsRequest?
    private var product: SKProduct?
    private var refreshRequest: SKReceiptRefreshRequest?
    
    private var purchsedThroughLogin: Bool?
    
    private var expired: Bool = false
    
    private var purchasedThroughInApp: Bool {
        get {
            return resources.sharedDefaults().bool(forKey: AEDefaultsIsProPurchasedThroughInApp)
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsIsProPurchasedThroughInApp)
        }
    }
    
    private var purchasedThroughLogin: Bool {
        get {
            return resources.sharedDefaults().bool(forKey: AEDefaultsIsProPurchasedThroughLogin)
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsIsProPurchasedThroughLogin)
        }
    }
    
    var isProPurchased: Bool {
        return isProPurchasedInternal
    }
    
    // MARK: - public properties
    @objc dynamic var isProPurchasedInternal: Bool {
        get {
            return purchasedThroughInApp || (purchasedThroughLogin && !expired);
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
    
    // MARK: - public methods
    init(network: ACNNetworkingProtocol, resources: AESharedResourcesProtocol) {
        self.network = network
        self.resources = resources
        super.init()
    }
    
    func start() {
        setObserver()
        requestProduct()
        checkPremiumExpired()
    }
    
    func login(withName name: String, password: String, onSuccess success:((Bool)->Void)?) {
        
        let params = [LOGIN_EMAIL_PARAM: name, LOGIN_PASSWORD_PARAM: password]
        let url = URL(string: LOGIN_URL)
        let request: URLRequest = ABECRequest.post(for: url, parameters: params)
        
        network.data(with: request) { [weak self] (dataOrNil, response, error) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                strongSelf.processLoginError(error: error)
                return
            }
            
            guard let data = dataOrNil  else{
                strongSelf.processLoginError(error: nil)
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                let loginSuccess = strongSelf.processLoginResponse(json: jsonResponse)
                
                if !loginSuccess {
                    success?(false)
                    return
                }
                
                if(!strongSelf.saveToKeychain(login: name, password: password)){
                    success?(false)
                    return
                }
                
                strongSelf.purchsedThroughLogin = true;
                let expired = strongSelf.checkExpired()
                
                strongSelf.postNotification(PurchaseService.kPSNotificationPremiumStatusChanged)
                
                success?(!expired)
            }
            catch {
                self?.processLoginError(error: error)
                success?(false)
            }
        }
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
        
        for transaction in transactions {
            if(transaction.payment.productIdentifier != kGetProProductID) { continue }
            
            switch transaction.transactionState {
            case .purchasing, .deferred:
                break
                
            case .failed:
                postNotification(PurchaseService.kPSNotificationPurchaseFailure, transaction.error)
                
            case .purchased, .restored:
                
                purchasedThroughInApp = true
                
                let result = transaction.transactionState == .purchased ? PurchaseService.kPSNotificationPurchaseSuccess : PurchaseService.kPSNotificationRestorePurchaseSuccess
                
                postNotification(result)
                
                postNotification(PurchaseService.kPSNotificationPremiumStatusChanged)
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            default:
                break
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
    
    // MARK: - keychain access
    internal func loadAuthFromKeychain()->(login: String, password: String)? {
        
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        LOGIN_SERVER as Any,
                     kSecMatchLimit as String:        kSecMatchLimitOne,
                     kSecReturnAttributes as String:  true,
                     kSecReturnData as String:        true]
        
        var attributes: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &attributes)
        
        if status != errSecSuccess {
            return nil
        }
        
        guard let resultDict = attributes as! [String: Any]?  else {
            return nil
        }
        
        guard   let email = resultDict[kSecAttrAccount as String],
                let passData = resultDict[kSecValueData as String] else {
            return nil
        }
        
        guard let password = String(data: passData as! Data, encoding: .utf8) else {
            return nil
        }
        
        return (email as! String, password)
    }
    
    internal func saveToKeychain(login: String, password: String) -> Bool {
        
        _ = deleteLoginFromKeychain()
        
        guard let passData = password.data(using: String.Encoding.utf8) else {
            return false
        }
        
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        LOGIN_SERVER as Any,
                     kSecAttrAccount as String:       login,
                     kSecValueData as String:         passData]
        
        var result: CFTypeRef?
        let status = SecItemAdd(query as CFDictionary, &result)
        
        return status == errSecSuccess
    }
    
    internal func deleteLoginFromKeychain() ->Bool {
        
        // read login(s) from keychain
        
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        LOGIN_SERVER as Any,
                     kSecMatchLimit as String:        kSecMatchLimitAll,
                     kSecReturnAttributes as String:  true,
                     kSecReturnData as String:        true]
        
        var attributes: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &attributes)
        if(status != errSecSuccess) { return false }
        
        guard let logins = attributes as? [[String: Any]] else { return false }
        
        for login in logins {
            let email = login[kSecAttrAccount as String]
            
            let deleteQuery = [kSecClass as String:             kSecClassInternetPassword,
                               kSecAttrServer as String:        LOGIN_SERVER as Any,
                               kSecAttrAccount as String:       email as! String]
            
            let status = SecItemDelete(deleteQuery as CFDictionary)
            if status != errSecSuccess {return false}
        }
        
        return true
    }
        
    // MARK: helper methods
    private func checkPremiumExpired() {
        if(isPremiumExpired()) {
            
            tryToRelogin {[weak self] (success) in
                self?.expired = !success
                if(!success) {
                    self?.notifyPremiumExpired()
                }
            }
        }
        else {
            self.expired = false;
        }
    }
    
    private func isPremiumExpired()->Bool {
        if let expirationDate = resources.sharedDefaults().object(forKey: AEDefaultsPremiumExpirationDate) as? Date {
            return expirationDate > Date()
        }
        return false
    }
    
    private func tryToRelogin(onSuccess success: @escaping (_ success: Bool)->Void){
        
        if let (email, password) = loadAuthFromKeychain() {
            login(withName: email, password: password, onSuccess: success)
        }
        else {
            success(false)
        }
    }
    
    private func processLoginError(error errorOrNil: Error?) {
        
        postNotification(PurchaseService.kPSNotificationLoginFailure, errorOrNil)
    }
    
    private func processLoginResponse(json: [String: Any]) -> Bool {
        
        guard let status = json[LOGIN_AUTH_STATUS_KEY] as? String else {
            processLoginError(error: nil)
            return false
        }
        
        let premium = json[LOGIN_PREMIUM_STATUS_KEY] as? String?
        let expirationTimestampAny = json[LOGIN_EXPIRATION_DATE_KEY]
        
        var expirationTimestamp: Double?
        
        switch expirationTimestampAny {
        case let strValue as String:
            expirationTimestamp = Double(strValue)
        case let doubleValue as Double:
            expirationTimestamp = doubleValue
        default:
            break
        }
        
        if status == AUTH_BAD_CREDINTIALS {
            let error = NSError(domain: PurchaseService.AEPurchaseErrorDomain, code: PurchaseService.AEPurchaseErrorAuthFailed, userInfo: nil)
            processLoginError(error: error)
            return false
        }
        
        
        // process premium
        if premium != PREMIUM_STATUS_ACTIVE && premium != PREMIUM_STATUS_EXPIRED {
            let userInfo = [PurchaseService.kPSNotificationTypeKey: PurchaseService.kPSNotificationLoginNotPremiumAccount]
            NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification),
                                            object: self, userInfo: userInfo)
            return false
        }
        
        // save expiration date in user defaults
        let expirationDate = Date(timeIntervalSince1970: expirationTimestamp ?? 0 / 1000)
        resources.sharedDefaults().set(expirationDate, forKey: AEDefaultsPremiumExpirationDate)
        
        return true
    }
    
    private func checkExpired() -> Bool{
        
        let expired = isPremiumExpired();
        
        let userInfo = [PurchaseService.kPSNotificationTypeKey: PurchaseService.kPSNotificationLoginSuccess,
                        PurchaseService.kPSNotificationLoginPremiumExpired: expired] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)
        
        return !expired;
    }
    
    private func notifyPremiumExpired() {
        if(purchasedThroughInApp) {
            return;
        }
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
