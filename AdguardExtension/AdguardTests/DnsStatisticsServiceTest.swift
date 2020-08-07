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

class DnsStatisticsServiceTest: XCTestCase {

    let resources: AESharedResourcesProtocol = SharedResourcesMock()
    var dnsStatisticsService: DnsStatisticsServiceProtocol!
    
    override func setUp() {
        dnsStatisticsService = DnsStatisticsService(resources: resources)
        dnsStatisticsService.deleteAllRecords()
    }
    
    func testWriteRecords() {
        let date1 = Date(timeIntervalSinceReferenceDate: 10.0)
        let date2 = Date(timeIntervalSinceReferenceDate: 20.0)
        let date3 = Date(timeIntervalSinceReferenceDate: 30.0)
        
        let testRecord1 = DnsStatisticsRecord(date: date1, requests: 10, encrypted: 3, elapsedSumm: 20)
        let testRecord2 = DnsStatisticsRecord(date: date2, requests: 12, encrypted: 7, elapsedSumm: 10)
        let testRecord3 = DnsStatisticsRecord(date: date3, requests: 13, encrypted: 4, elapsedSumm: 30)
        
        let testRecords = [testRecord1, testRecord2, testRecord3]
        
        dnsStatisticsService.writeRecord(testRecord1)
        dnsStatisticsService.writeRecord(testRecord2)
        dnsStatisticsService.writeRecord(testRecord3)
        
        let recordsCount = dnsStatisticsService.getRecordsCount()
        XCTAssertEqual(recordsCount, testRecords.count)
        
        let records = dnsStatisticsService.getAllRecords()
        XCTAssertEqual(records, testRecords)
    }
    
    func testDeleteAllRecords() {
        let date1 = Date(timeIntervalSinceReferenceDate: 10.0)
        let date2 = Date(timeIntervalSinceReferenceDate: 20.0)
        let date3 = Date(timeIntervalSinceReferenceDate: 30.0)
        
        let testRecord1 = DnsStatisticsRecord(date: date1, requests: 10, encrypted: 3, elapsedSumm: 20)
        let testRecord2 = DnsStatisticsRecord(date: date2, requests: 12, encrypted: 7, elapsedSumm: 10)
        let testRecord3 = DnsStatisticsRecord(date: date3, requests: 13, encrypted: 4, elapsedSumm: 30)
        
        dnsStatisticsService.writeRecord(testRecord1)
        dnsStatisticsService.writeRecord(testRecord2)
        dnsStatisticsService.writeRecord(testRecord3)
        
        dnsStatisticsService.deleteAllRecords()
        
        let records = dnsStatisticsService.getAllRecords()
        XCTAssertEqual(records, [])
    }
    
    func testDbRearrangingCount() {
        /* It is needed to add 1501 records to force table rearrange */
        for secondsSinceReferenceDate in 1...1500 {
            let date = Date(timeIntervalSinceReferenceDate: Double(secondsSinceReferenceDate))
            let record = DnsStatisticsRecord(date: date, requests: 10, encrypted: 5, elapsedSumm: 25)
            dnsStatisticsService.writeRecord(record)
        }
        
        let recordsCount = dnsStatisticsService.getRecordsCount()
        XCTAssertEqual(recordsCount, 150)
        
        let records = dnsStatisticsService.getAllRecords()
        for record in records {
            XCTAssertEqual(record.requests, 100)
            XCTAssertEqual(record.encrypted, 50)
            XCTAssertEqual(record.elapsedSumm, 250)
        }
    }
    
    func testGetRecordsByType() {
        let type = ChartDateType.day
        let suitableDate = Date()
        let unsuitableDate = Calendar.current.date(byAdding: .day, value: -2, to: suitableDate)!
        
        let suitableRecord = DnsStatisticsRecord(date: suitableDate, requests: 10, encrypted: 5, elapsedSumm: 30)
        let unsuitableRecord = DnsStatisticsRecord(date: unsuitableDate, requests: 15, encrypted: 7, elapsedSumm: 20)
        
        dnsStatisticsService.writeRecord(suitableRecord)
        dnsStatisticsService.writeRecord(unsuitableRecord)
        
        let recordsCount = dnsStatisticsService.getRecordsCount()
        XCTAssertEqual(recordsCount, 2)
        
        let recordsByType = dnsStatisticsService.getRecords(by: type)
        XCTAssert(recordsByType.contains(suitableRecord))
        
        let requests = recordsByType.map{$0.requests}.reduce(0, {$0 + $1})
        XCTAssertEqual(requests, suitableRecord.requests)
        
        let encrypted = recordsByType.map{$0.encrypted}.reduce(0, {$0 + $1})
        XCTAssertEqual(encrypted, suitableRecord.encrypted)
        
        let elapsedSumm = recordsByType.map{$0.elapsedSumm}.reduce(0, {$0 + $1})
        XCTAssertEqual(elapsedSumm, suitableRecord.elapsedSumm)
    }
}
