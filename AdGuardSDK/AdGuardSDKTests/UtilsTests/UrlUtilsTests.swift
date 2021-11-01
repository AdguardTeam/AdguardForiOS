//
///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///
  

import XCTest

class UrlUtilsTests: XCTestCase {

    func test() {
        XCTAssertTrue(UrlUtils.isIpv4("0.0.0.0"))
        XCTAssertTrue(UrlUtils.isIpv4("127.0.0.0"))

        XCTAssertFalse(UrlUtils.isIpv4("256.0.0.0"))
        XCTAssertFalse(UrlUtils.isIpv4("::"))

        XCTAssertTrue(UrlUtils.isIpv6("fe80:0000:0000:0000:0204:61ff:fe9d:f156"))
        XCTAssertTrue(UrlUtils.isIpv6("fe80:0:0:0:204:61ff:fe9d:f156"))
        XCTAssertTrue(UrlUtils.isIpv6("fe80::204:61ff:fe9d:f156"))
        XCTAssertTrue(UrlUtils.isIpv6("fe80:0000:0000:0000:0204:61ff:254.157.241.86"))
        XCTAssertTrue(UrlUtils.isIpv6("fe80:0:0:0:0204:61ff:254.157.241.86"))
        XCTAssertTrue(UrlUtils.isIpv6("fe80::204:61ff:254.157.241.86"))
        XCTAssertTrue(UrlUtils.isIpv6("::1"))
        XCTAssertTrue(UrlUtils.isIpv6("::"))
        XCTAssertTrue(UrlUtils.isIpv6("fe80::"))
        XCTAssertTrue(UrlUtils.isIpv6("2001::"))

        XCTAssertFalse(UrlUtils.isIpv6("127.0.0.0"))
        XCTAssertFalse(UrlUtils.isIpv6("1::1::1"))
    }
}
