import XCTest

class FiltersMetaStorage_LangsTest: XCTestCase {

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
    
    func testGetLangsForFilterWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let lang = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertTrue(lang.contains { $0 == "ru"} )
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLangsForFilterWithNonExistsId() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            var lang = try filtersStorage.getLangsForFilter(withId: 123456789)
            XCTAssertTrue(lang.isEmpty)
            
            lang = try filtersStorage.getLangsForFilter(withId: -123456789)
            XCTAssertTrue(lang.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
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
        let adguardDbFileName = "adguard.db"
        
        do {
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(defaultDbFileName))
            }
            
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(adguardDbFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(adguardDbFileName))
            }
        } catch {}
    }
}
