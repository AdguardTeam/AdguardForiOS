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

/// This struct responsible for imports Safari protection settings
struct ImportSafariProtectionSettingsHelper {
    private let safariProtection: SafariProtectionProtocol

    init(safariProtection: SafariProtectionProtocol) {
        self.safariProtection = safariProtection
    }

    /// Imports Safari filters. If **override** is true then all filters and groups would be disabled except new setted filters. If group contain enabled filters it would be enabled too. Return import result
    func importSafariFilters(_ filtersToImport: [DefaultCBFilterSettings], override: Bool)-> [DefaultCBFilterSettings] {
        if override { disableAllSafariFiltersAndGroups() }

        let allFilters = safariProtection.groups.flatMap { $0.filters }
        let result = importSafariFiltersInternal(filtersToImport, allFilters: allFilters)

        let groupsToEnable = collectGroupsToEnable(filtersToImport)
        enableGroups(groupsToEnable: groupsToEnable)

        return result
    }

    /// Imports custom Safari filters. If **override** is true then all old filters would be replaced with new ones. Returns import result
    func importCustomSafariFilters(_ filters: [CustomCBFilterSettings], override: Bool) -> [CustomCBFilterSettings] {
        if override { removeAllCustomSafariFilters() }

        var result = [CustomCBFilterSettings]()
        let group = DispatchGroup()

        for var filter in filters {

            if filter.status == .enabled {
                group.enter()

                subscribeSafariCustomFilter(filter) { success in
                    filter.status = success ? .successful : .unsuccessful
                    result.append(filter)
                    group.leave()
                }
            } else {
                result.append(filter)
            }
        }

        group.wait()

        if !result.isEmpty,
            let groupEnabled = safariProtection.groups.first(where: { $0.groupType == .custom })?.isEnabled,
            !groupEnabled {
            enableGroups(groupsToEnable: Set<SafariGroup.GroupType>(arrayLiteral: .custom))
        }
        return result
    }

    /// Import Safari blocklist rules. If **override** is true then all old rules would be replaced new ones. Returns true if storage have been changed
    func importSafariBlocklistRules(_ rules: [String]?, override: Bool) -> Bool {
        var result = false
        if override {
            safariProtection.removeAllRules(for: .blocklist, shouldReloadCB: false, onCbReloaded: nil)
            result = true
        }

        if let rules = rules {
            rules.forEach {
                do {
                    let userRule = UserRule(ruleText: $0)
                    try safariProtection.add(rule: userRule, for: .blocklist, override: override, shouldReloadCB: false, onCbReloaded: nil)
                    DDLogInfo("(ImportSafariProtectionSettingsHelper) - importSafariBlocklistRules; Successfully add rule \($0) to blocklist")
                    result = true
                } catch {
                    DDLogError("(ImportSafariProtectionSettingsHelper) - importSafariBlocklistRules; Error occurred while adding rule = \($0) for blocklist; Error: \(error)")
                }
            }
        }

        return result
    }

    private func subscribeSafariCustomFilter(_ filter: CustomCBFilterSettings, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: filter.url) else {
            DDLogError("(ImportSafariProtectionSettingsHelper) - subscribeSafariCustomFilter; Incorrect URL string = \(filter.url)")
            completion(false)
            return
        }
        let parser = CustomFilterMetaParser()

        do {
            let meta = try parser.getMetaFrom(url: url, for: .safari)
            safariProtection.add(customFilter: meta, enabled: true, shouldReloadCB: false) { error in
                if let error = error {
                    DDLogError("(ImportSafariProtectionSettingsHelper) - subscribeSafariCustomFilter; Error occurred while adding new custom filter with url = \(url); Error: \(error)")
                    completion(false)
                    return
                }

                DDLogInfo("(ImportSafariProtectionSettingsHelper) - subscribeSafariCustomFilter; Successfully add new custom filter with url = \(url)")
                completion(true)
            } onCbReloaded: { _ in }

        } catch {
            DDLogError("(ImportSafariProtectionSettingsHelper)")
            completion(false)
        }
    }

    private func importSafariFiltersInternal(_ filtersToImport: [DefaultCBFilterSettings], allFilters: [SafariGroup.Filter]) -> [DefaultCBFilterSettings] {
        var resultFilters: [DefaultCBFilterSettings] = []

        for var filterToImport in filtersToImport {
            if filterToImport.status == .enabled {
                if let filter = allFilters.first(where: { $0.filterId == filterToImport.id }) {
                    filterToImport.status = setFilter(filter: filter, enabled: filterToImport.enable)
                } else {
                    filterToImport.status = .unsuccessful
                }
            }
            resultFilters.append(filterToImport)
        }

        return resultFilters
    }

    private func setFilter(filter: SafariGroup.Filter, enabled: Bool) -> ImportSettingStatus {
        do {
            try safariProtection.setFilter(withId: filter.filterId, filter.group.groupId, enabled: enabled, shouldReloadCB: false, onCbReloaded: nil)
            DDLogInfo("(ImportSafariProtectionSettingsHelper) - setFilter; Successfully set enable to \(enabled) for filter with id = \(filter.filterId) for group id = \(filter.group.groupId)")
            return .successful
        } catch {
            DDLogError("(ImportSafariProtectionSettingsHelper) - setFilter; Error occurred while setting enable to \(enabled) for filter with id = \(filter.filterId) for group id = \(filter.group.groupId)")
            return .unsuccessful
        }
    }

    private func enableGroups(groupsToEnable: Set<SafariGroup.GroupType>) {
        groupsToEnable.forEach {
            do {
                try safariProtection.setGroup($0, enabled: true, shouldReloadCB: false, onCbReloaded: nil)
                DDLogInfo("(ImportSafariProtectionSettingsHelper) - enableGroups; Group \($0) were enabled")
            } catch {
                DDLogError("(ImportSafariProtectionSettingsHelper) - enableGroups; Error occurred while enabling group \($0); Error: \(error)")
            }
        }
    }

    /// Return set of GroupType that must be enabled
    private func collectGroupsToEnable(_ filtersToImport: [DefaultCBFilterSettings]) -> Set<SafariGroup.GroupType> {
        var setOfGroups = Set<SafariGroup.GroupType>()
        safariProtection.groups.forEach { group in
            filtersToImport.forEach { filter in
                if group.filters.contains(where: { filter.id == $0.filterId && $0.isEnabled }) {
                    setOfGroups.insert(group.groupType)
                }
            }
        }
        return setOfGroups
    }

    /// Disable all filters excepts filters from custom group.
    /// Disable all groups excepts custom group.
    private func disableAllSafariFiltersAndGroups() {
        for group in safariProtection.groups {
            if group.groupType == .custom { continue }
            disableGroupAndAllFilters(for: group)
        }
    }

    /// Removes all custom safari filters from custom group
    private func removeAllCustomSafariFilters() {
        if let group = safariProtection.groups.first(where: { $0.groupType == .custom }) {
            deleteFilters(from: group)
        }
    }

    private func disableGroupAndAllFilters(for group: SafariGroup) {
        do {
            try safariProtection.setGroup(group.groupType, enabled: false, shouldReloadCB: false, onCbReloaded: nil)
            DDLogInfo("(ImportSafariProtectionSettingsHelper) - disableGroupAndAllFilters; Group = \(group.groupType) were disabled")
        } catch {
            DDLogError("(ImportSafariProtectionSettingsHelper) - disableGroupAndAllFilters; Error occurred while disabling group = \(group.groupType); Error: \(error)")
        }

        group.filters.forEach { filter in
            do {
                try safariProtection.setFilter(withId: filter.filterId, filter.group.groupId, enabled: false, shouldReloadCB: false, onCbReloaded: nil)
                DDLogInfo("(ImportSafariProtectionSettingsHelper) - disableGroupAndAllFilters; Filter with id = \(filter.filterId) were disabled")
            } catch {
                DDLogError("(ImportSafariProtectionSettingsHelper) - disableGroupAndAllFilters; Error occurred while disabling filter with id = \(filter.filterId); Error: \(error)")
            }
        }
    }

    private func deleteFilters(from group: SafariGroup) {
        group.filters.forEach {
            do {
                try safariProtection.deleteCustomFilter(withId: $0.filterId, shouldReloadCB: false, onCbReloaded: nil)
                DDLogInfo("(ImportSafariProtectionSettingsHelper) - deleteFilters; Successfully delete filter with id = \($0.filterId)")
            } catch {
                DDLogError("(ImportSafariProtectionSettingsHelper) - deleteFilters; Error occurred while deleting filter with id = \($0.filterId); Error: \(error)")
            }
        }
    }
}
