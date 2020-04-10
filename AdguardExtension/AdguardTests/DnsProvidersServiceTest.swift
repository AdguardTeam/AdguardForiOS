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
        let result = dnsProviders.addCustomProvider(name: "test provider", upstream: "0.0.0.0")
        XCTAssertNotNil(result)
        XCTAssert(dnsProviders.customProviders.count == 1)
        XCTAssert(dnsProviders.allProviders.count == 1)
        
        guard let addedProvider = dnsProviders.customProviders.first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(addedProvider.name, "test provider")
        XCTAssertEqual(addedProvider.servers?.first?.upstreams, ["0.0.0.0"])
        XCTAssertEqual(addedProvider.servers?.first?.dnsProtocol, .dns)
    }
    
    func testCustomServerProtocolDohType() {
        let result = dnsProviders.addCustomProvider(name: "test provider", upstream: "https://server")
        XCTAssertNotNil(result)
        let server = dnsProviders.customProviders[0].servers?.first
        XCTAssertEqual(server?.dnsProtocol, .doh)
    }
    
    func testCustomServerProtocolDotType() {
        let result = dnsProviders.addCustomProvider(name: "test provider", upstream: "tls://server")
        XCTAssertNotNil(result)
        let server = dnsProviders.customProviders[0].servers?.first
        XCTAssertEqual(server?.dnsProtocol, .dot)
    }
    
    func testCustomServerProtocolDnsCryptType() {
        let result = dnsProviders.addCustomProvider(name: "test provider", upstream: "sdns://server")
        XCTAssertNotNil(result)
        let server = dnsProviders.customProviders[0].servers?.first
        XCTAssertEqual(server?.dnsProtocol, .dnsCrypt)
    }
    
    func testRemoveServer() {
        _ = dnsProviders.addCustomProvider(name: "test provider1", upstream: "0.0.0.1")
        let providerToRemove = dnsProviders.addCustomProvider(name: "test provider2", upstream: "0.0.0.2")
        _ = dnsProviders.addCustomProvider(name: "test provider3", upstream: "0.0.0.3")
        
        XCTAssert(dnsProviders.customProviders.count == 3)
        XCTAssert(dnsProviders.allProviders.count == 3)
        
        dnsProviders.deleteProvider(providerToRemove)
        
        XCTAssert(dnsProviders.allProviders.count == 2)
        XCTAssertEqual(dnsProviders.allProviders[0].name, "test provider1")
        XCTAssertEqual(dnsProviders.allProviders[1].name, "test provider3")
        
        XCTAssert(dnsProviders.customProviders.count == 2)
        XCTAssertEqual(dnsProviders.customProviders[0].name, "test provider1")
        XCTAssertEqual(dnsProviders.customProviders[1].name, "test provider3")
    }
}
