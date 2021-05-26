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
}
