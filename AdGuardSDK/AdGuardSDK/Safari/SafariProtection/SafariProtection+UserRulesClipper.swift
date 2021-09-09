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
@_implementationOnly import ContentBlockerConverter

public protocol SafariProtectionUserRulesClipperProtocol {
    /**
     Adds converted `domain` rule directly to Content Blocker JSON without convertation
     - Parameter domain: Domain that should be added
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func quickAddRuleToAllowlist(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws
    
    /**
     Adds converted `domain` rule directly to Content Blocker JSON without convertation
     - Parameter domain: Domain that should be added
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func quickAddInvertedAllowlistRule(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws
  
    /**
     Removes converted `domain` rule directly from Content Blocker JSON without convertation
     - Parameter domain: Domain that should be removed
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func quickRemoveAllowlistRule(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws
  
    /**
     Removes converted `domain` rule directly from Content Blocker JSON without convertation
     - Parameter domain: Domain that should be removed
     - Parameter onCbReloaded: Closure to handle errors when reloading Content Blockers
     */
    func quickRemoveInvertedAllowlistRule(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws
}

extension SafariProtection {
    public func quickAddRuleToAllowlist(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRulesClipper) - addRuleToAllowlist; Adding rule: \(domain)")
            
            try clipRuleFromCbJson({
                let rule = UserRule(ruleText: domain, isEnabled: true)
                let provider = getProvider(for: .allowlist)
                try provider.add(rule: rule, override: true)
            }, { convertionResult in
                try userRulesClipper.addAllowlistRule(by: domain, to: convertionResult)
            }, onCbReloaded: onCbReloaded)
        }
    }
    
    public func quickAddInvertedAllowlistRule(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRulesClipper) - addInvertedAllowlistRule; Adding rule: \(domain)")
            
            try clipRuleFromCbJson({
                let rule = UserRule(ruleText: domain, isEnabled: true)
                let provider = getProvider(for: .invertedAllowlist)
                try provider.add(rule: rule, override: true)
            }, { convertionResult in
                try userRulesClipper.addInvertedAllowlistRule(by: domain, to: convertionResult)
            }, onCbReloaded: onCbReloaded)
        }
    }
    
    public func quickRemoveAllowlistRule(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRulesClipper) - removeAllowlistRule; Removing rule: \(domain)")
            
            try clipRuleFromCbJson({
                let provider = getProvider(for: .allowlist)
                try provider.removeRule(withText: domain)
            }, { convertionResult in
                try userRulesClipper.removeAllowlistRule(by: domain, from: convertionResult)
            }, onCbReloaded: onCbReloaded)
        }
    }
    
    public func quickRemoveInvertedAllowlistRule(by domain: String, onCbReloaded: ((_ error: Error?) -> Void)?) throws {
        try workingQueue.sync {
            Logger.logInfo("(SafariProtection+UserRulesClipper) - removeInvertedAllowlistRule; Removing rule: \(domain)")
            
            try clipRuleFromCbJson({
                let provider = getProvider(for: .invertedAllowlist)
                try provider.removeRule(withText: domain)
            }, { convertionResult in
                try userRulesClipper.removeInvertedAllowlistRule(by: domain, from: convertionResult)
            }, onCbReloaded: onCbReloaded)
        }
    }
    
    private func clipRuleFromCbJson(
        _ userRuleHandler: () throws -> Void,
        _ cbClipperHandler: (_ conversionResult: ConversionResult) throws -> ConversionResult,
        onCbReloaded: ((_ error: Error?) -> Void)?
    ) throws {
        
        do {
            try userRuleHandler()
            let convertionResults = cbStorage.allConverterResults
            let newConvertionResults: [FiltersConverterResult] = try convertionResults.map {
                let convertionResult = ConversionResult(converterResult: $0.result)
                let result = try cbClipperHandler(convertionResult)
                return FiltersConverterResult(type: $0.result.type, conversionResult: result)
            }
            try cbStorage.save(converterResults: newConvertionResults)
        } catch {
            completionQueue.async { onCbReloaded?(error) }
            throw error
        }
        
        cbQueue.async { [weak self] in
            self?.cbService.updateContentBlockers { error in
                self?.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }
}
