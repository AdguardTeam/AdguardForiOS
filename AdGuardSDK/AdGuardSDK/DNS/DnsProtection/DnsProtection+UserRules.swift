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

//TODO: Need tests
public protocol DnsProtectionUserRulesManagerProtocol {

    /**
     Returns String representation of all enabled rules for specified rules type
     - Parameter type: User rule type (blocklist / allowlist)
     - Returns: String representation of all enabled rules
     */

    func rulesString(for type: DnsUserRuleType) -> String

    /**
     Returns all User rules objects for specified rules type
     - Parameter type: User rule type (blocklist / allowlist)
     - Returns: Array of user rules objects
     */
    func allRules(for type: DnsUserRuleType) -> [UserRule]

    /**
     Adds new rule to the user rule's list
     - Parameter rule: Rule object to add to storage
     - Parameter override: If **true** and **rule** is already in the user rule's list than it will be overriden with new one
     - Parameter type: User rule type (blocklist / allowlist)

     - Throws: **UserRulesStorageError.ruleAlreadyExists**
     if **override** is false and **allRules** already contains **rule**
     */
    func add(rule: UserRule, override: Bool, for type: DnsUserRuleType) throws

    /**
     Adds new rules to the user rule's list
     - Parameter rules: Rules object to add to storage
     - Parameter override: If **true**, duplicated rules will be overriden with new ones
     - Parameter type: User rule type (blocklist / allowlist)

     - Throws: **UserRulesStorageError.rulesAlreadyExist**
     if **override** is false and **allRules** already contains some rules from **rules**
     */
    func add(rules: [UserRule], override: Bool, for type: DnsUserRuleType) throws

    /**
     Modifies rule in the user rule's list
     - Parameter oldRuleText: Old rule text
     - Parameter newRuleText: New rule text
     - Parameter type: User rule type (blocklist / allowlist)

     - Throws: **UserRulesStorageError.rulesAlreadyExist**
     if **newRule** is already exists
     - Throws: **UserRulesStorageError.ruleDoesNotExist**
     if **oldRuleText** not contains in rules storage
     */
    func modifyRule(_ oldRuleText: String, _ newRule: UserRule, for type: DnsUserRuleType) throws

    /**
     Enables or disables passed rules
     - Parameter rules: Rules that should change their state
     - Parameter on: New state of rules
     - Parameter type: User rule type (blocklist / allowlist) to modify rule for
     */
    // TODO: - Tests missing
    func turnRules(_ rules: [String], on: Bool, for type: DnsUserRuleType)

    /**
     Removes rule from the user rule's list
     - Parameter ruleText: Rule text
     - Parameter type: User rule type (blocklist / allowlist)

     - Throws: **UserRulesStorageError.ruleDoesNotExist**
     if **ruleText** not contains in rules storage
     */
    func removeRule(withText ruleText: String, for type: DnsUserRuleType) throws

    /**
     Removes rule from the user rule's list
     - Parameter rules: Rules that should be removed
     - Parameter type: User rule type (blocklist / allowlist)
     */
    func removeRules(_ rules: [String], for type: DnsUserRuleType)

    /**
     Remove all rules from storage
     - Parameter type: User rule type (blocklist / allowlist)
     */
    func removeAllRules(for type: DnsUserRuleType)

    /** check that user filter contains the rule
     - Parameter rule: user rule to check
     - Parameter type: User rule type (blocklist / allowlist)
     - Returns: check result
     */
    func checkRuleExists(_ rule: String, for type: DnsUserRuleType)->Bool

    /** removes all rules that matches given domain
     - Parameter domain: domain
     - Parameter type: User rule type (blocklist / allowlist)
     */
    func removeAllRulesMatchesDomain(_ domain: String, type: DnsUserRuleType)
}

extension DnsProtection {
    public func rulesString(for type: DnsUserRuleType) -> String {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - rulesString; Returning rules string for type=\(type)")
            let manager = getManager(for: type)
            return manager.rulesString
        }
    }

    public func allRules(for type: DnsUserRuleType) -> [UserRule] {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - allRules; Returning all rules for type=\(type)")
            let manager = getManager(for: type)
            return manager.allRules
        }
    }

    public func add(rule: UserRule, override: Bool, for type: DnsUserRuleType) throws {
        try workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - addRule; Adding rule: \(rule); for type=\(type); override=\(override)")
            let manager = getManager(for: type)
            try manager.add(rule: rule, override: override)
        }
    }

    public func add(rules: [UserRule], override: Bool, for type: DnsUserRuleType) throws {
        try workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - addRules; Adding \(rules.count) rules; for type=\(type); override=\(override)")
            let manager = getManager(for: type)
            try manager.add(rules: rules, override: override)
        }
    }

    public func modifyRule(_ oldRuleText: String, _ newRule: UserRule, for type: DnsUserRuleType) throws {
        try workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - modifyRule; Modifying old rule=\(oldRuleText) to new rule=\(newRule)")
            let manager = getManager(for: type)
            try manager.modifyRule(oldRuleText, newRule)
        }
    }

    public func turnRules(_ rules: [String], on: Bool, for type: DnsUserRuleType) {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - turnRules; Turning \(rules.count) rules on=\(on) for type=\(type)")
            let manager = getManager(for: type)
            rules.forEach {
                try? manager.modifyRule($0, UserRule(ruleText: $0, isEnabled: on))
            }
        }
    }

    public func removeRule(withText ruleText: String, for type: DnsUserRuleType) throws {
        try workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - removeRule; Removing rule=\(ruleText) for type=\(type)")
            let manager = getManager(for: type)
            try manager.removeRule(withText: ruleText)
        }
    }

    public func removeRules(_ rules: [String], for type: DnsUserRuleType) {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - removeRules; Removing \(rules.count) rules for type=\(type)")
            let manager = getManager(for: type)
            rules.forEach {
                try? manager.removeRule(withText: $0)
            }
        }
    }

    public func removeAllRules(for type: DnsUserRuleType) {
        workingQueue.sync {
            Logger.logInfo("(DnsProtection+UserRules) - removeAllRules; Removing all rules for type=\(type)")
            let manager = getManager(for: type)
            manager.removeAllRules()
        }
    }

    public func checkRuleExists(_ rule: String, for type: DnsUserRuleType)->Bool {
        workingQueue.sync {
            let manager = getManager(for: type)
            return manager.checkRuleExists(rule)
        }
    }

    public func removeAllRulesMatchesDomain(_ domain: String, type: DnsUserRuleType) {
        workingQueue.sync {
            let manager = getManager(for: type)
            let rules = rulesForDomain(domain, type: type)
            rules.forEach {
                try? manager.removeRule(withText: $0)
            }
        }
    }

    private func getManager(for type: DnsUserRuleType) -> UserRulesManagerProtocol {
        switch type {
        case .blocklist: return dnsUserRulesManagerProvider.blocklistRulesManager
        case .allowlist: return dnsUserRulesManagerProvider.allowlistRulesManager
        }
    }

    private func rulesForDomain(_ domain: String, type: DnsUserRuleType)->[String] {
        let domains = allDomainsFromDomain(domain)
        switch type {
        case .blocklist:
            return blockRulesForDomains(domains)
        case .allowlist:
            return allowRulesForDomains(domains)
        }
    }

    private func allDomainsFromDomain(_ domain: String)->[String] {
        return []
    }

    private func blockRulesForDomains(_ domains: [String])->[String]{
        return []
    }

    private func allowRulesForDomains(_ domains: [String])->[String] {
        return []
    }
}
