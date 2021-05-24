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
    case ruleDoesNotExist(ruleString: String)
    
    var debugDescription: String {
        switch self {
        case .ruleAlreadyExists(let rule): return "Rule '\(rule)' already exists in rules list"
        case .ruleDoesNotExist(let rule): return "Rule '\(rule)' doest not exist in rules list"
        }
    }
}

protocol UserRulesStorageProtocol: AnyObject {
    associatedtype Rule: UserRuleProtocol
    
    /* String representation of all enabled rules */
    var rulesString: String { get }
    
    /* All UserRuleProtocol objects  */
    var allRules: [Rule] { get }
    
    /* Adds new rule to the user rule's list */
    func add(rule: Rule) throws
    
    /* Adds new rules to the user rule's list */
    func add(rules: [Rule]) throws
    
    /* Modifies rule in the user rule's list */
    func modifyRule(_ oldRuleDomain: String, _ newRule: Rule) throws
    
    /* Removes rule from the user rule's list */
    func removeRule(withDomain domain: String) throws
}
