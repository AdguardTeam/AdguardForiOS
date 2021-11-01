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

typealias SafariGroupFiltersModel = (groupModel: StateHeaderViewModel<SafariGroup.GroupType>, filtersModel: [SafariFilterCellModel])
final class SafariGroupFiltersModelsProvider {

    var groupModels: [StateHeaderViewModel<SafariGroup.GroupType>] { isSearching ? searchGroupModels : initialGroupModels }
    var filtersModels: [[SafariFilterCellModel]] { isSearching ? searchFiltersModels : initialFiltersModels }

    var searchString: String? {
        didSet {
            if isSearching {
                search()
            } else {
                searchGroupModels = []
                searchFiltersModels = []
            }
        }
    }

    var isSearching: Bool { searchString != nil && !searchString!.isEmpty }

    // MARK: - Private properties

    private let proStatus: Bool

    // MARK: - Models

    private var searchGroupModels: [StateHeaderViewModel<SafariGroup.GroupType>] = []
    private var searchFiltersModels: [[SafariFilterCellModel]] = []

    private var initialGroupModels: [StateHeaderViewModel<SafariGroup.GroupType>] = []
    private var initialFiltersModels: [[SafariFilterCellModel]] = []

    // MARK: - Initialization

    init(sdkModels: [SafariGroup], proStatus: Bool) {
        self.proStatus = proStatus
        sdkModels.forEach { group in
            if group.groupType.proOnly && !proStatus {
                return
            }

            let groupModel = StateHeaderViewModel(iconImage: group.groupType.iconImage, title: group.groupName, isEnabled: group.isEnabled, id: group.groupType)
            self.initialGroupModels.append(groupModel)

            let filtersModels = group.filters.map { filter -> SafariFilterCellModel in
                let tagsModels = filter.tags.map { SafariTagButtonModel(tag: $0, isSelected: true) }
                return SafariFilterCellModel(
                    filterId: filter.filterId,
                    groupType: group.groupType,
                    filterNameAttrString: (filter.name ?? "").clearAttrString,
                    isEnabled: filter.isEnabled,
                    version: filter.version,
                    lastUpdateDate: filter.lastUpdateDate,
                    tags: tagsModels,
                    groupIsEnabled: group.isEnabled
                )
            }
            self.initialFiltersModels.append(filtersModels)
        }
    }

    // MARK: - Private methods

    private func search() {
        searchGroupModels = []
        searchFiltersModels = []
        guard let searchString = searchString else { return }

        let (tags, words) = getTagsAndWordsFrom(searchString)

        for i in 0..<initialGroupModels.count {
            let filterModels = initialFiltersModels[i]
            let filteredModels = filterModels.compactMap { filter -> SafariFilterCellModel? in
                return check(filter, matches: tags, or: words)
            }

            if !filteredModels.isEmpty {
                let groupModel = initialGroupModels[i]
                searchGroupModels.append(groupModel)
                searchFiltersModels.append(filteredModels)
            }
        }
    }

    /// Gets tags and separate words from search string
    private func getTagsAndWordsFrom(_ string: String) -> (tags: Set<String>, words: Set<String>) {
        var tags: Set<String> = []
        var words: Set<String> = []
        let parts = string.split(separator: " ")
        parts.forEach {
            if $0.starts(with: "#") {
                tags.insert(String($0))
            } else {
                words.insert(String($0))
            }
        }
        return (tags, words)
    }

    private func check(_ filter: SafariFilterCellModel, matches tags: Set<String>, or words: Set<String>) -> SafariFilterCellModel? {
        let filterTags = Set(filter.tags.map { $0.tagName })
        let matchedTags = filterTags.intersection(tags)
        let tagModels = filter.tags.map {
            SafariTagButtonModel(tagName: $0.tagName, isLang: $0.isLang, isSelected: matchedTags.contains($0.tagName))
        }

        let highlightedOccurancies = filter.filterNameAttrString.string.highlight(occuranciesOf: words)
        if highlightedOccurancies.matchesFound || !matchedTags.isEmpty {
            return SafariFilterCellModel(
                filterId: filter.filterId,
                groupType: filter.groupType,
                filterNameAttrString: highlightedOccurancies.attrString,
                isEnabled: filter.isEnabled,
                version: filter.version,
                lastUpdateDate: filter.lastUpdateDate,
                tags: tagModels,
                groupIsEnabled: filter.groupIsEnabled
            )
        } else {
            return nil
        }
    }
}
