import XCTest
import SQLite

class DnsStatisticsMigrationHelperTests: XCTestCase {

    let oldStatisticsDbUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns-statistics.db")
    let newStatisticsDbUrl = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("activity_statistics.db")

    var statisticsMigration: DnsStatisticsMigrationHelperProtocol!

    override func setUp() {
        SDKMigrationsDirectoriesManager.clear()
        SDKMigrationsDirectoriesManager.createFolders()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        statisticsMigration = DnsStatisticsMigrationHelper(
            oldContainerFolderUrl: SDKMigrationsDirectoriesManager.rootUrl,
            newContainerDbUrl: SDKMigrationsDirectoriesManager.subfolderUrl
        )
    }

    // MARK: - Test removeOldRequestLogDatabase

    func testRemoveOldRequestLogDatabase() {
        let oldRequestLogUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns-log-records.db")
        let oldRequestDbJournalUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns-log-records.db-journal")

        XCTAssertFalse(FileManager.default.fileExists(atPath: oldRequestLogUrl.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldRequestDbJournalUrl.path))

        FileManager.default.createFile(atPath: oldRequestLogUrl.path, contents: nil, attributes: nil)
        FileManager.default.createFile(atPath: oldRequestDbJournalUrl.path, contents: nil, attributes: nil)

        XCTAssert(FileManager.default.fileExists(atPath: oldRequestLogUrl.path))
        XCTAssert(FileManager.default.fileExists(atPath: oldRequestDbJournalUrl.path))

        try! statisticsMigration.removeOldRequestLogDatabase()

        XCTAssertFalse(FileManager.default.fileExists(atPath: oldRequestLogUrl.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldRequestDbJournalUrl.path))
    }

    // MARK: - Test migrateStatistics

    func testMigrateStatistics() {
        FileManager.default.createFile(atPath: oldStatisticsDbUrl.path, contents: nil, attributes: nil)
        XCTAssert(FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path))

        let dbWrapper = DnsStatisticsDbWrapper(
            oldDnsStatisticsTableUrl: oldStatisticsDbUrl,
            newChartStatisticsUrl: newStatisticsDbUrl
        )
        try! dbWrapper.createOldDnsStatisticsTable()

        let oldRecord1 = (
            timeStamp: Date(timeIntervalSinceReferenceDate: 10),
            requests: 10,
            encrypted: 5,
            elapsedSumm: 30
        )

        let oldRecord2 = (
            timeStamp: Date(timeIntervalSinceReferenceDate: 20),
            requests: 20,
            encrypted: 10,
            elapsedSumm: 40
        )

        let oldRecords = [oldRecord1, oldRecord2]
        oldRecords.forEach {
            try! dbWrapper.addRecordToDnsStatisticsTable(timeStamp: $0.timeStamp, requests: $0.requests, encrypted: $0.encrypted, elapsedSumm: $0.elapsedSumm)
        }
        try! statisticsMigration.migrateStatistics()

        let records = try! dbWrapper.getRecordsFromNewChartStatisticsTable()
        XCTAssertEqual(records.count, oldRecords.count)

        for i in 0..<records.count {
            XCTAssertEqual(oldRecords[i].timeStamp, records[i].timeStamp)
            XCTAssertEqual(oldRecords[i].requests, records[i].requests)
            XCTAssertEqual(oldRecords[i].encrypted, records[i].encrypted)
            XCTAssertEqual(oldRecords[i].elapsedSumm, records[i].elapsed)
            XCTAssertEqual(records[i].blocked, 0)
        }
    }

    // MARK: - Test migrateActivity

    func testMigrateActivity() {
        FileManager.default.createFile(atPath: oldStatisticsDbUrl.path, contents: nil, attributes: nil)
        XCTAssert(FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path))

        let dbWrapper = DnsStatisticsDbWrapper(
            oldDnsStatisticsTableUrl: oldStatisticsDbUrl,
            newChartStatisticsUrl: newStatisticsDbUrl
        )
        try! dbWrapper.createOldActivityStatisticsTable()

        let oldRecord1 = (
            timeStamp: Date(timeIntervalSinceReferenceDate: 10),
            domain: "domain1",
            requests: 10,
            encrypted: 5,
            elapsedSumm: 30
        )

        let oldRecord2 = (
            timeStamp: Date(timeIntervalSinceReferenceDate: 20),
            domain: "domain2",
            requests: 20,
            encrypted: 10,
            elapsedSumm: 40
        )
        let oldRecords = [oldRecord1, oldRecord2]
        oldRecords.forEach {
            try! dbWrapper.addRecordToActivityStatisticsTable(timeStamp: $0.timeStamp, domain: $0.domain, requests: $0.requests, encrypted: $0.encrypted, elapsedSumm: $0.elapsedSumm)
        }
        try! statisticsMigration.migrateActivity()

        let records = try! dbWrapper.getRecordsFromNewActivityStatisticsTable()
        XCTAssertEqual(records.count, oldRecords.count)

        for i in 0..<records.count {
            XCTAssertEqual(oldRecords[i].timeStamp, records[i].timeStamp)
            XCTAssertEqual(oldRecords[i].domain, records[i].domain)
            XCTAssertEqual(oldRecords[i].requests, records[i].requests)
            XCTAssertEqual(oldRecords[i].encrypted, records[i].encrypted)
            XCTAssertEqual(oldRecords[i].elapsedSumm, records[i].elapsed)
            XCTAssertEqual(records[i].blocked, 0)
        }
    }

    // MARK: - Test removeOldStatisticsDatabase

    func testRemoveOldStatisticsDatabase() {
        let oldStatisticsDbUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns-statistics.db")
        let oldStatististicsDbJournalUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns-log-records.db-journal")

        XCTAssertFalse(FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldStatististicsDbJournalUrl.path))

        FileManager.default.createFile(atPath: oldStatisticsDbUrl.path, contents: nil, attributes: nil)
        FileManager.default.createFile(atPath: oldStatististicsDbJournalUrl.path, contents: nil, attributes: nil)

        XCTAssert(FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path))
        XCTAssert(FileManager.default.fileExists(atPath: oldStatististicsDbJournalUrl.path))

        try! statisticsMigration.removeOldStatisticsDatabase()

        XCTAssertFalse(FileManager.default.fileExists(atPath: oldStatisticsDbUrl.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldStatististicsDbJournalUrl.path))
    }

}
