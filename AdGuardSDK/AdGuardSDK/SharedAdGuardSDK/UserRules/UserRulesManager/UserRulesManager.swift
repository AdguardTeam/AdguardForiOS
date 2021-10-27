/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.

       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.

       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.

       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

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
        try internalAdd(rule: rule, override: override)
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
            try rules.forEach {
                try internalAdd(rule: $0, override: override)
            }
        }
    }

    public func set(rules: [String]) {
        let uniqueRules = rules.uniqueElements
        
        let newRules: [UserRule] = uniqueRules.compactMap { ruleToAdd in
            let trimmedRule = ruleToAdd.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedRule.isEmpty {
                return nil
            }

            if let existingRule = storage.rules.first(where: { $0.ruleText == trimmedRule }) {
                return existingRule
            }
            return UserRule(ruleText: trimmedRule, isEnabled: true)
        }
        storage.rules = OrderedSet(newRules)
    }

    public func modifyRule(_ oldRuleText: String, _ newRule: UserRule) throws {
        guard let ruleIndex = allRules.firstIndex(where: { $0.ruleText == oldRuleText }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: oldRuleText)
        }

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
        return storage.rules.contains { rule in
            rule.ruleText == ruleText && rule.isEnabled
        }
    }

    public func reset() throws {
        removeAllRules()
    }

    // This func us used to prevent deadlock in queue. Call it in rulesModificationQueue sync
    private func internalAdd(rule: UserRule, override: Bool) throws {
        let ruleIndex = storage.rules.firstIndex(where: { $0.ruleText == rule.ruleText })
        if ruleIndex != nil, !override {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: rule.ruleText)
        }

        if let ruleIndex = ruleIndex {
            storage.rules.remove(at: ruleIndex)
            storage.rules.insert(rule, at: ruleIndex)
        } else {
            storage.rules.append(rule)
        }
    }
}
