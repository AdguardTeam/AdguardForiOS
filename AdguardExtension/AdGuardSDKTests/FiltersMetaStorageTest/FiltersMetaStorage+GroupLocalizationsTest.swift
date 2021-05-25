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
        guard let filtersStorage = filtersStorage else { return }
        do {
            let localization = try filtersStorage.getLocalizationForGroup(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertFalse(localization!.name.isEmpty)
    
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLocalizationForGroupWithNonExistingIdOrLanguage() {
        guard let filtersStorage = filtersStorage else { return }
        do {
            var localization = try filtersStorage.getLocalizationForGroup(withId: 1, forLanguage: "foo")
            XCTAssertNil(localization)
            
            localization = try filtersStorage.getLocalizationForGroup(withId: -1, forLanguage: "en")
            XCTAssertNil(localization)
            
            localization = try filtersStorage.getLocalizationForGroup(withId: -1, forLanguage: "foo")
            XCTAssertNil(localization)
    
        } catch {
            XCTFail("\(error)")
        }
    }
}
