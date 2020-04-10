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

@objc class ActivityStatisticsRecord: NSObject {
    let date: Date
    let domain: String
    var requests: Int
    var encrypted: Int
    var elapsedSumm: Int
    
    init(date: Date = Date(), domain: String, requests: Int = 0, encrypted: Int = 0, elapsedSumm: Int = 0) {
        self.date = date
        self.domain = domain
        self.requests = requests
        self.encrypted = encrypted
        self.elapsedSumm = elapsedSumm
    }
    
    init?(_ resultSet: FMResultSet) {
        if let iso8601DateString = resultSet["timeStamp"] as? String,
            let date = ISO8601DateFormatter().date(from: iso8601DateString),
            let domain = resultSet["domain"] as? String,
            let requests = resultSet["requests"] as? Int,
            let encrypted = resultSet["encrypted"] as? Int,
            let elapsedSumm = resultSet["elapsedSumm"] as? Int {
            
            self.date = date
            self.domain = domain
            self.requests = requests
            self.encrypted = encrypted
            self.elapsedSumm = elapsedSumm
        }
        else {
            return nil
        }
    }

    override var debugDescription: String {
        get {
            return "date = \(self.date); domain = \(self.domain); requests = \(self.requests); encrypted = \(self.encrypted); elapsedSumm = \(self.elapsedSumm)"
        }
    }
    
    // MARK: - Equatable protocol
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? ActivityStatisticsRecord {
            return ISO8601DateFormatter().string(from: object.date) == ISO8601DateFormatter().string(from: self.date) &&
                object.domain == self.domain &&
                object.requests == self.requests &&
                object.encrypted == self.encrypted &&
                object.elapsedSumm == self.elapsedSumm
        }
        return false
    }
}
