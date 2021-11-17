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

import SafariAdGuardSDK
import SharedAdGuardSDK

class SafariProtectionMock: SafariProtectionProtocol {

    var allContentBlockerJsonUrls: [URL] = []

    var rules: [UserRule] = []

    var proStatus: Bool = false

    var safariProtectionEnabled: Bool = false

    var advancedProtectionIsEnabled: Bool = false

    var blocklistIsEnabled: Bool = false

    var allowlistIsEnabled: Bool = false

    var allowlistIsInverted: Bool = false

    var advancedRulesCount: Int = 0

    var reloadingContentBlockers: [ContentBlockerType : Bool] = [:]

    var allContentBlockersStates: [ContentBlockerType : Bool] = [:]

    var allConverterResults: [ConverterResult] = []

    var filtersAreConverting: Bool = false

    var groups: [SafariGroup] = []

    var lastFiltersUpdateCheckDate: Date?

    var resetResult: Error?
    var resetCalledCount = 0
    func reset(withReloadCB: Bool, _ onResetFinished: @escaping (Error?) -> Void) {
        resetCalledCount += 1
        onResetFinished(resetResult)
    }

    var updateSafariProtectionInBackgroundResult = BackgroundFetchUpdateResult(backgroundFetchResult: .newData, newBackgroundFetchState: .loadAndSaveFilters, oldBackgroundFetchState: .updateFinished, error: nil)
    var updateSafariProtectionInBackgroundCalledCount = 0
    func updateSafariProtectionInBackground(_ onStateExecutionFinished: @escaping (BackgroundFetchUpdateResult) -> Void) {
        updateSafariProtectionInBackgroundCalledCount += 1
        onStateExecutionFinished(updateSafariProtectionInBackgroundResult)
    }

    var finishBackgroundUpdateResult: Error?
    var finishBackgroundUpdateCalledCount = 0
    func finishBackgroundUpdate(_ onUpdateFinished: @escaping (Error?) -> Void) {
        finishBackgroundUpdateCalledCount += 1
        onUpdateFinished(finishBackgroundUpdateResult)
    }

    var updateProStatusResult: Error?
    var updateProStatusCalledCount = 0
    func update(proStatus: Bool, onCbReloaded: ((Error?) -> Void)?) {
        updateProStatusCalledCount += 1
        onCbReloaded?(updateProStatusResult)
    }

    var updateSafariProtectionEnabledResult: Error?
    var updateSafariProtectionEnabledCalledCount = 0
    func update(safariProtectionEnabled: Bool, onCbReloaded: ((Error?) -> Void)?) {
        updateSafariProtectionEnabledCalledCount += 1
        onCbReloaded?(updateSafariProtectionEnabledResult)
    }

    var updateAdvancedProtectionEnabledResult: Error?
    var updateAdvancedProtectionEnabledCalledCount = 0
    func update(advancedProtectionEnabled: Bool, onCbReloaded: ((Error?) -> Void)?) {
        updateAdvancedProtectionEnabledCalledCount += 1
        onCbReloaded?(updateAdvancedProtectionEnabledResult)
    }

    var updateBlocklistIsEnabledResult: Error?
    var updateBlocklistIsEnabledCalledCount = 0
    func update(blocklistIsEnabled: Bool, onCbReloaded: ((Error?) -> Void)?) {
        updateBlocklistIsEnabledCalledCount += 1
        onCbReloaded?(updateBlocklistIsEnabledResult)
    }
    var updateAllowlistIsEnabledResult: Error?
    var updateAllowlistIsEnabledCalledCount = 0
    func update(allowlistIsEnabled: Bool, onCbReloaded: ((Error?) -> Void)?) {
        updateAllowlistIsEnabledCalledCount += 1
        onCbReloaded?(updateAllowlistIsEnabledResult)
    }

    var updateAllowlistIsInvertedResult: Error?
    var updateAllowlistIsInvertedCalledCount = 0
    func update(allowlistIsInverted: Bool, onCbReloaded: ((Error?) -> Void)?) {
        updateAllowlistIsInvertedCalledCount += 1
        onCbReloaded?(updateAllowlistIsInvertedResult)
    }

    var updateConfigCalledCount = 0
    func updateConfig(with newConfig: SafariConfigurationProtocol) {
        updateConfigCalledCount += 1
    }

    var getStateResult = true
    var getStateCalledCount = 0
    func getState(for cbType: ContentBlockerType) -> Bool {
        getStateCalledCount += 1
        return getStateResult
    }

    var setGroupError: Error?
    var setGroupCalledCount = 0
    func setGroup(groupType: SafariGroup.GroupType, enabled: Bool) throws {
        setGroupCalledCount += 1
        if let error = setGroupError {
            throw error
        }
        
        if let index = groups.firstIndex(where: { $0.groupType == groupType }) {
            groups[index].isEnabled = enabled
        }
    }

    var setGroupWithReloadError: Error?
    var setGroupWithReloadResult: Error?
    var setGroupWithReloadCalledCount = 0
    func setGroup(groupType: SafariGroup.GroupType, enabled: Bool, onCbReloaded: ((Error?) -> Void)?) throws {
        setGroupWithReloadCalledCount += 1
        if let error = setGroupWithReloadError {
            onCbReloaded?(error)
            throw error
        }
        onCbReloaded?(setGroupWithReloadResult)
    }

    var setFilterError: Error?
    var setFilterCalledCount = 0
    func setFilter(withId id: Int, groupId: Int, enabled: Bool) throws {
        setFilterCalledCount += 1
        if let error = setFilterError {
            throw error
        }

        if let groupIndex = groups.firstIndex(where: { $0.groupId == groupId }),
           let filterIndex = groups[groupIndex].filters.firstIndex(where: { $0.filterId == id}) {
            groups[groupIndex].filters[filterIndex].isEnabled = enabled
        }
    }

    var setFilterWithReloadError: Error?
    var setFilterWithReloadResult: Error?
    var setFilterWithReloadCalledCount = 0
    func setFilter(withId id: Int, groupId: Int, enabled: Bool, onCbReloaded: ((Error?) -> Void)?) throws {
        setFilterWithReloadCalledCount += 1
        if let error = setFilterWithReloadError {
            onCbReloaded?(error)
            throw error
        }
        onCbReloaded?(setFilterWithReloadResult)
    }

    var addCustomFilterResult: Error?
    var addCustomFilterCalledCount = 0
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool, onFilterAddedToDb: ((Error?) -> Void)?) {
        addCustomFilterCalledCount += 1
        onFilterAddedToDb?(addCustomFilterResult)
    }

    var addCustomFilterWithReloadOnReloadResult: Error?
    var addCustomFilterWithReloadOnFilterAddedResult: Error?
    var addCustomFilterWithReloadCalledCount = 0
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool, onFilterAddedToDb: ((Error?) -> Void)?, onCbReloaded: ((Error?) -> Void)?) {
        addCustomFilterWithReloadCalledCount += 1
        if let error = addCustomFilterWithReloadOnFilterAddedResult {
            onFilterAddedToDb?(error)
            onCbReloaded?(error)
            return
        }
        onFilterAddedToDb?(nil)
        onCbReloaded?(addCustomFilterWithReloadOnReloadResult)

    }

    var renameCustomFilterError: Error?
    var renameCustomFilterCalledCount = 0
    func renameCustomFilter(withId id: Int, to name: String) throws {
        renameCustomFilterCalledCount += 1
        if let error = renameCustomFilterError {
            throw error
        }
    }

    var deleteCustomFilterError: Error?
    var deleteCustomFilterCalledCount = 0
    func deleteCustomFilter(withId id: Int) throws {
        deleteCustomFilterCalledCount += 1
        if let error = deleteCustomFilterError {
            throw error
        }
    }

    var deleteCustomFilterWithReloadError: Error?
    var deleteCustomFilterWithReloadResult: Error?
    var deleteCustomFilterWithReloadCalledCount = 0
    func deleteCustomFilter(withId id: Int, onCbReloaded: ((Error?) -> Void)?) throws {
        deleteCustomFilterWithReloadCalledCount += 1
        if let error = deleteCustomFilterWithReloadError {
            onCbReloaded?(error)
            throw error
        }
        onCbReloaded?(deleteCustomFilterWithReloadResult)
    }


    var updateFiltersMetaAndLocalizationsOnCbReloadResult: Error?
    var updateFiltersMetaAndLocalizationsOnFilterResult: Result<FiltersUpdateResult> = .success(FiltersUpdateResult(updatedFilterIds: [], failedFilterIds: [], addedFilterIds: [], removedFiltersIds: [], error: nil))
    var updateFiltersMetaAndLocalizationsCalledCount = 0
    func updateFiltersMetaAndLocalizations(_ forcibly: Bool, onFiltersUpdated: @escaping (Result<FiltersUpdateResult>) -> Void, onCbReloaded: @escaping (Error?) -> Void) {
        updateFiltersMetaAndLocalizationsCalledCount += 1
        onFiltersUpdated(updateFiltersMetaAndLocalizationsOnFilterResult)
        onCbReloaded(updateFiltersMetaAndLocalizationsOnCbReloadResult)
    }

    var enablePredefinedGroupsAndFiltersError: Error?
    var enablePredefinedGroupsAndFiltersCalledCount = 0
    func enablePredefinedGroupsAndFilters() throws {
        enablePredefinedGroupsAndFiltersCalledCount += 1
        if let error = enablePredefinedGroupsAndFiltersError {
            throw error
        }
    }

    var rulesStringResult = ""
    var rulesStringCalledCount = 0
    func rulesString(for type: SafariUserRuleType) -> String {
        rulesStringCalledCount += 1
        return rulesStringResult
    }

    var allRulesResult: [UserRule] = []
    var allRulesCalledCount = 0
    func allRules(for type: SafariUserRuleType) -> [UserRule] {
        allRulesCalledCount += 1
        return allRulesResult
    }

    var addRuleError: Error?
    var addRuleCalledCount = 0
    func add(rule: UserRule, for type: SafariUserRuleType, override: Bool) throws {
        addRuleCalledCount += 1
        if let error = addRuleError {
            throw error
        }
    }

    var addRuleWithReloadError: Error?
    var addRuleWithReloadResult: Error?
    var addRuleWithReloadCalledCount = 0
    func add(rule: UserRule, for type: SafariUserRuleType, override: Bool, onCbReloaded: ((Error?) -> Void)?) throws {
        addRuleWithReloadCalledCount += 1
        if let error = addRuleWithReloadError {
            onCbReloaded?(error)
            throw error
        }
        onCbReloaded?(addRuleWithReloadResult)
    }

    var addRulesWithReloadError: Error?
    var addRulesWithReloadResult: Error?
    var addRulesWithReloadCalledCount = 0
    func add(rules: [UserRule], for type: SafariUserRuleType, override: Bool, onCbReloaded: ((Error?) -> Void)?) throws {
        addRulesWithReloadCalledCount += 1
        if let error = addRulesWithReloadError {
            onCbReloaded?(error)
            throw error
        }
        onCbReloaded?(addRulesWithReloadResult)
    }

    var setRulesCalledCount = 0
    func set(rules: [String], for type: SafariUserRuleType) {
        setRulesCalledCount += 1
    }

    var setRulesWithReloadResult: Error?
    var setRulesWithReloadCalledCount = 0
    func set(rules: [String], for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        setRulesWithReloadCalledCount += 1
        onCbReloaded?(setRulesWithReloadResult)
    }

    var modifyRuleError: Error?
    var modifyRuleResult: Error?
    var modifyRuleCalledCount = 0
    func modifyRule(_ oldRuleText: String, _ newRule: UserRule, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) throws {
        modifyRuleCalledCount += 1
        if let error = modifyRuleError {
            onCbReloaded?(error)
            throw error
        }
        onCbReloaded?(modifyRuleResult)
    }

    var turnRulesResult: Error?
    var turnRulesCalledCount = 0
    func turnRules(_ rules: [String], on: Bool, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        turnRulesCalledCount += 1
        onCbReloaded?(turnRulesResult)
    }

    var removeRuleResult: Error?
    var removeRuleCalledCount = 0
    func removeRule(withText ruleText: String, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) throws {
        removeRuleCalledCount += 1
        onCbReloaded?(removeRuleResult)
    }

    var removeRulesResult: Error?
    var removeRulesCalledCount = 0
    func removeRules(_ rules: [String], for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        removeRulesCalledCount += 1
        onCbReloaded?(removeRulesResult)
    }

    var removeAllRulesCalledCount = 0
    func removeAllRules(for type: SafariUserRuleType) {
        removeAllRulesCalledCount += 1
    }

    var removeAllRulesWithReloadResult: Error?
    var removeAllRulesWithReloadCalledCount = 0
    func removeAllRules(for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        removeAllRulesWithReloadCalledCount += 1
        onCbReloaded?(removeAllRulesWithReloadResult)
    }

    var removeAllUserRulesAssociatedWithDomainResult: Error?
    var removeAllUserRulesAssociatedWithDomainCalledCount = 0
    func removeAllUserRulesAssociatedWith(domain: String, onCbReloaded: ((Error?) -> Void)?) {
        removeAllUserRulesAssociatedWithDomainCalledCount += 1
        onCbReloaded?(removeAllUserRulesAssociatedWithDomainResult)
    }
}
