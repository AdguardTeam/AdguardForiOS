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

import XCTest

class ContentBlockerTest: XCTestCase {
    
    var resources: SharedResourcesMock!
    var safari: SafariServiceMock!
    var contentBlocker: ContentBlockerService!
    var antibanner: AntibannerMock!
    var filtersStorage: FiltersStorageMock!
    
    override func setUp() {
        resources = SharedResourcesMock()
        safari = SafariServiceMock()
        antibanner = AntibannerMock()
        filtersStorage = FiltersStorageMock()
        
        contentBlocker = ContentBlockerService(resources: resources, safariService: safari, antibanner: antibanner, safariProtection: SafariProtectionService(resources: resources), filtersStorage: filtersStorage)
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
        
        let rulesTexts = rules.map({ (r) -> String in
            let rule: ASDFilterRule = r
            let affinity = rule.affinity == nil ? nil : Affinity(rawValue: rule.affinity!.uint8Value)
            return AffinityRulesParser.ruleWithAffinity(rule.ruleText, affinity: affinity)
        })
        
        let filterText = rulesTexts.joined(separator: "\n")
        filtersStorage.filters = [Int(ASDF_ENGLISH_FILTER_ID): filterText]
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        contentBlocker.reloadJsons(backgroundUpdate: false) { (error) in
            XCTAssertNil(error)
            
            let dataGeneral = self.safari.jsons[ContentBlockerType.general]
            let jsonString = String(data: dataGeneral ?? Data(), encoding:.utf8)
            let dataOther = self.safari.jsons[ContentBlockerType.other]
            let jsonStringOther = String(data: dataOther ?? Data(), encoding:.utf8)
            
            XCTAssertEqual(jsonString, expectedJsonGeneral)
            XCTAssertEqual(jsonStringOther, expectedJsonOther)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAffinityBlocks1() {
        let rules: [ASDFilterRule] = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: Affinity.general.rawValue as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: Affinity.general.rawValue as NSNumber)]
        
        let jsonGeneral = "[{\"trigger\":{\"url-filter\":\".*\",\"if-domain\":[\"*example.org\"]},\"action\":{\"type\":\"css-display-none\",\"selector\":\"banner\"}},{\"trigger\":{\"url-filter\":\"^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?example\\\\.org([\\\\/:&\\\\?].*)?$\"},\"action\":{\"type\":\"ignore-previous-rules\"}}]";
        let jsonOther = "[]";
        
        testAffinityBlocks(rules: rules, expectedJsonGeneral: jsonGeneral, expectedJsonOther: jsonOther);
    }
     
    func testAffinityBlocks2() {
        let rules = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: (Affinity.general.rawValue + Affinity.other.rawValue) as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: (Affinity.general.rawValue + Affinity.other.rawValue) as NSNumber)]
        
        let jsonGeneral = "[{\"trigger\":{\"url-filter\":\".*\",\"if-domain\":[\"*example.org\"]},\"action\":{\"type\":\"css-display-none\",\"selector\":\"banner\"}},{\"trigger\":{\"url-filter\":\"^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?example\\\\.org([\\\\/:&\\\\?].*)?$\"},\"action\":{\"type\":\"ignore-previous-rules\"}}]"
        let jsonOther = "[{\"trigger\":{\"url-filter\":\".*\",\"if-domain\":[\"*example.org\"]},\"action\":{\"type\":\"css-display-none\",\"selector\":\"banner\"}},{\"trigger\":{\"url-filter\":\"^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?example\\\\.org([\\\\/:&\\\\?].*)?$\"},\"action\":{\"type\":\"ignore-previous-rules\"}}]"
        
        testAffinityBlocks(rules: rules, expectedJsonGeneral: jsonGeneral, expectedJsonOther: jsonOther);
    }
    
    func testAffinityBlocks3() {
        let rules = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: Affinity.other.rawValue as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: nil)]
        
        let jsonGeneral = "[{\"trigger\":{\"url-filter\":\".*\",\"if-domain\":[\"*example.org\"]},\"action\":{\"type\":\"css-display-none\",\"selector\":\"banner\"}}]"
        let jsonOther = "[{\"trigger\":{\"url-filter\":\"^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?example\\\\.org([\\\\/:&\\\\?].*)?$\"},\"action\":{\"type\":\"ignore-previous-rules\"}}]"
        
        testAffinityBlocks(rules: rules, expectedJsonGeneral: jsonGeneral, expectedJsonOther: jsonOther);
    }
    
    func testAffinityBlocks4() {
        let rules = [ASDFilterRule(text: "@@||example.org^", enabled: true, affinity: 0 as NSNumber),
                     ASDFilterRule(text: "example.org##banner", enabled: true, affinity: nil)]
        
        let jsonGeneral = "[{\"trigger\":{\"url-filter\":\".*\",\"if-domain\":[\"*example.org\"]},\"action\":{\"type\":\"css-display-none\",\"selector\":\"banner\"}},{\"trigger\":{\"url-filter\":\"^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?example\\\\.org([\\\\/:&\\\\?].*)?$\"},\"action\":{\"type\":\"ignore-previous-rules\"}}]"
        let jsonOther = "[{\"trigger\":{\"url-filter\":\"^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?example\\\\.org([\\\\/:&\\\\?].*)?$\"},\"action\":{\"type\":\"ignore-previous-rules\"}}]"
        
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
