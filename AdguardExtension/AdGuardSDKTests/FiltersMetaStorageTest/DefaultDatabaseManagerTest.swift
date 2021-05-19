import XCTest

class DefaultDatabaseManagerTest: XCTestCase {
    let rootDirectory = Bundle(for: DefaultDatabaseManager.self).resourceURL!
    let workingUrl = Bundle(for: DefaultDatabaseManager.self).resourceURL!.appendingPathComponent("testFolder")
    let fileManager = FileManager.default
    
    let defaultDbFileName = "default.db"
    let defaultDbArchiveFileName = "default.db.zip"
    

    override func tearDown() {
        let _ = deleteTestFolder()
    }
    
    func testUpdateDefaultDbWithSuccess() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssert(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateDefaultDbWithMultipleUpdate() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssert(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
            
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssert(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))

        } catch {
            XCTFail()
        }
    }
    
    func testUpdateDefaultDbWithFailure() {
        let manager = DefaultDatabaseManager(dbContainerUrl: rootDirectory)
        do {
            try manager.updateDefaultDb()
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbSucces() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        do {
            try manager.updateDefaultDb()
            try manager.removeDefaultDb()
            
            XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbFailure() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        do {
            try manager.updateDefaultDb()
            let _ = deleteTestFolder()
            try manager.removeDefaultDb()
            
            XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbFailureInRootFolder() {
        let manager = DefaultDatabaseManager(dbContainerUrl: rootDirectory)
        do {
            try manager.updateDefaultDb()
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbIfNotExistsFailure() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        do {
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))

        } catch {
            XCTFail()
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
}
