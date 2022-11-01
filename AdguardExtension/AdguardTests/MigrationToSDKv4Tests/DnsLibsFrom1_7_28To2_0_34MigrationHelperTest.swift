//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import XCTest
import DnsAdGuardSDK

class DnsLibsFrom1_7_28To2_0_34MigrationHelperTest : XCTestCase {

    private var helper: DnsLibsFrom1_7_28To2_0_34MigrationHelper!
    private var dnsProvidersMock: DnsProvidersManagerMock!

    private let upstreamCases = [
        ("1.1.1.1", "1.1.1.1"),
        ("2606:4700:4700::1001", "2606:4700:4700::1001"),

        ("https://foo.bar", "https://foo.bar"),
        ("tls://foo.bar", "tls://foo.bar"),
        ("sdns://dklfjdsklfjkdlsjfklds", "sdns://dklfjdsklfjkdlsjfklds"),

        ("quic://adguard-dns.com", "quic://adguard-dns.com"),
        ("quic://dns.adguard-dns.com", "quic://dns.adguard-dns.com"),
        ("quic://unfiltere.adguard-dns.com", "quic://unfiltere.adguard-dns.com"),

        ("quic://1.1.1.1", "quic://1.1.1.1:8853"),
        ("quic://1.1.1.1:999", "quic://1.1.1.1:8853"),
        ("quic://2606:4700:4700::1001", "quic://[2606:4700:4700::1001]:8853"),
        ("quic://[2606:4700:4700::1001]:999", "quic://[2606:4700:4700::1001]:8853"),
        ("quic://foo.bar", "quic://foo.bar:8853"),
        ("quic://foo.bar:999", "quic://foo.bar:8853"),

        ("foo", "foo"),
        ("foo.bar", "foo.bar"),
        ("", ""),
    ]

    override func setUp() {
        dnsProvidersMock = DnsProvidersManagerMock()
        helper = DnsLibsFrom1_7_28To2_0_34MigrationHelper(dnsProvider: dnsProvidersMock)
    }



    /// Tests migration with upstreams
    func testMigration_1() {
        XCTAssertFalse(dnsProvidersMock.addCustomProviderCalled)
        XCTAssert(dnsProvidersMock.customProviders.isEmpty)
        fillProviderWithData()
        XCTAssert(dnsProvidersMock.addCustomProviderCalled)
        XCTAssertFalse(dnsProvidersMock.customProviders.isEmpty)

        XCTAssertFalse(dnsProvidersMock.updateCustomProviderCalled)
        try! helper.migrate()
        XCTAssert(dnsProvidersMock.updateCustomProviderCalled)
        XCTAssertFalse(dnsProvidersMock.customProviders.isEmpty)

        dnsProvidersMock.customProviders.enumerated().forEach { index, value in
            XCTAssertEqual(upstreamCases[index].1, value.server.upstreams.first!.upstream)
        }
    }

    /// Tests migration with non existing upstreams
    func testMigration_2() {
        XCTAssert(dnsProvidersMock.customProviders.isEmpty)
        XCTAssertFalse(dnsProvidersMock.updateCustomProviderCalled)
        try! helper.migrate()
        XCTAssertFalse(dnsProvidersMock.updateCustomProviderCalled)
        XCTAssert(dnsProvidersMock.customProviders.isEmpty)
    }

    /// Tests migration error throwing
    func testMigration_3() {
        fillProviderWithData()
        let error = NSError(domain: "test", code: -1)
        dnsProvidersMock.updateCustomProviderError = error

        XCTAssertThrowsError(try helper.migrate())
    }




    private func fillProviderWithData() {
        var index = 0
        upstreamCases.forEach {
            try! dnsProvidersMock.addCustomProvider(name: "Test\(index)", upstreams: [$0.0], selectAsCurrent: false, isMigration: false)
            index += 1
        }
    }
}
