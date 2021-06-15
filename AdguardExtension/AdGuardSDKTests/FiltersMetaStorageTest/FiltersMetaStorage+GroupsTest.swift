import XCTest

class FiltersMetaStorage_GroupsTest: XCTestCase {

    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    var filtersStorage: FiltersMetaStorage!
    
    override func setUpWithError() throws {
        let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
    }
    
    override func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    func testGetAllGroupsWithSuccess() {
        let groups = try! filtersStorage.getAllLocalizedGroups(forLanguage: "en")
        XCTAssertFalse(groups.isEmpty)
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
    }
    
    func testGetAllLocalizedGroupsWithSuccess() {
        let groups = try! filtersStorage.getAllLocalizedGroups(forLanguage: "fr")
        XCTAssertFalse(groups.isEmpty)
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
    }
    
    func testGetAllLocalizedGroupsWithNonExistingLanguage() {
        let groups = try! filtersStorage.getAllLocalizedGroups(forLanguage: "123")
        XCTAssertTrue(groups.isEmpty)
        XCTAssertNotNil(groups)
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
    }
    
    func testUpdateEnabledGroupState() {
        let groups = try! filtersStorage.getAllLocalizedGroups(forLanguage: "en")
        XCTAssertFalse(groups.isEmpty)
        for group in groups {
            try! filtersStorage.setGroup(withId: group.groupId, enabled: !group.isEnabled)
        }
        
        let updatedGroups = try! filtersStorage.getAllLocalizedGroups(forLanguage: "en")
        XCTAssertFalse(updatedGroups.isEmpty)
        XCTAssertEqual(groups.count, updatedGroups.count)
        for (index,_) in updatedGroups.enumerated() {
            XCTAssertEqual(groups[index].isEnabled, !updatedGroups[index].isEnabled)
        }
    }
    
    func testUpdateEnabledGroupStateWithNonExistionGroup() {
        let groups = try! filtersStorage.getAllLocalizedGroups(forLanguage: "foo")
        XCTAssert(groups.isEmpty)
        for group in groups {
            try! filtersStorage.setGroup(withId: group.groupId, enabled: !group.isEnabled)
        }
        
        let updatedGroups = try! filtersStorage.getAllLocalizedGroups(forLanguage: "foo")
        XCTAssert(updatedGroups.isEmpty)
        XCTAssertEqual(groups.count, updatedGroups.count)
    }
}
