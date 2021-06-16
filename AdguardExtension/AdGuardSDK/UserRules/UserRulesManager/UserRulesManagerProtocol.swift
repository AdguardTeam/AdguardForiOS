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

enum UserRulesStorageError: Error, CustomDebugStringConvertible {
    case ruleAlreadyExists(ruleString: String)
    case rulesAlreadyExist(rulesStrings: [String])
    case ruleDoesNotExist(ruleString: String)
    
    var debugDescription: String {
        switch self {
        case .ruleAlreadyExists(let rule): return "Rule '\(rule)' already exists in rules list"
        case .rulesAlreadyExist(rulesStrings: let rules): return "Rules '\(rules.joined(separator: ";"))' already exists in rules list"
        case .ruleDoesNotExist(let rule): return "Rule '\(rule)' doest not exist in rules list"
        }
    }
}

protocol UserRulesManagerProtocol: AnyObject {
    
    /* String representation of all enabled rules */
    var rulesString: String { get }
    
    /* All UserRuleProtocol objects  */
    var allRules: [UserRuleProtocol] { get }
    
    /**
     Adds new rule to the user rule's list
     - Parameter rule: Rule object to add to storage
     - Parameter override: If **true** and **rule** is already in the user rule's list than it  will be overriden with new one
     
     - Throws: **UserRulesStorageError.ruleAlreadyExists**
                if **override** is false and **allRules** already contains **rule**
     */
    func add(rule: UserRuleProtocol, override: Bool) throws
    
    /**
     Adds new rules to the user rule's list
     - Parameter rules: Rules object to add to storage
     - Parameter override: If **true**, duplicated rules will be overriden with new ones
     
     - Throws: **UserRulesStorageError.rulesAlreadyExist**
                if **override** is false and **allRules** already contains some rules from **rules**
     */
    func add(rules: [UserRuleProtocol], override: Bool) throws
    
    /* Modifies rule in the user rule's list */
    func modifyRule(_ oldRuleText: String, _ newRule: UserRuleProtocol) throws
    
    /* Removes rule from the user rule's list */
    func removeRule(withText ruleText: String) throws
    
    /* Remove all rules from storage */
    func removeAllRules()
}
