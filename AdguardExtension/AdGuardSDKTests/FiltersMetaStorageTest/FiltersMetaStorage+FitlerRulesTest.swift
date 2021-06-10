import XCTest

class FiltersMetaStorage_FitlerRulesTest: XCTestCase {
    
    let rootDirectory = MetaStorageTestProcessor.rootDirectory
    let workingUrl = MetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
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
}
