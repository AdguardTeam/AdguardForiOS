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

protocol ChartStatisticsProtocol: ResetableSyncProtocol {
    /// Adds the `record` obtained from DNS-libs in the Tunnel to the DB
    func process(record: ChartStatisticsRecord)
    
    /**
     Returns 100 points for building a chart
     
     - Parameters:
       - chartType: Variable that should be used as `y`
       - period: Desired period for points
     - Returns: Array of points and `chartType`
     - Throws: error if an error occurred in DB
     */
    func getPoints(for chartType: ChartType, for period: StatisticsPeriod) throws -> ChartRecords
}

/// This object is responsible for managing statistics that is used to build charts
final class ChartStatistics: ChartStatisticsProtocol {
    
    let statisticsDb: Connection
    
    init(statisticsDbContainerUrl: URL) throws {
        let dbName = Constants.Statistics.StatisticsType.chart.dbFileName
        statisticsDb = try Connection(statisticsDbContainerUrl.appendingPathComponent(dbName).path)
        dateFormatter.dateFormat = Constants.Statistics.dbDateFormat
        try createTableIfNotExists()
    }
    
    // MARK: - Public methods
    
    /// Just adds `record` to the table
    func add(record: ChartStatisticsRecord) throws {
        let setters: [Setter] = [ChartStatisticsTable.timeStamp <- record.timeStamp,
                                 ChartStatisticsTable.requests <- record.requests,
                                 ChartStatisticsTable.encrypted <- record.encrypted,
                                 ChartStatisticsTable.blocked <- record.blocked,
                                 ChartStatisticsTable.elapsedSumm <- record.elapsedSumm]

        let addQuery = ChartStatisticsTable.table.insert(setters)
        try statisticsDb.run(addQuery)
    }
    
    func process(record: ChartStatisticsRecord) {
        do {
            try add(record: record)
            try compressTableIfNeeded()
        } catch {
            Logger.logError("(ChartStatistics) - processRecord; Error adding record to DB; Error: \(error)")
        }
    }
    
    /**
     Returns list of all records stored in DB for the specified `period`
     
     This method will return records sorted by `timeStamp` in ascending order
     */
    func getRecords(for period: StatisticsPeriod) throws -> [ChartStatisticsRecord] {
        Logger.logDebug("(ChartStatistics) - getRecords for period=\(period.debugDescription)")
        
        let interval = period.interval
        let query = ChartStatisticsTable.table
            .where(interval.start...interval.end ~= ChartStatisticsTable.timeStamp)
            .order(ChartStatisticsTable.timeStamp.asc)
        let records: [ChartStatisticsRecord] = try statisticsDb.prepare(query).map {
            ChartStatisticsRecord(dbRecord: $0)
        }
        
        Logger.logDebug("(ChartStatistics) - getRecords; Return \(records.count) records for period=\(period.debugDescription)")
        
        return records
    }

    func getPoints(for chartType: ChartType, for period: StatisticsPeriod) throws -> ChartRecords {
        Logger.logDebug("(ChartStatistics) - getPoints for chartType=\(chartType) for period=\(period.debugDescription)")
        
        /// Intervals for points. Each interval will contain 1 aggregated point
        let intervals = chartIntervals(for: period)
        
        let points = try intervals.compactMap { interval -> Point? in
            let query = ChartStatisticsTable.table
                .select([chartType.expression.varSum,
                         dateInSeconds(ChartStatisticsTable.timeStamp)])
                .where(interval.start...interval.end ~= ChartStatisticsTable.timeStamp)
                .order(ChartStatisticsTable.timeStamp)
            
            /// Here must be only 1 point, we'll check it later
            let points: [Point] = try statisticsDb.prepare(query.asSQL()).map {
                guard let x = $0[1] as? Int64, let y = $0[0] as? Int64 else {
                    let middle = Int(interval.middle.timeIntervalSince1970)
                    /// If there is no points in the specified interval than we return zero point in the middle of this interval
                    return Point(x: middle, y: 0)
                }
                return Point(x: Int(x), y: Int(y))
            }
            
            /// Check if point is the only one
            if points.count != 1 {
                return Point(x: Int(interval.middle.timeIntervalSince1970), y: 0)
            } else {
                return points.first!
            }
        }
        
        Logger.logDebug("(ChartStatistics) - getPoints for chartType=\(chartType) for period=\(period.debugDescription) returning \(points.count) points")
        return ChartRecords(chartType: chartType, points: points)
    }

    /// Removes all records from the table
    func reset() throws {
        Logger.logInfo("(ChartStatistics) - reset called")
        
        let resetQuery = ChartStatisticsTable.table.delete()
        try statisticsDb.run(resetQuery)
        
        Logger.logInfo("(ChartStatistics) - reset successfully finished")
    }
    
    // MARK: - Private methods

    /// Creates `chart_statistics_table` in statistics DB if it doesn't exist
    private func createTableIfNotExists() throws {
        let query = ChartStatisticsTable.table.create(temporary: false, ifNotExists: true) { builder in
            builder.column(ChartStatisticsTable.timeStamp)
            builder.column(ChartStatisticsTable.requests)
            builder.column(ChartStatisticsTable.encrypted)
            builder.column(ChartStatisticsTable.blocked)
            builder.column(ChartStatisticsTable.elapsedSumm)
        }
        try statisticsDb.run(query)
    }
    
    /// Converts timeStamp to number of seconds since 1970
    private func dateInSeconds(_ expr: Expression<Date>) -> Expression<Int> {
        Expression(literal: "cast(avg(strftime('%s', \(expr.asSQL()))) as int) as \(expr.template)")
    }
}

// MARK: - ChartType + ChartStatisticsTable query

fileprivate extension ChartType {
    var expression: Expression<Int> {
        switch self {
        case .requests: return ChartStatisticsTable.requests
        case .encrypted: return ChartStatisticsTable.encrypted
        case .blocked: return ChartStatisticsTable.blocked
        case .elapsed: return ChartStatisticsTable.elapsedSumm
        }
    }
}
