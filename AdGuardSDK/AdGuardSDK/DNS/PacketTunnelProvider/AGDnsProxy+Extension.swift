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

import AGDnsProxy

// MARK: - AGDnsStamp + DnsProtocol

extension AGDnsStamp {
    var dnsProtocol: DnsProtocol { proto.dnsProtocol }
}

// MARK: - AGStampProtoType + DnsProtocol

extension AGStampProtoType {
    var dnsProtocol: DnsProtocol {
        switch self {
        case .AGSPT_PLAIN: return .dns
        case .AGSPT_DOH: return .doh
        case .AGSPT_TLS: return .dot
        case .AGSPT_DNSCRYPT: return .dnscrypt
        case .AGSPT_DOQ: return .doq
        @unknown default:
            assertionFailure("Unhandled AGStampProtoType type")
            return .dns
        }
    }
}

// MARK: - AGDnsUpstream + DnsProxyUpstream init

extension AGDnsUpstream {
    static func initialize(from upstream: DnsProxyUpstream) -> AGDnsUpstream {
        let dnsUpstream = AGDnsUpstream()
        dnsUpstream.address = upstream.dnsUpstreamInfo.upstream
        dnsUpstream.bootstrap = upstream.dnsBootstraps.map { $0.upstream }
        dnsUpstream.serverIp = nil
        dnsUpstream.id = upstream.id
        dnsUpstream.outboundInterfaceName = nil

        return dnsUpstream
    }

    var extendedDescription: String {
        return  """
                address: \(address ?? "nil")
                bootstrap: \(bootstrap ?? [])
                id: \(id)
                outboundInterfaceName: \(outboundInterfaceName ?? "nil")
                """
    }
}

// MARK: - AGDnsFilterParams + DnsProxyFilter init

extension AGDnsFilterParams {

    static func initialize(from filter: DnsProxyFilter) -> AGDnsFilterParams{
        let filterId = filter.filterId
        let filterData: String
        let inMemory: Bool

        switch filter.filterData {
        case .file(let path):
            filterData = path
            inMemory = false
        case .text(let text):
            filterData = text
            inMemory = true
        }

        let dnsFilterParams = AGDnsFilterParams()
        dnsFilterParams.id = filterId
        dnsFilterParams.data = filterData
        dnsFilterParams.inMemory = inMemory

        return dnsFilterParams
    }
}

// MARK: - AGDns64Settings + DnsProxy64Settings init

extension AGDns64Settings {
    static func initialize(from upstreams: [DnsProxyUpstream]) -> AGDns64Settings {
        let dns64Settings = AGDns64Settings()
        dns64Settings.upstreams = upstreams.map { AGDnsUpstream.initialize(from: $0) }
        dns64Settings.maxTries = 2
        dns64Settings.waitTimeMs = AGDnsProxyConfig.defaultTimeoutMs

        return dns64Settings
    }

    var extendedDescription: String {
        return  """
                upstreams: \(upstreams ?? [])
                maxTries: \(maxTries)
                waitTimeMs: \(waitTimeMs)
                """
    }
}

// MARK: - AGDnsProxyConfig + DnsProxyConfiguration

extension AGDnsProxyConfig {
    /// AGDnsProxy Fallback timeout
    public static let defaultTimeoutMs = 60_000

    /// Initializer for `AGDnsProxyConfig` from `DnsProxyConfiguration`
    /// We use `DnsProxyConfiguration` to be able to test how we configure `AGDnsProxyConfig`
    static func initialize(from configuration: DnsProxyConfiguration) -> AGDnsProxyConfig {
        let defaultConfig = AGDnsProxyConfig.getDefault()!

        let dnsProxyConfiguration = AGDnsProxyConfig()
        dnsProxyConfiguration.upstreams = configuration.upstreams.map { AGDnsUpstream.initialize(from: $0) }
        dnsProxyConfiguration.fallbacks = configuration.fallbacks.map { AGDnsUpstream.initialize(from: $0) }
        dnsProxyConfiguration.fallbackDomains = defaultConfig.fallbackDomains
        dnsProxyConfiguration.detectSearchDomains = defaultConfig.detectSearchDomains
        dnsProxyConfiguration.filters = configuration.filters.map { AGDnsFilterParams.initialize(from: $0) }
        dnsProxyConfiguration.filtersMemoryLimitBytes = defaultConfig.filtersMemoryLimitBytes
        dnsProxyConfiguration.blockedResponseTtlSecs = configuration.blockedResponseTtlSecs
        dnsProxyConfiguration.dns64Settings = AGDns64Settings.initialize(from: configuration.dns64Upstreams)
        dnsProxyConfiguration.listeners = defaultConfig.listeners
        dnsProxyConfiguration.outboundProxy = defaultConfig.outboundProxy
        dnsProxyConfiguration.ipv6Available = configuration.ipv6Available
        dnsProxyConfiguration.blockIpv6 = configuration.blockIpv6
        dnsProxyConfiguration.adblockRulesBlockingMode = configuration.rulesBlockingMode.agRulesBlockingMode
        dnsProxyConfiguration.hostsRulesBlockingMode = configuration.hostsBlockingMode.agHostsRulesBlockingMode
        dnsProxyConfiguration.customBlockingIpv4 = configuration.customBlockingIpv4 ?? defaultConfig.customBlockingIpv4
        dnsProxyConfiguration.customBlockingIpv6 = configuration.customBlockingIpv6 ?? defaultConfig.customBlockingIpv6
        dnsProxyConfiguration.dnsCacheSize = defaultConfig.dnsCacheSize
        dnsProxyConfiguration.optimisticCache = defaultConfig.optimisticCache
        dnsProxyConfiguration.enableDNSSECOK = defaultConfig.enableDNSSECOK
        dnsProxyConfiguration.enableRetransmissionHandling = defaultConfig.enableRetransmissionHandling
        // This feature has initially been added to solve the incompatibility issue with Windscribe VPN:
        // https://github.com/AdguardTeam/AdguardForiOS/issues/1707
        // Unfortunately, it appears to be really unstable and causing issues with the current implementation.
        // We should revive it later when we change the way the network extension handles network change.
        dnsProxyConfiguration.enableRouteResolver = false
        dnsProxyConfiguration.blockEch = false
        dnsProxyConfiguration.helperPath = defaultConfig.helperPath
        dnsProxyConfiguration.upstreamTimeoutMs = UInt(AGDnsProxyConfig.defaultTimeoutMs)

        return dnsProxyConfiguration
    }

    var extendedDescription: String {
        return """
               upstreams:\((upstreams ?? []).map { $0.extendedDescription })
               fallbacks: \((fallbacks ?? []).map { $0.extendedDescription })
               fallbackDomains: \(fallbackDomains ?? [])
               detectSearchDomains: \(detectSearchDomains)
               filters: \(filters ?? [])
               filtersMemoryLimitBytes: \(filtersMemoryLimitBytes)
               blockedResponseTtlSecs: \(blockedResponseTtlSecs)
               dns64Settings: \(dns64Settings.extendedDescription)
               ipv6Available: \(ipv6Available)
               blockIpv6: \(blockIpv6)
               adblockRulesBlockingMode: \(adblockRulesBlockingMode.extendedDescription)
               hostsRulesBlockingMode: \(hostsRulesBlockingMode.extendedDescription)
               customBlockingIpv4: \(customBlockingIpv4 ?? "nil")
               customBlockingIpv6: \(customBlockingIpv6 ?? "nil")
               dnsCacheSize: \(dnsCacheSize)
               optimisticCache: \(optimisticCache)
               enableDNSSECOK: \(enableDNSSECOK)
               enableRetransmissionHandling: \(enableRetransmissionHandling)
               enableRouteResolver: \(enableRouteResolver)
               blockEch: \(blockEch)
               helperPath: \(helperPath ?? "nil")
               upstreamTimeoutMs: \(upstreamTimeoutMs)
               """
    }
}

extension AGBlockingMode {
    var extendedDescription: String {
        switch self {
        case .AGBM_REFUSED:
            return "REFUSED"
        case .AGBM_NXDOMAIN:
            return "NXDOMAIN"
        case .AGBM_ADDRESS:
            return "CUSTOM_IP"
        default:
            return "UNKNOWN"
        }
    }
}
