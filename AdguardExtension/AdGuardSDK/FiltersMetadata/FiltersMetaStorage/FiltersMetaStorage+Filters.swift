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
struct FiltersTable {
    // Properties from table
    let filterId: Int
    let groupId: Int
    let isEnabled: Bool
    let version: String?
    let lastUpdateTime: Date? // TODO: - Looks like this property is useless
    let lastCheckTime: Date? // TODO: - Looks like this property is useless
    let editable: Bool
    let displayNumber: Int
    let name: String
    let description: String
    let homePage: String?
    let removable: Bool
    let expires: Int? // TODO: - Looks like this property is useless
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
    
    // Localized initializer
    init(dbFilter: Row, localizedName: String, localizedDescription: String) {
        self.filterId = dbFilter[FiltersTable.filterId]
        self.groupId = dbFilter[FiltersTable.groupId]
        self.isEnabled = dbFilter[FiltersTable.isEnabled]
        self.version = dbFilter[FiltersTable.version]
        self.lastUpdateTime = dbFilter[FiltersTable.lastUpdateTime]
        self.lastCheckTime = dbFilter[FiltersTable.lastCheckTime]
        self.editable = dbFilter[FiltersTable.editable]
        self.displayNumber = dbFilter[FiltersTable.displayNumber]
        self.name = localizedName
        self.description = localizedDescription
        self.homePage = dbFilter[FiltersTable.homePage]
        self.removable = dbFilter[FiltersTable.removable]
        self.expires = dbFilter[FiltersTable.expires]
        self.subscriptionUrl = dbFilter[FiltersTable.subscriptionUrl]
    }
    
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

// MARK: - ExtendedFilterMetaProtocol + Setters

fileprivate extension ExtendedFilterMetaProtocol {
    func getDbSetters(isEnabled: Bool?) -> [Setter] {
        var sttrs: [Setter] = [FiltersTable.filterId <- self.filterId,
                               FiltersTable.groupId <- self.group.groupId,
                               FiltersTable.displayNumber <- self.displayNumber]
        
        if let isEnabled = isEnabled {
            sttrs.append(FiltersTable.isEnabled <- isEnabled)
        }
        if let version = self.version {
            sttrs.append(FiltersTable.version <- version)
        }
        if let name =  self.name {
            sttrs.append(FiltersTable.name <- name)
        }
        if let description = self.description {
            sttrs.append(FiltersTable.description <- description)
        }
        if let homePage = self.homePage {
            sttrs.append(FiltersTable.homePage <- homePage)
        }
        if let expires = self.updateFrequency {
            sttrs.append(FiltersTable.expires <- expires)
        }
        if let subscriptionUrl = self.filterDownloadPage {
            sttrs.append(FiltersTable.subscriptionUrl <- subscriptionUrl)
        }
        
        return sttrs
    }
}

// MARK: - FiltersMetaStorageProtocol + Filters methods

extension FiltersMetaStorageProtocol {
    
    // Checks existing filter id and returns new unique id for custom filter
    var nextCustomFilterId: Int {
        // Query: SELECT max(filter_id) FROM filters
        if let maxId = try? filtersDb.scalar(FiltersTable.table.select(FiltersTable.filterId.max)) {
            return max(maxId, CustomFilterMeta.baseCustomFilterId) + 1
        } else {
            return CustomFilterMeta.baseCustomFilterId
        }
    }
    
    // Returns all filters from database with localizations for specified group and language
    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable] {
        // Query: select * from filters where group_id = id order by display_number, filter_id
        let query = FiltersTable.table.filter(FiltersTable.groupId == id).order(FiltersTable.displayNumber, FiltersTable.filterId)
        let dbFilters: [FiltersTable] = try filtersDb.prepare(query).map { dbFilter in
            let filter = FiltersTable(dbFilter: dbFilter)
            let filterLocalization = try getLocalizationForFilter(withId: filter.filterId, forLanguage: lang)
            let name = filterLocalization?.name ?? filter.name
            let description = filterLocalization?.description ?? filter.description
            return FiltersTable(dbFilter: dbFilter, localizedName: name, localizedDescription: description)
        }
        Logger.logDebug("(FiltersMetaStorage) - getLocalizedFiltersForGroup with id=\(id); lang=\(lang); return \(dbFilters.count) objects")
        return dbFilters
    }
    
    // Enables or disables a filter with specified id
    func setFilter(withId id: Int, enabled: Bool) throws {
        let query = FiltersTable.table.where(FiltersTable.filterId == id).update(FiltersTable.isEnabled <- enabled)
        //Query: UPDATE "filters" SET "is_enabled" = enabled WHERE ("filter_id" = filterId)
        let rowId = try filtersDb.run(query)
        Logger.logInfo("(FiltersMetaStorage) - Filter enabled state with filter Id \(rowId) was updated to state \(enabled)")
    }
    
    /*
     Updates all passed filters.
     Adds new filter if missing.
     If there are some filters from database that are not present in passed list than they will be deleted
     */
    func updateAll(filters: [ExtendedFilterMetaProtocol]) throws {
        for filter in filters {
            /*
             Check if filter exists
             If true than update filter with new data otherwise create it
            */
            let selectQuery = FiltersTable.table.where(FiltersTable.filterId == filter.filterId)
            if let _ = try filtersDb.pluck(selectQuery) {
                try update(filter: filter)
            } else {
                try add(filter: filter, enabled: true)
            }
        }
        
        // Remove filters and associated data
        let filterIds = filters.map { $0.filterId }
        let filterIdsToDeleteQuery = FiltersTable.table.filter(!filterIds.contains(FiltersTable.filterId))
        let filterIdsToDeleteResult = try filtersDb.prepare(filterIdsToDeleteQuery)
        let filterIdsToDelete = filterIdsToDeleteResult.map { $0[FiltersTable.filterId] }
        try deleteFilters(withIds: filterIdsToDelete)
    }
    
    // Updates filter with passed meta
    func update(filter: ExtendedFilterMetaProtocol) throws {
        // Query: UPDATE filters SET (filter_id, group_id, is_enabled, version, last_update_time, editable, display_number, name, description, homepage, removable, expires, subscriptionUrl) WHERE filter_id = meta.filterId
        let query = FiltersTable.table.where(FiltersTable.filterId == filter.filterId).update(filter.getDbSetters(isEnabled: nil))
        try filtersDb.run(query)
        Logger.logInfo("(FiltersMetaStorage) - Filter was updated with id \(filter.filterId)")
    }
    
    // Creates filter with passed meta
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws {
        // Query: INSERT OR REPLACE INTO "filters" (filter_id, group_id, is_enabled, version, last_update_time, editable, display_number, name, description, homepage, removable, expires, subscriptionUrl)
        let query = FiltersTable.table.insert(or: .replace, filter.getDbSetters(isEnabled: enabled))
        try filtersDb.run(query)
        Logger.logInfo("(FiltersMetaStorage) - Filter was added with id \(filter.filterId)")
    }
    
    // Deletes filter and all data associated with it
    func deleteFilter(withId id: Int) throws {
        try deleteFilters(withIds: [id])
    }
    
    // Deletes filters and all data associated with them
    func deleteFilters(withIds ids: [Int]) throws {
        let filtersToDelete = FiltersTable.table.filter(ids.contains(FiltersTable.filterId))
        let deletedRows = try filtersDb.run(filtersToDelete.delete())
        Logger.logDebug("(FiltersMetaStorage) - deleteFilters; deleted \(deletedRows) filters")
        
        try deleteLangsForFilters(withIds: ids)
        try deleteTagsForFilters(withIds: ids)
        try deleteAllLocalizationForFilters(withIds: ids)
    }
    
    func renameFilter(withId id: Int, name: String) throws {
        // Query: UPDATE filters SET (name) WHERE filter_id = id
        let query = FiltersTable.table.where(FiltersTable.filterId == id).update(FiltersTable.name <- name)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - renameCustomFilterName; updated name for filter with id \(id) with name \(name)")
    }
}
