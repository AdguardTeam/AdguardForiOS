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

class DomainTest: XCTestCase {

    let domains = [ "some.string.with.domain.and.subdomains.com" : "some.string.with.domain.and.subdomains.com",
                    "foo.bar" : "foo.bar",
                    "some-string.with123.dom--ain.and.subdomains.com" : "some-string.with123.dom--ain.and.subdomains.com",
                    "하위.도메인이.있는.일부.줄.한국" : "하위.도메인이.있는.일부.줄.한국",
                    "фуу.бар" : "фуу.бар",
                    "하-위.도메123인--이.있는.일부.줄.한국" : "하-위.도메123인--이.있는.일부.줄.한국",
                    "someDomain" : nil,
                    "someDomain#$%$" : nil,
                    "someDomain..net" : nil,
                    "foo.b" : nil,
                    "some-.domain" : nil ]

    func testFindDomains() {
        domains.forEach {
            XCTAssertEqual(Domain.findDomains(in: $0).first, $1)
        }

        let multipleDomainsWithSubdomains = "someSchema://somedomain.with.sub.domains.com?parameter=another.domain.with.sub.domains.ru"
        let result = Domain.findDomains(in: multipleDomainsWithSubdomains)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "somedomain.with.sub.domains.com")
        XCTAssertEqual(result[1], "another.domain.with.sub.domains.ru")
    }
}
