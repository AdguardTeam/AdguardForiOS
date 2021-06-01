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
    let lastUpdateTime: Date?
    let lastCheckTime: Date?
    let editable: Bool
    let displayNumber: Int
    let name: String
    let description: String
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

// MARK: - FiltersMetaStorageProtocol + Filters methods

extension FiltersMetaStorageProtocol {
    
    // Returns all filters from database with localizations for specified group and language
    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable] {
        // Query: select * from filters where group_id = id order by display_number, filter_id
        let query = FiltersTable.table.filter(FiltersTable.groupId == id).order(FiltersTable.displayNumber, FiltersTable.filterId)
        let dbFilters: [FiltersTable] = try filtersDb.prepare(query).map { dbFilter in
            let filter = FiltersTable(dbFilter: dbFilter)
            let filterLocalization = getLocalizationForFilter(withId: filter.filterId, forLanguage: lang)
            let name = filterLocalization?.name ?? filter.name
            let description = filterLocalization?.description ?? filter.description
            return FiltersTable(dbFilter: dbFilter, localizedName: name, localizedDescription: description)
        }
        Logger.logDebug("(FiltersMetaStorage) - getLocalizedFiltersForGroup with id=\(id); lang=\(lang); return \(dbFilters.count) objects")
        return dbFilters
    }
    
    // Enables or disables a filter with specified id
    func setFilter(withId id: Int, enabled: Bool) throws {
        // Query: update filters set is_enabled = enabled where filter_id = id
        let filter = FiltersTable.table.filter(FiltersTable.filterId == id)
        try filtersDb.run(filter.update(FiltersTable.isEnabled <- enabled))
        Logger.logDebug("(FiltersMetaStorage) - setFilter filter with id=\(id) was set to enabled=\(enabled)")
    }
}
