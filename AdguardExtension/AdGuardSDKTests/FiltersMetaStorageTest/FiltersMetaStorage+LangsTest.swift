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
        guard let filtersStorage = filtersStorage else { return XCTFail() }
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
        guard let filtersStorage = filtersStorage else { return XCTFail() }
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
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            var lang = try filtersStorage.getLangsForFilter(withId: 123456789)
            XCTAssertTrue(lang.isEmpty)
            
            lang = try filtersStorage.getLangsForFilter(withId: -123456789)
            XCTAssertTrue(lang.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInsertLangsWithNonExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let langs = try filtersStorage.getLangsForFilter(withId: -1)
            XCTAssert(langs.isEmpty)
            try filtersStorage.insertLangsIntoFilter(langs: ["foo", "bar"], forFilterId: -1)
            let insertedLangs = try filtersStorage.getLangsForFilter(withId: -1)
            XCTAssertFalse(insertedLangs.isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInsertLangsWithExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let langs = try filtersStorage.getLangsForFilter(withId: 1)
            try filtersStorage.insertLangsIntoFilter(langs: ["foo", "bar"], forFilterId: 1)
            let insertedLangs = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssert(insertedLangs.count > langs.count)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateLangsWithSucces() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let langs = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(langs.isEmpty)
            for (index, value) in langs.enumerated() {
                try filtersStorage.updateFiltersLang(oldLang: value, newLang: "foo\(index)", forFilterId: 1)
            }
            let updatedLangs = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(updatedLangs.isEmpty)
            XCTAssertNotEqual(langs, updatedLangs)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateLangsWithNonExistingRows() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let lang = try filtersStorage.getLangsForFilter(withId: 1).first else { return XCTFail() }
            XCTAssertNoThrow(try filtersStorage.updateFiltersLang(oldLang: lang, newLang: "bar", forFilterId: -1))
            XCTAssertNoThrow(try filtersStorage.updateFiltersLang(oldLang: "foo", newLang: "bar", forFilterId: 1))
            XCTAssertNoThrow(try filtersStorage.updateFiltersLang(oldLang: "foo", newLang: "bar", forFilterId: -1))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteAllLangsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let langs = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(langs.isEmpty)
            try filtersStorage.deleteAllLangsForFilter(withId: 1)
            let removedLangs = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssert(removedLangs.isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteAllLangsFromNonExistingFilterId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let nonExistingLangsFiletr = try filtersStorage.getLangsForFilter(withId: -123)
            XCTAssert(nonExistingLangsFiletr.isEmpty)
            XCTAssertNoThrow(try filtersStorage.deleteAllLangsForFilter(withId: -123))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteLangsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            try filtersStorage.insertLangsIntoFilter(langs: ["foo#1", "foo#2"], forFilterId: 101)
            let inserted = try filtersStorage.getLangsForFilter(withId: 101)
            XCTAssertFalse(inserted.isEmpty)
            try filtersStorage.deleteLangsForFilter(withId: 101, langs: ["foo#1", "foo#2"])
            let removed = try filtersStorage.getLangsForFilter(withId: 101)
            XCTAssert(removed.isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteLangsWithNonExistingFitlerIdOrlangs() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let inserted = try filtersStorage.getLangsForFilter(withId: 101)
            XCTAssert(inserted.isEmpty)
            try filtersStorage.deleteLangsForFilter(withId: 101, langs: ["foo#1", "foo#2"])
            var removed = try filtersStorage.getLangsForFilter(withId: 101)
            XCTAssert(removed.isEmpty)
            
            
            var langs = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(langs.isEmpty)
            try filtersStorage.deleteLangsForFilter(withId: 1, langs: ["foo#1", "foo#2"])
            removed = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertEqual(langs, removed)
            
            langs = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(langs.isEmpty)
            try filtersStorage.deleteLangsForFilter(withId: 1, langs: [])
            removed = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertEqual(langs, removed)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
