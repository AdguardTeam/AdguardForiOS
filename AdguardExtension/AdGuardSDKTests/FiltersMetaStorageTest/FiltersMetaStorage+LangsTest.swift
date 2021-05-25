import XCTest

class FiltersMetaStorage_LangsTest: XCTestCase {

    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager?
    var filtersStorage: FiltersMetaStorage?
    var setOfTestableLangs: Set<String> = Set()
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager!)
        
        let lang = try filtersStorage!.getLangsForFilter(withId: 1)
        lang.forEach { setOfTestableLangs.insert($0) }
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
    
    func testGetLangsForFilterWithSuccess() {
        guard let filtersStorage = filtersStorage else { return }
        do {
            let lang = try filtersStorage.getLangsForFilter(withId: 1)
            XCTAssertFalse(lang.isEmpty)
            lang.forEach {
                XCTAssertFalse($0.isEmpty)
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLangsForFilterWithDifferentLocalization() {
        guard let filtersStorage = filtersStorage else { return }
        do {
            let lang = try filtersStorage.getLangsForFilter(withId: 8)
            XCTAssertFalse(lang.isEmpty)
            lang.forEach {
                XCTAssertFalse($0.isEmpty)
                XCTAssertFalse(setOfTestableLangs.contains($0))
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLangsForFilterWithNonExistingId() {
        guard let filtersStorage = filtersStorage else { return }
        do {
            var lang = try filtersStorage.getLangsForFilter(withId: 123456789)
            XCTAssertTrue(lang.isEmpty)
            
            lang = try filtersStorage.getLangsForFilter(withId: -123456789)
            XCTAssertTrue(lang.isEmpty)
            
        } catch {
            XCTFail("\(error)")
        }
    }
}
