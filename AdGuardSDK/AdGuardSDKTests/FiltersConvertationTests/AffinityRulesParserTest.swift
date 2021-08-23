import XCTest

class AffinityRulesParserTest: XCTestCase {
    
    // MARK: - test parse strings
    
    func testParseStringsWithoutAffinity() {
        // 6 comments 4 rules
        let filterText = """
                        ! Checksum: ZfQYKYYCHnYvVSRxWh6gNw
                        ! Title: AdGuard Base filter (Optimized)
                        ! Description: EasyList + AdGuard English filter. This filter is necessary for quality ad blocking.
                        ! Version: 2.1.81.14
                        ! TimeUpdated: 2021-06-15T13:03:24+00:00
                        ! Expires: 4 days (update frequency)
                        ||cdn.allsportsflix.best^$third-party
                        ||vurobyde.xyz^$third-party
                        ||adnxs-simple.com^$third-party
                        ||main-ti-hub.com^
                        """
        let strings = filterText.components(separatedBy: .newlines)
        
        let rules = AffinityRulesParser.parse(strings: strings)
        XCTAssertEqual(rules.count, 4)
        
        for (index, rule) in rules.enumerated() {
            XCTAssertNil(rule.affinity)
            switch index {
            case 0: XCTAssertEqual(rule.rule, "||cdn.allsportsflix.best^$third-party")
            case 1: XCTAssertEqual(rule.rule, "||vurobyde.xyz^$third-party")
            case 2: XCTAssertEqual(rule.rule, "||adnxs-simple.com^$third-party")
            case 3: XCTAssertEqual(rule.rule, "||main-ti-hub.com^")
            default: XCTFail()
            }
        }
    }
    
    func testParseStringsWithAffinity() {
        // 1 comment; 2 rules; 3 rules with affinity
        let filterText = """
                        ! Checksum: ZfQYKYYCHnYvVSRxWh6gNw
                        ally.sh#@#.adsBox
                        ondemandkorea.com#@#.afs_ads
                        !#safari_cb_affinity(general,privacy)
                        @@||imasdk.googleapis.com/js/sdkloader/ima3.js$domain=ondemandkorea.com
                        @@||production-static.ondemandkorea.com/images^
                        @@||openx.net/|$domain=ondemandkorea.com
                        !#safari_cb_affinity
                        """
        let strings = filterText.components(separatedBy: .newlines)
        
        let rules = AffinityRulesParser.parse(strings: strings)
        XCTAssertEqual(rules.count, 5)
        
        for (index, rule) in rules.enumerated() {
            switch index {
            case 0:
                XCTAssertNil(rule.affinity)
                XCTAssertEqual(rule.rule, "ally.sh#@#.adsBox")
            case 1:
                XCTAssertNil(rule.affinity)
                XCTAssertEqual(rule.rule, "ondemandkorea.com#@#.afs_ads")
            case 2:
                XCTAssertEqual(rule.affinity, [.general, .privacy])
                XCTAssertEqual(rule.rule, "@@||imasdk.googleapis.com/js/sdkloader/ima3.js$domain=ondemandkorea.com")
            case 3:
                XCTAssertEqual(rule.affinity, [.general, .privacy])
                XCTAssertEqual(rule.rule, "@@||production-static.ondemandkorea.com/images^")
            case 4:
                XCTAssertEqual(rule.affinity, [.general, .privacy])
                XCTAssertEqual(rule.rule, "@@||openx.net/|$domain=ondemandkorea.com")
            default:
                XCTFail()
            }
        }
    }
    
    // MARK: - test rule withAffinity
    
    func testRuleWithAffinity() {
        let rule = "@@||imasdk.googleapis.com"
        let ruleWithAffinity = AffinityRulesParser.rule(rule, withAffinity: [.security, .general, .custom])
        let expectedRule = """
                            !#safari_cb_affinity(general,custom,security)
                            @@||imasdk.googleapis.com
                            !#safari_cb_affinity
                            """
        XCTAssertEqual(ruleWithAffinity, expectedRule)
    }
    
    func testRuleWithEmptyAffinity() {
        let rule = "@@||imasdk.googleapis.com"
        let ruleWithAffinity = AffinityRulesParser.rule(rule, withAffinity: [])
        let expectedRule = """
                            !#safari_cb_affinity(all)
                            @@||imasdk.googleapis.com
                            !#safari_cb_affinity
                            """
        XCTAssertEqual(ruleWithAffinity, expectedRule)
    }
    
    func testRuleWithNilAffinity() {
        let rule = "@@||imasdk.googleapis.com"
        let ruleWithAffinity = AffinityRulesParser.rule(rule, withAffinity: nil)
        let expectedRule = "@@||imasdk.googleapis.com"
        XCTAssertEqual(ruleWithAffinity, expectedRule)
    }
    
    func testEmptyRuleWithAffinity() {
        let rule = "  "
        let ruleWithAffinity = AffinityRulesParser.rule(rule, withAffinity: [.general])
        let expectedRule = "  "
        XCTAssertEqual(ruleWithAffinity, expectedRule)
    }
}
