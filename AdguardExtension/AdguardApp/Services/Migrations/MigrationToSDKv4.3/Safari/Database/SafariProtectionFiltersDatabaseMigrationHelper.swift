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

protocol SafariProtectionFiltersDatabaseMigrationHelperProtocol: AnyObject {
    /// Returns all groups with states from old DB
    func getGroupsStates() throws -> [(groupId: Int, isEnabled: Bool)]

    /// Returns all filters with states from old DB
    func getFiltersStates() throws -> [(filterId: Int, groupId: Int, isEnabled: Bool)]

    /// Returns all user rules objects  from old DB
    func getUserRules() throws -> [SDKSafariMigrationRule]

    /// Returns all custom filters objects  from old DB
    func getCustomFilters() throws -> [SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter]

    /// Removes old db files
    func removeOldDBFiles() throws
}

/// This object is a helper for `SDKMigrationServiceHelper`
/// It is a wrapper for old `adguard.db` database
/// And is responsible for providing user rules, custom filters rules and meta, filters and groups enabled states and removing obsolete db files
final class SafariProtectionFiltersDatabaseMigrationHelper: SafariProtectionFiltersDatabaseMigrationHelperProtocol {

    // MARK: - Private properties

    private let oldAdguardDB: Connection

    /* Paths to old database files */
    private let oldAdguardDBFilePath: String
    private let oldDefaultDBFilePath: String

    private let baseCustomFilterId = 10_000
    private let baseUserRulesGroupId = 0
    private let baseUserRulesFilterId = 0

    private let fileManager = FileManager.default

    // MARK: - Initialization

    init(
        oldAdguardDBFilePath: String,
        oldDefaultDBFilePath: String
    ) throws {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.oldAdguardDB = try Connection(oldAdguardDBFilePath, readonly: true)
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Connection with old AdGuard DB established")

        self.oldAdguardDBFilePath = oldAdguardDBFilePath
        self.oldDefaultDBFilePath = oldDefaultDBFilePath
    }

    // MARK: - Internal methods

    func getGroupsStates() throws -> [(groupId: Int, isEnabled: Bool)] {
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetching data from filter_groups table")

        // Query: SELECT group_id, is_enabled FROM filter_groups
        let query = FilterGroupsTable.table.select(FilterGroupsTable.groupId, FilterGroupsTable.isEnabled)
        let groupIds: [(groupId: Int, isEnabled: Bool)] = try oldAdguardDB.prepare(query).compactMap { dbGroup in
            let table = FilterGroupsTable(dbGroup: dbGroup)
            if table.groupId == baseUserRulesGroupId { return nil }

            return (groupId: table.groupId, isEnabled: table.isEnabled )
        }

        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetched from filter_groups table \(groupIds.count) groups")
        return groupIds
    }

    func getFiltersStates() throws -> [(filterId: Int, groupId: Int, isEnabled: Bool)] {
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetching data from filters table")

        // Query: SELECT * FROM filters
        let query = FiltersTable.table
        let filterIds: [(filterId: Int, groupId: Int, isEnabled: Bool)] = try oldAdguardDB.prepare(query).compactMap { dbFilter in
            let table = FiltersTable(dbFilter: dbFilter)
            if table.filterId == baseUserRulesFilterId || table.groupId == baseUserRulesGroupId { return nil }

            return (filterId: table.filterId, groupId: table.groupId, isEnabled: table.isEnabled)
        }

        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetched from filters table \(filterIds.count) filters")
        return filterIds
    }

    func getUserRules() throws -> [SDKSafariMigrationRule] {
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetching data from filter_rules table")

        // Query: SELECT * FROM filter_rules WHERE filter_id == baseUserRulesFilterId
        let query = FilterRulesTable.table.where(FilterRulesTable.filterId == baseUserRulesFilterId)
        let userRulesMeta: [ObsoleteFilterRules] = try oldAdguardDB.prepare(query).map { dbRule in
            let filterRulesTable = FilterRulesTable(dbFilterRule: dbRule)
            return ObsoleteFilterRules(from: filterRulesTable)
        }

        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetched from filter_rules table \(userRulesMeta.count) user rules meta")
        return userRulesMeta
    }

    func getCustomFilters() throws -> [ObsoleteCustomFilter] {
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetching data from filter_rules table")

        // SELECT * FROM filters WHERE (filter_id >= baseCustomFilterId)
        let queryCustomFilters = FiltersTable.table.where(FiltersTable.filterId >= baseCustomFilterId)

        let customFiltersFromDb = try oldAdguardDB.prepare(queryCustomFilters).map { row in
            return FiltersTable(dbFilter: row)
        }
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetched from filters table \(customFiltersFromDb.count) custom filters")

        return try customFiltersFromDb.map { customFilter in
            // SELECT * FROM filter_rules WHERE (filter_id == customFilter.filterId)
            let queryFilterRules = FilterRulesTable.table.where(FilterRulesTable.filterId == customFilter.filterId)

            let customFilterRules: [ObsoleteFilterRules] = try oldAdguardDB.prepare(queryFilterRules).map { row in
                let filterRulesTable = FilterRulesTable(dbFilterRule: row)
                return ObsoleteFilterRules(from: filterRulesTable)
            }
            DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Fetched \(customFilterRules.count) rules for custom filter with id=\(customFilter.filterId)")

            return ObsoleteCustomFilter(from: customFilter, rules: customFilterRules)
        }
    }

    func removeOldDBFiles() throws {
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Removing old DB files")
        try fileManager.removeItem(atPath: oldAdguardDBFilePath)
        try fileManager.removeItem(atPath: oldDefaultDBFilePath)
        DDLogInfo("(SafariProtectionFiltersDatabaseMigrationHelper) - Removed old DB files")
    }
}

// MARK: - SQLite library wrappers to retreive objects from obsolete database

extension SafariProtectionFiltersDatabaseMigrationHelper {

    /* SQLite library wrapper for `filter_groups` table */
    fileprivate struct FilterGroupsTable: Equatable {
        // Properties from table
        let groupId: Int
        let isEnabled: Bool

        // Table name
        static let table = Table("filter_groups")

        // Columns names
        static let groupId = Expression<Int>("group_id")
        static let isEnabled = Expression<Bool>("is_enabled")

        // Initializer from DB result
        init(dbGroup: Row) {
            self.groupId = dbGroup[FilterGroupsTable.groupId]
            self.isEnabled = dbGroup[FilterGroupsTable.isEnabled]
        }
    }

    /* SQLite library wrapper for `filter_rules` table */
    fileprivate struct FilterRulesTable: SDKSafariMigrationRule {
        // Properties from table
        let filterId: Int
        let ruleText: String
        let isEnabled: Bool
        let affinity: Int?

        // Table name
        static let table = Table("filter_rules")

        // Columns names
        static let filterId = Expression<Int>("filter_id")
        static let ruleText = Expression<String>("rule_text")
        static let isEnabled = Expression<Bool>("is_enabled")
        static let affinity = Expression<Int?>("affinity")

        // Initializer from DB result
        init(dbFilterRule: Row) {
            self.filterId = dbFilterRule[Self.filterId]
            self.ruleText = dbFilterRule[Self.ruleText]
            self.isEnabled = dbFilterRule[Self.isEnabled]
            self.affinity = dbFilterRule[Self.affinity]
        }
    }

    struct ObsoleteFilterRules: SDKSafariMigrationRule, Equatable {
        let filterId: Int
        let ruleText: String
        let isEnabled: Bool
        let affinity: Int?

        init(filterId: Int, ruleText: String, isEnabled: Bool, affinity: Int?) {
            self.filterId = filterId
            self.ruleText = ruleText
            self.isEnabled = isEnabled
            self.affinity = affinity
        }

        fileprivate init(from migrationRule: SDKSafariMigrationRule) {
            self.filterId = migrationRule.filterId
            self.ruleText = migrationRule.ruleText
            self.isEnabled = migrationRule.isEnabled
            self.affinity = migrationRule.affinity
        }
    }

    /* SQLite library wrapper for `filters` table */
    fileprivate struct FiltersTable: Equatable, Hashable {
        // Properties from table
        let filterId: Int
        let groupId: Int
        let isEnabled: Bool
        let version: String?
        let lastUpdateTime: Date?
        let displayNumber: Int
        let name: String?
        let description: String?
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

        // Initializer from DB result
        init(dbFilter: Row) {
            self.filterId = dbFilter[FiltersTable.filterId]
            self.groupId = dbFilter[FiltersTable.groupId]
            self.isEnabled = dbFilter[FiltersTable.isEnabled]
            self.version = dbFilter[FiltersTable.version]
            self.lastUpdateTime = dbFilter[FiltersTable.lastUpdateTime]
            self.displayNumber = dbFilter[FiltersTable.displayNumber]
            self.name = dbFilter[FiltersTable.name]
            self.description = dbFilter[FiltersTable.description]
            self.homePage = dbFilter[FiltersTable.homePage]
            self.subscriptionUrl = dbFilter[FiltersTable.subscriptionUrl]
        }
    }

    struct ObsoleteCustomFilter: Equatable {
        let filterId: Int
        let groupId: Int
        let isEnabled: Bool
        let version: String?
        let lastUpdateTime: Date?
        let displayNumber: Int
        let name: String?
        let description: String?
        let homePage: String?
        let subscriptionUrl: String?
        let rules: [ObsoleteFilterRules]

        init(filterId: Int, groupId: Int, isEnabled: Bool, version: String?, lastUpdateTime: Date?, displayNumber: Int, name: String, description: String, homePage: String?, subscriptionUrl: String?, rules: [ObsoleteFilterRules]) {
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
            self.rules = rules
        }

        fileprivate init(from filtersTable: FiltersTable, rules: [ObsoleteFilterRules]) {
            self.filterId = filtersTable.filterId
            self.groupId = filtersTable.groupId
            self.isEnabled = filtersTable.isEnabled
            self.version = filtersTable.version
            self.lastUpdateTime = filtersTable.lastUpdateTime
            self.displayNumber = filtersTable.displayNumber
            self.name = filtersTable.name
            self.description = filtersTable.description
            self.homePage = filtersTable.homePage
            self.subscriptionUrl = filtersTable.subscriptionUrl
            self.rules = rules
        }
    }
}
