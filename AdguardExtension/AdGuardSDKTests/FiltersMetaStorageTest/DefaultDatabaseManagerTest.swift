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
        XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
        XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
        XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))

        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssert(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateDefaultDbWithMultipleUpdates() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
        XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
        XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
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
    
    func testRemoveDefaultDbWithSuccess() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
        XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbFailure() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
        XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
        XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
            
            let _ = deleteTestFolder()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbWithFailureInRootFolder() {
        let manager = DefaultDatabaseManager(dbContainerUrl: rootDirectory)
        XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
        XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
        do {
            try manager.updateDefaultDb()
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbIfNotExistsFailure() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
        XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
        XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
        do {
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path))
            XCTAssertFalse(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(defaultDbFileName).path))
            XCTAssertTrue(fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbArchiveFileName).path))
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
