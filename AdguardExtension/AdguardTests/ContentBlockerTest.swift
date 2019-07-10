
import XCTest

class ContentBlockerTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddUserRule() {
        
        let resources = SharedResourcesMock()
        let safari = SafariServiceMock()
        
        let contentBlocker = ContentBlockerService(resources: resources, safariService: safari)
        contentBlocker.createConverter = {
            return (ConverterMock(), nil)
        }
        
        let antibanner = AntibannerMock()
        contentBlocker.antibanner = antibanner
        
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
        let resources = SharedResourcesMock()
        let safari = SafariServiceMock()
        
        let contentBlocker = ContentBlockerService(resources: resources, safariService: safari)
        contentBlocker.createConverter = {
            return (ConverterMock(), nil)
        }
        
        let antibanner = AntibannerMock()
        contentBlocker.antibanner = antibanner
        
        let rule = ASDFilterRule(text: ruleText, enabled: true)
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        let data = jsonText.data(using: .utf8)
        
        safari.jsons = [ContentBlockerType.general.rawValue: data!]
        
        contentBlocker.addWhitelistRule(rule) { (error) in
            XCTAssertNil(error)
            
            let data = safari.jsons[ContentBlockerType.general.rawValue]
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
        
        let resources = SharedResourcesMock()
        let safari = SafariServiceMock()
        
        let contentBlocker = ContentBlockerService(resources: resources, safariService: safari)
        contentBlocker.createConverter = {
            return (ConverterMock(), nil)
        }
        
        let antibanner = AntibannerMock()
        contentBlocker.antibanner = antibanner
        
        let expectation = XCTestExpectation(description: "reload jsons")
        
        let data = jsonText.data(using: .utf8)
        
        safari.jsons = [ContentBlockerType.general.rawValue: data!]
        
        if oldDomains.count > 0 {
            resources.invertedWhitelistContentBlockingObject = AEInvertedWhitelistDomainsObject(domains: oldDomains)
        }
        
        let completion = { (error: Error?) in
            
            XCTAssertNil(error)
            
            let data = safari.jsons[ContentBlockerType.general.rawValue]
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


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
