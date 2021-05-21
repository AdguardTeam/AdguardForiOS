import XCTest

class FiltersMetaStorage_TagsTest: XCTestCase {

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
    
    func getAllTagsWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let tags = try filtersStorage.getAllTags()
            XCTAssertNotNil(tags)
            XCTAssertFalse(tags.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetTagsForFilterWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertNotNil(tags)
            XCTAssertFalse(tags.isEmpty)
            XCTAssertTrue(tags.contains { $0.tagType == .lang} )
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetTagsForFilterWithNonExistsFilterId() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            var tags = try filtersStorage.getTagsForFilter(withId: 123456789)
            XCTAssertNotNil(tags)
            XCTAssertTrue(tags.isEmpty)
            
            tags = try filtersStorage.getTagsForFilter(withId: -123456789)
            XCTAssertNotNil(tags)
            XCTAssertTrue(tags.isEmpty)
            
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
