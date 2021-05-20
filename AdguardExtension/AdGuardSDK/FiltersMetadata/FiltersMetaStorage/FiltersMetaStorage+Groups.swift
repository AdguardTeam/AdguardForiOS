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
        // Query: select * from filter_groups order by display_number, group_id
        let query = FilterGroupsTable.table.select([])
                                           .order(FilterGroupsTable.displayNumber, FilterGroupsTable.groupId)
        
        let result: [ExtendedGroupMeta] = try filtersDb.prepare(query).map { group in
            let dbGroup = FilterGroupsTable(dbGroup: group)
            return ExtendedGroupMeta(groupId: dbGroup.groupId, groupName: dbGroup.name ?? "", displayNumber: dbGroup.displayNumber, isEnabled: dbGroup.isEnabled)
        }
        Logger.logDebug("(FiltersMetaStorage) - allGroups returning \(result.count) groups objects")
        return result
    }
    
    // Returns all groups with localization for specified language from database
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [ExtendedGroupMetaProtocol] {
        // Query: select * from filter_groups order by display_number, group_id
        let query = FilterGroupsTable.table.select([])
                                           .order(FilterGroupsTable.displayNumber, FilterGroupsTable.groupId)
        
        let result: [ExtendedGroupMeta] = try filtersDb.prepare(query).map { group in
            let dbGroup = FilterGroupsTable(dbGroup: group)
            let localizedName = getLocalizationForGroup(withId: dbGroup.groupId, forLanguage: lang).name
            return ExtendedGroupMeta(groupId: dbGroup.groupId, groupName: localizedName, displayNumber: dbGroup.displayNumber, isEnabled: dbGroup.isEnabled)
        }
        Logger.logDebug("(FiltersMetaStorage) - getAllLocalizedGroups returning \(result.count) groups objects for lang=\(lang)")
        return result
    }
    
    // Enables or disables a group with specified id
    func setGroup(withId id: Int, enabled: Bool) throws {
        let group = FilterGroupsTable.table.filter(FilterGroupsTable.groupId == id)
        
    }
}
