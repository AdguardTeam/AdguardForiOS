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
        let converter = AllowlistRuleConverter()
        
        var rule = converter.convertDomainToRule(exampleDomain)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        rule = converter.convertDomainToRule(prefix + exampleDomain)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        rule = converter.convertDomainToRule(exampleDomain + suffix)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        rule = converter.convertDomainToRule(prefix + exampleDomain + suffix)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        var domain = converter.convertRuleToDomain(exampleRule)
        XCTAssertEqual(domain, exampleDomain)
        
        domain = converter.convertRuleToDomain(prefix + exampleDomain)
        XCTAssertEqual(domain, exampleDomain)
        
        domain = converter.convertRuleToDomain(exampleDomain + suffix)
        XCTAssertEqual(domain, exampleDomain)
        
        domain = converter.convertRuleToDomain(prefix + exampleDomain + suffix)
        XCTAssertEqual(domain, exampleDomain)
        
        var domains = converter.convertRulesToString(exampleRules)
        XCTAssertEqual(domains, "@@||example1.org^$document/n@@||example2.org^$document/n@@||example3.org^$document")
        
        domains = converter.convertRulesToString(exampleRulesWithoutPrefixAndSufix)
        XCTAssertEqual(domains, "@@||example1.org^$document/n@@||example2.org^$document/n@@||example3.org^$document")
        
        domains = converter.convertRulesToString([])
        XCTAssertEqual(domains, "")

    }
    
    func testInvertedAllowlistConverter() {
        let converter = InvertedAllowlistRuleConverter()
        
        var rule = converter.convertDomainToRule(exampleDomain)
        XCTAssertEqual(rule, invertedAllowlistPrefix + exampleDomain)
        
        rule = converter.convertDomainToRule(invertedAllowlistPrefix + exampleDomain)
        XCTAssertEqual(rule, invertedAllowlistPrefix + exampleDomain)
        
        var domain = converter.convertRuleToDomain(exampleRule)
        XCTAssertEqual(domain, exampleRule)
        
        domain = converter.convertRuleToDomain(invertedAllowlistPrefix + exampleDomain)
        XCTAssertEqual(domain, exampleDomain)
        
        var domains = converter.convertRulesToString(exampleRules)
        XCTAssertEqual(domains, "@@||*$document,domain=~@@||example1.org^$document|~@@||example2.org^$document|~@@||example3.org^$document")
        
        domains = converter.convertRulesToString(exampleRulesWithoutPrefixAndSufix)
        XCTAssertEqual(domains, "@@||*$document,domain=~example1.org|~example2.org|~example3.org")
        
        domains = converter.convertRulesToString([])
        XCTAssertEqual(domains, "@@||*$document")
    }
    
    func testBlocklistRuleConverter() {
        let converter = BlocklistRuleConverter()
        
        var rule = converter.convertDomainToRule(exampleDomain)
        XCTAssertEqual(rule, exampleDomain)
        
        rule = converter.convertDomainToRule(prefix + exampleDomain)
        XCTAssertEqual(rule, prefix + exampleDomain)
        
        rule = converter.convertDomainToRule(exampleDomain + suffix)
        XCTAssertEqual(rule, exampleDomain + suffix)
        
        rule = converter.convertDomainToRule(prefix + exampleDomain + suffix)
        XCTAssertEqual(rule, prefix + exampleDomain + suffix)
        
        var domain = converter.convertRuleToDomain(exampleRule)
        XCTAssertEqual(domain, exampleRule)
        
        domain = converter.convertRuleToDomain(prefix + exampleDomain)
        XCTAssertEqual(domain, prefix + exampleDomain)
        
        domain = converter.convertRuleToDomain(exampleDomain + suffix)
        XCTAssertEqual(domain, exampleDomain + suffix)
        
        domain = converter.convertRuleToDomain(prefix + exampleDomain + suffix)
        XCTAssertEqual(domain, prefix + exampleDomain + suffix)
        
        var domains = converter.convertRulesToString(exampleRules)
        XCTAssertEqual(domains, "@@||example1.org^$document/n@@||example2.org^$document/n@@||example3.org^$document")
        
        domains = converter.convertRulesToString(exampleRulesWithoutPrefixAndSufix)
        XCTAssertEqual(domains, "example1.org/nexample2.org/nexample3.org")
        
        domains = converter.convertRulesToString([])
        XCTAssertEqual(domains, "")
    }
}
