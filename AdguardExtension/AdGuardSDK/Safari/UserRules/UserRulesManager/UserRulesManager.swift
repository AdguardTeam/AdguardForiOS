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
final class UserRulesManager<Storage: UserRulesStorageProtocol, Converter: UserRuleConverterProtocol>: UserRulesManagerProtocol {
    
    // MARK: - Public properties
    
    // TODO: - Check if it is not useless
    var rulesString: String {
        rulesModificationQueue.sync {
            let enabledRules = allRulesAtomic.filter { $0.isEnabled }
            return Converter.convertRulesToString(enabledRules)
        }
    }
    
    var allRules: [UserRuleProtocol] { rulesModificationQueue.sync { allRulesAtomic } }
    
    // MARK: - Private properties
    
    // Serial queue to save rules to user defaults on background thread
    private let rulesSavingToStorageQueue = DispatchQueue(label: "AdGuardSDK.RulesManager.rulesSavingToStorageQueue", qos: .background)
    
    // Serial queue to manage rules in one and only thread. This queue guarantees thread safety.
    private let rulesModificationQueue = DispatchQueue(label: "AdGuardSDK.RulesManager.rulesSavingToStorageQueue", qos: .userInitiated)
    
    // Helper varible to make allRules thread safe
    private var allRulesAtomic: [UserRuleProtocol]
    
    // Used to quickly check domain uniqueness
    private var domainsSet: Set<String>
    
    // Place where all rules are stored
    private let storage: Storage
    
    // MARK: - Initialization
    
    init(userDefaults: UserDefaultsStorageProtocol) {
        self.storage = Storage(userDefaults: userDefaults)
        self.allRulesAtomic = storage.rules
        self.domainsSet = Set(allRulesAtomic.map { $0.ruleText })
    }
    
    deinit {
        rulesSavingToStorageQueue.sync {
            // Flushing the queue
        }
    }
    
    // MARK: - Public methods
    
    func add(rule: UserRuleProtocol, override: Bool) throws {
        try rulesModificationQueue.sync {
            
            let ruleExists = domainsSet.contains(rule.ruleText)
            if ruleExists && !override {
                throw UserRulesStorageError.ruleAlreadyExists(ruleString: rule.ruleText)
            }
            
            if ruleExists {
                let ruleIndex = allRulesAtomic.firstIndex(where: { $0.ruleText == rule.ruleText })!
                allRulesAtomic[ruleIndex] = rule
                
                rulesSavingToStorageQueue.async { [weak self] in
                    self?.storage.rules[ruleIndex] = rule
                }
            } else {
                allRulesAtomic.append(rule)
                domainsSet.insert(rule.ruleText)
                
                rulesSavingToStorageQueue.async { [weak self] in
                    self?.storage.rules.append(rule)
                }
            }
        }
    }
    
    func add(rules: [UserRuleProtocol], override: Bool) throws {
        try rulesModificationQueue.sync {
            let existingRules = domainsSet.intersection(rules.map { $0.ruleText })
            
            if !existingRules.isEmpty && !override {
                throw UserRulesStorageError.rulesAlreadyExist(rulesStrings: Array(existingRules))
            }
            
            if existingRules.isEmpty {
                allRulesAtomic.append(contentsOf: rules)
                
                rulesSavingToStorageQueue.async { [weak self] in
                    self?.storage.rules.append(contentsOf: rules)
                }
            } else {
                try rules.forEach {
                    try add(rule: $0, override: override)
                }
            }
        }
    }
    
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol) throws {
        try rulesModificationQueue.sync {
            guard let ruleIndex = allRulesAtomic.firstIndex(where: { $0.ruleText == oldRuleText }) else {
                throw UserRulesStorageError.ruleDoesNotExist(ruleString: oldRuleText)
            }
            
            guard allRulesAtomic[ruleIndex].ruleText != newRule.ruleText || allRulesAtomic[ruleIndex].isEnabled != newRule.isEnabled else {
                throw UserRulesStorageError.ruleAlreadyExists(ruleString: newRule.ruleText)
            }
            
            if allRulesAtomic[ruleIndex].ruleText != newRule.ruleText {
                domainsSet.remove(oldRuleText)
                domainsSet.insert(newRule.ruleText)
            }
            
            allRulesAtomic[ruleIndex] = newRule
            rulesSavingToStorageQueue.async { [weak self] in
                self?.storage.rules[ruleIndex] = newRule
            }
        }
    }
    
    func removeRule(withText ruleText: String) throws {
        try rulesModificationQueue.sync {
            guard let ruleIndex = allRules.firstIndex(where: { $0.ruleText == ruleText }) else {
                throw UserRulesStorageError.ruleDoesNotExist(ruleString: ruleText)
            }
            
            allRulesAtomic.remove(at: ruleIndex)
            domainsSet.remove(ruleText)
            
            rulesSavingToStorageQueue.async { [weak self] in
                self?.storage.rules.remove(at: ruleIndex)
            }
        }
    }
}
