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

class SystemWhitelistModel: ListOfRulesModelProtocol {

    // MARK: - Variables
    
    weak var delegate: ListOfRulesModelDelegate?
    
    var rules: [RuleInfo] {
        get {
            return (searchString == nil || searchString!.count == 0) ?
            allRules : searchRules
        }
    }
    
    var searchString: String?
    
    var type: RulesType = .systemWhitelist
    
    var enabled: Bool {
        get {
            return resources.sharedDefaults().bool(forKey: AEDefaultsDnsWhitelistEnabled)
        }
        set{
            if enabled != newValue{
                resources.sharedDefaults().set(newValue, forKey: AEDefaultsDnsWhitelistEnabled)
            }
        }
    }
    
    // MARK: - Titles variables
    
    var title: String {
        get {
            return ACLocalizedString("whitelist_title", nil)
        }
    }

    var exportTitle: String {
        get {
            return ACLocalizedString("export", nil)
        }
    }

    var importTitle: String {
        get {
            return ACLocalizedString("import", nil)
        }
    }
    
    var leftButtonTitle: String {
        get {
            return ACLocalizedString("common_delete", nil)
        }
    }
       
    var middleButtonTitle: String {
        get {
            return ACLocalizedString("common_select_all", nil)
        }
    }

    var helperLabelText: String {
        get {
            return ACLocalizedString("dns_whitelist_helper", nil)
        }
    }
    
    var descriptionTitle: String {
        get {
            return ACLocalizedString("dns_whitelist_text", nil)
        }
    }
    
    // MARK: - Private variables
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    
    /* Variables */
    private let fileName = "dns_whitelist.txt"
    
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    // MARK: - Initializer
    
    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
    }
    
    // MARK: - Main functions
    
    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect) {
        
    }
    
    func importList(parentController: UIViewController) {
        
    }
    
    
    func addRule(ruleText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        
    }
    
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        
    }

    func selectAllRules() {
        allRules.forEach { (rule) in
            rule.selected = true
        }
    }
    
    func deleteSelectedRules(completionHandler: @escaping () -> Void, errorHandler: @escaping (String) -> Void) {
        
    }
    
    func delete(rule: RuleInfo, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        
        guard let index = allRules.firstIndex(of: rule) else { return }
        
        deleteRule(index: index, errorHandler: errorHandler, completionHandler: completionHandler)
    }
    
    func processRulesFromString(_ string: String, errorHandler: @escaping (String) -> Void) {
        // Unrealized method
    }
    
    private func deleteRule(index: Int, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        
    }
}
