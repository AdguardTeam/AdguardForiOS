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

/*
 This class is a generic user rules manager
 It can manage all types of user rules (allowlist / inverted allowlist / blocklist)
 To make it work you just need to pass appropriate storage and rules converter types
 */
final class UserRulesManager: UserRulesManagerProtocol {
    
    // MARK: - Public properties
    
    // TODO: - Check if it is not useless
    var rulesString: String {
        rulesModificationQueue.sync {
            let enabledRules = _allRules.filter { $0.isEnabled }
            return converter.convertRulesToString(enabledRules)
        }
    }
    
    var allRules: [UserRuleProtocol] { rulesModificationQueue.sync { _allRules } }
    
    // MARK: - Private properties
    
    // Serial queue to manage rules in one and only thread. This queue guarantees thread safety.
    private let rulesModificationQueue = DispatchQueue(label: "AdGuardSDK.RulesManager.rulesModificationQueue", qos: .userInitiated)
    
    private var _allRules: [UserRuleProtocol]
    
    // Used to quickly check domain uniqueness
    private var domainsSet: Set<String>
    
    // Place where all rules are stored
    private let storage: UserRulesStorageProtocol
    
    // Rules converter Rule <-> Domain
    private let converter: UserRuleConverterProtocol
    
    // MARK: - Initialization
    
    init(storage: UserRulesStorageProtocol, converter: UserRuleConverterProtocol) {
        self.storage = storage
        self.converter = converter
        self._allRules = storage.rules
        self.domainsSet = Set(_allRules.map { $0.ruleText })
    }
    
    // MARK: - Public methods
    
    func add(rule: UserRuleProtocol, override: Bool) throws {
        try rulesModificationQueue.sync { [weak self] in
            try self?.internalAdd(rule: rule, override: override)
        }
    }
    
    func add(rules: [UserRuleProtocol], override: Bool) throws {
        try rulesModificationQueue.sync {
            let existingRules = domainsSet.intersection(rules.map { $0.ruleText })
            
            if !existingRules.isEmpty && !override {
                throw UserRulesStorageError.rulesAlreadyExist(rulesStrings: Array(existingRules))
            }
            
            if existingRules.isEmpty {
                _allRules.append(contentsOf: rules)
                domainsSet = Set<String>(rules.map { $0.ruleText })
                self.storage.rules.append(contentsOf: rules)
            } else {
                try rules.forEach {
                    try internalAdd(rule: $0, override: override)
                }
            }
        }
    }
    
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol) throws {
        try rulesModificationQueue.sync {
            guard let ruleIndex = _allRules.firstIndex(where: { $0.ruleText == oldRuleText }) else {
                throw UserRulesStorageError.ruleDoesNotExist(ruleString: oldRuleText)
            }
            
            guard _allRules[ruleIndex].ruleText != newRule.ruleText || _allRules[ruleIndex].isEnabled != newRule.isEnabled else {
                throw UserRulesStorageError.ruleAlreadyExists(ruleString: newRule.ruleText)
            }
            
            if _allRules[ruleIndex].ruleText != newRule.ruleText {
                domainsSet.remove(oldRuleText)
                domainsSet.insert(newRule.ruleText)
            }
            
            _allRules[ruleIndex] = newRule
            storage.rules[ruleIndex] = newRule
        }
    }
    
    func removeRule(withText ruleText: String) throws {
        try rulesModificationQueue.sync {
            guard let ruleIndex = _allRules.firstIndex(where: { $0.ruleText == ruleText }) else {
                throw UserRulesStorageError.ruleDoesNotExist(ruleString: ruleText)
            }
            
            _allRules.remove(at: ruleIndex)
            domainsSet.remove(ruleText)
            storage.rules.remove(at: ruleIndex)
        }
    }
    
    func removeAllRules() {
        rulesModificationQueue.sync {
            _allRules.removeAll()
            domainsSet.removeAll()
            storage.rules.removeAll()
        }
    }
    
    func reset() throws {
        removeAllRules()
    }
    
    // This func us used to prevent deadlock in queue. Call it in rulesModificationQueue sync
    private func internalAdd(rule: UserRuleProtocol, override: Bool) throws {
        let ruleExists = domainsSet.contains(rule.ruleText)
        if ruleExists && !override {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: rule.ruleText)
        }
        
        if ruleExists {
            let ruleIndex = _allRules.firstIndex(where: { $0.ruleText == rule.ruleText })!
            _allRules[ruleIndex] = rule
            self.storage.rules[ruleIndex] = rule
        } else {
            _allRules.append(rule)
            domainsSet.insert(rule.ruleText)
            self.storage.rules.append(rule)
        }
    }
}
