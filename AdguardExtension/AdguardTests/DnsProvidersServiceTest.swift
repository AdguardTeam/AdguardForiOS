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

class DnsProvidersServiceTest: XCTestCase {
    
    var resources: SharedResourcesMock!
    var dnsProviders: DnsProvidersService!

    override func setUp() {
        resources = SharedResourcesMock()
        dnsProviders = DnsProvidersService(resources: resources)
    }
    
    func testAddCustomServer() {
        let expectation = XCTestExpectation()
        
        dnsProviders.addCustomProvider(name: "test provider", upstream: "0.0.0.0", {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssert(dnsProviders.customProviders.count == 1)
        XCTAssert(dnsProviders.allProviders.count == dnsProviders.predefinedProviders.count + 1)
        
        guard let addedProvider = dnsProviders.customProviders.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(addedProvider.name, "test provider")
        XCTAssertEqual(addedProvider.servers?.first?.upstreams, ["0.0.0.0"])
        XCTAssertEqual(addedProvider.servers?.first?.dnsProtocol, .dns)
    }
    
    func testCustomServerProtocolDohType() {
        let expectation = XCTestExpectation()
        dnsProviders.addCustomProvider(name: "test provider", upstream: "https://server", {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
        
        let server = dnsProviders.customProviders[0].servers?.first
        XCTAssertEqual(server?.dnsProtocol, .doh)
    }
    
    func testCustomServerProtocolDotType() {
        let expectation = XCTestExpectation()
        dnsProviders.addCustomProvider(name: "test provider", upstream: "tls://server", {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
  
        let server = dnsProviders.customProviders[0].servers?.first
        XCTAssertEqual(server?.dnsProtocol, .dot)
    }
    
    func testCustomServerProtocolDnsCryptType() {
        let expectation = XCTestExpectation()
        dnsProviders.addCustomProvider(name: "test provider", upstream: "sdns://server", {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
        
        let server = dnsProviders.customProviders[0].servers?.first
        XCTAssertEqual(server?.dnsProtocol, .dnsCrypt)
    }
    
    func testRemoveServer() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let expectation3 = XCTestExpectation()
        
        dnsProviders.addCustomProvider(name: "test provider1", upstream: "0.0.0.1", { expectation1.fulfill() })
        dnsProviders.addCustomProvider(name: "test provider2", upstream: "0.0.0.2", { expectation2.fulfill() })
        dnsProviders.addCustomProvider(name: "test provider3", upstream: "0.0.0.3", { expectation3.fulfill() })
        
        wait(for: [expectation1, expectation2, expectation3], timeout: 1.0)
        
        XCTAssert(dnsProviders.customProviders.count == 3)
        XCTAssert(dnsProviders.allProviders.count == 3 + dnsProviders.predefinedProviders.count)
        
        let expectation4 = XCTestExpectation()
        let providerToDelete = dnsProviders.customProviders.first!
        dnsProviders.deleteProvider(providerToDelete, { expectation4.fulfill() })
        wait(for: [expectation4], timeout: 1.0)
        
        XCTAssert(dnsProviders.allProviders.count == 2 + dnsProviders.predefinedProviders.count)
        XCTAssertEqual(dnsProviders.allProviders[dnsProviders.predefinedProviders.count + 0].name, "test provider2")
        XCTAssertEqual(dnsProviders.allProviders[dnsProviders.predefinedProviders.count + 1].name, "test provider3")
        
        XCTAssert(dnsProviders.customProviders.count == 2)
        XCTAssertEqual(dnsProviders.customProviders[0].name, "test provider2")
        XCTAssertEqual(dnsProviders.customProviders[1].name, "test provider3")
    }
    
    func testServerMigration() {
        let oldServer = DnsServerInfo(dnsProtocol: .dns, serverId: "adguard-dns", name: "Adguard", upstreams: ["0.0.0.0"], providerId: nil)
        
        resources.currentAdGuardImplementationDnsServer = oldServer
        
        let providersService = DnsProvidersService(resources: resources)
        
        let migrated = providersService.activeDnsServer
        
        XCTAssertEqual(migrated?.serverId, "1")
    }
    
    func testServerMigration2() {
        let oldServer = DnsServerInfo(dnsProtocol: .dns, serverId: "test-server", name: "Adguard", upstreams: ["0.0.0.0"], providerId: nil)
        
        resources.currentAdGuardImplementationDnsServer = oldServer
        
        let providersService = DnsProvidersService(resources: resources)
        
        let migrated = providersService.activeDnsServer
        
        XCTAssertEqual(migrated?.serverId, "test-server")
    }
    
    func testServerMigration3() {
        
        resources.sharedDefaults().removeObject(forKey: ActiveDnsServer)
        
        let providersService = DnsProvidersService(resources: resources)
        
        let migrated = providersService.activeDnsServer
        
        XCTAssertNil(migrated?.serverId)
    }
    
    func testMalware() {
        
        let providrsService = DnsProvidersService(resources: resources, locale: "en")
        
        for provider in providrsService.predefinedProviders {
            let contains = provider.name.lowercased().contains("malware") || provider.summary?.lowercased().contains("malware") ?? false
            if contains {
                XCTFail("\(provider.name) \(String(describing: provider.summary)) contains 'malware'")
            }
            
            for feature in provider.features ?? [] {
                let contains = feature.title.lowercased().contains("malware") || feature.summary.lowercased().contains("malware")
                
                if contains {
                    XCTFail("\(feature.title) \(feature.summary) contains 'malware'")
                }
            }
        }
    }
    
    func testStrings() {
        let providrsService = DnsProvidersService(resources: resources, locale: "en")
        
        for provider in providrsService.predefinedProviders {
            XCTAssertFalse(provider.name.isEmpty)
            XCTAssertFalse(provider.summary?.isEmpty ?? true)
            
            for feature in provider.features ?? [] {
                XCTAssertFalse(feature.title.isEmpty)
                XCTAssertFalse(feature.summary.isEmpty)
            }
        }
    }
}
