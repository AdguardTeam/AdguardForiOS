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
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import Foundation

public enum UserRulesStorageError: Error, CustomDebugStringConvertible {
    case ruleAlreadyExists(ruleString: String)
    case rulesAlreadyExist(rulesStrings: [String])
    case attemptingToAddDuplicates(duplicatedRules: [String])
    case ruleDoesNotExist(ruleString: String)

    public var debugDescription: String {
        switch self {
        case .ruleAlreadyExists(let rule): return "Rule '\(rule)' already exists in rules list"
        case .rulesAlreadyExist(rulesStrings: let rules): return "Rules '\(rules.joined(separator: ";"))' already exists in rules list"
        case .attemptingToAddDuplicates(duplicatedRules: let duplicates): return "There are duplicates in rules attempted to be add; Duplicates: \(duplicates.joined(separator: ";"))"
        case .ruleDoesNotExist(let rule): return "Rule '\(rule)' doest not exist in rules list"
        }
    }
}

public protocol UserRulesManagerProtocol: ResetableSyncProtocol, AnyObject {

    /* String representation of all enabled rules */
    var rulesString: String { get }

    /* All UserRule objects  */
    var allRules: [UserRule] { get }

    /**
     Adds new rule to the user rule's list
     - Parameter rule: Rule object to add to storage
     - Parameter override: If **true** and **rule** is already in the user rule's list than it will be overriden with new one

     - Throws: **UserRulesStorageError.ruleAlreadyExists**
                if **override** is false and **allRules** already contains **rule**
     */
    func add(rule: UserRule, override: Bool) throws

    /**
     Adds new rules to the user rule's list
     - Parameter rules: Rules object to add to storage
     - Parameter override: If **true**, duplicated rules will be overriden with new ones

     - Throws: **UserRulesStorageError.rulesAlreadyExist**
                if **override** is false and **allRules** already contains some rules from **rules**
     */
    func add(rules: [UserRule], override: Bool) throws

    /**
     Replaces old rules models with provided rules string
     If one of passed rules did already exist than it's state will be preserved

     - Parameter rules: Rules texts to add to storage
     */
    func set(rules: [String])

    /* Modifies rule in the user rule's list */
    func modifyRule(_ oldRuleText: String, _ newRule: UserRule) throws

    /* Removes rule from the user rule's list */
    func removeRule(withText ruleText: String) throws

    /* Remove all rules from storage */
    func removeAllRules()

    /** check that user filter contains the rule
     - Parameter ruleText: text of user rule to check
     - Returns: check result
     */
    func checkEnabledRuleExists(_ ruleText: String)->Bool
}
