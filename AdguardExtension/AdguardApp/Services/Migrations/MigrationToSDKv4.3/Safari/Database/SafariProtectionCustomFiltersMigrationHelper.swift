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
import SafariAdGuardSDK

protocol SafariProtectionCustomFiltersMigrationHelperProtocol: AnyObject {
    /// Saves custom filter meta to db and filter content to file
    func migrateCustomFilters(_ filters: [SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter]) throws
}

/// This object is a helper for `SDKMigrationServiceHelper`
/// It is responsible for migrating custom filters
/// It saves custom filter meta to db and filter content to file
final class SafariProtectionCustomFiltersMigrationHelper: SafariProtectionCustomFiltersMigrationHelperProtocol {

    private let newAdguardDB: Connection
    private let filtersDirectoryUrl: URL

    init(newDBFilePath: String, filtersDirectoryUrl: URL) throws {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.newAdguardDB = try Connection(newDBFilePath, readonly: false)
        self.filtersDirectoryUrl = filtersDirectoryUrl
    }

    func migrateCustomFilters(_ filters: [SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter]) throws {
        try filters.forEach { try addCustomFilterToDb($0) }

        for filter in filters {
            let customFilterText = getCustomFilterText(from: filter.rules)
            let customFilterUrl = filtersDirectoryUrl.appendingPathComponent("\(filter.filterId).txt")
            try customFilterText.write(to: customFilterUrl, atomically: true, encoding: .utf8)
        }
    }

    private func addCustomFilterToDb(_ filter: SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter) throws {
        let setters: [Setter] = [
            FiltersTable.groupId <- filter.groupId,
            FiltersTable.filterId <- filter.filterId,
            FiltersTable.isEnabled <- filter.isEnabled,
            FiltersTable.displayNumber <- filter.displayNumber,
            FiltersTable.version <- filter.version,
            FiltersTable.name <- filter.name,
            FiltersTable.description <- filter.description,
            FiltersTable.homePage <- filter.homePage,
            FiltersTable.expires <- nil,
            FiltersTable.subscriptionUrl <- filter.subscriptionUrl
        ]

        // Query: INSERT OR REPLACE INTO "filters" (filter_id, group_id, is_enabled, version, last_update_time, editable, display_number, name, description, homepage, removable, expires, subscriptionUrl)
        let query = FiltersTable.table.insert(or: .replace, setters)
        try newAdguardDB.run(query)
    }

    private func getCustomFilterText(from filterRules: [SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteFilterRules]) -> String {
        var ruleText: String = ""
        let lastElementIndex = filterRules.count - 1

        for (index, content) in filterRules.enumerated() {
            if let affinityInt = content.affinity {
                let affinity = Affinity(rawValue: UInt8(affinityInt))
                ruleText += AffinityRulesParser.rule(content.ruleText, withAffinity: affinity)
            } else {
                ruleText += content.ruleText
            }

            if index != lastElementIndex {
                ruleText += "\n"
            }
        }

        return ruleText
    }
}

// MARK: - Wrapper for DB table

fileprivate extension SafariProtectionCustomFiltersMigrationHelper {
    /* SQLite library wrapper for `filters` table */
    struct FiltersTable: Equatable {
        let filterId: Int
        let groupId: Int
        let isEnabled: Bool
        let version: String?
        let lastUpdateTime: Date? // TODO: - Don't forget to remove it if removed in SDK
        let lastCheckTime: Date? // TODO: - Don't forget to remove it if removed in SDK
        let editable: Bool
        let displayNumber: Int
        let name: String
        let description: String
        let homePage: String?
        let removable: Bool
        let expires: Int? // TODO: - Don't forget to remove it if removed in SDK
        let subscriptionUrl: String?

        // Table name
        static let table = Table("filters")

        // Columns names
        static let filterId = Expression<Int>("filter_id")
        static let groupId = Expression<Int>("group_id")
        static let isEnabled = Expression<Bool>("is_enabled")
        static let version = Expression<String?>("version")
        static let lastUpdateTime = Expression<Date?>("last_update_time")
        static let lastCheckTime = Expression<Date?>("last_check_time")
        static let editable = Expression<Bool>("editable")
        static let displayNumber = Expression<Int>("display_number")
        static let name = Expression<String?>("name")
        static let description = Expression<String?>("description")
        static let homePage = Expression<String?>("homepage")
        static let removable = Expression<Bool>("removable")
        static let expires = Expression<Int?>("expires")
        static let subscriptionUrl = Expression<String?>("subscriptionUrl")
    }
}
