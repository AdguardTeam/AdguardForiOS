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

final class BlocklistRulesStorage: UserRulesStorageProtocol {
    
    var rules: [UserRuleProtocol] {
        get {
            return userDefaults.blocklistRules
        }
        set {
            userDefaults.blocklistRules = newValue
        }
    }
    
    private let userDefaults: UserDefaultsStorageProtocol
    
    init(userDefaults: UserDefaultsStorageProtocol) {
        self.userDefaults = userDefaults
    }
}

// MARK: - UserDefaultsStorageProtocol + blocklist rules storage

fileprivate extension UserDefaultsStorageProtocol {
    
    private var blocklistRulesKey: String { "AdGuardSDK.blocklistRulesKey" }
    
    var blocklistRules: [UserRuleProtocol] {
        get {
            if let savedRulesData = storage.data(forKey: blocklistRulesKey) {
                let decoder = JSONDecoder()
                let rules = try? decoder.decode([UserRule].self, from: savedRulesData)
                return rules ?? []
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let rulesData = try? encoder.encode(newValue as! [UserRule]) {
                storage.set(rulesData, forKey: blocklistRulesKey)
            } else {
                storage.set(Date(), forKey: blocklistRulesKey)
            }
        }
    }
}
