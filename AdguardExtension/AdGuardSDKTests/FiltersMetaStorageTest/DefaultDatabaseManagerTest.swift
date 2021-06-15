import XCTest

class DefaultDatabaseManagerTest: XCTestCase {
    let rootDirectory = MetaStorageTestProcessor.rootDirectory
    let workingUrl = MetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    override class func setUp() {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
    }
    
    override class func tearDown() {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func tearDown() {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
    }
    
    func testUpdateDefaultDbWithSuccess() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))

        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateDefaultDbWithMultipleUpdates() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbWithSuccess() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbFailure() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            MetaStorageTestProcessor.deleteTestFolder()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbWithFailureInRootFolder() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: rootDirectory)
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbIfNotExistsFailure() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: MetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testDefaultDbFileExistsWithSuccess() {
        do {
            let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
            XCTAssertFalse(manager.defaultDbFileExists)
            try manager.updateDefaultDb()
            XCTAssertTrue(manager.defaultDbFileExists)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDefaultDbSchemaVersionWithSuccess() {
        do {
            let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
            XCTAssertNil(manager.defaultDbSchemaVersion)
            try manager.updateDefaultDb()
            XCTAssertNotNil(manager.defaultDbSchemaVersion)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
