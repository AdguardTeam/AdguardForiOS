import XCTest

class FiltersMetaStorage_GroupsTest: XCTestCase {

    let rootDirectory = MetaStorageTestProcessor.rootDirectory
    let workingUrl = MetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    var setOfDefaultLocalizedGroups: Set<String?> = Set()
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
        
        setOfDefaultLocalizedGroups.removeAll()
        let groups = try metaStorage?.getAllLocalizedGroups(forLanguage: "en")
        groups?.forEach {
            setOfDefaultLocalizedGroups.insert($0.name)
        }
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

    func testGetAllLocalizedGroupsWithSuccess() {
        do {
            var groups = try metaStorage.getAllLocalizedGroups(forLanguage: "en")
            XCTAssertFalse(groups.isEmpty)
            groups.forEach {
                XCTAssertNotNil($0.isEnabled)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.groupId)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name.isEmpty)

                XCTAssert(setOfDefaultLocalizedGroups.contains($0.name))
            }
            
            setOfDefaultLocalizedGroups.remove("Custom")
            
            groups = try metaStorage.getAllLocalizedGroups(forLanguage: "fr")
            XCTAssertFalse(groups.isEmpty)
            groups.forEach {
                XCTAssertNotNil($0.isEnabled)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.groupId)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name.isEmpty)

                XCTAssertFalse(setOfDefaultLocalizedGroups.contains($0.name))
            }

        } catch {
            XCTFail("\(error)")
        }
    }

    func testGetAllLocalizedGroupsWithNonExistingLanguage() {
        do {
            let groups = try metaStorage.getAllLocalizedGroups(forLanguage: "123")
            XCTAssertFalse(groups.isEmpty)
            XCTAssertNotNil(groups)
            groups.forEach {
                XCTAssertNotNil($0.isEnabled)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.groupId)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name.isEmpty)

                XCTAssert(setOfDefaultLocalizedGroups.contains($0.name))
            }

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedGroupsWithDefaultLocalization() {
        do {
            let enLocalization = try metaStorage.getAllLocalizedGroups(forLanguage: "en")
            var frLocalization = try metaStorage.getAllLocalizedGroups(forLanguage: "fr")
            
            enLocalization.forEach { enLocal in
                XCTAssert(frLocalization.contains {
                    $0.name != enLocal.name
                })
            }
            
            XCTAssertFalse(frLocalization.isEmpty)
            
            //Delete localization for language FR to test default localization from filter_group table data fetch
            try productionDbManager?.filtersDb.run("DELETE FROM filter_group_localizations WHERE (\"lang\" = \"fr\")")
            let count = try productionDbManager?.filtersDb.scalar("SELECT count(*) FROM filter_group_localizations WHERE (\"lang\" = \"fr\")") as! Int64
            XCTAssertNotNil(count)
            XCTAssert(count == 0)
            
            frLocalization = try metaStorage.getAllLocalizedGroups(forLanguage: "fr")
            
            enLocalization.forEach { enLocal in
                XCTAssert(frLocalization.contains {
                    $0.name == enLocal.name
                })
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetGroup() {
        do {
            guard let group = try metaStorage.getAllLocalizedGroups(forLanguage: "en").first(where: { $0.groupId == 1 }) else { return XCTFail() }
            let oldValue = group.isEnabled
            try metaStorage.setGroup(withId: 1, enabled: !group.isEnabled)
            guard let group = try metaStorage.getAllLocalizedGroups(forLanguage: "en").first(where: { $0.groupId == 1 }) else { return XCTFail() }
            XCTAssertNotEqual(oldValue, group.isEnabled)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAll() {
        do {
            var groups = try metaStorage.getAllLocalizedGroups(forLanguage: "en")
            XCTAssertFalse(groups.isEmpty)
            
            
            let modifiedGroups = groups.map {
                ExtendedFiltersMeta.Group(groupId: $0.groupId, groupName: "foo1001", displayNumber: 123321)
            }
            
            try metaStorage.updateAll(groups: modifiedGroups)
            
            groups = try metaStorage.getAllLocalizedGroups(forLanguage: "en")
            modifiedGroups.forEach{ modifiedGroup in
                XCTAssert(groups.contains(where: {
                    $0.groupId == modifiedGroup.groupId &&
                        $0.displayNumber == 123321
                }))
            }
            
            let modifiedGroup = modifiedGroups.first!
            try metaStorage.updateAll(groups: [ExtendedFiltersMeta.Group(groupId: modifiedGroup.groupId, groupName: "foo", displayNumber: 333333)])
            groups = try metaStorage.getAllLocalizedGroups(forLanguage: "en")
            
            XCTAssertEqual(groups.count, 1)
            XCTAssert(groups.contains(where: {
                $0.groupId == modifiedGroup.groupId &&
                    $0.displayNumber == 333333
            }))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAllWithEmptyValue() {
        do {
            XCTAssertFalse(try metaStorage.getAllLocalizedGroups(forLanguage: "en").isEmpty)
            try metaStorage.updateAll(groups: [])
            XCTAssert(try metaStorage.getAllLocalizedGroups(forLanguage: "en").isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
}
