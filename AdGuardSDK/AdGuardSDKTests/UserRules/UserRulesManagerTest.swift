import XCTest

class UserRulesManagerTest: XCTestCase {

    var storage: UserDefaultsStorageProtocol = UserDefaultsStorage(storage: UserDefaults(suiteName: "UserRulesStorage")!)
    var fileStorage: FilterFilesStorageProtocol = try! FilterFilesStorage(filterFilesDirectoryUrl: TestsFileManager.workingUrl)

    var allowlistRulesManager: UserRulesManagerProtocol?
    var invertedAllowlistRulesManager: UserRulesManagerProtocol?
    var blocklistRulesManager: UserRulesManagerProtocol?
    var dnsBlocklistRulesManager: UserRulesManagerProtocol?
    var dnsAllowlistRulesManager: UserRulesManagerProtocol?

    override func setUp() {
        let safariManagersProvider = SafariUserRulesManagersProvider(userDefaultsStorage: storage)

        allowlistRulesManager = safariManagersProvider.allowlistRulesManager
        allowlistRulesManager?.removeAllRules()

        invertedAllowlistRulesManager = safariManagersProvider.invertedAllowlistRulesManager
        invertedAllowlistRulesManager?.removeAllRules()

        blocklistRulesManager = safariManagersProvider.blocklistRulesManager
        blocklistRulesManager?.removeAllRules()

        let dnsManagersProvider = DnsUserRulesManagersProvider(fileStorage: fileStorage)

        dnsBlocklistRulesManager = dnsManagersProvider.blocklistRulesManager
        dnsBlocklistRulesManager?.removeAllRules()

        dnsAllowlistRulesManager = dnsManagersProvider.allowlistRulesManager
        dnsAllowlistRulesManager?.removeAllRules()

        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        try! FileManager.default.createDirectory(at: TestsFileManager.workingUrl, withIntermediateDirectories: false, attributes: nil)
    }

    override func tearDown() {
        allowlistRulesManager = nil
        invertedAllowlistRulesManager = nil
        blocklistRulesManager = nil
        dnsBlocklistRulesManager = nil
        dnsAllowlistRulesManager = nil

        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }

    let testRules = [
        UserRule(ruleText: "foo1", isEnabled: false),
        UserRule(ruleText: "foo2"),
        UserRule(ruleText: "foo3"),
        UserRule(ruleText: "foo4"),
        UserRule(ruleText: "foo5", isEnabled: false),
        UserRule(ruleText: "foo6"),
        UserRule(ruleText: "foo7"),
        UserRule(ruleText: "foo8"),
        UserRule(ruleText: "foo9"),
        UserRule(ruleText: "foo10")
    ]

    func testAllowlistRulesManager() {
        try! testAddRule(userRuleManager: allowlistRulesManager!)
        try! testAddRules(userRuleManager: allowlistRulesManager!)
        testSetRules(userRuleManager: allowlistRulesManager!)
        try! testModifyRule(userRuleManager: allowlistRulesManager!)
        try! testRemoveRules(userRuleManager: allowlistRulesManager!)
        try! testRemoveAllRules(userRuleManager: allowlistRulesManager!)
        try! testReset(userRuleManager: allowlistRulesManager!)
        testThreadSafty(userRuleManager: allowlistRulesManager!)
    }

    func testInvertedAllowlistRulesManager() {
        try! testAddRule(userRuleManager: invertedAllowlistRulesManager!)
        try! testAddRules(userRuleManager: invertedAllowlistRulesManager!)
        testSetRules(userRuleManager: invertedAllowlistRulesManager!)
        try! testModifyRule(userRuleManager: invertedAllowlistRulesManager!)
        try! testRemoveRules(userRuleManager: invertedAllowlistRulesManager!)
        try! testRemoveAllRules(userRuleManager: invertedAllowlistRulesManager!)
        try! testReset(userRuleManager: invertedAllowlistRulesManager!)
        testThreadSafty(userRuleManager: invertedAllowlistRulesManager!)
    }

    func testBlockinglistRulesManager() {
        try! testAddRule(userRuleManager: blocklistRulesManager!)
        try! testAddRules(userRuleManager: blocklistRulesManager!)
        testSetRules(userRuleManager: blocklistRulesManager!)
        try! testModifyRule(userRuleManager: blocklistRulesManager!)
        try! testRemoveRules(userRuleManager: blocklistRulesManager!)
        try! testRemoveAllRules(userRuleManager: blocklistRulesManager!)
        try! testReset(userRuleManager: blocklistRulesManager!)
        testThreadSafty(userRuleManager: blocklistRulesManager!)
    }

    func testDnsBlockinglistRulesManager() {
        try! testAddRule(userRuleManager: dnsBlocklistRulesManager!)
        try! testAddRules(userRuleManager: dnsBlocklistRulesManager!)
        testSetRules(userRuleManager: dnsBlocklistRulesManager!)
        try! testModifyRule(userRuleManager: dnsBlocklistRulesManager!)
        try! testRemoveRules(userRuleManager: dnsBlocklistRulesManager!)
        try! testRemoveAllRules(userRuleManager: dnsBlocklistRulesManager!)
        try! testReset(userRuleManager: dnsBlocklistRulesManager!)
        testThreadSafty(userRuleManager: dnsBlocklistRulesManager!)
    }

    func testDnsAllowlistRulesManager() {
        try! testAddRule(userRuleManager: dnsAllowlistRulesManager!)
        try! testAddRules(userRuleManager: dnsAllowlistRulesManager!)
        testSetRules(userRuleManager: dnsAllowlistRulesManager!)
        try! testModifyRule(userRuleManager: dnsAllowlistRulesManager!)
        try! testRemoveRules(userRuleManager: dnsAllowlistRulesManager!)
        try! testRemoveAllRules(userRuleManager: dnsAllowlistRulesManager!)
        try! testReset(userRuleManager: dnsAllowlistRulesManager!)
        testThreadSafty(userRuleManager: dnsAllowlistRulesManager!)
    }

    private func testAddRule(userRuleManager: UserRulesManagerProtocol) throws {

        XCTAssert(userRuleManager.allRules.isEmpty)
        try userRuleManager.add(rule: UserRule(ruleText: "1", isEnabled: false), override: false)
        XCTAssertFalse(userRuleManager.allRules.isEmpty)

        XCTAssertThrowsError(try userRuleManager.add(rule: UserRule(ruleText: "1", isEnabled: true), override: false))
        XCTAssertFalse(userRuleManager.allRules.isEmpty)

        XCTAssertNoThrow(try userRuleManager.add(rule: UserRule(ruleText: "1", isEnabled: true), override: true))
        let rule = userRuleManager.allRules.first { $0.ruleText == "1" }
        XCTAssertEqual(rule?.isEnabled, true)

        userRuleManager.removeAllRules()
    }

    private func testAddRules(userRuleManager: UserRulesManagerProtocol) throws {
        XCTAssert(userRuleManager.allRules.isEmpty)
        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        XCTAssertThrowsError(try userRuleManager.add(rules: testRules, override: false))
        XCTAssertFalse(userRuleManager.allRules.isEmpty)

        XCTAssertNoThrow(try userRuleManager.add(rules: testRules, override: true))
        XCTAssertFalse(userRuleManager.allRules.isEmpty)

        // Test add rules with duplicates
        userRuleManager.removeAllRules()

        var rulesWithDuplicates = testRules
        rulesWithDuplicates.append(testRules[0])
        XCTAssertThrowsError(try userRuleManager.add(rules: rulesWithDuplicates, override: false))
        XCTAssert(userRuleManager.allRules.isEmpty)

        // Only unique rules should be added
        XCTAssertNoThrow(try userRuleManager.add(rules: rulesWithDuplicates, override: true))
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        // Test duplicates with existing rules
        XCTAssertNoThrow(try userRuleManager.add(rules: [testRules[0], testRules[1]], override: true))
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        XCTAssertThrowsError(try userRuleManager.add(rules: [testRules[0], testRules[1]], override: false))
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        XCTAssertNoThrow(try userRuleManager.add(rules: [testRules[1], testRules[1]], override: true))
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        XCTAssertThrowsError(try userRuleManager.add(rules: [testRules[0], testRules[0]], override: false))
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        XCTAssertNoThrow(try userRuleManager.add(rules: [testRules[1], testRules[1], UserRule(ruleText: "duplicate"), UserRule(ruleText: "duplicate")], override: true))
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count + 1)

        userRuleManager.removeAllRules()
    }

    private func testSetRules(userRuleManager: UserRulesManagerProtocol) {
        // Test 1
        XCTAssert(userRuleManager.allRules.isEmpty)
        try! userRuleManager.add(rule: UserRule(ruleText: "rule1", isEnabled: true), override: true)
        XCTAssertEqual(userRuleManager.allRules.count, 1)

        userRuleManager.set(rules: ["rule1", "rule2"])
        XCTAssertEqual(userRuleManager.allRules.count, 2)
        XCTAssertEqual(userRuleManager.allRules[0], UserRule(ruleText: "rule1", isEnabled: true))
        XCTAssertEqual(userRuleManager.allRules[1], UserRule(ruleText: "rule2", isEnabled: true))
        userRuleManager.removeAllRules()

        // Test 2
        XCTAssert(userRuleManager.allRules.isEmpty)
        try! userRuleManager.add(rule: UserRule(ruleText: "rule1", isEnabled: false), override: true)
        XCTAssertEqual(userRuleManager.allRules.count, 1)

        userRuleManager.set(rules: ["rule0", "rule1", "rule2"])
        XCTAssertEqual(userRuleManager.allRules.count, 3)
        XCTAssertEqual(userRuleManager.allRules[0], UserRule(ruleText: "rule0", isEnabled: true))
        XCTAssertEqual(userRuleManager.allRules[1], UserRule(ruleText: "rule1", isEnabled: false))
        XCTAssertEqual(userRuleManager.allRules[2], UserRule(ruleText: "rule2", isEnabled: true))
        userRuleManager.removeAllRules()

        // Test 3
        XCTAssert(userRuleManager.allRules.isEmpty)
        try! userRuleManager.add(
            rules: [
                UserRule(ruleText: "rule1", isEnabled: true),
                UserRule(ruleText: "rule2", isEnabled: false),
                UserRule(ruleText: "rule3", isEnabled: true),
                UserRule(ruleText: "rule4", isEnabled: true)
            ],
            override: true
        )
        XCTAssertEqual(userRuleManager.allRules.count, 4)

        userRuleManager.set(rules: ["rule1", "rule2", "rule4"])
        XCTAssertEqual(userRuleManager.allRules.count, 3)
        XCTAssertEqual(userRuleManager.allRules[0], UserRule(ruleText: "rule1", isEnabled: true))
        XCTAssertEqual(userRuleManager.allRules[1], UserRule(ruleText: "rule2", isEnabled: false))
        XCTAssertEqual(userRuleManager.allRules[2], UserRule(ruleText: "rule4", isEnabled: true))
        userRuleManager.removeAllRules()

        // Test 4
        XCTAssert(userRuleManager.allRules.isEmpty)
        try! userRuleManager.add(
            rules: [
                UserRule(ruleText: "rule1", isEnabled: true),
                UserRule(ruleText: "rule2", isEnabled: false),
                UserRule(ruleText: "rule3", isEnabled: true)
            ],
            override: true
        )
        XCTAssertEqual(userRuleManager.allRules.count, 3)

        userRuleManager.set(rules: ["rule11", "rule21", "rulerule"])
        XCTAssertEqual(userRuleManager.allRules.count, 3)
        XCTAssertEqual(userRuleManager.allRules[0], UserRule(ruleText: "rule11", isEnabled: true))
        XCTAssertEqual(userRuleManager.allRules[1], UserRule(ruleText: "rule21", isEnabled: true))
        XCTAssertEqual(userRuleManager.allRules[2], UserRule(ruleText: "rulerule", isEnabled: true))
        userRuleManager.removeAllRules()

        // Test 5
        XCTAssert(userRuleManager.allRules.isEmpty)
        try! userRuleManager.add(
            rules: [
                UserRule(ruleText: "rule1", isEnabled: true),
                UserRule(ruleText: "rule2", isEnabled: false),
                UserRule(ruleText: "rule3", isEnabled: true)
            ],
            override: true
        )
        XCTAssertEqual(userRuleManager.allRules.count, 3)

        userRuleManager.set(rules: ["rule1", "", "rule2", "     ", "rule3", "  "])
        XCTAssertEqual(userRuleManager.allRules.count, 3)
        XCTAssertEqual(userRuleManager.allRules[0], UserRule(ruleText: "rule1", isEnabled: true))
        XCTAssertEqual(userRuleManager.allRules[1], UserRule(ruleText: "rule2", isEnabled: false))
        XCTAssertEqual(userRuleManager.allRules[2], UserRule(ruleText: "rule3", isEnabled: true))
        userRuleManager.removeAllRules()
    }

    private func testModifyRule(userRuleManager: UserRulesManagerProtocol) throws {
        XCTAssert(userRuleManager.allRules.isEmpty)
        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        try userRuleManager.modifyRule("foo5", UserRule(ruleText: "bar1", isEnabled: true))
        XCTAssertNotNil(userRuleManager.allRules.first { $0.ruleText == "bar1" })
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        //Throws error if bar1 exists
        XCTAssertThrowsError(try userRuleManager.modifyRule("foo999", UserRule(ruleText: "bar1", isEnabled: true)))

        //Throws error if foo999 doesn't exist
        XCTAssertThrowsError(try userRuleManager.modifyRule("foo999", UserRule(ruleText: "bar2", isEnabled: true)))

        //Throws error if foo2 exists
        XCTAssertThrowsError(try userRuleManager.modifyRule("foo1", UserRule(ruleText: "foo2", isEnabled: true)))

        userRuleManager.removeAllRules()
    }

    private func testRemoveRules(userRuleManager: UserRulesManagerProtocol) throws {

        XCTAssert(userRuleManager.allRules.isEmpty)
        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        try userRuleManager.removeRule(withText: "foo1")
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count - 1)

        XCTAssertThrowsError(try userRuleManager.removeRule(withText: "foo999"))

        userRuleManager.removeAllRules()
    }


    private func testRemoveAllRules(userRuleManager: UserRulesManagerProtocol) throws {

        XCTAssert(userRuleManager.allRules.isEmpty)
        userRuleManager.removeAllRules()
        XCTAssert(userRuleManager.allRules.isEmpty)

        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        userRuleManager.removeAllRules()
        XCTAssert(userRuleManager.allRules.isEmpty)
    }

    private func testThreadSafty(userRuleManager: UserRulesManagerProtocol) {
        let rule1 = UserRule(ruleText: "111", isEnabled: true)
        let rule2 = UserRule(ruleText: "222", isEnabled: true)

        let thread1 = Thread {
            do {
                try userRuleManager.add(rule: UserRule(ruleText: "1", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "2", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "3", isEnabled: true), override: true)

                try userRuleManager.removeRule(withText: "2")
                try userRuleManager.add(rule: UserRule(ruleText: "2", isEnabled: true), override: true)
            } catch {}
        }

        let thread2 = Thread {
            do {
                try userRuleManager.add(rule: UserRule(ruleText: "4", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "5", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "6", isEnabled: true), override: true)
                try userRuleManager.modifyRule("3", rule1)
                try userRuleManager.removeRule(withText: "2")
            } catch {}
        }

        let thread3 = Thread {
            do {
                try userRuleManager.add(rule: UserRule(ruleText: "7", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "8", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "9", isEnabled: true), override: true)
                try userRuleManager.modifyRule("1", rule2)
                try userRuleManager.removeRule(withText: "4")
            } catch {}
        }

        thread1.start()
        thread2.start()
        thread3.start()

        sleep(1)
    }

    private func testReset(userRuleManager: UserRulesManagerProtocol) throws {
        XCTAssert(userRuleManager.allRules.isEmpty)
        userRuleManager.removeAllRules()
        XCTAssert(userRuleManager.allRules.isEmpty)

        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)

        try userRuleManager.reset()
        XCTAssert(userRuleManager.allRules.isEmpty)
    }
}
