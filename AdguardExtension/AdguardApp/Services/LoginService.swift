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
    
    func checkStatus( callback: @escaping (Error?)->Void )
    func logout()->Bool
    
    func login(licenseKey: String, callback: @escaping  (_: Error?)->Void)
    func login(accessToken: String, callback: @escaping  (_: Error?)->Void)
//    func relogin(callback: @escaping (_ error: Error?)->Void)
    
    var activeChanged: (() -> Void)? { get set }
}

class LoginService: LoginServiceProtocol {
    
    var activeChanged: (() -> Void)? {
        didSet {
            setExpirationTimer()
        }
    }
    
    var loginResponseParser: LoginResponseParserProtocol = LoginResponseParser()
    
    // errors
    static let loginErrorDomain = "loginErrorDomain"
    
    static let loginError = -1
    static let loginBadCredentials = -2
    
    // keychain constants
    private let LOGIN_SERVER = "https://mobile-api.adguard.com"
    
    
    // login request
    private let LOGIN_URL = "https://mobile-api.adguard.com/api/2.0/auth"
    private let STATUS_URL = "https://mobile-api.adguard.com/api/1.0/status.html"
    private let AUTH_TOKEN_URL = "https://mobile-api.adguard.com/api/2.0/auth_token"
    private let LOGIN_EMAIL_PARAM = "email"
    private let LOGIN_PASSWORD_PARAM = "password"
    private let LOGIN_APP_NAME_PARAM = "app_name"
    private let LOGIN_APP_ID_PARAM = "app_id"
    private let LOGIN_LICENSE_KEY_PARAM = "license_key"
    private let LOGIN_ACCESS_TOKEN_PARAM = "access_token"
    private let LOGIN_APP_VERSION_PARAM = "app_version"
    
    private let LOGIN_APP_NAME_VALUE = "adguard_ios_pro"
    
    private var defaults: UserDefaults
    private var network: ACNNetworkingProtocol
    private var keychain: KeychainServiceProtocol
    
    private var timer: Timer?
    
    var expirationDate: Date? {
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
            let oldValue = defaults.bool(forKey: AEDefaultsIsProPurchasedThroughLogin)
            defaults.set(newValue, forKey: AEDefaultsIsProPurchasedThroughLogin)
            
            if newValue != oldValue {
                if let callback = activeChanged {
                    callback()
                }
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
    
    func login(licenseKey: String, callback: @escaping (Error?) -> Void) {
        requestStatus(licenseKey: licenseKey, callback: callback)
    }
    
    func login(accessToken: String, callback: @escaping  (_: Error?)->Void) {
        loginInternal(name: nil, password: nil, accessToken: accessToken, callback: callback)
    }
    
    private func loginInternal(name: String?, password: String?, accessToken: String?, callback: @escaping (Error?) -> Void) {
        
        let loginByToken = accessToken != nil
        
        var params = [LOGIN_APP_NAME_PARAM: LOGIN_APP_NAME_VALUE,
                      LOGIN_APP_ID_PARAM: keychain.appId ?? ""]
        
        if !loginByToken {
            params[LOGIN_EMAIL_PARAM] = name
            params[LOGIN_PASSWORD_PARAM] = password
        }
        
        guard let url = URL(string: loginByToken ? AUTH_TOKEN_URL : LOGIN_URL) else  {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(PurchaseService) login error. Can not make URL from String \(LOGIN_URL)")
            return
        }
        
        var headers: [String : String] = [:]
        
        if loginByToken {
            headers["Authorization"] = "Bearer \(accessToken!)"
        }
        
        let request: URLRequest = ABECRequest.post(for: url, parameters: params, headers: headers)
        
        network.data(with: request) { [weak self] (dataOrNil, responce, error) in
            guard let sSelf = self else { return }
            
            guard error == nil else {
                callback(error!)
                return
            }
            
            guard let data = dataOrNil  else{
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                return
            }
            
            let (loggedIn, _, _, licenseKey, error) = sSelf.loginResponseParser.processLoginResponse(data: data)
            
            if error != nil {
                callback(error!)
                return
            }
            
            sSelf.loggedIn = loggedIn
            
            sSelf.requestStatus(licenseKey: licenseKey, callback: callback)
        }
    }
    
    func checkStatus(callback: @escaping (Error?) -> Void) {
        requestStatus(licenseKey: nil, callback: callback)
    }
    
    private func requestStatus(licenseKey: String?, callback: @escaping (Error?)->Void ) {
        
        var params = [LOGIN_APP_NAME_PARAM: LOGIN_APP_NAME_VALUE,
                      LOGIN_APP_ID_PARAM: keychain.appId ?? "",
                      LOGIN_APP_VERSION_PARAM:ADProductInfo.version()!,
                      "key": "KPQ8695OH49KFCWC9EMX95OH49KFF50S" // legacy backend restriction
                      ]
        if licenseKey != nil {
            params[LOGIN_LICENSE_KEY_PARAM] = licenseKey
        }
        
        guard let url = URL(string: STATUS_URL) else  {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(PurchaseService) checkStatus error. Can not make URL from String \(STATUS_URL)")
            return
        }
        
        let request: URLRequest = ABECRequest.post(for: url, parameters: params, headers: nil)
        
        network.data(with: request) { [weak self] (dataOrNil, responce, error) in
            guard let sSelf = self else { return }
            
            guard error == nil else {
                callback(error!)
                return
            }
            
            guard let data = dataOrNil  else{
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                return
            }
            
            let (premium, expirationDate, error) = sSelf.loginResponseParser.processStatusResponse(data: data)
            
            if error != nil {
                callback(error!)
                return
            }
            
            // migrate from 3.0.0 ---------------------
            
            let oldAuth = sSelf.keychain.loadAuth(server: sSelf.LOGIN_SERVER)
            let oldLicenseKey = sSelf.keychain.loadLicenseKey(server: sSelf.LOGIN_SERVER)
            
            if !premium && oldAuth != nil || oldLicenseKey != nil {
                
                // delete saved in 3.0.0 logins
                _ = sSelf.keychain.deleteAuth(server: sSelf.LOGIN_SERVER)
                _ = sSelf.keychain.deleteLicenseKey(server: sSelf.LOGIN_SERVER)
                
                self?.loginInternal(name: oldAuth?.login, password: oldAuth?.password, accessToken: oldLicenseKey) {(error) in
                    if error != nil {
                        // rollback
                        if oldAuth != nil {
                            _ = sSelf.keychain.saveAuth(server: sSelf.LOGIN_SERVER, login: oldAuth!.login, password: oldAuth!.password)
                        }
                        else if oldLicenseKey != nil {
                            _ = sSelf.keychain.saveLicenseKey(server: sSelf.LOGIN_SERVER, key: oldLicenseKey!)
                        }
                    }
                    
                    callback(error)
                }
                
                return
            }
            
            // -----------------------------------------
            
            sSelf.expirationDate = expirationDate
            sSelf.hasPremiumLicense = premium
            sSelf.loggedIn = premium && sSelf.active
            
            callback(nil)
        }
    }
    
    func logout()->Bool {
        
        loggedIn = false
        expirationDate = nil
        
        return true
    }
    
    // MARK: - private methods
    
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
