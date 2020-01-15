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

@objcMembers
@objc(RequestsStatisticsBlock)
class RequestsStatisticsBlock: NSObject, NSCoding {

    @objc var date: Date
    @objc var numberOfRequests: Int {
        didSet {
            self.savedKbytes = numberOfRequests * Int.random(in: 10..<50)
        }
    }
    @objc var savedKbytes: Int = 0

    init(date: Date, numberOfRequests: Int) {
        self.date = date
        self.numberOfRequests = numberOfRequests
        super.init()
    }

    override var debugDescription: String {
        return "date = \(self.date) \n seconds = \(self.date.timeIntervalSinceReferenceDate) \n number = \(self.numberOfRequests) \r\n\r\n"
    }

    // MARK: - NSCoding methods

    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: "date")
        coder.encode(numberOfRequests, forKey: "numberOfRequests")
        coder.encode(savedKbytes, forKey: "savedKbytes")
    }

    required init?(coder: NSCoder) {
        self.date = coder.decodeObject(forKey: "date") as! Date
        self.numberOfRequests = coder.decodeInteger(forKey: "numberOfRequests")
        self.savedKbytes = coder.decodeInteger(forKey: "savedKbytes")
     }
 }
