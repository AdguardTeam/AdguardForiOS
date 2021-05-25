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
    
    var rulesString: String { allRulesAtomic.value.filter { $0.isEnabled }.map { $0.rule }.joined(separator: "/n") }
    var allRules: [Rule] { allRulesAtomic.value }
    
    // MARK: - Private properties
    
    // Helper varible to make allRules thread safe
    private var allRulesAtomic: Atomic<[Rule]>
    
    // UserDefaults storage
    private let storage: UserDefaultsStorageProtocol
    
    // Queue for saving rules to storage
    private let storageSaveQueue = DispatchQueue(label: "AdGuardSDK.AllowlistRulesStorage.storageSaveQueue", qos: .background)
    
    // Used to quickly check domain uniqueness
    private var domainsSet: Atomic<Set<String>>
    
    // MARK: - Initialization
    
    init(storage: UserDefaultsStorageProtocol) {
        self.storage = storage
        self.allRulesAtomic = Atomic(storage.allowlistRules)
        self.domainsSet = Atomic(Set(allRulesAtomic.value.map { $0.domain }))
    }
    
    deinit {
        storageSaveQueue.sync {
            // Flushing the queue
        }
    }
    
    // MARK: - Public methods
    
    func add(rule: Rule) throws {
        guard !domainsSet.value.contains(rule.domain) else {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: rule.domain)
        }
        
        allRulesAtomic.modify { $0.append(rule) }
        domainsSet.modify { $0.insert(rule.domain) }
        
        storageSaveQueue.async { [weak self] in
            self?.storage.allowlistRules.append(rule)
        }
    }
    
    func add(rules: [Rule]) throws {
        try rules.forEach { rule in
            if !domainsSet.value.contains(rule.domain) {
                try add(rule: rule)
            }
        }
    }
    
    func modifyRule(_ oldRuleDomain: String, _ newRule: Rule) throws {
        guard !domainsSet.value.contains(newRule.domain) else {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: newRule.domain)
        }
        guard let ruleIndex = allRulesAtomic.value.firstIndex(where: { $0.domain == oldRuleDomain }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: oldRuleDomain)
        }
        
        allRulesAtomic.modify { $0[ruleIndex] = newRule }
        domainsSet.modify {
            $0.remove(oldRuleDomain)
            $0.insert(newRule.domain)
        }
        
        storageSaveQueue.async { [weak self] in
            self?.storage.allowlistRules[ruleIndex] = newRule
        }
    }
    
    func removeRule(withDomain domain: String) throws {
        guard let ruleIndex = allRules.firstIndex(where: { $0.domain == domain }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: domain)
        }
        
        allRulesAtomic.modify { $0.remove(at: ruleIndex) }
        domainsSet.modify { $0.remove(domain) }
        
        storageSaveQueue.async { [weak self] in
            self?.storage.allowlistRules.remove(at: ruleIndex)
        }
    }
}

// MARK: - ResourcesProtocol + allowlist rules storage

extension UserDefaultsStorageProtocol {
    
    private var allowlistRulesKey: String { "AdGuardSDK.allowlistRulesKey" }
    
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
