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

class UserFilterModel: ListOfRulesModelProtocol {

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
            return resources.sharedDefaults().bool(forKey: AEDefaultsUserFilterEnabled)
        }
        set{
            if enabled != newValue {
                resources.sharedDefaults().set(newValue, forKey: AEDefaultsUserFilterEnabled)
                contentBlockerService.reloadJsons(backgroundUpdate: false) {_ in }
            }
        }
    }
    
    // MARK: - Titles variables
    var title: String {
        get {
            return ACLocalizedString("safari_userfilter_title", nil)
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
            return ACLocalizedString("common_clear", nil)
        }
    }
    
    var middleButtonTitle: String {
        get {
            return ACLocalizedString("common_save", nil)
        }
    }

    var helperLabelText: String {
        get {
            return ACLocalizedString("user_filter_helper", nil)
        }
    }
    
    var descriptionTitle: String {
        get {
            return ACLocalizedString("blacklist_text_format", nil)
        }
    }
    
    // MARK: - Private variables
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    private let contentBlockerService: ContentBlockerService
    private let antibanner: AESAntibannerProtocol
    private let theme: ThemeServiceProtocol
    private let fileShare: FileShareServiceProtocol = FileShareService()
    
    private var ruleObjects: [ASDFilterRule] = [ASDFilterRule]()
    
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    // MARK: - Initializer
    
    init(resources: AESharedResourcesProtocol, contentBlockerService: ContentBlockerService, antibanner: AESAntibannerProtocol, theme: ThemeServiceProtocol) {
        self.resources = resources
        self.contentBlockerService = contentBlockerService
        self.antibanner = antibanner
        self.theme = theme
        
        ruleObjects = antibanner.rules(forFilter: ASDF_USER_FILTER_ID as NSNumber)
        for ruleObject in ruleObjects {
            let rule = RuleInfo(ruleObject.ruleText, false, ruleObject.isEnabled.boolValue, theme)
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
        
        changeSafariUserfilterRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
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
    
    func deleteSelectedRules(completionHandler: @escaping () -> Void, errorHandler: @escaping (String) -> Void) {
        // Unrealized method
    }
    
    func processRulesFromString(_ string: String, errorHandler: @escaping (_ error: String)->Void) {
        let ruleStrings = string.components(separatedBy: .newlines)
        
        var newRuleObjects = [ASDFilterRule]()
        var newRuleInfos = [RuleInfo]()
        
        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }

            let ruleObject = ASDFilterRule(text: trimmedRuleString, enabled: true)
  
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
            
            var rulesToAdd = [ASDFilterRule]()
            var ruleTextsToAdd = [String]()
            for ruleText in ruleTexts {
            
                if !strongSelf.contentBlockerService.validateRule(ruleText) {
                   errorHandler(ACLocalizedString("rule_converting_error", nil))
                   return
                }
                let rule = ASDFilterRule(text: ruleText, enabled: true)
                
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
    
    private func setNewRules(_ newRuleObjects: [ASDFilterRule], ruleInfos: [RuleInfo], completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
    
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let rulesCopy = strongSelf.allRules
            let objectsCopy = strongSelf.ruleObjects
            
            strongSelf.allRules = ruleInfos
            strongSelf.ruleObjects = newRuleObjects
            
            strongSelf.delegate?.listOfRulesChanged()
            
            DispatchQueue.global().async { [weak self] in
                guard let strongSelf = self else { return }
                if let error = strongSelf.contentBlockerService.replaceUserFilter(newRuleObjects) {
                    DispatchQueue.main.async {
                        strongSelf.allRules = rulesCopy
                        strongSelf.ruleObjects = objectsCopy
                        strongSelf.delegate?.listOfRulesChanged()
                        errorHandler(error.localizedDescription)
                    }
                }
                completionHandler()
                
                strongSelf.contentBlockerService.reloadJsons(backgroundUpdate: false) { (error) in
                    
                    DDLogError("(UserFilterViewModel) Error occured during content blocker reloading.")
                    // do not rollback changes and do not show any alert to user in this case
                    // https://github.com/AdguardTeam/AdguardForiOS/issues/1174
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                }
            }
        }
    }
    
    private func deleteRule(index: Int, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        
        let rule = self.allRules[index]
        guard let index = allRules.firstIndex(of: rule) else { return }
        
        let ruleObject = ruleObjects[index]
        
        let filteredRules = allRules.filter({$0 != rule})
        let filteredRuleObjects = ruleObjects.filter({$0 != ruleObject})
        
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
        
        var newRuleObjects = [ASDFilterRule]()
        var newRuleInfos = [RuleInfo]()
        
        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }
    
            let ruleObject = AEWhitelistDomainObject(domain: trimmedRuleString).rule
            
            let ruleInfo = RuleInfo(trimmedRuleString, false, true, theme)
            newRuleObjects.append(ruleObject)
            newRuleInfos.append(ruleInfo)
        }
        setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: {
            
        }) { (message) in
            errorHandler(message)
        }
    }
    
    private func changeSafariUserfilterRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        if !contentBlockerService.validateRule(text) {
           errorHandler(ACLocalizedString("rule_converting_error", nil))
           return
        }
        
        let ruleObject = ruleObjects[index]
        let rule = allRules[index]
        
        rule.rule = text
        ruleObject.ruleText = text
        
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
