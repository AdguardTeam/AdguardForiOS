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

protocol PredefinedSafariMetaServiceProtocol {
    /// Predefine default safari protection groups and filters
    func predefine(with groups: [SafariGroup]) throws
}

/// This class setup predefined safari groups and filters
final class PredefinedSafariMetaService: PredefinedSafariMetaServiceProtocol {

    // MARK: - Private properties
    private let predefinedGroups: [SafariGroup.GroupType] = [.ads, .privacy, .languageSpecific, .custom]

    private let workingQueue = DispatchQueue(label: "AdGuardSDK.PredefinedSafariMetaService.workingQueue")

    // MARK: - Services
    
    private let safariConfiguration: SafariConfigurationProtocol
    private let metaStorage: MetaStorageProtocol

    // MARK: - Init

    init(safariConfiguration: SafariConfigurationProtocol, metaStorage: MetaStorageProtocol) {
        self.safariConfiguration = safariConfiguration
        self.metaStorage = metaStorage
    }

    // MARK: - Public methods

    func predefine(with groups: [SafariGroup]) throws {
        Logger.logInfo("(PredefinedSafariMetaService) - predefine; Start predefining default safari groups and filters")
        let predefinedGroups = collectPredefinedMeta(groups: groups)
        try predefinedGroups.forEach { group in
            try metaStorage.setGroup(withId: group.groupId, enabled: group.isEnabled)
            try group.filters.forEach { filter in
                try metaStorage.setFilter(withId: filter.filterId, enabled: true)
            }
        }
        Logger.logInfo("(PredefinedSafariMetaService) - predefine; Successfully predefine default safari groups and filters")
    }

    // MARK: - Private methods

    private func collectPredefinedMeta(groups: [SafariGroup]) -> [SafariGroup] {
        return groups.compactMap { group in
            guard predefinedGroups.contains(group.groupType) else { return nil }
            let findedFilters = group.filters.compactMap { findRecommended(filter: $0) }
            let groupIsEnabled = !findedFilters.isEmpty || group.groupType == .custom

            return SafariGroup(filters: findedFilters,
                               isEnabled: groupIsEnabled,
                               groupType: group.groupType,
                               groupName: group.groupName,
                               displayNumber: group.displayNumber)
        }
    }

    private func findRecommended(filter: SafariGroup.Filter) -> SafariGroup.Filter? {
        if filter.tags.contains(where: { $0.tagType == .recommended }) &&
            contains(currentLanguage: safariConfiguration.currentLanguage, inLanguages: filter.languages) {
            return filter
        }
        return nil
    }

    private func contains(currentLanguage: String ,inLanguages languages: [String]) -> Bool {
        let splited = currentLanguage.split(separator: "-")
        guard splited.count == 2 else { return false }
        let contains = languages.contains(String(splited[0])) || languages.contains(String(splited[1]))
        return contains || languages.isEmpty
    }
}
