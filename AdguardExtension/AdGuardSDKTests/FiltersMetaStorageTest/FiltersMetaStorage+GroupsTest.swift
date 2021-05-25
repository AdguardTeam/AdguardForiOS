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
        guard let filtersStorage = filtersStorage else { return }
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
        guard let filtersStorage = filtersStorage else { return }
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
        guard let filtersStorage = filtersStorage else { return }
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
}
