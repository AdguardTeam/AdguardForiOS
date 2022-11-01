import XCTest

class String_ipAddressValidation_Test: XCTestCase {

    private let ipV4ValidCase = "1.1.1.1"
    private let ipV4WithPortValidCases = ["1.1.1.1:34", "1.1.1.1:1", "1.1.1.1:65535"]

    private let ipV4NonValidCases = [
        "0.0.0.12310231230",
        "1.1.1.256",
        "1.1.1.1.",
        ".1.1.1.1",
        "1.1.",
        ".1.1",
        "1.foo",
        "foo.1",
        "foo",
        "foo.",
        ".foo",
        ".",
        "",
    ]
    private let ipV4WithPortNonValidCases = [
        "1.1.1.1.:",
        "1.1.1.1:-1",
        ":1.1.1.1.",
        "1.1.1.1.:99999999",
        "9999999:1.1.1.1",
        "1.1.:",
        "1.1.:123",
        ":1.1.",
        "123:1.1.",
        "1.foo:",
        "1.foo:123",
        ":1.foo",
        "123:1.foo",
        "foo:",
        "foo:123",
        ":foo",
        "123:foo",
        ".:",
        ".:123",
        ":.",
        "123:.",
        ":",
        ":123",
        "123:",
        "",
    ]


    private let ipV6ValidCases = ["ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff", "ffff:ffff::ffff:ffff", "ffff::", "::ffff:ffff"]
    private let ipV6WithPortValidCases = [
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]:8080",
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]:65535",
        "[ffff:ffff::ffff:ffff]:111",
        "[ffff::]:1",
        "[::ffff:ffff]:3444",
    ]

    private let ipV6NonValidCases = ["ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff:", "ffff:ffff:ffff:", "ffff:ffff:ffff:ffff:foo:ffff:ffff:ffff", "foo", ":", ""]
    private let ipV6WithPortNonValidCases = [
        "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff[]:",
        "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff:[]",
        ":[]ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff",
        "[]:ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff",
        "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff:]",
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff:",
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff:]",
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]",
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]:",
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]:-1",
        "[ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff]:999999999",
        "ffff:ffff:ffff:]",
        "[ffff:ffff:ffff:",
        "[ffff:ffff:ffff:]",
        "[ffff:ffff:ffff:]:",
        "[ffff:ffff:ffff:]:-1",
        "[ffff:ffff:ffff:]:9999999999",
        "ffff:ffff:ffff:ffff:foo:ffff:ffff:ffff",
        "ffff:ffff:ffff:ffff:foo:ffff:ffff:ffff]",
        "[ffff:ffff:ffff:ffff:foo:ffff:ffff:ffff",
        "[ffff:ffff:ffff:ffff:foo:ffff:ffff:ffff]:-1",
        "[ffff:ffff:ffff:ffff:foo:ffff:ffff:ffff]:999999",
        "foo:",
        "foo:123123",
        ":",
        "",
        "[]",
        "[:]:",
        "[]:",
        "]",
        "[",
        "]:",
        "[:",
    ]



    /// Tests valid cases of IPv4
    func testIPv4Validation1() {
        XCTAssert(ipV4ValidCase.isValidIPAddress())
        XCTAssert(ipV4ValidCase.isValidIPv4Address())
        XCTAssert(ipV4ValidCase.isValidIPv4AddressOnly())
        XCTAssertFalse(ipV4ValidCase.isValidIPv4AddressWithPort())
    }

    /// Tests valid cases of IPv4 with port
    func testIPv4Validation2() {
        ipV4WithPortValidCases.forEach {
            XCTAssert($0.isValidIPAddress())
            XCTAssert($0.isValidIPv4Address())
            XCTAssertFalse($0.isValidIPv4AddressOnly())
            XCTAssert($0.isValidIPv4AddressWithPort())
        }
    }

    /// Tests non valid cases of IPv4
    func testIPv4Validation3() {
        ipV4NonValidCases.forEach {
            XCTAssertFalse($0.isValidIPAddress())
            XCTAssertFalse($0.isValidIPv4Address())
            XCTAssertFalse($0.isValidIPv4AddressOnly())
            XCTAssertFalse($0.isValidIPv4AddressWithPort())
        }
    }

    /// Tests non valid cases of IPv4 with port
    func testIPv4Validation4() {
        ipV4WithPortNonValidCases.forEach {
            XCTAssertFalse($0.isValidIPAddress())
            XCTAssertFalse($0.isValidIPv4Address())
            XCTAssertFalse($0.isValidIPv4AddressOnly())
            XCTAssertFalse($0.isValidIPv4AddressWithPort())
        }
    }



    /// Tests valid cases of IPv6
    func testIPv6Validation1() {
        ipV6ValidCases.forEach {
            XCTAssert($0.isValidIPAddress())
            XCTAssert($0.isValidIPv6Address())
            XCTAssert($0.isValidIPv6AddressOnly())
            XCTAssertFalse($0.isValidIPv6AddressWithPort())
        }
    }

    /// Tests valid cases of IPv6 with port
    func testIPv6Validation2() {
        ipV6WithPortValidCases.forEach {
            XCTAssert($0.isValidIPAddress())
            XCTAssert($0.isValidIPv6Address())
            XCTAssertFalse($0.isValidIPv6AddressOnly())
            XCTAssert($0.isValidIPv6AddressWithPort())
        }
    }

    /// Tests non valid cases of IPv6
    func testIPv6Validation3() {
        ipV6NonValidCases.forEach {
            XCTAssertFalse($0.isValidIPAddress())
            XCTAssertFalse($0.isValidIPv6Address())
            XCTAssertFalse($0.isValidIPv6AddressOnly())
            XCTAssertFalse($0.isValidIPv6AddressWithPort())
        }
    }

    /// Tests non valid cases of IPv6 with port
    func testIPv6Validation4() {
        ipV6WithPortNonValidCases.forEach {
            XCTAssertFalse($0.isValidIPAddress())
            XCTAssertFalse($0.isValidIPv6Address())
            XCTAssertFalse($0.isValidIPv6AddressOnly())
            XCTAssertFalse($0.isValidIPv6AddressWithPort())
        }
    }
}
