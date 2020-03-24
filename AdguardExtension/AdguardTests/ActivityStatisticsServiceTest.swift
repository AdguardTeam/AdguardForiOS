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

class ActivityStatisticsServiceTest: XCTestCase {

    // DB path
    private lazy var path =  { self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db").absoluteString }()
    
    let resources: AESharedResourcesProtocol = SharedResourcesMock()
    var activityStatisticsService: ActivityStatisticsServiceProtocol!
    
    override func setUp() {
        activityStatisticsService = ActivityStatisticsService(resources: resources)
        activityStatisticsService.deleteAllRecords()
    }
    
    func testWriteRecords(){
        let now = Date()
        
        let testRecord1 = ActivityStatisticsRecord(date: now, domain: "testDomain", requests: 10, blocked: 5, savedData: 20)
        let testRecord2 = ActivityStatisticsRecord(date: now, domain: "testDomain1", requests: 15, blocked: 7, savedData: 40)
        let testRecord3 = ActivityStatisticsRecord(date: now, domain: "testDomain3", requests: 20, blocked: 10, savedData: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        
        activityStatisticsService.getAllRecords { (records) in
            XCTAssertEqual(records, testRecords)
        }
    }
    
    func testWriteRecordsWithAddingTheSameDomainInTheSameDay(){
        let testDate = Date.dateFromIso8601("2020-03-24")
        
        let testRecord1 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain", requests: 10, blocked: 5, savedData: 20)
        let testRecord2 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain1", requests: 15, blocked: 7, savedData: 40)
        let testRecord3 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain3", requests: 20, blocked: 10, savedData: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        
        let sameDomainRecord = ActivityStatisticsRecord(date: testDate!, domain: "testDomain", requests: 20, blocked: 10, savedData: 25)
        
        let recordToCheck = ActivityStatisticsRecord(date: testDate!, domain: sameDomainRecord.domain, requests: testRecord1.requests + sameDomainRecord.requests, blocked: testRecord1.blocked + sameDomainRecord.blocked, savedData: testRecord1.savedData + sameDomainRecord.savedData)
        let recordsToCheck = [recordToCheck, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords([sameDomainRecord])
        activityStatisticsService.getAllRecords { (records) in
            XCTAssertEqual(records, recordsToCheck)
        }
    }
    
    func testWriteRecordsWithAddingTheSameDomainInDifferentDay(){
        let testDate = Date.dateFromIso8601("2020-03-24")
        
        let testRecord1 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain", requests: 10, blocked: 5, savedData: 20)
        let testRecord2 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain1", requests: 15, blocked: 7, savedData: 40)
        let testRecord3 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain3", requests: 20, blocked: 10, savedData: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        
        let differentDate = Date.dateFromIso8601("2020-03-25")
        let sameDomainRecord = ActivityStatisticsRecord(date: differentDate!, domain: "testDomain", requests: 20, blocked: 10, savedData: 25)
        
        let recordsToCheck = [testRecord1, testRecord2, testRecord3, sameDomainRecord]
        
        activityStatisticsService.writeRecords([sameDomainRecord])
        activityStatisticsService.getAllRecords { (records) in
            XCTAssertEqual(records, recordsToCheck)
        }
    }
}
