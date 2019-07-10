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

protocol LoginServiceProtocol {
    
    var loggedIn: Bool { get }
    var hasPremiumLicense: Bool { get }
    // not expired
    var active: Bool { get }
    
    func login(name: String?, password: String, callback: @escaping  (_: Error?)->Void)
    func relogin(callback: @escaping (_ error: Error?)->Void)
    func logout()->Bool
    
    var activeChanged: (() -> Void)? { get set }
}

class LoginService: LoginServiceProtocol {
    
    var activeChanged: (() -> Void)? {
        didSet {
            setExpirationTimer()
        }
    }
    
    // errors
    static let loginErrorDomain = "loginErrorDomain"
    
    static let loginError = -1
    static let loginBadCredentials = -2
    
    // keychain constants
    private let LOGIN_SERVER = "https://mobile-api.adguard.com"
    
    
    // login request
    private let LOGIN_URL = "https://mobile-api.adguard.com/api/2.0/auth"
    private let LOGIN_EMAIL_PARAM = "email"
    private let LOGIN_PASSWORD_PARAM = "password"
    private let LOGIN_APP_NAME_PARAM = "app_name"
    private let LOGIN_APP_ID_PARAM = "app_id"
    private let LOGIN_LICENSE_KEY_PARAM = "license_key"
    
    private let LOGIN_APP_NAME_VALUE = "adguard_ios_pro"
    
    // login response params
    
    // params
    private let LOGIN_AUTH_STATUS_PARAM = "auth_status"
    private let LOGIN_PREMIUM_STATUS_PARAM = "premium_status"
    private let LOGIN_EXPIRATION_DATE_PARAM = "expiration_date"
    private let LICENSE_INFO_PARAM = "license_info"
    
    // licenses info params
    private let LICENSES_PARAM = "licenses"
    private let BEST_LICENSE_ID_PARAM = "license"
    
    // one license info params
    private let LICENSE_KEY_PARAM = "license_key"
    private let LICENSE_STATUS_PARAM = "license_status"
    private let LICENSE_TYPE_PARAM = "license_type"
    private let LICENSE_EXPIRATION_DATE_PARAM = "expiration_date"
    private let LICENSE_COMPUTERS_PARAM = "license_computers_count"
    private let LICENSE_MAX_COMPUTERS_PARAM = "license_max_computers_count"
    private let SUBSCRIPTION_PARAM = "subscription"
    
    // subscription params
    private let SUBSCRIPTION_STATUS_PARAM = "status"
    private let SUBSCRIPTION_NEXT_BILL_DATE_PARAM = "next_bill_date"
    
    // auth status values
    private let AUTH_SUCCESS = "SUCCESS"
    private let AUTH_BAD_CREDINTIALS = "BAD_CREDENTIALS"
    
    // premium values
    private let PREMIUM_STATUS_ACTIVE = "ACTIVE"
    private let PREMIUM_STATUS_FREE = "FREE"
    
    private var defaults: UserDefaults
    private var network: ACNNetworkingProtocol
    private var keychain: KeychainServiceProtocol
    
    private var timer: Timer?
    
    private var expirationDate: Date? {
        get {
            return defaults.object(forKey: AEDefaultsPremiumExpirationDate) as? Date
        }
        set {
            if newValue == nil {
                defaults.removeObject(forKey: AEDefaultsPremiumExpirationDate)
            }
            else {
                defaults.set(newValue, forKey: AEDefaultsPremiumExpirationDate)
                setExpirationTimer()
            }
        }
    }
    
    var hasPremiumLicense: Bool {
        get {
            return defaults.bool(forKey: AEDefaultsHasPremiumLicense)
        }
        set {
            defaults.set(newValue, forKey: AEDefaultsHasPremiumLicense)
        }
    }
    
    // MARK: - public methods
    
    init(defaults: UserDefaults, network: ACNNetworkingProtocol, keychain: KeychainServiceProtocol) {
        self.defaults = defaults
        self.network = network
        self.keychain = keychain
    }
    
    var loggedIn: Bool {
        get {
            return defaults.bool(forKey: AEDefaultsIsProPurchasedThroughLogin)
        }
        set {
            defaults.set(newValue, forKey: AEDefaultsIsProPurchasedThroughLogin)
            
            if let callback = activeChanged {
                callback()
            }
        }
    }
    
    var active: Bool {
        get {
            if expirationDate == nil {
                return false
            }
            return expirationDate! > Date()
        }
    }
    
    func login(name: String?, password: String, callback: @escaping (Error?) -> Void) {
        if name != nil && name!.count > 0 {
            loginInternal(name: name!, password: password, callback: callback)
        }
        else {
            useLicenseKey(password, callback: callback)
        }
    }
    
    private func loginInternal(name: String, password: String, callback: @escaping (Error?) -> Void) {
        
        let params = [LOGIN_EMAIL_PARAM: name,
                      LOGIN_PASSWORD_PARAM: password,
                      LOGIN_APP_NAME_PARAM: LOGIN_APP_NAME_VALUE,
                      LOGIN_APP_ID_PARAM: keychain.appId ?? ""]
        
        guard let url = URL(string: LOGIN_URL) else  {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(PurchaseService) login error. Can not make URL from String \(LOGIN_URL)")
            return
        }
        
        let request: URLRequest = ABECRequest.post(for: url, parameters: params)
        
        network.data(with: request) { [weak self] (dataOrNil, responce, error) in
            
            guard let sSelf = self else {
                return
            }
            
            guard error == nil else {
                callback(error!)
                return
            }
            
            guard let data = dataOrNil  else{
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                return
            }
            
            do {
                let jsonResponce = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                let (loggedIn, premium, expirationDate, error) = sSelf.processLoginResponce(json: jsonResponce)
                
                sSelf.expirationDate = expirationDate
                sSelf.hasPremiumLicense = premium
                sSelf.loggedIn = loggedIn
                
                if error != nil {
                    callback(error!)
                    return
                }
                
                if(!sSelf.keychain.saveAuth(server: sSelf.LOGIN_SERVER, login: name, password: password)){
                    callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                    return
                }
                
                callback(nil)
            }
            catch {
                let responseString = String(data: data, encoding: .utf8)
                DDLogError("(LoginService) login error. Wrong json: \(responseString ?? "")")
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            }
        }
    }
    
    private func useLicenseKey(_ key: String, callback: @escaping (Error?) -> Void) {
        let params = [LOGIN_LICENSE_KEY_PARAM: key,
                      LOGIN_APP_NAME_PARAM: LOGIN_APP_NAME_VALUE,
                      LOGIN_APP_ID_PARAM: keychain.appId ?? ""]
        
        guard let url = URL(string: LOGIN_URL) else  {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(PurchaseService) login error. Can not make URL from String \(LOGIN_URL)")
            return
        }
        
        let request: URLRequest = ABECRequest.post(for: url, parameters: params)
        
        network.data(with: request) { [weak self] (dataOrNil, responce, error) in
            
            guard let sSelf = self else {
                return
            }
            
            guard error == nil else {
                callback(error!)
                return
            }
            
            guard let data = dataOrNil  else{
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                return
            }
            
            do {
                let jsonResponce = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                
                let (loggedIn, premium, expirationDate, error) = sSelf.processLoginResponce(json: jsonResponce)
                
                sSelf.loggedIn = loggedIn
                sSelf.expirationDate = expirationDate
                sSelf.hasPremiumLicense = premium
                
                if error != nil {
                    callback(error!)
                    return
                }
                
                if !sSelf.keychain.saveLicenseKey(server: sSelf.LOGIN_SERVER, key: key ) {
                    callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                    return
                }
                
                callback(nil)
            }
            catch {
                let responseString = String(data: data, encoding: .utf8)
                DDLogError("(LoginService) login error. Wrong json: \(responseString ?? "")")
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            }
        }
    }
    
    func relogin(callback: @escaping (_ error: Error?)->Void){
        
        if let (email, password) = keychain.loadAuth(server: LOGIN_SERVER) {
            login(name: email, password: password, callback: callback)
        }
        else if let key = keychain.loadLiceseKey(server: LOGIN_SERVER) {
            useLicenseKey(key, callback: callback)
        }
        else {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
        }
    }
    
    func logout()->Bool {
        if !keychain.deleteAuth(server: LOGIN_SERVER) && !keychain.deleteLicenseKey(server: LOGIN_SERVER) {
            return false
        }
        
        loggedIn = false
        expirationDate = nil
        
        return true
    }
    

    // MARK: - private methods
    
    private func processLoginResponce(json: [String: Any]) -> (loggedIn: Bool, premium: Bool,expirationDate: Date?, Error?) {
        
        guard let status = json[LOGIN_AUTH_STATUS_PARAM] as? String else {
            let error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil)
            DDLogError("(LoginService) login error - json does not contain status param." )
            return (false, false, nil, error)
        }
        
        let premium = json[LOGIN_PREMIUM_STATUS_PARAM] as? String?
        let expirationTimestampAny = json[LOGIN_EXPIRATION_DATE_PARAM]
        
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
            
            DDLogInfo("(LoginService) login error - bad credintials" )
            let error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginBadCredentials, userInfo: nil)
            return (false, false, nil, error)
        }
        
        // process premium
        if premium != PREMIUM_STATUS_ACTIVE {
            return (true, false, nil, nil)
        }
        
        // save expiration date in user defaults
        let expirationDate = Date(timeIntervalSince1970: (expirationTimestamp ?? 0) / 1000)
        
        return (true, true, expirationDate, nil)
    }
    
    private func setExpirationTimer() {
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        guard let time = expirationDate else { return }
        if time < Date() { return }
        
        timer = Timer(fire: time, interval: 0, repeats: false) { [weak self] (timer) in
            guard let sSelf = self else { return }
            if let callback = sSelf.activeChanged {
                callback()
            }
            sSelf.timer = nil
        }
        
        RunLoop.main.add(timer!, forMode: .common)
    }
}
