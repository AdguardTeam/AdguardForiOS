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
import SQLite

// MARK: - FiltersMetaStorageProtocol + Filters methods

/* FiltersTable; filters table */
fileprivate struct FiltersTable {
    // Properties from table
    let filterId: Int
    let groupId: Int
    let isEnabled: Bool
    let version: String?
    let lastUpdateTime: Date?
    let lastCheckTime: Date?
    let editable: Bool
    let displayNumber: Int
    let name: String?
    let description: String?
    let homePage: String?
    let removable: Bool
    let expires: Int?
    let subscriptionUrl: String?
    
    // Table name
    static let table = Table("filters")
    
    // Columns names
    static let filterId = Expression<Int>("filter_id")
    static let groupId = Expression<Int>("group_id")
    static let isEnabled = Expression<Bool>("is_enabled")
    static let version = Expression<String>("version")
    static let lastUpdateTime = Expression<Date>("last_update_time")
    static let lastCheckTime = Expression<Date>("last_check_time")
    static let editable = Expression<Bool>("editable")
    static let displayNumber = Expression<Int>("display_number")
    static let name = Expression<String>("name")
    static let description = Expression<String>("description")
    static let homePage = Expression<String>("homepage")
    static let removable = Expression<Bool>("removable")
    static let expires = Expression<Int>("expires")
    static let subscriptionUrl = Expression<String>("subscriptionUrl")
    
    // Initializer from DB result
    init(dbFilter: Row) {
        self.filterId = dbFilter[FiltersTable.filterId]
        self.groupId = dbFilter[FiltersTable.groupId]
        self.isEnabled = dbFilter[FiltersTable.isEnabled]
        self.version = dbFilter[FiltersTable.version]
        self.lastUpdateTime = dbFilter[FiltersTable.lastUpdateTime]
        self.lastCheckTime = dbFilter[FiltersTable.lastCheckTime]
        self.editable = dbFilter[FiltersTable.editable]
        self.displayNumber = dbFilter[FiltersTable.displayNumber]
        self.name = dbFilter[FiltersTable.name]
        self.description = dbFilter[FiltersTable.description]
        self.homePage = dbFilter[FiltersTable.homePage]
        self.removable = dbFilter[FiltersTable.removable]
        self.expires = dbFilter[FiltersTable.expires]
        self.subscriptionUrl = dbFilter[FiltersTable.subscriptionUrl]
    }
}

extension FiltersMetaStorageProtocol {
    
    // Returns all filters from database (they aren't localized)
    func getAllFilters() throws -> [ExtendedFilterMetaProtocol] {
        // Query: select * from filters order by group_id, display_number, filter_id
        let query = FiltersTable.table.order(FiltersTable.groupId, FiltersTable.displayNumber, FiltersTable.filterId)
        
        let dbFilters: [FiltersTable] = (try? filtersDb.prepare(query).map { FiltersTable(dbFilter: $0) }) ?? []
        let groups = try getAllGroups()
        let filters: [ExtendedFilterMetaProtocol] = try dbFilters.map { dbFilter in
            let tags = try getTagsForFilter(withId: dbFilter.filterId)
            let langs = try getLangsForFilter(withId: dbFilter.filterId)
            let group = groups.first(where: { $0.groupId == dbFilter.groupId })!
            
            return ExtendedFiltersMeta.Meta(filterId: dbFilter.filterId,
                                            name: dbFilter.name,
                                            description: dbFilter.description,
                                            timeAdded: nil,
                                            homePage: dbFilter.homePage,
                                            updateFrequency: dbFilter.expires,
                                            displayNumber: dbFilter.displayNumber,
                                            group: group,
                                            filterDownloadPage: dbFilter.subscriptionUrl,
                                            trustLevel: .full,
                                            version: dbFilter.version,
                                            lastUpdateDate: dbFilter.lastUpdateTime,
                                            languages: langs,
                                            tags: tags)
        }
        Logger.logDebug("(FiltersMetaStorage) - allFilters returning \(filters.count) filter objects")
        return filters
    }
    
    // Returns all filters from database with localizations for specified language
    func getAllLocalizedFilters(forLanguage lang: String) throws -> [ExtendedFilterMetaProtocol] {
        // Query: select * from filters order by group_id, display_number, filter_id
        let query = FiltersTable.table.order(FiltersTable.groupId, FiltersTable.displayNumber, FiltersTable.filterId)
        
        let dbFilters: [FiltersTable] = try filtersDb.prepare(query).map { FiltersTable(dbFilter: $0) }
        var groups = try getAllLocalizedGroups(forLanguage: lang)
        if groups.isEmpty {
            //if groups is empty get not localized groups
            groups = try getAllGroups()
        }
        
        let filters: [ExtendedFilterMetaProtocol] = try dbFilters.compactMap { dbFilter in
            let tags = try getTagsForFilter(withId: dbFilter.filterId)
            let langs = try getLangsForFilter(withId: dbFilter.filterId)
            let group = groups.first(where: { $0.groupId == dbFilter.groupId })!
            
            /*
                If there is no localized filter we trying to get default english localization and if it is steel nil return nil
             */
            var filterLocalization = try getLocalizationForFilter(withId: dbFilter.filterId, forLanguage: lang)
            if filterLocalization == nil && lang != FiltersMetaStorage.defaultDbLanguage {
                filterLocalization = try getLocalizationForFilter(withId: dbFilter.filterId, forLanguage: FiltersMetaStorage.defaultDbLanguage)
            }
            
            guard let localization = filterLocalization else { return nil }
            
            return ExtendedFiltersMeta.Meta(filterId: dbFilter.filterId,
                                            name: localization.name,
                                            description: localization.description,
                                            timeAdded: nil,
                                            homePage: dbFilter.homePage,
                                            updateFrequency: dbFilter.expires,
                                            displayNumber: dbFilter.displayNumber,
                                            group: group,
                                            filterDownloadPage: dbFilter.subscriptionUrl,
                                            trustLevel: .full,
                                            version: dbFilter.version,
                                            lastUpdateDate: dbFilter.lastUpdateTime,
                                            languages: langs,
                                            tags: tags)
        }
        Logger.logDebug("(FiltersMetaStorage) - getAllLocalizedFilters returning \(filters.count) filter objects for lang=\(lang)")
        return filters
    }
}
