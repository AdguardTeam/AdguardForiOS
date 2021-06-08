import XCTest

class FiltersMetaStorage_LangsTest: XCTestCase {

    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager?
    var filtersStorage: FiltersMetaStorage?
    var setOfTestableLangs: Set<String> = Set()
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager!)
        
        let lang = try filtersStorage!.getLangsForFilter(withId: 1)
        lang.forEach { setOfTestableLangs.insert($0) }
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
    
    func testGetLangsForFilterWithSuccess() {
        let filtersStorage = filtersStorage!
        do {
            let lang = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(lang.isEmpty)
            lang.forEach {
                XCTAssertFalse($0.isEmpty)
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLangsForFilterWithDifferentLocalization() {
        let filtersStorage = filtersStorage!
        do {
            let lang = try filtersStorage.getLangsForFilter(withId: 8)
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
        let filtersStorage = filtersStorage!
        do {
            var lang = try filtersStorage.getLangsForFilter(withId: 123456789)
            XCTAssertTrue(lang.isEmpty)
            
            lang = try filtersStorage.getLangsForFilter(withId: -123456789)
            XCTAssertTrue(lang.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAll() {
        let filtersStorage = filtersStorage!
        let testLangs = ["en", "fr", "ru"]
        do {
            var lang = try filtersStorage.getLangsForFilter(withId: 123)
            XCTAssert(lang.isEmpty)
            
            try filtersStorage.updateAll(langs: testLangs, forFilterWithId: 123)
            lang = try filtersStorage.getLangsForFilter(withId: 123)
            XCTAssertFalse(lang.isEmpty)
            testLangs.forEach { XCTAssert(lang.contains($0)) }
            
            try filtersStorage.updateAll(langs: ["foo"], forFilterWithId: 123)
            lang = try filtersStorage.getLangsForFilter(withId: 123)
            XCTAssertFalse(lang.isEmpty)
            testLangs.forEach { XCTAssertFalse(lang.contains($0)) }
            XCTAssertEqual(lang.count, 1)
            XCTAssert(lang.contains("foo"))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAllWithEmptyValue() {
        let filtersStorage = filtersStorage!
        do {
            XCTAssertFalse(try filtersStorage.getLangsForFilter(withId: 1).isEmpty)
            try filtersStorage.updateAll(langs: [], forFilterWithId: 1)
            XCTAssert(try filtersStorage.getLangsForFilter(withId: 1).isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteLangsForFilterId() {
        let filtersStorage = filtersStorage!
        do {
            var lang1 = try filtersStorage.getLangsForFilter(withId: 1)
            var lang2 = try filtersStorage.getLangsForFilter(withId: 233)
            var lang3 = try filtersStorage.getLangsForFilter(withId: 249)
            var lang4 = try filtersStorage.getLangsForFilter(withId: 214)

            XCTAssertFalse(lang1.isEmpty)
            XCTAssertFalse(lang2.isEmpty)
            XCTAssertFalse(lang3.isEmpty)
            XCTAssertFalse(lang4.isEmpty)
            
            try filtersStorage.deleteLangsForFilters(withIds: [1])
            
            lang1 = try filtersStorage.getLangsForFilter(withId: 1)
            lang2 = try filtersStorage.getLangsForFilter(withId: 233)
            lang3 = try filtersStorage.getLangsForFilter(withId: 249)
            lang4 = try filtersStorage.getLangsForFilter(withId: 214)
            
            XCTAssert(lang1.isEmpty)
            XCTAssertFalse(lang2.isEmpty)
            XCTAssertFalse(lang3.isEmpty)
            XCTAssertFalse(lang4.isEmpty)
            
            try filtersStorage.deleteLangsForFilters(withIds: [233,249,214])
            
            lang2 = try filtersStorage.getLangsForFilter(withId: 233)
            lang3 = try filtersStorage.getLangsForFilter(withId: 249)
            lang4 = try filtersStorage.getLangsForFilter(withId: 214)
            
            XCTAssert(lang2.isEmpty)
            XCTAssert(lang3.isEmpty)
            XCTAssert(lang4.isEmpty)

        } catch {
            XCTFail("\(error)")
        }
    }
}
