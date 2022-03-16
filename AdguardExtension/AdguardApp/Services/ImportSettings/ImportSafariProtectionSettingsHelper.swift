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

protocol ImportSafariProtectionSettingsHelperProtocol {
    /// Imports Safari filters. If **override** is true then all filters and groups will be disabled except new setted filters. If group contains enabled filters it will be enabled too. Returns import result
    func importSafariFilters(_ filtersToImport: [ImportSettings.DefaultSafariFilterSettings], override: Bool) -> [ImportSettings.DefaultSafariFilterSettings]

    /// Imports Safari blocklist rules. If **override** is true then all old rules will be replaced with new ones.
    func importSafariBlocklistRules(_ rules: [String], override: Bool)

    /// Imports custom Safari filters. If **override** is true then all old filters will be replaced with new ones. Returns import result in completion
    func importCustomSafariFilters(_ filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool, completion: @escaping ([ImportSettings.FilterSettings]) -> Void)
}

private let LOG = LoggerFactory.getLoggerWrapper(ImportSafariProtectionSettingsHelper.self)

/// This object is responsible for importing Safari protection settings
final class ImportSafariProtectionSettingsHelper: ImportSafariProtectionSettingsHelperProtocol {

    // MARK: - Properties

    private let safariProtection: SafariProtectionProtocol
    private let parser: CustomFilterMetaParserProtocol

    private let workingQueue = DispatchQueue(label: "AdGuardApp.ImportSafariProtectionSettingsHelperQueue")
    private let completionQueue = DispatchQueue(label: "AdGuardApp.ImportSafariProtectionSettingsHelperCompletionQueue")

    // MARK: - Init

    init(safariProtection: SafariProtectionProtocol,
         parser: CustomFilterMetaParserProtocol = CustomFilterMetaParser()) {
        self.safariProtection = safariProtection
        self.parser = parser
    }

    // MARK: Internal methods

    func importSafariFilters(_ filtersToImport: [ImportSettings.DefaultSafariFilterSettings], override: Bool) -> [ImportSettings.DefaultSafariFilterSettings] {
        workingQueue.sync {
            if override { disableAllSafariFiltersAndGroups() }

            let allFilters = safariProtection.groups.flatMap { $0.filters }
            let result = importSafariFiltersInternal(filtersToImport, allFilters: allFilters)

            let groupsToEnable = collectGroupsToEnable(result)
            enableGroups(groupsToEnable)

            return result
        }
    }

    func importSafariBlocklistRules(_ rules: [String], override: Bool) {
        workingQueue.sync {
            if override {
                safariProtection.removeAllRules(for: .blocklist)
            }

            safariProtection.set(rules: rules, for: .blocklist)
        }
    }

    func importCustomSafariFilters(_ filtersContainer: ImportSettingsService.FiltersImportContainer, override: Bool, completion: @escaping ([ImportSettings.FilterSettings]) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                LOG.error("Missing self")
                DispatchQueue.main.async { completion([]) }
                return
            }

            if override { self.removeAllCustomSafariFilters() }

            let group = DispatchGroup()
            var result = [ImportSettings.FilterSettings]()

            filtersContainer.toEnableFilters.forEach {
                var filter = $0
                let status = self.setCustomSafariFilter(filter)
                filter.status = status
                result.append(filter)
            }

            filtersContainer.toImportFilters.forEach { filter in
                group.enter()
                self.subscribe(filter) { settings in
                    result.append(settings)
                    group.leave()
                }
            }

            group.wait()

            // Enable custom group if custom filters was added and custom group was not enabled
            if !result.isEmpty,
               let groupEnabled = self.safariProtection.groups.first(where: { $0.groupType == .custom })?.isEnabled,
                !groupEnabled,
                result.contains(where: { $0.status == .successful }) {
                self.enableGroups(Set<SafariGroup.GroupType>(arrayLiteral: .custom))
            }
            self.completionQueue.async { completion(result) }
        }
    }

    // MARK: - Private methods

    private func subscribe(_ filter: ImportSettings.FilterSettings, completion: @escaping (ImportSettings.FilterSettings) -> Void) {
        var filter = filter
        if filter.isImportEnabled {
            addCustomFilter(filter) { success in
                filter.status = success ? .successful : .unsuccessful
                completion(filter)
            }
        } else {
            completion(filter)
        }
    }

    private func addCustomFilter(_ filter: ImportSettings.FilterSettings, completion: @escaping (_ success: Bool) -> Void) {
        guard let url = URL(string: filter.url) else {
            LOG.error("Incorrect URL string = \(filter.url)")
            self.completionQueue.async { completion(false) }
            return
        }

        do {
            let meta = try parser.getMetaFrom(url: url, for: .safari)
            safariProtection.add(customFilter: meta, enabled: true) { error in
                if let error = error {
                    LOG.error("Error occurred while adding new custom filter with url = \(url); Error: \(error)")
                    self.completionQueue.async { completion(false) }
                    return
                }

                LOG.info("Successfully add new custom filter with url = \(url)")
                self.completionQueue.async { completion(true) }
            }

        } catch {
            LOG.error("Error occurred while trying to add filter with url=\(url); Error: \(error)")
            self.completionQueue.async { completion(false) }
        }
    }

    private func importSafariFiltersInternal(_ filtersToImport: [ImportSettings.DefaultSafariFilterSettings], allFilters: [SafariGroup.Filter]) -> [ImportSettings.DefaultSafariFilterSettings] {

        var resultFilters: [ImportSettings.DefaultSafariFilterSettings] = []

        for var filterToImport in filtersToImport {
            if filterToImport.isImportEnabled {
                if let filter = allFilters.first(where: { $0.filterId == filterToImport.id }) {
                    filterToImport.status = setFilter(filter, enabled: filterToImport.enable)
                } else {
                    filterToImport.status = .unsuccessful
                }
            }
            resultFilters.append(filterToImport)
        }

        return resultFilters
    }

    private func setFilter(_ filter: SafariGroup.Filter, enabled: Bool) -> ImportSettings.ImportSettingStatus {
        do {
            try safariProtection.setFilter(withId: filter.filterId, groupId: filter.group.groupId, enabled: enabled)
            LOG.info("Successfully set enable to \(enabled) for filter with id = \(filter.filterId) for group id = \(filter.group.groupId)")
            return .successful
        } catch {
            LOG.error("Error occurred while setting enable to \(enabled) for filter with id = \(filter.filterId) for group id = \(filter.group.groupId)")
            return .unsuccessful
        }
    }

    private func enableGroups(_ groupsToEnable: Set<SafariGroup.GroupType>) {
        groupsToEnable.forEach {
            do {
                try safariProtection.setGroup(groupType: $0, enabled: true)
                LOG.info("Group \($0) was enabled")
            } catch {
                LOG.error("Error occurred while enabling group \($0); Error: \(error)")
            }
        }
    }

    /// Returns set of GroupType that must be enabled
    private func collectGroupsToEnable(_ filtersToImport: [ImportSettings.DefaultSafariFilterSettings]) -> Set<SafariGroup.GroupType> {
        var setOfGroups = Set<SafariGroup.GroupType>()
        safariProtection.groups.forEach { group in
            filtersToImport.forEach { filter in
                let filtersWasImported = filter.isImportEnabled && filter.status == .successful
                if group.filters.contains(where: { filter.id == $0.filterId && $0.isEnabled }) && filtersWasImported {
                    setOfGroups.insert(group.groupType)
                }
            }
        }
        return setOfGroups
    }

    /// Disables all filters excepts filters from custom group.
    /// Disables all groups excepts custom group.
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
            try safariProtection.setGroup(groupType: group.groupType, enabled: false)
            LOG.info("Group = \(group.groupType) was disabled")
        } catch {
            LOG.error("Error occurred while disabling group = \(group.groupType); Error: \(error)")
        }

        group.filters.forEach { filter in
            do {
                try safariProtection.setFilter(withId: filter.filterId, groupId: filter.group.groupId, enabled: false)
                LOG.info("Filter with id = \(filter.filterId) was disabled")
            } catch {
                LOG.error("Error occurred while disabling filter with id = \(filter.filterId); Error: \(error)")
            }
        }
    }

    private func deleteFilters(from group: SafariGroup) {
        group.filters.forEach {
            do {
                try safariProtection.deleteCustomFilter(withId: $0.filterId)
                LOG.info("Successfully delete filter with id = \($0.filterId)")
            } catch {
                LOG.error("Error occurred while deleting filter with id = \($0.filterId); Error: \(error)")
            }
        }
    }

    private func setCustomSafariFilter(_ filter: ImportSettings.FilterSettings) -> ImportSettings.ImportSettingStatus {
        guard let customGroup = safariProtection.groups.first(where: { $0.groupType == .custom }),
              let customSafariFilter = customGroup.filters.first(where: { $0.filterDownloadPage == filter.url })
        else {
            LOG.error("Custom safari filter with url=\(filter.url) not exists")
            return .unsuccessful
        }

        do {
            try safariProtection.setFilter(withId: customSafariFilter.filterId, groupId: SafariGroup.GroupType.custom.id, enabled: true)
            LOG.info("Successfully enable custom safari filter with url=\(filter.url)")
            return .successful
        } catch {
            LOG.error("Custom safari filter with url=\(filter.url) were not enabled: Error: \(error)")
            return .unsuccessful
        }
    }
}
