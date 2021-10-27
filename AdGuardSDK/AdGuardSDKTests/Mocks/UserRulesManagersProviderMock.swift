import Foundation

final class SafariUserRulesManagersProviderMock: SafariUserRulesManagersProviderProtocol {
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

    var type: SafariUserRuleType { .blocklist }

    var rulesString: String = ""

    var allRules: [UserRule] = []

    var addRuleCalledCount = 0
    var addRuleError: Error?
    func add(rule: UserRule, override: Bool) throws {
        addRuleCalledCount += 1
        if let error = addRuleError {
            throw error
        }
    }

    var addRulesCalledCount = 0
    var addRulesError: Error?
    func add(rules: [UserRule], override: Bool) throws {
        addRulesCalledCount += 1
        if let error = addRulesError {
            throw error
        }
    }

    var setRulesCalledCount = 0
    func set(rules: [String]) {
        setRulesCalledCount += 1
    }

    var modifyRuleCalledCount = 0
    var modifyRuleError: Error?
    func modifyRule(_ oldRuleText: String, _ newRule: UserRule) throws {
        modifyRuleCalledCount += 1
        if let error = modifyRuleError {
            throw error
        }
    }

    var removeRuleCalledCount = 0
    var removeRuleError: Error?
    var invokedRemoveRuleParameters: [String] = []
    func removeRule(withText ruleText: String) throws {
        removeRuleCalledCount += 1
        invokedRemoveRuleParameters.append(ruleText)
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

    func checkEnabledRuleExists(_ ruleText: String) -> Bool {
        return false
    }
}

final class BlocklistRulesManagerMock: UserRulesManagerMock {
    override var type: SafariUserRuleType { .blocklist }
}
final class AllowlistRulesManagerMock: UserRulesManagerMock {
    override var type: SafariUserRuleType { .allowlist }
}
final class InvertedAllowlistRulesManagerMock: UserRulesManagerMock {
    override var type: SafariUserRuleType { .invertedAllowlist }
}
