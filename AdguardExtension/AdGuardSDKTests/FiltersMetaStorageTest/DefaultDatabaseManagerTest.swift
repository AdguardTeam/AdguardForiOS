import XCTest

class DefaultDatabaseManagerTest: XCTestCase {
    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    override class func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    override class func tearDown() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func tearDown() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    func testUpdateDefaultDbWithSuccess() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))

        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateDefaultDbWithMultipleUpdates() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssert(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbWithSuccess() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbFailure() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            FiltersMetaStorageTestProcessor.deleteTestFolder()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbWithFailureInRootFolder() {
        let manager = DefaultDatabaseManager(dbContainerUrl: rootDirectory)
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        do {
            try manager.updateDefaultDb()
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))

        } catch {
            XCTFail()
        }
    }
    
    func testRemoveDefaultDbIfNotExistsFailure() {
        let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
        XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
        XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        do {
            try manager.removeDefaultDb()
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileRootUrl.path))
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbArchiveRootUrl.path))
            XCTAssertFalse(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.defaultDbFileWorkingUrl.path))
        } catch {
            XCTFail()
        }
    }
    
    func testDefaultDbFileExistsWithSuccess() {
        do {
            let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
            XCTAssertFalse(manager.defaultDbFileExists)
            try manager.updateDefaultDb()
            XCTAssertTrue(manager.defaultDbFileExists)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDefaultDbSchemaVersionWithSuccess() {
        do {
            let manager = DefaultDatabaseManager(dbContainerUrl: workingUrl)
            XCTAssertNil(manager.defaultDbSchemaVersion)
            try manager.updateDefaultDb()
            XCTAssertNotNil(manager.defaultDbSchemaVersion)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
