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
    convenience init(from upstream: DnsProxyUpstream) {
        self.init(
            address: upstream.dnsUpstreamInfo.upstream,
            bootstrap: upstream.dnsBootstraps.map { $0.upstream },
            timeoutMs: AGDnsUpstream.defaultTimeoutMs,
            serverIp: nil,
            id: upstream.id,
            outboundInterfaceName: nil
        )
    }

    var extendedDescription: String {
        return  """
                address: \(address ?? "nil")
                bootstrap: \(bootstrap ?? [])
                timeoutMs: \(timeoutMs)
                id: \(id)
                outboundInterfaceName: \(outboundInterfaceName ?? "nil")
                """
    }
}

// MARK: - AGDnsFilterParams + DnsProxyFilter init

extension AGDnsFilterParams {
    convenience init(from filter: DnsProxyFilter) {

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

        self.init(
            id: filterId,
            data: filterData,
            inMemory: inMemory
        )
    }
}

// MARK: - AGDns64Settings + DnsProxy64Settings init

extension AGDns64Settings {
    convenience init(from upstreams: [DnsProxyUpstream]) {
        self.init(
            upstreams: upstreams.map { AGDnsUpstream(from: $0) },
            maxTries: 2,
            waitTimeMs: AGDnsUpstream.defaultTimeoutMs
        )
    }

    var extendedDescription: String {
        return  """
                upstreams: \(upstreams ?? [])
                maxTries: \(maxTries)
                waitTimeMs: \(waitTimeMs)
                """
    }
}

// MARK: - AGDnsUpstream + defaultTimeoutMs

public extension AGDnsUpstream {
    /// AGDnsProxy Fallback timeout
    static let defaultTimeoutMs = 2000
}

// MARK: - AGDnsProxyConfig + DnsProxyConfiguration

extension AGDnsProxyConfig {
    /// Initializer for `AGDnsProxyConfig` from `DnsProxyConfiguration`
    /// We use `DnsProxyConfiguration` to be able to test how we configure `AGDnsProxyConfig`
    convenience init(from configuration: DnsProxyConfiguration) {
        let defaultConfig = AGDnsProxyConfig.getDefault()!

        self.init(
            upstreams: configuration.upstreams.map { AGDnsUpstream(from: $0) },
            fallbacks: configuration.fallbacks.map { AGDnsUpstream(from: $0) },
            fallbackDomains: defaultConfig.fallbackDomains,
            detectSearchDomains: defaultConfig.detectSearchDomains,
            filters: configuration.filters.map { AGDnsFilterParams(from: $0)},
            blockedResponseTtlSecs: configuration.blockedResponseTtlSecs,
            dns64Settings: AGDns64Settings(from: configuration.dns64Upstreams),
            listeners: defaultConfig.listeners,
            outboundProxy: defaultConfig.outboundProxy,
            ipv6Available: configuration.ipv6Available,
            blockIpv6: configuration.blockIpv6,
            adblockRulesBlockingMode: configuration.rulesBlockingMode.agRulesBlockingMode,
            hostsRulesBlockingMode: configuration.hostsBlockingMode.agHostsRulesBlockingMode,
            customBlockingIpv4: configuration.customBlockingIpv4 ?? defaultConfig.customBlockingIpv4,
            customBlockingIpv6: configuration.customBlockingIpv6 ?? defaultConfig.customBlockingIpv6,
            dnsCacheSize: defaultConfig.dnsCacheSize,
            optimisticCache: defaultConfig.optimisticCache,
            enableDNSSECOK: defaultConfig.enableDNSSECOK,
            enableRetransmissionHandling: defaultConfig.enableRetransmissionHandling,
            helperPath: defaultConfig.helperPath
        )
    }

    var extendedDescription: String {
        return """
               upsteams:\((upstreams ?? []).map { $0.extendedDescription })
               fallbacks: \((fallbacks ?? []).map { $0.extendedDescription })
               fallbackDomains: \(fallbackDomains ?? [])
               detectSearchDomains: \(detectSearchDomains)
               filters: \(filters ?? [])
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
               helperPath: \(helperPath ?? "nil")
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
