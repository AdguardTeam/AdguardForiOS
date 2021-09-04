import XCTest

class FiltersLocalizationsMetaStorageTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    
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

    func testGetLocalizationForFilterWithSuccess() {
        var localization = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
        XCTAssertNotNil(localization)
        XCTAssertNotNil(localization?.name)
        XCTAssertFalse(localization!.name!.isEmpty)
        XCTAssertNotNil(localization?.description)
        XCTAssertFalse(localization!.description!.isEmpty)
        
        localization = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
        XCTAssertNotNil(localization)
        XCTAssertNotNil(localization?.name)
        XCTAssertFalse(localization!.name!.isEmpty)
        XCTAssertNotNil(localization?.description)
        XCTAssertFalse(localization!.description!.isEmpty)
    }
    
    func testGetLocalizationForFilterWithNonExistingIdOrLanguage() {
        let localization = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "foo")
        XCTAssertNil(localization)
        
        XCTAssertNil(try! metaStorage.getLocalizationForFilter(withId: -1, forLanguage: "en"))
        XCTAssertNil(try! metaStorage.getLocalizationForFilter(withId: -1, forLanguage: "foo"))
    }
    
    func testUpdateLocalizatonForFilter() {
        var localization = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
        XCTAssertNotNil(localization)
        XCTAssertNotEqual(localization?.name, "foo")
        XCTAssertNotEqual(localization?.description, "bar")
        
        try! metaStorage.updateLocalizationForFilter(withId: 1, forLanguage: "en", localization: .init(name: "foo", description: "bar"))
        
        localization = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
        XCTAssertNotNil(localization)
        XCTAssertEqual(localization?.name, "foo")
        XCTAssertEqual(localization?.description, "bar")
    }
    
    func testDeleteAllLocalizationForFilters() {
        var lang1 = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
        var lang2 = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
        var lang3 = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "ru")
        XCTAssertNotNil(lang1)
        XCTAssertNotNil(lang2)
        XCTAssertNotNil(lang3)
        
        lang1 = try! metaStorage.getLocalizationForFilter(withId: 2, forLanguage: "en")
        lang2 = try! metaStorage.getLocalizationForFilter(withId: 2, forLanguage: "fr")
        lang3 = try! metaStorage.getLocalizationForFilter(withId: 2, forLanguage: "ru")
        XCTAssertNotNil(lang1)
        XCTAssertNotNil(lang2)
        XCTAssertNotNil(lang3)
        
        try! metaStorage.deleteAllLocalizationForFilters(withIds: [1,2])
        
        lang1 = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
        lang2 = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
        lang3 = try! metaStorage.getLocalizationForFilter(withId: 1, forLanguage: "ru")
        XCTAssertNil(lang1)
        XCTAssertNil(lang2)
        XCTAssertNil(lang3)
        
        lang1 = try! metaStorage.getLocalizationForFilter(withId: 2, forLanguage: "en")
        lang2 = try! metaStorage.getLocalizationForFilter(withId: 2, forLanguage: "fr")
        lang3 = try! metaStorage.getLocalizationForFilter(withId: 2, forLanguage: "ru")
        XCTAssertNil(lang1)
        XCTAssertNil(lang2)
        XCTAssertNil(lang3)
    }
}
