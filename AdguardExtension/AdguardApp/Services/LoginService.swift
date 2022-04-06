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
import UIKit.UIDevice

/**
 LoginService - this service is responsible for working with adguard logins and licenses
 */
protocol LoginServiceProtocol {

    var loggedIn: Bool { get }
    var hasPremiumLicense: Bool { get }
    // not expired
    var active: Bool { get }

    var hasActiveLicense: Bool { get }

    var licenseKey: String? { get }

    func checkStatus(attributionRecords: String?, callback: @escaping (Error?)->Void )
    func logout()->Bool

    /**
     login on backend server and check license information
     the results will be posted through notification center

     we can use adguard license in two ways
     1) login through oauth in safari and get access_token. Then we make auth_token request and get license key. Then bind this key to user device id(app_id) through status request with license key in params
     2) login directly with license key. In this case we immediately send status request with this license key
     */
    func login(accessToken: String, attributionRecords: String?, callback: @escaping  (_: NSError?)->Void)
    func login(licenseKey: String, attributionRecords: String?, callback: @escaping  (_: NSError?)->Void)

    func login(name:String, password: String, code2fa: String?, attributionRecords: String?, callback: @escaping  ( _: NSError?)->Void)

    var activeChanged: (() -> Void)? { get set }

    /* resets all login data */
    func reset(completion:@escaping ()->Void )
}

final class LoginService: LoginServiceProtocol {

    // MARK: - Internal variables

    var activeChanged: (() -> Void)? {
        didSet {
            setExpirationTimer()
        }
    }

    var loginResponseParser: LoginResponseParserProtocol = LoginResponseParser()

    var hasActiveLicense: Bool { resources.hasActiveLicense }

    var expirationDate: Date? {
        get {
            return resources.licenseExpirationDate
        }
        set {
            resources.licenseExpirationDate = newValue
            if newValue != nil {
                setExpirationTimer()
            }
        }
    }

    var hasPremiumLicense: Bool {
        get {
            return resources.userHasPremiumLicense
        }
        set {
            resources.userHasPremiumLicense = newValue
        }
    }

    var loggedIn: Bool {
        get {
            return resources.loggedIn
        }
        set {
            let oldValue = resources.loggedIn
            resources.loggedIn = newValue

            if newValue != oldValue, let callback = activeChanged {
                callback()
            }
        }
    }

    var active: Bool { resources.licenseIsActive }

    var licenseKey: String? { keychain.loadLicenseKey(server: LICENSE_KEY_SERVER) }

    // errors
    static let loginErrorDomain = "loginErrorDomain"

    static let loginError = -1
    static let loginBadCredentials = -2
    static let loginMaxComputersExceeded = -3
    static let auth2FaRequired = -4
    static let accountIsDisabled = -5
    static let outh2FAInvalid = -6
    static let emptyEmailOrPassword = -7
    static let invalidEmailOrPassword = -8
    static let toShortPassword = -9
    static let compromissedPassword = -10
    static let emailAllreadyUsed = -11
    static let accountIsLocked = -12
    static let socialUserNotFound = -13

    static let errorDescription = "error_description"

    static let APP_NAME_VALUE =  Bundle.main.isPro ? "adguard_ios_pro" : "adguard_ios"
    static let APP_TYPE_VALUE = Bundle.main.isPro ? "ADGUARD_FOR_IOS_PRO" : "ADGUARD_FOR_IOS"

    // MARK: - Private variables

    // keychain constants
    private let LICENSE_KEY_SERVER = "com.adguard.ios.adguard.licensekey"

    private let LOGIN_SERVER = "https://mobile-api.adguard.com"

    private let AUTH_SERVER = "https://auth.adguard.com"

    // login request
    lazy private var STATUS_URL = { "\(LOGIN_SERVER)/api/1.0/status.html" }()
    lazy private var AUTH_TOKEN_URL = { "\(LOGIN_SERVER)/api/2.0/auth_token" }()
    lazy private var RESET_LICENSE_URL = { "\(LOGIN_SERVER)/api/1.0/resetlicense.html" }()
    lazy private var OAUTH_TOKEN_URL = { "\(AUTH_SERVER)/oauth/token" } ()

    // - request fileds
    private let LOGIN_APP_NAME_PARAM = "app_name"
    private let LOGIN_APP_ID_PARAM = "app_id"
    private let LOGIN_LICENSE_KEY_PARAM = "license_key"
    private let LOGIN_ACCESS_TOKEN_PARAM = "access_token"
    private let LOGIN_APP_VERSION_PARAM = "app_version"
    private let STATUS_DEVICE_NAME_PARAM = "device_name"
    private let STATUS_ATTRIBUTION_RECORDS_PARAM = "iad_metadata" // Param for Apple Search Ads

    private let resources: AESharedResourcesProtocol
    private var network: ACNNetworkingProtocol
    private var keychain: KeychainServiceProtocol
    private var productInfo: ADProductInfoProtocol

    private var timer: Timer?

    // MARK: - Initialization

    init(resources: AESharedResourcesProtocol, network: ACNNetworkingProtocol, keychain: KeychainServiceProtocol, productInfo: ADProductInfoProtocol) {
        self.resources = resources
        self.network = network
        self.keychain = keychain
        self.productInfo = productInfo
    }

    // MARK: - Internal methods

    func login(licenseKey: String, attributionRecords: String?, callback: @escaping (NSError?) -> Void) {
        requestStatus(licenseKey: licenseKey, attributionRecords: attributionRecords, callback: callback)
    }

    func login(accessToken: String, attributionRecords: String?, callback: @escaping  (NSError?)->Void) {
        // we must reset license before login to unbind previously attached license key
        resetLicense { [weak self] (error) in
            if error != nil {
                callback(error)
            }
            else {
                self?.loginInternal(accessToken: accessToken, attributionRecords: attributionRecords, callback: callback)
            }
        }
    }

    func checkStatus(attributionRecords: String?, callback: @escaping (Error?) -> Void) {
        requestStatus(licenseKey: nil, attributionRecords: attributionRecords, callback: callback)
    }

    func logout()->Bool {

        loggedIn = false
        expirationDate = nil

        // for logged in 3.0.0 users
        _ = keychain.deleteAuth(server: LOGIN_SERVER)
        _ = keychain.deleteLicenseKey(server: LOGIN_SERVER)

        // In 4.3 version we store licence key for remote migration to new app
        _ = keychain.deleteLicenseKey(server: LICENSE_KEY_SERVER)

        resetLicense() { _ in }

        return true
    }

    func getOauthToken(username: String, password: String, twoFactorToken: String?, callback: @escaping (_ token: String?, _ error: NSError?)->Void) {
        DDLogInfo("(LoginService) getOauthToken ")

        var params = ["username" : username,
                      "password" : password,
                      "client_id" : "adguard-ios",
                      "grant_type" : "password_2fa",
                      "scope" : "trust",
        ]

        if twoFactorToken != nil {
            params["2fa_token"] = twoFactorToken!
        }

        guard let url = URL(string: OAUTH_TOKEN_URL) else  {
            callback(nil, NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(LoginService) getOauthToken error. Can not make URL from String \(OAUTH_TOKEN_URL)")
            return
        }

        let request: URLRequest = ABECRequest.post(for: url, parameters: params, headers: nil)

        network.data(with: request) { [weak self] (dataOrNil, response, error) in
            guard let sSelf = self else { return }
            guard error == nil else {
                DDLogError("(LoginService) getOauthToken - got error \(error!.localizedDescription)")
                callback(nil, error as NSError?)
                return
            }

            guard let data = dataOrNil else {
                DDLogError("(LoginService) getOauthToken - response data is nil")
                callback(nil, NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                return
            }

            DDLogInfo("(LoginService) getOauthToken get response")

            let result = sSelf.loginResponseParser.processOauthTokenResponse(data: data)

            callback(result.accessToken, result.error)
        }
    }

    func login(name: String, password: String, code2fa: String?, attributionRecords: String?, callback: @escaping (NSError?) -> Void) {

        self.getOauthToken(username: name, password: password, twoFactorToken: code2fa) { [weak self] (token, error) in

            if error == nil && token != nil {
                self?.login(accessToken: token!, attributionRecords: attributionRecords) { (error) in
                    if error == nil {
                        callback(nil)
                    }
                    else {
                        callback(error)
                    }
                }
            }
            else {
                if error != nil {
                    callback(error)
                }
            }
        }
    }

    func reset(completion:@escaping ()->Void ) {
        resetLicense { [weak self] (_) in
            self?.keychain.reset()

            completion()
        }
    }

    // MARK: - Private methods

    private func loginInternal(accessToken: String, attributionRecords: String?, callback: @escaping (NSError?) -> Void) {

        guard let appId = keychain.appId else {
            DDLogError("(LoginService) loginInternal error - can not obtain appId)")
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: [:]))
            return
        }

        DDLogInfo("(LoginService) - loginInternal. Login with access_token")

        let params = [LOGIN_APP_NAME_PARAM: LoginService.APP_NAME_VALUE,
                      LOGIN_APP_ID_PARAM: appId,
                      LOGIN_APP_VERSION_PARAM:productInfo.version()!]

        guard let url = URL(string: AUTH_TOKEN_URL) else  {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(LoginService) login error. Can not make URL from String \(AUTH_TOKEN_URL)")
            return
        }

        let headers = ["Authorization": "Bearer \(accessToken)"]

        let request: URLRequest = ABECRequest.post(for: url, parameters: params, headers: headers)

        network.data(with: request) { [weak self] (dataOrNil, response, error) in
            guard let sSelf = self else { return }

            guard error == nil else {
                DDLogError("(LoginService) loginInternal - got error \(error!.localizedDescription)")
                callback(error! as NSError)
                return
            }

            guard let data = dataOrNil  else{
                DDLogError("(LoginService) loginInternal - got empty response")
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                return
            }

            let (loggedIn, premium, expirationDate, licenseKey, error) = sSelf.loginResponseParser.processLoginResponse(data: data)

            DDLogInfo("(LoginService) loginInternal - processLoginResponse: loggedIn - \(loggedIn ? "true" : "false") premium = \(premium) expirationDate = " + (expirationDate == nil ? "nil" : expirationDate!.description))

            if error != nil {
                DDLogError("(LoginService) loginInternal - processLoginResponse error: \(error!.localizedDescription)")
                callback(error!)
                return
            }

            sSelf.requestStatus(licenseKey: licenseKey, attributionRecords: attributionRecords, callback: callback)
        }
    }

    private func requestStatus(licenseKey: String?, attributionRecords: String?, callback: @escaping (NSError?)->Void ) {

        DDLogInfo("(LoginService) requestStatus " + (licenseKey == nil ? "without license key" : "with license key"))

        guard let appId = keychain.appId else {
            DDLogError("(LoginService) loginInternal error - can not obtain appId)")
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: [:]))
            return
        }

        var params = [LOGIN_APP_NAME_PARAM: LoginService.APP_NAME_VALUE,
                      LOGIN_APP_ID_PARAM: appId,
                      LOGIN_APP_VERSION_PARAM:productInfo.version()!,
                      STATUS_DEVICE_NAME_PARAM: UIDevice.current.name,
                      "key": "KPQ8695OH49KFCWC9EMX95OH49KFF50S" // legacy backend restriction
                      ]
        if licenseKey != nil {
            params[LOGIN_LICENSE_KEY_PARAM] = licenseKey
        }

        if let attributionRecords = attributionRecords {
            DDLogInfo("(LoginService) - requestStatus; Attribution records added as parameter for request status")
            params[STATUS_ATTRIBUTION_RECORDS_PARAM] = attributionRecords
        }

        guard let url = URL(string: STATUS_URL) else  {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(LoginService) checkStatus error. Can not make URL from String \(STATUS_URL)")
            return
        }

        let request: URLRequest = ABECRequest.post(for: url, parameters: params, headers: nil)

        network.data(with: request) { [weak self] (dataOrNil, response, error) in
            guard let self = self else { return }

            guard error == nil else {
                DDLogError("(LoginService) checkStatus - got error \(error!.localizedDescription)")
                callback(error! as NSError)
                return
            }

            guard let data = dataOrNil  else {
                DDLogError("(LoginService) checkStatus - got empty response")
                callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
                return
            }

            let (premium, expirationDate, licenseKey, error) = self.loginResponseParser.processStatusResponse(data: data)

            DDLogInfo("(LoginService) checkStatus - processStatusResponse: premium = \(premium) " + (expirationDate == nil ? "" : "expirationDate = \(expirationDate!)"))


            if error != nil {
                DDLogError("(LoginService) checkStatus - processStatusResponse error: \(error!.localizedDescription)")
                callback(error!)
                return
            }

            self.expirationDate = expirationDate
            self.hasPremiumLicense = premium
            self.loggedIn = premium && self.active

            if let licenseKey = licenseKey {
                DDLogInfo("(LoginService) - on request status; License received, start saving it to keychain")
                let result = self.keychain.saveLicenseKey(server: self.LICENSE_KEY_SERVER, key: licenseKey)
                DDLogInfo("(LoginService) - on request status; License saving into keychain result=\(result)")
            } else {
                DDLogInfo("(LoginService) - on request status; License missed, start deleting old license key from keychain")
                let result = self.keychain.deleteLicenseKey(server: self.LICENSE_KEY_SERVER)
                DDLogInfo("(LoginService) - on request status; License deleting from keychain result=\(result)")
            }

            callback(nil)
        }
    }

    private func resetLicense(callback: @escaping (NSError?)->Void) {

        DDLogInfo("(LoginService) resetLicense")

        guard let appId = keychain.appId else {
            DDLogError("(LoginService) loginInternal error - can not obtain appId)")
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: [:]))
            return
        }

        let params = [LOGIN_APP_NAME_PARAM: LoginService.APP_NAME_VALUE,
                      LOGIN_APP_ID_PARAM: appId,
                      LOGIN_APP_VERSION_PARAM:productInfo.version()!,
                      "key": "KPQ8695OH49KFCWC9EMX95OH49KFF50S" // legacy backend restriction
        ]

        guard let url = URL(string: RESET_LICENSE_URL) else  {
            callback(NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil))
            DDLogError("(LoginService) checkStatus error. Can not make URL from String \(RESET_LICENSE_URL)")
            return
        }

        var request: URLRequest = ABECRequest.post(for: url, parameters: params, headers: nil)
        request.timeoutInterval = 10.0

        network.data(with: request) { (dataOrNil, response, error) in

            guard error == nil else {
                DDLogError("(LoginService) resetLicense - got error \(error!.localizedDescription)")
                callback(error! as NSError)
                return
            }

            DDLogInfo("(LoginService) resetLicense succeeded")

            callback(nil)
        }
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

            DDLogInfo("(LoginService) expiration timer fired")

            if let callback = sSelf.activeChanged {
                callback()
            }
            sSelf.timer = nil
        }

        RunLoop.main.add(timer!, forMode: .common)
    }
}
