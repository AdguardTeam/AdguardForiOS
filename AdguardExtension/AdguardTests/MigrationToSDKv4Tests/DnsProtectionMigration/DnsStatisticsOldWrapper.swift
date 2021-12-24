import Foundation
import SQLite

/// This object is a helper for SDK migraitons test
/// It is responsible for creating tables that were used in app 4.2 and earlier
final class DnsStatisticsDbWrapper {

    private let oldDnsStatisticsTableUrl: URL
    private let newChartStatisticsUrl: URL

    init(oldDnsStatisticsTableUrl: URL, newChartStatisticsUrl: URL) {
        self.oldDnsStatisticsTableUrl = oldDnsStatisticsTableUrl
        self.newChartStatisticsUrl = newChartStatisticsUrl
    }

    func createOldDnsStatisticsTable() throws {
        let db = try Connection(oldDnsStatisticsTableUrl.path, readonly: false)
        try db.run("""
            CREATE TABLE IF NOT EXISTS DnsStatisticsTable (
                timeStamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP PRIMARY KEY,
                requests INTEGER NOT NULL DEFAULT 0,
                encrypted INTEGER NOT NULL DEFAULT 0,
                elapsedSumm INTEGER NOT NULL DEFAULT 0
            )
            """
        )
    }

    func addRecordToDnsStatisticsTable(
        timeStamp: Date,
        requests: Int,
        encrypted: Int,
        elapsedSumm: Int
    ) throws {
        let oldDateFormatter = dateFormatter
        dateFormatter = iso8601Formatter()

        let db = try Connection(oldDnsStatisticsTableUrl.path, readonly: false)

        let table = Table("DnsStatisticsTable")
        let timeStampColumn = Expression<Date>("timeStamp")
        let requestsColumn = Expression<Int>("requests")
        let encryptedColumn = Expression<Int>("encrypted")
        let elapsedSummColumn = Expression<Int>("elapsedSumm")

        let query = table.insert([
            timeStampColumn <- timeStamp,
            requestsColumn <- requests,
            encryptedColumn <- encrypted,
            elapsedSummColumn <- elapsedSumm
        ])
        try db.run(query)

        dateFormatter = oldDateFormatter
    }

    func getRecordsFromNewChartStatisticsTable() throws -> [(
        timeStamp: Date,
        requests: Int,
        encrypted: Int,
        blocked: Int,
        elapsed: Int
    )] {
        let db = try Connection(newChartStatisticsUrl.path, readonly: true)

        let table = Table("chart_statistics_table")
        let timeStampColumn = Expression<Date>("timeStamp")
        let requestsColumn = Expression<Int>("requests")
        let encryptedColumn = Expression<Int>("encrypted")
        let blockedColumn = Expression<Int>("blocked")
        let elapsedSummColumn = Expression<Int>("elapsedSumm")

        return try db.prepare(table).map { row in
            return (
                row[timeStampColumn],
                row[requestsColumn],
                row[encryptedColumn],
                row[blockedColumn],
                row[elapsedSummColumn]
            )
        }
    }

    func createOldActivityStatisticsTable() throws {
        let db = try Connection(oldDnsStatisticsTableUrl.path, readonly: false)
        try db.run("""
            CREATE TABLE IF NOT EXISTS ActivityStatisticsTable (
                timeStamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                domain TEXT NOT NULL DEFAULT '',
                requests INTEGER NOT NULL DEFAULT 0,
                encrypted INTEGER NOT NULL DEFAULT 0,
                elapsedSumm INTEGER NOT NULL DEFAULT 0,
                PRIMARY KEY(timeStamp, domain)
            )
            """
        )
    }

    func addRecordToActivityStatisticsTable(
        timeStamp: Date,
        domain: String,
        requests: Int,
        encrypted: Int,
        elapsedSumm: Int
    ) throws {
        let oldDateFormatter = dateFormatter
        dateFormatter = iso8601Formatter()

        let db = try Connection(oldDnsStatisticsTableUrl.path, readonly: false)

        let table = Table("ActivityStatisticsTable")
        let timeStampColumn = Expression<Date>("timeStamp")
        let domainColumn = Expression<String>("domain")
        let requestsColumn = Expression<Int>("requests")
        let encryptedColumn = Expression<Int>("encrypted")
        let elapsedSummColumn = Expression<Int>("elapsedSumm")

        let query = table.insert([
            timeStampColumn <- timeStamp,
            domainColumn <- domain,
            requestsColumn <- requests,
            encryptedColumn <- encrypted,
            elapsedSummColumn <- elapsedSumm
        ])
        try db.run(query)

        dateFormatter = oldDateFormatter
    }

    func getRecordsFromNewActivityStatisticsTable() throws -> [(
        timeStamp: Date,
        domain: String,
        requests: Int,
        encrypted: Int,
        blocked: Int,
        elapsed: Int
    )] {
        let db = try Connection(newChartStatisticsUrl.path, readonly: true)

        let table = Table("activity_statistics_table")
        let timeStampColumn = Expression<Date>("timeStamp")
        let domainColumn = Expression<String>("domain")
        let requestsColumn = Expression<Int>("requests")
        let encryptedColumn = Expression<Int>("encrypted")
        let blockedColumn = Expression<Int>("blocked")
        let elapsedSummColumn = Expression<Int>("elapsedSumm")

        return try db.prepare(table).map { row in
            return (
                row[timeStampColumn],
                row[domainColumn],
                row[requestsColumn],
                row[encryptedColumn],
                row[blockedColumn],
                row[elapsedSummColumn]
            )
        }
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
