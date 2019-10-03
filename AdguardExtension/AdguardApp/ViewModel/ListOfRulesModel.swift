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

enum ListOfRulesType {
    case wifiExceptions, dnsWhiteList, dnsBlackList, safariUserFilter, safariWhiteList, invertedSafariWhiteList
}

class ListOfRulesModel: NSObject {
    /**
     array of all rules or filtered by @searchString array if search is active
    */
    @objc dynamic var listOfRules: [RuleInfo] {
        get {
            return (searchString == nil || searchString!.count == 0) ?
                allRules : searchRules
        }
    }
    
    @objc dynamic var searchString: String? {
        didSet {
            willChangeValue(for: \.listOfRules)
            searchRules = allRules.filter({ (ruleInfo) -> Bool in
                ruleInfo.attributedString = ruleInfo.rule.lowercased().highlight(search: [searchString?.lowercased()])
                return ruleInfo.rule.lowercased().contains(searchString?.lowercased())
            })
            didChangeValue(for: \.listOfRules)
        }
    }
    
    // MARK - private members
    private var allRules = [RuleInfo]()
    private var searchRules = [RuleInfo]()
    
    private let resources: AESharedResourcesProtocol
    private let contentBlockerService: ContentBlockerService
    private let antibanner: AESAntibannerProtocol
    private let themeService: ThemeServiceProtocol
    private let fileShare: FileShareServiceProtocol = FileShareService()
    private var dnsFiltersService: DnsFiltersServiceProtocol
    
    private var ruleObjects = [ASDFilterRule]()
    private var invertedWhitelistObject: AEInvertedWhitelistDomainsObject?
    
    private let dnsWhitelistPath = "dns_whitelist.txt"
    private let dnsBlacklistPath = "dns_blacklist.txt"
    private let wifiExceptionsPath = "wifi_exceptions.txt"

    var title: String {
        get {
            return getTitle()
        }
    }

    var exportTitle: String {
        get {
            return getExportTitle()
        }
    }

    var importTitle: String {
        get {
            return getImportTitle()
        }
    }

    var helperLabelText: String {
        get {
            return getHelperLabelText()
        }
    }
    
    var descriptionTitle: String {
        get {
            return getDescriptionText()
        }
    }

    private let listOfRulesType: ListOfRulesType
    var listType: ListOfRulesType {
        get {
            return listOfRulesType
        }
    }

    init(listOfRulesType: ListOfRulesType, resources: AESharedResourcesProtocol, contentBlockerService: ContentBlockerService, antibanner: AESAntibannerProtocol, theme: ThemeServiceProtocol, dnsFiltersService: DnsFiltersServiceProtocol) {
        
        self.listOfRulesType = listOfRulesType
        self.resources = resources
        self.contentBlockerService = contentBlockerService
        self.antibanner = antibanner
        self.themeService = theme
        self.dnsFiltersService = dnsFiltersService
        
        super.init()
        
        switch listOfRulesType {
        case .safariUserFilter:
            ruleObjects = antibanner.rules(forFilter: ASDF_USER_FILTER_ID as NSNumber)
            allRules = ruleObjects.map { RuleInfo($0.ruleText, false, themeService) }
        
        case .safariWhiteList:
            ruleObjects = resources.whitelistContentBlockingRules as? [ASDFilterRule] ?? [ASDFilterRule]()
            allRules = ruleObjects.map{
                let domainObject = AEWhitelistDomainObject(rule: $0)
                return RuleInfo(domainObject?.domain ?? "", false, themeService)
            }
        
        case .invertedSafariWhiteList:
            invertedWhitelistObject = resources.invertedWhitelistContentBlockingObject
            allRules = invertedWhitelistObject?.domains.map{ (rule) -> RuleInfo in
                RuleInfo(rule, false, themeService)
            } ?? [RuleInfo]()
            
        case .dnsBlackList:
            allRules = dnsFiltersService.userRules.map { RuleInfo($0, false, themeService) }
            
        case .dnsWhiteList:
            allRules = dnsFiltersService.whitelistDomains.map { RuleInfo($0, false, themeService) }
            
        case .wifiExceptions:
            allRules = [] // todo: get wifi exceptions
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
            if trimmed.count > 0 {
                rules.append(trimmed)
            }
        }
        
        if rules.count == 0 {
            return
        }
        
        switch listOfRulesType {
        case .safariUserFilter:
            addUserFilterRules(ruleTexts: rules, completionHandler: completionHandler, errorHandler: errorHandler)
        case .safariWhiteList:
            addSafariWhitelistDomain(domain: ruleText, completionHandler: completionHandler, errorHandler: errorHandler)
        case .invertedSafariWhiteList:
            addInvertedSafariWhitelistRule(ruleText: rules.first ?? "", completionHandler: completionHandler, errorHandler: errorHandler)
        case .dnsBlackList:
            dnsFiltersService.userRules = rules
        case .dnsWhiteList:
            dnsFiltersService.whitelistDomains = rules
        case .wifiExceptions:
            break // todo: save wifi exceptions
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
        
        switch listOfRulesType {
        case .safariUserFilter:
            changeSafariUserfilterRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
        case .safariWhiteList:
            changeSafariWhitelistRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
        case .invertedSafariWhiteList:
            changeInvertedSafariWhitelistRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
        case .dnsBlackList:
            changeDnsBlacklistRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
        case .dnsWhiteList:
            changeDnsWhitelistRule(index: index, text: newText, completionHandler: completionHandler, errorHandler: errorHandler)
            
        case .wifiExceptions:
            return // todo: change wifi exception
            
        }

    }
    
    /**
     adds array of rules to user filter and reloads safari content blockers
     */
    func addRules(ruleTexts: [String], errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        if listOfRulesType == .safariUserFilter {
            addUserFilterRules(ruleTexts: ruleTexts, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    /**
     removes rule from user filter and reloads safari content blockers
     */
    func deleteRule(index: Int, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        switch listOfRulesType {
        case .safariUserFilter:
            deleteUserfilterRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        case .safariWhiteList:
            deleteSafariWhitelistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        case .invertedSafariWhiteList:
            deleteInvertedSafariWhitelistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        case .dnsBlackList:
            deleteDnsBlacklistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        case .dnsWhiteList:
            deleteDnsWhitelistRule(index: index, completionHandler: completionHandler, errorHandler: errorHandler)
        case .wifiExceptions:
            break // todo: delete wifi exeption
        }
    }
    
    /**
     removes rule from list of rules and reloads safari content blockers
     */
    func deleteRule(_ rule: RuleInfo, errorHandler: @escaping (_ error: String)->Void, completionHandler: @escaping ()->Void) {
        
        guard let index = listOfRules.firstIndex(of: rule) else { return }
        
        deleteRule(index: index, errorHandler: errorHandler, completionHandler: completionHandler)
    }
    
    /**
     select or deselect all rules in  list of rules
     */
    func selectAllRules(_ select: Bool) {
        allRules.forEach({ $0.selected = select })
    }
    
    /**
     deletes selected rules from list of rules and reloads safari content blockers
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
     retuns all rules from list of rules as a plain text
     */
    func plainText() -> String {
        return allRules.map({ $0.rule }).joined(separator: "\n")
    }

    /**
     parse plain text to array of rules. Save it to list of rules and reload safari content blockers
    */
    func importRules(_ plainText: String, errorHandler: @escaping (_ error: String)->Void) {
        
        let ruleStrings = plainText.components(separatedBy: .newlines)
        
        var newRuleObjects = [ASDFilterRule]()
        var newRuleInfos = [RuleInfo]()
        var dnsAndWifiRules = [String]()
        
        for ruleString in ruleStrings {
            
            let trimmedRuleString = ruleString.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedRuleString.count == 0 {
                continue
            }
            
            var ruleObject: ASDFilterRule? = nil
            
            switch listOfRulesType {
            case .safariUserFilter:
                ruleObject = ASDFilterRule(text: trimmedRuleString, enabled: true)
            case .safariWhiteList:
                ruleObject = AEWhitelistDomainObject(domain: trimmedRuleString).rule
            case .invertedSafariWhiteList:
                ruleObject = AEWhitelistDomainObject(domain: trimmedRuleString).rule
            default:
                dnsAndWifiRules.append(trimmedRuleString)
                continue
            }
            
            let ruleInfo = RuleInfo(trimmedRuleString, false, themeService)
            guard let object = ruleObject else { return }
            newRuleObjects.append(object)
            newRuleInfos.append(ruleInfo)
        }
        
        switch listOfRulesType {
        case .safariUserFilter, .safariWhiteList, .invertedSafariWhiteList:
            setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: {
                
            }) { (message) in
                errorHandler(message)
            }
        
        case .dnsBlackList:
            dnsFiltersService.userRules = dnsAndWifiRules
        case .dnsWhiteList:
            dnsFiltersService.whitelistDomains = dnsAndWifiRules
        case .wifiExceptions:
            break // todo save wi-fi exceptions
        }
    }
    
    var listOfRulesEnabled: Bool {
        get {
            var key: String = ""
            switch listOfRulesType {
            case .safariUserFilter:
                key = AEDefaultsUserFilterEnabled
            case .safariWhiteList:
                key = AEDefaultsSafariWhitelistEnabled
            case .wifiExceptions:
                key = AEDefaultsWifiExceptionsEnabled
            case .invertedSafariWhiteList:
                key = AEDefaultsSafariWhitelistEnabled
            case .dnsWhiteList:
                key = AEDefaultsDnsWhitelistEnabled
            case .dnsBlackList:
                key = AEDefaultsDnsBlacklistEnabled
            }
            
            return resources.sharedDefaults().object(forKey: key) as? Bool ?? true
        }
        
        set {
            if listOfRulesEnabled != newValue {
                var key: String = ""
                switch listOfRulesType {
                case .safariUserFilter:
                    key = AEDefaultsUserFilterEnabled
                case .safariWhiteList:
                    key = AEDefaultsSafariWhitelistEnabled
                case .wifiExceptions:
                    key = AEDefaultsWifiExceptionsEnabled
                case .invertedSafariWhiteList:
                    key = AEDefaultsSafariWhitelistEnabled
                case .dnsWhiteList:
                    key = AEDefaultsDnsWhitelistEnabled
                case .dnsBlackList:
                    key = AEDefaultsDnsBlacklistEnabled
                }
                
                resources.sharedDefaults().set(newValue, forKey: key)
                contentBlockerService.reloadJsons(backgroundUpdate: false) {_ in }
            }
        }
    }
    
    func exportList(parentController: UIViewController, sourceView: UIView, sourceRect: CGRect){
        var fileName = ""
        switch listOfRulesType{
        case .safariUserFilter:
            fileName = "adguard_user_filter.txt"
        case .safariWhiteList:
            fileName = "adguard_whitelist.txt"
        case .invertedSafariWhiteList:
            fileName = "adguard_inverted_whitelist.txt"
        case .dnsWhiteList:
            fileName = dnsWhitelistPath
        case .dnsBlackList:
            fileName = dnsBlacklistPath
        case .wifiExceptions:
            fileName = wifiExceptionsPath
        }
        
        fileShare.exportFile(parentController: parentController, sourceView: sourceView, sourceRect: sourceRect, filename: fileName, text: plainText()) { (message) in
        }
    }
    
    func importList(parentController: UIViewController){
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
    
    // MARK: - Private methods
    
    // MARK: - Methods to add rules
    
    private func addSafariWhitelistDomain(domain: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
                        
        let rulesCopy = allRules
        let objectsCopy = ruleObjects
        
        let newRules = allRules + [RuleInfo(domain, false, themeService)]
        let newRuleObjects = ruleObjects + [AEWhitelistDomainObject(domain: domain).rule]
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.willChangeValue(for: \.listOfRules)
            
            strongSelf.allRules = newRules
            strongSelf.ruleObjects = newRuleObjects
            
            strongSelf.didChangeValue(for: \.listOfRules)
        
            strongSelf.contentBlockerService.addWhitelistDomain(domain) { [weak self] (error) in
                DispatchQueue.main.async {
                    if error == nil {
                        completionHandler()
                    }
                    else {
            
                        self?.willChangeValue(for: \.listOfRules)
                        self?.allRules = rulesCopy
                        self?.ruleObjects = objectsCopy
                        self?.didChangeValue(for: \.listOfRules)
                       
                        errorHandler(error!.localizedDescription)
                    }
                    
                    UIApplication.shared.endBackgroundTask(backgroundTaskId)
                }
            }
        }
    }
    
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
            
            newRuleInfos.append(contentsOf: ruleTextsToAdd.map({ (rule) -> RuleInfo in RuleInfo(rule, false, strongSelf.themeService) }))
            newRuleObjects.append(contentsOf: rulesToAdd)
            
            strongSelf.setNewRules(newRuleObjects, ruleInfos: newRuleInfos, completionHandler: completionHandler, errorHandler: errorHandler)
        }
    }
    
    private func addInvertedSafariWhitelistRule(ruleText: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void){
        
        let domainObject = AEWhitelistDomainObject(domain: ruleText)
                        
        if !contentBlockerService.validateRule(domainObject.rule.ruleText) {
           errorHandler(ACLocalizedString("rule_converting_error", nil))
           return
        }
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        var domains = allRules
        domains.append(RuleInfo(ruleText, false, themeService))
        
        willChangeValue(for: \.listOfRules)
        allRules = domains
        didChangeValue(for: \.listOfRules)
        
        contentBlockerService.addInvertedWhitelistDomain(ruleText) { (error) in
            DispatchQueue.main.async {
                [weak self] in
                if error == nil {
                    completionHandler()
                    self?.willChangeValue(for: \.listOfRules)
                    self?.allRules = domains
                    self?.didChangeValue(for: \.listOfRules)
                }
                else {
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    // MARK: - Methods to work with files
    
    private func getStringFrom(path: URL) -> String? {
        do {
            let domains = try String(contentsOf: path, encoding: .utf8)
            return domains
        }
        catch {
            DDLogError("Error getting domains from dns whitelist: \(error.localizedDescription)")
        }
        return ""
    }
    
    private func saveStringTo(path: URL, string: String){
        do {
            try string.write(to: path, atomically: false, encoding: .utf8)
        }
        catch {
            DDLogError("Error saving domains to dns whitelist: \(error.localizedDescription)")
        }
    }
    
    // NEEDS TO BE CHANGED
    private func setNewRules(_ newRuleObjects: [ASDFilterRule], ruleInfos: [RuleInfo], completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
    
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let rulesCopy = strongSelf.allRules
            let objectsCopy = strongSelf.ruleObjects
            
            strongSelf.willChangeValue(for: \.listOfRules)
            
            strongSelf.allRules = ruleInfos
            strongSelf.ruleObjects = newRuleObjects
            
            strongSelf.didChangeValue(for: \.listOfRules)
            
            DispatchQueue.global().async { [weak self] in
                guard let strongSelf = self else { return }
                
                switch (strongSelf.listOfRulesType) {
                case .safariUserFilter:
                    if let error = strongSelf.contentBlockerService.replaceUserFilter(newRuleObjects) {
                        DispatchQueue.main.async {
                            strongSelf.willChangeValue(for: \.listOfRules)
                            strongSelf.allRules = rulesCopy
                            strongSelf.ruleObjects = objectsCopy
                            strongSelf.didChangeValue(for: \.listOfRules)
                            errorHandler(error.localizedDescription)
                        }
                        return
                    }
                case .safariWhiteList:
                    strongSelf.resources.whitelistContentBlockingRules = (strongSelf.ruleObjects as NSArray).mutableCopy() as? NSMutableArray
                case .invertedSafariWhiteList:
                    let invertedWhitelistObject = AEInvertedWhitelistDomainsObject(domains: strongSelf.allRules.map({ $0.rule }))
                    strongSelf.resources.invertedWhitelistContentBlockingObject = invertedWhitelistObject
                default:
                    return
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
    
    private func changeSafariWhitelistRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        let oldRuleObject = ruleObjects[index]
        let oldRule = allRules[index]
        
        contentBlockerService.replaceWhitelistDomain(listOfRules[index].rule, with: text) { (error) in
            oldRule.rule = text
            oldRuleObject.ruleText = text
            
            completionHandler()
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
        }
    }
    
    private func changeInvertedSafariWhitelistRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        let domains = allRules
        domains[index].rule = text
        
        willChangeValue(for: \.listOfRules)
        allRules = domains
        didChangeValue(for: \.listOfRules)
        
        let invertedWhitelistObject = AEInvertedWhitelistDomainsObject(domains: domains.map({ $0.rule }))
        resources.invertedWhitelistContentBlockingObject = invertedWhitelistObject
        
        contentBlockerService.reloadJsons(backgroundUpdate: false) {(error)  in
            
            DispatchQueue.main.async {
                if error == nil {
                    completionHandler()
                }
                else {
                    DDLogError("(UserFilterViewModel) changeInvertedWhitelistRule - Error occured during content blocker reloading.")
                    // do not rollback changes and do not show any alert to user in this case
                    // https://github.com/AdguardTeam/AdguardForiOS/issues/1174
                    completionHandler()
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    private func deleteUserfilterRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let rule = self.listOfRules[index]
        guard let index = allRules.firstIndex(of: rule) else { return }
        
        let ruleObject = ruleObjects[index]
        
        let filteredRules = allRules.filter({$0 != rule})
        let filteredRuleObjects = ruleObjects.filter({$0 != ruleObject})
        
        setNewRules(filteredRuleObjects, ruleInfos: filteredRules, completionHandler: completionHandler, errorHandler: errorHandler)
    }
    
    private func deleteSafariWhitelistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void){
        
        let oldRules = allRules
        let oldRuleObjects = ruleObjects
        
        let domain = listOfRules[index].rule
        willChangeValue(for: \.listOfRules)
        allRules.remove(at: index)
        ruleObjects.remove(at: index)
        didChangeValue(for: \.listOfRules)
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        contentBlockerService.removeWhitelistDomain(domain) { (error) in
            
            DispatchQueue.main.async {
                if error == nil {
                    completionHandler()
                }
                else {
                    self.willChangeValue(for: \.listOfRules)
                    self.allRules = oldRules
                    self.ruleObjects = oldRuleObjects
                    self.didChangeValue(for: \.listOfRules)
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    private func deleteInvertedSafariWhitelistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        var newAllRules = allRules
        let rule = newAllRules.remove(at: index)
        
        let oldRules = allRules
        
        willChangeValue(for: \.listOfRules)
        allRules = newAllRules
        didChangeValue(for: \.listOfRules)
        
        contentBlockerService.removeInvertedWhitelistDomain(rule.rule) { (error) in
            DispatchQueue.main.async {
                [weak self] in
                if error == nil {
                    completionHandler()
                }
                else {
                    self?.willChangeValue(for: \.listOfRules)
                    self?.allRules = oldRules
                    self?.didChangeValue(for: \.listOfRules)
                    errorHandler(error?.localizedDescription ?? "")
                }
                
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
            }
        }
    }
    
    private func changeDnsBlacklistRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        allRules[index].rule = text
        dnsFiltersService.userRules = allRules.map { $0.rule }
        
        completionHandler()
    }
    
    private func changeDnsWhitelistRule(index: Int, text: String, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        allRules[index].rule = text
        dnsFiltersService.whitelistDomains = allRules.map { $0.rule }
        
        completionHandler()
    }
    
    private func deleteDnsBlacklistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        allRules.remove(at: index)
        dnsFiltersService.userRules = allRules.map { $0.rule }
        
        completionHandler()
    }
    
    private func deleteDnsWhitelistRule(index: Int, completionHandler: @escaping ()->Void, errorHandler: @escaping (_ error: String)->Void) {
        
        allRules.remove(at: index)
        dnsFiltersService.whitelistDomains = allRules.map { $0.rule }
        
        completionHandler()
    }
}

extension ListOfRulesModel {

    // MARK: - Methods to get strings

    private func getTitle() -> String {
        switch listOfRulesType {
            case .wifiExceptions:
            return ACLocalizedString("wifi_exceptions_title", nil)

            case .dnsWhiteList:
            return ACLocalizedString("whitelist_title", nil)

            case .dnsBlackList:
            return ACLocalizedString("dns_blacklist_title", nil)

            case .safariUserFilter:
            return ACLocalizedString("safari_userfilter_title", nil)

            case .safariWhiteList:
            return ACLocalizedString("whitelist_title", nil)

            case .invertedSafariWhiteList:
            return ACLocalizedString("inverted_whitelist_title", nil)
        }
    }

    private func getExportTitle() -> String {
        switch listOfRulesType {
            case .wifiExceptions:
            return ACLocalizedString("export", nil)

            case .dnsWhiteList:
            return ACLocalizedString("export_whitelist", nil)

            case .dnsBlackList:
            return ACLocalizedString("export", nil)

            case .safariUserFilter:
            return ACLocalizedString("export", nil)

            case .safariWhiteList:
            return ACLocalizedString("export_whitelist", nil)

            case .invertedSafariWhiteList:
            return ACLocalizedString("export", nil)
        }
    }

    private func getImportTitle() -> String {
        switch listOfRulesType {
            case .wifiExceptions:
            return ACLocalizedString("import", nil)

            case .dnsWhiteList:
            return ACLocalizedString("import_whitelist", nil)

            case .dnsBlackList:
            return ACLocalizedString("import", nil)

            case .safariUserFilter:
            return ACLocalizedString("import", nil)

            case .safariWhiteList:
            return ACLocalizedString("import_whitelist", nil)

            case .invertedSafariWhiteList:
            return ACLocalizedString("import", nil)
        }
    }

    // TODO: - NEEDS TO ADD STRINGS
    private func getHelperLabelText() -> String {
        switch listOfRulesType {
            case .wifiExceptions:
            return ACLocalizedString("wifi_exceptions_helper", nil)

            case .dnsWhiteList:
            return ACLocalizedString("dns_whitelist_helper", nil)

            case .dnsBlackList:
            return ACLocalizedString("dns_blacklist_helper", nil)

            case .safariUserFilter:
            return ACLocalizedString("user_filter_helper", nil)

            case .safariWhiteList:
            return ACLocalizedString("whitelist_helper", nil)

            case .invertedSafariWhiteList:
            return ACLocalizedString("whitelist_helper", nil)
        }
    }
    
    private func getDescriptionText() -> String {
        switch listOfRulesType {
            case .wifiExceptions:
            return ACLocalizedString("wifi_exceptions_text", nil)

            case .dnsWhiteList:
            return ACLocalizedString("dns_whitelist_text", nil)

            case .dnsBlackList:
            return ACLocalizedString("dns_blacklist_text", nil)

            case .safariUserFilter:
            return ACLocalizedString("blacklist_text_format", nil)

            case .safariWhiteList:
            return ACLocalizedString("whitelist_text", nil)

            case .invertedSafariWhiteList:
            return ACLocalizedString("inverted_whitelist_text", nil)
        }
    }
}
