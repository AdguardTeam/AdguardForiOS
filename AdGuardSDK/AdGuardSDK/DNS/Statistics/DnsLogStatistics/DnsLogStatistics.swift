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
import SharedAdGuardSDK

public protocol DnsLogStatisticsProtocol: ResetableSyncProtocol {
    /// Saves passed `event` to DB
    func process(event: DnsRequestProcessedEvent)

    /**
     Returns list of `DnsRequestProcessedEvent` objects for the specified `period`
     This method will return records sorted by `startDate` in descending order
     */
    func getDnsLogRecords(for period: StatisticsPeriod) throws -> [DnsRequestProcessedEvent]

    /**
     Returns list of blocked `DnsRequestProcessedEvent` objects for the specified `period`
     This method will return blocked records sorted by `startDate` in descending order
     */
    func getBlockedDnsLogRecords(for period: StatisticsPeriod) throws -> [DnsRequestProcessedEvent]

    /**
     Returns list of allowlisted `DnsRequestProcessedEvent` objects for the specified `period`
     This method will return allowlisted records sorted by `startDate` in descending order
     */
    func getAllowlistedDnsLogRecords(for period: StatisticsPeriod) throws -> [DnsRequestProcessedEvent]
}

/// This object is responsible for saving and getting statistics about DNS requests and responses
/// It stores the last 1500 objects of log, if it is overflowed that it will purge the oldest 500 records
final public class DnsLogStatistics: DnsLogStatisticsProtocol {

    // MARK: - Private properties

    private let statisticsDb: Connection

    public init(statisticsDbContainerUrl: URL) throws {
        // Create directory if doesn't exist
        try FileManager.default.createDirectory(at: statisticsDbContainerUrl, withIntermediateDirectories: true, attributes: [:])

        let dbName = Constants.Statistics.StatisticsType.dnsLog.dbFileName
        statisticsDb = try Connection(statisticsDbContainerUrl.appendingPathComponent(dbName).path)
        
        // TODO: - It's a crutch; Refactor it later
        // This database is used by several threads at the same time.
        // It is possible that a database file is temporarily locked in one thread and is being accessed from another.
        // Here we set a timeout to resolve this issue
        self.statisticsDb.busyTimeout = 10.0

        dateFormatter.dateFormat = Constants.Statistics.dbDateFormat
        try createTableIfNotExists()
    }

    // MARK: - Public methods

    /// Tries to save `event` to `DNS_log_statistics.db`
    public func process(event: DnsRequestProcessedEvent) {
        do {
            try add(record: event)
            try purgeDnsLogIfNeeded()
        } catch {
            Logger.logError("(DnsLogStatistics) - processEvent; Error adding event to DB; Error: \(error)")
        }
    }

    // TODO: - Needs new tests
    /// Returns all available records from `DNS_log_statistics.db` for the specified `period`
    public func getDnsLogRecords(for period: StatisticsPeriod) throws -> [DnsRequestProcessedEvent] {
        Logger.logInfo("(DnsLogStatistics) - getDnsLogRecords called")
        let query = DnsLogTable.table
            .where(period.interval.start...period.interval.end ~= DnsLogTable.startDate)
            .order(DnsLogTable.startDate.desc)
        let all: [DnsRequestProcessedEvent] = try statisticsDb.prepare(query).map {
            DnsRequestProcessedEvent(dbLogRecord: $0)
        }
        Logger.logInfo("(DnsLogStatistics) - getDnsLogRecords fetched \(all.count) log records")
        return all
    }

    // TODO: - Needs new tests
    /// Returns all available blocked records from `DNS_log_statistics.db` for the specified `period`
    public func getBlockedDnsLogRecords(for period: StatisticsPeriod) throws -> [DnsRequestProcessedEvent] {
        Logger.logInfo("(DnsLogStatistics) - getBlockedDnsLogRecords called")
        let query = DnsLogTable.table
            .where(
                period.interval.start...period.interval.end ~= DnsLogTable.startDate && (
                    DnsLogTable.processedStatus == DnsRequestProcessedEvent.ProcessedStatus.blocklistedByDnsFilter.rawValue ||
                    DnsLogTable.processedStatus == DnsRequestProcessedEvent.ProcessedStatus.blocklistedByDnsServer.rawValue ||
                    DnsLogTable.processedStatus == DnsRequestProcessedEvent.ProcessedStatus.blocklistedByUserFilter.rawValue
                )
            )
            .order(DnsLogTable.startDate.desc)
        let blocked: [DnsRequestProcessedEvent] = try statisticsDb.prepare(query).map {
            DnsRequestProcessedEvent(dbLogRecord: $0)
        }
        Logger.logInfo("(DnsLogStatistics) - getBlockedDnsLogRecords fetched \(blocked.count) log records")
        return blocked
    }

    // TODO: - Needs new tests
    /// Returns all available allowlisted records from `DNS_log_statistics.db` for the specified `period`
    public func getAllowlistedDnsLogRecords(for period: StatisticsPeriod) throws -> [DnsRequestProcessedEvent] {
        Logger.logInfo("(DnsLogStatistics) - getAllowlistedDnsLogRecords called")
        let query = DnsLogTable.table
            .where(
                period.interval.start...period.interval.end ~= DnsLogTable.startDate && (
                    DnsLogTable.processedStatus == DnsRequestProcessedEvent.ProcessedStatus.allowlistedByDnsFilter.rawValue ||
                    DnsLogTable.processedStatus == DnsRequestProcessedEvent.ProcessedStatus.allowlistedByUserFilter.rawValue
                )
            )
            .order(DnsLogTable.startDate.desc)
        let allowlisted: [DnsRequestProcessedEvent] = try statisticsDb.prepare(query).map {
            DnsRequestProcessedEvent(dbLogRecord: $0)
        }
        Logger.logInfo("(DnsLogStatistics) - getAllowlistedDnsLogRecords fetched \(allowlisted.count) log records")
        return allowlisted
    }

    /// Removes all records from `DNS_log_statistics.db`
    public func reset() throws {
        Logger.logInfo("(DnsLogStatistics) - reset called")

        let resetQuery = DnsLogTable.table.delete()
        try statisticsDb.run(resetQuery)

        Logger.logInfo("(DnsLogStatistics) - reset successfully finished")
    }

    // MARK: - Private methods

    /// Creates `DNS_log_table` in statistics DB if it doesn't exist
    private func createTableIfNotExists() throws {
        let query = DnsLogTable.table.create(temporary: false, ifNotExists: true) { builder in
            builder.column(DnsLogTable.domain)
            builder.column(DnsLogTable.startDate)
            builder.column(DnsLogTable.elapsed)
            builder.column(DnsLogTable.type)
            builder.column(DnsLogTable.answer)
            builder.column(DnsLogTable.processedStatus)
            builder.column(DnsLogTable.originalAnswer)
            builder.column(DnsLogTable.upstream)
            builder.column(DnsLogTable.bytesSent)
            builder.column(DnsLogTable.bytesReceived)
            builder.column(DnsLogTable.blockRules)
            builder.column(DnsLogTable.cacheHit)
            builder.column(DnsLogTable.filterListIds)
            builder.column(DnsLogTable.dnsStatus)
        }
        try statisticsDb.run(query)
    }

    /// Removes last 500 records if records number exceeds 1500 records
    private func purgeDnsLogIfNeeded() throws {
        let maxRecordsCount = 1500
        let recordsCount = try statisticsDb.scalar(DnsLogTable.table.count)
        guard recordsCount >= maxRecordsCount else {
            return
        }

        let recordsToRemoveCount = 500
        try removeLast(recordsToRemoveCount)

        Logger.logInfo("(DnsLogStatistics) - purgeDnsLogIfNeeded; Last \(recordsToRemoveCount) records were purged")
    }

    /// Removes `n` last rows from the table
    private func removeLast(_ n: Int) throws {
        let removeQuery = DnsLogTable.table.order(DnsLogTable.startDate).limit(n)
        try statisticsDb.run(removeQuery.delete())
    }

    /// Adds `record` to `DNS_log_table`
    private func add(record: DnsRequestProcessedEvent) throws {
        let setters: [Setter] = [DnsLogTable.domain <- record.domain,
                                 DnsLogTable.startDate <- record.startDate,
                                 DnsLogTable.elapsed <- record.elapsed,
                                 DnsLogTable.type <- record.type,
                                 DnsLogTable.answer <- record.answer,
                                 DnsLogTable.processedStatus <- record.processedStatus.rawValue,
                                 DnsLogTable.originalAnswer <- record.originalAnswer,
                                 DnsLogTable.upstream <- record.upstream,
                                 DnsLogTable.bytesSent <- record.bytesSent,
                                 DnsLogTable.bytesReceived <- record.bytesReceived,
                                 DnsLogTable.blockRules <- record.blockRules,
                                 DnsLogTable.cacheHit <- record.cacheHit,
                                 DnsLogTable.filterListIds <- record.filterListIds,
                                 DnsLogTable.dnsStatus <- record.dnsStatus]
        let addQuery = DnsLogTable.table.insert(setters)
        try statisticsDb.run(addQuery)
    }
}
