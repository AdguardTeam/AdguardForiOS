//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import OrderedCollections

/*
 This class is a generic user rules manager
 It can manage all types of user rules (allowlist / inverted allowlist / blocklist)
 To make it work you just need to pass appropriate storage and rules converter types
 */
public final class UserRulesManager: UserRulesManagerProtocol {

    // MARK: - Public properties

    public var rulesString: String {
        let enabledRules = allRules.filter { $0.isEnabled }
        return converter.convertRulesToString(enabledRules)
    }

    public var allRules: [UserRule] { storage.rules.elements }

    // MARK: - Private properties

    // Place where all rules are stored
    private let storage: UserRulesStorageProtocol

    // Rules converter Rule <-> Domain
    private let converter: UserRuleConverterProtocol

    // MARK: - Initialization

    public init(type: UserRuleType, storage: UserRulesStorageProtocol, converter: UserRuleConverterProtocol) {
        self.storage = storage
        self.converter = converter
    }

    // MARK: - Public methods

    public func add(rule: UserRule, override: Bool) throws {
        try internalAdd(rules: [rule], override: override)
    }

    public func add(rules: [UserRule], override: Bool) throws {
        let duplicates = rules.map { $0.ruleText }.duplicates
        if !override, !duplicates.isEmpty {
            throw UserRulesStorageError.attemptingToAddDuplicates(duplicatedRules: duplicates)
        }

        let rulesTextSet = Set(storage.rules.map { $0.ruleText })
        let existingRules = rulesTextSet.intersection(rules.map { $0.ruleText })

        if !existingRules.isEmpty && !override {
            throw UserRulesStorageError.rulesAlreadyExist(rulesStrings: Array(existingRules))
        }

        if existingRules.isEmpty && duplicates.isEmpty {
            storage.rules.append(contentsOf: rules)
        } else {
            try internalAdd(rules: rules, override: override)
        }
    }

    public func set(rules: [String]) {
        let uniqueRules = rules.uniqueElements
        let setOfRules = storage.rules
        
        let newRules: [UserRule] = uniqueRules.compactMap { ruleToAdd in
            let trimmedRule = ruleToAdd.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedRule.isEmpty {
                return nil
            }

            if let existingRule = setOfRules.first(where: { $0.ruleText == trimmedRule }) {
                return existingRule
            }
            return UserRule(ruleText: trimmedRule, isEnabled: true)
        }
        storage.rules = OrderedSet(newRules)
    }

    public func modifyRule(_ oldRuleText: String, _ newRule: UserRule) throws {
        // Check if modified rule is not already in the list
        if oldRuleText != newRule.ruleText, allRules.contains(where: { $0.ruleText == newRule.ruleText }) {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: newRule.ruleText)
        }

        // Check if rule that should be modified exist
        guard let ruleIndex = allRules.firstIndex(where: { $0.ruleText == oldRuleText }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: oldRuleText)
        }

        // Check if rule that should be modified is really changing
        guard storage.rules[ruleIndex].ruleText != newRule.ruleText || storage.rules[ruleIndex].isEnabled != newRule.isEnabled else {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: newRule.ruleText)
        }

        storage.rules.remove(at: ruleIndex)
        storage.rules.insert(newRule, at: ruleIndex)
    }

    public func removeRule(withText ruleText: String) throws {
        guard let ruleIndex = storage.rules.firstIndex(where: { $0.ruleText == ruleText }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: ruleText)
        }
        storage.rules.remove(at: ruleIndex)
    }

    public func removeAllRules() {
        storage.rules.removeAll()
    }

    public func checkEnabledRuleExists(_ ruleText: String) -> Bool {
        // Create a hashable UserRule object so that we could quickly check
        // if the the rules set contains it or not.
        let ruleToCheck = UserRule(ruleText: ruleText, isEnabled: true)
        return storage.rules.contains(ruleToCheck)
    }

    public func reset() throws {
        removeAllRules()
    }

    // This func us used to prevent deadlock in queue. Call it in rulesModificationQueue sync
    private func internalAdd(rules: [UserRule], override: Bool) throws {
        var setOfRules = storage.rules
        try rules.forEach { rule in
            let ruleIndex = setOfRules.firstIndex(where: { $0.ruleText == rule.ruleText} )
            if ruleIndex != nil, !override {
                throw UserRulesStorageError.ruleAlreadyExists(ruleString: rule.ruleText)
            }

            if let ruleIndex = ruleIndex {
                setOfRules.remove(at: ruleIndex)
                setOfRules.insert(rule, at: ruleIndex)
            } else {
                setOfRules.append(rule)
            }
        }

        storage.rules = setOfRules
    }
}
