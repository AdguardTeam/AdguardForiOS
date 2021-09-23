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

// MARK: - FilterFileContent

struct FilterFileContent: Equatable {
    let text: String
    let lines: [String]
    let group: SafariGroup.GroupType
    
    init(text: String, group: SafariGroup.GroupType) {
        self.text = text
        self.lines = text.components(separatedBy: .newlines)
        self.group = group
    }
}

// MARK: - ContentBlockerConverterWrapper

/**
 This converter is a wrapper for ContentBlockerConverter responsible for converting rules to JSON files
 We use it in order to be able to test code in FiltersConverter
 `cbType` is used to differ conversion results because `ConversionResult` init is inaccessible
 */
protocol ContentBlockerConverterProtocol {
    func convertArray(
        rules: [String],
        safariVersion: SafariVersion,
        optimize: Bool,
        advancedBlocking: Bool
    ) -> ConversionResult
}

final class ContentBlockerConverterWrapper: ContentBlockerConverterProtocol {
    func convertArray(rules: [String], safariVersion: SafariVersion, optimize: Bool, advancedBlocking: Bool) -> ConversionResult {
        let converter = ContentBlockerConverter()
        let result = converter.convertArray(rules: rules, safariVersion: safariVersion, optimize: optimize, advancedBlocking: advancedBlocking)
        return result
    }
}

// MARK: - FiltersConverter

protocol FiltersConverterProtocol {
    /**
     Creates **SafariFilter** objects from all available rules for each content blocker
     - Parameter filters: Array of enabled predefined and custom filters
     - Parameter blocklistRules: Array of enabled blocklist user rules
     - Parameter allowlistRules: Array of enabled blocklist user rules
     - Parameter invertedAllowlistRulesString: String represantation of enabled inverted allowlist rules
     Note that one of **allowlistRules** and **invertedAllowlistRulesString** should be nil
     - Returns: ContentBlockerConverter result for each content blocker
     */
    func convert(filters: [FilterFileContent], blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRules: [String]?) -> [FiltersConverterResult]
}

final class FiltersConverter: FiltersConverterProtocol {
    
    /**
     Safari Content Blocker can return an error if we pass empty json
     So we just pass json with empty rule to avoid this error
     */
    private lazy var emptyRuleJsonResult: ConversionResult = {
        let safariVersion = SafariVersion(rawValue: configuration.iosVersion) ?? .safari15
        return converter.convertArray(rules: [], safariVersion: safariVersion, optimize: false, advancedBlocking: false)
    }()
        
    private let configuration: SafariConfigurationProtocol
    private let converter: ContentBlockerConverterProtocol
    
    init(configuration: SafariConfigurationProtocol, converter: ContentBlockerConverterProtocol = ContentBlockerConverterWrapper()) {
        self.configuration = configuration
        self.converter = converter
    }
    
    // MARK: - Internal method
    
    func convert(filters: [FilterFileContent], blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRules: [String]?) -> [FiltersConverterResult] {
        let sortedRules = sortRulesByContentBlockers(filters, blocklistRules, allowlistRules, invertedAllowlistRules)
        let safariFilters = convert(filters: sortedRules)
        return safariFilters
    }
    
    // MARK: - private methods
    
    // Sorts all filters and rules by content blockers
    private func sortRulesByContentBlockers(_ filters: [FilterFileContent],
                                    _ blocklistRules: [String]?,
                                    _ allowlistRules: [String]?,
                                    _ invertedAllowlistRules: [String]?) -> [ContentBlockerType: [String]]
    {
        var filterRules = parse(filters: filters)
        addUserRules(blocklistRules: blocklistRules,
                     allowlistRules: allowlistRules,
                     invertedAllowlistRules: invertedAllowlistRules,
                     filters: &filterRules)
        return filterRules
    }
    
    // Returns rules sorted by content blockers
    private func parse(filters: [FilterFileContent]) -> [ContentBlockerType: [String]] {
        var rulesByCBType: [ContentBlockerType: [String]] = [:]
        ContentBlockerType.allCases.forEach { rulesByCBType[$0] = [] }
        
        for filter in filters {
            let rules = AffinityRulesParser.parse(strings: filter.lines)
            let cbType = filter.group.contentBlockerType
            sortRulesByAffinity(filterRules: rules, defaultCBType: cbType, rulesByAffinityBlocks: &rulesByCBType)
        }
        
        return rulesByCBType
    }
    
    // Sorts rules by affinity and adds them to the proper content blocker
    private func sortRulesByAffinity(filterRules: [FilterRule], defaultCBType: ContentBlockerType, rulesByAffinityBlocks: inout [ContentBlockerType: [String]]) {
        for rule in filterRules {
            guard let ruleAffinity = rule.affinity else {
                rulesByAffinityBlocks[defaultCBType]?.append(rule.rule)
                continue
            }
            
            for type in ContentBlockerType.allCases {
                let affinity = type.affinity
                if ruleAffinity == .all || ruleAffinity.contains(affinity) {
                    rulesByAffinityBlocks[type]?.append(rule.rule)
                }
            }
        }
    }
    
    // Adds all types of user rules to all content blockers
    private func addUserRules(blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRules: [String]?, filters: inout [ContentBlockerType: [String]]) {
        // add blacklist rules
        if let blocklistRules = blocklistRules {
            filters.keys.forEach { filters[$0]?.append(contentsOf: blocklistRules) }
        }
        
        // add allowlist rules
        if let allowlistRules = allowlistRules {
            let converter = AllowlistRuleConverter()
            let properAllowlistRules = allowlistRules.map { converter.convertDomainToRule($0) }
            filters.keys.forEach { filters[$0]?.append(contentsOf: properAllowlistRules) }
        }
        
        // add inverted allowlist rules
        if let invertedAllowlistRules = invertedAllowlistRules {
            let converter = InvertedAllowlistRuleConverter()
            let properInvertedallowlistRules = invertedAllowlistRules.map { converter.convertDomainToRule($0) }
            filters.keys.forEach { filters[$0]?.append(contentsOf: properInvertedallowlistRules) }
        }
    }
    
    // Converts all rules to jsons
    private func convert(filters: [ContentBlockerType: [String]]) -> [FiltersConverterResult] {
        var conversionResult: [FiltersConverterResult] = []
        let safariVersion = SafariVersion(rawValue: configuration.iosVersion) ?? .safari15
        for (cbType, rules) in filters {
            let result = converter.convertArray(
                rules: rules,
                safariVersion: safariVersion,
                optimize: false,
                advancedBlocking: configuration.advancedBlockingIsEnabled && configuration.proStatus
            )
            Logger.logInfo("FiltersCoverter result: \(result.message)")
            
            // Just take the info we need
            let converterResult = FiltersConverterResult(type: cbType, conversionResult: result)
            conversionResult.append(converterResult)
        }
        return conversionResult
    }
}
