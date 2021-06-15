import XCTest

class URL_UtilsTest: XCTestCase {
    
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
    
    func testValidDirectoryUrl() {
        do {
            XCTAssertTrue(MetaStorageTestProcessor.rootDirectory.isDirectory)
            XCTAssertFalse(MetaStorageTestProcessor.workingUrl.isDirectory)
            try FileManager.default.createDirectory(at: MetaStorageTestProcessor.workingUrl, withIntermediateDirectories: false, attributes: nil)
            
            XCTAssertTrue(MetaStorageTestProcessor.workingUrl.isDirectory)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUnvalidDirectoryUrl() {
        do {
            XCTAssertTrue(MetaStorageTestProcessor.rootDirectory.isDirectory)
            XCTAssertFalse(MetaStorageTestProcessor.workingUrl.isDirectory)
            let testFileUrl = MetaStorageTestProcessor.workingUrl.appendingPathComponent("testFile")
            
            try FileManager.default.createDirectory(at: MetaStorageTestProcessor.workingUrl, withIntermediateDirectories: false, attributes: nil)
            
            XCTAssertFalse(testFileUrl.isDirectory)
            _ = FileManager.default.createFile(atPath: testFileUrl.path, contents: nil, attributes: nil)
            XCTAssertFalse(testFileUrl.isDirectory)
        } catch {
            XCTFail("\(error)")
        }
    }
}
