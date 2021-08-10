/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import SQLite

/// Extension with table compression methods
/// These methods are not part of Interface, do not use them directly
extension ActivityStatistics {
    
    /// Compresses the table
    func compressTable() throws {
        Logger.logInfo("(ActivityStatistics) - compressTable; Trying to compress the table")
        
        let recordsCountBeforeCompression = try statisticsDb.recordsCount(for: ActivityStatisticsTable.table)
        let compressedRecords = try getCompressedRecords()
        try reset()
        try compressedRecords.forEach { try add(record: $0) }
        
        Logger.logInfo("(ActivityStatistics) - compressTable; Successfully compressed the table; from \(recordsCountBeforeCompression) to \(compressedRecords.count)")
    }
    
    private func getCompressedRecords() throws -> [ActivityStatisticsRecord] {
        let intervals = StatisticsPeriod.activityCompressionIntervals
        let compressedRecords: [ActivityStatisticsRecord] = try intervals.flatMap { interval -> [ActivityStatisticsRecord] in
            /// if you are confused `end >= start`
            let start = interval.start
            let end = interval.end
            
            let query = ActivityStatisticsTable.table
                .select([ActivityStatisticsTable.timeStamp.avgDate,
                         ActivityStatisticsTable.domain,
                         ActivityStatisticsTable.requests.sum,
                         ActivityStatisticsTable.encrypted.sum,
                         ActivityStatisticsTable.blocked.sum,
                         ActivityStatisticsTable.elapsedSumm.sum])
                .where(start...end ~= ActivityStatisticsTable.timeStamp)
                .group(ActivityStatisticsTable.domain)
                .order(ActivityStatisticsTable.timeStamp.desc, ActivityStatisticsTable.domain)
            
            let result = try statisticsDb.prepare(query.asSQL()).compactMap { ActivityStatisticsRecord(dbRecord: $0) }
            return result
        }
        return compressedRecords
    }
}

// MARK: - StatisticsPeriod + compression interval

extension StatisticsPeriod {
    /**
     Intervals where statistics data will be compressed to one record by domains
     So if there were `n` different domains in the interval they will be compressed to
     `n` unique records, all counters will be summed
        
     Statistics timeline:
               month                 week    day   today
     |------|------------------------------|------------|------|----------|---->
                                        NOW
     
     Every segment will be compressed sepately
     So every next segment records will include previous segments
     */
    static var activityCompressionIntervals: [DateInterval] {
        let todayInterval = Self.today.interval
        
        var duration: TimeInterval = 0.0
        
        var dayInterval = Self.day.interval
        duration = todayInterval.duration
        dayInterval = DateInterval(start: dayInterval.start, end: dayInterval.end - duration)
        
        var weekInterval = Self.week.interval
        duration += dayInterval.duration
        weekInterval = DateInterval(start: weekInterval.start, end: weekInterval.end - duration)
        
        var monthInterval = Self.month.interval
        duration += weekInterval.duration
        monthInterval = DateInterval(start: monthInterval.start, end: monthInterval.end - duration)
        
        var allInterval = Self.all.interval
        duration += monthInterval.duration
        allInterval = DateInterval(start: allInterval.start, end: allInterval.end - duration)
        
        return [todayInterval, dayInterval, weekInterval, monthInterval, allInterval]
    }
}
