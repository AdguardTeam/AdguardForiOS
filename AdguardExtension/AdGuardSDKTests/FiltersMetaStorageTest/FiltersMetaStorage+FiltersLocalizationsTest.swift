import XCTest

class FiltersMetaStorage_FiltersLocalizationsTest: XCTestCase {

    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var filtersStorage: FiltersMetaStorage!
    
    override func setUpWithError() throws {
        let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
    }
    
    override class func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }

    func testGetLocalizationForFilterWithSuccess() {
        var localization = try! filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
        XCTAssertNotNil(localization)
        XCTAssertNotNil(localization?.name)
        XCTAssertFalse(localization!.name!.isEmpty)
        XCTAssertNotNil(localization?.description)
        XCTAssertFalse(localization!.description!.isEmpty)
        
        localization = try! filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
        XCTAssertNotNil(localization)
        XCTAssertNotNil(localization?.name)
        XCTAssertFalse(localization!.name!.isEmpty)
        XCTAssertNotNil(localization?.description)
        XCTAssertFalse(localization!.description!.isEmpty)
    }
    
    func testGetLocalizationForFilterWithNonExistingIdOrLanguage() {
        let localization = try! filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "foo")
        XCTAssertNil(localization)
        
        XCTAssertNil(try! filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "en"))
        XCTAssertNil(try! filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "foo"))
    }
    
    func testUpdateLocalizationForFilterWithSuccess() {
        let filter = try! filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").first!
        var localization = try! filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en")
        XCTAssertNotEqual(localization?.name, "foo")
        XCTAssertNotEqual(localization?.description, "bar")
        
        try! filtersStorage.updateLocalizationForFilter(withId: filter.filterId, forLanguage: "en", localization: .init(name: "foo", description: "bar"))
        localization = try! filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "en")
        XCTAssert(localization?.name == "foo")
        XCTAssert(localization?.description == "bar")
    
        localization = try! filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "foo")
        XCTAssertNil(localization)
        
        try! filtersStorage.updateLocalizationForFilter(withId: filter.filterId, forLanguage: "foo", localization: .init(name: "foo", description: "bar"))
        localization = try! filtersStorage.getLocalizationForFilter(withId: filter.filterId, forLanguage: "foo")
        XCTAssertNil(localization)
    }
}
