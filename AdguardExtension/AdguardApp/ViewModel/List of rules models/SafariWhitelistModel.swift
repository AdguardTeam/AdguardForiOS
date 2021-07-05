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
import AdGuardSDK

class SafariWhitelistModel: ListOfRulesModelProtocol {
    
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
    
    var type: RulesType = .safariWhitelist
    
    var enabled: Bool {
        get {
            return resources.safariWhitelistEnabled
        }
        set{
            if enabled != newValue {
                resources.safariWhitelistEnabled = newValue
                safariProtection.update(allowlistIsEnbaled: newValue) { _ in
                    // todo: process error
                }
            }
        }
    }
    
    // MARK: - Titles variables
    var title: String {
        get {
            return ACLocalizedString("whitelist_title", nil)
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
            return ""
        }
    }
    
    var descriptionTitle: String {
        get {
            return ACLocalizedString("whitelist_text", nil)
        }
    }
    
    // MARK: - Private variables
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    private let theme: ThemeServiceProtocol
    private let fileShare: FileShareServiceProtocol = FileShareService()
    private let safariProtection: SafariProtectionProtocol
    
    /* Variables */
    private var ruleObjects = [UserRuleProtocol]()
    
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    // MARK: - Initializer
    
    init(resources: AESharedResourcesProtocol, theme: ThemeServiceProtocol, safariProtection: SafariProtectionProtocol) {
        self.resources = resources
        self.theme = theme
        self.safariProtection = safariProtection
        
        ruleObjects = safariProtection.allRules(for: .allowlist)
        allRules = ruleObjects.map({
            return RuleInfo($0.ruleText, false, $0.isEnabled , theme)
        })
    }
    
    // MARK: - Main functions


    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect){
        let fileName = "adguard_whitelist.txt"

        fileShare.exportFile(parentController: parentController, sourceView: sourceView, sourceRect: sourceRect, filename: fileName, text: plainText()) { (message) in
        }
    }
    
    func importList(parentController: UIViewController){
        fileShare.importFile(parentController: parentController) { [weak self] (text, errorMessage) in
            guard let self = self else { return }
            if errorMessage != nil {
                ACSSystemUtils.showSimpleAlert(for: parentController, withTitle: nil, message: errorMessage)
            }
            else {
                self.importRules(text) { errorMessage in
                    ACSSystemUtils.showSimpleAlert(for: parentController, withTitle: nil, message: errorMessage)
                }
            }
        }
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
        
        addSafariWhitelistDomain(domain: ruleText, completionHandler: completionHandler, errorHandler: errorHandler)
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
    
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        delegate?.listOfRulesChanged()
        guard let index = allRules.firstIndex(of: rule) else {
            DDLogError("(UserFilterViewModel) change rule failed - rule not found")
            return
        }
        changeSafariWhitelistRule(index: index, text: newText, enabled: rule.enabled, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func deleteSelectedRules(completionHandler: @escaping (_ rulesWereDeleted: Bool) -> Void, errorHandler: @escaping (String) -> Void) {
        var newRuleObjects = [UserRuleProtocol]()
        var newRuleInfos = [RuleInfo]()
        var rulesWereDeleted = false
        
        for (index, ruleInfo) in allRules.enumerated() {
            if !ruleInfo.selected {
                newRuleObjects.append(ruleObjects[index])
                newRuleInfos.append(allRules[index])
            } else {
                rulesWereDeleted = true
            }
        }
        
        setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: { completionHandler(rulesWereDeleted) }, errorHandler: errorHandler)
    }
    
    func processRulesFromString(_ string: String, errorHandler: @escaping (String) -> Void) {
        // Unrealized method
    }
    
    // MARK: - Private methods
    
    private func addSafariWhitelistDomain(domain: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
           
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
                           
        let rulesCopy = allRules
        let objectsCopy = ruleObjects
           
        let newRules = allRules + [RuleInfo(domain, false, true, theme)]
        var newRuleObjects = ruleObjects
        newRuleObjects.append(UserRule(ruleText: domain))
           
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
               
            self.allRules = newRules
            self.ruleObjects = newRuleObjects
               
            self.delegate?.listOfRulesChanged()
           
            self.safariProtection.add(rule: UserRule(ruleText: domain), for: .allowlist, override: true) { [weak self] (error) in
                DispatchQueue.main.async {
                    if error == nil {
                        completionHandler()
                    } else {
                        self?.allRules = rulesCopy
                        self?.ruleObjects = objectsCopy
                        self?.delegate?.listOfRulesChanged()
                          
                        errorHandler(error!.localizedDescription)
                    }
                       
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                }
            }
        }
    }
    
    private func deleteRule(index: Int, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        let oldRules = allRules
        let oldRuleObjects = ruleObjects
        
        let domain = allRules[index].rule
        allRules.remove(at: index)
        ruleObjects.remove(at: index)
        delegate?.listOfRulesChanged()
            
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            
        safariProtection.removeRule(withText: domain, for: .allowlist) { (error) in
                
            DispatchQueue.main.async {[weak self] in
                if error == nil {
                    completionHandler()
                }
                else {
                    self?.allRules = oldRules
                    self?.ruleObjects = oldRuleObjects
                    self?.delegate?.listOfRulesChanged()
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    private func setNewRules(_ newRuleObjects: [UserRuleProtocol], ruleInfos: [RuleInfo], completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
    
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
        
            self.allRules = ruleInfos
            self.ruleObjects = newRuleObjects
            
            self.delegate?.listOfRulesChanged()
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                self.safariProtection.add(rules: self.ruleObjects, for: .allowlist, override: true) { (error) in
                    
                    if error != nil {
                        DDLogError("(SafariWhitelistModel) Error occured during content blocker reloading - \(error!.localizedDescription)")
                        // do not rollback changes and do not show any alert to user in this case
                        // https://github.com/AdguardTeam/AdguardForiOS/issues/1174
                    }
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                    completionHandler()
                }
            }
        }
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
    
            let ruleObject = UserRule(ruleText: trimmedRuleString)
            
            let ruleInfo = RuleInfo(trimmedRuleString, false, true, theme)
            newRuleObjects.append(ruleObject)
            newRuleInfos.append(ruleInfo)
        }
        setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: { 
            
        }) { (message) in
            errorHandler(message)
        }
    }
    
    private func changeSafariWhitelistRule(index: Int, text: String, enabled: Bool, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        let oldRuleObject = ruleObjects[index]
        let oldRule = allRules[index]
        
        safariProtection.modifyRule(allRules[index].rule, UserRule(ruleText: text), for: .allowlist) { (error) in
            oldRule.rule = text
            
            oldRule.enabled = enabled
            
            // todo:
//            oldRuleObject.isEnabled = NSNumber(booleanLiteral: enabled)
//            oldRuleObject.ruleText = text
            
            completionHandler()
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
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
