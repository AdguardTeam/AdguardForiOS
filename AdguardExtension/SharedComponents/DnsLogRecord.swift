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

@objc(DnsLogRecordStatus)
enum DnsLogRecordStatus: Int {
    typealias RawValue = Int

    case processed, blacklistedByUserFilter, blacklistedByOtherFilter, whitelisted 
}

@objc(DnsLogRecordUserStatus)
enum DnsLogRecordUserStatus: Int {
    typealias RawValue = Int

    case none, movedToBlacklist, movedToWhitelist, removedFromBlacklist, removedFromWhitelist
}

@objc(DnsLogRecord)
class DnsLogRecord: NSObject, NSCoding {
    
    @objc var rowid: NSNumber?
    
    let domain: String
    let date: Date
    let elapsed: Int
    let type: String
    let answer: String
    let server: String
    let upstreamAddr: String?
    let bytesSent: Int
    let bytesReceived: Int
    let status: DnsLogRecordStatus
    var userStatus: DnsLogRecordUserStatus
    let blockRules: [String]?
    let matchedFilterIds: [Int]?
    
    init(domain: String, date: Date, elapsed: Int, type: String, answer: String, server: String, upstreamAddr: String, bytesSent: Int, bytesReceived: Int, status: DnsLogRecordStatus, userStatus: DnsLogRecordUserStatus, blockRules: [String]?, matchedFilterIds: [Int]?) {
        
        self.domain = domain
        self.date = date
        self.elapsed = elapsed
        self.type = type
        self.answer = answer
        self.server = server
        self.upstreamAddr = upstreamAddr
        self.bytesSent = bytesSent
        self.bytesReceived = bytesReceived
        self.status = status
        self.userStatus = userStatus
        self.blockRules = blockRules
        self.matchedFilterIds = matchedFilterIds
        
        self.rowid = -1
        
        super.init()
    }
    
    // MARK: - NSCoding methods
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(domain, forKey: "domain")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(elapsed, forKey: "elapsed")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(answer, forKey: "answer")
        aCoder.encode(server, forKey: "server")
        aCoder.encode(upstreamAddr, forKey: "upstreamAddr")
        aCoder.encode(bytesSent, forKey: "bytesSent")
        aCoder.encode(bytesReceived, forKey: "bytesReceived")
        aCoder.encode(status.rawValue, forKey: "status")
        aCoder.encode(userStatus.rawValue, forKey: "userStatus")
        aCoder.encode(blockRules, forKey: "blockRules")
        aCoder.encode(matchedFilterIds,forKey: "matchedFilterIds")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.domain = aDecoder.decodeObject(forKey: "domain") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.elapsed = aDecoder.decodeInteger(forKey: "elapsed")
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.answer = aDecoder.decodeObject(forKey: "answer") as! String
        self.server = aDecoder.decodeObject(forKey: "server") as! String
        self.bytesSent = aDecoder.decodeInteger(forKey: "bytesSent")
        self.bytesReceived = aDecoder.decodeInteger(forKey: "bytesReceived")
        
        // These fields can be nil for the old log records
        self.upstreamAddr = aDecoder.decodeObject(forKey: "upstreamAddr") as? String
        self.status = DnsLogRecordStatus.init(rawValue: aDecoder.decodeInteger(forKey: "status")) ?? .processed
        self.userStatus = DnsLogRecordUserStatus.init(rawValue: aDecoder.decodeInteger(forKey: "userStatus")) ?? .none
        self.blockRules = aDecoder.decodeObject(forKey: "blockRules") as? [String]
        self.matchedFilterIds = aDecoder.decodeObject(forKey: "matchedFilterIds") as? [Int]
        self.rowid = -1
    }
}
