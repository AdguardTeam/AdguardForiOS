import XCTest

class PacketTunnelSettingsProviderTest: XCTestCase {

    let addresses = PacketTunnelProvider.Addresses(
        tunnelRemoteAddress: "127.0.0.1",
        interfaceIpv4: "172.16.209.3",
        interfaceIpv6: "fd12:1:1:1::3",
        localDnsIpv4: "198.18.0.1",
        localDnsIpv6: "2001:ad00:ad00::ad00",
        defaultSystemDnsServers: ["94.140.14.140", "94.140.14.141", "2a10:50c0::1:ff", "2a10:50c0::2:ff"]
    )
    var networkUtils: NetworkUtilsMock!
    var tunnelSettings: PacketTunnelSettingsProviderProtocol!

    override func setUp() {
        networkUtils = NetworkUtilsMock()
        tunnelSettings = PacketTunnelSettingsProvider(addresses: addresses, networkUtils: networkUtils)
    }

    func testWithIpv4AvailableAndIpv6Available() {
        networkUtils.isIpv4Available = true
        networkUtils.isIpv6Available = true

        let settings = tunnelSettings.createSettings(full: false, withoutVpnIcon: false)

        // Check tunnel remote address
        XCTAssertEqual(settings.tunnelRemoteAddress, addresses.tunnelRemoteAddress)

        // Check DNS settings
        XCTAssertEqual(settings.dnsSettings?.servers.count, 1)
        XCTAssertEqual(settings.dnsSettings?.servers[0], addresses.localDnsIpv4)

        // Check IPv4 settings
        XCTAssertEqual(settings.ipv4Settings?.addresses.count, 1)
        XCTAssertEqual(settings.ipv4Settings?.addresses[0], addresses.interfaceIpv4)
        XCTAssertEqual(settings.ipv4Settings?.subnetMasks.count, 1)
        XCTAssertEqual(settings.ipv4Settings?.subnetMasks[0], "255.255.255.252")
        XCTAssertEqual(settings.ipv4Settings?.includedRoutes?.count, 1)
        XCTAssertEqual(settings.ipv4Settings?.includedRoutes?[0].destinationAddress, "198.18.0.1")
        XCTAssertEqual(settings.ipv4Settings?.includedRoutes?[0].destinationSubnetMask, "255.255.255.255")
        XCTAssertEqual(settings.ipv4Settings?.excludedRoutes?.count, 1)
        XCTAssertEqual(settings.ipv4Settings?.excludedRoutes?[0].destinationAddress, "0.0.0.0")
        XCTAssertEqual(settings.ipv4Settings?.excludedRoutes?[0].destinationSubnetMask, "0.0.0.0")

        // Check IPv6 settings
        XCTAssertEqual(settings.ipv6Settings?.addresses.count, 1)
        XCTAssertEqual(settings.ipv6Settings?.addresses[0], addresses.interfaceIpv6)
        XCTAssertEqual(settings.ipv6Settings?.networkPrefixLengths.count, 1)
        XCTAssertEqual(settings.ipv6Settings?.networkPrefixLengths[0], 64)
        XCTAssertNil(settings.ipv6Settings?.includedRoutes)
        XCTAssertEqual(settings.ipv6Settings?.excludedRoutes?.count, 1)
        XCTAssertEqual(settings.ipv6Settings?.excludedRoutes?[0].destinationAddress, "::")
        XCTAssertEqual(settings.ipv6Settings?.excludedRoutes?[0].destinationNetworkPrefixLength, 0)
    }

    // TODO: - Need more tests
}
