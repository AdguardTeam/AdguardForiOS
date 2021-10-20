/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.

       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.

       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.

       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

protocol DnsProxyConfigurationProviderProtocol {
    /**
     Contains all DNS upstreams that can resolve the request by unique ids
     We use this variable to be able to distinguish upstream that resolved the request
     The DNS-lib will return us id of the upstream and we will look up DNS upstream here
     */
    var dnsUpstreamById: [Int: DnsProxyUpstream] { get }

    /**
     Identifiers of custom DNS filters user did add
     We use this variable to reveal which DNS filter rule worked when blocking/unblocking request
     */
    var customDnsFilterIds: [Int] { get }

    /**
     DNS blocklist rules are stored in files like custom DNS filters
     We use this identifier to know if request was blocklisted by user rules
     */
    var dnsBlocklistFilterId: Int { get }

    /**
     DNS allowlist rules are stored in files like custom DNS filters
     We use this identifier to know if request was allowlisted by user rules
     */
    var dnsAllowlistFilterId: Int { get }

    /**
     Creates and returns configuration for DNS-lib
     - Parameter systemDnsUpstreams: System DNS addresses objects. Should be obtained in `PacketTunnelProvider`
     - Returns configuration that will be passed to DNS-lib
     */
    func getProxyConfig(_ systemDnsUpstreams: [DnsUpstream]) -> DnsProxyConfiguration

    /// Just clears `upstreamById`
    func reset()
}

final class DnsProxyConfigurationProvider: DnsProxyConfigurationProviderProtocol {

    private(set) var dnsUpstreamById: [Int: DnsProxyUpstream] = [:]
    private(set) var customDnsFilterIds: [Int] = []
    private(set) var dnsBlocklistFilterId: Int = -1
    private(set) var dnsAllowlistFilterId: Int = -2

    // MARK: - Private variables

    private var nextUpstreamId: Int { dnsUpstreamById.count }

    /* Services */
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let dnsLibsRulesProvider: DnsLibsRulesProviderProtocol
    private let dnsConfiguration: DnsConfigurationProtocol
    private let networkUtils: NetworkUtilsProtocol

    init(
        dnsProvidersManager: DnsProvidersManagerProtocol,
        dnsLibsRulesProvider: DnsLibsRulesProviderProtocol,
        dnsConfiguration: DnsConfigurationProtocol,
        networkUtils: NetworkUtilsProtocol = NetworkUtils()
    ) {
        self.dnsProvidersManager = dnsProvidersManager
        self.dnsLibsRulesProvider = dnsLibsRulesProvider
        self.dnsConfiguration = dnsConfiguration
        self.networkUtils = networkUtils
    }

    func getProxyConfig(_ systemDnsUpstreams: [DnsUpstream]) -> DnsProxyConfiguration {
        let lowLevelConfiguration = dnsConfiguration.lowLevelConfiguration

        // Reveal DNS bootstraps
        var bootstraps = getDnsUpstreams(from: lowLevelConfiguration.bootstrapServers ?? [])
        if bootstraps.count == 0 {
            bootstraps = systemDnsUpstreams
        }

        // DNS upstreams
        let upstreams = getUpstreams(systemDnsUpstreams)
        let proxyUpstreams: [DnsProxyUpstream] = upstreams.map {
            let id = nextUpstreamId
            let dnsProxy = DnsProxyUpstream(dnsUpstreamInfo: $0, dnsBootstraps: bootstraps, id: id)
            dnsUpstreamById[id] = dnsProxy
            return dnsProxy
        }

        // DNS fallbacks
        let fallbacks = getDnsUpstreams(from: lowLevelConfiguration.fallbackServers ?? [])
        let proxyFallbacks: [DnsProxyUpstream] = fallbacks.map {
            let id = nextUpstreamId
            let dnsProxy = DnsProxyUpstream(dnsUpstreamInfo: $0, dnsBootstraps: bootstraps, id: id)
            dnsUpstreamById[id] = dnsProxy
            return dnsProxy
        }

        /**
         Detect ipv6 addresses,
         We need to use system DNS in dns64Settings variable, that's why we iterate through fallbacks variable
         */
        let ipv6Fallbacks = proxyFallbacks.filter { ACNUrlUtils.isIPv6($0.dnsUpstreamInfo.upstream) }

        // Filters for DNS-lib
        var proxyFilters = dnsLibsRulesProvider.enabledCustomDnsFilters
        customDnsFilterIds = proxyFilters.map { $0.filterId }

        let blocklistFilter = dnsLibsRulesProvider.blocklistFilter
        proxyFilters.append(blocklistFilter)
        dnsBlocklistFilterId = blocklistFilter.filterId

        let allowlistFilter = dnsLibsRulesProvider.allowlistFilter
        dnsAllowlistFilterId = allowlistFilter.filterId
        proxyFilters.append(allowlistFilter)

        return DnsProxyConfiguration(
            upstreams: proxyUpstreams,
            fallbacks: proxyFallbacks,
            dns64Upstreams: ipv6Fallbacks,
            filters: proxyFilters,
            ipv6Available: networkUtils.isIpv6Available,
            rulesBlockingMode: lowLevelConfiguration.blockingMode,
            hostsBlockingMode: lowLevelConfiguration.blockingMode,
            blockedResponseTtlSecs: lowLevelConfiguration.blockedTtl,
            customBlockingIpv4: lowLevelConfiguration.blockingIpv4 ?? "0.0.0.0",
            customBlockingIpv6: lowLevelConfiguration.blockingIpv6 ?? "::",
            blockIpv6: lowLevelConfiguration.blockIpv6
        )
    }

    func reset() {
        dnsUpstreamById.removeAll()
        customDnsFilterIds = []
        dnsBlocklistFilterId = -1
        dnsAllowlistFilterId = -2
    }

    ///  Current DNS servers upstreams are empty when default one is selected
    ///  When default is selected we should return system DNS ip addresses
    private func getUpstreams(_ systemDnsUpstreams: [DnsUpstream]) -> [DnsUpstream] {
        let currentDnsServer = dnsProvidersManager.activeDnsServer

        if currentDnsServer.upstreams.isEmpty {
            return systemDnsUpstreams
        } else {
            return currentDnsServer.upstreams
        }
    }

    /// Creates upstreams objects from String representation and sets their protocols (DoH, DoT, etc..)
    private func getDnsUpstreams(from upstreams: [String]) -> [DnsUpstream] {
        return upstreams.map {
            let prot = try? networkUtils.getProtocol(from: $0)
            return DnsUpstream(upstream: $0, protocol: prot ?? .dns)
        }
    }
}
