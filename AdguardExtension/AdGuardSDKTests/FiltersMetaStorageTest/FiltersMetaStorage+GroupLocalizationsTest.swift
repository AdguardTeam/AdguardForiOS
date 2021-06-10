import XCTest

class FiltersMetaStorage_GroupLocalizationsTest: XCTestCase {

    let rootDirectory = MetaStorageTestProcessor.rootDirectory
    let workingUrl = MetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
    }
    
    override class func setUp() {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
    }
    
    override class func tearDown() {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func tearDown() {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
    }
    
    func testGetLocalizationForGroupWithSuccess() {
        let localization = metaStorage.getLocalizationForGroup(withId: 1, forLanguage: "en")
        XCTAssertNotNil(localization)
        XCTAssertNotNil(localization?.name)
        XCTAssertFalse(localization!.name!.isEmpty)
    }
    
    func testGetLocalizationForGroupWithNonExistingIdOrLanguage() {
        var localization = metaStorage.getLocalizationForGroup(withId: 1, forLanguage: "foo")
        XCTAssertNil(localization)
        
        localization = metaStorage.getLocalizationForGroup(withId: -1, forLanguage: "en")
        XCTAssertNil(localization)
        
        localization = metaStorage.getLocalizationForGroup(withId: -1, forLanguage: "foo")
        XCTAssertNil(localization)
    }
    
    func testUpdateLocalizationForGroup() {
        do {
            var localization = metaStorage.getLocalizationForGroup(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertFalse(localization!.name!.isEmpty)

            try metaStorage.updateLocalizationForGroup(withId: 1, forLanguage: "en", localization: .init(name: "foo"))
            
            localization = metaStorage.getLocalizationForGroup(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertNotNil(localization?.name)
            XCTAssertEqual(localization!.name!, "foo")
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
