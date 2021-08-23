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

import SQLite

/// Object representation of `chart_statistics_table`
struct ChartStatisticsTable: Equatable {
    // Table name
    static let table = Table(Constants.Statistics.StatisticsType.chart.tableName)
    
    // Columns names
    static let timeStamp = Expression<Date>("timeStamp")
    static let requests = Expression<Int>("requests")
    static let encrypted = Expression<Int>("encrypted")
    static let blocked = Expression<Int>("blocked")
    static let elapsedSumm = Expression<Int>("elapsedSumm")
}

// MARK: - ChartStatisticsRecord

public struct ChartStatisticsRecord: Equatable {
    let timeStamp: Date
    let requests: Int
    let encrypted: Int
    let blocked: Int
    let elapsedSumm: Int
    let averageElapsed: Int
    
    init(timeStamp: Date, requests: Int, encrypted: Int, blocked: Int, elapsedSumm: Int) {
        self.timeStamp = timeStamp
        self.requests = requests
        self.encrypted = encrypted
        self.blocked = blocked
        self.elapsedSumm = elapsedSumm
        
        if self.requests > 0 {
            averageElapsed = elapsedSumm / requests
        } else {
            averageElapsed = 0
        }
    }
    
    init(dbRecord: Row) {
        let timeStamp = dbRecord[ChartStatisticsTable.timeStamp]
        let requests = dbRecord[ChartStatisticsTable.requests]
        let encrypted = dbRecord[ChartStatisticsTable.encrypted]
        let blocked = dbRecord[ChartStatisticsTable.blocked]
        let elapsedSumm = dbRecord[ChartStatisticsTable.elapsedSumm]
        self.init(timeStamp: timeStamp, requests: requests, encrypted: encrypted, blocked: blocked, elapsedSumm: elapsedSumm)
    }
    
    /// Failable initializer for compressing records
    init?(dbRecord: SQLite.Statement.Element) {
        guard let timeStampString = dbRecord[0] as? String,
              let timeStamp = dateFormatter.date(from: timeStampString),
              let requests = dbRecord[1] as? Int64,
              let encrypted = dbRecord[2] as? Int64,
              let blocked = dbRecord[3] as? Int64,
              let elapsedSumm = dbRecord[4] as? Int64
        else {
            return nil
        }
        self.init(timeStamp: timeStamp, requests: Int(requests), encrypted: Int(encrypted), blocked: Int(blocked), elapsedSumm: Int(elapsedSumm))
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // Dates created from DB object can differ a little bit, so we add 1 second for an error rate
        let dateDiff = lhs.timeStamp.timeIntervalSince1970 - rhs.timeStamp.timeIntervalSince1970
        let datesAreEqual = abs(dateDiff) < 1
        return datesAreEqual
            && lhs.requests == rhs.requests
            && lhs.encrypted == rhs.encrypted
            && lhs.blocked == rhs.blocked
            && lhs.elapsedSumm == rhs.elapsedSumm
    }
}

// MARK: - DnsRequestProcessedEvent + ChartStatisticsRecord

extension DnsRequestProcessedEvent {
    var chartStatisticsRecord: ChartStatisticsRecord {
        ChartStatisticsRecord(
                timeStamp: startDate,
                requests: 1,
                encrypted: isEncrypted ? 1 : 0,
                blocked: isBlocked ? 1 : 0,
                elapsedSumm: elapsed
        )
    }
}

// MARK: - ChartRecords

public struct Point: Equatable {
    let x: Int
    let y: Int
}

public struct ChartRecords {
    let chartType: ChartType
    let points: [Point]
}
