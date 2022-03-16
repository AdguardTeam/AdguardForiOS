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

typealias MetaStorageTypeAlias = FiltersMetaStorageProtocol
                                & GroupsMetaStorageProtocol
                                & TagsMetaStorageProtocol
                                & LangsMetaStorageProtocol
                                & GroupLocalizationsMetaStorageProtocol
                                & FiltersLocalizationsMetaStorageProtocol

protocol MetaStorageProtocol: MetaStorageTypeAlias, ResetableSyncProtocol, AnyObject {
    static var defaultDbLanguage: String { get }
}

private let LOG = LoggerFactory.getLoggerWrapper(MetaStorage.self)

final class MetaStorage: MetaStorageProtocol {

    // MARK: - Public properties

    static var defaultDbLanguage: String = "en"

    var filtersDb: Connection

    // MARK: - Production DB manager

    private let productionDbManager: ProductionDatabaseManagerProtocol

    // MARK: - Initialization

    init(productionDbManager: ProductionDatabaseManagerProtocol) {
        self.productionDbManager = productionDbManager
        self.filtersDb = productionDbManager.filtersDb
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // TODO: - It's a crutch; Refactor it later
        // This database is used by several threads at the same time.
        // It is possible that a database file is temporarily locked in one thread and is being accessed from another.
        // Here we set a timeout and `busyHadler` to resolve this issue
        // `busyHandler` is needed to handle error when db is locked and try once more
        self.filtersDb.busyTimeout = 5
        self.filtersDb.busyHandler { _ in
            LOG.error("Safari filters db is locked")
            return true
        }
        insertCustomGroupIfNeeded()
    }

    func reset() throws {
        LOG.info("Reset start")

        try productionDbManager.reset()
        filtersDb = productionDbManager.filtersDb

        LOG.info("Successfully reset adguard.db reinitialize Connection object now")
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
                              FilterGroupsTable.name <- "Custom",
                              FilterGroupsTable.displayNumber <- 8,
                              FilterGroupsTable.isEnabled <- false)
            try filtersDb.run(insertionQuery)
        } catch {
            LOG.error("Custom group insertion error: \(error)")
        }
    }
}
