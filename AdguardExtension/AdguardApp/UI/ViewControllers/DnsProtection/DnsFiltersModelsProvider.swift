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

import struct DnsAdGuardSDK.DnsFilter

protocol DnsFiltersModelsProviderProtocol: AnyObject {
    /// Returns DNS filters models depending on `searchString`
    var filtersModels: [DnsFilterCellModel] { get }

    /// String the user entered while searching for DNS filters
    var searchString: String? { get set }

    /// True if searching, false otherwise
    var isSearching: Bool { get }
}

/// This object is a helper for `DnsFiltetsModel`
/// It is responsible for providing UITableViewCell models, all logic of searching is encapsulated here
final class DnsFiltersModelsProvider: DnsFiltersModelsProviderProtocol {

    // MARK: - Public variables

    var filtersModels: [DnsFilterCellModel] { isSearching ? searchModels : initialModels }

    var searchString: String? {
        didSet {
            if isSearching {
                search()
            } else {
                searchModels = []
            }
        }
    }

    var isSearching: Bool { searchString != nil && !searchString!.isEmpty }

    // MARK: - Private variables

    private let initialModels: [DnsFilterCellModel]
    private var searchModels: [DnsFilterCellModel] = []

    // MARK: - Initializer

    init(sdkModels: [DnsFilter]) {
        self.initialModels = sdkModels.map { sdkModel -> DnsFilterCellModel in
            DnsFilterCellModel(
                filterId: sdkModel.filterId,
                filterNameAttrString: (sdkModel.name ?? "").clearAttrString,
                filterDescription: sdkModel.description,
                isEnabled: sdkModel.isEnabled,
                version: sdkModel.version,
                lastUpdateDate: sdkModel.lastUpdateDate
            )
        }
    }

    // MARK: - Private methods

    private func search() {
        guard let searchString = searchString else { return }
        let searchWords = searchString.split(separator: " ").map { String($0) }

        searchModels = initialModels.compactMap { initialModel -> DnsFilterCellModel? in
            let occuranceInfo = initialModel.filterNameAttrString.string.highlight(occuranciesOf: Set(searchWords))
            if occuranceInfo.matchesFound {
                return DnsFilterCellModel(
                    filterId: initialModel.filterId,
                    filterNameAttrString: occuranceInfo.attrString,
                    filterDescription: initialModel.filterDescription,
                    isEnabled: initialModel.isEnabled,
                    version: initialModel.version,
                    lastUpdateDate: initialModel.lastUpdateDate
                )
            } else {
                return nil
            }
        }
    }
}
