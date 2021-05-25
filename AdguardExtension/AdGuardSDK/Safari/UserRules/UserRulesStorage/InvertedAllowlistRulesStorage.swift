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
 This class manages inverted allowlist rules
 It uses allowlist rules storage because rules are the same
 The class differs from AllowlistRulesStorage in the way we convert rules and create rules string representation
 */
final class InvertedAllowlistRulesStorage: UserRulesStorageProtocol {
    typealias Rule = UserRule<InvertedAllowlistRuleConverter>
    
    // MARK: - Public properties
    
    var rulesString: String {
        if allRulesAtomic.value.isEmpty {
            return "@@||*$document"
        } else {
            let rulePrefix = "@@||*$document,domain="
            let ruleFromRules = allRulesAtomic.value.map { $0.rule }.joined(separator: "|")
            return rulePrefix + ruleFromRules
        }
    }
    var allRules: [Rule] { allRulesAtomic.value }
    
    // MARK: - Private properties
    
    // Helper varible to make allRules thread safe
    private var allRulesAtomic: Atomic<[Rule]>
    
    private let allowlistRulesStorage: AllowlistRulesStorage
    
    // Used to quickly check domain uniqueness
    private var domainsSet: Atomic<Set<String>>
    
    // MARK: - Initialization
    
    init(allowlistRulesStorage: AllowlistRulesStorage) {
        self.allowlistRulesStorage = allowlistRulesStorage
        self.allRulesAtomic = Atomic(allowlistRulesStorage.allRules.map { Self.convertToInverted($0) })
        self.domainsSet = Atomic(Set(allRulesAtomic.value.map { $0.domain }))
    }
    
    // MARK: - Public methods
    
    func add(rule: Rule) throws {
        guard !domainsSet.value.contains(rule.domain) else {
            throw UserRulesStorageError.ruleAlreadyExists(ruleString: rule.domain)
        }
        
        allRulesAtomic.modify { $0.append(rule) }
        domainsSet.modify { $0.insert(rule.domain) }
        
        let allowlistRule = Self.convertToNormal(rule)
        try allowlistRulesStorage.add(rule: allowlistRule)
    }
    
    func add(rules: [Rule]) throws  {
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
        
        let allowlistRule = Self.convertToNormal(newRule)
        try allowlistRulesStorage.modifyRule(oldRuleDomain, allowlistRule)
    }
    
    func removeRule(withDomain domain: String) throws {
        guard let ruleIndex = allRules.firstIndex(where: { $0.domain == domain }) else {
            throw UserRulesStorageError.ruleDoesNotExist(ruleString: domain)
        }
        
        allRulesAtomic.modify { $0.remove(at: ruleIndex) }
        domainsSet.modify { $0.remove(domain) }
        
        try allowlistRulesStorage.removeRule(withDomain: domain)
    }
    
    // MARK: - Private methods
    
    // Converts allowlist rule to inverted allowlist rule
    private static func convertToInverted(_ allowlistRule: UserRule<AllowlistRuleConverter>) -> UserRule<InvertedAllowlistRuleConverter> {
        return UserRule<InvertedAllowlistRuleConverter>(domain: allowlistRule.domain, isEnabled: allowlistRule.isEnabled)
    }
    
    // Converts inverted allowlist rule to normal allowlist rule
    private static func convertToNormal(_ invertedRule: UserRule<InvertedAllowlistRuleConverter>) -> UserRule<AllowlistRuleConverter> {
        return UserRule<AllowlistRuleConverter>(domain: invertedRule.domain, isEnabled: invertedRule.isEnabled)
    }
}
