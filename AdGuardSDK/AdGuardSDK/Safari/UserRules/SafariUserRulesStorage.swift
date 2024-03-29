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

import SharedAdGuardSDK
import OrderedCollections

final public class SafariUserRulesStorage: UserRulesStorageProtocol {

    public var rules: OrderedSet<UserRule> {
        get {
            if self.userRules != nil {
                return self.userRules!
            }

            if let savedRulesData = userDefaults.storage.data(forKey: type.key) {
                let decoder = JSONDecoder()
                let rules = try? decoder.decode(OrderedSet<UserRule>.self, from: savedRulesData)
                self.userRules = rules ?? OrderedSet<UserRule>([])
            } else {
                self.userRules = []
            }

            return self.userRules!
        }
        set {
            let encoder = JSONEncoder()
            if let rulesData = try? encoder.encode(newValue) {
                userDefaults.storage.set(rulesData, forKey: type.key)
            } else {
                userDefaults.storage.set(Data(), forKey: type.key)
            }
            self.userRules = nil
        }
    }

    private let userDefaults: UserDefaultsStorageProtocol
    private let type: UserRuleType
    private var userRules: OrderedSet<UserRule>?

    public init(userDefaults: UserDefaultsStorageProtocol, rulesType: UserRuleType) {
        self.userDefaults = userDefaults
        self.type = rulesType
    }

    public init(userDefaults: UserDefaults, rulesType: UserRuleType) {
        self.userDefaults = UserDefaultsStorage(storage: userDefaults)
        self.type = rulesType
    }
}

fileprivate extension UserRuleType {
    var key: String {
        switch self {
        case .allowlist: return "AdGuardSDK.allowlistRulesKey"
        case .invertedAllowlist: return "AdGuardSDK.invertedAllowlistRulesKey"
        case .blocklist: return "AdGuardSDK.blocklistRulesKey"
        case .dnsAllowlist: return "AdGuardSDK.dnsAllowlistRulesKey"
        case .dnsBlocklist: return "AdGuardSDK.dnsBlocklistRulesKey"
        }
    }
}
