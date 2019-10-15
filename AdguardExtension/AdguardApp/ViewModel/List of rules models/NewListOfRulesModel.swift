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

enum RulesType{
    case safariWhitelist, invertedSafariWhitelist, systemWhitelist, systemBlacklist, safariUserfilter, wifiExceptions
}

protocol ListOfRulesModelDelegate: class{
    func listOfRulesChanged()
}

protocol ListOfRulesModelProtocol {
    /* Delegate, to be notified about rules changes */
    var delegate: ListOfRulesModelDelegate? { get set }
    
    /* Variables */
    var rules: [RuleInfo] { get }
    var type: RulesType { get }
    var enabled: Bool { get set }
    var searchString: String? { get set }
    
    /* Main functions */
    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect)
    func importList(parentController: UIViewController)
    func addRule(ruleText: String, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void)
    func selectAllRules()
    func deleteSelectedRules(completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void)
    func delete(rule: RuleInfo, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void)
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) 
    func processRulesFromString(_ string: String, errorHandler: @escaping (_ error: String)->Void)
    
    /* Titles variables */
    var title: String { get }
    var exportTitle: String { get }
    var importTitle: String { get }
    var leftButtonTitle: String { get }
    var middleButtonTitle: String { get }
    var helperLabelText: String { get }
    var descriptionTitle: String { get }
}
