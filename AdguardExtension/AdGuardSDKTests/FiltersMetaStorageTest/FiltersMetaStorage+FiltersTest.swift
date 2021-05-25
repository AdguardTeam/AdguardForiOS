import XCTest

class FiltersMetaStorage_FiltersTest: XCTestCase {
    
    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager?
    var filtersStorage: FiltersMetaStorage?
    var setOfDefaultLocalizedFiltersDescription: Set<String?> = Set()
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager!)
        
        setOfDefaultLocalizedFiltersDescription.removeAll()
        let notLocalizedFilters = try filtersStorage!.getAllLocalizedFilters(forLanguage: "en")
        notLocalizedFilters.forEach {
            setOfDefaultLocalizedFiltersDescription.insert($0.description)
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

    func testGetAllFiltersWithSuccess() {
        guard let filtersStorage = filtersStorage else { return }
        do {
            
            XCTAssertTrue(fileManager.fileExists(atPath: FiltersMetaStorageTestProcessor.adguardDbFileWorkingUrl.path))
            let filters = try filtersStorage.getAllFilters()
            XCTAssertFalse(filters.isEmpty)
            filters.forEach {
                XCTAssertNotNil($0.filterId)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.group)
                XCTAssertNotNil($0.group.groupId)
                XCTAssertNotNil($0.group.displayNumber)
                XCTAssertFalse($0.group.groupName.isEmpty)
                XCTAssertNotNil($0.trustLevel)
                XCTAssertNotNil($0.description)
                XCTAssertFalse($0.description!.isEmpty)
                XCTAssertNotNil($0.filterDownloadPage)
                XCTAssertFalse($0.filterDownloadPage!.isEmpty)
                XCTAssertNotNil($0.homePage)
                XCTAssertFalse($0.homePage!.isEmpty)
                XCTAssertNotNil($0.lastUpdateDate)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name!.isEmpty)
                XCTAssertNotNil($0.updateFrequency)
                XCTAssertNotNil($0.version)
                XCTAssertFalse($0.version!.isEmpty)
            }
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedFiltersWithSuccess() {
        guard let filtersStorage = filtersStorage else { return }
        do {
            let filters = try filtersStorage.getAllLocalizedFilters(forLanguage: "fr")
            XCTAssertFalse(filters.isEmpty)
            filters.forEach {
                XCTAssertNotNil($0.filterId)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.group)
                XCTAssertNotNil($0.group.groupId)
                XCTAssertNotNil($0.group.displayNumber)
                XCTAssertFalse($0.group.groupName.isEmpty)
                XCTAssertNotNil($0.trustLevel)
                XCTAssertNotNil($0.description)
                XCTAssertFalse($0.description!.isEmpty)
                XCTAssertNotNil($0.filterDownloadPage)
                XCTAssertFalse($0.filterDownloadPage!.isEmpty)
                XCTAssertNotNil($0.homePage)
                XCTAssertFalse($0.homePage!.isEmpty)
                XCTAssertNotNil($0.lastUpdateDate)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name!.isEmpty)
                XCTAssertNotNil($0.updateFrequency)
                XCTAssertNotNil($0.version)
                XCTAssertFalse($0.version!.isEmpty)
                
                XCTAssertFalse(setOfDefaultLocalizedFiltersDescription.contains($0.description))
            }
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedFiltersWithNonExistingLanguage() {
        guard let filtersStorage = filtersStorage else { return }
        do {
            let filters = try filtersStorage.getAllLocalizedFilters(forLanguage: "123")
            XCTAssertFalse(filters.isEmpty)
            filters.forEach {
                XCTAssertNotNil($0.filterId)
                XCTAssertNotNil($0.displayNumber)
                XCTAssertNotNil($0.group)
                XCTAssertNotNil($0.group.groupId)
                XCTAssertNotNil($0.group.displayNumber)
                XCTAssertFalse($0.group.groupName.isEmpty)
                XCTAssertNotNil($0.trustLevel)
                XCTAssertNotNil($0.description)
                XCTAssertFalse($0.description!.isEmpty)
                XCTAssertNotNil($0.filterDownloadPage)
                XCTAssertFalse($0.filterDownloadPage!.isEmpty)
                XCTAssertNotNil($0.homePage)
                XCTAssertFalse($0.homePage!.isEmpty)
                XCTAssertNotNil($0.lastUpdateDate)
                XCTAssertNotNil($0.name)
                XCTAssertFalse($0.name!.isEmpty)
                XCTAssertNotNil($0.updateFrequency)
                XCTAssertNotNil($0.version)
                XCTAssertFalse($0.version!.isEmpty)
                
                XCTAssertTrue(setOfDefaultLocalizedFiltersDescription.contains($0.description))
            }
        } catch {
            XCTFail("\(error)")
        }
    }
}
