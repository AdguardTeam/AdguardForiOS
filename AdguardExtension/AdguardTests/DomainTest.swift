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

    enum DomainTestCases: String {
        case domainWithSubdomains = "some.string.with.domain.and.subdomains.com"
        case singleDomain = "foo.bar"
        case domainWithDigitsAndOtherSymbols = "some-string.with123.dom--ain.and.subdomains.com"

        case wrongDomain1 = "someDomain"
        case wrongDomain2 = "someDomain#$%$"
        case wrongDomain3 = "someDomain..net"
        case wrongDomain4 = "foo.b"
        case wrongDomain5 = "some-.domain"

        case foreignLanguageDomainWithSubdomains = "하위.도메인이.있는.일부.줄.한국"
        case foreignLanguageDomain = "фуу.бар"
        case foreignLanguageDomainWithDigitsAndOtherSymbols = "하-위.도메123인--이.있는.일부.줄.한국"

        case multipleDomainsWithSubdomains = "someSchema://somedomain.with.sub.domains.com?parameter=another.domain.with.sub.domains.ru"
    }

    func testParserWithValidDomains() {
        let validDomains = [ DomainTestCases.domainWithSubdomains.rawValue,
                             DomainTestCases.singleDomain.rawValue,
                             DomainTestCases.domainWithDigitsAndOtherSymbols.rawValue ]

        validDomains.forEach {
            let result = try! Domain.parse($0)
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual($0, result.first!)
        }
    }

    func testParserWithNonValidDomains() {
        let nonValidDomains = [ DomainTestCases.wrongDomain1.rawValue,
                                DomainTestCases.wrongDomain2.rawValue,
                                DomainTestCases.wrongDomain3.rawValue,
                                DomainTestCases.wrongDomain4.rawValue,
                                DomainTestCases.wrongDomain5.rawValue ]

        try! nonValidDomains.forEach {
            XCTAssertThrowsError(try Domain.parse($0)) { error in
                XCTAssertEqual(error as! Domain.ParsingError, Domain.ParsingError.emptyParsingResult)
            }
        }
    }

    func testParseWithEmptyString() {
        XCTAssertThrowsError(try Domain.parse("")) { error in
            XCTAssertEqual(error as! Domain.ParsingError, Domain.ParsingError.emptyInputString)
        }

        XCTAssertThrowsError(try Domain.parse(" ")) { error in
            XCTAssertEqual(error as! Domain.ParsingError, Domain.ParsingError.emptyParsingResult)
        }
    }

    func testParserWithForeignDomains() {
        let validDomain = DomainTestCases.multipleDomainsWithSubdomains.rawValue

        let result = try! Domain.parse(validDomain)
        XCTAssertEqual(result.count, 2)
        result.enumerated().forEach {
            XCTAssertEqual($0.element, $0.offset == 0 ? "somedomain.with.sub.domains.com" : "another.domain.with.sub.domains.ru")
        }
    }
}
