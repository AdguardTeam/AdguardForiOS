import XCTest

class LangsMetaStorageTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    var setOfTestableLangs: Set<String> = Set()
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
        
        let lang = try metaStorage!.getLangsForFilter(withId: 1)
        lang.forEach { setOfTestableLangs.insert($0) }
    }
    
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
    
    func testGetLangsForFilterWithSuccess() {
        do {
            let lang = try metaStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(lang.isEmpty)
            lang.forEach {
                XCTAssertFalse($0.isEmpty)
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLangsForFilterWithDifferentLocalization() {
        do {
            let lang = try metaStorage.getLangsForFilter(withId: 8)
            XCTAssertFalse(lang.isEmpty)
            lang.forEach {
                XCTAssertFalse($0.isEmpty)
                XCTAssertFalse(setOfTestableLangs.contains($0))
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLangsForFilterWithNonExistingId() {
        do {
            var lang = try metaStorage.getLangsForFilter(withId: 123456789)
            XCTAssertTrue(lang.isEmpty)
            
            lang = try metaStorage.getLangsForFilter(withId: -123456789)
            XCTAssertTrue(lang.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAll() {
        let testLangs = ["en", "fr", "ru"]
        do {
            var lang = try metaStorage.getLangsForFilter(withId: 123)
            XCTAssert(lang.isEmpty)
            
            try metaStorage.updateAll(langs: testLangs, forFilterWithId: 123)
            lang = try metaStorage.getLangsForFilter(withId: 123)
            XCTAssertFalse(lang.isEmpty)
            testLangs.forEach { XCTAssert(lang.contains($0)) }
            
            try metaStorage.updateAll(langs: ["foo"], forFilterWithId: 123)
            lang = try metaStorage.getLangsForFilter(withId: 123)
            XCTAssertFalse(lang.isEmpty)
            testLangs.forEach { XCTAssertFalse(lang.contains($0)) }
            XCTAssertEqual(lang.count, 1)
            XCTAssert(lang.contains("foo"))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAllWithEmptyValue() {
        do {
            XCTAssertFalse(try metaStorage.getLangsForFilter(withId: 1).isEmpty)
            try metaStorage.updateAll(langs: [], forFilterWithId: 1)
            XCTAssert(try metaStorage.getLangsForFilter(withId: 1).isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteLangsForFilterId() {
        do {
            var lang1 = try metaStorage.getLangsForFilter(withId: 1)
            var lang2 = try metaStorage.getLangsForFilter(withId: 233)
            var lang3 = try metaStorage.getLangsForFilter(withId: 249)
            var lang4 = try metaStorage.getLangsForFilter(withId: 214)

            XCTAssertFalse(lang1.isEmpty)
            XCTAssertFalse(lang2.isEmpty)
            XCTAssertFalse(lang3.isEmpty)
            XCTAssertFalse(lang4.isEmpty)
            
            try metaStorage.deleteLangsForFilters(withIds: [1])
            
            lang1 = try metaStorage.getLangsForFilter(withId: 1)
            lang2 = try metaStorage.getLangsForFilter(withId: 233)
            lang3 = try metaStorage.getLangsForFilter(withId: 249)
            lang4 = try metaStorage.getLangsForFilter(withId: 214)
            
            XCTAssert(lang1.isEmpty)
            XCTAssertFalse(lang2.isEmpty)
            XCTAssertFalse(lang3.isEmpty)
            XCTAssertFalse(lang4.isEmpty)
            
            try metaStorage.deleteLangsForFilters(withIds: [233,249,214])
            
            lang2 = try metaStorage.getLangsForFilter(withId: 233)
            lang3 = try metaStorage.getLangsForFilter(withId: 249)
            lang4 = try metaStorage.getLangsForFilter(withId: 214)
            
            XCTAssert(lang2.isEmpty)
            XCTAssert(lang3.isEmpty)
            XCTAssert(lang4.isEmpty)

        } catch {
            XCTFail("\(error)")
        }
    }
}
