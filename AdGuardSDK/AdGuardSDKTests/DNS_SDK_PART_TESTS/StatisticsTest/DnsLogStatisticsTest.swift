import XCTest

class DnsLogStatisticsTest: XCTestCase {
    
    var statistics: DnsLogStatisticsProtocol!
    
    let mockEvent1 = DnsRequestProcessedEvent(domain: "domain1",
                                              startDate: Date(),
                                              elapsed: 100,
                                              type: "A",
                                              answer: "Empty",
                                              processedStatus: .processed,
                                              originalAnswer: "",
                                              upstream: DnsUpstream(upstream: "1.1.1.1", protocol: .dns),
                                              bytesSent: 100,
                                              bytesReceived: 10,
                                              blockRules: [],
                                              cacheHit: true)
    
    let mockEvent2 = DnsRequestProcessedEvent(domain: "domain2",
                                              startDate: Date(),
                                              elapsed: 134,
                                              type: "AAAA",
                                              answer: "Empty",
                                              processedStatus: .blocklistedByDnsFilter,
                                              originalAnswer: "answer",
                                              upstream: DnsUpstream(upstream: "https", protocol: .doh),
                                              bytesSent: 200,
                                              bytesReceived: 20,
                                              blockRules: [],
                                              cacheHit: false)
    
    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
        
        statistics = try! DnsLogStatistics(statisticsDbContainerUrl: TestsFileManager.workingUrl)
    }
    
    override class func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    func testProcessEvent() {
        statistics.process(event: mockEvent1)
        statistics.process(event: mockEvent2)
        
        let records = try! statistics.getDnsLogRecords()
        XCTAssertEqual(records, [mockEvent1, mockEvent2])
    }
    
    func testGetDnsLogRecords() {
        let records = generateRecords(1000)
        records.forEach { statistics.process(event: $0) }
        
        let recordsFromDb = try! statistics.getDnsLogRecords()
        let dates = recordsFromDb.map { $0.startDate }
        XCTAssert(dates.isSorted(isOrderedBefore: >=))
    }
    
    func testPurge() {
        let records = generateRecords(1499)
        records.forEach { statistics.process(event: $0) }
        var recordsFromDb = try! statistics.getDnsLogRecords()
        XCTAssertEqual(recordsFromDb.count, records.count)
        
        // This records should be removed
        let oldestRecords = Array(records[0...499])
        
        // Check log is purged
        statistics.process(event: mockEvent1)
        recordsFromDb = try! statistics.getDnsLogRecords()
        XCTAssertEqual(recordsFromDb.count, 1000)
        
        // Check proper records removed
        recordsFromDb.forEach { XCTAssertFalse(oldestRecords.contains($0)) }
        
        //  Check new record is added
        statistics.process(event: mockEvent2)
        recordsFromDb = try! statistics.getDnsLogRecords()
        XCTAssertEqual(recordsFromDb.count, 1001)
        
        // Check records order
        let dates = recordsFromDb.map { $0.startDate }
        XCTAssert(dates.isSorted(isOrderedBefore: >=))
    }
    
    func testReset() {
        let records = generateRecords(1000)
        records.forEach { statistics.process(event: $0) }
        
        var recordsFromDb = try! statistics.getDnsLogRecords()
        XCTAssertEqual(recordsFromDb.count, records.count)
        
        try! statistics.reset()
        recordsFromDb = try! statistics.getDnsLogRecords()
        XCTAssert(recordsFromDb.isEmpty)
    }
    
    private func generateRecords(_ n: Int) -> [DnsRequestProcessedEvent] {
        return (1...n).map { i -> DnsRequestProcessedEvent in
            DnsRequestProcessedEvent(domain: "domain\(i)",
                                     startDate: Date(timeIntervalSinceReferenceDate: Double(100000 * i)),
                                     elapsed: i,
                                     type: "type\(i)",
                                     answer: "answer\(i)",
                                     processedStatus: .allowlistedByDnsFilter,
                                     originalAnswer: "originalAnswer\(i)",
                                     upstream: DnsUpstream(upstream: "upstream\(i)", protocol: .dns),
                                     bytesSent: i,
                                     bytesReceived: i * 2,
                                     blockRules: [],
                                     cacheHit: true)
        }
    }
}
