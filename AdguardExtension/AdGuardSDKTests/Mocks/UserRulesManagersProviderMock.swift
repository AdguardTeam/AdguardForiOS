import Foundation

final class UserRulesManagersProviderMock: UserRulesManagersProviderProtocol {
    var blocklistRulesManager: UserRulesManagerProtocol = BlocklistRulesManagerMock()
    var allowlistRulesManager: UserRulesManagerProtocol = AllowlistRulesManagerMock()
    var invertedAllowlistRulesManager: UserRulesManagerProtocol = InvertedAllowlistRulesManagerMock()
}

final class BlocklistRulesManagerMock: UserRulesManagerProtocol {
    var rulesString: String = ""
    
    var allRules: [UserRuleProtocol] = []
    
    var addRuleCalled = false
    var addRuleError: Error?
    func add(rule: UserRuleProtocol, override: Bool) throws {
        addRuleCalled = true
        if let error = addRuleError {
            throw error
        }
    }
    
    var addRulesCalled = false
    var addRulesError: Error?
    func add(rules: [UserRuleProtocol], override: Bool) throws {
        addRulesCalled = true
        if let error = addRulesError {
            throw error
        }
    }
    
    var modifyRuleCalled = false
    var modifyRuleError: Error?
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol) throws {
        modifyRuleCalled = true
        if let error = modifyRuleError {
            throw error
        }
    }
    
    var removeRuleCalled = false
    var removeRuleError: Error?
    func removeRule(withText ruleText: String) throws {
        removeRuleCalled = true
        if let error = removeRuleError {
            throw error
        }
    }
    
    var removeAllRulesCalled = false
    func removeAllRules() {
        removeAllRulesCalled = true
    }
}

final class AllowlistRulesManagerMock: UserRulesManagerProtocol {
    var rulesString: String = ""
    
    var allRules: [UserRuleProtocol] = []
    
    var addRuleCalled = false
    var addRuleError: Error?
    func add(rule: UserRuleProtocol, override: Bool) throws {
        addRuleCalled = true
        if let error = addRuleError {
            throw error
        }
    }
    
    var addRulesCalled = false
    var addRulesError: Error?
    func add(rules: [UserRuleProtocol], override: Bool) throws {
        addRulesCalled = true
        if let error = addRulesError {
            throw error
        }
    }
    
    var modifyRuleCalled = false
    var modifyRuleError: Error?
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol) throws {
        modifyRuleCalled = true
        if let error = modifyRuleError {
            throw error
        }
    }
    
    var removeRuleCalled = false
    var removeRuleError: Error?
    func removeRule(withText ruleText: String) throws {
        removeRuleCalled = true
        if let error = removeRuleError {
            throw error
        }
    }
    
    var removeAllRulesCalled = false
    func removeAllRules() {
        removeAllRulesCalled = true
    }
}

final class InvertedAllowlistRulesManagerMock: UserRulesManagerProtocol {
    var rulesString: String = ""
    
    var allRules: [UserRuleProtocol] = []
    
    var addRuleCalled = false
    var addRuleError: Error?
    func add(rule: UserRuleProtocol, override: Bool) throws {
        addRuleCalled = true
        if let error = addRuleError {
            throw error
        }
    }
    
    var addRulesCalled = false
    var addRulesError: Error?
    func add(rules: [UserRuleProtocol], override: Bool) throws {
        addRulesCalled = true
        if let error = addRulesError {
            throw error
        }
    }
    
    var modifyRuleCalled = false
    var modifyRuleError: Error?
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol) throws {
        modifyRuleCalled = true
        if let error = modifyRuleError {
            throw error
        }
    }
    
    var removeRuleCalled = false
    var removeRuleError: Error?
    func removeRule(withText ruleText: String) throws {
        removeRuleCalled = true
        if let error = removeRuleError {
            throw error
        }
    }
    
    var removeAllRulesCalled = false
    func removeAllRules() {
        removeAllRulesCalled = true
    }
}
