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

protocol LoginResponseParserProtocol {
    func processLoginResponse(data: Data)->(loggedIn: Bool, premium: Bool,expirationDate: Date?, licenseKey: String?, Error?)
    
    func processStatusResponse(data: Data)->(premium: Bool,expirationDate: Date?, Error?)
}


class LoginResponseParser: LoginResponseParserProtocol {
    
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
    private let AUTH_MAX_COMPUTERS_EXCEED = "MAX_COMPUTERS_EXCEED"
    
    // premium values
    private let PREMIUM_STATUS_ACTIVE = "ACTIVE"
    private let PREMIUM_STATUS_FREE = "FREE"
    
    // status response params
    private let STATUS_RESPONSE_STATUS_PARAM = "status"
    private let STATUS_RESPONSE_KEY_STATUS_PARAM = "licenseKeyStatus"
    private let STATUS_RESPONSE_KEY_PARAM = "licenseKey"
    private let STATUS_RESPONSE_EXPIRATION_DATE_PARAM = "expirationDate"
    
    // status response status values
    private let STATUS_RESPONSE_STATUS_PREMIUM = "PREMIUM"
    private let STATUS_RESPONSE_STATUS_EXPIRED = "EXPIRED"
    private let STATUS_RESPONSE_STATUS_ERROR = "ERROR"
    
    func processLoginResponse(data: Data)->(loggedIn: Bool, premium: Bool,expirationDate: Date?, licenseKey: String?, Error?) {
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            
            return processLoginResponseJson(json: jsonResponse)
        }
        catch {
            let responseString = String(data: data, encoding: .utf8)
            DDLogError("(LoginResponseParser) error. Wrong json: \(responseString ?? "")")
            let error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil)
            return (false, false, nil, nil, error)
        }
    }
    
    func processStatusResponse(data: Data) -> (premium: Bool, expirationDate: Date?, Error?) {
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            
            return processStatusResponseJson(json: jsonResponse)
        }
        catch {
            let responseString = String(data: data, encoding: .utf8)
            DDLogError("(LoginResponseParser) error. Wrong json: \(responseString ?? "")")
            let error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil)
            return (false, nil, error)
        }
    }
    
    
    private func processLoginResponseJson(json: [String: Any]) -> (loggedIn: Bool, premium: Bool,expirationDate: Date?, licenseKey: String?, Error?) {
        
        guard let status = json[LOGIN_AUTH_STATUS_PARAM] as? String else {
            let error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil)
            DDLogError("(LoginService) login error - json does not contain status param." )
            return (false, false, nil, nil, error)
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
        
        var licenseKey: String?
        
        if let licenseInfo = json[LICENSE_INFO_PARAM] as? [String : Any] {
            licenseKey = licenseInfo[BEST_LICENSE_ID_PARAM] as? String
        }
        
        if status == AUTH_BAD_CREDINTIALS {
            
            DDLogInfo("(LoginService) login error - bad credintials" )
            let error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginBadCredentials, userInfo: nil)
            return (false, false, nil, nil, error)
        }
        
        // process premium
        if premium != PREMIUM_STATUS_ACTIVE {
            return (true, false, nil, licenseKey, nil)
        }
        
        // save expiration date in user defaults
        let expirationDate = Date(timeIntervalSince1970: (expirationTimestamp ?? 0) / 1000)
        
        return (true, true, expirationDate, licenseKey, nil)
    }
    
    
    private func processStatusResponseJson(json: [String: Any]) -> (premium: Bool,expirationDate: Date?, Error?) {
        
        guard let status = json[STATUS_RESPONSE_STATUS_PARAM] as? String else {
            DDLogInfo("(LoginService) processStatusResponseJson error - json does not contain status" )
            let error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginBadCredentials, userInfo: nil)
            return (false, nil, error)
        }
        
        if status == STATUS_RESPONSE_STATUS_ERROR {
            let licenseKeyStatus = (json["licenseKeyStatus"] as? String) ?? ""
            DDLogInfo("(LoginService) processStatusResponseJson error - status = ERROR licenseKeyStatus: \(licenseKeyStatus)")
            
            var error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginError, userInfo: nil)
            
            if licenseKeyStatus == AUTH_BAD_CREDINTIALS {
                error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginBadCredentials, userInfo: nil)
            }
            
            if licenseKeyStatus == AUTH_MAX_COMPUTERS_EXCEED {
                error = NSError(domain: LoginService.loginErrorDomain, code: LoginService.loginMaxComputersExceed, userInfo: nil)
            }
            return (false, nil, error)
        }
        
        let expirationTimestampAny = json[STATUS_RESPONSE_EXPIRATION_DATE_PARAM]
        
        var expirationTimestamp: Double?
        
        switch expirationTimestampAny {
        case let strValue as String:
            expirationTimestamp = Double(strValue)
        case let doubleValue as Double:
            expirationTimestamp = doubleValue
        default:
            break
        }
        
        let expirationDate = Date(timeIntervalSince1970: (expirationTimestamp ?? 0) / 1000)
        
        let premium = status == STATUS_RESPONSE_STATUS_PREMIUM
        
        return (premium, expirationDate, nil)
    }
}
