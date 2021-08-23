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

protocol SafariUserRulesManagersProviderProtocol: ResetableSyncProtocol {
    var blocklistRulesManager: UserRulesManagerProtocol { get }
    var allowlistRulesManager: UserRulesManagerProtocol { get }
    var invertedAllowlistRulesManager: UserRulesManagerProtocol { get }
}

final class SafariUserRulesManagersProvider: SafariUserRulesManagersProviderProtocol {
    private(set) lazy var blocklistRulesManager: UserRulesManagerProtocol = {
        let storage = SafariUserRulesStorage(userDefaults: userDefaultsStorage, rulesType: .blocklist)
        return UserRulesManager(type: .blocklist, storage: storage)
    }()
    
    private(set) lazy var allowlistRulesManager: UserRulesManagerProtocol = {
        let storage = SafariUserRulesStorage(userDefaults: userDefaultsStorage, rulesType: .allowlist)
        return UserRulesManager(type: .allowlist, storage: storage)
    }()
    
    private(set) lazy var invertedAllowlistRulesManager: UserRulesManagerProtocol = {
        let storage = SafariUserRulesStorage(userDefaults: userDefaultsStorage, rulesType: .invertedAllowlist)
        return UserRulesManager(type: .invertedAllowlist, storage: storage)
    }()
    
    private let userDefaultsStorage: UserDefaultsStorageProtocol
    
    init(userDefaultsStorage: UserDefaultsStorageProtocol) {
        self.userDefaultsStorage = userDefaultsStorage
    }
    
    func reset() throws {
        Logger.logInfo("(UserRulesManagersProvider) - reset start")
        
        try blocklistRulesManager.reset()
        try allowlistRulesManager.reset()
        try invertedAllowlistRulesManager.reset()
        
        Logger.logInfo("(UserRulesManagersProvider) - reset; Successfully reset all user rules managers")
    }
}
