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

class InvertedSafariWhitelistModel: ListOfRulesModelProtocol {
    
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
    
    var type: RulesType = .invertedSafariWhitelist
    
    var enabled: Bool {
        get {
            return safariProtection.allowlistIsEnbaled
        }
        set{
            if enabled != newValue {
                safariProtection.update(allowlistIsEnbaled: newValue) { error in
                    // todo:
                }
            }
        }
    }
    
    // MARK: - Titles variables
    var title: String {
        get {
            return ACLocalizedString("inverted_whitelist_title", nil)
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
            return ACLocalizedString("inverted_whitelist_text", nil)
        }
    }
    
    // MARK: - Private variables
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    private let theme: ThemeServiceProtocol
    private let fileShare: FileShareServiceProtocol = FileShareService()
    private let safariProtection: SafariProtectionProtocol
    
    /* Variables */
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    // MARK: - Initializer
    
    init(resources: AESharedResourcesProtocol, theme: ThemeServiceProtocol, safariProtection: SafariProtectionProtocol) {
        self.resources = resources
        self.theme = theme
        self.safariProtection = safariProtection
        
        let invertedRules = safariProtection.allRules(for: .invertedAllowlist)
        allRules = invertedRules.map({ (rule) -> RuleInfo in
            RuleInfo(rule.ruleText, false, rule.isEnabled, theme)
        })
    }
    
    // MARK: - Main functions

    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect) {
        
        let fileName = "adguard_inverted_whitelist.txt"
        
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
    
    /**
     adds rule with @ruleText to inverted whitelist and reloads safari content blockers
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
        
        addInvertedSafariWhitelistRule(ruleText: rules.first ?? "", completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        guard let index = allRules.firstIndex(of: rule) else {
            DDLogError("(UserFilterViewModel) change rule failed - rule not found")
            return
        }
        changeInvertedSafariWhitelistRule(index: index, text: newText, enabled: rule.enabled, completionHandler: completionHandler, errorHandler: errorHandler)
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

        deleteInvertedSafariWhitelistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func deleteSelectedRules(completionHandler: @escaping (_ rulesWereDeleted: Bool) -> Void, errorHandler: @escaping (String) -> Void) {
        var newRuleInfos = [RuleInfo]()
        var rulesWereDeleted = false
        
        for ruleInfo in allRules {
            if !ruleInfo.selected {
                newRuleInfos.append(ruleInfo)
            } else {
                rulesWereDeleted = true
            }
        }
        allRules = newRuleInfos
        
        setNewRules(completionHandler: { completionHandler(rulesWereDeleted) }, errorHandler: errorHandler)
    }
    
    func processRulesFromString(_ string: String, errorHandler: @escaping (String) -> Void) {
        // Unrealized method
    }
    
    // MARK: - Private methods
    
    private func addInvertedSafariWhitelistRule(ruleText: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void){
        
        // todo:
//        if !contentBlockerService.validateRule(domainObject.rule.ruleText) {
//           errorHandler(ACLocalizedString("rule_converting_error", nil))
//           return
//        }
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        var domains = allRules
        domains.append(RuleInfo(ruleText, false, true, theme))
        
        allRules = domains
        delegate?.listOfRulesChanged()
        
        safariProtection.add(rule: UserRule(ruleText: ruleText), for: .invertedAllowlist, override: false) { [weak self] error in
            if error == nil {
                completionHandler()
                self?.allRules = domains
                self?.delegate?.listOfRulesChanged()
            }
            else {
                errorHandler(error?.localizedDescription ?? "")
            }
            
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
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
    private func importRules(_ plainText: String, errorHandler: @escaping (_ error: String)->Void) {
        
        let ruleStrings = plainText.components(separatedBy: .newlines)

        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }
            let rule = RuleInfo(trimmedRuleString, false, true, theme)
            allRules.append(rule)
        }

        setNewRules(completionHandler: {}) { (message) in
            errorHandler(message)
        }
    }
    
    private func setNewRules(completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
    
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.delegate?.listOfRulesChanged()
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }

                let objects = self.rulesToObjectsConverter(rules: self.allRules)
                self.safariProtection.add(rules: objects, for: .invertedAllowlist, override: true) { error in
                    
                    if error != nil {
                        DDLogError("(invertedSafariWhitelistModel) Error occured during content blocker reloading - \(error!.localizedDescription)")
                        // do not rollback changes and do not show any alert to user in this case
                        // https://github.com/AdguardTeam/AdguardForiOS/issues/1174
                    }
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                    completionHandler()
                }
            }
        }
    }
    
    private func changeInvertedSafariWhitelistRule(index: Int, text: String, enabled: Bool, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let domains = allRules
        domains[index].rule = text
        domains[index].enabled = enabled
        
        allRules = domains
        delegate?.listOfRulesChanged()
        
        let objects = rulesToObjectsConverter(rules: allRules)
        safariProtection.add(rules: objects, for: .invertedAllowlist, override: true) { error in
            if error != nil {
                DDLogError("(InvertedSafariWhitelistModel) changeInvertedSafariWhitelistRule - Error occured during content blocker reloading - \(error!.localizedDescription)")
                // do not rollback changes and do not show any alert to user in this case
                // https://github.com/AdguardTeam/AdguardForiOS/issues/1174
            }
        }
    }
    
    private func deleteInvertedSafariWhitelistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        var newAllRules = allRules
        let rule = newAllRules.remove(at: index)
        
        let oldRules = allRules
    
        allRules = newAllRules
        delegate?.listOfRulesChanged()
        
        safariProtection.removeRule(withText: rule.rule, for: .invertedAllowlist) { [weak self] error in
            if error == nil {
                completionHandler()
            }
            else {
                self?.allRules = oldRules
                self?.delegate?.listOfRulesChanged()
                errorHandler(error?.localizedDescription ?? "")
            }
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
    
    private func rulesToObjectsConverter(rules: [RuleInfo]) -> [UserRuleProtocol]{
        var objects: [UserRuleProtocol] = []
        for rule in rules {
            let object = UserRule(ruleText: rule.rule, isEnabled: rule.enabled)
            objects.append(object)
        }
        return objects
    }
}
