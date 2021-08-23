import XCTest

class FilterFilesStorageTest: XCTestCase {
    var filterFileStorage: FilterFilesStorageProtocol!
    
    override class func setUp() {
        TestsFileManager.deleteTestFolder()
    }
    
    override func setUpWithError() throws {
        TestsFileManager.deleteTestFolder()
        filterFileStorage = try FilterFilesStorage(filterFilesDirectoryUrl: TestsFileManager.workingUrl)
    }
        
    func testGetFilterContentWithNonExistingId() {
        XCTAssertNil(filterFileStorage.getFilterContentForFilter(withId: -123))
    }
    
    func testGetFilterContentWithExistingId() {
        try! filterFileStorage.saveFilter(withId: 10001, filterContent: "Content1")
        let content = filterFileStorage.getFilterContentForFilter(withId: 10001)
        XCTAssertEqual(content, "Content1")
    }
    
    func testGetFiltersContentWithExistingIds() {
        try! filterFileStorage.saveFilter(withId: 10001, filterContent: "Content1")
        try! filterFileStorage.saveFilter(withId: 10002, filterContent: "Content2")
        
        let content = filterFileStorage.getFiltersContentForFilters(withIds: [10001, 10002])
        XCTAssertEqual(content.count, 2)
        XCTAssertEqual(content[10001], "Content1")
        XCTAssertEqual(content[10002], "Content2")
    }
    
    func testGetFiltersContentWithNonExistingIds() {
        XCTAssert(filterFileStorage.getFiltersContentForFilters(withIds: [-1]).isEmpty)
    }
    
    func testSaveFilter() {
        XCTAssertNil(filterFileStorage.getFilterContentForFilter(withId: 10001))
        
        try! filterFileStorage.saveFilter(withId: 10001, filterContent: "Content")
        let content = filterFileStorage.getFilterContentForFilter(withId: 10001)
        
        XCTAssertEqual(content, "Content")
    }
    
    func testDeleteFilter() {
        try! filterFileStorage.saveFilter(withId: 10001, filterContent: "Content")
        let content = filterFileStorage.getFilterContentForFilter(withId: 10001)
        XCTAssertEqual(content, "Content")
        
        try! filterFileStorage.deleteFilter(withId: 10001)
        XCTAssertNil(filterFileStorage.getFilterContentForFilter(withId: 10001))
    }
    
    func testDeleteFilterWithNonExistingFilter() {
        XCTAssertThrowsError(try filterFileStorage.deleteFilter(withId: 10))
    }
    
    func testReset() {
        try! filterFileStorage.saveFilter(withId: 10001, filterContent: "Content1")
        try! filterFileStorage.saveFilter(withId: 10002, filterContent: "Content2")
        
        let content = filterFileStorage.getFiltersContentForFilters(withIds: [10001, 10002])
        XCTAssertEqual(content.count, 2)
        XCTAssertEqual(content[10001], "Content1")
        XCTAssertEqual(content[10002], "Content2")
        
        try! filterFileStorage.reset()
        let contentAfterReset = filterFileStorage.getFiltersContentForFilters(withIds: [10001, 10002])
        XCTAssert(contentAfterReset.isEmpty)
        
        // Check if the server is operating as usual after reset
        try! filterFileStorage.saveFilter(withId: 10003, filterContent: "Content3")
        let content2 = filterFileStorage.getFilterContentForFilter(withId: 10003)
        XCTAssertEqual(content2, "Content3")
    }
}
