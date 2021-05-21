import XCTest

class FiltersMetaStorage_GroupsTest: XCTestCase {

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
    
    
    func testGetAllGroupsWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let groups = try filtersStorage.getAllGroups()
            XCTAssertNotNil(groups)
            XCTAssertTrue(groups.contains { $0.groupName == "Security"})
            XCTAssertFalse(groups.contains { $0.groupName == "Autres" })

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedGroupsWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "fr")
            XCTAssertNotNil(groups)
            XCTAssertFalse(groups.contains { $0.groupName == "Security"})
            XCTAssertTrue(groups.contains { $0.groupName == "Autres" })

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedGroupsWithNonExistsLanguage() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "123")
            XCTAssertTrue(groups.isEmpty)

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
