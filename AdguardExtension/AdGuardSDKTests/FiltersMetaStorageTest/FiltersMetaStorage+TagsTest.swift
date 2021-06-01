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
    
    func testInsertTagsWithNonExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: -123)
            XCTAssert(tags.isEmpty)
            try filtersStorage.insertTagsForFilter(withId: -123, tags: testTags)
            let insertedTags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssert(insertedTags.count > tags.count)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInsertTagsWithExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertFalse(tags.isEmpty)
            try filtersStorage.insertTagsForFilter(withId: 1, tags: testTags)
            let insertedTags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertEqual(insertedTags.count, tags.count + 3)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateTagsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: 1)
            let tagsName = tags.compactMap { $0.tagName }
            XCTAssertFalse(tags.isEmpty)
            for (index, tag) in tags.enumerated() {
                let newTag = ExtendedFiltersMeta.Tag(tagId: 100 + index, tagType: .lang, tagName: "foo#\(index)")
                try filtersStorage.updateTagsForFilter(withId: 1, oldTag: tag, newTag: newTag)
            }
            
            let updatedTagsNames = try filtersStorage.getTagsForFilter(withId: 1).compactMap { $0.tagName }
            XCTAssertFalse(updatedTagsNames.isEmpty)
            XCTAssertNotEqual(tagsName, updatedTagsNames)

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateTagsWithNonExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: -123)
            XCTAssert(tags.isEmpty)
            for (index, tag) in tags.enumerated() {
                let newTag = ExtendedFiltersMeta.Tag(tagId: 100 + index, tagType: .lang, tagName: "foo#\(index)")
                try filtersStorage.updateTagsForFilter(withId: -123, oldTag: tag, newTag: newTag)
            }
            
            let updatedTagsNames = try filtersStorage.getTagsForFilter(withId: -123).compactMap { $0.tagName }
            XCTAssert(updatedTagsNames.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteAllTagsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertFalse(tags.isEmpty)
            try filtersStorage.deleteAllTagsForFilter(withId: 1)
            XCTAssert(try filtersStorage.getTagsForFilter(withId: 1).isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteAllTagsWithNonExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: -123)
            XCTAssert(tags.isEmpty)
            try filtersStorage.deleteAllTagsForFilter(withId: -123)
            XCTAssert(try filtersStorage.getTagsForFilter(withId: -123).isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteTagsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertFalse(tags.isEmpty)
            try filtersStorage.deleteTagsForFilter(withId: 1, tags: tags)
            XCTAssert(try filtersStorage.getTagsForFilter(withId: 1).isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteTagsWithNonExistingFilterIdOrTags() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            var tags = try filtersStorage.getTagsForFilter(withId: -123)
            XCTAssert(tags.isEmpty)
            try filtersStorage.deleteTagsForFilter(withId: -123, tags: testTags)
            
            tags = try filtersStorage.getTagsForFilter(withId: -123)
            XCTAssert(tags.isEmpty)
            
            tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertFalse(tags.isEmpty)
            try filtersStorage.deleteTagsForFilter(withId: 1, tags: testTags)
            var removed = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssert(tags.compactMap { $0.tagName } == removed.compactMap { $0.tagName} )
            
            
            tags = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssertFalse(tags.isEmpty)
            try filtersStorage.deleteTagsForFilter(withId: 1, tags: [])
            removed = try filtersStorage.getTagsForFilter(withId: 1)
            XCTAssert(tags.compactMap { $0.tagName } == removed.compactMap { $0.tagName} )
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
