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

public protocol SafariFilterProtocol {
    var name: String? { get }
    var description: String? { get }
    var isEnabled: Bool { get set }
    var version: String? { get }
    var lastUpdateDate: Date? { get }
    var updateFrequency: Int? { get }
    var homePage: String? { get }
    var filterDownloadPage: String? { get }
    var filterId: Int { get }
    var group: SafariGroupProtocol { get }
    var displayNumber: Int { get }
    var languages: [String] { get }
    var tags: [ExtendedFiltersMeta.Tag] { get }
    var rulesCount: Int? { get }
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
