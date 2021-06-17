import XCTest

class FilterFilesStorageTest: XCTestCase {
    var filterFileStorage: FilterFilesStorageProtocol!
    var jsonFiltersMeta: ExtendedFiltersMeta!
    
    override class func setUp() {
        TestsFileManager.deleteTestFolder()
    }
    
    override func setUpWithError() throws {
        TestsFileManager.deleteTestFolder()
        filterFileStorage = try FilterFilesStorage(filterFilesDirectoryUrl: TestsFileManager.workingUrl)
        
        let jsonUrl = Bundle(for: type(of: self)).url(forResource: "filters_test", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonUrl)
        let decoder = JSONDecoder()
        jsonFiltersMeta = try decoder.decode(ExtendedFiltersMeta.self, from: jsonData)
    }
        
    func testGetFilterContentWithNonExistingId() {
        XCTAssertNil(filterFileStorage.getFilterContentForFilter(withId: -123))
    }
    
    func testGetFiltersContentWithNonExistingIds() {
        XCTAssert(filterFileStorage.getFiltersContentForFilters(withIds: [-1]).isEmpty)
    }
    
    func testSaveFilter() {
        do {
            XCTAssertNil(filterFileStorage.getFilterContentForFilter(withId: 10001))
            try filterFileStorage.saveFilter(withId: 10001, filterContent: "Content")
            let content = filterFileStorage.getFilterContentForFilter(withId: 10001)
            XCTAssertEqual(content, "Content")
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
