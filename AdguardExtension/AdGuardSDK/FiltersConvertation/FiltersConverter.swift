import Foundation
@_implementationOnly import ContentBlockerConverter

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
    func convert(filters: [FilterFileContent], blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRulesString: String?) -> [SafariFilter]?
}

struct FiltersConverter: FiltersConverterProtocol {

    func convert(filters: [FilterFileContent], blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRulesString: String?) -> [SafariFilter]? {
        var filterRules = parse(filters: filters)
        addUserRules(blocklistRules: blocklistRules,
                     allowlistRules: allowlistRules,
                     invertedAllowlistRulesString: invertedAllowlistRulesString,
                     filters: &filterRules)
        let safariFilters = convert(filters: filterRules)
        return safariFilters
    }
    
    // MARK: - private methods
    
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
    private func addUserRules(blocklistRules: [String]?, allowlistRules: [String]?, invertedAllowlistRulesString: String?, filters: inout [ContentBlockerType: [String]]) {
        // add blacklist rules
        if let blocklistRules = blocklistRules {
            filters.keys.forEach { filters[$0]?.append(contentsOf: blocklistRules) }
        }
        
        // add allowlist rules
        if let allowlistRules = allowlistRules {
            let properAllowlistRules = allowlistRules.map { AllowlistRuleConverter.convertDomainToRule($0) }
            filters.keys.forEach { filters[$0]?.append(contentsOf: properAllowlistRules) }
        }
        
        // add inverted allowlist rules string
        if let invertedAllowlistRulesString = invertedAllowlistRulesString {
            filters.keys.forEach { filters[$0]?.append(invertedAllowlistRulesString) }
        }
    }
    
    private func convert(filters: [ContentBlockerType: [String]]) -> [SafariFilter] {
        var resultFilters: [SafariFilter] = []
        let converter = ContentBlockerConverter()
        
        for (cbType, rules) in filters {
            guard let result = converter.convertArray(rules: rules, limit: 50000, optimize: false, advancedBlocking: false) else {
                Logger.logError("FiltersCoverter error - can not convert filter with type: \(cbType)")
                continue
            }
            Logger.logInfo("FiltersCoverter result: \(result.message)")
            let safariFilter = SafariFilter(type: cbType, jsonString: result.converted, totalRules: result.totalConvertedCount, totalConverted: result.convertedCount, overlimit: result.overLimit)
            resultFilters.append(safariFilter)
        }
        return resultFilters
    }
}

// MARK: - Affinity

struct Affinity: OptionSet {
    let rawValue: UInt8
    
    static let general = Affinity(rawValue: 1 << 0)
    static let privacy = Affinity(rawValue: 1 << 1)
    static let socialWidgetsAndAnnoyances = Affinity(rawValue: 1 << 2)
    static let other = Affinity(rawValue: 1 << 3)
    static let custom = Affinity(rawValue: 1 << 4)
    static let security = Affinity(rawValue: 1 << 5)
    static let all = Affinity([])
}
