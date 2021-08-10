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

final class DnsUserRulesStorage: UserRulesStorageProtocol {
    
    var rules: [UserRuleProtocol] {
        get {
            let allRules = getAllRules()
            let enabledRules = getEnabledRules()
            return allRules.map {
                let isEnabled = enabledRules.contains($0)
                return UserRule(ruleText: $0, isEnabled: isEnabled)
            }
        }
        set {
            var allRules: [String] = []
            var enabledRules: [String] = []
            newValue.forEach {
                allRules.append($0.ruleText)
                if $0.isEnabled {
                    enabledRules.append($0.ruleText)
                }
            }
            saveAllRules(allRules)
            saveEnabledRules(enabledRules)
        }
    }
    
    // MARK: - Private properties
        
    private let type: DnsUserRuleType
    private let fileStorage: FilterFilesStorageProtocol
    
    // fileStorage should be passed as new object with unique folder to avoid filters ids collisions
    init(type: DnsUserRuleType, fileStorage: FilterFilesStorageProtocol) {
        self.type = type
        self.fileStorage = fileStorage
    }
    
    // MARK: - Private methods
    
    private func getAllRules() -> [String] {
        guard let rules = fileStorage.getFilterContentForFilter(withId: type.allRulesFilterId) else {
            return []
        }
        return rules.components(separatedBy: .newlines)
    }
    
    private func saveAllRules(_ rules: [String]) {
        let rulesString = rules.joined(separator: "\n")
        do {
            try fileStorage.saveFilter(withId: type.allRulesFilterId, filterContent: rulesString)
        } catch {
            Logger.logError("(DnsUserRulesStorage) - saveAllRules; Error saving all rules; Error: \(error)")
        }
    }
    
    private func getEnabledRules() -> [String] {
        guard let rules = fileStorage.getFilterContentForFilter(withId: type.enabledRulesFilterId) else {
            return []
        }
        return rules.components(separatedBy: .newlines)
    }
    
    private func saveEnabledRules(_ rules: [String]) {
        let rulesString = rules.joined(separator: "\n")
        do {
            try fileStorage.saveFilter(withId: type.enabledRulesFilterId, filterContent: rulesString)
        } catch {
            Logger.logError("(DnsUserRulesStorage) - saveEnabledRules; Error saving enabled rules; Error: \(error)")
        }
    }
}

// MARK: - DnsUserRuleType + Filter ids

extension DnsUserRuleType {
    
    var enabledRulesFilterId: Int {
        switch self {
        case .allowlist: return 10001
        case .blocklist: return 10002
        }
    }
    
    fileprivate var allRulesFilterId: Int {
        switch self {
        case .allowlist: return 10003
        case .blocklist: return 10004
        }
    }
}
