import XCTest

class FiltersMetaStorage_GroupsTest: XCTestCase {

    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager?
    var filtersStorage: FiltersMetaStorage?
    var setOfDefaultLocalizedGroups: Set<String?> = Set()
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager!)
        
        setOfDefaultLocalizedGroups.removeAll()
        let groups = try filtersStorage?.getAllGroups()
        groups?.forEach {
            setOfDefaultLocalizedGroups.insert($0.groupName)
        }
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
    
    func testGetAllGroupsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let groups = try filtersStorage.getAllGroups()
            XCTAssertFalse(groups.isEmpty)
            groups.forEach {
                XCTAssertNotNil($0.isEnabled)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.groupId)
                XCTAssertNotNil($0.groupName)
                XCTAssertFalse($0.groupName.isEmpty)
            }

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedGroupsWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "fr")
            XCTAssertFalse(groups.isEmpty)
            groups.forEach {
                XCTAssertNotNil($0.isEnabled)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.groupId)
                XCTAssertNotNil($0.groupName)
                XCTAssertFalse($0.groupName.isEmpty)
                
                XCTAssertFalse(setOfDefaultLocalizedGroups.contains($0.groupName))
            }

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedGroupsWithNonExistingLanguage() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "123")
            XCTAssertTrue(groups.isEmpty)
            XCTAssertNotNil(groups)
            groups.forEach {
                XCTAssertNotNil($0.isEnabled)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.groupId)
                XCTAssertNotNil($0.groupName)
                XCTAssertFalse($0.groupName.isEmpty)
                
                XCTAssertFalse(setOfDefaultLocalizedGroups.contains($0.groupName))
            }

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateEnabledGroupState() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "en")
            XCTAssertFalse(groups.isEmpty)
            for group in groups {
                try filtersStorage.updateEnabledGroupState(groupId: group.groupId, enabled: !group.isEnabled)
            }
            
            let updatedGroups = try filtersStorage.getAllLocalizedGroups(forLanguage: "en")
            XCTAssertFalse(updatedGroups.isEmpty)
            XCTAssertEqual(groups.count, updatedGroups.count)
            for (index,_) in updatedGroups.enumerated() {
                XCTAssertEqual(groups[index].isEnabled, !updatedGroups[index].isEnabled)
            }
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateEnabledGroupStateWithNonExistionGroup() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "foo")
            XCTAssert(groups.isEmpty)
            for group in groups {
                try filtersStorage.updateEnabledGroupState(groupId: group.groupId, enabled: !group.isEnabled)
            }
            
            let updatedGroups = try filtersStorage.getAllLocalizedGroups(forLanguage: "foo")
            XCTAssert(updatedGroups.isEmpty)
            XCTAssertEqual(groups.count, updatedGroups.count)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteGroupWithSuccess() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            guard let group = try filtersStorage.getAllGroups().first else { return XCTFail() }
            try filtersStorage.deleteGroup(groupId: group.groupId)
            let removed = try filtersStorage.getAllGroups().filter { $0.groupId == group.groupId }
            XCTAssert(removed.isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteGroupWithNonExistingGroupId() {
        guard let filtersStorage = filtersStorage else { return XCTFail() }
        do {
            let group = try filtersStorage.getAllGroups().filter { $0.groupId == -123 }
            XCTAssert(group.isEmpty)
            try filtersStorage.deleteGroup(groupId: -123)
            let removed = try filtersStorage.getAllGroups().filter { $0.groupId == -123 }
            XCTAssert(removed.isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
}
