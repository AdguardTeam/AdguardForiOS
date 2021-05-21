import XCTest

class FiltersMetaStorage_FiltersLocalizationsTest: XCTestCase {

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

    func testGetLocalizationForFilterWithSuccess() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            var localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "en")
            XCTAssertNotNil(localization)
            XCTAssertTrue(localization.name == "AdGuard Russian filter")
            
            localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "fr")
            XCTAssertNotNil(localization)
            XCTAssertTrue(localization.name == "Filtre Russe AdGuard")

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetLocalizationForFilterWithNonExistsIdOrLanguage() {
        do {
            let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
            let filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
            let localization = try filtersStorage.getLocalizationForFilter(withId: 1, forLanguage: "foo")
            XCTAssertNotNil(localization)
            XCTAssertTrue(localization.name == "AdGuard Russian filter")
            XCTAssertTrue(localization.name != "Filtre Russe AdGuard")
            
            XCTAssertThrowsError(try filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "en"))
            XCTAssertThrowsError(try filtersStorage.getLocalizationForFilter(withId: -1, forLanguage: "foo"))
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
