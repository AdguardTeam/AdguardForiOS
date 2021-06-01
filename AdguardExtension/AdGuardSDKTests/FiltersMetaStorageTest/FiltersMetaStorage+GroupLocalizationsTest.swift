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
        guard let filtersStorage = filtersStorage else { return XCTFail() }
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
    
    func testInsertLocalizationForGroupWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let group = try filtersStorage.getAllGroups().first else { return XCTFail() }
            XCTAssertNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "foo"))
            try filtersStorage.insertLocalizationForGroup(groupId: group.groupId, lang: "foo", name: "bar")
            var localization = try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "foo")
            XCTAssertNotNil(localization)
            XCTAssertEqual(localization?.name, "bar")
            
            XCTAssertNotNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en"))
            try filtersStorage.insertLocalizationForGroup(groupId: group.groupId, lang: "en", name: "fooEn")
            localization = try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertEqual(localization?.name, "fooEn")
               
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateLocalizationForGroup() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let group = try filtersStorage.getAllGroups().first else { return XCTFail() }
            var localization = try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssert(localization?.name == group.groupName)
            try filtersStorage.updateLocalizationForGroup(groupId: group.groupId, lang: "en", name: "foo")
            localization = try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssert(localization?.name == "foo")

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteAllLocalizationGroups() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let group = try filtersStorage.getAllGroups().first else { return XCTFail() }
            XCTAssertNotNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en"))
            XCTAssertNotNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "fr"))
            try filtersStorage.deleteAllLocalizationForGroup(groupId: group.groupId)
            XCTAssertNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en"))
            XCTAssertNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "fr"))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteLocalizationForGroups() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let group = try filtersStorage.getAllGroups().first else { return XCTFail() }
            XCTAssertNotNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en"))
            XCTAssertNotNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "fr"))
            try filtersStorage.deleteLocalizationForGroup(groupId: group.groupId, lang: "en")
            XCTAssertNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "en"))
            XCTAssertNotNil(try filtersStorage.getLocalizationForGroup(withId: group.groupId, forLanguage: "fr"))
        } catch {
            XCTFail("\(error)")
        }
    }
}
