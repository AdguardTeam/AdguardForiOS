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


extension MigrationService {
    
    func migrateFilterRulesIfNeeded(antibanner: AESAntibannerProtocol, storage: FiltersStorageProtocol) {
        
        let activeFilterIds = antibanner.activeFilterIDs()
        for filterId in activeFilterIds {
            let rules = antibanner.activeRules(forFilter: filterId)
            
            // already converted or empty filter
            if rules.count == 0 { continue }
            
            let ruleTexts = rules.map { (rule) -> String in
                // add affinity comments to rule
                let rule = rule as ASDFilterRule
                let affinity = rule.affinity == nil ? nil : Affinity(rawValue: rule.affinity!.uint8Value)
                return AffinityRulesParser.ruleWithAffinity(rule.ruleText, affinity: affinity)
            }
            
            let text = ruleTexts.joined(separator: "/n")
            
            if let error = storage.saveFilter(identifier: filterId.intValue, content: text) {
                DDLogError("migrateFilterRulesIfNeeded - save filter error: \(error)")
                continue
            }
            
            // remove rules from database
            antibanner.removeRules(forFilter: filterId)
        }
    }
}
