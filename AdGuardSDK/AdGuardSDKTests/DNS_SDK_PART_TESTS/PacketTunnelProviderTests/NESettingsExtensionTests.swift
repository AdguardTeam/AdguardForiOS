
import XCTest
import NetworkExtension

class NESettingsExtensionTests: XCTestCase {

    func testIpv4Cidr() {
        let route = NEIPv4Route.routeWithCidr("0.0.0.2/31")
        XCTAssertEqual(route?.destinationAddress, "0.0.0.2")
        XCTAssertEqual(route?.destinationSubnetMask, "255.255.255.254")
    }

    func testIpv4Cidr2() {
        let route = NEIPv4Route.routeWithCidr("0.0.0.1/1")
        XCTAssertEqual(route?.destinationAddress, "0.0.0.1")
        XCTAssertEqual(route?.destinationSubnetMask, "128.0.0.0")
    }

    func testIpv4Cidr3() {
        let route = NEIPv4Route.routeWithCidr("8.8.8.8/15")
        XCTAssertEqual(route?.destinationAddress, "8.8.8.8")
        XCTAssertEqual(route?.destinationSubnetMask, "255.254.0.0")
    }

    func testIpv4CidrFail() {
        let route = NEIPv4Route.routeWithCidr("1.1.1.1/33")
        XCTAssertNil(route)
    }

    func testIpv4CidrFail2() {
        let route = NEIPv4Route.routeWithCidr("1.1.1.1")
        XCTAssertNil(route)
    }

    func testIpv4CidrFail3() {
        let route = NEIPv4Route.routeWithCidr("::/31")
        XCTAssertNil(route)
    }

    func testIpv6Cidr() {
        let route = NEIPv6Route.routeWithCidr("::/127")
        XCTAssertEqual(route?.destinationAddress, "::")
        XCTAssertEqual(route?.destinationNetworkPrefixLength, 127)
    }

    func testIpv6Fail() {
        let route = NEIPv6Route.routeWithCidr("0.0.0.0/32")
        XCTAssertNil(route)
    }

    func testIpv6Fail2() {
        let route = NEIPv6Route.routeWithCidr("::/129")
        XCTAssertNil(route)
    }
}
