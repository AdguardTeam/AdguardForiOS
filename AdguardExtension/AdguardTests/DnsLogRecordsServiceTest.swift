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

import XCTest

class DnsLogRecordsServiceTest: XCTestCase {

    var service: DnsLogRecordsService!
    var resources = SharedResourcesMock()
    
    override func setUp() {
        resources.reset()
        service = DnsLogRecordsService(resources: resources)
    }

    override func tearDown() {
    }
    
    func testAddRecord() {
        let recordToSave = DnsLogRecord(domain: "domain", date: Date(), elapsed: 100, type: "type", answer: "answer", server: "server", upstreamAddr: "upstream", bytesSent: 100, bytesReceived: 100, status: .processed, userStatus: .none, blockRules: nil, matchedFilterIds: nil)
        service.writeRecords([recordToSave])
        
        let records = service.readRecords()
        XCTAssertEqual(records.count, 1)
        
        guard let record = records.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(record.domain, recordToSave.domain)
        XCTAssertEqual(record.date, recordToSave.date)
        XCTAssertEqual(record.elapsed, recordToSave.elapsed)
        XCTAssertEqual(record.type, recordToSave.type)
        XCTAssertEqual(record.answer, recordToSave.answer)
        XCTAssertEqual(record.server, recordToSave.server)
        XCTAssertEqual(record.upstreamAddr, recordToSave.upstreamAddr)
        XCTAssertEqual(record.bytesSent, recordToSave.bytesSent)
        XCTAssertEqual(record.bytesReceived, recordToSave.bytesReceived)
        XCTAssertEqual(record.status, recordToSave.status)
        XCTAssertEqual(record.userStatus, recordToSave.userStatus)
        XCTAssertEqual(record.blockRules, recordToSave.blockRules)
    }
    
    func testClearLog() {
        
        testAddRecord()
        service.clearLog()
        
        let records = service.readRecords()
        XCTAssertEqual(records.count, 0)
    }
}
