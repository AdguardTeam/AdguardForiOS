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
        let groups = try filtersStorage?.getAllLocalizedGroups(forLanguage: "en")
        groups?.forEach {
            setOfDefaultLocalizedGroups.insert($0.name)
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

    func testGetAllLocalizedGroupsWithSuccess() {
        let filtersStorage = filtersStorage!
        do {
            var groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "en")
            XCTAssertFalse(groups.isEmpty)
            groups.forEach {
                XCTAssertNotNil($0.isEnabled)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.groupId)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name.isEmpty)

                XCTAssert(setOfDefaultLocalizedGroups.contains($0.name))
            }
            
            groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "fr")
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
        let filtersStorage = filtersStorage!
        do {
            let groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "123")
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
        let filtersStorage = filtersStorage!
        do {
            let enLocalization = try filtersStorage.getAllLocalizedGroups(forLanguage: "en")
            var frLocalization = try filtersStorage.getAllLocalizedGroups(forLanguage: "fr")
            
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
            
            frLocalization = try filtersStorage.getAllLocalizedGroups(forLanguage: "fr")
            
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
        let filtersStorage = filtersStorage!
        do {
            guard let group = try filtersStorage.getAllLocalizedGroups(forLanguage: "en").first(where: { $0.groupId == 1 }) else { return XCTFail() }
            let oldValue = group.isEnabled
            try filtersStorage.setGroup(withId: 1, enabled: !group.isEnabled)
            guard let group = try filtersStorage.getAllLocalizedGroups(forLanguage: "en").first(where: { $0.groupId == 1 }) else { return XCTFail() }
            XCTAssertNotEqual(oldValue, group.isEnabled)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAll() {
        let filtersStorage = filtersStorage!
        do {
            var groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "en")
                XCTAssertFalse(groups.isEmpty)

            
            let modifiedGroups = groups.map {
                ExtendedFiltersMeta.Group(groupId: $0.groupId, groupName: "foo1001", displayNumber: 123321)
            }
            
            try filtersStorage.updateAll(groups: modifiedGroups)
            
            groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "en")
            modifiedGroups.forEach{ modifiedGroup in
                XCTAssert(groups.contains(where: {
                    $0.groupId == modifiedGroup.groupId &&
                    $0.displayNumber == 123321
                }))
            }
            
            let modifiedGroup = modifiedGroups.first!
            try filtersStorage.updateAll(groups: [ExtendedFiltersMeta.Group(groupId: modifiedGroup.groupId, groupName: "foo", displayNumber: 333333)])
            groups = try filtersStorage.getAllLocalizedGroups(forLanguage: "en")
            
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
        let filtersStorage = filtersStorage!
        do {
            XCTAssertFalse(try filtersStorage.getAllLocalizedGroups(forLanguage: "en").isEmpty)
            try filtersStorage.updateAll(groups: [])
            XCTAssert(try filtersStorage.getAllLocalizedGroups(forLanguage: "en").isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
}
