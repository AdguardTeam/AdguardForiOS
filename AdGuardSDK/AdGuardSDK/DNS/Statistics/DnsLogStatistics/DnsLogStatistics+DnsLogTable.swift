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

import SQLite

/// Object representation of DB table `DNS_log_statistics.db`
struct DnsLogTable: Equatable {
    // Table name
    static let table = Table(Constants.Statistics.StatisticsType.dnsLog.tableName)
    
    // Columns names
    static let domain = Expression<String>("domain")
    static let startDate = Expression<Date>("start_date")
    static let elapsed = Expression<Int>("elapsed")
    static let type = Expression<String>("type")
    static let answer = Expression<String>("answer")
    static let processedStatus = Expression<Int>("processed_status")
    static let originalAnswer = Expression<String>("original_answer")
    static let upstream = Expression<DnsUpstream>("upstream")
    static let bytesSent = Expression<Int>("bytes_sent")
    static let bytesReceived = Expression<Int>("bytes_received")
    static let blockRules = Expression<[String]>("block_rules")
    static let cacheHit = Expression<Bool>("cache_hit")
}

extension DnsRequestProcessedEvent {
    init(dbLogRecord: Row) {
        self.domain = dbLogRecord[DnsLogTable.domain]
        self.startDate = dbLogRecord[DnsLogTable.startDate]
        self.elapsed = dbLogRecord[DnsLogTable.elapsed]
        self.type = dbLogRecord[DnsLogTable.type]
        self.answer = dbLogRecord[DnsLogTable.answer]
        let status = dbLogRecord[DnsLogTable.processedStatus]
        self.processedStatus = DnsRequestProcessedEvent.ProcessedStatus(rawValue: status)!
        self.originalAnswer = dbLogRecord[DnsLogTable.originalAnswer]
        self.upstream = dbLogRecord[DnsLogTable.upstream]
        self.bytesSent = dbLogRecord[DnsLogTable.bytesSent]
        self.bytesReceived = dbLogRecord[DnsLogTable.bytesReceived]
        self.blockRules = dbLogRecord[DnsLogTable.blockRules]
        self.cacheHit = dbLogRecord[DnsLogTable.cacheHit]
    }
}
