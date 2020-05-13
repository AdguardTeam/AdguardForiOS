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
    let date: Date?
    let domain: String
    var requests: Int
    var encrypted: Int
    var elapsedSumm: Int?
    
    init(date: Date? = nil, domain: String, requests: Int = 0, encrypted: Int = 0, elapsedSumm: Int? = nil) {
        self.date = date
        self.domain = domain
        self.requests = requests
        self.encrypted = encrypted
        self.elapsedSumm = elapsedSumm
    }

    override var debugDescription: String {
        get {
            return "domain = \(self.domain); requests = \(self.requests); encrypted = \(self.encrypted)"
        }
    }
    
    // MARK: - Equatable protocol
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? ActivityStatisticsRecord {
            return object.date == self.date &&
                object.domain == self.domain &&
                object.requests == self.requests &&
                object.encrypted == self.encrypted &&
                object.elapsedSumm == self.elapsedSumm
        }
        return false
    }
}
