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

/**
 All filters that we store have their own meta and rules
 This object represents all filters information we're able to find
 */
public protocol SafariFilterProtocol {
    var name: String? { get } // Filter name
    var description: String? { get } // Filter description
    var isEnabled: Bool { get set } // Filter state. We won't use rules from disabled filters.
    var version: String? { get } // Filter version. Filter content always changes by it's authors, so we store the version of filter to identify it
    var lastUpdateDate: Date? { get } // The last time the filter was updated
    var updateFrequency: Int? { get } // The frequency with which we should update filters
    var homePage: String? { get } // Filter's homepage. It's just a link to somewhere
    var filterDownloadPage: String? { get } // The link we should download filter from
    var filterId: Int { get } // Filter's unique identifier. It is different for every filter
    var group: SafariGroupProtocol { get } // Group the filter is related to
    var displayNumber: Int { get } // It's an order that filters will be displayed in. A filter with the lowest one will be dispalyed first
    var languages: [String] { get } // Languages that filter is related to
    var tags: [ExtendedFiltersMeta.Tag] { get } // Some tags that filters can be grouped by
    var rulesCount: Int? { get } // Number of rules in the filter. But this variable is approximate. The very exact result will give the Converter Lib
}

public extension SafariGroup {
    struct Filter: SafariFilterProtocol {
        public let name: String?
        public let description: String?
        public var isEnabled: Bool
        public let filterId: Int
        public let version: String?
        public let lastUpdateDate: Date?
        public let updateFrequency: Int?
        public let group: SafariGroupProtocol
        public let displayNumber: Int
        public let languages: [String]
        public let tags: [ExtendedFiltersMeta.Tag]
        public let homePage: String?
        public let filterDownloadPage: String?
        public let rulesCount: Int?
        
        // MARK: - Initialization
        
        init(name: String?, description: String?, isEnabled: Bool, filterId: Int, version: String?, lastUpdateDate: Date?, updateFrequency: Int?, group: SafariGroupProtocol, displayNumber: Int, languages: [String], tags: [ExtendedFiltersMeta.Tag], homePage: String?, filterDownloadPage: String?, rulesCount: Int?) {
            self.name = name
            self.description = description
            self.isEnabled = isEnabled
            self.filterId = filterId
            self.version = version
            self.lastUpdateDate = lastUpdateDate
            self.updateFrequency = updateFrequency
            self.group = group
            self.displayNumber = displayNumber
            self.languages = languages
            self.tags = tags
            self.homePage = homePage
            self.filterDownloadPage = filterDownloadPage
            self.rulesCount = rulesCount
        }
        
        init(dbFilter: FiltersTable, group: SafariGroupProtocol, rulesCount: Int?, languages: [String], tags: [FilterTagsTable], filterDownloadPage: String?) {
            self.name = dbFilter.name
            self.description = dbFilter.description
            self.isEnabled = dbFilter.isEnabled
            self.filterId = dbFilter.filterId
            self.version = dbFilter.version
            self.lastUpdateDate = dbFilter.lastUpdateTime
            self.updateFrequency = dbFilter.expires
            self.group = group
            self.displayNumber = dbFilter.displayNumber
            self.languages = languages
            self.tags = tags.compactMap { ExtendedFiltersMeta.Tag(tagId: $0.tagId, tagTypeId: $0.type, tagName: $0.name) }
            self.homePage = dbFilter.homePage
            self.filterDownloadPage = filterDownloadPage
            self.rulesCount = rulesCount
        }
        
        init(customFilter: ExtendedCustomFilterMetaProtocol, filterId: Int, isEnabled: Bool, group: SafariGroupProtocol, displayNumber: Int) {
            self.name = customFilter.name
            self.description = customFilter.description
            self.filterId = filterId
            self.isEnabled = isEnabled
            self.version = customFilter.version
            self.lastUpdateDate = customFilter.lastUpdateDate
            self.updateFrequency = customFilter.updateFrequency
            self.group = group
            self.displayNumber = displayNumber
            self.languages = []
            self.tags = []
            self.homePage = customFilter.homePage
            self.filterDownloadPage = customFilter.filterDownloadPage
            self.rulesCount = customFilter.rulesCount
        }
    }
}
