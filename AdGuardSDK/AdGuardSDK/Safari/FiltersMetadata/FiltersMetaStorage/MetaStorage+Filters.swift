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

import SharedAdGuardSDK
import SQLite

// MARK: - FiltersMetaStorageProtocol + Filters methods

/* FiltersTable; filters table */
struct FiltersTable: Equatable {
    // Properties from table
    let filterId: Int
    let groupId: Int
    let isEnabled: Bool
    let version: String?
    let lastUpdateTime: Date?
    let displayNumber: Int
    let name: String
    let description: String
    let homePage: String?
    let subscriptionUrl: String?

    // Table name
    static let table = Table("filters")

    // Columns names
    static let filterId = Expression<Int>("filter_id")
    static let groupId = Expression<Int>("group_id")
    static let isEnabled = Expression<Bool>("is_enabled")
    static let version = Expression<String?>("version")
    static let lastUpdateTime = Expression<Date?>("last_update_time")
    static let displayNumber = Expression<Int>("display_number")
    static let name = Expression<String?>("name")
    static let description = Expression<String?>("description")
    static let homePage = Expression<String?>("homepage")
    static let subscriptionUrl = Expression<String?>("subscriptionUrl")

    // Localized initializer
    init(dbFilter: Row, localizedName: String, localizedDescription: String) {
        self.filterId = dbFilter[FiltersTable.filterId]
        self.groupId = dbFilter[FiltersTable.groupId]
        self.isEnabled = dbFilter[FiltersTable.isEnabled]
        self.version = dbFilter[FiltersTable.version]
        self.lastUpdateTime = dbFilter[FiltersTable.lastUpdateTime]
        self.displayNumber = dbFilter[FiltersTable.displayNumber]
        self.name = localizedName
        self.description = localizedDescription
        self.homePage = dbFilter[FiltersTable.homePage]
        self.subscriptionUrl = dbFilter[FiltersTable.subscriptionUrl]
    }

    // Initializer from DB result
    init(dbFilter: Row) {
        self.filterId = dbFilter[FiltersTable.filterId]
        self.groupId = dbFilter[FiltersTable.groupId]
        self.isEnabled = dbFilter[FiltersTable.isEnabled]
        self.version = dbFilter[FiltersTable.version]
        self.lastUpdateTime = dbFilter[FiltersTable.lastUpdateTime]
        self.displayNumber = dbFilter[FiltersTable.displayNumber]
        self.name = dbFilter[FiltersTable.name] ?? ""
        self.description = dbFilter[FiltersTable.description] ?? ""
        self.homePage = dbFilter[FiltersTable.homePage]
        self.subscriptionUrl = dbFilter[FiltersTable.subscriptionUrl]
    }

    // Default initializer
    init(filterId: Int, groupId: Int, isEnabled: Bool, version: String?, lastUpdateTime: Date?, displayNumber: Int, name: String, description: String, homePage: String?, subscriptionUrl: String?) {
        self.filterId = filterId
        self.groupId = groupId
        self.isEnabled = isEnabled
        self.version = version
        self.lastUpdateTime = lastUpdateTime
        self.displayNumber = displayNumber
        self.name = name
        self.description = description
        self.homePage = homePage
        self.subscriptionUrl = subscriptionUrl
    }
}

// MARK: - ExtendedFilterMetaProtocol + Setters

fileprivate extension ExtendedFilterMetaProtocol {
    var updateSetters: [Setter] {
        let sttrs: [Setter] = [
            FiltersTable.groupId <- self.group.groupId,
            FiltersTable.displayNumber <- self.displayNumber,
            FiltersTable.version <- self.version,
            FiltersTable.name <- self.name,
            FiltersTable.description <- self.description,
            FiltersTable.homePage <- self.homePage,
            FiltersTable.subscriptionUrl <- self.filterDownloadPage,
            FiltersTable.lastUpdateTime <- self.lastUpdateDate
        ]
        return sttrs
    }

    func getDbAddSetters(isEnabled: Bool) -> [Setter] {
        var sttrs: [Setter] = updateSetters
        sttrs.append(FiltersTable.filterId <- self.filterId)
        sttrs.append(FiltersTable.isEnabled <- isEnabled)

        return sttrs
    }
}

// MARK: - MetaStorage + Filters
protocol FiltersMetaStorageProtocol {
    var nextCustomFilterId: Int { get }

    func getLocalizedFiltersForGroup(withId id: Int, forSuitableLanguages suitableLanguages: [String]) throws -> [FiltersTable]
    func setFilter(withId id: Int, enabled: Bool) throws
    func update(filter: ExtendedFilterMetaProtocol) throws -> Bool
    func update(filters: [ExtendedFilterMetaProtocol]) throws -> [Int]
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws
    func deleteFilter(withId id: Int) throws
    func deleteFilters(withIds ids: [Int]) throws
    func renameFilter(withId id: Int, name: String) throws
}

private let LOG = LoggerFactory.getLoggerWrapper("MetaStorage+Filters")

extension MetaStorage: FiltersMetaStorageProtocol {

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
    func getLocalizedFiltersForGroup(withId id: Int, forSuitableLanguages suitableLanguages: [String]) throws -> [FiltersTable] {
        let lang = try collectFiltersMetaLocalizationLanguage(from: suitableLanguages)
        // Query: select * from filters where group_id = id order by display_number, filter_id
        let query = FiltersTable.table.filter(FiltersTable.groupId == id).order(FiltersTable.displayNumber, FiltersTable.filterId)
        let dbFilters: [FiltersTable] = try filtersDb.prepare(query).map { dbFilter in
            let filter = FiltersTable(dbFilter: dbFilter)
            let filterLocalization = try getLocalizationForFilter(withId: filter.filterId, forLanguage: lang)
            let name = filterLocalization?.name ?? filter.name
            let description = filterLocalization?.description ?? filter.description
            return FiltersTable(dbFilter: dbFilter, localizedName: name, localizedDescription: description)
        }
        LOG.debug("getLocalizedFiltersForGroup with id=\(id); lang=\(lang); return \(dbFilters.count) objects")
        return dbFilters
    }

    // Enables or disables a filter with specified id
    func setFilter(withId id: Int, enabled: Bool) throws {
        //Query: UPDATE "filters" SET "is_enabled" = enabled WHERE ("filter_id" = filterId)
        let query = FiltersTable.table.where(FiltersTable.filterId == id).update(FiltersTable.isEnabled <- enabled)
        let rowId = try filtersDb.run(query)
        LOG.info("Filter enabled state with filter Id \(rowId) was updated to state \(enabled)")
    }

    /**
     Updates filter with passed meta
     Compares passed filter version and filter version in DB
     If they differ than we update filter and return true
     If they are equal than we don't update filter and return false
     - Returns true if update occured and false otherwise
     */
    func update(filter: ExtendedFilterMetaProtocol) throws -> Bool {
        LOG.debug("UpdateFilter start; Filter id=\(filter.filterId)")


        // Query: SELECT version FROM filters WHERE filter_id = filter.filterId
        let lastUpdateDateQuery = FiltersTable.table.select(FiltersTable.lastUpdateTime).where(FiltersTable.filterId == filter.filterId)

        if let currentFilterLastUpdateDate = try filtersDb.pluck(lastUpdateDateQuery)?.get(FiltersTable.lastUpdateTime) {
            if let newUpdateDate = filter.lastUpdateDate, currentFilterLastUpdateDate == newUpdateDate {
                LOG.info("Update ended with reason: New meta update date is the same as current meta update date")
                return false
            }
        }

        // Query: UPDATE filters SET (group_id, version, last_update_time, display_number, name, description, homepage, subscriptionUrl) WHERE filter_id = filter.filterId
        let query = FiltersTable.table
                                .where(FiltersTable.filterId == filter.filterId)
                                .update(filter.updateSetters)

        try filtersDb.run(query)
        LOG.info("Filter was updated with id \(filter.filterId)")
        return true
    }

    /**
     Updates meta for passed filters if needed
     Checks filter version for every filter and decides whether to update filter or not
     - Returns array of filter ids that were updated
     */
    func update(filters: [ExtendedFilterMetaProtocol]) throws -> [Int] {
        LOG.debug("updateFilters start; Filters number = \(filters.count)")
        return try filters.compactMap {
            let wasUpdated = try update(filter: $0)
            return wasUpdated ? $0.filterId : nil
        }
    }

    // Creates filter with passed meta
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws {
        // Query: INSERT OR REPLACE INTO "filters" (filter_id, group_id, is_enabled, version, last_update_time, display_number, name, description, homepage, subscriptionUrl)
        let query = FiltersTable.table.insert(or: .replace, filter.getDbAddSetters(isEnabled: enabled))
        try filtersDb.run(query)
        LOG.info("Filter was added with id \(filter.filterId)")
    }

    // Deletes filter and all data associated with it
    func deleteFilter(withId id: Int) throws {
        try deleteFilters(withIds: [id])
    }

    // Deletes filters and all data associated with them
    func deleteFilters(withIds ids: [Int]) throws {
        let filtersToDelete = FiltersTable.table.filter(ids.contains(FiltersTable.filterId))
        let deletedRows = try filtersDb.run(filtersToDelete.delete())
        LOG.debug("deleted \(deletedRows) filters")

        try deleteLangsForFilters(withIds: ids)
        try deleteTagsForFilters(withIds: ids)
        try deleteAllLocalizationForFilters(withIds: ids)
    }

    func renameFilter(withId id: Int, name: String) throws {
        // Query: UPDATE filters SET (name) WHERE filter_id = id
        let query = FiltersTable.table.where(FiltersTable.filterId == id).update(FiltersTable.name <- name)
        try filtersDb.run(query)
        LOG.debug("Updated name for filter with id \(id) with name \(name)")
    }
}
