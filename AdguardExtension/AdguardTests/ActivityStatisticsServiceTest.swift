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
        
        let testRecord1 = ActivityStatisticsRecord(date: now, domain: "testDomain", requests: 10, encrypted: 5, elapsedSumm: 20)
        let testRecord2 = ActivityStatisticsRecord(date: now, domain: "testDomain1", requests: 15, encrypted: 7, elapsedSumm: 40)
        let testRecord3 = ActivityStatisticsRecord(date: now, domain: "testDomain3", requests: 20, encrypted: 10, elapsedSumm: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        
        let records = activityStatisticsService.getAllRecords()
        XCTAssertEqual(records, testRecords)
    }
    
    func testWriteRecordsWithAddingTheSameDomainInTheSameDay(){
        let testDate = Date.dateFromIso8601("2020-03-24")
        
        let testRecord1 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain", requests: 10, encrypted: 5, elapsedSumm: 20)
        let testRecord2 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain1", requests: 15, encrypted: 7, elapsedSumm: 40)
        let testRecord3 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain3", requests: 20, encrypted: 10, elapsedSumm: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        
        let sameDomainRecord = ActivityStatisticsRecord(date: testDate!, domain: "testDomain", requests: 20, encrypted: 10, elapsedSumm: 25)
        
        let recordToCheck = ActivityStatisticsRecord(date: testDate!, domain: sameDomainRecord.domain, requests: testRecord1.requests + sameDomainRecord.requests, encrypted: testRecord1.encrypted + sameDomainRecord.encrypted, elapsedSumm: testRecord1.elapsedSumm + sameDomainRecord.elapsedSumm)
        let recordsToCheck = [recordToCheck, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords([sameDomainRecord])
        let records = activityStatisticsService.getAllRecords()
        XCTAssertEqual(records, recordsToCheck)
    }
    
    func testWriteRecordsWithAddingTheSameDomainInDifferentDay(){
        let testDate = Date.dateFromIso8601("2020-03-24")
        
        let testRecord1 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain", requests: 10, encrypted: 5, elapsedSumm: 20)
        let testRecord2 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain1", requests: 15, encrypted: 7, elapsedSumm: 40)
        let testRecord3 = ActivityStatisticsRecord(date: testDate!, domain: "testDomain3", requests: 20, encrypted: 10, elapsedSumm: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        
        let differentDate = Date.dateFromIso8601("2020-03-25")
        let sameDomainRecord = ActivityStatisticsRecord(date: differentDate!, domain: "testDomain", requests: 20, encrypted: 10, elapsedSumm: 25)
        
        let recordsToCheck = [testRecord1, testRecord2, testRecord3, sameDomainRecord]
        
        activityStatisticsService.writeRecords([sameDomainRecord])
        let records = activityStatisticsService.getAllRecords()
        XCTAssertEqual(records, recordsToCheck)
    }
    
    func testDeleteAllRecords(){
        let now = Date()
        
        let testRecord1 = ActivityStatisticsRecord(date: now, domain: "testDomain", requests: 10, encrypted: 5, elapsedSumm: 20)
        let testRecord2 = ActivityStatisticsRecord(date: now, domain: "testDomain1", requests: 15, encrypted: 7, elapsedSumm: 40)
        let testRecord3 = ActivityStatisticsRecord(date: now, domain: "testDomain3", requests: 20, encrypted: 10, elapsedSumm: 30)
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        activityStatisticsService.writeRecords(testRecords)
        activityStatisticsService.deleteAllRecords()
        let records = activityStatisticsService.getAllRecords()
        XCTAssert(records.isEmpty)
    }
    
    func testGetRecordsByType(){
        let googleRecord1 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "google.com", requests: 10, encrypted: 8, elapsedSumm: 20)
        let googleRecord2 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "google.com", requests: 15, encrypted: 16, elapsedSumm: 30)
        let googleRecord3 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-24")!, domain: "google.com", requests: 20, encrypted: 24, elapsedSumm: 40)
        
        let facebookRecord1 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-24")!, domain: "facebook.com", requests: 5, encrypted: 2, elapsedSumm: 12)
        let facebookRecord2 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-25")!, domain: "facebook.com", requests: 10, encrypted: 4, elapsedSumm: 24)
        let facebookRecord3 = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-25")!, domain: "facebook.com", requests: 15, encrypted: 6, elapsedSumm: 36)
        
        let amazonRecord = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "amazon.com", requests: 22, encrypted: 33, elapsedSumm: 44)
        
        let records = [googleRecord1, googleRecord2, googleRecord3, facebookRecord1, facebookRecord2, facebookRecord3, amazonRecord]
        
        /* Records made in the same day to the same domain will transform into one record */
        
        let jointGoogleRecord = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-26")!, domain: "google.com", requests: googleRecord1.requests + googleRecord2.requests, encrypted: googleRecord1.encrypted + googleRecord2.encrypted, elapsedSumm: googleRecord1.elapsedSumm + googleRecord2.elapsedSumm)
        
        let jointFacebookRecord = ActivityStatisticsRecord(date: Date.dateFromIso8601("2020-03-25")!, domain: "facebook.com", requests: facebookRecord2.requests + facebookRecord3.requests, encrypted: facebookRecord2.encrypted + facebookRecord3.encrypted, elapsedSumm: facebookRecord2.elapsedSumm + facebookRecord3.elapsedSumm)
        
        
        let checkRecords = [amazonRecord, jointGoogleRecord, jointFacebookRecord, facebookRecord1, googleRecord3]
        
        activityStatisticsService.writeRecords(records)
        
        
        let recordsToCheck = activityStatisticsService.getRecords(by: .alltime)
        XCTAssertEqual(recordsToCheck, checkRecords)
    }
}
