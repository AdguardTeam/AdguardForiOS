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
        let filtersStorage = filtersStorage!
        do {
            var localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertFalse(localization!.name!.isEmpty)
            XCTAssertNotNil(localization?.description)
            XCTAssertFalse(localization!.description!.isEmpty)
            
            localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertFalse(localization!.name!.isEmpty)
            XCTAssertNotNil(localization?.description)
            XCTAssertFalse(localization!.description!.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLocalizationForFilterWithNonExistingIdOrLanguage() {
        let filtersStorage = filtersStorage!
        do {
            let localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "foo")
            XCTAssertNil(localization)
            
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "en"))
            XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "foo"))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateLocalizatonForFilter() {
        let filtersStorage = filtersStorage!
        do {
            var localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotEqual(localization?.name, "foo")
            XCTAssertNotEqual(localization?.description, "bar")
            
            try filtersStorage.updateLocalizationForFilter(withId: 1, forLanguage: "en", localization: .init(name: "foo", description: "bar"))
            
            localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertEqual(localization?.name, "foo")
            XCTAssertEqual(localization?.description, "bar")
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteAllLocalizationForFilters() {
        let filtersStorage = filtersStorage!
        do {
            var lang1 = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
            var lang2 = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
            var lang3 = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "ru")
            XCTAssertNotNil(lang1)
            XCTAssertNotNil(lang2)
            XCTAssertNotNil(lang3)
            
            lang1 = try filtersStorage.getLocalizationForFilter(withId: 2, forLanguage: "en")
            lang2 = try filtersStorage.getLocalizationForFilter(withId: 2, forLanguage: "fr")
            lang3 = try filtersStorage.getLocalizationForFilter(withId: 2, forLanguage: "ru")
            XCTAssertNotNil(lang1)
            XCTAssertNotNil(lang2)
            XCTAssertNotNil(lang3)
            
            try filtersStorage.deleteAllLocalizationForFilters(withIds: [1,2])
            
            lang1 = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
            lang2 = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
            lang3 = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "ru")
            XCTAssertNil(lang1)
            XCTAssertNil(lang2)
            XCTAssertNil(lang3)
            
            lang1 = try filtersStorage.getLocalizationForFilter(withId: 2, forLanguage: "en")
            lang2 = try filtersStorage.getLocalizationForFilter(withId: 2, forLanguage: "fr")
            lang3 = try filtersStorage.getLocalizationForFilter(withId: 2, forLanguage: "ru")
            XCTAssertNil(lang1)
            XCTAssertNil(lang2)
            XCTAssertNil(lang3)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
