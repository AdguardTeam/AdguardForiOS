import XCTest

class FiltersMetaStorage_TagsTest: XCTestCase {

    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager?
    var filtersStorage: FiltersMetaStorage?
    
    let testTags = [ExtendedFiltersMeta.Tag(tagId: 100, tagType: .lang, tagName: "foo#101"),
                    ExtendedFiltersMeta.Tag(tagId: 101, tagType: .obsolete, tagName: "foo#102"),
                    ExtendedFiltersMeta.Tag(tagId: 102, tagType: .platform, tagName: "foo#103")]
    
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
        let filtersStorage = filtersStorage!
        do {
            let tags = try filtersStorage.getAllTags()
            XCTAssertFalse(tags.isEmpty)
            tags.forEach {
                XCTAssertNotNil($0.tagId)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name.isEmpty)
                XCTAssertNotNil($0.type)
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetTagsForFilterWithSuccess() {
        let filtersStorage = filtersStorage!
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertFalse(tags.isEmpty)
            tags.forEach {
                XCTAssertNotNil($0.tagId)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name.isEmpty)
                XCTAssertNotNil($0.type)
            }
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetTagsForFilterWithNonExistingFilterId() {
        let filtersStorage = filtersStorage!
        do {
            var tags = try filtersStorage.getTagsForFilter(withId: 123456789)
            XCTAssertTrue(tags.isEmpty)
            
            tags = try filtersStorage.getTagsForFilter(withId: -123456789)
            XCTAssertTrue(tags.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAll() {
        let filtersStorage = filtersStorage!
        do {
            var tags = try filtersStorage.getTagsForFilter(withId: 10000)
            XCTAssert(tags.isEmpty)
            
            try filtersStorage.updateAll(tags: testTags, forFilterWithId: 10000)
            tags = try filtersStorage.getTagsForFilter(withId: 10000)
            XCTAssertFalse(tags.isEmpty)
            testTags.forEach { testTag in
                XCTAssert(tags.contains {
                    testTag.tagId == $0.tagId &&
                    testTag.tagName == $0.name &&
                    testTag.tagType.id == $0.type
                })
            }
            
            try filtersStorage.updateAll(tags: [.init(tagId: 4, tagType: .obsolete, tagName: "bar")], forFilterWithId: 10000)
            tags = try filtersStorage.getTagsForFilter(withId: 10000)
            XCTAssertFalse(tags.isEmpty)
            testTags.forEach { testTag in
                XCTAssertFalse(tags.contains {
                    testTag.tagId == $0.tagId &&
                    testTag.tagName == $0.name &&
                    testTag.tagType.id == $0.type
                })
            }
            XCTAssertEqual(tags.count, 1)
            XCTAssert(tags.contains {
                $0.tagId == 4 &&
                $0.name == "bar" &&
                $0.type == ExtendedFiltersMeta.Tag.TagType.obsolete.id &&
                $0.filterId == 10000
            })
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAllWithEmptyValue() {
        let filtersStorage = filtersStorage!
        do {
            XCTAssertFalse(try filtersStorage.getTagsForFilter(withId: 1).isEmpty)
            try filtersStorage.updateAll(tags: [], forFilterWithId: 1)
            XCTAssert(try filtersStorage.getTagsForFilter(withId: 1).isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteTagsForFilters() {
        let filtersStorage = filtersStorage!
        do {
            var tags1 = try filtersStorage.getTagsForFilter(withId: 1)
            var tags2 = try filtersStorage.getTagsForFilter(withId: 233)
            var tags3 = try filtersStorage.getTagsForFilter(withId: 249)
            var tags4 = try filtersStorage.getTagsForFilter(withId: 214)

            XCTAssertFalse(tags1.isEmpty)
            XCTAssertFalse(tags2.isEmpty)
            XCTAssertFalse(tags3.isEmpty)
            XCTAssertFalse(tags4.isEmpty)
            
            try filtersStorage.deleteTagsForFilters(withIds: [1])
            
            tags1 = try filtersStorage.getTagsForFilter(withId: 1)
            tags2 = try filtersStorage.getTagsForFilter(withId: 233)
            tags3 = try filtersStorage.getTagsForFilter(withId: 249)
            tags4 = try filtersStorage.getTagsForFilter(withId: 214)
            
            XCTAssert(tags1.isEmpty)
            XCTAssertFalse(tags2.isEmpty)
            XCTAssertFalse(tags3.isEmpty)
            XCTAssertFalse(tags4.isEmpty)
            
            try filtersStorage.deleteTagsForFilters(withIds: [233,249,214])
            
            tags2 = try filtersStorage.getTagsForFilter(withId: 233)
            tags3 = try filtersStorage.getTagsForFilter(withId: 249)
            tags4 = try filtersStorage.getTagsForFilter(withId: 214)
            
            XCTAssert(tags2.isEmpty)
            XCTAssert(tags3.isEmpty)
            XCTAssert(tags4.isEmpty)

        } catch {
            XCTFail("\(error)")
        }
    }
}
