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

class AntibannerMock: NSObject, AESAntibannerProtocol {
    
    var enabled = true
    var updatesRightNow = false
    
    var rules = [NSNumber: [ASDFilterRule]]()
    
    var metadata = ABECFilterClientMetadata()
    var storedGroups = [ASDFilterGroup]()
    var storedFilters = [ASDFilterMetadata]()
    
    func start() {
    }
    
    func setDatabase(_ db: ASDatabase) {
        
    }
    
    func stop() {
        
    }
    
    func rules(forFilter filterId: NSNumber) -> [ASDFilterRule] {
        return rules[filterId] ?? [ASDFilterRule]()
    }
    
    func metadata(forSubscribe refresh: Bool) -> ABECFilterClientMetadata? {
        return metadata
    }
    
    
    func activeRules() -> NSMutableArray {
        return []
    }
    
    func activeRules(forFilter filterId: NSNumber) -> [ASDFilterRule] {
        return rules[filterId] ?? [ASDFilterRule]()
    }
    
    func groups() -> [ASDFilterGroup] {
        return storedGroups
    }
    
    func groupsI18n() -> ASDGroupsI18n {
        return ASDGroupsI18n()
    }
    
    func checkIfFilterInstalled(_ filterId: NSNumber) -> Bool {
        return true
    }
    
    func filters() -> [ASDFilterMetadata] {
        return storedFilters
    }
    
    func activeFilters() -> [ASDFilterMetadata] {
        return storedFilters
    }
    
    func filters(forGroup groupId: NSNumber) -> [ASDFilterMetadata] {
        return []
    }
    
    func enabledFilterIDs() -> [NSNumber] {
        return []
    }
    
    func activeFilterIDs() -> [NSNumber] {
        return []
    }
    
    func activeGroupIDs() -> [NSNumber] {
        return [1 as NSNumber]
    }
    
    func activeFilterIDs(byGroupID groupID: NSNumber) -> [NSNumber] {
        return groupID == 1 ? [ASDF_ENGLISH_FILTER_ID as NSNumber] : []
    }
    
    func filtersI18n() -> ASDFiltersI18n {
        return ASDFiltersI18n()
    }
    
    func setFilter(_ filterId: NSNumber, enabled: Bool, fromUI: Bool) {
    
    }
    
    func setFiltersGroup(_ groupId: NSNumber, enabled: Bool) {
        
    }
    
    func setRules(_ ruleIds: [Any], filter filterId: NSNumber, enabled: Bool) {
        
    }
    
    func add(_ rule: ASDFilterRule) -> Bool {
        return true
    }
    
    func update(_ rule: ASDFilterRule) -> Bool {
        return true
    }
    
    func `import`(_ rules: [ASDFilterRule], filterId: NSNumber) -> Bool {
        self.rules[filterId] = rules
        return true
    }
    
    func removeRules(_ ruleIds: [Any], filterId: NSNumber) -> Bool {
        return true
    }
    
    func i18n(forSubscribe refresh: Bool) -> ABECFilterClientLocalization? {
        return ABECFilterClientLocalization()
    }
    
    func subscribeFilters(_ filters: [ASDFilterMetadata]) -> Bool {
        return true
    }
    
    func unsubscribeFilter(_ filterId: NSNumber) -> Bool {
        return true
    }
    
    func startUpdatingForced(_ forced: Bool, interactive: Bool) -> Bool {
        return true
    }
    
    func repairUpdateStateForBackground() {
        
    }
    
    func repairUpdateState(completionBlock block: (() -> Void)? = nil) {
        
    }
    
    func filtersLastUpdateTime() -> Date? {
        return nil
    }
    
    func inTransaction() -> Bool {
        return false
    }
    
    func beginTransaction() {
        
    }
    
    func endTransaction() {
        
    }
    
    func rollbackTransaction() {
        
    }
    
    func nextCustomFilterId() -> NSNumber {
        return 0
    }
    
    func subscribeCustomFilter(from parserResult: AASCustomFilterParserResult, completion completionBlock: (() -> Void)? = nil) {
        
    }
    
    func customFilterId(byUrl url: String) -> NSNumber? {
        return nil
    }
    
    func setDefaultEnabledGroups() -> Bool {
        return true
    }
    
    func rulesCount(forFilter filterId: NSNumber) -> Int32 {
        return Int32(rules.count)
    }
    
    func enableGroupsWithEnabledFilters() -> Bool {
        return true
    }
    
    func applicationWillEnterForeground() {
    }
    
    func renameCustomFilter(_ filterId: NSNumber, newName: String) {}
}
