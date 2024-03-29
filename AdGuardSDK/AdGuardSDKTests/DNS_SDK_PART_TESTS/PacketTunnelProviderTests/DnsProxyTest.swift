import XCTest

class DnsProxyTest: XCTestCase {

    var proxySettingsProvider: DnsProxyConfigurationProviderMock!
    var dnsProxy: DnsProxyProtocol!

    override func setUp() {
        proxySettingsProvider = DnsProxyConfigurationProviderMock()
        dnsProxy = DnsProxy(
            proxySettingsProvider: proxySettingsProvider,
            statisticsDbContainerUrl: TestsFileManager.workingUrl
        )
    }

    func testStart() {
        proxySettingsProvider.stubbedGetProxyConfigResult = DnsProxyConfiguration(
            upstreams: [],
            fallbacks: [],
            dns64Upstreams: [],
            filters: [],
            ipv6Available: true,
            rulesBlockingMode: .customAddress,
            hostsBlockingMode: .customAddress,
            blockedResponseTtlSecs: 200,
            customBlockingIpv4: nil,
            customBlockingIpv6: nil,
            blockIpv6: false
        )

        let systemDnsUpstream = DnsUpstream(upstream: "8.8.8.8", protocol: .dns)
        let error = dnsProxy.start([systemDnsUpstream])
        XCTAssertNotNil(error)
        XCTAssertEqual(proxySettingsProvider.invokedResetCount, 1)

        // TODO: - Finish the test
    }

    // TODO: - Need more tests
}
