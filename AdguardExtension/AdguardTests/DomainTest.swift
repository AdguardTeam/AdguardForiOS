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

    func testFindDomains() {
        let domainWithSubdomains = "some.string.with.domain.and.subdomains.com"
        XCTAssertEqual(Domain.findDomains(in: domainWithSubdomains).first!, domainWithSubdomains)

        let singleDomain = "foo.bar"
        XCTAssertEqual(Domain.findDomains(in: singleDomain).first!, singleDomain)

        let domainWithDigitsAndOtherSymbols = "some-string.with123.dom--ain.and.subdomains.com"
        XCTAssertEqual(Domain.findDomains(in: domainWithDigitsAndOtherSymbols).first!, domainWithDigitsAndOtherSymbols)

        let wrongDomain1 = "someDomain"
        XCTAssertEqual(Domain.findDomains(in: wrongDomain1).count, 0)

        let wrongDomain2 = "someDomain#$%$"
        XCTAssertEqual(Domain.findDomains(in: wrongDomain2).count, 0)

        let wrongDomain3 = "someDomain..net"
        XCTAssertEqual(Domain.findDomains(in: wrongDomain3).count, 0)

        let wrongDomain4 = "foo.b"
        XCTAssertEqual(Domain.findDomains(in: wrongDomain4).count, 0)

        let wrongDomain5 = "some-.domain"
        XCTAssertEqual(Domain.findDomains(in: wrongDomain5).count, 0)

        let foreignLanguageDomainWithSubdomains = "하위.도메인이.있는.일부.줄.한국"
        XCTAssertEqual(Domain.findDomains(in: foreignLanguageDomainWithSubdomains).first!, foreignLanguageDomainWithSubdomains)

        let foreignLanguageDomain = "фуу.бар"
        XCTAssertEqual(Domain.findDomains(in: foreignLanguageDomain).first!, foreignLanguageDomain)

        let foreignLanguageDomainWithDigitsAndOtherSymbols = "하-위.도메123인--이.있는.일부.줄.한국"
        XCTAssertEqual(Domain.findDomains(in: foreignLanguageDomainWithDigitsAndOtherSymbols).first!, foreignLanguageDomainWithDigitsAndOtherSymbols)

        let multipleDomainsWithSubdomains = "someSchema://somedomain.with.sub.domains.com?parameter=another.domain.with.sub.domains.ru"
        let result = Domain.findDomains(in: multipleDomainsWithSubdomains)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "somedomain.with.sub.domains.com")
        XCTAssertEqual(result[1], "another.domain.with.sub.domains.ru")
    }
}
