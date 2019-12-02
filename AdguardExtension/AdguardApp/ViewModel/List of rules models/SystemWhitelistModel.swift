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
    
    var type: RulesType = .systemWhitelist
    
    var enabled: Bool {
        get {
            return resources.sharedDefaults().bool(forKey: AEDefaultsDnsWhitelistEnabled)
        }
        set{
            if enabled != newValue{
                resources.sharedDefaults().set(newValue, forKey: AEDefaultsDnsWhitelistEnabled)
                vpnManager.restartTunnel()
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
    private var dnsFiltersService: DnsFiltersServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let theme: ThemeServiceProtocol
    private let vpnManager: APVPNManager
    private let fileShare: FileShareServiceProtocol = FileShareService()
    
    /* Variables */
    private let fileName = "dns_whitelist.txt"
    
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    // MARK: - Initializer
    
    init(dnsFiltersService: DnsFiltersServiceProtocol, resources: AESharedResourcesProtocol, theme: ThemeServiceProtocol, vpnManager: APVPNManager) {
        self.dnsFiltersService = dnsFiltersService
        self.resources = resources
        self.theme = theme
        self.vpnManager = vpnManager
        
        // Needs to be changed
        // dnsFiltersService must store rules as [RuleInfo] because we need to know their state
        // for now it is always initialized with true
        allRules = dnsFiltersService.whitelistDomains.map { RuleInfo($0, false, true, theme) }
    }
    
    // MARK: - Main functions
    
    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect) {
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
    
    
    func addRule(ruleText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
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
        
        dnsFiltersService.whitelistDomains.append(contentsOf: rules)
        
        allRules.append(contentsOf: rules.map { RuleInfo($0, false, true, theme) })
            
        delegate?.listOfRulesChanged()
    }
    
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        guard let index = allRules.firstIndex(of: rule) else {
            DDLogError("(UserFilterViewModel) change rule failed - rule not found")
            return
        }
    
        allRules[index].rule = newText
        dnsFiltersService.whitelistDomains = allRules.map { $0.rule }
           
        completionHandler()
        delegate?.listOfRulesChanged()
    }

    func selectAllRules() {
        allRules.forEach({ $0.selected = true })
    }
    
    func deleteSelectedRules(completionHandler: @escaping () -> Void, errorHandler: @escaping (String) -> Void) {
        var newRules = [RuleInfo]()
        for rule in allRules {
            if !rule.selected {
                newRules.append(rule)
            }
        }
        allRules = newRules
        dnsFiltersService.whitelistDomains = allRules.map({ $0.rule })
        
        delegate?.listOfRulesChanged()
    }
    
    func delete(rule: RuleInfo, errorHandler: @escaping (String) -> Void, completionHandler: @escaping () -> Void) {
        
        guard let index = allRules.firstIndex(of: rule) else { return }
        if let indexWhileSearching = searchRules.firstIndex(of: rule){
            searchRules.remove(at: indexWhileSearching)
        }
        
        allRules.remove(at: index)
        dnsFiltersService.whitelistDomains = allRules.map { $0.rule }
        
        delegate?.listOfRulesChanged()
        completionHandler()
    }
    
    func processRulesFromString(_ string: String, errorHandler: @escaping (String) -> Void) {
        // Unrealized method
    }
    
    // MARK: - Private methods
    
    /**
     retuns all rules from list of rules as a plain text
     */
    func plainText() -> String {
        return allRules.map({ $0.rule }).joined(separator: "\n")
    }
    
    /**
     parse plain text to array of rules. Save it to list of rules and reload safari content blockers
    */
    private func importRules(_ plainText: String, errorHandler: @escaping (_ error: String)->Void) {
        
        let ruleStrings = plainText.components(separatedBy: .newlines)
        
        var newRules = [String]()
        
        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }
            
            newRules.append(trimmedRuleString)
        }
        dnsFiltersService.whitelistDomains = newRules
        allRules = newRules.map { RuleInfo($0, false, true, theme) }
        delegate?.listOfRulesChanged()
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
