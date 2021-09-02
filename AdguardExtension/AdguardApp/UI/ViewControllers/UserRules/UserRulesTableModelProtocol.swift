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

import UIKit

protocol UserRulesTableModelDelegate: AnyObject {
    func rulesChanged()
    func ruleSuccessfullyAdded()
    func rulesChanged(at indexPaths: [IndexPath])
    func rulesRemoved(at indexPaths: [IndexPath])
}

protocol UserRulesTableModelProtocol: UserRuleTableViewCellDelegate, AddRuleControllerDelegate, RuleDetailsControllerDelegate {
    var delegate: UserRulesTableModelDelegate? { get set }
    var title: String { get }
    var description: String { get }
    var isEnabled: Bool { get set }
    var isEditing: Bool { get set }
    var isSearching: Bool { get set }
    var rulesModels: [UserRuleCellModel] { get }
    var icon: UIImage? { get }
    var searchString: String? { get set }
    
    func remove(rules: [String], for indexPaths: [IndexPath])
    func turn(rules: [String], for indexPaths: [IndexPath], on: Bool)
    func setRule(_ rule: String, selected: Bool)
    func deselectAll()
}
