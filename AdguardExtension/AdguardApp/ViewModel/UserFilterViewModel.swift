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

// MARK: - data types -

enum UserFilterType {
    case blacklist
    case whitelist
    case invertedWhitelist
}

class RuleInfo: NSObject {
    var rule: String
    var selected: Bool
    
    init(_ rule: String, _ selected: Bool) {
        self.rule = rule
        self.selected = selected
        super.init()
    }
}

// MARK: - UserFilterViewModel -
/**
 UserFilterViewModel - view model for UserFilterController
 */
class UserFilterViewModel: NSObject {
    
    // MARK - public fields
    
    var type: UserFilterType
    
    /**
     array of all rules or filtered by @searchString array if search is active
    */
    @objc dynamic var rules: [RuleInfo] {
        get {
            return (searchString == nil || searchString!.count == 0) ?
                allRules : searchRules
        }
    }
    
    // MARK - private members
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    @objc dynamic var searchString: String? {
        didSet {
            willChangeValue(for: \.rules)
            searchRules = allRules.filter({ (ruleInfo) -> Bool in
                return ruleInfo.rule.lowercased().contains(searchString?.lowercased())
            })
            didChangeValue(for: \.rules)
        }
    }
    
    private var resources: AESharedResourcesProtocol
    private var contentBlockerService: ContentBlockerService
    private var antibanner: AESAntibannerProtocol
    
    private var ruleObjects = [ASDFilterRule]()
    private var invertedWhitelistObject: AEInvertedWhitelistDomainsObject?
    
    // MARK: - init
    
    init(_ type: UserFilterType, resources: AESharedResourcesProtocol, contentBlockerService: ContentBlockerService, antibanner: AESAntibannerProtocol) {
        
        self.type = type
        self.resources = resources
        self.contentBlockerService = contentBlockerService
        self.antibanner = antibanner
        
        super.init()
        
        switch type {
        case .blacklist:
            ruleObjects = antibanner.rules(forFilter: ASDF_USER_FILTER_ID as NSNumber)
            allRules = ruleObjects.map({ RuleInfo($0.ruleText, false) })
            
        case .whitelist:
            ruleObjects = resources.whitelistContentBlockingRules as? [ASDFilterRule] ?? [ASDFilterRule]()
            allRules = ruleObjects.map({
                let domainObject = AEWhitelistDomainObject(rule: $0)
                return RuleInfo(domainObject?.domain ?? "", false)
            })
            
        case .invertedWhitelist:
            invertedWhitelistObject = resources.invertedWhitelistContentBlockingObject
            allRules = invertedWhitelistObject?.domains.map({ (rule) -> RuleInfo in
                RuleInfo(rule, false)
            }) ?? [RuleInfo]()
        }
    }
    
    // MARK: - public methods
    /**
     adds rule with @ruleText to user filter and reloads safari content blockers
     */
    func addRule(ruleText: String, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        if ruleText.count == 0 { return }
        
        let components = ruleText.components(separatedBy: .newlines)
        
        var rules: [String] = []
        
        for component in components {
            let trimmed = component.trimmingCharacters(in: .whitespaces)
            if trimmed.count > 0 && !trimmed.starts(with: "!") {
                rules.append(trimmed)
            }
        }
        
        if rules.count == 0 {
            return
        }
        
        switch type {
        case .blacklist:
            addBlacklistRules(ruleTexts: rules, completionHandler: completionHandler, errorHandler: errorHandler)
        case .whitelist:
            addWhitelistRule(ruleText: rules.first ?? "", completionHandler: completionHandler, errorHandler: errorHandler)
        case .invertedWhitelist:
            addInvertedWhitelstRule(ruleText: rules.first ?? "", completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    /**
     change @rule in user filter and reloads safari content blockers
     */
    func changeRule(rule: RuleInfo, newText: String, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        guard let index = allRules.firstIndex(of: rule) else {
            DDLogError("(UserFilterViewModel) change rule failed - rule not found")
            return
        }
        
        switch type {
        case .blacklist:
            changeBlacklistRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
        case .whitelist:
            changeWhitelistRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
        case .invertedWhitelist:
            changeInvertedWhitelistRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    /**
     adds array of rules to user filter and reloads safari content blockers
     */
    func addRules(ruleTexts: [String], errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        if type == .blacklist {
            addBlacklistRules(ruleTexts: ruleTexts, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    /**
     removes rule from user filter and reloads safari content blockers
     */
    func deleteRule(index: Int, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        switch type {
        case .blacklist:
            deleteBlacklistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        case .whitelist:
            deleteWhitelistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        case .invertedWhitelist:
            deleteInvertedWhitelistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    /**
     removes rule from user filter and reloads safari content blockers
     */
    func deleteRule(_ rule: RuleInfo, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        
        guard let index = rules.firstIndex(of: rule) else { return }
        
        deleteRule(index: index, errorHandler: errorHandler, completionHandler: completionHandler)
    }
    
    /**
     returns localized caption for "add a rule" button
     */
    func addRuleTitle()->String {
        
        if type == .blacklist {
            return ACLocalizedString("add_blacklist_rule_title", "")
        }
        else {
            return ACLocalizedString("add_whitelist_domain_title", "")
        }
    }
    
    /**
     select or deselect all rules in user filter
     */
    func selectAllRules(_ select: Bool) {
        allRules.forEach({ $0.selected = select })
    }
    
    /**
     deletes selected rules from user filter and reloads safari content blockers
     */
    func deleteSelected(completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        var newRuleObjects = [ASDFilterRule]()
        var newRuleInfos = [RuleInfo]()
        
        for (index, ruleInfo) in allRules.enumerated() {
            if !ruleInfo.selected {
                newRuleObjects.append(ruleObjects[index])
                newRuleInfos.append(allRules[index])
            }
        }
        
        setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    /**
     retuns all rules from user filter as a plain text
     */
    func plainText() -> String {
        return allRules.map({ $0.rule }).joined(separator: "\n")
    }
    
    /**
     parse plain text to array of rules. Save it to user filter and reload safari content blockers
    */
    func importRules(_ plainText: String, errorHandler: @escaping (_ error: String)->Void) {
        
        let ruleStrings = plainText.components(separatedBy: .newlines)
        
        var newRuleObjects = [ASDFilterRule]()
        var newRuleInfos = [RuleInfo]()
        for ruleString in ruleStrings {
            if ruleString.starts(with: "!") {
                continue
            }
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }
            
            let ruleObjectOpt = type == .blacklist ?
                                        ASDFilterRule(text: trimmedRuleString, enabled: true) :
                                        AEWhitelistDomainObject(domain: trimmedRuleString)?.rule
            
            guard let ruleObject = ruleObjectOpt else { continue }
            
            let ruleInfo = RuleInfo(trimmedRuleString, false)
            
            newRuleObjects.append(ruleObject)
            newRuleInfos.append(ruleInfo)
        }
        
        setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: {
            
        }) { (message) in
            errorHandler(message)
        }
    }
    
    // MARK: - private methods
    
    func addWhitelistRule(ruleText: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        let domainObject = AEWhitelistDomainObject(domain: ruleText)
        guard let ruleObject = domainObject?.rule else { return }
        
        let rulesCopy = allRules
        let objectsCopy = ruleObjects
        
        let newRules = allRules + [RuleInfo(ruleText, false)]
        let newRuleObjects = ruleObjects + [ruleObject]
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.willChangeValue(for: \.rules)
            
            strongSelf.allRules = newRules
            strongSelf.ruleObjects = newRuleObjects
            
            strongSelf.didChangeValue(for: \.rules)
        
            strongSelf.contentBlockerService.addWhitelistRule(ruleObject) { [weak self] (error) in
                DispatchQueue.main.async {
                    if error == nil {
                        completionHandler()
                    }
                    else {
            
                        self?.willChangeValue(for: \.rules)
                        self?.allRules = rulesCopy
                        self?.ruleObjects = objectsCopy
                        self?.didChangeValue(for: \.rules)
                       
                        errorHandler(error!.localizedDescription)
                    }
                    
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                }
            }
        }
    }
    
    func addBlacklistRules(ruleTexts: [String], completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
            var rulesToAdd = [ASDFilterRule]()
            var ruleTextsToAdd = [String]()
            ruleTexts.forEach({ (ruteText) in
                let rule = ASDFilterRule(text: ruteText, enabled: true)
                rulesToAdd.append(rule)
                ruleTextsToAdd.append(ruteText)
            })
            
            if rulesToAdd.count == 0 {
                
                DispatchQueue.main.async {
                    let errorDescription = ACLocalizedString("filter_rules_converting_error", nil)
                    errorHandler(errorDescription)
                }
                return
            }
            
            var newRuleObjects = Array(strongSelf.ruleObjects)
            var newRuleInfos = Array(strongSelf.allRules)
            
            newRuleInfos.append(contentsOf: ruleTextsToAdd.map({ (rule) -> RuleInfo in RuleInfo(rule, false) }))
            newRuleObjects.append(contentsOf: rulesToAdd)
            
            strongSelf.setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    func addInvertedWhitelstRule(ruleText: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void){
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        var domains = allRules
        domains.append(RuleInfo(ruleText, false))
        
        contentBlockerService.addInvertedWhitelistDomain(ruleText) { (error) in
            DispatchQueue.main.async {
                [weak self] in
                if error == nil {
                    completionHandler()
                    self?.willChangeValue(for: \.rules)
                    self?.allRules = domains
                    self?.didChangeValue(for: \.rules)
                }
                else {
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    func setNewRules(_ newRuleObjects: [ASDFilterRule], ruleInfos: [RuleInfo], completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
    
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let rulesCopy = strongSelf.allRules
            let objectsCopy = strongSelf.ruleObjects
            
            strongSelf.willChangeValue(for: \.rules)
            
            strongSelf.allRules = ruleInfos
            strongSelf.ruleObjects = newRuleObjects
            
            strongSelf.didChangeValue(for: \.rules)
            
            DispatchQueue.global().async { [weak self] in
                guard let strongSelf = self else { return }
                
                switch (strongSelf.type) {
                case .blacklist:
                    if let error = strongSelf.contentBlockerService.replaceUserFilter(newRuleObjects) {
                        DispatchQueue.main.async {
                            strongSelf.willChangeValue(for: \.rules)
                            strongSelf.allRules = rulesCopy
                            strongSelf.ruleObjects = objectsCopy
                            strongSelf.didChangeValue(for: \.rules)
                            errorHandler(error.localizedDescription)
                        }
                        return
                    }
                case .whitelist:
                    strongSelf.resources.whitelistContentBlockingRules = (strongSelf.ruleObjects as NSArray).mutableCopy() as? NSMutableArray
                case .invertedWhitelist:
                    let invertedWhitelistObject = AEInvertedWhitelistDomainsObject(domains: strongSelf.allRules.map({ $0.rule }))
                    strongSelf.resources.invertedWhitelistContentBlockingObject = invertedWhitelistObject
                }
                
                completionHandler()
                
                strongSelf.contentBlockerService.reloadJsons(backgroundUpdate: false) { (error) in
                    
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                    
                    if error != nil {
                        DispatchQueue.main.async {
                            DDLogError("(UserFilterViewModel) setNewRules failed: \(error!.localizedDescription)")
                            errorHandler(ACLocalizedString("safari_filters_loading_error", nil))
                            
                            // rolback changes
                            let _ = strongSelf.contentBlockerService.replaceUserFilter(objectsCopy)
                            strongSelf.willChangeValue(for: \.rules)
                            strongSelf.allRules = rulesCopy
                            strongSelf.ruleObjects = objectsCopy
                            strongSelf.didChangeValue(for: \.rules)
                        }
                    }
                    else {
                    
                    }
                }
            }
        }
    }
    
    func deleteBlacklistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let rule = self.rules[index]
        guard let index = allRules.firstIndex(of: rule) else { return }
        
        let ruleObject = ruleObjects[index]
        
        let filteredRules = allRules.filter({$0 != rule})
        let filteredRuleObjects = ruleObjects.filter({$0 != ruleObject})
        
        setNewRules(filteredRuleObjects, ruleInfos: filteredRules, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func deleteWhitelistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void){
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        contentBlockerService.removeWhitelistRule(ruleObjects[index]) { (error) in
            
            DispatchQueue.main.async {
                if error == nil {
                    self.willChangeValue(for: \.rules)
                    self.allRules.remove(at: index)
                    self.ruleObjects.remove(at: index)
                    self.didChangeValue(for: \.rules)
                    completionHandler()
                }
                else {
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    func deleteInvertedWhitelistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        var newAllRules = allRules
        let rule = newAllRules.remove(at: index)
        
        contentBlockerService.removeInvertedWhitelistDomain(rule.rule) { (error) in
            DispatchQueue.main.async {
                [weak self] in
                if error == nil {
                    completionHandler()
                    self?.willChangeValue(for: \.rules)
                    self?.allRules = newAllRules
                    self?.didChangeValue(for: \.rules)
                }
                else {
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    func changeBlacklistRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let ruleObject = ruleObjects[index]
        let rule = allRules[index]
        
        rule.rule = text
        ruleObject.ruleText = text
        
        setNewRules(ruleObjects, ruleInfos: allRules, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    func changeWhitelistRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        let oldRuleObject = ruleObjects[index]
        let oldRule = allRules[index]
        
        let newDomainObject = AEWhitelistDomainObject(domain: text)
        guard let newRuleObject = newDomainObject?.rule else {
            errorHandler(ACLocalizedString("whitelist_rule_creation_failure", nil))
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            return
        }
        
        contentBlockerService.replaceWhitelistRule(oldRuleObject, with: newRuleObject) { (error) in
            oldRule.rule = text
            oldRuleObject.ruleText = text
            
            completionHandler()
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
    }
    
    func changeInvertedWhitelistRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        var domains = allRules
        domains[index].rule = text
        
        let invertedWhitelistObject = AEInvertedWhitelistDomainsObject(domains: domains.map({ $0.rule }))
        resources.invertedWhitelistContentBlockingObject = invertedWhitelistObject
        
        contentBlockerService.reloadJsons(backgroundUpdate: false) { [weak self] (error)  in
            
            DispatchQueue.main.async {
                if error == nil {
                    completionHandler()
                    self?.willChangeValue(for: \.rules)
                    self?.allRules = domains
                    self?.didChangeValue(for: \.rules)
                }
                else {
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
}
