
import XCTest

class ContentBlockerTest: XCTestCase {
    
    var resources: SharedResourcesMock!
    var safari: SafariServiceMock!
    var contentBlocker: ContentBlockerService!
    var antibanner: AntibannerMock!
    
    override func setUp() {
        resources = SharedResourcesMock()
        safari = SafariServiceMock()
        
        contentBlocker = ContentBlockerService(resources: resources, safariService: safari)
        contentBlocker.createConverter = {
            return (ConverterMock(), nil)
        }
        
        antibanner = AntibannerMock()
        contentBlocker.antibanner = antibanner
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddUserRule() {
        
        let rule = ASDFilterRule(text: "||google.com^", enabled: true)
    
        XCTAssertNil(contentBlocker.replaceUserFilter([rule]))
        XCTAssertEqual(antibanner.activeRules(forFilter: 0), [rule])
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func addToWhitelist(ruleText: String, jsonText: String, expectedResult: String) {
        
        let rule = ASDFilterRule(text: ruleText, enabled: true)
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        let data = jsonText.data(using: .utf8)
        
        safari.jsons = [ContentBlockerType.general.rawValue: data!]
        
        contentBlocker.addWhitelistRule(rule) { (error) in
            XCTAssertNil(error)
            
            let data = self.safari.jsons[ContentBlockerType.general.rawValue]
            let jsonString = String(data: data!, encoding:.utf8)
            
            XCTAssertTrue(jsonString == expectedResult)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAddWhitelistRule1() {
        addToWhitelist(ruleText: "@@||google.com^|$document", jsonText: "", expectedResult: "[@@||google.com^|$document\n]")
    }
    
    func testAddWhitelistRule2() {
        addToWhitelist(ruleText: "@@||google.com^|$document", jsonText: "[rule]", expectedResult: "[rule,@@||google.com^|$document\n]")
    }
    
    enum invertedDomainAction {
        case add
        case remove
    }
    
    func changeInvertedDomainList(oldDomains: [String], domain: String, jsonText: String, expectedResult: String, action:invertedDomainAction) {
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        let data = jsonText.data(using: .utf8)
        
        safari.jsons = [ContentBlockerType.general.rawValue: data!]
        
        if oldDomains.count > 0 {
            resources.invertedWhitelistContentBlockingObject = AEInvertedWhitelistDomainsObject(domains: oldDomains)
        }
        
        let completion = { (error: Error?) in
            
            XCTAssertNil(error)
            
            let data = self.safari.jsons[ContentBlockerType.general.rawValue]
            let jsonString = String(data: data!, encoding:.utf8)
            
            XCTAssertTrue(jsonString == expectedResult)
            
            expectation.fulfill()
        }
        
        switch action {
        case .add:
            contentBlocker.addInvertedWhitelistDomain(domain, completion: completion)
        case .remove:
            contentBlocker.removeInvertedWhitelistDomain(domain, completion: completion)
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAddInvertedDomain() {
        changeInvertedDomainList(oldDomains: [], domain: "google.com", jsonText: "[rule]", expectedResult: "[rule,\n@@||*$document,domain=~google.com]", action: .add)
    }
    
    func testAddInvertedDomain2() {
        changeInvertedDomainList(oldDomains: ["google.com"], domain: "amazon.com", jsonText: "[rule,\n@@||*$document,domain=~google.com]", expectedResult: "[rule,\n@@||*$document,domain=~google.com|~amazon.com]", action: .add)
    }
    
    func testRemoveInvertedDomain() {
        changeInvertedDomainList(oldDomains: ["google.com"], domain: "google.com", jsonText: "[rule,\n@@||*$document,domain=~google.com]", expectedResult: "[rule,\n@@||*$document,domain=]", action: .remove)
    }
    
    func testRemoveInvertedDomain2() {
        changeInvertedDomainList(oldDomains: ["google.com", "amazon.com"], domain: "google.com", jsonText: "[rule,\n@@||*$document,domain=~google.com|~amazon.com]", expectedResult: "[rule,\n@@||*$document,domain=~amazon.com]", action: .remove)
    }
    
    func testAffinityBlocks(rules: [ASDFilterRule], expectedJsonGeneral: String, expectedJsonOther: String) {
        
        XCTAssertNil(contentBlocker.replaceUserFilter([]))
        
        XCTAssertTrue(antibanner.import(rules, filterId: ASDF_ENGLISH_FILTER_ID as NSNumber))
        XCTAssertEqual(antibanner.activeRules(forFilter: ASDF_ENGLISH_FILTER_ID as NSNumber), rules)
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
            XCTAssertNil(error)
            
            let dataGeneral = self.safari.jsons[ContentBlockerType.general.rawValue]
            let jsonString = String(data: dataGeneral!, encoding:.utf8)
            let dataOther = self.safari.jsons[ContentBlockerType.other.rawValue]
            let jsonStringOther = String(data: dataOther!, encoding:.utf8)
            
            XCTAssertTrue(jsonString == expectedJsonGeneral)
            XCTAssertTrue(jsonStringOther == expectedJsonOther)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAffinityBlocks1() {
        let rules: [ASDFilterRule] = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: Affinity.general.rawValue as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: Affinity.general.rawValue as NSNumber)]
        
        let jsonGeneral = "[@@||example.org^\nexample.org##banner\n]";
        let jsonOther = "";
        
        testAffinityBlocks(rules: rules, expectedJsonGeneral: jsonGeneral, expectedJsonOther: jsonOther);
    }
    
    func testAffinityBlocks2() {
        let rules = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: (Affinity.general.rawValue + Affinity.other.rawValue) as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: (Affinity.general.rawValue + Affinity.other.rawValue) as NSNumber)]
        
        let jsonGeneral = "[@@||example.org^\nexample.org##banner\n]";
        let jsonOther = "[@@||example.org^\nexample.org##banner\n]";
        
        testAffinityBlocks(rules: rules, expectedJsonGeneral: jsonGeneral, expectedJsonOther: jsonOther);
    }
    
    func testAffinityBlocks3() {
        let rules = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: Affinity.other.rawValue as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: nil)]
        
        let jsonGeneral = "[example.org##banner\n]";
        let jsonOther = "[@@||example.org^\n]";
        
        testAffinityBlocks(rules: rules, expectedJsonGeneral: jsonGeneral, expectedJsonOther: jsonOther);
    }
    
    func testAffinityBlocks4() {
        let rules = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: 0 as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: nil)]
        
        let jsonGeneral = "[example.org##banner\n@@||example.org^\n]";
        let jsonOther = "[@@||example.org^\n]";
        
        testAffinityBlocks(rules: rules, expectedJsonGeneral: jsonGeneral, expectedJsonOther: jsonOther);
    }
    
    func testRuleValidation() {
        
        let validRules = [
            "!comment",
            "||blacklist.rule^",
            "@@whitelist.rule^",
            "example.com###abc",
        ]
        
        let invalidRules = [
            "   ",
            "example.com###adg_start_style_inject { display: none!important; } #footer>a { visibility: hidden!important; } #adg_end_style_inject",
            "example.com$$div",
            "example.com$@$script[tag-content=\"banner\"]",
            "example.com%%js",
            "example.com##^abc"
        ]
        
        for rule in validRules {
            XCTAssertTrue(contentBlocker.validateRule(rule))
        }
        
        for rule in invalidRules {
            XCTAssertFalse(contentBlocker.validateRule(rule))
        }
    }

}
