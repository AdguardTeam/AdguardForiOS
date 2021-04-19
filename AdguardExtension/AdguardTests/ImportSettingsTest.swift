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

class ImportSettingsTest: XCTestCase {
    
    var filtersService = FiltersServiceMock()
    var antibanner = AntibannerMock()
    var networking = NetworkMock()
    var dnsFiltersService = DnsFiltersServiceMock()
    var dnsProviders = DnsProvidersServiceMock()
    var purchaseService = PurchaseServiceMock()
    var contentBlockerService = ContentBlockerServiceMock()
    var importService: ImportSettingsServiceProtocol!
    

    override func setUpWithError() throws {
        importService = ImportSettingsService(antibanner: antibanner, networking: networking, filtersService: filtersService, dnsFiltersService: dnsFiltersService, dnsProvidersService: dnsProviders, purchaseService: purchaseService, contentBlockerService: contentBlockerService)
        
        let group = Group(1)
        let filter = Filter(filterId: 2, groupId: 1)
        filter.enabled = false
        group.filters = [filter]
        filtersService.groups = [group]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEnableFilter() {
        var settings = Settings()
        settings.defaultCbFilters = [DefaultCBFilterSettings(id: 2, enable: true)]
        
        let expectation = XCTestExpectation()
        importService.applySettings(settings) { (settings) in
            XCTAssertEqual(settings.defaultCbFilters?.first?.status, .successful)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        for group  in filtersService.groups {
            for filter in group.filters {
                
                if filter.filterId == 2 {
                    XCTAssertTrue(filter.enabled)
                    return
                }
            }
        }
        XCTFail()
    }
    
    func testDisableCBFilter() {
        
        var settings = Settings()
        settings.defaultCbFilters = [DefaultCBFilterSettings(id: 2, enable: false)]
        
        // disable all filters
        for group  in filtersService.groups {
            for filter in group.filters {
                filter.enabled = true
            }
        }
        
        // apply settings
        let expectation = XCTestExpectation()
        importService.applySettings(settings) { (settings) in
            XCTAssertEqual(settings.defaultCbFilters?.first?.status, .successful)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // check result
        for group  in filtersService.groups {
            for filter in group.filters {
                
                if filter.filterId == 2 {
                    XCTAssertFalse(filter.enabled)
                    return
                }
            }
        }
        XCTFail()
    }
    
    func testAddCustomFilter() {
        var settings = Settings()
        settings.customCbFilters = [CustomCBFilterSettings(name: "custom", url: "custom_url")]
        
        let customGroup = Group(AdGuardFilterGroup.custom.rawValue)
        filtersService.groups = [customGroup]
        
        networking.response = URLResponse(url: URL(string: "custom_url")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        networking.returnString = "rules"
        
        let expectation = XCTestExpectation()
        importService.applySettings(settings) { (settings) in
            
            let filter = customGroup.filters.first
            XCTAssertNotNil(filter)
            XCTAssertEqual(filter?.enabled, true)
            XCTAssertEqual(filter?.name, "custom")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddCustomDnsFilter() {
        var settings = Settings()
        settings.dnsFilters = [DnsFilterSettings(name: "custom_dns", url: "custom_dns_url")]
        
        dnsFiltersService.filters = []
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            let newFilter = self.dnsFiltersService.filters.first
            XCTAssertNotNil(newFilter)
            XCTAssertEqual(newFilter?.name, "custom_dns")
            XCTAssertEqual(newFilter?.subscriptionUrl, "custom_dns_url")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSelectDnsServer() {
        var settings = Settings()
        settings.dnsServerId = 123
        
        let provider = DnsProviderInfo(name: "ag family", providerId: 100)
        provider.servers = [DnsServerInfo(dnsProtocol: .doh, serverId: "123", name: "ag family test", upstreams: [], providerId: 100)]
        dnsProviders.allProviders = [provider]
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            let activeServer = dnsProviders.activeDnsServer
            XCTAssertNotNil(activeServer)
            XCTAssertEqual(activeServer?.serverId, "123")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testActivateLicense() {
        
        var settings = Settings()
        settings.license = "license"
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            XCTAssertTrue(purchaseService.activateLicesnseCalled)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddUserRules() {
        var settings = Settings()
        settings.userRules = ["rule"]
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            let userRules = antibanner.rules[ASDF_USER_FILTER_ID as! NSNumber]
            XCTAssertEqual(userRules!.first!.ruleText, "rule")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddDnsRule() {
        var settings = Settings()
        settings.dnsUserRules = ["rule"]
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            XCTAssertEqual(dnsFiltersService.userRules.first, "rule")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOverrideDnsRules() {
        var settings = Settings()
        settings.overrideDnsUserRules = true
        
        settings.dnsUserRules = ["rule"]
        
        dnsFiltersService.userRules = ["old_rule"]
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            XCTAssertEqual(dnsFiltersService.userRules.count, 1)
            XCTAssertEqual(dnsFiltersService.userRules.first, "rule")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOverrideCBRules() {
        var settings = Settings()
        settings.userRules = ["rule"]
        settings.overrideUserRules = true
        
        antibanner.rules[ASDF_USER_FILTER_ID as NSNumber] = [ASDFilterRule(text: "old_rule", enabled: true)]
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            let userRules = antibanner.rules[ASDF_USER_FILTER_ID as NSNumber]
            XCTAssertEqual(userRules?.count, 2)
            XCTAssertEqual(userRules![0].ruleText, "old_rule")
            XCTAssertEqual(userRules![0].isEnabled, false)
            XCTAssertEqual(userRules![1].ruleText, "rule")
            XCTAssertEqual(userRules![1].isEnabled, true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOverrideDnsFilter() {
        var settings = Settings()
        settings.dnsFilters = [DnsFilterSettings(name: "new_dns_filter_name", url: "new_dns_filter_url")]
        settings.overrideDnsFilters = true
        
        dnsFiltersService.filters = [DnsFilter(subscriptionUrl: "old_url", name: "old_name", date: Date(), enabled: true, desc: nil, importantDesc: nil, version: nil, rulesCount: nil, homepage: nil)]
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            let filters = self.dnsFiltersService.filters
            XCTAssertEqual(filters.count, 2)
            XCTAssertEqual(filters[1].name, "new_dns_filter_name")
            XCTAssertEqual(filters[1].subscriptionUrl, "new_dns_filter_url")
            
            XCTAssertFalse(filters[0].enabled)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOverrideCBFilters() {
        
        // set old filters settings
        let group = Group(1)
        let filter1 = Filter(filterId: 1, groupId: 1)
        filter1.enabled = true
        let filter2 = Filter(filterId: 2, groupId: 1)
        filter2.enabled = false
        group.filters = [filter1, filter2]
        group.enabled = true
        
        filtersService.groups = [group]
        
        // fill new settings
        var settings = Settings()
        settings.defaultCbFilters = [DefaultCBFilterSettings(id: 2, enable: true)] // enable filter2
        settings.overrideCbFilters = true
        
        let expectation = XCTestExpectation()
        
        importService.applySettings(settings) { [unowned self] (settings) in
            
            let groups = self.filtersService.groups
            
            XCTAssertEqual(groups[0].filters[0].enabled, false) // override works
            XCTAssertEqual(groups[0].filters[1].enabled, true) // apply filter settings works
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
