import XCTest

class FiltersMetaStorage_FiltersTest: XCTestCase {
    
    let rootDirectory = Bundle(for: DefaultDatabaseManager.self).resourceURL!
    let workingUrl = Bundle(for: DefaultDatabaseManager.self).resourceURL!.appendingPathComponent("testFolder")
    let fileManager = FileManager.default
    
    let defaultDbFileName = "default.db"
    let defaultDbArchiveFileName = "default.db.zip"
    let adguardDbFileName = "adguard.db"
    
    override func tearDownWithError() throws {
        let _ = deleteTestFolder()
    }
    
    override class func tearDown() {
        clearRootDirectory()
    }

    func testGetAllFiltersWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            XCTAssertTrue(fileManager.fileExists(atPath: workingUrl.appendingPathComponent(adguardDbFileName).path))
            let filters = try filtersStorage.getAllFilters()
            XCTAssertFalse(filters.isEmpty)
            XCTAssertTrue(filters.contains{ $0.name == "Official Polish filters for AdBlock, uBlock Origin & AdGuard"})
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedFiltersWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let filters = try filtersStorage.getAllLocalizedFilters(forLanguage: "fr")
            XCTAssertFalse(filters.isEmpty)
            XCTAssertTrue(filters.contains { $0.name == "Filtre Suédois par Frellwit" })
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllLocalizedFiltersWithNonExistsLanguage() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let filters = try filtersStorage.getAllLocalizedFilters(forLanguage: "123")
            XCTAssertFalse(filters.isEmpty) //If there is no localized group filters constant would be contain NOT localized groups
            XCTAssertTrue(filters.contains{ $0.name == "Official Polish filters for AdBlock, uBlock Origin & AdGuard"})
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private func deleteTestFolder() -> Bool {
        do {
            try fileManager.removeItem(atPath: workingUrl.path)
            return true
        } catch {
            return false
        }
    }
    
    private static func clearRootDirectory() {
        let rootDirectory = Bundle(for: DefaultDatabaseManager.self).resourceURL!
        let fileManager = FileManager.default
        
        let defaultDbFileName = "default.db"
        let adguardDbFileName = "adguard.db"
        
        do {
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(defaultDbFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(defaultDbFileName))
            }
            
            if fileManager.fileExists(atPath: rootDirectory.appendingPathComponent(adguardDbFileName).path) {
                try fileManager.removeItem(at: rootDirectory.appendingPathComponent(adguardDbFileName))
            }
        } catch {}
    }
}
