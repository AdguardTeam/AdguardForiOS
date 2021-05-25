import XCTest

class UtilsTest: XCTestCase {
    
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
    
    func testValidDirectoryUrl() {
        do {
            XCTAssertTrue(FiltersMetaStorageTestProcessor.rootDirectory.isDirectory)
            XCTAssertFalse(FiltersMetaStorageTestProcessor.workingUrl.isDirectory)
            try FileManager.default.createDirectory(at: FiltersMetaStorageTestProcessor.workingUrl, withIntermediateDirectories: false, attributes: nil)
            
            XCTAssertTrue(FiltersMetaStorageTestProcessor.workingUrl.isDirectory)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUnvalidDirectoryUrl() {
        do {
            XCTAssertTrue(FiltersMetaStorageTestProcessor.rootDirectory.isDirectory)
            XCTAssertFalse(FiltersMetaStorageTestProcessor.workingUrl.isDirectory)
            let testFileUrl = FiltersMetaStorageTestProcessor.workingUrl.appendingPathComponent("testFile")
            
            try FileManager.default.createDirectory(at: FiltersMetaStorageTestProcessor.workingUrl, withIntermediateDirectories: false, attributes: nil)
            
            XCTAssertFalse(testFileUrl.isDirectory)
            _ = FileManager.default.createFile(atPath: testFileUrl.path, contents: nil, attributes: nil)
            XCTAssertFalse(testFileUrl.isDirectory)
        } catch {
            XCTFail("\(error)")
        }
    }
}
