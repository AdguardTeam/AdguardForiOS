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

typealias MetaStorageTypeAlias = FiltersMetaStorageProtocol&
    GroupsMetaStorageProtocol &
    TagsMetaStorageProtocol &
    LangsMetaStorageProtocol &
    GroupLocalizationsMetaStorageProtocol &
    FiltersLocalizationsMetaStorageProtocol

protocol MetaStorageProtocol: MetaStorageTypeAlias, AnyObject {
    static var defaultDbLanguage: String { get }
    var filtersDb: Connection { get }
}

final class MetaStorage: MetaStorageProtocol {
    // MARK: - Public properties
    static var defaultDbLanguage: String = "en"
    
    let filtersDb: Connection
    
    // MARK: - Initialization
    
    init(productionDbManager: ProductionDatabaseManagerProtocol) {
        self.filtersDb = productionDbManager.filtersDb
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        insertCustomGroupIfNeeded()
    }
    
    /*
     We don't store custom group and localization in default DB.
     If custom group not exists in production DB we should insert custom group with default localization
     */
    
    private func insertCustomGroupIfNeeded() {
        do {
            //Query: SELECT count(*) FROM filters_group WHERE group_id = SafariGroup.GroupType.custom
            let count = try filtersDb
                .scalar(FilterGroupsTable.table.select(FilterGroupsTable.groupId.count)
                            .where(FilterGroupsTable.groupId == SafariGroup.GroupType.custom.rawValue))
            if count > 0 { return }
            //Query: INSERT INTO filter_groups (\"group_id\", \"name\") VALUES (SafariGroup.GroupType.custom, \'Custom\')"
            let insertionQuery = FilterGroupsTable
                .table.insert(FilterGroupsTable.groupId <- SafariGroup.GroupType.custom.rawValue,
                              FilterGroupsTable.name <- "Custom")
            try filtersDb.run(insertionQuery)
        } catch {
            Logger.logError("Custom group insertion error: \(error)")
        }
    }
}
