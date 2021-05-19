import XCTest
import SQLite

class ProductionDatabaseManagerTest: XCTestCase {

    let rootDirectory = Bundle(for: DefaultDatabaseManager.self).resourceURL!
    let workingUrl = Bundle(for: DefaultDatabaseManager.self).resourceURL!.appendingPathComponent("testFolder")
    let fileManager = FileManager.default
    
    let defaultDbFileName = "default.db"
    let defaultDbArchiveFileName = "default.db.zip"
    let adguardDbFileName = "adguard.db"
    
    override func tearDownWithError() throws {
        let _ = deleteTestFolder()
    }
    
    override class func tearDown() {
        clearRootDirectory()
    }

    func testUpdateDatabaseSucceded() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            try productionDbManager.updateDatabaseIfNeeded()
            XCTAssertTrue(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(adguardDbFileName).path))
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            
            let versionTable = Table("version")
            let versionColumn = Expression<String>("schema_version")
            let filtersDb = try Connection(workingUrl.appendingPathComponent(adguardDbFileName).path)
            XCTAssertNotNil(try filtersDb.pluck(versionTable)?.get(versionColumn))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateDatabaseWithNewVersionSuccedded() {
        do {
            try setUpOldVersionProductionDb()

            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            try productionDbManager.updateDatabaseIfNeeded()
            XCTAssertTrue(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(adguardDbFileName).path))
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            
            let versionTable = Table("version")
            let versionColumn = Expression<String>("schema_version")
            let filtersDb = try Connection(workingUrl.appendingPathComponent(adguardDbFileName).path)
            let version = try filtersDb.pluck(versionTable)?.get(versionColumn)
            XCTAssertTrue(try exists(column: "affinity", inTable: "filter_rules", forDB: filtersDb))
            XCTAssertNotNil(version)
            XCTAssertNotEqual(version, "0.100")
        } catch {
            XCTFail("\(error)")
        }
    }
        
    private func applySchemeToDefaultDb(db: Connection) throws {
        let dbSchemeFileFormat = "schema%@.sql" // %@ stands for schema version
        let version = "0.100" //old version
        let schemaFileName = String(format: dbSchemeFileFormat, version)
        let latestSchemaUrl = rootDirectory.appendingPathComponent(schemaFileName)
        let schemaQuery = try String(contentsOf: latestSchemaUrl)
        try db.execute(schemaQuery)
    }
    
    private func setUpOldVersionProductionDb() throws {
        
        try fileManager.createDirectory(at: workingUrl, withIntermediateDirectories: true, attributes: nil)
        
        let prudctionDb = try Connection(workingUrl.appendingPathComponent(adguardDbFileName).path)
        try applySchemeToDefaultDb(db: prudctionDb)

        XCTAssertTrue(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(adguardDbFileName).path))
        
        let versionTable = Table("version")
        let versionColumn = Expression<String>("schema_version")
        let productionVersion = try prudctionDb.pluck(versionTable)?.get(versionColumn)

        XCTAssertEqual(productionVersion, "0.100")
        XCTAssertFalse(try exists(column: "affinity", inTable: "filter_rules", forDB: prudctionDb))
        XCTAssertTrue(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(adguardDbFileName).path))
    }
    
    private func exists(column: String, inTable table: String, forDB db: Connection) throws -> Bool {
        let statement = try db.prepare("PRAGMA table_info(\(table))")
        
        let columnNames = statement.makeIterator().map { (row) -> String in
            return row[1] as? String ?? ""
        }
        
        return columnNames.contains(where: { dbColumn -> Bool in
            return dbColumn.caseInsensitiveCompare(column) == ComparisonResult.orderedSame
        })
    }
    
    private func deleteTestFolder() -> Bool {
        do {
            try fileManager.removeItem(atPath: workingUrl.path)
            return true
        } catch {
            return false
        }
    }
    
    private static func clearRootDirectory() {
        let rootDirectory = Bundle(for: DefaultDatabaseManager.self).resourceURL!
        let fileManager = FileManager.default
        
        let defaultDbFileName = "default.db"
        let defaultDbArchiveFileName = "default.db.zip"
        
        do {
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(defaultDbFileName))
            }
            
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(defaultDbArchiveFileName))
            }
        } catch {}
    }
}
