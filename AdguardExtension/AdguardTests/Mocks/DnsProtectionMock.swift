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
import DnsAdGuardSDK

class DnsProtectionMock: DnsProtectionProtocol {
    var proStatus: Bool = false

    var dnsProtectionEnabled: Bool = false

    var blocklistIsEnabled: Bool = false

    var allowlistIsEnabled: Bool = false

    var updateProStatusCalledCount = 0
    func update(proStatus: Bool) {
        updateProStatusCalledCount += 1
    }

    var updateDnsProtectionEnabledCalledCount = 0
    func update(dnsProtectionEnabled: Bool) {
        updateDnsProtectionEnabledCalledCount += 1
    }

    var updateBlocklistEnabledStateCalledCount = 0
    func update(blocklistIsEnabled: Bool) {
        updateBlocklistEnabledStateCalledCount += 1
    }

    var updateAllowlistEnabledStateCalledCount = 0
    func update(allowlistIsEnabled: Bool) {
        updateAllowlistEnabledStateCalledCount += 1
    }

    var updateConfigCalledCount = 0
    func updateConfig(with newConfig: DnsConfigurationProtocol) {
        updateConfigCalledCount += 1
    }

    var filters: [DnsFilter] = []

    var dnsLibsFilters: [Int : String] = [:]

    var setFilterError: Error?
    var setFilterCalledCount = 0
    func setFilter(withId id: Int, to enabled: Bool) throws {
        setFilterCalledCount += 1
        if let error = setFilterError {
            throw error
        }
    }

    var renameFilterError: Error?
    var renameFilterCalledCount = 0
    func renameFilter(withId id: Int, to name: String) throws {
        renameFilterCalledCount += 1
        if let error = renameFilterError{
            throw error
        }
    }

    var addFilterResult: Error?
    var addFilterCalledCount = 0
    func addFilter(withName name: String, url: URL, isEnabled: Bool, onFilterAdded: @escaping (Error?) -> Void) {
        addFilterCalledCount += 1
        if let error = addFilterResult {
            onFilterAdded(error)
        } else {
            filters.append(DnsFilter(filterId: addFilterCalledCount, subscriptionUrl: url, isEnabled: isEnabled, name: name, description: nil, version: nil, lastUpdateDate: nil, updateFrequency: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0))
            onFilterAdded(nil)
        }
    }

    var removeFilterError: Error?
    var removeFilterCalledCount = 0
    func removeFilter(withId id: Int) throws {
        removeFilterCalledCount += 1
        filters.removeAll(where: { $0.filterId == id })
        if let error = removeFilterError {
            throw error
        }
    }

    var updateFilterResult: Error?
    var updateFilterCalledCount = 0
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        updateFilterCalledCount += 1
        onFilterUpdated(updateFilterResult)
    }

    var updateAllFiltersResult = DnsFiltersUpdateResult(updatedFiltersIds: [], unupdatedFiltersIds: [])
    var updateAllFiltersCalledCount = 0
    func updateAllFilters(onFilterUpdated: @escaping (DnsFiltersUpdateResult) -> Void) {
        updateAllFiltersCalledCount += 1
        onFilterUpdated(updateAllFiltersResult)
    }

    var rulesStringResult = "rulesStringResult"
    var rulesStringCalledCount = 0
    func rulesString(for type: DnsUserRuleType) -> String {
        rulesStringCalledCount += 1
        return rulesStringResult
    }

    var allRulesResult = [UserRule]()
    var allRulesCalledCount = 0
    func allRules(for type: DnsUserRuleType) -> [UserRule] {
        allRulesCalledCount += 1
        return allRulesResult
    }

    var addRuleError: Error?
    var addRuleCalledCount = 0
    func add(rule: UserRule, override: Bool, for type: DnsUserRuleType) throws {
        addRuleCalledCount += 1
        if let error = addRuleError {
            throw error
        }
    }

    var addRulesError: Error?
    var addRulesCalledCount = 0
    func add(rules: [UserRule], override: Bool, for type: DnsUserRuleType) throws {
        addRulesCalledCount += 1
        if let error = addRulesError {
            throw error
        }
    }

    var setRulesCalledCount = 0
    func set(rules: [String], for type: DnsUserRuleType) {
        setRulesCalledCount += 1
    }

    var modifyRuleError: Error?
    var modifyRuleCalledCount = 0
    func modifyRule(_ oldRuleText: String, _ newRule: UserRule, for type: DnsUserRuleType) throws {
        modifyRuleCalledCount += 1
        if let error = modifyRuleError {
            throw error
        }
    }

    var turnRulesCalledCount = 0
    func turnRules(_ rules: [String], on: Bool, for type: DnsUserRuleType) {
        turnRulesCalledCount += 1
    }

    var removeRuleError: Error?
    var removeRuleCalledCount = 0
    func removeRule(withText ruleText: String, for type: DnsUserRuleType) throws {
        removeRuleCalledCount += 1
        if let error = removeRuleError {
            throw error
        }
    }

    var removeRulesCalledCount = 0
    func removeRules(_ rules: [String], for type: DnsUserRuleType) {
        removeRuleCalledCount += 1
    }

    var removeAllRulesCalledCount = 0
    func removeAllRules(for type: DnsUserRuleType) {
        removeAllRulesCalledCount += 1
    }

    var checkEnabledRuleExistsResult = false
    var checkEnabledRuleExistsCalledCount = 0
    func checkEnabledRuleExists(_ rule: String, for type: DnsUserRuleType) -> Bool {
        checkEnabledRuleExistsCalledCount += 1
        return checkEnabledRuleExistsResult
    }

    var updateFiltersInBackgroundResult: Error?
    var updateFiltersInBackgroundCalledCount = 0
    func updateFiltersInBackground(onFiltersUpdate: @escaping (Error?) -> Void) {
        updateFiltersInBackgroundCalledCount += 1
        onFiltersUpdate(updateFiltersInBackgroundResult)
    }

    var resetError: Error?
    var resetCalledCount = 0
    func reset() throws {
        resetCalledCount += 1
        if let error = resetError {
            throw error
        }
    }
}
