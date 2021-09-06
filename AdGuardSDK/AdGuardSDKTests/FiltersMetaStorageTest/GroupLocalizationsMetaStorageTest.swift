import XCTest

class GroupLocalizationsMetaStorageTest: XCTestCase {

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
