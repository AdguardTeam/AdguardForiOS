import XCTest

class ChartStatisticsTest: XCTestCase {
    var statistics: ChartStatisticsProtocol!
    
    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
        
        statistics = try! ChartStatistics(statisticsDbContainerUrl: TestsFileManager.workingUrl)
    }
    
    override class func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    func testGetRecordsForDifferentPeriods() {
        let stat = statistics as! ChartStatistics
        
        let dateInInterval: (_ interval: DateInterval) -> Date = { interval in
            let mean = (interval.end.timeIntervalSinceReferenceDate + interval.start.timeIntervalSinceReferenceDate) / 2
            return Date(timeIntervalSinceReferenceDate: mean)
        }
        
        let dateIntervals = StatisticsPeriod.activityCompressionIntervals
        
        let todayIntervalDate = dateInInterval(dateIntervals[0])
        let todayRecord = ChartStatisticsRecord(timeStamp: todayIntervalDate, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: todayRecord)
        
        let dayIntervalDate = dateInInterval(dateIntervals[1])
        let dayRecord = ChartStatisticsRecord(timeStamp: dayIntervalDate, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: dayRecord)
        
        let weekIntervalDate = dateInInterval(dateIntervals[2])
        let weekRecord = ChartStatisticsRecord(timeStamp: weekIntervalDate, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: weekRecord)
        
        let monthIntervalDate = dateInInterval(dateIntervals[3])
        let monthRecord = ChartStatisticsRecord(timeStamp: monthIntervalDate, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: monthRecord)
        
        let allIntervalDate = dateInInterval(dateIntervals[4])
        let allRecord = ChartStatisticsRecord(timeStamp: allIntervalDate, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        statistics.process(record: allRecord)
        
        // Today interval tests
        var recordsFromDb = try! stat.getRecords(for: .today)
        XCTAssertEqual(recordsFromDb.count, 1)
        XCTAssertEqual(recordsFromDb.first!, todayRecord)
        
        // Day interval tests
        recordsFromDb = try! stat.getRecords(for: .day)
        XCTAssertEqual(recordsFromDb.count, 2)
        XCTAssertEqual(recordsFromDb[0], dayRecord)
        XCTAssertEqual(recordsFromDb[1], todayRecord)
    
        // Week interval tests
        recordsFromDb = try! stat.getRecords(for: .week)
        XCTAssertEqual(recordsFromDb.count, 3)
        XCTAssertEqual(recordsFromDb[0], weekRecord)
        XCTAssertEqual(recordsFromDb[1], dayRecord)
        XCTAssertEqual(recordsFromDb[2], todayRecord)
        
        // Month interval tests
        recordsFromDb = try! stat.getRecords(for: .month)
        XCTAssertEqual(recordsFromDb.count, 4)
        XCTAssertEqual(recordsFromDb[0], monthRecord)
        XCTAssertEqual(recordsFromDb[1], weekRecord)
        XCTAssertEqual(recordsFromDb[2], dayRecord)
        XCTAssertEqual(recordsFromDb[3], todayRecord)
        
        // All interval tests
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 5)
        XCTAssertEqual(recordsFromDb[0], allRecord)
        XCTAssertEqual(recordsFromDb[1], monthRecord)
        XCTAssertEqual(recordsFromDb[2], weekRecord)
        XCTAssertEqual(recordsFromDb[3], dayRecord)
        XCTAssertEqual(recordsFromDb[4], todayRecord)
    }
    
    func testGetPoints() {
        let now = Date()
        let record1 = ChartStatisticsRecord(timeStamp: now - 10, requests: 10, encrypted: 2, blocked: 3, elapsedSumm: 120)
        let record2 = ChartStatisticsRecord(timeStamp: now, requests: 20, encrypted: 3, blocked: 5, elapsedSumm: 230)
        statistics.process(record: record1)
        statistics.process(record: record2)
        
        let points = try! statistics.getPoints(for: .encrypted, for: .all)
        check(points: points, chartType: .encrypted, sum: 5)
    }
    
    func testGetPointsWithEmptyDb() {
        let stat = statistics as! ChartStatistics
        
        let recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssert(recordsFromDb.isEmpty)
        
        var points = try! statistics.getPoints(for: .requests, for: .all)
        check(points: points, chartType: .requests, sum: 0)
        
        points = try! statistics.getPoints(for: .requests, for: .month)
        check(points: points, chartType: .requests, sum: 0)
        
        points = try! statistics.getPoints(for: .requests, for: .week)
        check(points: points, chartType: .requests, sum: 0)
        
        points = try! statistics.getPoints(for: .requests, for: .day)
        check(points: points, chartType: .requests, sum: 0)
        
        points = try! statistics.getPoints(for: .requests, for: .today)
        check(points: points, chartType: .requests, sum: 0)
    }
    
    func testGetPointsWithDifferentPeriods() {
        let stat = statistics as! ChartStatistics
        let intervals = StatisticsPeriod.activityCompressionIntervals
        
        let todayInterval = intervals[0]
        let todayRecords = [
            ChartStatisticsRecord(timeStamp: todayInterval.end - 100, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1),
            ChartStatisticsRecord(timeStamp: todayInterval.end - 200, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1),
            ChartStatisticsRecord(timeStamp: todayInterval.end - 300, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        ]
        
        let dayInterval = intervals[1]
        let dayRecords = [
            ChartStatisticsRecord(timeStamp: dayInterval.end - 1000, requests: 2, encrypted: 2, blocked: 2, elapsedSumm: 2),
            ChartStatisticsRecord(timeStamp: dayInterval.end - 2000, requests: 2, encrypted: 2, blocked: 2, elapsedSumm: 2),
            ChartStatisticsRecord(timeStamp: dayInterval.end - 3000, requests: 2, encrypted: 2, blocked: 2, elapsedSumm: 2),
            ChartStatisticsRecord(timeStamp: dayInterval.end - 4000, requests: 2, encrypted: 2, blocked: 2, elapsedSumm: 2)
        ]
        
        let weekInterval = intervals[2]
        let weekRecords = [
            ChartStatisticsRecord(timeStamp: weekInterval.end - 10000, requests: 3, encrypted: 3, blocked: 3, elapsedSumm: 3),
            ChartStatisticsRecord(timeStamp: weekInterval.end - 20000, requests: 3, encrypted: 3, blocked: 3, elapsedSumm: 3)
        ]
        
        let monthInterval = intervals[3]
        let monthRecords = [
            ChartStatisticsRecord(timeStamp: monthInterval.end - 100000, requests: 4, encrypted: 4, blocked: 4, elapsedSumm: 4)
        ]
        
        let allInterval = intervals[4]
        let allRecords = [
            ChartStatisticsRecord(timeStamp: allInterval.end - 100000, requests: 5, encrypted: 5, blocked: 5, elapsedSumm: 5),
            ChartStatisticsRecord(timeStamp: allInterval.end - 200000, requests: 5, encrypted: 5, blocked: 5, elapsedSumm: 5),
            ChartStatisticsRecord(timeStamp: allInterval.end - 300000, requests: 5, encrypted: 5, blocked: 5, elapsedSumm: 5)
        ]
        
        // Save records to DB
        todayRecords.forEach { try! stat.add(record: $0) }
        dayRecords.forEach { try! stat.add(record: $0) }
        weekRecords.forEach { try! stat.add(record: $0) }
        monthRecords.forEach { try! stat.add(record: $0) }
        allRecords.forEach { try! stat.add(record: $0) }
        let recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 13)
        
        // Check points
        let todayPoints = try! statistics.getPoints(for: .requests, for: .today)
        check(points: todayPoints, chartType: .requests, sum: 3)
        
        let dayPoints = try! statistics.getPoints(for: .encrypted, for: .day)
        check(points: dayPoints, chartType: .encrypted, sum: 11)
        
        let weekPoints = try! statistics.getPoints(for: .blocked, for: .week)
        check(points: weekPoints, chartType: .blocked, sum: 17)
        
        let monthPoints = try! statistics.getPoints(for: .elapsed, for: .month)
        check(points: monthPoints, chartType: .elapsed, sum: 21)
        
        let allPoints = try! statistics.getPoints(for: .requests, for: .all)
        check(points: allPoints, chartType: .requests, sum: 36)
    }
    
    func testGetPointsWithLotsOfRecords() {
        let stat = statistics as! ChartStatistics
        
        let now = Date()
        let records: [ChartStatisticsRecord] = (0..<1000).map ({ i -> ChartStatisticsRecord in
            let time = now - Double(i * 1000)
            return ChartStatisticsRecord(timeStamp: time, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        })
        
        records.forEach { try! stat.add(record: $0) }
        let recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 1000)
        
        let points = try! statistics.getPoints(for: .requests, for: .all)
        check(points: points, chartType: .requests, sum: 1000)
    }
    
    func testProcessRecordAddsRecordToDb() {
        let stat = statistics as! ChartStatistics
        
        let record1 = ChartStatisticsRecord(timeStamp: Date(), requests: 10, encrypted: 2, blocked: 3, elapsedSumm: 120)
        statistics.process(record: record1)
        var recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 1)
        XCTAssertEqual(recordsFromDb.first!, record1)
        
        let record2 = ChartStatisticsRecord(timeStamp: Date(), requests: 20, encrypted: 3, blocked: 5, elapsedSumm: 230)
        statistics.process(record: record2)
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 2)
        XCTAssertEqual(recordsFromDb, [record1, record2])
    }
    
    func testComressTableIfNeeded() {
        let stat = statistics as! ChartStatistics
        
        let now = Date()
        let records: [ChartStatisticsRecord] = (0..<1000).map ({ i -> ChartStatisticsRecord in
            let time = now - Double(i * 1000)
            return ChartStatisticsRecord(timeStamp: time, requests: 1, encrypted: 1, blocked: 1, elapsedSumm: 1)
        })
        
        records.forEach { try! stat.add(record: $0) }
        var recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 1000)
        
        try! stat.compressTableIfNeeded()
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 100)
        
        // Check that points aren't lost
        var requests = 0
        var encrypted = 0
        var blocked = 0
        var elapsedSum = 0
        var recordsDates: [Date] = []
        recordsFromDb.forEach {
            requests += $0.requests
            encrypted += $0.encrypted
            blocked += $0.blocked
            elapsedSum += $0.elapsedSumm
            recordsDates.append($0.timeStamp)
        }
        
        XCTAssertEqual(requests, 1000)
        XCTAssertEqual(encrypted, 1000)
        XCTAssertEqual(blocked, 1000)
        XCTAssertEqual(elapsedSum, 1000)
        
        // Check records order
        XCTAssert(recordsDates.isSorted(isOrderedBefore: <))
    }
    
    func testTryingToCompressEmptyTable() {
        let stat = statistics as! ChartStatistics
        XCTAssertNoThrow(try stat.compressTable())
    }
    
    func testReset() {
        let stat = statistics as! ChartStatistics
        
        let record1 = ChartStatisticsRecord(timeStamp: Date(), requests: 10, encrypted: 2, blocked: 3, elapsedSumm: 120)
        let record2 = ChartStatisticsRecord(timeStamp: Date(), requests: 20, encrypted: 3, blocked: 5, elapsedSumm: 230)
        statistics.process(record: record1)
        statistics.process(record: record2)
        var recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssertEqual(recordsFromDb.count, 2)
        XCTAssertEqual(recordsFromDb, [record1, record2])
        
        try! statistics.reset()
        
        recordsFromDb = try! stat.getRecords(for: .all)
        XCTAssert(recordsFromDb.isEmpty)
    }
    
    private func check(points: ChartRecords, chartType: ChartType, sum: Int) {
        XCTAssertEqual(points.chartType, chartType)
        XCTAssertEqual(points.points.count, 100)
        XCTAssert(points.points.isSorted(isOrderedBefore: { $0.x < $1.x }))
        XCTAssertEqual(points.points.reduce(0, { $0 + $1.y }), sum)
    }
}
