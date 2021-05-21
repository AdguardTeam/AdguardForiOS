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

protocol UserRulesStorageProtocol {
    associatedtype Rule: UserRuleProtocol
    
    /* String representation of all enabled rules */
    var rulesString: String { get }
    
    /* All UserRuleProtocol objects  */
    var allRules: [Rule] { get }
    
    /* Adds new rule to the user rule's list */
    func add(rule: Rule)
    
    /* Adds new rules to the user rule's list */
    func add(rules: [Rule])
    
    /* Modifies rule in the user rule's list */
    func modifyRule(_ oldRuleDomain: String, _ newRule: Rule)
    
    /* Removes rule from the user rule's list */
    func removeRule(withDomain domain: String)
}
