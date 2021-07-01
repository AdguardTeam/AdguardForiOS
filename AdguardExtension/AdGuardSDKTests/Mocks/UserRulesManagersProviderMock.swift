import Foundation

final class UserRulesManagersProviderMock: UserRulesManagersProviderProtocol {
    lazy var blocklistRulesManager: UserRulesManagerProtocol = { blocklistRulesManagerMock }()
    lazy var allowlistRulesManager: UserRulesManagerProtocol = { allowlistRulesManagerMock }()
    lazy var invertedAllowlistRulesManager: UserRulesManagerProtocol = { invertedAllowlistRulesManagerMock }()
    
    let blocklistRulesManagerMock = BlocklistRulesManagerMock()
    let allowlistRulesManagerMock = AllowlistRulesManagerMock()
    let invertedAllowlistRulesManagerMock = InvertedAllowlistRulesManagerMock()
    
    var resetCalledCount = 0
    var resetError: Error?
    func reset() throws {
        resetCalledCount += 1
        if let error = resetError {
            throw error
        }
    }
}

class UserRulesManagerMock: UserRulesManagerProtocol {

    var type: UserRuleType { .blocklist }
    
    var rulesString: String = ""
    
    var allRules: [UserRuleProtocol] = []
    
    var addRuleCalledCount = 0
    var addRuleError: Error?
    func add(rule: UserRuleProtocol, override: Bool) throws {
        addRuleCalledCount += 1
        if let error = addRuleError {
            throw error
        }
    }
    
    var addRulesCalledCount = 0
    var addRulesError: Error?
    func add(rules: [UserRuleProtocol], override: Bool) throws {
        addRulesCalledCount += 1
        if let error = addRulesError {
            throw error
        }
    }
    
    var modifyRuleCalledCount = 0
    var modifyRuleError: Error?
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol) throws {
        modifyRuleCalledCount += 1
        if let error = modifyRuleError {
            throw error
        }
    }
    
    var removeRuleCalledCount = 0
    var removeRuleError: Error?
    func removeRule(withText ruleText: String) throws {
        removeRuleCalledCount += 1
        if let error = removeRuleError {
            throw error
        }
    }
    
    var removeAllRulesCalledCount = 0
    func removeAllRules() {
        removeAllRulesCalledCount += 1
    }
    
    func reset() throws {
        
    }
}

final class BlocklistRulesManagerMock: UserRulesManagerMock {
    override var type: UserRuleType { .blocklist }
}
final class AllowlistRulesManagerMock: UserRulesManagerMock {
    override var type: UserRuleType { .allowlist }
}
final class InvertedAllowlistRulesManagerMock: UserRulesManagerMock {
    override var type: UserRuleType { .invertedAllowlist }
}
