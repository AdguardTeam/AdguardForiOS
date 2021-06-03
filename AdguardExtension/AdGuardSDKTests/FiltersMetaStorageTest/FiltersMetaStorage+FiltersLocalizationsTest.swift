import XCTest

class FiltersMetaStorage_FiltersLocalizationsTest: XCTestCase {

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

    func testGetLocalizationForFilterWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            var localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertFalse(localization!.name.isEmpty)
            XCTAssertNotNil(localization?.description)
            XCTAssertFalse(localization!.description.isEmpty)
            
            localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertFalse(localization!.name.isEmpty)
            XCTAssertNotNil(localization?.description)
            XCTAssertFalse(localization!.description.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLocalizationForFilterWithNonExistingIdOrLanguage() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "foo")
            XCTAssertNil(localization)
            
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "en"))
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "foo"))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInsertLocalizatonForFilterWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let filter = try filtersStorage.getAllFilters().first else { return XCTFail() }
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "foo"))
            try filtersStorage.insertOrReplaceLocalizatonForFilter(withId: filter.filterId, forLanguage: "foo", filterLocalization: .init(name: "foo", description: "bar"))
            var localization = try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "foo")
            XCTAssertNotNil(localization)
            XCTAssert(localization?.name == "foo")
            XCTAssert(localization?.description == "bar")
            
            
            XCTAssertNotNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en"))
            try filtersStorage.insertOrReplaceLocalizatonForFilter(withId: filter.filterId, forLanguage: "en", filterLocalization: .init(name: "foo", description: "bar"))
            localization = try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssert(localization?.name == "foo")
            XCTAssert(localization?.description == "bar")
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateLocalizationForFilterWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let filter = try filtersStorage.getAllFilters().first else { return XCTFail() }
            var localization = try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en")
            XCTAssertNotEqual(localization?.name, "foo")
            XCTAssertNotEqual(localization?.description, "bar")
            try filtersStorage.updateLocalizationForFilter(with: filter.filterId, forLanguage: "en", filterLocalization: .init(name: "foo", description: "bar"))
            localization = try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en")
            XCTAssert(localization?.name == "foo")
            XCTAssert(localization?.description == "bar")
            
            
            localization = try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "foo")
            XCTAssertNil(localization)
            try filtersStorage.updateLocalizationForFilter(with: filter.filterId, forLanguage: "foo", filterLocalization: .init(name: "foo", description: "bar"))
            localization = try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "foo")
            XCTAssertNil(localization)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteAllLocalizationForFilter() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let filter = try filtersStorage.getAllFilters().first else { return XCTFail() }
            XCTAssertNotNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en"))
            XCTAssertNotNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "fr"))
            try filtersStorage.deleteAllLocalizationForFilter(with: filter.filterId)
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en"))
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "fr"))
            XCTAssertNoThrow( try filtersStorage.deleteAllLocalizationForFilter(with: -123))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteLocalizationForFilter() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let filter = try filtersStorage.getAllFilters().first else { return XCTFail() }
            XCTAssertNotNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en"))
            XCTAssertNotNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "fr"))
            try filtersStorage.deleteLocalizationForFilter(with: filter.filterId, forLanguage: "en")
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en"))
            XCTAssertNotNil(try filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "fr"))
            XCTAssertNoThrow( try filtersStorage.deleteLocalizationForFilter(with: -123, forLanguage: "en"))
        } catch {
            XCTFail("\(error)")
        }
    }
}
