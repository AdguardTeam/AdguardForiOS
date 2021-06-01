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

// MARK: - FiltersMetaStorageProtocol + Filters methods

extension FiltersMetaStorageProtocol {
    
    // Returns all filters from database (they aren't localized)
    func getAllFilters() throws -> [ExtendedFilterMetaProtocol] {
        // Query: SELECT * FROM filters ORDER BY group_id, display_number, filter_id
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
        // Query: SELECT * FROM filters ORDER BY group_id, display_number, filter_id
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
    
    // Enables or disables a filter with specified id
    func setFilter(withId id: Int, enabled: Bool) throws {
        let query = FiltersTable.table.where(FiltersTable.filterId == id).update(FiltersTable.isEnabled <- enabled)
        //Query: UPDATE "filters" SET "is_enabled" = enabled WHERE ("filter_id" = filterId)
        let rowId = try filtersDb.run(query)
        Logger.logInfo("(FiltersMetaStorage) - Filter enabled state with filter Id \(rowId) was updated to state \(enabled)")
    }
    
    
    func updateFiltersWithJSONMetas(metas: [ExtendedFilterMetaProtocol]) throws {
        for meta in metas {
            /* Check if filter exists
             If true than update filters with new data otherwise create filter with new data
            */
            let selectQuery = FiltersTable.table.where(FiltersTable.filterId == meta.filterId)
            if let _ = try filtersDb.pluck(selectQuery) {
                try updateFilterWithMeta(meta: meta)
            } else {
                try insertOrReplaceFilterWith(meta: meta)
            }
        }
    }
    
    func updateFilterWithMeta(meta: ExtendedFilterMetaProtocol) throws {
        // Query: UPDATE filters SET (filter_id, group_id, is_enabled, version, last_update_time, editable, display_number, name, description, homepage, removable, expires, subscriptionUrl) WHERE filter_id = meta.filterId
        let query = FiltersTable.table.where(FiltersTable.filterId == meta.filterId).update(getSettersFrom(meta: meta))
        try filtersDb.run(query)
        try deleteAllLangsForFilter(withId: meta.filterId)
        try insertOrReplaceLangsIntoFilter(langs: meta.languages, forFilterId: meta.filterId)
        try insertOrReplaceTagsForFilter(withId: meta.filterId, tags: meta.tags)
        Logger.logInfo("(FiltersMetaStorage) - Filter was updated with id \(meta.filterId)")
    }
    
    func insertOrReplaceFilterWith(meta: ExtendedFilterMetaProtocol) throws {
        var setters = getSettersFrom(meta: meta)
        setters.append(FiltersTable.isEnabled <- false)
        setters.append(FiltersTable.editable <- meta.filterId == 0)  //filterId == 0 it is custom filter id
        setters.append(FiltersTable.removable <- meta.filterId != 0)
        // Query: INSERT OR REPLACE INTO "filters" (filter_id, group_id, is_enabled, version, last_update_time, editable, display_number, name, description, homepage, removable, expires, subscriptionUrl)
        let query = FiltersTable.table.insert(or: .replace, setters)
        try filtersDb.run(query)
        Logger.logInfo("(FiltersMetaStorage) - Filter was added with id \(meta.filterId)")
    }
    
    private func getSettersFrom(meta: ExtendedFilterMetaProtocol) -> [Setter] {
        var result = [Setter]()
    
        result.append(FiltersTable.filterId <- meta.filterId)
        result.append(FiltersTable.groupId <- meta.group.groupId)
        
        if let version = meta.version {
            result.append(FiltersTable.version <- version)
        }
        
        result.append(FiltersTable.displayNumber <- meta.displayNumber)
        
        if let name = meta.name {
            result.append(FiltersTable.name <- name)
        }
        
        if let description = meta.description {
            result.append(FiltersTable.description <- description)
        }
        
        if let homePage = meta.homePage {
            result.append(FiltersTable.homePage <- homePage)
        }
        
        if let lastUpdateTime = meta.lastUpdateDate {
            result.append(FiltersTable.lastUpdateTime <- lastUpdateTime)
        }
        
        if let expires = meta.updateFrequency {
            result.append(FiltersTable.expires <- expires)
        }

        if let subscriptionUrl = meta.filterDownloadPage {
            result.append(FiltersTable.subscriptionUrl <- subscriptionUrl)
        }
        
        return result
    }
}
