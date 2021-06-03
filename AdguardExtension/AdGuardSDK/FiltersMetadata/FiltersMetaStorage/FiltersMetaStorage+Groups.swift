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

// MARK: - ExtendedGroupMeta

protocol ExtendedGroupMetaProtocol: GroupMetaProtocol {
    var isEnabled: Bool { get }
}

struct ExtendedGroupMeta: ExtendedGroupMetaProtocol {
    let groupId: Int
    let groupName: String
    let displayNumber: Int
    var isEnabled: Bool

    init(groupId: Int, groupName: String, displayNumber: Int, isEnabled: Bool) {
        self.groupId = groupId
        self.groupName = groupName
        self.displayNumber = displayNumber
        self.isEnabled = isEnabled
    }
}

/* FilterGroupsTable; filter_groups table */
fileprivate struct FilterGroupsTable {
    // Properties from table
    let groupId: Int
    let name: String?
    let displayNumber: Int
    let isEnabled: Bool
    
    // Table name
    static let table = Table("filter_groups")
    
    // Columns names
    static let groupId = Expression<Int>("group_id")
    static let name = Expression<String>("name")
    static let displayNumber = Expression<Int>("display_number")
    static let isEnabled = Expression<Bool>("is_enabled")
    
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
    
    // Returns all groups from database
    func getAllGroups() throws -> [ExtendedGroupMetaProtocol] {
        // Query: SELECT * FROM filter_groups ORDER BY display_number, group_id
        let query = FilterGroupsTable.table.order(FilterGroupsTable.displayNumber, FilterGroupsTable.groupId)
        
        let result: [ExtendedGroupMeta] = try filtersDb.prepare(query).map { group in
            let dbGroup = FilterGroupsTable(dbGroup: group)
            return ExtendedGroupMeta(groupId: dbGroup.groupId, groupName: dbGroup.name ?? "", displayNumber: dbGroup.displayNumber, isEnabled: dbGroup.isEnabled)
        }
        Logger.logDebug("(FiltersMetaStorage) - allGroups returning \(result.count) groups objects")
        return result
    }
    
    // Returns all groups with localization for specified language from database
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [ExtendedGroupMetaProtocol] {
        // Query: SELECT * FROM filter_groups ORDER BY display_number, group_id
        let query = FilterGroupsTable.table.order(FilterGroupsTable.displayNumber, FilterGroupsTable.groupId)
        
        let result: [ExtendedGroupMeta] = try filtersDb.prepare(query).compactMap { group in
            let dbGroup = FilterGroupsTable(dbGroup: group)
            
            /*
                If there is no localized group name we trying to get default english localization and if it is steel nil return nil
             */
            var localizedName = try getLocalizationForGroup(withId: dbGroup.groupId, forLanguage: lang)?.name
            if localizedName == nil && lang != FiltersMetaStorage.defaultDbLanguage  {
                localizedName = try getLocalizationForGroup(withId: dbGroup.groupId, forLanguage: lang)?.name
            }
            guard let name = localizedName else { return nil }
            
            return ExtendedGroupMeta(groupId: dbGroup.groupId, groupName: name, displayNumber: dbGroup.displayNumber, isEnabled: dbGroup.isEnabled)
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
    
    //TODO: Remove this method if it would not be used
    func insertOrReplaceGroups(groups: [ExtendedGroupMetaProtocol]) throws {
        for group in groups {
            // Query: INSERT OR REPLACE INTO filter_groups (group_id, display_number, name, is_enabled)
            let query = FilterGroupsTable.table.insert(or: .replace,
                                                       FilterGroupsTable.groupId <- group.groupId,
                                                       FilterGroupsTable.name <- group.groupName,
                                                       FilterGroupsTable.displayNumber <- group.displayNumber,
                                                       FilterGroupsTable.isEnabled <- group.isEnabled)
            try filtersDb.run(query)
            Logger.logDebug("(FiltersMetaStorage) - Insert group with id=\(group.groupId)")
        }
    }
    
    //TODO: Remove this method if it would not be used
    func updateGroup(oldGroupId: Int, newGroup: ExtendedGroupMetaProtocol) throws {
        // Query: UPDATE filter_groups SET name = newGroup.groupName, display_number = newGroup.displayNumber, is_enabled = newGroup.isEnabled) WHERE group_id = oldGroupId
        let query = FilterGroupsTable.table.where(FilterGroupsTable.groupId == oldGroupId)
            .update(FilterGroupsTable.name <- newGroup.groupName,
                    FilterGroupsTable.displayNumber <- newGroup.displayNumber,
                    FilterGroupsTable.isEnabled <- newGroup.isEnabled)
        
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Update group with id=\(newGroup.groupId)")
    }
    
    //TODO: Remove this method if it would not be used
    func deleteGroup(groupId: Int) throws {
        // Query: DELETE FROM filter_groups WHERE grpoup_id = groupId
        let query = FilterGroupsTable.table.where(FilterGroupsTable.groupId == groupId).delete()
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Delete group with id=\(groupId)")
    }
}
