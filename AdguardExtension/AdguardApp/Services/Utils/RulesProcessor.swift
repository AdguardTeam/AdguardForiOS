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

/**
 RulesProcessor - helper class responsible for fast change safari content blocker json whitout recompilling through Converter.js
 
 it works with raw data. It can add, remove, replace whitelist or inverted whitelist rules
 */
protocol RulesProcessorProtocol {
    /**
     adds domain to whitelist
     if @overlimit is true it removes last blocklist rule before adding new whitelist rule
     */
    func addDomainToWhitelist(domain: String, enabled: Bool, jsonData: Data, overlimit: Bool)->(Data?, NSError?)
    
    /**
    remove domain from whitelist
    */
    func removeWhitelistDomain(domain: String, jsonData: Data)->(Data?, NSError?)
    
    /**
    adds domain to inverted whitelist
    if @overlimit is true it removes last blocklist rule before adding new inverted whitelist domain
    */
    func addDomainToInvertedWhitelist(domain: String, jsonData: Data, overlimit: Bool)->(Data?, NSError?)
    
    /**
    remove domain from inverted whitelist
    */
    func removeInvertedWhitelistDomain(domain: String, jsonData: Data)->(Data?, NSError?)
}

class RulesProcessor : RulesProcessorProtocol {
    
    static let errorDomain = "RulesConverterErrorDomain"
    static let errorCode = -1
    
    func addDomainToWhitelist(domain: String, enabled: Bool, jsonData: Data, overlimit: Bool)->(Data?, NSError?) {
        
        var (json, error) = prepareJson(jsonData: jsonData, overlimit: overlimit)
        if error != nil { return (nil, error) }
        
        let rule = SafariRule(domains: [domain], action: .whitelist)
        
        if enabled {
            json!.append(rule.json())
        }

        return convertObjectToData(json!)
    }
    
    func removeWhitelistDomain(domain: String, jsonData: Data) -> (Data?, NSError?) {
        
        DDLogInfo("(RulesConverter) removeWhitelistRule")
        if jsonData.count == 0 {
            DDLogError("(RulesConverter) removeWhitelistRule error. jsonData is empty")
            return (nil, NSError(domain: RulesProcessor.errorDomain, code: RulesProcessor.errorCode, userInfo: nil))
        }
        
        var (json, error) = convertDataToObject(jsonData)
        
        if error != nil {
            return (nil, error)
        }
        
        let expectedRule = SafariRule(domains: [domain], action: .whitelist)
        var foundIndex: Int?

        for i in (0..<json!.count).reversed() {
            let ruleObj = json![i]
            
            guard let rule = SafariRule(object: ruleObj) else { continue }
            
            if rule == expectedRule  {
                foundIndex = i
                break;
            }
        }
        
        if foundIndex == nil {
            DDLogInfo("(RulesConverter) can not find expectedData")
            return (jsonData, NSError(domain: RulesProcessor.errorDomain, code: RulesProcessor.errorCode, userInfo: nil))
        }
        
        DDLogInfo("(RulesConverter) removeWhitelistRule expectedData is found")
        
        json?.remove(at: foundIndex!)
        
        return convertObjectToData(json!)
    }
    
    func addDomainToInvertedWhitelist(domain: String, jsonData: Data, overlimit: Bool) -> (Data?, NSError?) {
        DDLogInfo("(RulesConverter) addDomainToInvertedWhitelist")
        
        var (json, error) = prepareJson(jsonData: jsonData, overlimit: overlimit)
        if error != nil { return (nil, error)}
        
        var found = false
        if json!.count > 0 {
            if let lastRule = SafariRule(object: (json?.last)!) {
                if lastRule.action == .invertedWhitelist {
                    DDLogInfo("(RulesConverter) addDomainToInvertedWhitelist - inverted rule exists. Add domainto it")
                    lastRule.appendDomain(domain)
                    found = true
                    
                    json!.removeLast()
                    json!.append(lastRule.json())
                }
            }
        }
        
        if !found {
            DDLogInfo("(RulesConverter) addDomainToInvertedWhitelist - inverted rule does not exist. Create new one")
            let newRule = SafariRule(domains: [domain], action: .invertedWhitelist)
            json?.append(newRule.json())
        }
        
        return convertObjectToData(json!)
    }
    
    func removeInvertedWhitelistDomain(domain: String, jsonData: Data) -> (Data?, NSError?) {
        DDLogInfo("(RulesConverter) removeInvertedWhitelistDomain")
        var (json, error) = prepareJson(jsonData: jsonData, overlimit: false)
        if error != nil { return (nil, error)}
        
        var found = false
        if json!.count > 0 {
            if let lastRule = SafariRule(object: (json?.last)!) {
                if lastRule.action == .invertedWhitelist {
                    DDLogInfo("(RulesConverter) addDomainToInvertedWhitelist - inverted rule exists. Add domainto it")
                    found = lastRule.removeDomain(domain)
                    
                    json!.removeLast()
                    json!.append(lastRule.json())
                }
            }
        }
        
        if !found {
            DDLogInfo("(RulesConverter) addDomainToInvertedWhitelist - inverted rule does not exist. Create new one")
            let newRule = SafariRule(domains: [domain], action: .invertedWhitelist)
            json?.append(newRule.json())
        }
        
        return convertObjectToData(json!)
    }
    
    // MARK: - private methods
    
    private func convertDataToObject(_ jsonData: Data)->(json: Array<Any>?, error: NSError?) {
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? Array<Any>{
            return (json, nil)
        }
        else {
            return(nil, NSError(domain: RulesProcessor.errorDomain, code: RulesProcessor.errorCode, userInfo: nil))
        }
    }
    
    private func convertObjectToData(_ object: Any)->(Data?, NSError?) {
        if let returnData = try? NotEcapingJsonSerialization.data(withJSONObject: object as Any, options: [.prettyPrinted]) {
            return(returnData, nil)
        }
        else {
            DDLogError("(RulesProcessor) convertObejctToData error - can not convert result data to json")
            return (nil, NSError(domain: RulesProcessor.errorDomain, code: RulesProcessor.errorCode, userInfo: nil))
        }
    }
    
    // this function gets array with one rule as Data and returns this one rule as Any object
    private func ruleFromData(_ data: Data)->Any? {
        guard let ruleJson = try? JSONSerialization.jsonObject(with: data, options: []) else { return nil }
        
        if let arrayOfRules = ruleJson as? Array<Any> {
            return arrayOfRules.first
        }
        
        return ruleJson
    }
    
    private func prepareJson (jsonData: Data, overlimit: Bool)->([Any]?, NSError?) {
        DDLogInfo("(RulesConverter) add whilist domain")
        
        var json: [Any]?
        
        if jsonData.count == 0 {
            DDLogInfo("(RulesConverter) jsonData is empty.")
            json = [Any]()
            return(json, nil)
        }
        else {
            let (sourceJson, error) = convertDataToObject(jsonData)
            if error != nil {
                return (nil, error)
            }
            
            json = sourceJson
        }
        
        if overlimit {

            // remove last blocking rule from json array
            var indexToDelete: Int?

            for i in (0..<json!.count).reversed() {
                guard let rule = SafariRule(object: json![i]) else { continue }
                if rule.action == .block {
                    indexToDelete = i
                    break;
                }
            }

            // if there is not blocking rule, we can not add new whitelist rule
            if indexToDelete == nil {
                DDLogError("(RulesProcessor) addWhitelist error - can not add a whitelist rule because the limit of 50000 rules is reached and there is not any rules to remove")
                return (nil, NSError(domain: RulesProcessor.errorDomain, code: RulesProcessor.errorCode, userInfo: nil))
            }

            json!.remove(at: indexToDelete!)
        }
        
        return (json, nil)
    }
}
