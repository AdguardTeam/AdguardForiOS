import XCTest

class UserRulesManagerTest: XCTestCase {
    
    var storage: UserDefaultsStorageProtocol = UserDefaultsStorage(storage: UserDefaults(suiteName: "UserRulesStorage")!)
    
    var allowlistRulesManager: UserRulesManager<AllowlistRulesStorage, AllowlistRuleConverter>?
    var invertedAllowlistRulesManager: UserRulesManager<InvertedAllowlistRulesStorage, InvertedAllowlistRuleConverter>?
    var blocklistRulesManager: UserRulesManager<BlocklistRulesStorage, BlocklistRuleConverter>?
    
    override func setUp() {
        allowlistRulesManager = UserRulesManager<AllowlistRulesStorage, AllowlistRuleConverter>(userDefaults: storage)
        allowlistRulesManager?.removeAllRules()
        
        invertedAllowlistRulesManager = UserRulesManager<InvertedAllowlistRulesStorage, InvertedAllowlistRuleConverter>(userDefaults: storage)
        invertedAllowlistRulesManager?.removeAllRules()
        
        blocklistRulesManager = UserRulesManager<BlocklistRulesStorage, BlocklistRuleConverter>(userDefaults: storage)
        blocklistRulesManager?.removeAllRules()
    }
    
    override func tearDown() {
        allowlistRulesManager = nil
        invertedAllowlistRulesManager = nil
        blocklistRulesManager = nil
    }
    
    let testRules = [UserRule(ruleText: "foo1"),
                     UserRule(ruleText: "foo2"),
                     UserRule(ruleText: "foo3"),
                     UserRule(ruleText: "foo4"),
                     UserRule(ruleText: "foo5"),
                     UserRule(ruleText: "foo6"),
                     UserRule(ruleText: "foo7"),
                     UserRule(ruleText: "foo8"),
                     UserRule(ruleText: "foo9"),
                     UserRule(ruleText: "foo10")]
    
    func testAllowlistRulesManager() {
        guard let allowlistRulesManager = allowlistRulesManager else { return XCTFail() }
        do {
            try testAddRule(userRuleManager: allowlistRulesManager)
            try testAddRules(userRuleManager: allowlistRulesManager)
            try testModifyRule(userRuleManager: allowlistRulesManager)
            try testRemoveRules(userRuleManager: allowlistRulesManager)
            try testRemoveAllRules(userRuleManager: allowlistRulesManager)
            testThreadSafty(userRuleManager: allowlistRulesManager)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testInvertedAllowlistRulesManager() {
        guard let invertedAllowlistRulesManager = invertedAllowlistRulesManager else { return XCTFail() }
        do {
            try testAddRule(userRuleManager: invertedAllowlistRulesManager)
            try testAddRules(userRuleManager: invertedAllowlistRulesManager)
            try testModifyRule(userRuleManager: invertedAllowlistRulesManager)
            try testRemoveRules(userRuleManager: invertedAllowlistRulesManager)
            try testRemoveAllRules(userRuleManager: invertedAllowlistRulesManager)
            testThreadSafty(userRuleManager: invertedAllowlistRulesManager)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testBlockinglistRulesManager() {
        guard let blocklistRulesManager = blocklistRulesManager else { return XCTFail() }
        do {
            try testAddRule(userRuleManager: blocklistRulesManager)
            try testAddRules(userRuleManager: blocklistRulesManager)
            try testModifyRule(userRuleManager: blocklistRulesManager)
            try testRemoveRules(userRuleManager: blocklistRulesManager)
            try testRemoveAllRules(userRuleManager: blocklistRulesManager)
            testThreadSafty(userRuleManager: blocklistRulesManager)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private func testAddRule<UserRulesStorageProtocol, UserRuleConverterProtocol>(userRuleManager: UserRulesManager<UserRulesStorageProtocol, UserRuleConverterProtocol>) throws {
        
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
    
    private func testAddRules<UserRulesStorageProtocol, UserRuleConverterProtocol>(userRuleManager: UserRulesManager<UserRulesStorageProtocol, UserRuleConverterProtocol>) throws {
        
        XCTAssert(userRuleManager.allRules.isEmpty)
        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)
        
        XCTAssertThrowsError(try userRuleManager.add(rules: testRules, override: false))
        XCTAssertFalse(userRuleManager.allRules.isEmpty)
        
        XCTAssertNoThrow(try userRuleManager.add(rules: testRules, override: true))
        XCTAssertFalse(userRuleManager.allRules.isEmpty)
        
        userRuleManager.removeAllRules()
    }
    
    private func testModifyRule<UserRulesStorageProtocol, UserRuleConverterProtocol>(userRuleManager: UserRulesManager<UserRulesStorageProtocol, UserRuleConverterProtocol>) throws {
        
        XCTAssert(userRuleManager.allRules.isEmpty)
        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)
        
        try userRuleManager.modifyRule("foo5", UserRule(ruleText: "bar1", isEnabled: true))
        XCTAssertNotNil(userRuleManager.allRules.first { $0.ruleText == "bar1" })
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)
        
        //Throws error if bar1 exists
        XCTAssertThrowsError(try userRuleManager.modifyRule("foo999", UserRule(ruleText: "bar1", isEnabled: true)))
        //Throws error if foo999 non exists
        XCTAssertThrowsError(try userRuleManager.modifyRule("foo999", UserRule(ruleText: "bar2", isEnabled: true)))
        
        userRuleManager.removeAllRules()
    }
    
    private func testRemoveRules<UserRulesStorageProtocol, UserRuleConverterProtocol>(userRuleManager: UserRulesManager<UserRulesStorageProtocol, UserRuleConverterProtocol>) throws {
        
        XCTAssert(userRuleManager.allRules.isEmpty)
        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)
        
        try userRuleManager.removeRule(withText: "foo1")
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count - 1)
        
        XCTAssertThrowsError(try userRuleManager.removeRule(withText: "foo999"))
        
        userRuleManager.removeAllRules()
    }
    
    
    private func testRemoveAllRules<UserRulesStorageProtocol, UserRuleConverterProtocol>(userRuleManager: UserRulesManager<UserRulesStorageProtocol, UserRuleConverterProtocol>) throws {
        
        XCTAssert(userRuleManager.allRules.isEmpty)
        userRuleManager.removeAllRules()
        XCTAssert(userRuleManager.allRules.isEmpty)
        
        try userRuleManager.add(rules: testRules, override: false)
        XCTAssertEqual(userRuleManager.allRules.count, testRules.count)
        
        userRuleManager.removeAllRules()
        XCTAssert(userRuleManager.allRules.isEmpty)
        
        userRuleManager.removeAllRules()
    }
    
    private func testThreadSafty<UserRulesStorageProtocol, UserRuleConverterProtocol>(userRuleManager: UserRulesManager<UserRulesStorageProtocol, UserRuleConverterProtocol>) {
        let rule1 = UserRule(ruleText: "111", isEnabled: true)
        let rule2 = UserRule(ruleText: "222", isEnabled: true)
        
        let thread1 = Thread {
            do {
                try userRuleManager.add(rule: UserRule(ruleText: "1", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "2", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "3", isEnabled: true), override: true)
                
                try userRuleManager.removeRule(withText: "2")
                try userRuleManager.add(rule: UserRule(ruleText: "2", isEnabled: true), override: true)
            } catch {
                XCTFail("\(error)")
            }
        }
        
        let thread2 = Thread {
            do {
                try userRuleManager.add(rule: UserRule(ruleText: "4", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "5", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "6", isEnabled: true), override: true)
                try userRuleManager.modifyRule("3", rule1)
                try userRuleManager.removeRule(withText: "2")
            } catch {
                XCTFail("\(error)")
            }
        }
        
        let thread3 = Thread {
            do {
                try userRuleManager.add(rule: UserRule(ruleText: "7", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "8", isEnabled: true), override: true)
                try userRuleManager.add(rule: UserRule(ruleText: "9", isEnabled: true), override: true)
                try userRuleManager.modifyRule("1", rule2)
                try userRuleManager.removeRule(withText: "4")
            } catch {
                XCTFail("\(error)")
            }
        }
        
        thread1.start()
        thread2.start()
        thread3.start()
        
        sleep(1)
    }
}
