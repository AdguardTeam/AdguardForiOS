import XCTest

class FiltersMetaStorage_TagsTest: XCTestCase {

    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager?
    var filtersStorage: FiltersMetaStorage?
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager!)
    }
    
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
    
    func testGetAllTagsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getAllTags()
            XCTAssertFalse(tags.isEmpty)
            tags.forEach {
                XCTAssertNotNil($0.tagId)
                XCTAssertNotNil($0.tagName)
                XCTAssertFalse($0.tagName.isEmpty)
                XCTAssertNotNil($0.tagType)
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetTagsForFilterWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertFalse(tags.isEmpty)
            tags.forEach {
                XCTAssertNotNil($0.tagId)
                XCTAssertNotNil($0.tagName)
                XCTAssertFalse($0.tagName.isEmpty)
                XCTAssertNotNil($0.tagType)
            }
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetTagsForFilterWithNonExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            var tags = try filtersStorage.getTagsForFilter(withId: 123456789)
            XCTAssertTrue(tags.isEmpty)
            
            tags = try filtersStorage.getTagsForFilter(withId: -123456789)
            XCTAssertTrue(tags.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
