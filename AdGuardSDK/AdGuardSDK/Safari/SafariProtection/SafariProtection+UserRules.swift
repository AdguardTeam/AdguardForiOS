///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import SharedAdGuardSDK
import class ContentBlockerConverter.WebExtensionHelpers

public protocol SafariProtectionUserRulesProtocol {
    /**
     Returns String representation of all enabled rules for specified rules type
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist)
     - Returns: String representation of all enabled rules
     */
    func rulesString(for type: SafariUserRuleType) -> String

    /**
     Returns all User rules objects for specified rules type
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist)
     - Returns: Array of user rules objects
     */
    func allRules(for type: SafariUserRuleType) -> [UserRule]

    /**
     Adds new rule to the specified user rule's list  and reloads CBs than

     If **override** is false and **allRules** already contains **rule** it will return **UserRulesStorageError.ruleAlreadyExists**

     - Parameter rule: Rule object to add to storage
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to add a rule for
     - Parameter override: If **true** and **rule** is already in the user rule's list than it will be overriden with new one
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func add(rule: UserRule, for type: SafariUserRuleType, override: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws

    /**
     Adds new rules to the specified user rule's list and reloads CBs than

     If **override** is false and **allRules** already contains some rules from **rules** it will return **UserRulesStorageError.rulesAlreadyExist**

     - Parameter rules: Rules object to add to storage
     - Parameter type: User rules type (blocklist / allowlist / inverted allowlist) to add rules for
     - Parameter override: If **true**, duplicated rules will be overriden with new ones
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func add(rules: [UserRule], for type: SafariUserRuleType, override: Bool, onCbReloaded: ((Error?) -> Void)?) throws

    /**
     Replaces old rules models with provided rules string and reloads CBs than
     If one of passed rules did already exist than it's state will be preserved

     - Parameter rules: Rules texts to add to storage
     - Parameter type: User rules type (blocklist / allowlist / inverted allowlist) to add rules for
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func set(rules: [String], for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?)

    /**
     Modifies rule in the specified user rule's list and reloads CBs than
     - Parameter oldRuleText: Old rule text to find a rule that wil be modified
     - Parameter newRule: New rule to replace old one
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to modify rule for
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func modifyRule(_ oldRuleText: String, _ newRule: UserRule, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) throws

    /**
     Enables or disables passed rules and reloads CBs than
     - Parameter rules: Rules that should change their state
     - Parameter on: New state of rules
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to modify rule for
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    // TODO: - Tests missing
    func turnRules(_ rules: [String], on: Bool, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?)

    /**
     Removes rule from the specified user rule's list and reloads CBs than
     - Parameter ruleText: Rule text to find a rule that should be deleted
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to remove rule from
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func removeRule(withText ruleText: String, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) throws

    /**
     Removes passed rules and reloads CBs than
     - Parameter rules: Rules that should be removed
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to modify rule for
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func removeRules(_ rules: [String], for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?)

    /**
     Removes all user rules for the specified user rule's list and reloads CBs than
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to remove all rules from
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func removeAllRules(for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?)

    /**
     Removes all safari blocklist rules associated with provided `domain`
     Logic with checking user rule associativity is in `ContentBlockerConverter`
     - Parameter domain: Domain to check blocklist rules association with
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     - Seealso [ContentBlockerConverter](https://github.com/AdguardTeam/SafariConverterLib)
     */
    func removeAllUserRulesAssociatedWith(domain: String, onCbReloaded: ((Error?) -> Void)?)
}

/* Extension is used to interact with all available user rules lists and properly process operations with them */
extension SafariProtection {

    // MARK: - Public methods

    public func rulesString(for type: SafariUserRuleType) -> String {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - rulesString; Returning rules string for type=\(type)")
            let provider = getProvider(for: type)
            return provider.rulesString
        }
    }

    public func allRules(for type: SafariUserRuleType) -> [UserRule] {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - allRules; Returning all rules for type=\(type)")
            let provider = getProvider(for: type)
            return provider.allRules
        }
    }

    public func add(rule: UserRule, for type: SafariUserRuleType, override: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - addRule; Adding rule: \(rule); for type=\(type); override=\(override)")

            let provider = getProvider(for: type)
            try executeBlockAndReloadCbs {
                try provider.add(rule: rule, override: override)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - addRule.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - addRule; Error reloading CBs when adding rule: \(rule) for type=\(type), override=\(override); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - addRule; Successfully reloaded CBs after adding rule: \(rule) for type=\(type), override=\(override)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func add(rules: [UserRule], for type: SafariUserRuleType, override: Bool, onCbReloaded: ((Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - addRules; Adding \(rules.count) rules; for type=\(type); override=\(override)")

            let provider = self.getProvider(for: type)
            try executeBlockAndReloadCbs {
                try provider.add(rules: rules, override: override)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - addRules.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - addRules; Error reloading CBs when adding \(rules.count) rules for type=\(type), override=\(override); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - addRules; Successfully reloaded CBs after adding \(rules.count) rules for type=\(type), override=\(override)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func set(rules: [String], for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - setRules; Setting \(rules.count) rules; for type=\(type)")

            let provider = self.getProvider(for: type)
            executeBlockAndReloadCbs {
                provider.set(rules: rules)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - setRules.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - setRules; Error reloading CBs when setting \(rules.count) rules for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - setRules; Successfully reloaded CBs after setting \(rules.count) rules for type=\(type)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func modifyRule(_ oldRuleText: String, _ newRule: UserRule, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - modifyRule; Modifying old rule=\(oldRuleText) to new rule=\(newRule)")

            let provider = getProvider(for: type)
            try executeBlockAndReloadCbs {
                try provider.modifyRule(oldRuleText, newRule)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - modifyRule.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - modifyRule; Error reloading CBs when modifying rule=\(oldRuleText) to \(newRule) for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - modifyRule; Successfully reloaded CBs after modifying rule=\(oldRuleText) to \(newRule) for type=\(type)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func turnRules(_ rules: [String], on: Bool, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - turnRules; Turning \(rules.count) rules on=\(on) for type=\(type)")

            let provider = getProvider(for: type)
            executeBlockAndReloadCbs {
                rules.forEach {
                    try? provider.modifyRule($0, UserRule(ruleText: $0, isEnabled: on))
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - turnRules.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - turnRules; Error reloading CBs when turning \(rules.count) rules on=\(on) for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - turnRules; Successfully reloaded CBs after turning \(rules.count) rules on=\(on) for type=\(type)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func removeRule(withText ruleText: String, for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - removeRule; Removing rule=\(ruleText) for type=\(type)")

            let provider = getProvider(for: type)
            try executeBlockAndReloadCbs {
                try provider.removeRule(withText: ruleText)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - removeRule.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - removeRule; Error reloading CBs when removing rule=\(ruleText) for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - removeRule; Successfully reloaded CBs after removing rule=\(ruleText) for type=\(type)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func removeRules(_ rules: [String], for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - removeRules; Removing \(rules.count) rules for type=\(type)")

            let provider = getProvider(for: type)
            executeBlockAndReloadCbs {
                rules.forEach {
                    try? provider.removeRule(withText: $0)
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - removeRules.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - removeRules; Error reloading CBs when removing \(rules.count) rules for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - removeRules; Successfully reloaded CBs after removing \(rules.count) rules for type=\(type)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func removeAllRules(for type: SafariUserRuleType, onCbReloaded: ((Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - removeAllRules; Removing all rules for type=\(type)")

            let provider = getProvider(for: type)
            executeBlockAndReloadCbs {
                provider.removeAllRules()
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - removeAllRules.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - removeAllRules; Error reloading CBs when removing all rules for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - removeAllRules; Successfully reloaded CBs after removing all rules for type=\(type)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func removeAllUserRulesAssociatedWith(domain: String, onCbReloaded: ((Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - removeAllUserRulesAssociatedWithDomain; Removing all rules for type=\(domain)")

            let provider = getProvider(for: .blocklist)
            executeBlockAndReloadCbs {
                for rule in provider.allRules {
                    if converterHelper.userRuleIsAssociated(with: domain, rule.ruleText) {
                        try? provider.removeRule(withText: rule.ruleText)
                    }
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - removeAllUserRulesAssociatedWithDomain.onCbReloaded; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - removeAllUserRulesAssociatedWithDomain; Error reloading CBs when removing all rules for domain=\(domain); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - removeAllUserRulesAssociatedWithDomain; Successfully reloaded CBs after removing all rules for type=\(domain)")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    // MARK: - Internal methods

    func getProvider(for type: SafariUserRuleType) -> UserRulesManagerProtocol {
        switch type {
        case .blocklist: return safariManagers.blocklistRulesManager
        case .allowlist: return safariManagers.allowlistRulesManager
        case .invertedAllowlist: return safariManagers.invertedAllowlistRulesManager
        }
    }
}
