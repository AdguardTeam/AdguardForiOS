
import XCTest
import NetworkExtension

class NESettingsExtensionTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testIpv4Cidr() throws {
        let settings = NEIPv4Route.routeWithCidr("0.0.0.2/31")
        XCTAssertEqual(settings?.destinationAddress, "0.0.0.2")
        XCTAssertEqual(settings?.destinationSubnetMask, "255.255.255.254")
    }

    func testIpv6Cidr() throws {
        let settings = NEIPv6Route.routeWithCidr("::/127")
        XCTAssertEqual(settings?.destinationAddress, "::")
        XCTAssertEqual(settings?.destinationNetworkPrefixLength, 127)
    }

}
