import XCTest

class LangsMetaStorageTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default

    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    var setOfTestableLangs: Set<String> = Set()

    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        TestsFileManager.putDbFileToDirectory(Bundle(for: type(of: self)))

        productionDbManager = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)

        let lang = try! metaStorage!.getLangsForFilter(withId: 1)
        lang.forEach { setOfTestableLangs.insert($0) }
    }

    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }

    func testGetLangsForFilterWithSuccess() {
        let lang = try! metaStorage.getLangsForFilter(withId: 1)
        XCTAssertFalse(lang.isEmpty)
        lang.forEach {
            XCTAssertFalse($0.isEmpty)
        }
    }

    func testGetLangsForFilterWithDifferentLocalization() {
        let lang = try! metaStorage.getLangsForFilter(withId: 8)
        XCTAssertFalse(lang.isEmpty)
        lang.forEach {
            XCTAssertFalse($0.isEmpty)
            XCTAssertFalse(setOfTestableLangs.contains($0))
        }
    }

    func testGetLangsForFilterWithNonExistingId() {
        var lang = try! metaStorage.getLangsForFilter(withId: 123456789)
        XCTAssertTrue(lang.isEmpty)

        lang = try! metaStorage.getLangsForFilter(withId: -123456789)
        XCTAssertTrue(lang.isEmpty)
    }

    func testUpdateAll() {
        let testLangs = ["en", "fr", "ru"]
        var lang = try! metaStorage.getLangsForFilter(withId: 123)
        XCTAssert(lang.isEmpty)

        try! metaStorage.updateAll(langs: testLangs, forFilterWithId: 123)
        lang = try! metaStorage.getLangsForFilter(withId: 123)
        XCTAssertFalse(lang.isEmpty)
        testLangs.forEach { XCTAssert(lang.contains($0)) }

        try! metaStorage.updateAll(langs: ["foo"], forFilterWithId: 123)
        lang = try! metaStorage.getLangsForFilter(withId: 123)
        XCTAssertFalse(lang.isEmpty)
        testLangs.forEach { XCTAssertFalse(lang.contains($0)) }
        XCTAssertEqual(lang.count, 1)
        XCTAssert(lang.contains("foo"))
    }

    func testUpdateAllWithEmptyValue() {
        XCTAssertFalse(try! metaStorage.getLangsForFilter(withId: 1).isEmpty)
        try! metaStorage.updateAll(langs: [], forFilterWithId: 1)
        XCTAssert(try! metaStorage.getLangsForFilter(withId: 1).isEmpty)
    }

    func testDeleteLangsForFilterId() {
        var lang1 = try! metaStorage.getLangsForFilter(withId: 1)
        var lang2 = try! metaStorage.getLangsForFilter(withId: 233)
        var lang3 = try! metaStorage.getLangsForFilter(withId: 249)
        var lang4 = try! metaStorage.getLangsForFilter(withId: 214)

        XCTAssertFalse(lang1.isEmpty)
        XCTAssertFalse(lang2.isEmpty)
        XCTAssertFalse(lang3.isEmpty)
        XCTAssertFalse(lang4.isEmpty)

        try! metaStorage.deleteLangsForFilters(withIds: [1])

        lang1 = try! metaStorage.getLangsForFilter(withId: 1)
        lang2 = try! metaStorage.getLangsForFilter(withId: 233)
        lang3 = try! metaStorage.getLangsForFilter(withId: 249)
        lang4 = try! metaStorage.getLangsForFilter(withId: 214)

        XCTAssert(lang1.isEmpty)
        XCTAssertFalse(lang2.isEmpty)
        XCTAssertFalse(lang3.isEmpty)
        XCTAssertFalse(lang4.isEmpty)

        try! metaStorage.deleteLangsForFilters(withIds: [233,249,214])

        lang2 = try! metaStorage.getLangsForFilter(withId: 233)
        lang3 = try! metaStorage.getLangsForFilter(withId: 249)
        lang4 = try! metaStorage.getLangsForFilter(withId: 214)

        XCTAssert(lang2.isEmpty)
        XCTAssert(lang3.isEmpty)
        XCTAssert(lang4.isEmpty)
    }
}
