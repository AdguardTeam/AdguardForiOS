
import XCTest

class NetworkSettingsMigrationTest: XCTestCase {

    private let exceptions = [ WifiException(rule: "rule#1", enabled: true),
                               WifiException(rule: "rule#2", enabled: false),
                               WifiException(rule: "rule#3", enabled: true)]

    private let filePath = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("NetworkSettings").path

    private let fileManager = FileManager.default
    private var resource: SharedResourcesMock!
    private var networkSettings: NetworkSettingsServiceMock!
    private var migration: NetworkSettingsMigrationProtocol!

    override func setUpWithError() throws {
        resource = SharedResourcesMock()
        networkSettings = NetworkSettingsServiceMock()
        migration = NetworkSettingsMigrations(networkSettingsService: networkSettings, resources: resource)
        SDKMigrationsDirectoriesManager.createFolders()
    }

    func testStartMigrationWithSuccess() {
        createTestFile(exceptions: exceptions)
        var exists = fileManager.fileExists(atPath: filePath)
        XCTAssert(exists)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        migration.startMigration()
        exists = fileManager.fileExists(atPath: filePath)
        XCTAssertEqual(networkSettings.invokedAddCount, 3)
        XCTAssertFalse(exists)
    }

    func testStartMigrationWithOldFileNoData() {
        var exists = fileManager.fileExists(atPath: filePath)
        XCTAssert(exists)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        migration.startMigration()
        exists = fileManager.fileExists(atPath: filePath)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        XCTAssert(exists)
    }

    func testStartMigrationWithDecodingError() {
        fileManager.createFile(atPath: filePath, contents: Data())
        resource.files = ["NetworkSettings": Data()]

        var exists = fileManager.fileExists(atPath: filePath)
        XCTAssert(exists)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        migration.startMigration()
        exists = fileManager.fileExists(atPath: filePath)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        XCTAssert(exists)
    }

    func testStartMigrationWithEmptyListOfData() {
        createTestFile(exceptions: [])

        var exists = fileManager.fileExists(atPath: filePath)
        XCTAssert(exists)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        migration.startMigration()
        exists = fileManager.fileExists(atPath: filePath)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        XCTAssert(exists)
    }

    func testStartMigrationWithAddError() {
        createTestFile(exceptions: exceptions)
        networkSettings.stubbedAddError = NSError(domain: "test_error", code: 1, userInfo: nil)
        var exists = fileManager.fileExists(atPath: filePath)
        XCTAssert(exists)
        XCTAssertEqual(networkSettings.invokedAddCount, 0)
        migration.startMigration()
        exists = fileManager.fileExists(atPath: filePath)
        XCTAssertEqual(networkSettings.invokedAddCount, 1)
        XCTAssert(exists)
    }

    private func createTestFile(exceptions: [WifiException]) {
        let data = try! JSONEncoder().encode(exceptions)
        resource.files = ["NetworkSettings": data]
        resource.pathResult = filePath
        fileManager.createFile(atPath: filePath, contents: data)
    }
}
