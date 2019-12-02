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

@objc enum BlockedRecordType: Int{
    case blocked = 0, whitelisted, tracked, normal
}

@objc(DnsLogRecord)
class DnsLogRecord: NSObject, NSCoding {
    
    let domain: String
    let date: Date
    let elapsed: Int
    let type: String
    let answer: String
    let server: String
    let upstreamAddr: String?
    let bytesSent: Int
    let bytesReceived: Int
    var blockRecordType: BlockedRecordType
    var name: String?
    var company: String?
    var category: String?
    
    init(domain: String, date: Date, elapsed: Int, type: String, answer: String, server: String, upstreamAddr: String, bytesSent: Int, bytesReceived: Int, blockRecordType: BlockedRecordType, name: String?, company: String?, category: String?) {
        
        self.domain = domain
        self.date = date
        self.elapsed = elapsed
        self.type = type
        self.answer = answer
        self.server = server
        self.upstreamAddr = upstreamAddr
        self.bytesSent = bytesSent
        self.bytesReceived = bytesReceived
        self.blockRecordType = blockRecordType
        self.name = name
        self.company = company
        self.category = category
        
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
        aCoder.encode(blockRecordType.rawValue, forKey: "blockRecordType")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(company, forKey: "company")
        aCoder.encode(category, forKey: "category")
        
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
        
        let type = aDecoder.decodeInteger(forKey: "blockRecordType")
        self.blockRecordType = BlockedRecordType.init(rawValue: type) ?? .normal
        
        // These fields can be nil for the old log records
        self.upstreamAddr = aDecoder.decodeObject(forKey: "upstreamAddr") as? String
        
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.company = aDecoder.decodeObject(forKey: "company") as? String
        self.category = aDecoder.decodeObject(forKey: "category") as? String
    }
}

@objcMembers
@objc(RequestsStatisticsBlock)
class RequestsStatisticsBlock: NSObject, NSCoding {
    
    @objc var date: Date
    @objc var numberOfRequests: Int
    
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
    }
    
    required init?(coder: NSCoder) {
        self.date = coder.decodeObject(forKey: "date") as! Date
        self.numberOfRequests = coder.decodeInteger(forKey: "numberOfRequests")
    }
}
