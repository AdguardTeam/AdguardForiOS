import XCTest

class ActivityStatisticsTest: XCTestCase {
    
    var statistics: ActivityStatisticsProtocol!
    
    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
        
        statistics = try! ActivityStatistics(statisticsDbContainerUrl: TestsFileManager.workingUrl)
    }
    
    override class func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    func testAddRecord() {
        let stat = statistics as! ActivityStatistics
        var recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssert(recordsFromDb.isEmpty)
        
        let record1 = ActivityStatisticsRecord(timeStamp: Date(), domain: "domain1", requests: 10, encrypted: 2, blocked: 3, elapsedSumm: 5)
        try! stat.add(record: record1)
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 1)
        XCTAssertEqual(record1, recordsFromDb[0])
        
        let record2 = ActivityStatisticsRecord(timeStamp: Date(), domain: "domain2", requests: 5, encrypted: 4, blocked: 1, elapsedSumm: 10)
        try! stat.add(record: record2)
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 2)
        XCTAssertEqual(recordsFromDb, [record1, record2])
    }
    
    func testCompressTable() {
        let stat = statistics as! ActivityStatistics
        let intervals = StatisticsPeriod.activityCompressionIntervals
        
        // Today interval
        
        let todayInterval = intervals[0]
        
        let recordsToCompressForTodayInterval = [
            ActivityStatisticsRecord(timeStamp: todayInterval.end - 100, domain: "google.com", requests: 10, encrypted: 2, blocked: 3, elapsedSumm: 12),
            ActivityStatisticsRecord(timeStamp: todayInterval.end - 100, domain: "google.com", requests: 5, encrypted: 1, blocked: 4, elapsedSumm: 10),
            ActivityStatisticsRecord(timeStamp: todayInterval.end - 1000, domain: "ya.ru", requests: 2, encrypted: 1, blocked: 1, elapsedSumm: 4),
            ActivityStatisticsRecord(timeStamp: todayInterval.end - 2000, domain: "yahoo.net", requests: 12, encrypted: 3, blocked: 2, elapsedSumm: 9)
        ]
        let expectedTodayIntervalRecords = [
            ActivityStatisticsRecord(timeStamp: todayInterval.end - 100, domain: "google.com", requests: 15, encrypted: 3, blocked: 7, elapsedSumm: 22),
            ActivityStatisticsRecord(timeStamp: todayInterval.end - 1000, domain: "ya.ru", requests: 2, encrypted: 1, blocked: 1, elapsedSumm: 4),
            ActivityStatisticsRecord(timeStamp: todayInterval.end - 2000, domain: "yahoo.net", requests: 12, encrypted: 3, blocked: 2, elapsedSumm: 9)
        ]
        let expectedTodayCountersStatistics = CountersStatisticsRecord(requests: 29, encrypted: 7, blocked: 10, elapsedSumm: 35)
        let expectedTodayDomainsStatistics = [
            DomainsStatisticsRecord(domain: "google.com", counters: CountersStatisticsRecord(requests: 15, encrypted: 3, blocked: 7, elapsedSumm: 22)),
            DomainsStatisticsRecord(domain: "yahoo.net", counters: CountersStatisticsRecord(requests: 12, encrypted: 3, blocked: 2, elapsedSumm: 9)),
            DomainsStatisticsRecord(domain: "ya.ru", counters: CountersStatisticsRecord(requests: 2, encrypted: 1, blocked: 1, elapsedSumm: 4))
        ]
        
        // Day interval
        
        let dayInterval = intervals[1]
        
        let recordsToCompressForDayInterval = [
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 1200, domain: "google.com", requests: 6, encrypted: 1, blocked: 2, elapsedSumm: 11),
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 1400, domain: "adguard.com", requests: 7, encrypted: 1, blocked: 4, elapsedSumm: 5),
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 1800, domain: "google.com", requests: 4, encrypted: 1, blocked: 1, elapsedSumm: 3),
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 2000, domain: "adguard.com", requests: 12, encrypted: 3, blocked: 2, elapsedSumm: 9),
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 2000, domain: "yahoo.net", requests: 12, encrypted: 5, blocked: 2, elapsedSumm: 11)
        ]
        let expectedDayIntervalRecords = [
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 1500, domain: "google.com", requests: 10, encrypted: 2, blocked: 3, elapsedSumm: 14),
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 1700, domain: "adguard.com", requests: 19, encrypted: 4, blocked: 6, elapsedSumm: 14),
            ActivityStatisticsRecord(timeStamp: dayInterval.end - 2000, domain: "yahoo.net", requests: 12, encrypted: 5, blocked: 2, elapsedSumm: 11)
        ]
        let expectedDayCountersStatistics = CountersStatisticsRecord(requests: 70, encrypted: 18, blocked: 21, elapsedSumm: 74)
        let expectedDayDomainsStatistics = [ // Sums up with expectedTodayDomainsStatistics
            DomainsStatisticsRecord(domain: "google.com", counters: CountersStatisticsRecord(requests: 25, encrypted: 5, blocked: 10, elapsedSumm: 36)),
            DomainsStatisticsRecord(domain: "yahoo.net", counters: CountersStatisticsRecord(requests: 24, encrypted: 8, blocked: 4, elapsedSumm: 20)),
            DomainsStatisticsRecord(domain: "adguard.com", counters: CountersStatisticsRecord(requests: 19, encrypted: 4, blocked: 6, elapsedSumm: 14)),
            DomainsStatisticsRecord(domain: "ya.ru", counters: CountersStatisticsRecord(requests: 2, encrypted: 1, blocked: 1, elapsedSumm: 4))
        ]
        
        // Week interval
        
        let weekInterval = intervals[2]
        
        let recordsToCompressForWeekInterval = [
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 100, domain: "google.com", requests: 10, encrypted: 5, blocked: 3, elapsedSumm: 10),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 200, domain: "ya.ru", requests: 12, encrypted: 3, blocked: 8, elapsedSumm: 11),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 300, domain: "reddit.com", requests: 11, encrypted: 4, blocked: 1, elapsedSumm: 32),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 400, domain: "ya.ru", requests: 9, encrypted: 2, blocked: 0, elapsedSumm: 12),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 500, domain: "google.com", requests: 19, encrypted: 6, blocked: 1, elapsedSumm: 34),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 600, domain: "amazon.com", requests: 14, encrypted: 9, blocked: 2, elapsedSumm: 45),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 700, domain: "lenta.ru", requests: 4, encrypted: 0, blocked: 3, elapsedSumm: 63),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 900, domain: "google.com", requests: 7, encrypted: 1, blocked: 5, elapsedSumm: 23)
        ]
        let expectedWeekIntervalRecords = [
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 300, domain: "reddit.com", requests: 11, encrypted: 4, blocked: 1, elapsedSumm: 32),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 300, domain: "ya.ru", requests: 21, encrypted: 5, blocked: 8, elapsedSumm: 23),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 500, domain: "google.com", requests: 36, encrypted: 12, blocked: 9, elapsedSumm: 67),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 600, domain: "amazon.com", requests: 14, encrypted: 9, blocked: 2, elapsedSumm: 45),
            ActivityStatisticsRecord(timeStamp: weekInterval.end - 700, domain: "lenta.ru", requests: 4, encrypted: 0, blocked: 3, elapsedSumm: 63),
        ]
        let expectedWeekCountersStatistics = CountersStatisticsRecord(requests: 156, encrypted: 48, blocked: 44, elapsedSumm: 304)
        let expectedWeekDomainsStatistics = [ // Sums up with expectedDayDomainsStatistics
            DomainsStatisticsRecord(domain: "google.com", counters: CountersStatisticsRecord(requests: 61, encrypted: 17, blocked: 19, elapsedSumm: 103)),
            DomainsStatisticsRecord(domain: "yahoo.net", counters: CountersStatisticsRecord(requests: 24, encrypted: 8, blocked: 4, elapsedSumm: 20)),
            DomainsStatisticsRecord(domain: "ya.ru", counters: CountersStatisticsRecord(requests: 23, encrypted: 6, blocked: 9, elapsedSumm: 27)),
            DomainsStatisticsRecord(domain: "adguard.com", counters: CountersStatisticsRecord(requests: 19, encrypted: 4, blocked: 6, elapsedSumm: 14)),
            DomainsStatisticsRecord(domain: "amazon.com", counters: CountersStatisticsRecord(requests: 14, encrypted: 9, blocked: 2, elapsedSumm: 45)),
            DomainsStatisticsRecord(domain: "reddit.com", counters: CountersStatisticsRecord(requests: 11, encrypted: 4, blocked: 1, elapsedSumm: 32)),
            DomainsStatisticsRecord(domain: "lenta.ru", counters: CountersStatisticsRecord(requests: 4, encrypted: 0, blocked: 3, elapsedSumm: 63))
        ]
        
        // Month interval
        
        let monthInterval = intervals[3]

        let recordsToCompressForMonthInterval = [
            ActivityStatisticsRecord(timeStamp: monthInterval.end - 100, domain: "lenta.ru", requests: 4, encrypted: 0, blocked: 3, elapsedSumm: 63),
            ActivityStatisticsRecord(timeStamp: monthInterval.end - 300, domain: "ya.ru", requests: 9, encrypted: 2, blocked: 0, elapsedSumm: 12)
        ]
        let expectedMonthIntervalRecords = [
            ActivityStatisticsRecord(timeStamp: monthInterval.end - 100, domain: "lenta.ru", requests: 4, encrypted: 0, blocked: 3, elapsedSumm: 63),
            ActivityStatisticsRecord(timeStamp: monthInterval.end - 300, domain: "ya.ru", requests: 9, encrypted: 2, blocked: 0, elapsedSumm: 12)
        ]
        let expectedMonthCountersStatistics = CountersStatisticsRecord(requests: 169, encrypted: 50, blocked: 47, elapsedSumm: 398)
        let expectedMonthDomainsStatistics = [ // Sums up with expectedWeekDomainsStatistics
            DomainsStatisticsRecord(domain: "google.com", counters: CountersStatisticsRecord(requests: 61, encrypted: 17, blocked: 19, elapsedSumm: 103)),
            DomainsStatisticsRecord(domain: "ya.ru", counters: CountersStatisticsRecord(requests: 32, encrypted: 8, blocked: 9, elapsedSumm: 58)),
            DomainsStatisticsRecord(domain: "yahoo.net", counters: CountersStatisticsRecord(requests: 24, encrypted: 8, blocked: 4, elapsedSumm: 20)),
            DomainsStatisticsRecord(domain: "adguard.com", counters: CountersStatisticsRecord(requests: 19, encrypted: 4, blocked: 6, elapsedSumm: 14)),
            DomainsStatisticsRecord(domain: "amazon.com", counters: CountersStatisticsRecord(requests: 14, encrypted: 9, blocked: 2, elapsedSumm: 45)),
            DomainsStatisticsRecord(domain: "reddit.com", counters: CountersStatisticsRecord(requests: 11, encrypted: 4, blocked: 1, elapsedSumm: 32)),
            DomainsStatisticsRecord(domain: "lenta.ru", counters: CountersStatisticsRecord(requests: 8, encrypted: 0, blocked: 6, elapsedSumm: 126))
        ]
        
        recordsToCompressForTodayInterval.forEach { statistics.process(record: $0) }
        var recordsFromDb = try! stat.getRecords(for: .all)
        var countersDb = try! statistics.getCounters(for: .all)
        var domainsDb = try! statistics.getDomains(for: .all)
        compare(recordsFromDb, recordsToCompressForTodayInterval)
        compare(domainsDb, expectedTodayDomainsStatistics)
        XCTAssertEqual(countersDb, expectedTodayCountersStatistics)
        
        recordsToCompressForDayInterval.forEach { statistics.process(record: $0) }
        recordsFromDb = try! stat.getRecords(for: .all)
        countersDb = try! statistics.getCounters(for: .all)
        domainsDb = try! statistics.getDomains(for: .all)
        compare(recordsFromDb, recordsToCompressForTodayInterval + recordsToCompressForDayInterval)
        compare(domainsDb, expectedDayDomainsStatistics)
        XCTAssertEqual(countersDb, expectedDayCountersStatistics)
        
        recordsToCompressForWeekInterval.forEach { statistics.process(record: $0) }
        recordsFromDb = try! stat.getRecords(for: .all)
        countersDb = try! statistics.getCounters(for: .all)
        domainsDb = try! statistics.getDomains(for: .all)
        compare(recordsFromDb, recordsToCompressForTodayInterval + recordsToCompressForDayInterval + recordsToCompressForWeekInterval)
        compare(domainsDb, expectedWeekDomainsStatistics)
        XCTAssertEqual(countersDb, expectedWeekCountersStatistics)
        
        recordsToCompressForMonthInterval.forEach { statistics.process(record: $0) }
        recordsFromDb = try! stat.getRecords(for: .all)
        countersDb = try! statistics.getCounters(for: .all)
        domainsDb = try! statistics.getDomains(for: .all)
        compare(recordsFromDb, recordsToCompressForTodayInterval + recordsToCompressForDayInterval + recordsToCompressForWeekInterval + recordsToCompressForMonthInterval)
        compare(domainsDb, expectedMonthDomainsStatistics)
        XCTAssertEqual(countersDb, expectedMonthCountersStatistics)
        
        try! stat.compressTable()
        recordsFromDb = try! stat.getRecords(for: .all)
        countersDb = try! statistics.getCounters(for: .all)
        domainsDb = try! statistics.getDomains(for: .all)
        compare(recordsFromDb, expectedTodayIntervalRecords + expectedDayIntervalRecords + expectedWeekIntervalRecords + expectedMonthIntervalRecords)
        
        // Statistics shouldn't change after compression
        countersDb = try! statistics.getCounters(for: .all)
        domainsDb = try! statistics.getDomains(for: .all)
        compare(domainsDb, expectedMonthDomainsStatistics)
        XCTAssertEqual(countersDb, expectedMonthCountersStatistics)
    }
    
    func testGetRecordsWithEmptyDb() {
        let stat = statistics as! ActivityStatistics
        let recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssert(recordsFromDb.isEmpty)
    }
    
    func testGetCountersWithEmptyDb() {
        let countersFromDb = try! statistics.getCounters(for: .all)
        XCTAssertEqual(countersFromDb, CountersStatisticsRecord(requests: 0, encrypted: 0, blocked: 0, elapsedSumm: 0))
    }
    
    func testGetDomainsWithEmptyDb() {
        let domainsFromDb = try! statistics.getDomains(for: .all)
        XCTAssert(domainsFromDb.isEmpty)
    }
    
    func testStatisticsFunctionsWithDifferentPeriods() {
        let stat = statistics as! ActivityStatistics
        
        let dateInInterval: (_ interval: DateInterval) -> Date = { interval in
            let mean = (interval.end.timeIntervalSinceReferenceDate + interval.start.timeIntervalSinceReferenceDate) / 2
            return Date(timeIntervalSinceReferenceDate: mean)
        }
        
        let dateIntervals = StatisticsPeriod.activityCompressionIntervals
        
        let todayIntervalDate = dateInInterval(dateIntervals[0])
        let todayRecord = ActivityStatisticsRecord(timeStamp: todayIntervalDate, domain: "today_domain", requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: todayRecord)
        
        let dayIntervalDate = dateInInterval(dateIntervals[1])
        let dayRecord = ActivityStatisticsRecord(timeStamp: dayIntervalDate, domain: "day_domain", requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: dayRecord)
        
        let weekIntervalDate = dateInInterval(dateIntervals[2])
        let weekRecord = ActivityStatisticsRecord(timeStamp: weekIntervalDate, domain: "week_domain", requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: weekRecord)
        
        let monthIntervalDate = dateInInterval(dateIntervals[3])
        let monthRecord = ActivityStatisticsRecord(timeStamp: monthIntervalDate, domain: "month_domain", requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: monthRecord)
        
        let allIntervalDate = dateInInterval(dateIntervals[4])
        let allRecord = ActivityStatisticsRecord(timeStamp: allIntervalDate, domain: "all_domain", requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: allRecord)
        
        // Today interval tests
        var recordsFromDb = try! stat.getRecords(for: .today)
        XCTAssertEqual(recordsFromDb.count, 1)
        XCTAssertEqual(recordsFromDb.first!, todayRecord)
        
        var countersDb = try! statistics.getCounters(for: .today)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1))
        
        var domainsDb = try! statistics.getDomains(for: .today)
        XCTAssertEqual(domainsDb.count, 1)
        XCTAssertEqual(domainsDb.first!, DomainsStatisticsRecord(domain: "today_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        
        // Day interval tests
        recordsFromDb = try! stat.getRecords(for: .day)
        XCTAssertEqual(recordsFromDb.count, 2)
        XCTAssertEqual(recordsFromDb[0], todayRecord)
        XCTAssertEqual(recordsFromDb[1], dayRecord)
        
        countersDb = try! statistics.getCounters(for: .day)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 2, encrypted: 2, blocked: 2, elapsedSumm: 2))
        
        domainsDb = try! statistics.getDomains(for: .day)
        XCTAssertEqual(domainsDb.count, 2)
        XCTAssertEqual(domainsDb[0], DomainsStatisticsRecord(domain: "day_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[1], DomainsStatisticsRecord(domain: "today_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        
        // Week interval tests
        recordsFromDb = try! stat.getRecords(for: .week)
        XCTAssertEqual(recordsFromDb.count, 3)
        XCTAssertEqual(recordsFromDb[0], todayRecord)
        XCTAssertEqual(recordsFromDb[1], dayRecord)
        XCTAssertEqual(recordsFromDb[2], weekRecord)
        
        countersDb = try! statistics.getCounters(for: .week)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 3, encrypted: 3, blocked: 3, elapsedSumm: 3))
        
        domainsDb = try! statistics.getDomains(for: .week)
        XCTAssertEqual(domainsDb.count, 3)
        XCTAssertEqual(domainsDb[0], DomainsStatisticsRecord(domain: "day_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[1], DomainsStatisticsRecord(domain: "today_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[2], DomainsStatisticsRecord(domain: "week_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        
        // Month interval tests
        recordsFromDb = try! stat.getRecords(for: .month)
        XCTAssertEqual(recordsFromDb.count, 4)
        XCTAssertEqual(recordsFromDb[0], todayRecord)
        XCTAssertEqual(recordsFromDb[1], dayRecord)
        XCTAssertEqual(recordsFromDb[2], weekRecord)
        XCTAssertEqual(recordsFromDb[3], monthRecord)
        
        countersDb = try! statistics.getCounters(for: .month)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 4, encrypted: 4, blocked: 4, elapsedSumm: 4))
        
        domainsDb = try! statistics.getDomains(for: .month)
        XCTAssertEqual(domainsDb.count, 4)
        XCTAssertEqual(domainsDb[0], DomainsStatisticsRecord(domain: "day_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[1], DomainsStatisticsRecord(domain: "month_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[2], DomainsStatisticsRecord(domain: "today_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[3], DomainsStatisticsRecord(domain: "week_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        
        // All interval tests
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 5)
        XCTAssertEqual(recordsFromDb[0], todayRecord)
        XCTAssertEqual(recordsFromDb[1], dayRecord)
        XCTAssertEqual(recordsFromDb[2], weekRecord)
        XCTAssertEqual(recordsFromDb[3], monthRecord)
        XCTAssertEqual(recordsFromDb[4], allRecord)
        
        countersDb = try! statistics.getCounters(for: .all)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 5, encrypted: 5, blocked: 5, elapsedSumm: 5))
        
        domainsDb = try! statistics.getDomains(for: .all)
        XCTAssertEqual(domainsDb.count, 5)
        XCTAssertEqual(domainsDb[0], DomainsStatisticsRecord(domain: "all_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[1], DomainsStatisticsRecord(domain: "day_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[2], DomainsStatisticsRecord(domain: "month_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[3], DomainsStatisticsRecord(domain: "today_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
        XCTAssertEqual(domainsDb[4], DomainsStatisticsRecord(domain: "week_domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
    }

    func testCompressTableIfNeeded() {
        let stat = statistics as! ActivityStatistics
        
        let now = Date()
        let records: [ActivityStatisticsRecord] = (0..<1000).map ({ i -> ActivityStatisticsRecord in
            let time = now - Double(i * 10000)
            return ActivityStatisticsRecord(timeStamp: time, domain: "domain\(i)", requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        })
        
        records.forEach { statistics.process(record: $0) }
        records.forEach { statistics.process(record: $0) }
        
        var recordsFromDb = try! stat.getRecords(for: .all)
        var countersDb = try! statistics.getCounters(for: .all)
        var domainsDb = try! statistics.getDomains(for: .all)
        XCTAssertEqual(recordsFromDb.count, 2000)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 2000, encrypted: 2000, blocked: 2000, elapsedSumm: 2000))
        XCTAssertEqual(domainsDb.count, 1000)
        
        try! stat.compressTable()
        recordsFromDb = try! stat.getRecords(for: .all)
        countersDb = try! statistics.getCounters(for: .all)
        domainsDb = try! statistics.getDomains(for: .all)
        
        // Records number should decrease twice, but statistics shouldn't change
        XCTAssertEqual(recordsFromDb.count, 1000)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 2000, encrypted: 2000, blocked: 2000, elapsedSumm: 2000))
        XCTAssertEqual(domainsDb.count, 1000)
    }
    
    func testProcessRecordAddsRecords() {
        let stat = statistics as! ActivityStatistics
        
        let record = ActivityStatisticsRecord(timeStamp: Date(), domain: "domain", requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: record)
        
        let recordsFromDb = try! stat.getRecords(for: .all)
        let countersDb = try! statistics.getCounters(for: .all)
        let domainsDb = try! statistics.getDomains(for: .all)
        
        XCTAssertEqual(recordsFromDb.count, 1)
        XCTAssertEqual(recordsFromDb.first!, record)
        XCTAssertEqual(countersDb, CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1))
        XCTAssertEqual(domainsDb.count, 1)
        XCTAssertEqual(domainsDb.first!, DomainsStatisticsRecord(domain: "domain", counters: CountersStatisticsRecord(requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)))
    }
    
    func testReset() {
        let stat = statistics as! ActivityStatistics
        
        let record1 = ActivityStatisticsRecord(timeStamp: Date(), domain: "domain1", requests: 10, encrypted: 2, blocked: 3, elapsedSumm: 5)
        let record2 = ActivityStatisticsRecord(timeStamp: Date(), domain: "domain2", requests: 5, encrypted: 4, blocked: 1, elapsedSumm: 10)
        statistics.process(record: record1)
        statistics.process(record: record2)
        
        var recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 2)
        XCTAssertEqual(recordsFromDb, [record1, record2])
        
        try! statistics.reset()
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssert(recordsFromDb.isEmpty)
    
        // Check records are normally added
        statistics.process(record: record1)
        statistics.process(record: record2)
        
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 2)
        XCTAssertEqual(recordsFromDb, [record1, record2])
    }
    
    private func compare<Element: Equatable>(_ expected: [Element], _ real: [Element]) {
        XCTAssertEqual(expected.count, real.count, "Different array size, expected has \(expected.count) elements, real has \(real.count) elements")
        
        for i in 0..<expected.count {
            let exp = expected[i]
            let rl = real[i]
            
            XCTAssertEqual(exp, rl, "Elements differ at index=\(i)")
        }
    }
}
