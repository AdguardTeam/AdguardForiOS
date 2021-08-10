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

protocol DnsUserRulesManagersProviderProtocol: ResetableSyncProtocol {
    var blocklistRulesManager: UserRulesManagerProtocol { get }
    var allowlistRulesManager: UserRulesManagerProtocol { get }
}

final class DnsUserRulesManagersProvider: DnsUserRulesManagersProviderProtocol {
    private(set) lazy var blocklistRulesManager: UserRulesManagerProtocol = {
        let storage = DnsUserRulesStorage(type: .blocklist, fileStorage: fileStorage)
        return UserRulesManager(type: .dnsBlocklist, storage: storage)
    }()
    
    private(set) lazy var allowlistRulesManager: UserRulesManagerProtocol = {
        let storage = DnsUserRulesStorage(type: .allowlist, fileStorage: fileStorage)
        return UserRulesManager(type: .dnsAllowlist, storage: storage)
    }()
    
    private let fileStorage: FilterFilesStorageProtocol
    
    // fileStorage should be passed as new object with unique folder to avoid filters ids collisions
    init(fileStorage: FilterFilesStorageProtocol) {
        self.fileStorage = fileStorage
    }
    
    func reset() throws {
        Logger.logInfo("(UserRulesManagersProvider) - reset start")
        
        try blocklistRulesManager.reset()
        try allowlistRulesManager.reset()
        
        Logger.logInfo("(UserRulesManagersProvider) - reset; Successfully reset all user rules managers")
    }
}
