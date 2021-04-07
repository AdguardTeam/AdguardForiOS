import Foundation
@_implementationOnly import ContentBlockerConverter

public protocol FiltersConverterProtocol {
    func convertFilters(_ filters: [AdGuardFilter], allowlist: String?, blocklist: String?, invert: Bool)->[SafariFilter]?
}

public class FiltersConverter: FiltersConverterProtocol {

	public func convertFilters(_ filters: [AdGuardFilter], allowlist: String?, blocklist: String?, invert: Bool) -> [SafariFilter]? {
        
        var filterRules = parseFilters(filters)
        
        addUserRules(blocklist: blocklist, whitelist: allowlist, inverted: invert, filters: &filterRules)
        
        let safariFilters = convertFilters(filterRules)
        
        return safariFilters
    }
    
    // MARK: - private methods
    
    // returns Dictionary
    // key - ContentBlockerType
    // value - Array of rules
    private func parseFilters(_ filters: [AdGuardFilter])->[ContentBlockerType: [String]] {
        var rulesByCBType = [ContentBlockerType: [String]]()
        
        for filter in filters {
            let lines = filter.text.components(separatedBy: .newlines)
            let rulesParser = AffinityRulesParser()
            let rules = rulesParser.parseStrings(lines)
            
            guard let cbType = contentBlockerByGroup[filter.group] else {
                assertionFailure("can not resolve content blocker type")
                continue
            }
            sortWithAffinityBlocks(filterRules: rules, defaultCBType: cbType, rulesByAffinityBlocks: &rulesByCBType)
        }
        
        return rulesByCBType
    }
    
    private func sortWithAffinityBlocks(filterRules: [FilterRule], defaultCBType: ContentBlockerType, rulesByAffinityBlocks: inout [ContentBlockerType: [String]]) {
        
        for rule in filterRules {
            if let ruleAffinity = rule.affinity {
                
                for type in ContentBlockerType.allCases {
                    if let affinity = affinityMaskByContentBlockerType[type] {
                        if (ruleAffinity.rawValue == 0 || ruleAffinity.contains(affinity)) {
                            if rulesByAffinityBlocks[type] == nil {
                                rulesByAffinityBlocks[type] = [String]()
                            }
                            rulesByAffinityBlocks[type]?.append(rule.text)
                        }
                    }
                }
                
            } else {
                if rulesByAffinityBlocks[defaultCBType] == nil {
                    rulesByAffinityBlocks[defaultCBType] = [String]()
                }
                rulesByAffinityBlocks[defaultCBType]?.append(rule.text)
            }
        }
    }
    
    private func convertFilters(_ filters: [ContentBlockerType: [String]])->[SafariFilter] {
        
        var resultFilters = [SafariFilter]()
        let converter = ContentBlockerConverter()
        for filter in filters {
            let result = converter.convertArray(rules: filter.value, limit: 50000, optimize: false, advancedBlocking: false)
            let safariFilter = SafariFilter(type: filter.key, jsonString: result?.converted, totalRules: result?.totalConvertedCount, totalConverted: result?.convertedCount, error: nil)
            
            resultFilters.append(safariFilter)
        }
        return resultFilters
    }
    
    private func addUserRules(blocklist: String?, whitelist: String?, inverted: Bool?, filters: inout [ContentBlockerType: [String]]) {
        
        let blocklistRules = blocklist?.components(separatedBy: .newlines) ?? []
        
        // add blacklist rules
        for type in filters.keys {
            filters[type]?.append(contentsOf: blocklistRules)
        }
        
        // add whitelist rules
        
        if inverted == false {
            let whitelistRules = whitelist?.components(separatedBy: .newlines) ?? []
            for type in filters.keys {
                filters[type]?.append(contentsOf: whitelistRules)
            }
        }
        
        // add inverted whitelist
        
        if inverted == true {
            
            let invertedRule = createInvertedRule(whitelist: whitelist)
            for type in filters.keys {
                filters[type]?.append(invertedRule)
            }
        }
    }
    
    private func createInvertedRule(whitelist: String?)->String {
        
        var ruleString = ""
        
        let rules = whitelist?.components(separatedBy: .newlines) ?? []
        
        if rules.count == 0 {
            ruleString.append("@@||*$document") // Empty list rule
        }
        else {
            let prefix = "@@||*$document,domain="
            ruleString.append(prefix)
            for i in 0..<rules.count {
                let rule = rules[i]
                if rule.isEmpty { continue }
                
                if i > 0 {
                    ruleString.append("|")
                }
                
                ruleString.append("~%\(rule)")
            }
        }

        return ruleString
    }
    
    // MARK: - type mappings
    
    let contentBlockerByGroup: [AdGuardFilterGroup: ContentBlockerType] = [
        .ads : .general,
        .languageSpecific: .general,
        .privacy: .privacy,
        .socialWidgets: .socialWidgetsAndAnnoyances,
        .other: .other,
        .custom: .custom,
        .security: .security,
        .annoyances: .socialWidgetsAndAnnoyances
    ]
    
    private let affinityMaskByContentBlockerType: [ContentBlockerType: Affinity] =
        [.general: Affinity.general,
         .privacy: Affinity.privacy,
         .socialWidgetsAndAnnoyances: Affinity.socialWidgetsAndAnnoyances,
         .other: Affinity.other,
         .custom: Affinity.custom,
         .security: Affinity.security ]
}

struct Affinity: OptionSet {
    
    let rawValue: UInt8
    
    static let general = Affinity(rawValue: 1 << 0)
    static let privacy = Affinity(rawValue: 1 << 1)
    static let socialWidgetsAndAnnoyances = Affinity(rawValue: 1 << 2)
    static let other = Affinity(rawValue: 1 << 3)
    static let custom = Affinity(rawValue: 1 << 4)
    static let security = Affinity(rawValue: 1 << 5)
}

@objc
@objcMembers
class FilterRule: NSObject {
    let text: String
    let affinity: Affinity?
    
    init(text: String, affinity: Affinity?) {
        self.text = text
        self.affinity = affinity
        super.init()
    }
}
