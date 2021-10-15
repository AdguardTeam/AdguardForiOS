import XCTest

/// Tests for `SafariProtectionAllowlistRulesMigrationHelperTests`
class SafariProtectionAllowlistRulesMigrationHelperTests: XCTestCase {

    var allowlistMigration: SafariProtectionAllowlistRulesMigrationHelperProtocol!

    override func setUp() {
        SDKMigrationsDirectoriesManager.clear()
        SDKMigrationsDirectoriesManager.createFolders()

        let path = SDKMigrationsDirectoriesManager.rootUrl.path
        allowlistMigration = SafariProtectionAllowlistRulesMigrationHelper(rulesContainerDirectoryPath: path)
    }

    // MARK: - Test getAllowlistRules

    func testGetAllowlistRulesWithAbcentFile() {
        let oldRules = try! allowlistMigration.getAllowlistRules()
        XCTAssert(oldRules.isEmpty)
    }

    func testGetAllowlistRulesWithZeroRules() {
        createObsoleteAllowlistFile(from: [])
        let oldRules = try! allowlistMigration.getAllowlistRules()
        XCTAssert(oldRules.isEmpty)
    }

    func testGetAllowlistRulesWithMultipleRules() {
        let rules = [("rule1", true), ("rule2", false), ("rule3", true)]
        createObsoleteAllowlistFile(from: rules)

        let oldRules = try! allowlistMigration.getAllowlistRules()
        XCTAssertEqual(oldRules.count, rules.count)

        for i in 0..<rules.count {
            XCTAssertEqual(rules[i].0, oldRules[i].ruleText)
            XCTAssertEqual(rules[i].1, oldRules[i].isEnabled)
        }
    }

    // MARK: - Test getInvertedAllowlistRules

    func testGetInvertedAllowlistRulesWithAbcentFile() {
        let oldRules = try! allowlistMigration.getInvertedAllowlistRules()
        XCTAssert(oldRules.isEmpty)
    }

    func testGetInvertedAllowlistRulesWithZeroRules() {
        createObsoleteInvAllowlistFile(from: [])
        let oldRules = try! allowlistMigration.getInvertedAllowlistRules()
        XCTAssert(oldRules.isEmpty)
    }

    func testGetInvertedAllowlistRulesWithMultipleRules() {
        let rules = [("rule1", true), ("rule2", false), ("rule3", true)]
        createObsoleteInvAllowlistFile(from: rules)

        let oldRules = try! allowlistMigration.getInvertedAllowlistRules()
        XCTAssertEqual(oldRules.count, rules.count)

        for i in 0..<rules.count {
            XCTAssertEqual(rules[i].0, oldRules[i].ruleText)
            XCTAssertEqual(rules[i].1, oldRules[i].isEnabled)
        }
    }

    // MARK: - Test removeOldRuleFiles

    func testRemoveOldRuleFiles() {
        let rules = [("rule1", true), ("rule2", false), ("rule3", true)]
        createObsoleteAllowlistFile(from: rules)
        createObsoleteInvAllowlistFile(from: rules)

        let allowlistFilePath = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("safari-whitelist-rules.data").path
        XCTAssert(FileManager.default.fileExists(atPath: allowlistFilePath))

        let invAllowlistFilePath = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("safari-inverdet-whitelist-rules.data").path
        XCTAssert(FileManager.default.fileExists(atPath: invAllowlistFilePath))

        try! allowlistMigration.removeOldRuleFiles()
        XCTAssertFalse(FileManager.default.fileExists(atPath: allowlistFilePath))
        XCTAssertFalse(FileManager.default.fileExists(atPath: invAllowlistFilePath))
    }

    // MARK: - Private helper methods

    private func createObsoleteAllowlistFile(from rules: [(rule: String, isEnabled: Bool)]) {
        let fileName = "safari-whitelist-rules.data"

        let oldRules = rules.enumerated().map {
            SDKSafariMigrationAllowlistRule(
                filterId: 0,
                ruleId: $0.offset,
                ruleText: $0.element.rule,
                isEnabled: $0.element.isEnabled,
                affinity: nil
            )
        }

        NSKeyedArchiver.setClassName("ASDFilterRule", for: SDKSafariMigrationAllowlistRule.self)
        NSKeyedUnarchiver.setClass(SDKSafariMigrationAllowlistRule.self, forClassName: "ASDFilterRule")

        let rulesData = try! NSKeyedArchiver.archivedData(withRootObject: oldRules, requiringSecureCoding: false)
        let url = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent(fileName)
        try! rulesData.write(to: url)
    }

    private func createObsoleteInvAllowlistFile(from rules: [(rule: String, isEnabled: Bool)]) {
        let fileName = "safari-inverdet-whitelist-rules.data"

        let oldRules = rules.enumerated().map {
            SDKSafariMigrationAllowlistRule(
                filterId: 0,
                ruleId: $0.offset,
                ruleText: $0.element.rule,
                isEnabled: $0.element.isEnabled,
                affinity: nil
            )
        }
        NSKeyedArchiver.setClassName(
            "AEInvertedWhitelistDomainsObject",
            for: SDKSafariMigrationInvertedAllowlistDomainObject.self
        )
        NSKeyedUnarchiver.setClass(
            SDKSafariMigrationInvertedAllowlistDomainObject.self,
            forClassName: "AEInvertedWhitelistDomainsObject"
        )

        let object = SDKSafariMigrationInvertedAllowlistDomainObject(rules: oldRules)
        let rulesData = try! NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        let url = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent(fileName)
        try! rulesData.write(to: url)
    }
}
