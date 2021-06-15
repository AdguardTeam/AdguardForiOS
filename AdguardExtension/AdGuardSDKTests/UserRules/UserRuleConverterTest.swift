import XCTest

class UserRuleConverterTest: XCTestCase {
    
    let prefix = "@@||"
    let suffix = "^$document"
    let invertedAllowlistPrefix = "~"
    
    let exampleRule = "@@||example.org^$document"
    let exampleDomain = "example.org"
    
    let exampleRulesWithoutPrefixAndSufix = [UserRule(ruleText: "example1.org", isEnabled: false),
                                             UserRule(ruleText: "example2.org", isEnabled: true),
                                             UserRule(ruleText: "example3.org", isEnabled: false)]
    
    let exampleRules = [UserRule(ruleText: "@@||example1.org^$document", isEnabled: false),
                        UserRule(ruleText: "@@||example2.org^$document", isEnabled: true),
                        UserRule(ruleText: "@@||example3.org^$document", isEnabled: false)]

    func testAllowlistRuleConverter() {
        var rule = AllowlistRuleConverter.convertDomainToRule(exampleDomain)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        rule = AllowlistRuleConverter.convertDomainToRule(prefix + exampleDomain)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        rule = AllowlistRuleConverter.convertDomainToRule(exampleDomain + suffix)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        rule = AllowlistRuleConverter.convertDomainToRule(prefix + exampleDomain + suffix)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        var domain = AllowlistRuleConverter.convertRuleToDomain(exampleRule)
        XCTAssertEqual(domain, exampleDomain)
        
        domain = AllowlistRuleConverter.convertRuleToDomain(prefix + exampleDomain)
        XCTAssertEqual(domain, exampleDomain)
        
        domain = AllowlistRuleConverter.convertRuleToDomain(exampleDomain + suffix)
        XCTAssertEqual(domain, exampleDomain)
        
        domain = AllowlistRuleConverter.convertRuleToDomain(prefix + exampleDomain + suffix)
        XCTAssertEqual(domain, exampleDomain)
        
        var domains = AllowlistRuleConverter.convertRulesToString(exampleRules)
        XCTAssertEqual(domains, "@@||example1.org^$document/n@@||example2.org^$document/n@@||example3.org^$document")
        
        domains = AllowlistRuleConverter.convertRulesToString(exampleRulesWithoutPrefixAndSufix)
        XCTAssertEqual(domains, "@@||example1.org^$document/n@@||example2.org^$document/n@@||example3.org^$document")
        
        domains = AllowlistRuleConverter.convertRulesToString([])
        XCTAssertEqual(domains, "")

    }
    
    func testInvertedAllowlistConverter() {
        var rule = InvertedAllowlistRuleConverter.convertDomainToRule(exampleDomain)
        XCTAssertEqual(rule, invertedAllowlistPrefix + exampleDomain)
        
        rule = InvertedAllowlistRuleConverter.convertDomainToRule(invertedAllowlistPrefix + exampleDomain)
        XCTAssertEqual(rule, invertedAllowlistPrefix + exampleDomain)
        
        var domain = InvertedAllowlistRuleConverter.convertRuleToDomain(exampleRule)
        XCTAssertEqual(domain, exampleRule)
        
        domain = InvertedAllowlistRuleConverter.convertRuleToDomain(invertedAllowlistPrefix + exampleDomain)
        XCTAssertEqual(domain, exampleDomain)
        
        var domains = InvertedAllowlistRuleConverter.convertRulesToString(exampleRules)
        XCTAssertEqual(domains, "@@||*$document,domain=~@@||example1.org^$document|~@@||example2.org^$document|~@@||example3.org^$document")
        
        domains = InvertedAllowlistRuleConverter.convertRulesToString(exampleRulesWithoutPrefixAndSufix)
        XCTAssertEqual(domains, "@@||*$document,domain=~example1.org|~example2.org|~example3.org")
        
        domains = InvertedAllowlistRuleConverter.convertRulesToString([])
        XCTAssertEqual(domains, "@@||*$document")
    }
    
    func testBlocklistRuleConverter() {
        var rule = BlocklistRuleConverter.convertDomainToRule(exampleDomain)
        XCTAssertEqual(rule, exampleDomain)
        
        rule = BlocklistRuleConverter.convertDomainToRule(prefix + exampleDomain)
        XCTAssertEqual(rule, prefix + exampleDomain)
        
        rule = BlocklistRuleConverter.convertDomainToRule(exampleDomain + suffix)
        XCTAssertEqual(rule, exampleDomain + suffix)
        
        rule = BlocklistRuleConverter.convertDomainToRule(prefix + exampleDomain + suffix)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        var domain = BlocklistRuleConverter.convertRuleToDomain(exampleRule)
        XCTAssertEqual(domain, exampleRule)
        
        domain = BlocklistRuleConverter.convertRuleToDomain(prefix + exampleDomain)
        XCTAssertEqual(domain, prefix + exampleDomain)
        
        domain = BlocklistRuleConverter.convertRuleToDomain(exampleDomain + suffix)
        XCTAssertEqual(domain, exampleDomain + suffix)
        
        domain = BlocklistRuleConverter.convertRuleToDomain(prefix + exampleDomain + suffix)
        XCTAssertEqual(domain, prefix + exampleDomain + suffix)
        
        var domains = BlocklistRuleConverter.convertRulesToString(exampleRules)
        XCTAssertEqual(domains, "@@||example1.org^$document/n@@||example2.org^$document/n@@||example3.org^$document")
        
        domains = BlocklistRuleConverter.convertRulesToString(exampleRulesWithoutPrefixAndSufix)
        XCTAssertEqual(domains, "example1.org/nexample2.org/nexample3.org")
        
        domains = BlocklistRuleConverter.convertRulesToString([])
        XCTAssertEqual(domains, "")
    }
}
