import XCTest

class GroupsMetaStorageTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
    }
    
    override class func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    override class func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }

    func testGetAllLocalizedGroupsWithSuccess() {
        var groups = try! metaStorage.getAllLocalizedGroups(forLanguage: "en")
        XCTAssertEqual(groups.count, 8)
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
        
        groups = try! metaStorage.getAllLocalizedGroups(forLanguage: "fr")
        XCTAssertEqual(groups.count, 8)
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
    }

    func testGetAllLocalizedGroupsWithNonExistingLanguage() {
        let groups = try! metaStorage.getAllLocalizedGroups(forLanguage: "123")
        XCTAssertEqual(groups.count, 8)
        
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
    }
    
    func testGetAllLocalizedGroupsWithDefaultLocalization() {
        let enLocalization = try! metaStorage.getAllLocalizedGroups(forLanguage: "en")
        XCTAssertEqual(enLocalization.count, 8)
        var frLocalization = try! metaStorage.getAllLocalizedGroups(forLanguage: "fr")
        XCTAssertEqual(frLocalization.count, 8)
        
        enLocalization.forEach { enLocal in
            XCTAssert(frLocalization.contains {
                $0.name != enLocal.name
            })
        }
        
        //Delete localization for language FR to test default localization from filter_group table data fetch
        try! productionDbManager?.filtersDb.run("DELETE FROM filter_group_localizations WHERE (\"lang\" = \"fr\")")
        let count = try! productionDbManager?.filtersDb.scalar("SELECT count(*) FROM filter_group_localizations WHERE (\"lang\" = \"fr\")") as! Int64
        XCTAssertEqual(count, 0)
        
        frLocalization = try! metaStorage.getAllLocalizedGroups(forLanguage: "fr")
        enLocalization.forEach { enLocal in
            XCTAssert(frLocalization.contains {
                $0.name == enLocal.name
            })
        }
    }
    
    func testSetGroup() {
        let adsGroup = try! metaStorage.getAllLocalizedGroups(forLanguage: "en").first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        try! metaStorage.setGroup(withId: SafariGroup.GroupType.ads.id, enabled: !adsGroup.isEnabled)
        let updatedAdsGroup = try! metaStorage.getAllLocalizedGroups(forLanguage: "en").first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        XCTAssertNotEqual(adsGroup.isEnabled, updatedAdsGroup.isEnabled)
    }
    
    func testUpdateGroups() {
        var groups = try! metaStorage.getAllLocalizedGroups(forLanguage: "en")
        XCTAssertEqual(groups.count, 8)
        
        // Modify 2 groups
        let adsGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        let privacyGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.privacy.id })!
        let customGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.custom.id })!
        
        let newAdsGroup = ExtendedFiltersMeta.Group(groupId: adsGroup.groupId, groupName: adsGroup.name, displayNumber: 100)
        let newPrivacyGroup = ExtendedFiltersMeta.Group(groupId: privacyGroup.groupId, groupName: privacyGroup.name, displayNumber: 101)
        
        // Update with new groups
        try! metaStorage.update(groups: [newAdsGroup, newPrivacyGroup])

        groups = try! metaStorage.getAllLocalizedGroups(forLanguage: "en")
        XCTAssertEqual(groups.count, 8)
        
        let updatedAdsGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        let updatedPrivacyGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.privacy.id })!
        let customGroupAfterUpdate = groups.first(where: { $0.groupId == SafariGroup.GroupType.custom.id })!
        
        XCTAssertEqual(updatedAdsGroup.displayNumber, 100)
        XCTAssertEqual(updatedPrivacyGroup.displayNumber, 101)
        XCTAssertEqual(customGroup, customGroupAfterUpdate)
    }
    
    func testUpdateAllWithEmptyValue() {
        XCTAssertEqual(try! metaStorage.getAllLocalizedGroups(forLanguage: "en").count, 8)
        try! metaStorage.update(groups: [])
        // Nothing should change
        XCTAssertEqual(try! metaStorage.getAllLocalizedGroups(forLanguage: "en").count, 8)
    }
}
