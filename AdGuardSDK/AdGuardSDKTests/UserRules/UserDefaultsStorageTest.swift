import XCTest

class UserDefaultsStorageTest: XCTestCase {

    var userDefaults: UserDefaultsStorageProtocol!
    
    lazy var allowlistRuleStorage: UserRulesStorageProtocol = {
        SafariUserRulesStorage(userDefaults: userDefaults, rulesType: .allowlist)
    }()
        
    lazy var invertedAllowlistRulesStorage: UserRulesStorageProtocol = {
        SafariUserRulesStorage(userDefaults: userDefaults, rulesType: .invertedAllowlist)
    }()
    
    lazy var blocklistRulesStorage: UserRulesStorageProtocol  = {
        SafariUserRulesStorage(userDefaults: userDefaults, rulesType: .blocklist)
    }()
    
    let userRules = [UserRule(ruleText: "1", isEnabled: false),
                     UserRule(ruleText: "2", isEnabled: true),
                     UserRule(ruleText: "3", isEnabled: false)]
    
    override func setUpWithError() throws {
        userDefaults = UserDefaultsStorage(storage: UserDefaults(suiteName: "UserRulesStorage")!)
        allowlistRuleStorage.rules = []
        invertedAllowlistRulesStorage.rules = []
        blocklistRulesStorage.rules = []
    }

    func testAllowlistRuleStorageWithSuccess() {
        XCTAssert(allowlistRuleStorage.rules.isEmpty)
        allowlistRuleStorage.rules = userRules
        XCTAssertEqual(allowlistRuleStorage.rules.count, 3)
        for (index,rule) in allowlistRuleStorage.rules.enumerated() {
            XCTAssert(rule.ruleText == userRules[index].ruleText)
            XCTAssert(rule.isEnabled == userRules[index].isEnabled)
        }
    }
    
    func testResetAllowlistRuleStorage() {
        XCTAssert(allowlistRuleStorage.rules.isEmpty)
        allowlistRuleStorage.rules = userRules
        XCTAssertEqual(allowlistRuleStorage.rules.count, 3)
        allowlistRuleStorage.rules = []
        XCTAssert(allowlistRuleStorage.rules.isEmpty)
    }
    
    func testInvertedAllowlistRulesStorageWithSuccess() {
        XCTAssert(invertedAllowlistRulesStorage.rules.isEmpty)
        invertedAllowlistRulesStorage.rules = userRules
        XCTAssertEqual(invertedAllowlistRulesStorage.rules.count, 3)
        for (index,rule) in invertedAllowlistRulesStorage.rules.enumerated() {
            XCTAssert(rule.ruleText == userRules[index].ruleText)
            XCTAssert(rule.isEnabled == userRules[index].isEnabled)
        }
    }
    
    func testResetInvertedAllowlistRulesStorage() {
        XCTAssert(invertedAllowlistRulesStorage.rules.isEmpty)
        invertedAllowlistRulesStorage.rules = userRules
        XCTAssertEqual(invertedAllowlistRulesStorage.rules.count, 3)
        invertedAllowlistRulesStorage.rules = []
        XCTAssert(invertedAllowlistRulesStorage.rules.isEmpty)
    }
    
    func testBlocklistRulesStorageWithSuccess() {
        XCTAssert(blocklistRulesStorage.rules.isEmpty)
        blocklistRulesStorage.rules = userRules
        XCTAssertEqual(blocklistRulesStorage.rules.count, 3)
        for (index,rule) in blocklistRulesStorage.rules.enumerated() {
            XCTAssert(rule.ruleText == userRules[index].ruleText)
            XCTAssert(rule.isEnabled == userRules[index].isEnabled)
        }
    }
    
    func testResetBlocklistRulesStorage() {
        XCTAssert(blocklistRulesStorage.rules.isEmpty)
        blocklistRulesStorage.rules = userRules
        XCTAssertEqual(blocklistRulesStorage.rules.count, 3)
        blocklistRulesStorage.rules = []
        XCTAssert(blocklistRulesStorage.rules.isEmpty)
    }
}
