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

protocol KeychainServiceProtocol {
    
    var appId: String? { get }
    func loadAuth(server: String)->(login: String, password: String)?
    func saveAuth(server: String, login: String, password: String) -> Bool
    func deleteAuth(server: String) ->Bool
    func saveLicenseKey(server: String, key: String) -> Bool
    func loadLicenseKey(server: String) -> String?
    func deleteLicenseKey(server: String) -> Bool
}

class KeychainService : KeychainServiceProtocol {
    
    let appIdService = "deviceInfo"
    let appIdKey = "AppId"
    let licenseKeyLogin = "license"
    
    var appId: String? {
        get {
            var storedId = getStoredAppId()
            if storedId == nil {
                storedId = generateAppId()
                if !save(appId: storedId!) {
                    return nil
                }
            }
            
            return storedId
        }
    }
    
    func loadAuth(server: String) -> (login: String, password: String)? {
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        server as Any,
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
        
        guard   let email = resultDict[kSecAttrAccount as String] as? String,
            let passData = resultDict[kSecValueData as String] else {
                return nil
        }
        
        if email.isEqual(licenseKeyLogin) {
            return nil
        }
        
        guard let password = String(data: passData as! Data, encoding: .utf8) else {
            return nil
        }
        
        return (email, password)
    }
    
    func saveAuth(server: String, login: String, password: String) -> Bool {
        
        _ = deleteAuth(server: server)
        
        guard let passData = password.data(using: String.Encoding.utf8) else {
            return false
        }
        
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        server as Any,
                     kSecAttrAccount as String:       login,
                     kSecValueData as String:         passData]
        
        var result: CFTypeRef?
        let status = SecItemAdd(query as CFDictionary, &result)
        
        return status == errSecSuccess
    }
    
    func deleteAuth(server: String) -> Bool {
        
        // read login(s) from keychain
        
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        server as Any,
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
                               kSecAttrServer as String:        server as Any,
                               kSecAttrAccount as String:       email as! String]
            
            let status = SecItemDelete(deleteQuery as CFDictionary)
            if status != errSecSuccess {return false}
        }
        
        return true
    }
    
    func saveLicenseKey(server: String, key: String) -> Bool {
        
        _ = deleteLicenseKey(server: server)
        
        guard let keyData = key.data(using: String.Encoding.utf8) else {
            return false
        }
        
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        server as Any,
                     kSecAttrAccount as String:       licenseKeyLogin,
                     kSecValueData as String:         keyData]
        
        var result: CFTypeRef?
        let status = SecItemAdd(query as CFDictionary, &result)
        
        return status == errSecSuccess
    }
    
    func loadLicenseKey(server: String) -> String? {
        
        let query = [kSecClass as String:             kSecClassInternetPassword,
                     kSecAttrServer as String:        server as Any,
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
        
        guard let keyData = resultDict[kSecValueData as String] else {
                return nil
        }
        
        let key = String(data: keyData as! Data, encoding: .utf8)
        return key
    }
    
    func deleteLicenseKey(server: String) -> Bool {
        
        let deleteQuery = [kSecClass as String:             kSecClassInternetPassword,
                           kSecAttrServer as String:        server as Any,
                           kSecAttrAccount as String:       licenseKeyLogin]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status != errSecSuccess { return false }
        
        return true
    }
    
    // MARK: - private methods
    
    private func getStoredAppId()->String? {
        let query = [kSecClass as String:             kSecClassGenericPassword,
                     kSecAttrService as String:        appIdService as Any,
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
        
        guard   let key = resultDict[kSecAttrAccount as String] as? String,
                let value = resultDict[kSecValueData as String] else {
                return nil
        }
        
        guard let valueString = String(data: value as! Data, encoding: .utf8) else {
            return nil
        }
        
        if key != appIdKey {
            return nil
        }
        
        return valueString
    }
    
    private func generateAppId()->String {
        return UUID().uuidString
    }
    
    private func save(appId: String)->Bool {
        
        guard let appIdData = appId.data(using: String.Encoding.utf8) else {
            return false
        }
        
        let query = [kSecClass as String:             kSecClassGenericPassword,
                     kSecAttrService as String:       appIdService as Any,
                     kSecAttrAccount as String:       appIdKey as Any,
                     kSecValueData as String:         appIdData]
        
        var result: CFTypeRef?
        let status = SecItemAdd(query as CFDictionary, &result)
        
        return status == errSecSuccess
    }
    
    internal func deleteAppId()-> Bool {
        
        // read login(s) from keychain
        
        let query = [kSecClass as String:             kSecClassGenericPassword,
                     kSecAttrService as String:        appIdService as Any,
                     kSecMatchLimit as String:        kSecMatchLimitAll,
                     kSecReturnAttributes as String:  true,
                     kSecReturnData as String:        true]
        
        var attributes: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &attributes)
        if(status != errSecSuccess) { return false }
        
        guard let accounts = attributes as? [[String: Any]] else { return false }
        
        for _ in accounts {
            
            let deleteQuery = [kSecClass as String:             kSecClassGenericPassword,
                               kSecAttrService as String:        appIdService as Any,
                               kSecAttrAccount as String:       appIdKey]
            
            let status = SecItemDelete(deleteQuery as CFDictionary)
            if status != errSecSuccess {return false}
        }
        
        return true
    }
}
