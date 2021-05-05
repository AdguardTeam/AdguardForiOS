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
import AdGuardSDK

class DnsStatisticsRecord: CustomDebugStringConvertible {
    var date: Date
    var requests: Int
    var encrypted: Int
    var elapsedSumm: Int
    
    var debugDescription: String { "date: \(date); requests = \(requests); encrypted = \(encrypted); elapsedSumm = \(elapsedSumm)" }
    
    init(date: Date = Date(), requests: Int = 0, encrypted: Int = 0, elapsedSumm: Int = 0) {
        self.date = date
        self.requests = requests
        self.encrypted = encrypted
        self.elapsedSumm = elapsedSumm
    }
    
    init?(_ resultSet: FMResultSet) {
        if let iso8601DateString = resultSet["timeStamp"] as? String,
            let date = ISO8601DateFormatter().date(from: iso8601DateString),
            let requests = resultSet["requests"] as? Int,
            let encrypted = resultSet["encrypted"] as? Int,
            let elapsedSumm = resultSet["elapsedSumm"] as? Int {
            
            self.date = date
            self.requests = requests
            self.encrypted = encrypted
            self.elapsedSumm = elapsedSumm
        }
        else {
            return nil
        }
    }
}

extension DnsStatisticsRecord: Equatable {
    static func == (lhs: DnsStatisticsRecord, rhs: DnsStatisticsRecord) -> Bool {
        let lhsDateString = ISO8601DateFormatter().string(from: lhs.date)
        let rhsDateString = ISO8601DateFormatter().string(from: rhs.date)
        return lhsDateString == rhsDateString &&
               lhs.requests == rhs.requests &&
               lhs.encrypted == rhs.encrypted &&
               lhs.elapsedSumm == rhs.elapsedSumm
    }
}
