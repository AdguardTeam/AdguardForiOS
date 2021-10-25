import XCTest

class DnsProxyConfigurationProviderTest: XCTestCase {

    var dnsProvidersManager: DnsProvidersManagerMock!
    var dnsLibsRulesProvider: DnsLibsRulesProviderMock!
    var dnsConfiguration: DnsConfigurationMock!
    var networkUtils: NetworkUtilsMock!
    var dnsProxyConfigurationProvider: DnsProxyConfigurationProviderProtocol!

    override func setUp() {
        dnsProvidersManager = DnsProvidersManagerMock()
        dnsLibsRulesProvider = DnsLibsRulesProviderMock()
        dnsConfiguration = DnsConfigurationMock()
        networkUtils = NetworkUtilsMock()
        dnsProxyConfigurationProvider = DnsProxyConfigurationProvider(
            dnsProvidersManager: dnsProvidersManager,
            dnsLibsRulesProvider: dnsLibsRulesProvider,
            dnsConfiguration: dnsConfiguration,
            networkUtils: networkUtils
        )
    }

    func test() {
        dnsProvidersManager.stubbedActiveDnsServer = DnsServer(
            features: [],
            upstreams: [DnsUpstream(upstream: "8.8.8.8", protocol: .dns)],
            providerId: 1,
            type: .dns,
            id: 1,
            name: "custom",
            isEnabled: true
        )

        dnsConfiguration.lowLevelConfiguration = LowLevelDnsConfiguration(
            tunnelMode: .split,
            fallbackServers: ["9.9.9.9"],
            bootstrapServers: ["1.1.1.1"],
            blockingMode: .customAddress,
            blockingIpv4: "2.2.2.2",
            blockingIpv6: "::",
            blockedTtl: 200,
            blockIpv6: false,
            restartByReachability: true
        )

        var expectedFilters = [
            DnsProxyFilter(filterId: 0, filterData: .file("path1")),
            DnsProxyFilter(filterId: 1, filterData: .file("path2"))
        ]
        dnsLibsRulesProvider.stubbedEnabledCustomDnsFilters = expectedFilters

        let expectedBlocklistFilter = DnsProxyFilter(filterId: DnsUserRuleType.blocklist.enabledRulesFilterId, filterData: .file("path4"))
        dnsLibsRulesProvider.stubbedBlocklistFilter = expectedBlocklistFilter
        expectedFilters.append(expectedBlocklistFilter)

        let expectedAllowlistFilter = DnsProxyFilter(filterId: DnsUserRuleType.allowlist.enabledRulesFilterId, filterData: .text("allowlist text"))
        dnsLibsRulesProvider.stubbedAllowlistFilter = expectedAllowlistFilter
        expectedFilters.append(expectedAllowlistFilter)
        
        networkUtils.getProtocolResult = .success(.dns)
        networkUtils.isIpv4Available = true
        networkUtils.isIpv6Available = false

        let systemDnsUpstream = DnsUpstream(upstream: "8.8.8.8", protocol: .dns)
        let actualConfig = dnsProxyConfigurationProvider.getProxyConfig([systemDnsUpstream])

        let bootstrap = DnsUpstream(upstream: "1.1.1.1", protocol: .dns)
        let expectedUpstreams = [DnsProxyUpstream(dnsUpstreamInfo: systemDnsUpstream, dnsBootstraps: [bootstrap], id: 0)]
        let fallback = DnsUpstream(upstream: "9.9.9.9", protocol: .dns)
        let expectedFallbacks = [DnsProxyUpstream(dnsUpstreamInfo: fallback, dnsBootstraps: [bootstrap], id: 1)]

        let expectedConfig = DnsProxyConfiguration(
            upstreams: expectedUpstreams,
            fallbacks: expectedFallbacks,
            dns64Upstreams: [],
            filters: expectedFilters,
            ipv6Available: false,
            rulesBlockingMode: .customAddress,
            hostsBlockingMode: .customAddress,
            blockedResponseTtlSecs: 200,
            customBlockingIpv4: "2.2.2.2",
            customBlockingIpv6: "::",
            blockIpv6: false
        )
        XCTAssertEqual(actualConfig, expectedConfig)

        let expectedDnsUpstreamById = [
            0: expectedUpstreams[0],
            1: expectedFallbacks[0]
        ]
        XCTAssertEqual(dnsProxyConfigurationProvider.dnsUpstreamById, expectedDnsUpstreamById)
        XCTAssertEqual(dnsProxyConfigurationProvider.dnsAllowlistFilterId,  DnsUserRuleType.allowlist.enabledRulesFilterId)
        XCTAssertEqual(dnsProxyConfigurationProvider.dnsBlocklistFilterId,  DnsUserRuleType.blocklist.enabledRulesFilterId)

        XCTAssertEqual(dnsLibsRulesProvider.invokedEnabledCustomDnsFiltersGetterCount, 1)
        XCTAssertEqual(dnsLibsRulesProvider.invokedAllowlistFilterGetterCount, 1)
        XCTAssertEqual(dnsLibsRulesProvider.invokedBlocklistFilterGetterCount, 1)
    }

    // TODO: - Need more tests
}
