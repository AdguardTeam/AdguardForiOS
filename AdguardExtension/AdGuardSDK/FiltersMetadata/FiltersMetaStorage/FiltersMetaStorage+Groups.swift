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

/* FilterGroupsTable; filter_groups table */
struct FilterGroupsTable {
    // Properties from table
    let groupId: Int
    let name: String
    let displayNumber: Int
    let isEnabled: Bool
    
    // Table name
    static let table = Table("filter_groups")
    
    // Columns names
    static let groupId = Expression<Int>("group_id")
    static let name = Expression<String>("name")
    static let displayNumber = Expression<Int>("display_number")
    static let isEnabled = Expression<Bool>("is_enabled")
    
    // Localized initializer
    init(dbGroup: Row, localizedName: String) {
        self.groupId = dbGroup[FilterGroupsTable.groupId]
        self.name = localizedName
        self.displayNumber = dbGroup[FilterGroupsTable.displayNumber]
        self.isEnabled = dbGroup[FilterGroupsTable.isEnabled]
    }
    
    // Initializer from DB result
    init(dbGroup: Row) {
        self.groupId = dbGroup[FilterGroupsTable.groupId]
        self.name = dbGroup[FilterGroupsTable.name]
        self.displayNumber = dbGroup[FilterGroupsTable.displayNumber]
        self.isEnabled = dbGroup[FilterGroupsTable.isEnabled]
    }
}

// MARK: - FiltersMetaStorageProtocol + Groups methods

extension FiltersMetaStorageProtocol {
    
    // Returns all groups with localization for specified language from database
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [FilterGroupsTable] {
        // Query: SELECT * FROM filter_groups ORDER BY display_number, group_id
        let query = FilterGroupsTable.table.order(FilterGroupsTable.displayNumber, FilterGroupsTable.groupId)
        
        let result: [FilterGroupsTable] = try filtersDb.prepare(query).compactMap { group in
            let dbGroup = FilterGroupsTable(dbGroup: group)
            
            /* If there is no localized group name we trying to get default english localization and if it is steel nil return nil */
            var localizedName = getLocalizationForGroup(withId: dbGroup.groupId, forLanguage: lang)?.name
            if localizedName == nil && lang != FiltersMetaStorage.defaultDbLanguage  {
                localizedName = getLocalizationForGroup(withId: dbGroup.groupId, forLanguage: lang)?.name
            }
            
            return FilterGroupsTable(dbGroup: group, localizedName: localizedName ?? dbGroup.name)
        }
        Logger.logDebug("(FiltersMetaStorage) - getAllLocalizedGroups returning \(result.count) groups objects for lang=\(lang)")
        return result
    }
    
    // Enables or disables a group with specified id
    func setGroup(withId id: Int, enabled: Bool) throws {
        // Query: UPDATE filter_groups SET is_enabled = enabled WHERE group_id = id
        let query = FilterGroupsTable.table.filter(FilterGroupsTable.groupId == id)
        try filtersDb.run(query.update(FilterGroupsTable.isEnabled <- enabled))
        Logger.logDebug("(FiltersMetaStorage) - setGroup group with id=\(id) was set to enabled=\(enabled)")
    }
    
    /*
     Updates all passed groups.
     Adds new groups if missing.
     If there are some groups from database that are not present in passed list than they will be deleted
     */
    func updateAll(groups: [GroupMetaProtocol]) throws {
        for group in groups {
            try update(group: group)
        }
        
        // Remove groups
        let groupIds = groups.map { $0.groupId }
        let groupsToDelete = FilterGroupsTable.table.filter(!groupIds.contains(FilterGroupsTable.groupId))
        let deletedRows = try filtersDb.run(groupsToDelete.delete())
        Logger.logDebug("(FiltersMetaStorage) - updateAll groups; deleted \(deletedRows) rows")
    }
    
    // Updates group metadata with passed one
    func update(group: GroupMetaProtocol) throws {
        // Query: UPDATE filter_groups SET name = group.groupName, display_number = group.displayNumber) WHERE group_id = group.groupId
        let query = FilterGroupsTable.table.where(FilterGroupsTable.groupId == group.groupId)
                                           .update(FilterGroupsTable.groupId <- group.groupId,
                                                   FilterGroupsTable.name <- group.groupName,
                                                   FilterGroupsTable.displayNumber <- group.displayNumber)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Update group with id=\(group.groupId)")
    }
}
