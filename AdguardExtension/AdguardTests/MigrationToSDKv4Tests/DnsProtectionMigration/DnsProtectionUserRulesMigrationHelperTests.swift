import XCTest

/// Tests for `DnsProtectionUserRulesMigrationHelper`
class DnsProtectionUserRulesMigrationHelperTests: XCTestCase {

    var dnsRulesMigration: DnsProtectionUserRulesMigrationHelperProtocol!

    override func setUp() {
        SDKMigrationsDirectoriesManager.clear()
        SDKMigrationsDirectoriesManager.createFolders()

        dnsRulesMigration = DnsProtectionUserRulesMigrationHelper(
            oldDnsUserRulesContainerFolderUrl: SDKMigrationsDirectoriesManager.rootUrl,
            newDnsUserRulesContainerFolderUrl: SDKMigrationsDirectoriesManager.subfolderUrl
        )
    }

    // MARK: - Test moveOldDnsUserRulesToNewFiles

    func testMoveOldDnsUserRulesToNewFilesForBlocklist() {
        let rules = "rule1\nrule2\nrule3"
        let oldBlocklistUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns_filter_1.txt")
        try! rules.write(to: oldBlocklistUrl, atomically: true, encoding: .utf8)

        let newAllDnsBlocklistRulesFileUrl = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("10004.txt")
        let newEnabledDnsBlocklistRulesFileUrl = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("10002.txt")

        FileManager.default.createFile(atPath: newAllDnsBlocklistRulesFileUrl.path, contents: nil, attributes: nil)
        FileManager.default.createFile(atPath: newEnabledDnsBlocklistRulesFileUrl.path, contents: nil, attributes: nil)

        try! dnsRulesMigration.moveOldDnsUserRulesToNewFiles()

        let newAllDnsBlocklistRulesFileContent = try! String(contentsOf: newAllDnsBlocklistRulesFileUrl)
        let newEnabledDnsBlocklistRulesFileContent = try! String(contentsOf: newEnabledDnsBlocklistRulesFileUrl)
        XCTAssertEqual(newAllDnsBlocklistRulesFileContent, rules)
        XCTAssertEqual(newEnabledDnsBlocklistRulesFileContent, rules)
    }

    func testMoveOldDnsUserRulesToNewFilesForAllowlist() {
        let rules = """
            @@||rule1^|$important
            @@||rule2
            rule3^|$important
            rule4

            """
        let oldAllowlistUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns_filter_2.txt")
        try! rules.write(to: oldAllowlistUrl, atomically: true, encoding: .utf8)

        let newAllDnsAllowlistRulesFileUrl = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("10003.txt")
        let newEnabledDnsAllowlistRulesFileUrl = SDKMigrationsDirectoriesManager.subfolderUrl.appendingPathComponent("10001.txt")

        FileManager.default.createFile(atPath: newAllDnsAllowlistRulesFileUrl.path, contents: nil, attributes: nil)
        FileManager.default.createFile(atPath: newEnabledDnsAllowlistRulesFileUrl.path, contents: nil, attributes: nil)

        try! dnsRulesMigration.moveOldDnsUserRulesToNewFiles()

        let newAllDnsAllowlistRulesFileContent = try! String(contentsOf: newAllDnsAllowlistRulesFileUrl)
        let newEnabledDnsAllowlistRulesFileContent = try! String(contentsOf: newEnabledDnsAllowlistRulesFileUrl)

        let expectedResult = """
            rule1
            @@||rule2
            rule3^|$important
            rule4
            """
        XCTAssertEqual(newAllDnsAllowlistRulesFileContent, expectedResult)
        XCTAssertEqual(newEnabledDnsAllowlistRulesFileContent, expectedResult)
    }

    // MARK: - Test removeOldDnsUserRulesFiles

    func testRemoveOldDnsUserRulesFiles() {
        let oldBlocklistUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns_filter_1.txt")
        let oldAllowlistUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("dns_filter_2.txt")

        FileManager.default.createFile(atPath: oldBlocklistUrl.path, contents: nil, attributes: nil)
        FileManager.default.createFile(atPath: oldAllowlistUrl.path, contents: nil, attributes: nil)

        XCTAssert(FileManager.default.fileExists(atPath: oldBlocklistUrl.path))
        XCTAssert(FileManager.default.fileExists(atPath: oldAllowlistUrl.path))

        try! dnsRulesMigration.removeOldDnsUserRulesFiles()

        XCTAssertFalse(FileManager.default.fileExists(atPath: oldBlocklistUrl.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldAllowlistUrl.path))
    }
}
