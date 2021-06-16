import XCTest

class DefaultDatabaseManagerTest: XCTestCase {
    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default
    
    override class func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    override class func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    func testUpdateDefaultDbWithSuccess() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateDefaultDbWithMultipleUpdates() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
            
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbWithSuccess() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbFailure() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
            
            TestsFileManager.deleteTestFolder()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbWithFailureInRootFolder() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: rootDirectory)
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbIfNotExistsFailure() {
        let manager = try! DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
        do {
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: TestsFileManager.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: TestsFileManager.defaultDbFileWorkingUrl.path))
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
