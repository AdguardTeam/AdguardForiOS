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

import SQLite
import DnsAdGuardSDK

/// This object is a helper for `SDKMigrationServiceHelper`
/// It is responsible for migration dns request statistics and activity statistics
/// And removing obsolete files
protocol DnsStatisticsMigrationHelperProtocol {

    // removes old requst log database. This table only contains the last 1500 requests and we don't need to migrate them.
    func removeOldRequestLogDatabase() throws

    // migrates requests statistics to new database. Adds 'blocked' columm
    func migrateStatistics() throws

    // migrates activity(company) statistics to new database. Adds 'blocked' columm
    func migrateActivity() throws

    // remove old statistics database file.
    func removeOldStatisticsDatabase() throws
}

final class DnsStatisticsMigrationHelper: DnsStatisticsMigrationHelperProtocol {

    private let oldRequestLogUrl: URL
    private let oldStatisticsDbUrl: URL
    private let oldRequestDbJournalUrl: URL
    private let oldStatististicsDbJournalUrl: URL
    private let newStatisticsDbUrl: URL

    init(oldContainerFolderUrl: URL, newContainerDbUrl: URL) {
        self.oldRequestLogUrl = oldContainerFolderUrl.appendingPathComponent("dns-log-records.db")
        self.oldStatisticsDbUrl = oldContainerFolderUrl.appendingPathComponent("dns-statistics.db")
        self.oldRequestDbJournalUrl = oldContainerFolderUrl.appendingPathComponent("dns-log-records.db-journal")
        self.oldStatististicsDbJournalUrl = oldContainerFolderUrl.appendingPathComponent("dns-log-records.db-journal")
        self.newStatisticsDbUrl = newContainerDbUrl.appendingPathComponent("activity_statistics.db")
    }

    func removeOldRequestLogDatabase() throws {
        if FileManager.default.fileExists(atPath: oldRequestLogUrl.path) {
            try FileManager.default.removeItem(at: oldRequestLogUrl)
        }
        if FileManager.default.fileExists(atPath: oldRequestDbJournalUrl.path) {
            try FileManager.default.removeItem(atPath: oldRequestDbJournalUrl.path)
        }
    }

    func migrateStatistics() throws {

        guard FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path) else { return }

        let oldDb = try Connection(oldStatisticsDbUrl.path, readonly: false)
        let newDb = try Connection(newStatisticsDbUrl.path, readonly: false)

        try alterOldTable(db: oldDb, table: DnsStatisticsTable.table)
        try createNewChartTable(db: newDb)

        let records = try readStatistics(db: oldDb)
        try writeStatistics(records, db: newDb)
    }

    func migrateActivity() throws {

        guard FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path) else { return }
        
        let oldDb = try Connection(oldStatisticsDbUrl.path, readonly: false)
        let newDb = try Connection(newStatisticsDbUrl.path, readonly: false)

        try alterOldTable(db: oldDb, table: DnsActivityTable.table)
        try createNewActivityTable(db: newDb)

        let records = try readActivity(db: oldDb)
        try writeActivity(records, db: newDb)
    }

    func removeOldStatisticsDatabase() throws {
        if FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path) {
            try FileManager.default.removeItem(atPath: oldStatisticsDbUrl.path)
        }
        if FileManager.default.fileExists(atPath: oldStatististicsDbJournalUrl.path) {
            try FileManager.default.removeItem(atPath: oldStatististicsDbJournalUrl.path)
        }
    }

    // MARK: private methods

    private func alterOldTable(db: Connection, table: Table) throws {
        try db.run(table.addColumn(Expression<Int>("blocked"), check: nil, defaultValue: 0))
    }

    private func createNewChartTable(db: Connection) throws {
        let query = DnsStatisticsTable.newTable.create(temporary: false, ifNotExists: true) { builder in
            builder.column(DnsStatisticsTable.timeStamp)
            builder.column(DnsStatisticsTable.requests)
            builder.column(DnsStatisticsTable.encrypted)
            builder.column(DnsStatisticsTable.blocked)
            builder.column(DnsStatisticsTable.elapsedSumm)
        }
        try db.run(query)
    }

    private func createNewActivityTable(db: Connection) throws {
        let query = DnsActivityTable.newTable.create(temporary: false, ifNotExists: true) { builder in
            builder.column(DnsActivityTable.timeStamp)
            builder.column(DnsActivityTable.domain)
            builder.column(DnsActivityTable.requests)
            builder.column(DnsActivityTable.encrypted)
            builder.column(DnsActivityTable.blocked)
            builder.column(DnsActivityTable.elapsedSumm)
        }
        try db.run(query)
    }

    private func readStatistics(db: Connection) throws -> [ChartStatisticsRecord] {
        let oldDateFormatter = dateFormatter
        dateFormatter = iso8601Formatter()

        let query = DnsStatisticsTable.table
        let records: [ChartStatisticsRecord] = try db.prepare(query).map {
            ChartStatisticsRecord(dbRecord: $0)
        }

        dateFormatter = oldDateFormatter
        return records
    }

    private func writeStatistics(_ records: [ChartStatisticsRecord], db: Connection) throws {
        guard records.count > 0 else { return }

        let setters: [[Setter]] = records.map { record in
            [DnsStatisticsTable.timeStamp <- record.timeStamp,
             DnsStatisticsTable.requests <- record.requests,
             DnsStatisticsTable.encrypted <- record.encrypted,
             DnsStatisticsTable.blocked <- record.blocked,
             DnsStatisticsTable.elapsedSumm <- record.elapsedSumm]
        }

        let oldDateFormat = dateFormatter.dateFormat
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let addQuery = DnsStatisticsTable.newTable.insertMany(setters)
        try db.run(addQuery)

        dateFormatter.dateFormat = oldDateFormat
    }

    private func readActivity(db: Connection) throws -> [ActivityStatisticsRecord] {
        let oldDateFormatter = dateFormatter
        dateFormatter = iso8601Formatter()

        let query = DnsActivityTable.table
        let records: [ActivityStatisticsRecord] = try db.prepare(query).map {
            ActivityStatisticsRecord(dbRecord: $0)
        }

        dateFormatter = oldDateFormatter
        return records
    }

    private func writeActivity(_ records: [ActivityStatisticsRecord], db: Connection) throws {
        guard records.count > 0 else { return }

        let setters: [[Setter]] = records.map { record in
            [DnsActivityTable.timeStamp <- record.timeStamp,
             DnsActivityTable.domain <- record.domain,
             DnsActivityTable.requests <- record.requests,
             DnsActivityTable.encrypted <- record.encrypted,
             DnsActivityTable.blocked <- record.blocked,
             DnsActivityTable.elapsedSumm <- record.elapsedSumm]
        }

        let oldDateFormat = dateFormatter.dateFormat
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let addQuery = DnsActivityTable.newTable.insertMany(setters)
        try db.run(addQuery)

        dateFormatter.dateFormat = oldDateFormat
    }

    private func iso8601Formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        return formatter
    }
}

fileprivate struct DnsStatisticsTable: Equatable {
    // Table name
    static let table = Table("DnsStatisticsTable")
    static let newTable = Table("chart_statistics_table")

    // Columns names
    static let timeStamp = Expression<Date>("timeStamp")
    static let requests = Expression<Int>("requests")
    static let encrypted = Expression<Int>("encrypted")
    static let blocked = Expression<Int>("blocked")
    static let elapsedSumm = Expression<Int>("elapsedSumm")
}

fileprivate struct DnsActivityTable: Equatable {
    // Table name
    static let table = Table("ActivityStatisticsTable")
    static let newTable = Table("activity_statistics_table")

    // Columns names
    static let timeStamp = Expression<Date>("timeStamp")
    static let domain = Expression<String>("domain")
    static let requests = Expression<Int>("requests")
    static let encrypted = Expression<Int>("encrypted")
    static let blocked = Expression<Int>("blocked")
    static let elapsedSumm = Expression<Int>("elapsedSumm")
}
