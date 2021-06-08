import XCTest

class FiltersMetaStorage_GroupLocalizationsTest: XCTestCase {

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
    
    func testGetLocalizationForGroupWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        let localization = filtersStorage.getLocalizationForGroup(withId: 1, forLanguage: "en")
        XCTAssertNotNil(localization)
        XCTAssertNotNil(localization?.name)
        XCTAssertFalse(localization!.name!.isEmpty)
    }
    
    func testGetLocalizationForGroupWithNonExistingIdOrLanguage() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        var localization = filtersStorage.getLocalizationForGroup(withId: 1, forLanguage: "foo")
        XCTAssertNil(localization)
        
        localization = filtersStorage.getLocalizationForGroup(withId: -1, forLanguage: "en")
        XCTAssertNil(localization)
        
        localization = filtersStorage.getLocalizationForGroup(withId: -1, forLanguage: "foo")
        XCTAssertNil(localization)
    }
    
    func testUpdateLocalizationForGroup() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            var localization = filtersStorage.getLocalizationForGroup(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertFalse(localization!.name!.isEmpty)

            try filtersStorage.updateLocalizationForGroup(withId: 1, forLanguage: "en", localization: .init(name: "foo"))
            
            localization = filtersStorage.getLocalizationForGroup(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertEqual(localization!.name!, "foo")
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
