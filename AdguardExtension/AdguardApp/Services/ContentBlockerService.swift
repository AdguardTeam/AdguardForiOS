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

// MARK: - service protocol
/**
 ContentBlockerService is responsible for the composition of safari content blocker rules files
 */
protocol ContentBlockerServiceProtocol {
    /**
     recompile all content blocker files and reloads it to safari
    */
    func reloadJsons(backgroundUpdate: Bool, completion:@escaping (Error?)->Void)
    
    /**
     validates rule text
     It returns true if rule can be converted to safari content blocker rule by converter, false for unsupported rules
     */
    func validateRule(_ ruleText: String)->Bool
}

@objc
class ContentBlockerService: NSObject, ContentBlockerServiceProtocol {
    
    @objc
    var antibanner: AESAntibannerProtocol?
    
    // MARK: - error constants
    static let contentBlockerServiceErrorDomain = "ContentBlockerServiceErrorDomain"
    static let contentBlockerConverterErrorCode = 1
    static let contentBlockerDBErrorCode = 2
    
    // MARK: - private properties
    private var resources: AESharedResourcesProtocol
    private var safariService: SafariServiceProtocol
    private var rulesProcessor: RulesProcessorProtocol = RulesProcessor()
    
    private let workQueue = DispatchQueue(label: "content_blocker")
    
    static let groupsByContentBlocker: [ContentBlockerType: [Int]] =
            [.general:                      [FilterGroupId.ads, FilterGroupId.languageSpecific, FilterGroupId.user],
             .privacy:                      [FilterGroupId.privacy, FilterGroupId.user],
             .socialWidgetsAndAnnoyances:   [FilterGroupId.socialWidgets, FilterGroupId.annoyances, FilterGroupId.user],
             .other:                        [FilterGroupId.other, FilterGroupId.user],
             .custom:                       [FilterGroupId.custom, FilterGroupId.user],
             .security:                     [FilterGroupId.security, FilterGroupId.user]
            ]
    
    static let defaultsCountKeyByBlocker: [ContentBlockerType: String] = [
        .general:                       AEDefaultsGeneralContentBlockerRulesCount,
        .privacy:                       AEDefaultsPrivacyContentBlockerRulesCount,
        .socialWidgetsAndAnnoyances:    AEDefaultsSocialContentBlockerRulesCount,
        .other:                         AEDefaultsOtherContentBlockerRulesCount,
        .custom:                        AEDefaultsCustomContentBlockerRulesCount,
        .security:                      AEDefaultsSecurityContentBlockerRulesCount
    ]
    
    static let defaultsOverLimitCountKeyByBlocker: [ContentBlockerType: String] = [
        .general:                       AEDefaultsGeneralContentBlockerRulesOverLimitCount,
        .privacy:                       AEDefaultsPrivacyContentBlockerRulesOverLimitCount,
        .socialWidgetsAndAnnoyances:    AEDefaultsSocialContentBlockerRulesOverLimitCount,
        .other:                         AEDefaultsOtherContentBlockerRulesOverLimitCount,
        .custom:                        AEDefaultsCustomContentBlockerRulesOverLimitCount,
        .security:                      AEDefaultsSecurityContentBlockerRulesOverLimitCount
    ]
    
    // MARK: - init
    init(resources: AESharedResourcesProtocol, safariService: SafariServiceProtocol) {
        self.resources = resources
        self.safariService = safariService
        super.init()
    }
    
    // MARK: - public methods
    @objc
    func reloadJsons(backgroundUpdate: Bool, completion:@escaping (Error?)->Void) {
        
#if !APP_EXTENSION
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
#endif
        
        workQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            if let error = sSelf.updateContentBlockers() {
#if !APP_EXTENSION
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
#endif
                completion(error)
                return
            }
            
            sSelf.safariService.invalidateBlockingJsons(completion: { (error) in
                sSelf.finishReloadingConetentBlocker(completion: completion, error: error)
#if !APP_EXTENSION
                UIApplication.shared.endBackgroundTask(backgroundTaskId)
#endif
            })
        }
    }
    
    func validateRule(_ ruleText: String) -> Bool {
        
        let trimmedRule = ruleText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedRule.count == 0 {
            return false
        }
        
        if  trimmedRule.contains(OLD_INJECT_RULES) ||
            trimmedRule.contains(MASK_CONTENT_RULE) ||
            trimmedRule.contains(MASK_CONTENT_EXCEPTION_RULE) ||
            trimmedRule.contains(MASK_JS_RULE) ||
            trimmedRule.contains(MASK_FILTER_UNSUPPORTED_RULE){
            return false
        }
        
        return true
    }

    // MARK: - whitelist operations
    
    /**
     Adds whitelist domain, modifies content blocking JSONs
     and replaces these JSONs in shared resources asynchronously.
     Method performs completionBlock when done on service working queue.
     */
    func addWhitelistDomain(_ domain: String, completion: @escaping (Error?)->Void) {
        
        processWhitelistDomain(domain, completion: completion, processRules: {(rules) in
            let rule = AEWhitelistDomainObject(domain: domain).rule
            return (rules + [rule], true)
        }, processData: { [weak self] (jsonData, jsonRuleData, contentBlocker) in
            guard let sSelf = self else { return Data() }
            
            let converted = sSelf.resources.sharedDefaults().integer(forKey: ContentBlockerService.defaultsCountKeyByBlocker[contentBlocker]!)
            let limit = sSelf.resources.sharedDefaults().integer(forKey: AEDefaultsJSONMaximumConvertedRules)
            let overlimit = converted == limit
                
            let (resultData, _) = sSelf.rulesProcessor.addDomainToWhitelist(domain: domain, jsonData: jsonData as Data, overlimit: overlimit)
            
            return resultData ?? Data()
        })
    }
    
    
    
    func removeWhitelistDomain(_ domain: String, completion: @escaping (Error?)->Void) {
        
        processWhitelistDomain(domain, completion: completion, processRules: {(rules) in
            var found = false
            let rule = AEWhitelistDomainObject(domain: domain).rule
            let resultRules = rules.filter() { (testRule) in
                if rule.isEqualRuleText(testRule) {
                    found = true
                    return false
                }
                return true
            }
            return (resultRules, found)
        }, processData: { [weak self] (jsonData, domain, _) in
            guard let sSelf = self else { return Data() }
            
            let (resultJsonData, _) = sSelf.rulesProcessor.removeWhitelistDomain(domain: domain, jsonData: jsonData)
            
            return resultJsonData ?? Data()
        })
    }
    
    func replaceWhitelistDomain(_ domain: String, with newDomain: String, completion: @escaping (Error?)->Void) {
        processWhitelistDomain(domain, completion: completion, processRules: {(rules) in
            var found = false
            let rule = AEWhitelistDomainObject(domain: domain).rule
            let resultRules = rules.map() { (testRule)->ASDFilterRule in
                if rule.isEqualRuleText(testRule) {
                    found = true
                    return AEWhitelistDomainObject(domain: newDomain).rule
                }
                return testRule
            }
            return (resultRules, found)
        }, processData: { [weak self] (jsonData, ruleData, _) in
            guard let sSelf = self else { return jsonData }
            
            let (removed, _) = sSelf.rulesProcessor.removeWhitelistDomain(domain: domain, jsonData: jsonData)
            
            let (result, _) = sSelf.rulesProcessor.addDomainToWhitelist(domain: newDomain, jsonData: removed ?? Data(), overlimit: false)
            
            return result ?? Data()
        })
    }
    
    private func replaceJsonData(jsonData: NSMutableData, oldRuleData: Data?, newRuleData: Data?) {
        
        var newRuleDataClean: NSData = NSData()
    
        // remove emphasizes []
        newRuleData?.withUnsafeBytes { dataBytes in
            newRuleDataClean = NSData(bytes: dataBytes + 1, length: newRuleData!.count - 3)
        }
        
        if oldRuleData == nil {
            // just append new rule data in the end before ]
            
            // append coma
            let comaData = ",\n".data(using: .utf8)!
            comaData.withUnsafeBytes({ dataBytes in
                jsonData.replaceBytes(in: NSRange(location: jsonData.length - 1, length: 0), withBytes: dataBytes, length: comaData.count)
            })
            
            jsonData.replaceBytes(in: NSRange(location: jsonData.length - 1, length: 0), withBytes: newRuleDataClean.bytes, length: newRuleDataClean.length)
        }
        else {
        
            var oldRuleDataClean: NSData?
            // remove emphasizes []
            oldRuleData!.withUnsafeBytes { dataBytes in
                oldRuleDataClean = NSData(bytes: dataBytes + 1, length: oldRuleData!.count - 3)
            }
            
            var loc = jsonData.range(of: oldRuleDataClean! as Data, options: .backwards, in: NSRange(location: 0, length: jsonData.length))
            
            if loc.location != NSNotFound {
                
                // remove ",\n" from json if we remove a rule
                if newRuleDataClean.length == 0 {
                    loc.location -= 2
                    loc.length += 2
                }
                
                jsonData.replaceBytes(in: loc, withBytes: newRuleDataClean.bytes, length: newRuleDataClean.length)
            }
            
        }
    }
    
    // MARK: - inverted whitelist rules
    
    func addInvertedWhitelistDomain(_ domain: String, completion: @escaping (Error?)->Void) {
        
        processInvertedWhitelistDomain(processDomains: { (domains) -> ([String], Bool) in
            return (domains + [domain], true)
        }, processData: { [weak self] (jsonData, contentBlocker) -> Data in
            guard let sSelf = self else { return Data() }
            let converted = sSelf.resources.sharedDefaults().integer(forKey: ContentBlockerService.defaultsCountKeyByBlocker[contentBlocker]!)
            let limit = sSelf.resources.sharedDefaults().integer(forKey: AEDefaultsJSONMaximumConvertedRules)
            let overlimit = converted == limit
            
            let (data, _) = sSelf.rulesProcessor.addDomainToInvertedWhitelist(domain: domain, jsonData: jsonData, overlimit: overlimit)
            
            return data ?? Data()
            
        }) { (error) in
            completion(error)
        }
    }
    
    func removeInvertedWhitelistDomain(_ domainToRemove: String, completion: @escaping (Error?)->Void) {
    
        processInvertedWhitelistDomain(processDomains: { (domains) -> ([String], Bool) in
            let filteredDomains = domains.filter({ (domain) -> Bool in
                return domainToRemove != domain
            })
            return(filteredDomains, true)
        }, processData: { [weak self] (jsonData, contentBlocker) -> Data in
            guard let sSelf = self else { return Data() }
            
            let (data, _) = sSelf.rulesProcessor.removeInvertedWhitelistDomain(domain: domainToRemove, jsonData: jsonData)
            
            return data ?? Data()
        }) { (error) in
            completion(error)
        }
    }
    
    // MARK: - private methods
    
    private func updateContentBlockers()->Error? {
        
        let filtersByGroup = activeGroups()
        let allFilters = filtersByGroup.flatMap { $0.value }
        let rulesByFilter = rules(forFilters: allFilters)
        
        // get map of rules by content blocker
        var rulesByContentBlocker = [ContentBlockerType: [ASDFilterRule]]()
        var rulesByAffinityBlocks = [ContentBlockerType: [ASDFilterRule]]()
        
        for (contentBlocker, groups) in ContentBlockerService.groupsByContentBlocker {
            var contentBlockerRules = [ASDFilterRule]()
            for groupID in groups {
                
                guard let filters = filtersByGroup[groupID as NSNumber] else { continue }
                for filterID in filters {
                    
                    guard let filterRules = rulesByFilter[filterID] else { continue }
                    sortWithAffinityBlocks(filterRules: filterRules, contentBlockerRules: &contentBlockerRules, rulesByAffinityBlocks: &rulesByAffinityBlocks)
                }
            }
            
            rulesByContentBlocker[contentBlocker] = contentBlockerRules
        }
        
        for type in ContentBlockerType.allCases {
            if rulesByContentBlocker[type] == nil {
                rulesByContentBlocker[type] = [ASDFilterRule]()
            }
            rulesByContentBlocker[type]?.append(contentsOf: rulesByAffinityBlocks[type] ?? [])
        }
        
        var resultError: Error?
        
        resultError = updateJson(blockerRules: rulesByContentBlocker[.general]!, forContentBlocker: .general) ?? resultError
        resultError = updateJson(blockerRules: rulesByContentBlocker[.privacy]!, forContentBlocker: .privacy) ?? resultError
        resultError = updateJson(blockerRules: rulesByContentBlocker[.socialWidgetsAndAnnoyances]!, forContentBlocker: .socialWidgetsAndAnnoyances) ?? resultError
        resultError = updateJson(blockerRules: rulesByContentBlocker[.other]!, forContentBlocker: .other) ?? resultError
        resultError = updateJson(blockerRules: rulesByContentBlocker[.custom]!, forContentBlocker: .custom) ?? resultError
        resultError = updateJson(blockerRules: rulesByContentBlocker[.security]!, forContentBlocker: .security) ?? resultError
        
        return resultError
    }
    
    private func sortWithAffinityBlocks(filterRules: [ASDFilterRule], contentBlockerRules: inout [ASDFilterRule], rulesByAffinityBlocks: inout [ContentBlockerType: [ASDFilterRule]]) {
        
        for rule in filterRules {
            if rule.affinity != nil {
                
                for type in ContentBlockerType.allCases {
                    let affinity = affinityMaskByContentBlockerType[type]
                    if (affinity != nil) {
                        if (rule.affinity == 0 || Affinity(rawValue: UInt8(truncating: rule.affinity!)).contains(affinity!)) {
                            if rulesByAffinityBlocks[type] == nil {
                                rulesByAffinityBlocks[type] = [ASDFilterRule]()
                            }
                            rulesByAffinityBlocks[type]?.append(rule)
                        }
                    }
                }
                
            } else {
                contentBlockerRules.append(rule)
            }
        }
    }
    
    private let affinityMaskByContentBlockerType: [ContentBlockerType: Affinity] =
        [.general: Affinity.general,
         .privacy: Affinity.privacy,
         .socialWidgetsAndAnnoyances: Affinity.socialWidgetsAndAnnoyances,
         .other: Affinity.other,
         .custom: Affinity.custom,
         .security: Affinity.security ]
    
    private func updateJson(blockerRules: [ASDFilterRule], forContentBlocker contentBlocker: ContentBlockerType)->Error? {
        let safariProtectionEnabled = resources.sharedDefaults().bool(forKey: SafariProtectionState)
        
        if safariProtectionEnabled {
            return autoreleasepool {
                var rules = blockerRules
                
                // add user rules
                
                let userFilterEnabled = resources.sharedDefaults().object(forKey: AEDefaultsUserFilterEnabled) as? Bool ?? true
                let userRules = userFilterEnabled ? antibanner!.rules(forFilter: ASDF_USER_FILTER_ID as NSNumber) : [ASDFilterRule]()
                
                rules = userRules + rules
                
                // add whitelist rules
                
                let inverted = resources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
                
                let whitelistEnabled = resources.sharedDefaults().object(forKey: AEDefaultsWhitelistEnabled) as? Bool ?? true
                
                if whitelistEnabled {
                    if inverted {
                        
                        if resources.invertedWhitelistContentBlockingObject == nil {
                            resources.invertedWhitelistContentBlockingObject = AEInvertedWhitelistDomainsObject(domains: [])
                        }
                        
                        if let innvertedRule = resources.invertedWhitelistContentBlockingObject?.rule {
                            rules.append(innvertedRule)
                        }
                    }
                    else {
                        if let whitelistRules = resources.whitelistContentBlockingRules {
                            rules.append(contentsOf: whitelistRules as! [ASDFilterRule])
                        }
                    }
                }
                
                var resultData = Data()
                var resultError: Error?
                if rules.count != 0 {
                    let (jsonData, converted, overLimit, _, error) = convertRulesToJson(rules)
                    resources.sharedDefaults().set(overLimit, forKey: ContentBlockerService.defaultsOverLimitCountKeyByBlocker[contentBlocker]!)
                    
                    if jsonData != nil { resultData = jsonData! }
                    resources.sharedDefaults().set(converted, forKey: ContentBlockerService.defaultsCountKeyByBlocker[contentBlocker]!)
                    
                    resultError = error
                    
                } else {
                    resources.sharedDefaults().set(0, forKey: ContentBlockerService.defaultsOverLimitCountKeyByBlocker[contentBlocker]!)
                    resources.sharedDefaults().set(0, forKey: ContentBlockerService.defaultsCountKeyByBlocker[contentBlocker]!)
                }
                
                safariService.save(json: resultData, type: contentBlocker.rawValue)
                
                return resultError
            }
        } else {
            safariService.save(json: Data(), type: contentBlocker.rawValue)
            return nil
        }
    }
    
    /** returns map [filterID: [Rule]]*/
    private func rules(forFilters filterIDs: [NSNumber]) -> [NSNumber: [ASDFilterRule]] {
        var rulesByFilter = [NSNumber: [ASDFilterRule]]()
        
        for filterID in filterIDs {
            let rules = antibanner?.activeRules(forFilter: filterID)
            rulesByFilter[filterID] = rules
        }
        
        return rulesByFilter
    }
    
    /** returns map [groupId: [filterId]] */
    private func activeGroups()->[NSNumber: [NSNumber]] {
        var filterByGroup = [NSNumber:[NSNumber]]()
        let groupIDs = antibanner!.activeGroupIDs()
        
        for groupID in groupIDs {
            let filterIDs = antibanner!.activeFilterIDs(byGroupID: groupID)
            filterByGroup[groupID] = filterIDs
        }
        
        return filterByGroup
    }
    
    private func processWhitelistDomain(_ domain: String, completion: @escaping (Error?)->Void, processRules: @escaping(_ rules: [ASDFilterRule])->([ASDFilterRule], Bool), processData: @escaping(_ jsonData: Data, _ domain: String, _ contentBlocker: ContentBlockerType)->Data) {
        
        workQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            var error: Error?
            var modified = false
            
            var savedDatas:[ContentBlockerType: Data] = [:]
            var savedRules:[ASDFilterRule] = []
            
            var rollback: ()->Void = {
                for (_, obj) in savedDatas.enumerated() {
                    sSelf.safariService.save(json: obj.value, type: obj.key.rawValue)
                    sSelf.resources.whitelistContentBlockingRules = (savedRules as NSArray).mutableCopy() as? NSMutableArray
                }
            }
            
            defer {
            
                if error != nil {
                    sSelf.finishReloadingConetentBlocker(completion: completion, error: error)
                    rollback()
                }
                else if error == nil && modified {
                    sSelf.safariService.invalidateBlockingJsons { (error) in
                        sSelf.finishReloadingConetentBlocker(completion: completion, error: error)
                        
                        if error != nil {
                            rollback()
                            sSelf.safariService.invalidateBlockingJsons { (error) in
                            }
                        }
                    }
                }
                else {
                    sSelf.finishReloadingConetentBlocker(completion: completion, error: error)
                }
            }
            
            var whitelistRules = sSelf.resources.whitelistContentBlockingRules as? [ASDFilterRule] ?? []
            savedRules = Array(whitelistRules)
            var succeded = false
            (whitelistRules, succeded) = processRules(whitelistRules)
            
            if !succeded {
                error = NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain,
                               code: ContentBlockerService.contentBlockerDBErrorCode,
                               userInfo: [NSLocalizedDescriptionKey: ACLocalizedString("support_unexpected_error", "")])
                return
            }
            
            sSelf.resources.whitelistContentBlockingRules = (whitelistRules as NSArray).mutableCopy() as? NSMutableArray
            
            // change all content blocker jsons
            ContentBlockerType.allCases.forEach { (type) in
                guard let data = sSelf.safariService.readJson(forType: type.rawValue) else { return }
                savedDatas[type] = data
                let jsonData = processData(data, domain, type)
                
                sSelf.safariService.save(json: jsonData as Data, type: type.rawValue)
            }
            
            modified = true
            return
        }
    }
    
    private func processInvertedWhitelistDomain(processDomains: @escaping(_ domains: [String])->([String], Bool), processData: @escaping(_ jsonData: Data, _ contentBlocker: ContentBlockerType)->Data, completion: @escaping (Error?)->Void) {
        
        workQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            var error: Error?
            var modified = false
            
            var savedDatas:[ContentBlockerType: Data] = [:]
            let invertedObject = sSelf.resources.invertedWhitelistContentBlockingObject
            
            var rollback: ()->Void = {
                for (_, obj) in savedDatas.enumerated() {
                    sSelf.safariService.save(json: obj.value, type: obj.key.rawValue)
                    sSelf.resources.invertedWhitelistContentBlockingObject = invertedObject
                }
            }
            
            defer {
                
                if error != nil {
                    sSelf.finishReloadingConetentBlocker(completion: completion, error: error)
                    rollback()
                }
                else if error == nil && modified {
                    sSelf.safariService.invalidateBlockingJsons { (error) in
                        sSelf.finishReloadingConetentBlocker(completion: completion, error: error)
                    }
                }
                else {
                    sSelf.finishReloadingConetentBlocker(completion: completion, error: error)
                }
            }
            
            var domains = invertedObject?.domains ?? [String]()
        
            var succeded = false
            (domains, succeded) = processDomains(domains)
            
            if !succeded {
                error = NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain,
                                code: ContentBlockerService.contentBlockerDBErrorCode,
                                userInfo: [NSLocalizedDescriptionKey: ACLocalizedString("support_unexpected_error", "")])
                return
            }
            
            var newInvertedObject: AEInvertedWhitelistDomainsObject? = nil
            
            newInvertedObject = AEInvertedWhitelistDomainsObject(domains: domains)
        
            sSelf.resources.invertedWhitelistContentBlockingObject = newInvertedObject
            
            // change all content blocker jsons
            ContentBlockerType.allCases.forEach { (type) in
                guard let data = sSelf.safariService.readJson(forType: type.rawValue) else { return }
                savedDatas[type] = data
                
                let jsonData = processData(data, type)
                
                sSelf.safariService.save(json: jsonData, type: type.rawValue)
            }
            
            modified = true
            return
        }
    }
    
    private func finishReloadingConetentBlocker(completion: ((Error?)->Void)?, error: Error?) {
        workQueue.async {
            if completion != nil {
                self.workQueue.async {
                    completion!(error)
                }
            }
        }
    }
    
    private func convertRulesToJson(_ rules: [ASDFilterRule])->(data: Data?, converted: Int, overlimit: Int, totalConverted: Int, error: Error?) {
        
        var error: Error?
        var converted = 0
        var overLimit = 0
        var totalConverted = 0
        var rulesData: Data?
        
        if rules.count == 0 { return (nil, 0, 0, 0, NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain, code: 0, userInfo: [:])) }
        
        // run converter
        let limit = UInt(resources.sharedDefaults().integer(forKey: AEDefaultsJSONMaximumConvertedRules))
        let optimize = resources.sharedDefaults().bool(forKey: AEDefaultsJSONConverterOptimize)
        
        let (converter, converterError) = createConverter()
        if converterError != nil { return (nil, 0, 0, 0, converterError) }
        
        if converter == nil {
            error = NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain,
                            code: ContentBlockerService.contentBlockerConverterErrorCode,
                            userInfo: nil)
            return (nil, 0, 0, 0, error)
        }
        
        let converterResult = converter!.json(fromRules: rules, upTo: limit, optimize: optimize) as? [String: Any]
        
        error = converterResult?[AESFConvertedErrorKey] as? Error
        if error != nil { return (nil, 0, 0, 0, error) }
        
        converted = converterResult?[AESFConvertedCountKey] as? Int ?? 0
        totalConverted = converterResult?[AESFTotalConvertedCountKey] as? Int ?? 0
        overLimit = totalConverted - converted
        
        // obtain rules
        let jsonString = converterResult?[AESFConvertedRulesKey] as? String
        if jsonString == nil || jsonString! == "undefined" || jsonString! == "[]" {
            error = NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain,
                            code: ContentBlockerService.contentBlockerConverterErrorCode,
                            userInfo: nil)
            return (nil, 0, 0, 0, error)
        }
        
        rulesData = jsonString?.data(using: .utf8)
        
        return (rulesData, converted, overLimit, totalConverted, error)
    }
    
    func replaceUserFilter(_ rules: [ASDFilterRule])->Error? {
        
        if antibanner?.import(rules, filterId: ASDF_USER_FILTER_ID as NSNumber) ?? false {
            return nil
        }
        
        return NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain,
                       code: ContentBlockerService.contentBlockerDBErrorCode,
                       userInfo: [NSLocalizedDescriptionKey: ACLocalizedString("support_unexpected_error", "")])
    }
    
    func convertOneRule(_ rule: ASDFilterRule)->([String: Any]?, Error?) {
        
        let optimize = resources.sharedDefaults().bool(forKey: AEDefaultsJSONConverterOptimize)
                    
        var convertResult: [String: Any]?
        
        let (converter, converterError) = createConverter()
        if converterError != nil { return (nil, converterError) }
        
        convertResult = converter!.json(fromRules: [rule], upTo: 1, optimize: optimize) as? [String: Any]
        
        if let error = convertResult?[AESFConvertedErrorKey] as? Error { return (nil, error) }
        
        let convertedCount = convertResult?[AESFConvertedCountKey] as? Int
        let errorsCount = convertResult?[AESErrorsCountKey] as? Int
        
        if convertedCount == 0 || errorsCount ?? 0 > 0 {
            let errorDescription = ACLocalizedString("rule_converting_error", nil)
            let error = NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain,
                            code: Int(AES_ERROR_UNSUPPORTED_RULE),
                            userInfo: [NSLocalizedDescriptionKey: errorDescription, AESUserInfoRuleObject: rule])
            return(nil, error)
        }
        
        return (convertResult, nil)
    }
    
    var createConverter:()->(AESFilterConverterProtocol?, Error?) = {
        
        guard let converter = AESFilterConverter() else {
            DDLogError("(ContentBlockerService) Can't initialize converter to JSON format!")
            let errorDescription = ACLocalizedString("json_converting_error", nil)
            let error = NSError(domain: ContentBlockerService.contentBlockerServiceErrorDomain,
                                code: Int(AES_ERROR_UNSUPPORTED_RULE),
                                userInfo: [NSLocalizedDescriptionKey: errorDescription])
            return (nil, error)
        }
        
        return (converter, nil)
    }
}
