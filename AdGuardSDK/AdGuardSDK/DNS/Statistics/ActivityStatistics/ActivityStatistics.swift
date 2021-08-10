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

protocol ActivityStatisticsProtocol: ResetableSyncProtocol {
    /// Adds the `record` obtained from DNS-libs in the Tunnel to the DB
    func process(record: ActivityStatisticsRecord)
      
    /**
     Returns list of `DomainsStatisticsRecord` objects for the specified `period`
     `DomainsStatisticsRecord` represents counters statistics for certain domain
     
     This method will return records sorted by `requests` in descending order
     In case `requests` are equal will sort by `domain`
     */
    func getDomains(for period: StatisticsPeriod) throws -> [DomainsStatisticsRecord]
  
    /**
     Returns `CountersStatisticsRecord` object for the specified `period`
     `CountersStatisticsRecord` represents counters statistics
     */
    func getCounters(for period: StatisticsPeriod) throws -> CountersStatisticsRecord
}

/// This object is responsible for counters statistics
/// It stores and manages data for counters
/// If data appears to be big it can compress it
final class ActivityStatistics: ActivityStatisticsProtocol {

    let statisticsDb: Connection
    
    init(statisticsDbContainerUrl: URL) throws {
        let dbName = Constants.Statistics.StatisticsType.activity.dbFileName
        self.statisticsDb = try Connection(statisticsDbContainerUrl.appendingPathComponent(dbName).path)
        dateFormatter.dateFormat = Constants.Statistics.dbDateFormat
        try self.createTableIfNotExists()
        try compressTable()
    }

    // MARK: - Public methods

    func process(record: ActivityStatisticsRecord) {
        do {
            try add(record: record)
        } catch {
            Logger.logError("(ActivityStatistics) - processRecord; Error adding record to DB; Error: \(error)")
        }
    }
    
    /**
     Returns list of all records stored in DB for the specified `period`
     
     This method will return records sorted by `timeStamp` in descending order
     In case `timeStamp`s are equal will sort by `domain`
     */
    func getRecords(for period: StatisticsPeriod) throws -> [ActivityStatisticsRecord] {
        Logger.logDebug("(ActivityStatistics) - getRecords for period=\(period.debugDescription)")
        
        let interval = period.interval
        let query = ActivityStatisticsTable.table
            .where(interval.start...interval.end ~= ActivityStatisticsTable.timeStamp)
            .order(ActivityStatisticsTable.timeStamp.desc, ActivityStatisticsTable.domain)
        let records: [ActivityStatisticsRecord] = try statisticsDb.prepare(query).map {
            return ActivityStatisticsRecord(dbRecord: $0)
        }
        
        Logger.logDebug("(ActivityStatistics) - getRecords; Return \(records.count) records for period=\(period.debugDescription)")
        
        return records
    }
    
    func getDomains(for period: StatisticsPeriod) throws -> [DomainsStatisticsRecord] {
        Logger.logDebug("(ActivityStatistics) - getDomains for period=\(period.debugDescription)")
        
        let interval = period.interval
        let query = ActivityStatisticsTable.table
            .select([ActivityStatisticsTable.domain,
                     ActivityStatisticsTable.requests.varSum,
                     ActivityStatisticsTable.encrypted.varSum,
                     ActivityStatisticsTable.blocked.varSum,
                     ActivityStatisticsTable.elapsedSumm.varSum])
            .where(interval.start...interval.end ~= ActivityStatisticsTable.timeStamp)
            .group(ActivityStatisticsTable.domain)
            .order(ActivityStatisticsTable.requests.desc, ActivityStatisticsTable.domain)
        
        let result = try statisticsDb.prepare(query.asSQL()).map { DomainsStatisticsRecord(dbRecord: $0) }
        
        Logger.logDebug("(ActivityStatistics) - getDomains; Return \(result.count) domains for period=\(period.debugDescription)")
        return result
    }
    
    func getCounters(for period: StatisticsPeriod) throws -> CountersStatisticsRecord {
        Logger.logDebug("(ActivityStatistics) - getCounters for period=\(period.debugDescription)")
        
        let interval = period.interval
        let query = ActivityStatisticsTable.table
            .select([ActivityStatisticsTable.requests.varSum,
                     ActivityStatisticsTable.encrypted.varSum,
                     ActivityStatisticsTable.blocked.varSum,
                     ActivityStatisticsTable.elapsedSumm.varSum])
            .where(interval.start...interval.end ~= ActivityStatisticsTable.timeStamp)
            .limit(1)
        
        let records = try statisticsDb.prepare(query.asSQL()).map { CountersStatisticsRecord(dbRecord: $0) }
        
        if records.count == 1 {
            Logger.logDebug("(ActivityStatistics) - getCounters; Return \(records.first!) for period=\(period.debugDescription)")
            return records.first!
        } else {
            Logger.logDebug("(ActivityStatistics) - getCounters; Return zero CountersStatisticsRecord for period=\(period.debugDescription)")
            return CountersStatisticsRecord(requests: 0, encrypted: 0, blocked: 0, averageElapsed: 0)
        }
    }
    
    func reset() throws {
        Logger.logInfo("(ActivityStatistics) - reset called")
        
        let resetQuery = ActivityStatisticsTable.table.delete()
        try statisticsDb.run(resetQuery)
        
        Logger.logInfo("(ActivityStatistics) - reset successfully finished")
    }
    
    func add(record: ActivityStatisticsRecord) throws {
        let setters: [Setter] = [ActivityStatisticsTable.timeStamp <- record.timeStamp,
                                 ActivityStatisticsTable.domain <- record.domain,
                                 ActivityStatisticsTable.requests <- record.requests,
                                 ActivityStatisticsTable.encrypted <- record.encrypted,
                                 ActivityStatisticsTable.blocked <- record.blocked,
                                 ActivityStatisticsTable.elapsedSumm <- record.elapsedSumm]

        let addQuery = ActivityStatisticsTable.table.insert(setters)
        try statisticsDb.run(addQuery)
    }

    // MARK: - Private methods

    /// Creates `activity_statistics_table` in statistics DB if it doesn't exist
    private func createTableIfNotExists() throws {
        let query = ActivityStatisticsTable.table.create(temporary: false, ifNotExists: true) { builder in
            builder.column(ActivityStatisticsTable.timeStamp)
            builder.column(ActivityStatisticsTable.domain)
            builder.column(ActivityStatisticsTable.requests)
            builder.column(ActivityStatisticsTable.encrypted)
            builder.column(ActivityStatisticsTable.blocked)
            builder.column(ActivityStatisticsTable.elapsedSumm)
        }
        try statisticsDb.run(query)
    }
}
