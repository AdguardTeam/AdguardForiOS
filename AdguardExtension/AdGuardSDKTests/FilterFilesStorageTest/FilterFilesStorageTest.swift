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
    
    func testUpdateFilter() {
        let filtersIds = jsonFiltersMeta.filters.compactMap({ $0.filterId })
        XCTAssert(filterFileStorage.getFiltersContentForFilters(withIds: filtersIds).isEmpty)
        var expectations = [XCTestExpectation]()
        for id in filtersIds {
            let expectation = XCTestExpectation()
            expectations.append(expectation)
            filterFileStorage.updateFilter(withId: id) { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: expectations, timeout: 5.0)
        let filters = filterFileStorage.getFiltersContentForFilters(withIds: filtersIds)
        XCTAssertFalse(filters.isEmpty)
        XCTAssertEqual(filters.count, filtersIds.count)
    }
    
    func testUpdateCustomFilter() {
        let subscriptionUrl = URL(string: "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt")!
        let expectation = XCTestExpectation()
        XCTAssertNil(filterFileStorage.getFilterContentForFilter(withId: 10001))

        filterFileStorage.updateCustomFilter(withId: 10001, subscriptionUrl: subscriptionUrl) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(filterFileStorage.getFilterContentForFilter(withId: 10001))
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
