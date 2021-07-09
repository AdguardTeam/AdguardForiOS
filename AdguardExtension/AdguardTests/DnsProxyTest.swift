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

class LogWriterMock: NSObject, DnsLogRecordsWriterProtocol {
    var dnsProxyService: DnsProxyServiceProtocol?
    
    var whitelistFilterId: NSNumber?
    
    var userFilterId: NSNumber?
    
    var otherFilterIds: [NSNumber]?
    
    var server: String = ""
    
    func handleEvent(_ event: AGDnsRequestProcessedEvent) {
        
    }
    
    func flush() {
        
    }
}

class DnsProxyTest: XCTestCase {
    
    var proxyService = DnsProxyService(logWriter: LogWriterMock(), resources: SharedResourcesMock(), dnsProvidersService: DnsProvidersServiceMock());
    let request = Data(base64Encoded: "RQAAQkGPAAD/ETb1rBDRAsYSAAHOlAA1AC47HU+xAQAAAQAAAAAAAAdjbGllbnRzAWwGZ29vZ2xlA2NvbQAAAQAB")

    override func setUp() {
        XCTAssert(proxyService.start(upstreams: ["1.1.1.1"], bootstrapDns: ["8.8.8.8"], fallbacks: ["8.8.8.8"], serverName: "cloudflare", filtersJson: "", userFilterId: 1, whitelistFilterId: 2, ipv6Available: true, rulesBlockingMode: .AGBM_NXDOMAIN, hostsBlockingMode: .AGBM_NXDOMAIN, blockedResponseTtlSecs: 3, customBlockingIpv4: nil, customBlockingIpv6: nil, blockIpv6: false))
    }

    func testResolve() {
        
        let expectation = XCTestExpectation(description: "expectation")
        
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNotNil(response)
            XCTAssert(response!.count > 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15)
    }
    
    func testRestart() {
        
        let expectation = XCTestExpectation(description: "expectation")
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNotNil(response)
            XCTAssert(response!.count > 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15)
        
        let expectation2 = XCTestExpectation(description: "expectation2")
        
        proxyService.stop() {}
        
        XCTAssertTrue(self.proxyService.start(upstreams: ["1.1.1.1"], bootstrapDns: ["8.8.8.8"], fallbacks: ["8.8.8.8"], serverName: "cloudflare", filtersJson: "", userFilterId: 1, whitelistFilterId: 2, ipv6Available: true, rulesBlockingMode: .AGBM_NXDOMAIN, hostsBlockingMode: .AGBM_NXDOMAIN, blockedResponseTtlSecs: 3, customBlockingIpv4: nil, customBlockingIpv6: nil, blockIpv6: false))
        
        proxyService.resolve(dnsRequest: self.request!) { (response) in
            XCTAssertNotNil(response)
            XCTAssert(response!.count > 0)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 15)
    }
    
    func testStopAndResolve() {
        
        let expectation = XCTestExpectation(description: "expectation")
        
        proxyService.stop() { [weak self] in
            self!.proxyService.resolve(dnsRequest: self!.request!) { (response) in
                XCTAssertNil(response)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 15)
        
    }
    
    func testResolveAfterStop() {
        
        let expectation = XCTestExpectation(description: "expectation")
        
        proxyService.stop() { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 15)
        
        let expectation2 = XCTestExpectation(description: "expectation2")
        
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNil(response)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 15)
    }
    
    func testUpstreamsById(){
        proxyService.stop() {}
        
        let ipV6Adress = "0000:0000:0000:0000:0000:0000:0000:0000"
        let isSuccess = self.proxyService.start(upstreams: ["1.1.1.1", "2.2.2.2", "3.3.3.3"], bootstrapDns: ["8.8.8.8"], fallbacks: ["8.8.8.8", ipV6Adress], serverName: "cloudflare", filtersJson: "", userFilterId: 1, whitelistFilterId: 2, ipv6Available: true, rulesBlockingMode: .AGBM_NXDOMAIN, hostsBlockingMode: .AGBM_NXDOMAIN, blockedResponseTtlSecs: 3, customBlockingIpv4: nil, customBlockingIpv6: nil, blockIpv6: false)
        
        XCTAssert(isSuccess)
        
        let upstreams = self.proxyService.upstreamsById
        /* 3 upstreams, 2 fallbacks, 1 ipV6 fallback */
        XCTAssert(upstreams.count == 6)
        
        XCTAssertEqual(upstreams[0]!.upstream, "1.1.1.1")
        XCTAssertEqual(upstreams[1]!.upstream, "2.2.2.2")
        XCTAssertEqual(upstreams[2]!.upstream, "3.3.3.3")
        XCTAssertEqual(upstreams[3]!.upstream, "8.8.8.8")
        XCTAssertEqual(upstreams[4]!.upstream, ipV6Adress)
        XCTAssertEqual(upstreams[5]!.upstream, ipV6Adress)
    }
}
