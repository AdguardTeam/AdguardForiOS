
import XCTest

class ContentBlockerTest: XCTestCase {
    
    var resources: SharedResourcesMock!
    var safari: SafariServiceMock!
    var contentBlocker: ContentBlockerService!
    var antibanner: AntibannerMock!
    
    override func setUp() {
        resources = SharedResourcesMock()
        safari = SafariServiceMock()
        antibanner = AntibannerMock()
        
        contentBlocker = ContentBlockerService(resources: resources, safariService: safari, antibanner: antibanner)
        contentBlocker.createConverter = {
            return (ConverterMock(), nil)
        }
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
    
    func testAffinityBlocks(rules: [ASDFilterRule], expectedJsonGeneral: String, expectedJsonOther: String) {
        
        XCTAssertNil(contentBlocker.replaceUserFilter([]))
        
        XCTAssertTrue(antibanner.import(rules, filterId: ASDF_ENGLISH_FILTER_ID as NSNumber))
        XCTAssertEqual(antibanner.activeRules(forFilter: ASDF_ENGLISH_FILTER_ID as NSNumber), rules)
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
            XCTAssertNil(error)
            
            let dataGeneral = self.safari.jsons[ContentBlockerType.general]
            let jsonString = String(data: dataGeneral!, encoding:.utf8)
            let dataOther = self.safari.jsons[ContentBlockerType.other]
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

    func testReloadWithoutErrors() {
        let expectation = XCTestExpectation(description: "reload jsons")
        
        contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testReloadWithErrors() {
        let expectation = XCTestExpectation(description: "reload jsons")
        
        safari.errors = [.general: true]
        
        contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testMultipleReloadWithoutErrors() {
        let expectation = XCTestExpectation(description: "reload jsons")
        expectation.expectedFulfillmentCount = 10
        
        for _ in 0..<10 {
            contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
                XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testMultipleReloadWithErrors() {
        let expectation = XCTestExpectation(description: "reload jsons")
        expectation.expectedFulfillmentCount = 10
        
        safari.errors = [.general: true]
        
        for _ in 0..<10 {
            contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
