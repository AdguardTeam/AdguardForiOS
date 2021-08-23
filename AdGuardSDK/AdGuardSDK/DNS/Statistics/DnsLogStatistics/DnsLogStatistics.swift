/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.

       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.

       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.

       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.

 */

import Foundation
import SQLite

protocol DnsLogStatisticsProtocol: ResetableSyncProtocol {
    /// Saves passed `event` to DB
    func process(event: DnsRequestProcessedEvent)
    
    /// Returns all log records saved in DB
    func getDnsLogRecords() throws -> [DnsRequestProcessedEvent]
}

/// This object is responsible for saving and getting statistics about DNS requests and responses
/// It stores the last 1500 objects of log, if it is overflowed that it will purge the oldest 500 records
final class DnsLogStatistics: DnsLogStatisticsProtocol {
    
    // MARK: - Private properties
    
    private let statisticsDb: Connection
        
    init(statisticsDbContainerUrl: URL) throws {
        let dbName = Constants.Statistics.StatisticsType.dnsLog.dbFileName
        statisticsDb = try Connection(statisticsDbContainerUrl.appendingPathComponent(dbName).path)
        dateFormatter.dateFormat = Constants.Statistics.dbDateFormat
        try createTableIfNotExists()
    }
    
    // MARK: - Public methods
    
    /// Tries to save `event` to `DNS_log_statistics.db`
    func process(event: DnsRequestProcessedEvent) {
        do {
            try add(record: event)
            try purgeDnsLogIfNeeded()
        } catch {
            Logger.logError("(DnsLogStatistics) - processEvent; Error adding event to DB; Error: \(error)")
        }
    }
    
    /// Returns all available records from `DNS_log_statistics.db`
    func getDnsLogRecords() throws -> [DnsRequestProcessedEvent] {
        Logger.logInfo("(DnsLogStatistics) - getDnsLogRecords called")
        let query = DnsLogTable.table.order(DnsLogTable.startDate.desc)
        let all: [DnsRequestProcessedEvent] = try statisticsDb.prepare(query).map {
            DnsRequestProcessedEvent(dbLogRecord: $0)
        }
        Logger.logInfo("(DnsLogStatistics) - getDnsLogRecords fetched \(all.count) log records")
        return all
    }

    /// Removes all records from `DNS_log_statistics.db`
    func reset() throws {
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
        }
        try statisticsDb.run(query)
    }
    
    /// Removes last 500 records if records number exceeds 1500 records
    private func purgeDnsLogIfNeeded() throws {
        let maxRecordsCount = 1500
        let recordsCount = try statisticsDb.recordsCount(for: DnsLogTable.table)
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
                                 DnsLogTable.cacheHit <- record.cacheHit]
        let addQuery = DnsLogTable.table.insert(setters)
        try statisticsDb.run(addQuery)
    }
}
