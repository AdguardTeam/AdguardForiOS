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

protocol PredefinedSafariMetaProtocol {
    /// Setup predefined meta for safari groups and filters
    func setupPredefinedMeta(with groups: [SafariGroup], currentLanguage: String) throws
}

extension MetaStorage: PredefinedSafariMetaProtocol {

    // MARK: - Public methods

    func setupPredefinedMeta(with groups: [SafariGroup], currentLanguage: String) throws {
        Logger.logInfo("(MetaStorage+PredefinedSafariMeta) - setupPredefinedMeta; Start setup predefined safari groups and filters meta")
        let predefinedGroups = collectPredefinedMeta(groups: groups, currentLanguage: currentLanguage)
        try predefinedGroups.forEach { group in
            try self.setGroup(withId: group.groupId, enabled: group.isEnabled)
            try group.filters.forEach { filter in
                try self.setFilter(withId: filter.filterId, enabled: true)
            }
        }
        Logger.logInfo("(MetaStorage+PredefinedSafariMeta) - setupPredefinedMeta; Successfully predefine safari groups and filters meta")
    }

    // MARK: - Private methods

    private func collectPredefinedMeta(groups: [SafariGroup], currentLanguage: String) -> [SafariGroup] {
        let predefinedGroups: [SafariGroup.GroupType] = [.ads, .privacy, .languageSpecific, .custom]
        return groups.compactMap { group in
            guard predefinedGroups.contains(group.groupType) else { return nil }
            let recommendedFilters = group.filters.compactMap { findRecommended(filter: $0, currentLanguage: currentLanguage) }
            let groupIsEnabled = !recommendedFilters.isEmpty || group.groupType == .custom

            return SafariGroup(filters: recommendedFilters,
                               isEnabled: groupIsEnabled,
                               groupType: group.groupType,
                               groupName: group.groupName,
                               displayNumber: group.displayNumber)
        }
    }

    private func findRecommended(filter: SafariGroup.Filter, currentLanguage: String) -> SafariGroup.Filter? {
        if filter.tags.contains(where: { $0.tagType == .recommended }) &&
            contains(currentLanguage: currentLanguage, inLanguages: filter.languages) {
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
