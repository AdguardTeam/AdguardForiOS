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

// MARK: - ActivityStatisticsTable

struct ActivityStatisticsTable {
    // Table name
    static let table = Table(Constants.Statistics.StatisticsType.activity.tableName)
    
    // Columns names
    static let timeStamp = Expression<Date>("timeStamp")
    static let domain = Expression<String>("domain")
    static let requests = Expression<Int>("requests")
    static let encrypted = Expression<Int>("encrypted")
    static let blocked = Expression<Int>("blocked")
    static let elapsedSumm = Expression<Int>("elapsedSumm")
}

// MARK: - ActivityStatistics + ActivityStatisticsRecord

public struct ActivityStatisticsRecord: Equatable {
    let timeStamp: Date
    let domain: String
    let requests: Int
    let encrypted: Int
    let blocked: Int
    let elapsedSumm: Int
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        // Dates created from DB object can differ a little bit, so we add 1 second for an error rate
        let dateDiff = lhs.timeStamp.timeIntervalSince1970 - rhs.timeStamp.timeIntervalSince1970
        let datesAreEqual = abs(dateDiff) < 1
        return datesAreEqual
            && lhs.domain == rhs.domain
            && lhs.requests == rhs.requests
            && lhs.encrypted == rhs.encrypted
            && lhs.blocked == rhs.blocked
            && lhs.elapsedSumm == rhs.elapsedSumm
    }
}

extension ActivityStatisticsRecord {
    init(dbRecord: Row) {
        self.timeStamp = dbRecord[ActivityStatisticsTable.timeStamp]
        self.domain = dbRecord[ActivityStatisticsTable.domain]
        self.requests = dbRecord[ActivityStatisticsTable.requests]
        self.encrypted = dbRecord[ActivityStatisticsTable.encrypted]
        self.blocked = dbRecord[ActivityStatisticsTable.blocked]
        self.elapsedSumm = dbRecord[ActivityStatisticsTable.elapsedSumm]
    }
    
    init?(dbRecord: SQLite.Statement.Element) {
        guard let timeStampString = dbRecord[0] as? String,
              let timeStamp = dateFormatter.date(from: timeStampString),
              let domain = dbRecord[1] as? String,
              let requests = dbRecord[2] as? Int64,
              let encrypted = dbRecord[3] as? Int64,
              let blocked = dbRecord[4] as? Int64,
              let elapsedSumm = dbRecord[5] as? Int64
        else {
            return nil
        }
        
        self.timeStamp = timeStamp
        self.domain = domain
        self.requests = Int(requests)
        self.encrypted = Int(encrypted)
        self.blocked = Int(blocked)
        self.elapsedSumm = Int(elapsedSumm)
    }
}

extension DnsRequestProcessedEvent {
    var activityRecord: ActivityStatisticsRecord {
        ActivityStatisticsRecord(timeStamp: startDate,
                                 domain: domain,
                                 requests: 1,
                                 encrypted: isEncrypted ? 1 : 0,
                                 blocked: isBlocked ? 1 : 0,
                                 elapsedSumm: elapsed)
    }
}

// MARK: - DomainsStatistics

public struct DomainsStatisticsRecord: Equatable {
    let domain: String
    let counters: CountersStatisticsRecord
}

extension DomainsStatisticsRecord {
    init(dbRecord: SQLite.Statement.Element) {
        self.domain = dbRecord[0] as? String ?? ""
        let requests = dbRecord[1] as? Int64 ?? 0
        let encrypted = dbRecord[2] as? Int64 ?? 0
        let blocked = dbRecord[3] as? Int64 ?? 0
        let elapsedSumm = dbRecord[4] as? Int64 ?? 0
        self.counters = CountersStatisticsRecord(requests: Int(requests), encrypted: Int(encrypted), blocked: Int(blocked), elapsedSumm: Int(elapsedSumm))
    }
}

// MARK: - CountersStatistics

public struct CountersStatisticsRecord: Equatable {
    let requests: Int
    let encrypted: Int
    let blocked: Int
    let averageElapsed: Int
}

extension CountersStatisticsRecord {
    init(dbRecord: SQLite.Statement.Element) {
        let requests = dbRecord[0] as? Int64 ?? 0
        let encrypted = dbRecord[1] as? Int64 ?? 0
        let blocked = dbRecord[2] as? Int64 ?? 0
        let elapsedSumm = dbRecord[3] as? Int64 ?? 0
        self.init(requests: Int(requests), encrypted: Int(encrypted), blocked: Int(blocked), elapsedSumm: Int(elapsedSumm))
    }
    
    init(requests: Int, encrypted: Int, blocked: Int, elapsedSumm: Int) {
        self.requests = requests
        self.encrypted = encrypted
        self.blocked = blocked
        
        if requests == 0 {
            self.averageElapsed = 0
        } else {
            self.averageElapsed = Int(elapsedSumm / requests)
        }
    }
}
