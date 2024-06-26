import XCTest

class TagsMetaStorageTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default

    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!

    let testTags = [ExtendedFiltersMeta.Tag(tagId: 100, tagType: .lang, tagName: "foo#101"),
                    ExtendedFiltersMeta.Tag(tagId: 101, tagType: .obsolete, tagName: "foo#102"),
                    ExtendedFiltersMeta.Tag(tagId: 102, tagType: .platform, tagName: "foo#103")]

    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        TestsFileManager.putDbFileToDirectory(Bundle(for: type(of: self)))
        productionDbManager = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
    }

    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }

    func testGetAllTagsWithSuccess() {
        let tags = try! metaStorage.getAllTags()
        XCTAssertFalse(tags.isEmpty)
        tags.forEach {
            XCTAssertNotNil($0.tagId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.type)
        }
    }

    func testGetTagsForFilterWithSuccess() {
        let tags = try! metaStorage.getTagsForFilter(withId: 1)
        XCTAssertFalse(tags.isEmpty)
        tags.forEach {
            XCTAssertNotNil($0.tagId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.type)
        }
    }

    func testGetTagsForFilterWithNonExistingFilterId() {
        var tags = try! metaStorage.getTagsForFilter(withId: 123456789)
        XCTAssertTrue(tags.isEmpty)

        tags = try! metaStorage.getTagsForFilter(withId: -123456789)
        XCTAssertTrue(tags.isEmpty)
    }

    func testUpdateAll() {
        var tags = try! metaStorage.getTagsForFilter(withId: 10000)
        XCTAssert(tags.isEmpty)

        try! metaStorage.updateAll(tags: testTags, forFilterWithId: 10000)
        tags = try! metaStorage.getTagsForFilter(withId: 10000)
        XCTAssertFalse(tags.isEmpty)
        testTags.forEach { testTag in
            XCTAssert(tags.contains {
                testTag.tagId == $0.tagId &&
                    testTag.tagName == $0.name &&
                    testTag.tagType.id == $0.type
            })
        }

        try! metaStorage.updateAll(tags: [.init(tagId: 4, tagType: .obsolete, tagName: "bar")], forFilterWithId: 10000)
        tags = try! metaStorage.getTagsForFilter(withId: 10000)
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
    }

    func testUpdateAllWithEmptyValue() {
        XCTAssertFalse(try! metaStorage.getTagsForFilter(withId: 1).isEmpty)
        try! metaStorage.updateAll(tags: [], forFilterWithId: 1)
        XCTAssert(try! metaStorage.getTagsForFilter(withId: 1).isEmpty)
    }

    func testDeleteTagsForFilters() {
        var tags1 = try! metaStorage.getTagsForFilter(withId: 1)
        var tags2 = try! metaStorage.getTagsForFilter(withId: 233)
        var tags3 = try! metaStorage.getTagsForFilter(withId: 249)
        var tags4 = try! metaStorage.getTagsForFilter(withId: 214)

        XCTAssertFalse(tags1.isEmpty)
        XCTAssertFalse(tags2.isEmpty)
        XCTAssertFalse(tags3.isEmpty)
        XCTAssertFalse(tags4.isEmpty)

        try! metaStorage.deleteTagsForFilters(withIds: [1])

        tags1 = try! metaStorage.getTagsForFilter(withId: 1)
        tags2 = try! metaStorage.getTagsForFilter(withId: 233)
        tags3 = try! metaStorage.getTagsForFilter(withId: 249)
        tags4 = try! metaStorage.getTagsForFilter(withId: 214)

        XCTAssert(tags1.isEmpty)
        XCTAssertFalse(tags2.isEmpty)
        XCTAssertFalse(tags3.isEmpty)
        XCTAssertFalse(tags4.isEmpty)

        try! metaStorage.deleteTagsForFilters(withIds: [233,249,214])

        tags2 = try! metaStorage.getTagsForFilter(withId: 233)
        tags3 = try! metaStorage.getTagsForFilter(withId: 249)
        tags4 = try! metaStorage.getTagsForFilter(withId: 214)

        XCTAssert(tags2.isEmpty)
        XCTAssert(tags3.isEmpty)
        XCTAssert(tags4.isEmpty)
    }
}
