import XCTest

class URL_UtilsTest: XCTestCase {
    
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
    
    func testValidDirectoryUrl() {
        do {
            XCTAssertTrue(TestsFileManager.rootDirectory.isDirectory)
            XCTAssertFalse(TestsFileManager.workingUrl.isDirectory)
            try FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
            
            XCTAssertTrue(TestsFileManager.workingUrl.isDirectory)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUnvalidDirectoryUrl() {
        do {
            XCTAssertTrue(TestsFileManager.rootDirectory.isDirectory)
            XCTAssertFalse(TestsFileManager.workingUrl.isDirectory)
            let testFileUrl = TestsFileManager.workingUrl.appendingPathComponent("testFile")
            
            try FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
            
            XCTAssertFalse(testFileUrl.isDirectory)
            _ = FileManager.default.createFile(atPath: testFileUrl.path, contents: nil, attributes: nil)
            XCTAssertFalse(testFileUrl.isDirectory)
        } catch {
            XCTFail("\(error)")
        }
    }
}
