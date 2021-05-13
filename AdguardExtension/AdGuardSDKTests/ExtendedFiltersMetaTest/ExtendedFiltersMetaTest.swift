import XCTest

class ExtendedFiltersMetaTest: XCTestCase {
    
    func testExtendedFiltersMetaIsDecodedProperly() {
        let jsonUrl = Bundle(for: type(of: self)).url(forResource: "filters_test", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonUrl)
        
        do {
            let decoder = JSONDecoder()
            let extendedFiltersMeta = try decoder.decode(ExtendedFiltersMeta.self, from: jsonData)
            
            XCTAssertEqual(extendedFiltersMeta.tags.count, 64)
            extendedFiltersMeta.tags.forEach { tag in
                XCTAssertFalse(tag.tagName.isEmpty)
            }
            
            XCTAssertEqual(extendedFiltersMeta.groups.count, 7)
            extendedFiltersMeta.groups.forEach { group in
                XCTAssertFalse(group.groupName.isEmpty)
            }
            
            XCTAssertEqual(extendedFiltersMeta.filters.count, 81)
            extendedFiltersMeta.filters.forEach { filter in
                XCTAssertNotNil(filter.name)
                XCTAssertNotNil(filter.description)
                XCTAssertNotNil(filter.timeAdded)
                XCTAssertNotNil(filter.homePage)
                XCTAssertNotNil(filter.updateFrequency)
                XCTAssertNotNil(filter.filterDownloadPage)
                XCTAssertNotNil(filter.lastUpdateDate)
                XCTAssertNotNil(filter.version)
            }
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
