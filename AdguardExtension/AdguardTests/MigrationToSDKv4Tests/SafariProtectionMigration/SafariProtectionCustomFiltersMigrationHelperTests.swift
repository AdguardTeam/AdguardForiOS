import XCTest
import struct SafariAdGuardSDK.Affinity

/// Tests for `SafariProtectionCustomFiltersMigrationHelper`
class SafariProtectionCustomFiltersMigrationHelperTests: XCTestCase {

    var newDbWrapper: SDKMigrationNewDbWrapper!
    var filtersMigration: SafariProtectionCustomFiltersMigrationHelperProtocol!

    override func setUp() {
        SDKMigrationsDirectoriesManager.clear()
        SDKMigrationsDirectoriesManager.createFolders()

        let newDbPath = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("new.db").path
        newDbWrapper = SDKMigrationNewDbWrapper(dbPath: newDbPath)
        newDbWrapper.createDbFile()

        filtersMigration = try! SafariProtectionCustomFiltersMigrationHelper(
            newDBFilePath: newDbPath,
            filtersDirectoryUrl: SDKMigrationsDirectoriesManager.subfolderUrl
        )
    }

    // MARK: - test migrateCustomFilters

    func testMigrateCustomFiltersWithZeroFilters() {
        try! newDbWrapper.createMockTableForFilters()
        try! filtersMigration.migrateCustomFilters([])

        let filtersFromDb = try! newDbWrapper.getAllFilters()
        let filtersDirectoryUrls = try! FileManager.default.contentsOfDirectory(
            at: SDKMigrationsDirectoriesManager.subfolderUrl,
            includingPropertiesForKeys: nil,
            options: []
        )
        XCTAssert(filtersFromDb.isEmpty)
        XCTAssert(filtersDirectoryUrls.isEmpty)
    }

    func testMigrateCustomFiltersWithMultipleFilters() {
        /* Creating 1st custom filter */
        let customFilterRules1 = [
            SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteFilterRules(
                filterId: 10_000,
                ruleText: "custom_filter1_rule1",
                isEnabled: true,
                affinity: nil
            ),
            SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteFilterRules(
                filterId: 10_000,
                ruleText: "custom_filter1_rule2",
                isEnabled: true,
                affinity: nil
            )
        ]
        let customFilter1 = SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter(
            filterId: 10_000,
            groupId: 101,
            isEnabled: true,
            version: "1.1.1",
            lastUpdateTime: nil,
            displayNumber: 1,
            name: "Custom filter 1",
            description: nil,
            homePage: nil,
            subscriptionUrl: "Custom sub url 1",
            rules: customFilterRules1
        )

        /* Creating 2nd custom filter */
        let customFilterRules2 = [
            SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteFilterRules(
                filterId: 10_001,
                ruleText: "custom_filter2_rule1",
                isEnabled: true,
                affinity: nil
            ),
            SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteFilterRules(
                filterId: 10_001,
                ruleText: "custom_filter2_rule2",
                isEnabled: true,
                affinity: nil
            )
        ]
        let customFilter2 = SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter(
            filterId: 10_001,
            groupId: 101,
            isEnabled: false,
            version: "2.2",
            lastUpdateTime: nil,
            displayNumber: 2,
            name: "Custom filter 2",
            description: "Custom filter descr 2",
            homePage: "Custom filter homepage 2",
            subscriptionUrl: nil,
            rules: customFilterRules2
        )

        try! newDbWrapper.createMockTableForFilters()
        try! filtersMigration.migrateCustomFilters([customFilter1, customFilter2])

        /* Check what is in db */
        let filtersFromDb = try! newDbWrapper.getAllFilters()
        XCTAssertEqual(filtersFromDb.count, 2)
        check(customFilter1, filtersFromDb[0])
        check(customFilter2, filtersFromDb[1])

        /* Check files content */
        let filtersDirectoryUrls = try! FileManager.default.contentsOfDirectory(
            at: SDKMigrationsDirectoriesManager.subfolderUrl,
            includingPropertiesForKeys: nil,
            options: []
        )
        XCTAssertEqual(filtersDirectoryUrls.count, 2)
        let actualContent1 = try! String(contentsOf: SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("10000.txt"))
        let actualContent2 = try! String(contentsOf: SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("10001.txt"))

        let expectedContent1 = customFilterRules1.map { $0.ruleText }.joined(separator: "\n")
        let expectedContent2 = customFilterRules2.map { $0.ruleText }.joined(separator: "\n")

        XCTAssertEqual(expectedContent1, actualContent1)
        XCTAssertEqual(expectedContent2, actualContent2)
    }

    func testMigrateCustomFiltersWithAffinity() {
        /* Creating custom filter */
        let customFilterRules = [
            SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteFilterRules(
                filterId: 10_000,
                ruleText: "custom_rule1",
                isEnabled: true,
                affinity: Int(Affinity.privacy.rawValue)
            ),
            SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteFilterRules(
                filterId: 10_000,
                ruleText: "custom_rule2",
                isEnabled: true,
                affinity: Int(Affinity.privacy.rawValue)
            )
        ]
        let customFilter = SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter(
            filterId: 10_000,
            groupId: 101,
            isEnabled: true,
            version: "1.1.1",
            lastUpdateTime: nil,
            displayNumber: 1,
            name: "Custom filter 1",
            description: nil,
            homePage: nil,
            subscriptionUrl: "Custom sub url 1",
            rules: customFilterRules
        )
        try! newDbWrapper.createMockTableForFilters()
        try! filtersMigration.migrateCustomFilters([customFilter])

        /* Check what is in db */
        let filtersFromDb = try! newDbWrapper.getAllFilters()
        XCTAssertEqual(filtersFromDb.count, 1)
        check(customFilter, filtersFromDb[0])

        /* Check files content */
        let filtersDirectoryUrls = try! FileManager.default.contentsOfDirectory(
            at: SDKMigrationsDirectoriesManager.subfolderUrl,
            includingPropertiesForKeys: nil,
            options: []
        )
        XCTAssertEqual(filtersDirectoryUrls.count, 1)

        let actualContent = try! String(contentsOf: SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("10000.txt"))
        let expectedContent = """
        !#safari_cb_affinity(privacy)
        custom_rule1
        !#safari_cb_affinity
        !#safari_cb_affinity(privacy)
        custom_rule2
        !#safari_cb_affinity
        """
        XCTAssertEqual(expectedContent, actualContent)
    }

    private func check(
        _ lhs: SafariProtectionFiltersDatabaseMigrationHelper.ObsoleteCustomFilter,
        _ rhs: SDKMigrationNewDbWrapper.CustomFiltersTable
    ) {
        XCTAssertEqual(lhs.filterId, rhs.filterId)
        XCTAssertEqual(lhs.groupId, rhs.groupId)
        XCTAssertEqual(lhs.isEnabled, rhs.isEnabled)
        XCTAssertEqual(lhs.version, rhs.version)
        XCTAssertEqual(lhs.displayNumber, rhs.displayNumber)
        XCTAssertEqual(lhs.name, rhs.name)
        XCTAssertEqual(lhs.description, rhs.description)
        XCTAssertEqual(lhs.homePage, rhs.homePage)
        XCTAssertEqual(lhs.subscriptionUrl, rhs.subscriptionUrl)
    }
}
