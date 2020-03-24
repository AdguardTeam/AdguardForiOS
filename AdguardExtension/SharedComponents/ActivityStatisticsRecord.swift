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
    var blocked: Int
    var savedData: Int
    
    init(date: Date, domain: String, requests: Int, blocked: Int, savedData: Int) {
        self.date = date
        self.domain = domain
        self.requests = requests
        self.blocked = blocked
        self.savedData = savedData
    }
    
    init?(_ resultSet: FMResultSet) {
        if let iso8601DateString = resultSet["timeStamp"] as? String,
            let date = Date.dateFromIso8601(iso8601DateString),
            let domain = resultSet["domain"] as? String,
            let requests = resultSet["requests"] as? Int,
            let blocked = resultSet["blocked"] as? Int,
            let savedData = resultSet["savedData"] as? Int {
            
            self.date = date
            self.domain = domain
            self.requests = requests
            self.blocked = blocked
            self.savedData = savedData
        }
        else {
            return nil
        }
    }

    override var debugDescription: String {
        get {
            return "date = \(self.date); domain = \(self.domain); requests = \(self.requests); blocked = \(self.blocked); savedData = \(self.savedData)"
        }
    }
    
    // MARK: - Equatable protocol
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? ActivityStatisticsRecord {
            return object.date.Iso8601YyyyMmDdFormatter() == self.date.Iso8601YyyyMmDdFormatter() &&
                object.domain == self.domain &&
                object.requests == self.requests &&
                object.blocked == self.blocked &&
                object.savedData == self.savedData
        }
        return false
    }
}
