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

public protocol SafariProtectionUserRulesProtocol {
    /**
     Returns String representation of all enabled rules for specified rules type
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist)
     - Returns: String representation of all enabled rules
     */
    func rulesString(for type: UserRuleType) -> String
 
    /**
     Returns all User rules objects for specified rules type
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist)
     - Returns: Array of user rules objects
     */
    func allRules(for type: UserRuleType) -> [UserRuleProtocol]
    
    /**
     Adds new rule to the specified user rule's list
     
     If **override** is false and **allRules** already contains **rule** it will return **UserRulesStorageError.ruleAlreadyExists**
     
     - Parameter rule: Rule object to add to storage
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to add a rule for
     - Parameter override: If **true** and **rule** is already in the user rule's list than it will be overriden with new one
     - Parameter onRuleAdded: Closure to handle errors
     */
    func add(rule: UserRuleProtocol, for type: UserRuleType, override: Bool, onRuleAdded: @escaping (_ error: Error?) -> Void)
    
    /**
     Adds new rules to the specified user rule's list
     
     If **override** is false and **allRules** already contains some rules from **rules** it will return **UserRulesStorageError.rulesAlreadyExist**
     
     - Parameter rules: Rules object to add to storage
     - Parameter type: User rules type (blocklist / allowlist / inverted allowlist) to add rules for
     - Parameter override: If **true**, duplicated rules will be overriden with new ones
     - Parameter onRulesAdded: Closure to handle errors
     */
    func add(rules: [UserRuleProtocol], for type: UserRuleType, override: Bool, onRulesAdded: @escaping (_ error: Error?) -> Void)
    
    /**
     Modifies rule in the specified user rule's list
     - Parameter oldRuleText: Old rule text to find a rule that wil be modified
     - Parameter newRule: New rule to replace old one
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to modify rule for
     - Parameter onRuleModified: Closure to handle errors
     */
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol, for type: UserRuleType, onRuleModified: @escaping (_ error: Error?) -> Void)
    
    /**
     Removes rule from the specified user rule's list
     - Parameter ruleText: Rule text to find a rule that should be deleted
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to remove rule from
     - Parameter onRuleRemoved: Closure to handle errors
     */
    func removeRule(withText ruleText: String, for type: UserRuleType, onRuleRemoved: @escaping (_ error: Error?) -> Void)
    
    /**
     Removes all user rules for the specified user rule's list
     - Parameter type: User rule type (blocklist / allowlist / inverted allowlist) to remove all rules from
     - Parameter onRulesRemoved: Closure to handle errors
     */
    func removeAllRules(for type: UserRuleType, onRulesRemoved: @escaping (_ error: Error?) -> Void)
}

extension SafariProtection {
    
    // MARK: - Public methods
    
    public func rulesString(for type: UserRuleType) -> String {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - rulesString; Returning rules string for type=\(type)")
            let provider = getProvider(for: type)
            return provider.rulesString
        }
    }
    
    public func allRules(for type: UserRuleType) -> [UserRuleProtocol] {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRules) - allRules; Returning all rules for type=\(type)")
            let provider = getProvider(for: type)
            return provider.allRules
        }
    }
    
    public func add(rule: UserRuleProtocol, for type: UserRuleType, override: Bool, onRuleAdded: @escaping (_ error: Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+UserRules) - addRule; self is missing!")
                onRuleAdded(CommonError.missingSelf)
                return
            }
            
            Logger.logInfo("(SafariProtection+UserRules) - addRule; Adding rule: \(rule); for type=\(type); override=\(override)")
            
            let provider = self.getProvider(for: type)
            self.executeBlockAndReloadCbs {
                try provider.add(rule: rule, override: override)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - addRule.onCbReloaded; self is missing!")
                    onRuleAdded(CommonError.missingSelf)
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - addRule; Error reloading CBs when adding rule: \(rule) for type=\(type), override=\(override); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - addRule; Successfully reloaded CBs after adding rule: \(rule) for type=\(type), override=\(override)")
                }
                self.completionQueue.async { onRuleAdded(error) }
            }
        }
    }
    
    public func add(rules: [UserRuleProtocol], for type: UserRuleType, override: Bool, onRulesAdded: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+UserRules) - addRules; self is missing!")
                onRulesAdded(CommonError.missingSelf)
                return
            }
            
            Logger.logInfo("(SafariProtection+UserRules) - addRules; Adding \(rules.count) rules; for type=\(type); override=\(override)")
            let provider = self.getProvider(for: type)
            self.executeBlockAndReloadCbs {
                try provider.add(rules: rules, override: override)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - addRules.onCbReloaded; self is missing!")
                    onRulesAdded(CommonError.missingSelf)
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - addRules; Error reloading CBs when adding \(rules.count) rules for type=\(type), override=\(override); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - addRules; Successfully reloaded CBs after adding \(rules.count) rules for type=\(type), override=\(override)")
                }
                self.completionQueue.async { onRulesAdded(error) }
            }
        }
    }
    
    public func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol, for type: UserRuleType, onRuleModified: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+UserRules) - modifyRule; self is missing!")
                onRuleModified(CommonError.missingSelf)
                return
            }
            
            Logger.logInfo("(SafariProtection+UserRules) - modifyRule; Modifying old rule=\(oldRuleText) to new rule=\(newRule)")
            let provider = self.getProvider(for: type)
            self.executeBlockAndReloadCbs {
                try provider.modifyRule(oldRuleText, newRule)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - modifyRule.onCbReloaded; self is missing!")
                    onRuleModified(CommonError.missingSelf)
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - modifyRule; Error reloading CBs when modifying rule=\(oldRuleText) to \(newRule) for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - modifyRule; Successfully reloaded CBs after modifying rule=\(oldRuleText) to \(newRule) for type=\(type)")
                }
                self.completionQueue.async { onRuleModified(error) }
            }
        }
    }
    
    public func removeRule(withText ruleText: String, for type: UserRuleType, onRuleRemoved: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+UserRules) - removeRule; self is missing!")
                onRuleRemoved(CommonError.missingSelf)
                return
            }
            
            Logger.logInfo("(SafariProtection+UserRules) - removeRule; Removing rule=\(ruleText) for type=\(type)")
            let provider = self.getProvider(for: type)
            self.executeBlockAndReloadCbs {
                try provider.removeRule(withText: ruleText)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - removeRule.onCbReloaded; self is missing!")
                    onRuleRemoved(CommonError.missingSelf)
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - removeRule; Error reloading CBs when removing rule=\(ruleText) for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - removeRule; Successfully reloaded CBs after removing rule=\(ruleText) for type=\(type)")
                }
                self.completionQueue.async { onRuleRemoved(error) }
            }
        }
    }
    
    public func removeAllRules(for type: UserRuleType, onRulesRemoved: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+UserRules) - removeAllRules; self is missing!")
                onRulesRemoved(CommonError.missingSelf)
                return
            }
            
            Logger.logInfo("(SafariProtection+UserRules) - removeAllRules; Removing all rules for type=\(type)")
            let provider = self.getProvider(for: type)
            self.executeBlockAndReloadCbs {
                provider.removeAllRules()
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+UserRules) - removeAllRules.onCbReloaded; self is missing!")
                    onRulesRemoved(CommonError.missingSelf)
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+UserRules) - removeAllRules; Error reloading CBs when removing all rules for type=\(type); Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+UserRules) - removeAllRules; Successfully reloaded CBs after removing all rules for type=\(type)")
                }
                self.completionQueue.async { onRulesRemoved(error) }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func getProvider(for type: UserRuleType) -> UserRulesManagerProtocol {
        switch type {
        case .blocklist: return userRulesManagersProvider.blocklistRulesManager
        case .allowlist: return userRulesManagersProvider.allowlistRulesManager
        case .invertedAllowlist: return userRulesManagersProvider.invertedAllowlistRulesManager
        }
    }
}
