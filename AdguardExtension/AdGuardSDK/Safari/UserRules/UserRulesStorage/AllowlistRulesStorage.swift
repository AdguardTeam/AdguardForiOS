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

final class AllowlistRulesStorage: UserRulesStorageProtocol {
    typealias Rule = UserRule<AllowlistRuleConverter>
    
    // MARK: - Public properties
    
    var rulesString: String { allRules.filter { $0.isEnabled }.map { $0.rule }.joined(separator: "/n") }
    var allRules: [Rule] { rulesCacheQueue.sync { _allRules } }
    
    // MARK: - Private properties
    
    // Helper varible to make allRules thread safe
    private var _allRules: [Rule]
    
    private let storage: UserDefaultsStorageProtocol
    // Queue for saving rules to storage
    private let storageSaveQueue = DispatchQueue(label: "AdGuardSDK.AllowlistRulesStorage.storageSaveQueue", qos: .background)
    // Queue for modifying and accessing rules to be sure in allRules thread safety
    private let rulesCacheQueue = DispatchQueue(label: "AdGuardSDK.AllowlistRulesStorage.storageSaveQueue", qos: .userInitiated)
    // Used to quickly check domain uniqueness
    private var domainsSet: Set<String>
    
    // MARK: - Initialization
    
    init(storage: UserDefaultsStorageProtocol) {
        self.storage = storage
        self._allRules = storage.allowlistRules
        self.domainsSet = Set(allRules.map { $0.domain })
    }
    
    deinit {
        storageSaveQueue.sync {
            // Flushing the queue
        }
    }
    
    // MARK: - Public methods
    
    func add(rule: Rule) throws {
        guard !domainsSet.contains(rule.domain) else {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: rule.domain)
        }
        
        rulesCacheQueue.sync {
            _allRules.append(rule)
            domainsSet.insert(rule.domain)
        }
        
        storageSaveQueue.async { [weak self] in
            self?.storage.allowlistRules.append(rule)
        }
    }
    
    func add(rules: [Rule]) throws {
        try rules.forEach { rule in
            if !domainsSet.contains(rule.domain) {
                try add(rule: rule)
            }
        }
    }
    
    func modifyRule(_ oldRuleDomain: String, _ newRule: Rule) throws {
        guard !domainsSet.contains(newRule.domain) else {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: newRule.domain)
        }
        guard let ruleIndex = allRules.firstIndex(where: { $0.domain == oldRuleDomain }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: oldRuleDomain)
        }
        
        allRules[ruleIndex] = newRule
        storageSaveQueue.async { [weak self] in
            self?.storage.allowlistRules[ruleIndex] = newRule
        }
    }
    
    func removeRule(withDomain domain: String) throws {
        guard let ruleIndex = allRules.firstIndex(where: { $0.domain == domain }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: domain)
        }
        allRules.remove(at: ruleIndex)
        storageSaveQueue.async { [weak self] in
            self?.storage.allowlistRules.remove(at: ruleIndex)
        }
    }
}

// MARK: - ResourcesProtocol + allowlist rules storage

fileprivate extension UserDefaultsStorageProtocol {
    
    private var allowlistRulesKey: String { "allowlistRulesKey" }
    
    var allowlistRules: [UserRule<AllowlistRuleConverter>] {
        get {
            if let savedRulesData = storage.data(forKey: allowlistRulesKey) {
                let decoder = JSONDecoder()
                let rules = try? decoder.decode([UserRule<AllowlistRuleConverter>].self, from: savedRulesData)
                return rules ?? []
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let rulesData = try? encoder.encode(newValue) {
                storage.set(rulesData, forKey: allowlistRulesKey)
            } else {
                storage.set(Date(), forKey: allowlistRulesKey)
            }
        }
    }
}
