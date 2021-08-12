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
import SafariAdGuardSDK

class UserFilterModel: ListOfRulesModelProtocol {
    
    private let filterRulesAction = "filter_rules"
    private let openUrlFrom = "user_filter"
    
    // MARK: - Variables
    
    /* State of model */
    var state: ControllerState = .normal {
        didSet {
            allRules.forEach({ $0.attributedString = nil })
            if state == .searching {
                searchRules = allRules
            }
        }
    }
    
    weak var delegate: ListOfRulesModelDelegate?
    
    var rules: [RuleInfo] {
        get {
            return (state == .searching) ? searchRules : allRules
        }
    }
    
    var searchString: String? {
        didSet {
            searchRule()
        }
    }
    
    var type: RulesType = .safariUserfilter
    
    var enabled: Bool {
        get {
            return resources.safariUserFilterEnabled
        }
        set{
            if enabled != newValue {
                resources.safariUserFilterEnabled = newValue
                safariProtection.update(blocklistIsEnabled: newValue) { _ in
                    // todo:
                }
            }
        }
    }
    
    // MARK: - Titles variables
    var title: String {
        get {
            return String.localizedString("safari_userfilter_title")
        }
    }
    
    var leftButtonTitle: String {
        get {
            return String.localizedString("common_clear")
        }
    }
    
    var middleButtonTitle: String {
        get {
            return String.localizedString("common_save")
        }
    }

    var helperLabelText: String {
        get {
            return String.localizedString("user_filter_helper")
        }
    }
    
    var descriptionTitle: String {
        get {
            let format = ACLocalizedString("blacklist_text_format", nil)
            let url = UIApplication.shared.adguardUrl(action: filterRulesAction, from: openUrlFrom, buildVersion: productInfo.buildVersion())
            return String(format: format, url)
        }
    }
    
    // MARK: - Private variables
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    private let theme: ThemeServiceProtocol
    private let fileShare: FileShareServiceProtocol = FileShareService()
    private let productInfo: ADProductInfoProtocol
    private let safariProtection: SafariProtectionProtocol
    
    private var ruleObjects = [UserRuleProtocol]()
    
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    // MARK: - Initializer
    
    init(resources: AESharedResourcesProtocol, theme: ThemeServiceProtocol, productInfo: ADProductInfoProtocol, safariProtection: SafariProtectionProtocol) {
        self.resources = resources
        self.theme = theme
        self.productInfo = productInfo
        self.safariProtection = safariProtection
        
        ruleObjects = safariProtection.allRules(for: .blocklist)
        for ruleObject in ruleObjects {
            let rule = RuleInfo(ruleObject.ruleText, false, ruleObject.isEnabled, theme)
            allRules.append(rule)
        }
    }
    
    // MARK: - Main functions

    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect) {
        let fileName = "adguard_user_filter.txt"
        
        fileShare.exportFile(parentController: parentController, sourceView: sourceView, sourceRect: sourceRect, filename: fileName, text: plainText()) { (message) in
        }
    }
    
    func importList(parentController: UIViewController) {
        fileShare.importFile(parentController: parentController) { [weak self] (text, errorMessage) in
            guard let strongSelf = self else { return }
            if errorMessage != nil {
                ACSSystemUtils.showSimpleAlert(for: parentController, withTitle: nil, message: errorMessage)
            }
            else {
                strongSelf.importRules(text) { errorMessage in
                    ACSSystemUtils.showSimpleAlert(for: parentController, withTitle: nil, message: errorMessage)
                }
            }
        }
    }
    
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        guard let index = allRules.firstIndex(of: rule) else {
            DDLogError("(UserFilterViewModel) change rule failed - rule not found")
            return
        }
        
        changeSafariUserfilterRule(index: index, text: newText, enabled: rule.enabled, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    /**
     adds rule with @ruleText to user filter and reloads safari content blockers
     */
    func addRule(ruleText: String, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        if ruleText.count == 0 { return }
        
        let components = ruleText.components(separatedBy: .newlines)
        
        var rules: [String] = []
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            if trimmed.count > 0 {
                rules.append(trimmed)
            }
        }
        
        if rules.count == 0 {
            return
        }
        
        addUserFilterRules(ruleTexts: rules, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func selectAllRules() {
        allRules.forEach { (rule) in
            rule.selected = true
        }
    }
    
    func delete(rule: RuleInfo, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        
        guard let index = allRules.firstIndex(of: rule) else { return }
        if let indexWhileSearching = searchRules.firstIndex(of: rule){
            searchRules.remove(at: indexWhileSearching)
        }
        
        deleteRule(index: index, errorHandler: errorHandler, completionHandler: completionHandler)
    }
    
    func deleteSelectedRules(completionHandler: @escaping (_ rulesWereDeleted: Bool) -> Void, errorHandler: @escaping (String) -> Void) {
        // Unrealized method
    }
    
    func processRulesFromString(_ string: String, errorHandler: @escaping (_ error: String)->Void) {
        let ruleStrings = string.components(separatedBy: .newlines)
        
        var newRuleObjects = [UserRuleProtocol]()
        var newRuleInfos = [RuleInfo]()
        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }

            let ruleObject = UserRule(ruleText: trimmedRuleString, isEnabled: true)
  
            let ruleInfo = RuleInfo(trimmedRuleString, false, true, theme)

            newRuleObjects.append(ruleObject)
            newRuleInfos.append(ruleInfo)
        }
        setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: {}) { (message) in
            errorHandler(message)
        }
    }
    
    // MARK: - Private methods
    
    private func addUserFilterRules(ruleTexts: [String], completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
            var rulesToAdd = [UserRuleProtocol]()
            var ruleTextsToAdd = [String]()
            for ruleText in ruleTexts {
            
                // todo:
//                if !strongSelf.contentBlockerService.validateRule(ruleText) {
//                   errorHandler(ACLocalizedString("rule_converting_error", nil))
//                   return
//                }
                let rule = UserRule(ruleText: ruleText, isEnabled: true)
                
                rulesToAdd.append(rule)
                ruleTextsToAdd.append(ruleText)
            }
            
            if rulesToAdd.count == 0 {
                
                DispatchQueue.main.async {
                    let errorDescription = ACLocalizedString("filter_rules_converting_error", nil)
                    errorHandler(errorDescription)
                }
                return
            }
            
            var newRuleObjects = Array(strongSelf.ruleObjects)
            var newRuleInfos = Array(strongSelf.allRules)
            
            newRuleInfos.append(contentsOf: ruleTextsToAdd.map({ (rule) -> RuleInfo in RuleInfo(rule, false, true, strongSelf.theme) }))
            newRuleObjects.append(contentsOf: rulesToAdd)
            
            strongSelf.setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    private func setNewRules(_ newRuleObjects: [UserRuleProtocol], ruleInfos: [RuleInfo], completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
    
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let rulesCopy = self.allRules
            let objectsCopy = self.ruleObjects
            
            self.allRules = ruleInfos
            self.ruleObjects = newRuleObjects
            
            self.delegate?.listOfRulesChanged()
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.safariProtection.add(rules: newRuleObjects, for: .blocklist, override: true) { error in
                    DispatchQueue.main.async {
                        self.allRules = rulesCopy
                        self.ruleObjects = objectsCopy
                        self.delegate?.listOfRulesChanged()
                        if let error = error {
                            errorHandler(error.localizedDescription)
                        }
                    }
                }
                
                completionHandler()
            }
        }
    }
    
    private func deleteRule(index: Int, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        
        let rule = self.allRules[index]
        guard let index = allRules.firstIndex(of: rule) else { return }
        
        let ruleObject = ruleObjects[index]
        
        let filteredRules = allRules.filter({$0 != rule})
        let filteredRuleObjects = ruleObjects.filter({$0.ruleText != ruleObject.ruleText})
        
        setNewRules(filteredRuleObjects, ruleInfos: filteredRules, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    /**
     retuns all rules from list of rules as a plain text
     */
    private func plainText() -> String {
        return allRules.map({ $0.rule }).joined(separator: "\n")
    }
    
    /**
     parse plain text to array of rules. Save it to list of rules and reload safari content blockers
    */
    func importRules(_ plainText: String, errorHandler: @escaping (_ error: String)->Void) {
        
        let ruleStrings = plainText.components(separatedBy: .newlines)
        
        var newRuleObjects = [UserRuleProtocol]()
        var newRuleInfos = [RuleInfo]()
        
        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }
    
            let ruleObject = UserRule(ruleText: trimmedRuleString, isEnabled: true)
            
            let ruleInfo = RuleInfo(trimmedRuleString, false, true, theme)
            newRuleObjects.append(ruleObject)
            newRuleInfos.append(ruleInfo)
        }
        setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: {
            
        }) { (message) in
            errorHandler(message)
        }
    }
    
    private func changeSafariUserfilterRule(index: Int, text: String, enabled: Bool, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        // todo:
//        if !contentBlockerService.validateRule(text) {
//           errorHandler(ACLocalizedString("rule_converting_error", nil))
//           return
//        }
        
        let ruleObject = ruleObjects[index]
        let rule = allRules[index]
        
        rule.rule = text
        rule.enabled = enabled
        
        // todo: replace rule object in array
//        ruleObject.ruleText = text
//        ruleObject.isEnabled = NSNumber(booleanLiteral: enabled)
        
        setNewRules(ruleObjects, ruleInfos: allRules, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    private func searchRule(){
        searchRules = []
        allRules.forEach({ $0.attributedString = nil })
        
        if searchString == nil || (searchString?.isEmpty ?? true) {
            searchRules = allRules
            delegate?.listOfRulesChanged()
            return
        }
        
        guard let components = searchString?.lowercased().split(separator: " ") else { return }
        let searchStrings = components.map({ String($0) })
        
        for rule in allRules {
            if checkRule(rule: rule, components: components) {
                rule.attributedString = rule.rule.highlight(search: searchStrings)
                searchRules.append(rule)
            }
        }
        
        delegate?.listOfRulesChanged()
    }
    
    private func checkRule(rule: RuleInfo, components: [Substring]) -> Bool {
        let name = rule.rule
        for component in components {
            let range = name.range(of: component, options: .caseInsensitive)
            if range != nil {
                return true
            }
        }
        return false
    }
}
