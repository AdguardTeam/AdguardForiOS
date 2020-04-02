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
    
    func testDeleteAllRecords(){
        let now = Date()
        
        let testRecord1 = ActivityStatisticsRecord(date: now, domain: "testDomain", requests: 10, blocked: 5, savedData: 20)
        let testRecord2 = ActivityStatisticsRecord(date: now, domain: "testDomain1", requests: 15, blocked: 7, savedData: 40)
        let testRecord3 = ActivityStatisticsRecord(date: now, domain: "testDomain3", requests: 20, blocked: 10, savedData: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        activityStatisticsService.deleteAllRecords()
        activityStatisticsService.getAllRecords { (records) in
            XCTAssert(records.isEmpty)
        }
    }
    
    func testGetRecordsByType(){
        let googleRecord1 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "google.com", requests: 10, blocked: 8, savedData: 20)
        let googleRecord2 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "google.com", requests: 15, blocked: 16, savedData: 30)
        let googleRecord3 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-24")!, domain: "google.com", requests: 20, blocked: 24, savedData: 40)
        
        let facebookRecord1 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-24")!, domain: "facebook.com", requests: 5, blocked: 2, savedData: 12)
        let facebookRecord2 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-25")!, domain: "facebook.com", requests: 10, blocked: 4, savedData: 24)
        let facebookRecord3 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-25")!, domain: "facebook.com", requests: 15, blocked: 6, savedData: 36)
        
        let amazonRecord = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "amazon.com", requests: 22, blocked: 33, savedData: 44)
        
        let records = [googleRecord1, googleRecord2, googleRecord3, facebookRecord1, facebookRecord2, facebookRecord3, amazonRecord]
        
        /* Records made in the same day to the same domain will transform into one record */
        
        let jointGoogleRecord = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "google.com", requests: googleRecord1.requests + googleRecord2.requests, blocked: googleRecord1.blocked + googleRecord2.blocked, savedData: googleRecord1.savedData + googleRecord2.savedData)
        
        let jointFacebookRecord = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-25")!, domain: "facebook.com", requests: facebookRecord2.requests + facebookRecord3.requests, blocked: facebookRecord2.blocked + facebookRecord3.blocked, savedData: facebookRecord2.savedData + facebookRecord3.savedData)
        
        
        let checkRecords = [amazonRecord, jointGoogleRecord, jointFacebookRecord, facebookRecord1, googleRecord3]
        
        activityStatisticsService.writeRecords(records)
        
        
        activityStatisticsService.getRecords(by: .alltime) { (records) in
            XCTAssertEqual(records, checkRecords)
        }
    }
}
