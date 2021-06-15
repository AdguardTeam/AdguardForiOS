import XCTest

class FiltersMetaStorage_FiltersTest: XCTestCase {
    
    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var filtersStorage: FiltersMetaStorage!
    
    override func setUpWithError() throws {
        let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
    }
    
    override func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }

    func testUpdateEnabledFilterStateWithSuccess() {
    }
}
