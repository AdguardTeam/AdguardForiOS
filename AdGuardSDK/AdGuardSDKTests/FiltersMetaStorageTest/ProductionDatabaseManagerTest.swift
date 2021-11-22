import XCTest
import SQLite

class ProductionDatabaseManagerTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default

    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        TestsFileManager.putDbFileToDirectory(Bundle(for: type(of: self)))
    }

    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }

    func testUpdateDatabaseSucceeded() {
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        let productionDbManager = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        try! productionDbManager.updateDatabaseIfNeeded()
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        let versionTable = Table("version")
        let versionColumn = Expression<String>("schema_version")
        let filtersDb = try! Connection(TestsFileManager.adguardDbFileWorkingUrl.path)
        XCTAssertNotNil(try! filtersDb.pluck(versionTable)?.get(versionColumn))
    }

    func testDBExistsAfterInitialization() {
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        let _ = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)

        let pruductionDb = try! Connection(TestsFileManager.adguardDbFileWorkingUrl.path)
        XCTAssertTrue(try! exists(column: "schema_version", inTable: "version", forDB: pruductionDb))

        let versionTable = Table("version")
        let versionColumn = Expression<String>("schema_version")
        let version = try! pruductionDb.pluck(versionTable)?.get(versionColumn)
        XCTAssertNotNil(version)

        let filterTagsTable = Table("filter_tags")
        let filterTagsColumn = Expression<String>("name")
        let name = try! pruductionDb.pluck(filterTagsTable)?.get(filterTagsColumn)
        XCTAssertNotNil(name)

        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
    }

    func testReset() {
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        let productionDbManager = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)

        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        try! productionDbManager.reset()

        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.adguardDbFileWorkingUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        let versionTable = Table("version")
        let versionColumn = Expression<String>("schema_version")
        let filtersDb = try! Connection(TestsFileManager.adguardDbFileWorkingUrl.path)
        let version = try! filtersDb.pluck(versionTable)?.get(versionColumn)
        XCTAssertTrue(try! exists(column: "affinity", inTable: "filter_rules", forDB: filtersDb))
        XCTAssertTrue(try! exists(column: "subscriptionUrl", inTable: "filters", forDB: filtersDb))
        XCTAssertNotNil(version)
    }

    private func applySchemeToDefaultDb(db: Connection) throws {
        let dbSchemeFileFormat = "schema%@.sql" // %@ stands for schema version
        let version = "0.100" //old version
        let schemaFileName = String(format: dbSchemeFileFormat, version)
        let latestSchemaUrl = rootDirectory.appendingPathComponent(schemaFileName)
        let schemaQuery = try String(contentsOf: latestSchemaUrl)
        try db.execute(schemaQuery)
    }

    private func exists(column: String, inTable table: String, forDB db: Connection) throws -> Bool {
        let statement = try db.prepare("PRAGMA table_info(\(table))")

        let columnNames = statement.makeIterator().map { (row) -> String in
            return row[1] as? String ?? ""
        }

        return columnNames.contains(where: { dbColumn -> Bool in
            return dbColumn.caseInsensitiveCompare(column) == .orderedSame
        })
    }
}
