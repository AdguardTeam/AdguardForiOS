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

// MARK: - DnsProxyConfiguration

/**
 This object is a configuration for `AGDnsProxy`
 We use this wrapper to be able to check the settings we pass to `AGDnsProxy`
 */
struct DnsProxyConfiguration: Equatable {
    let upstreams: [DnsProxyUpstream] // DNS upstreams
    let fallbacks: [DnsProxyUpstream] // DNS fallbacks
    let dns64Upstreams: [DnsProxyUpstream] // Upstreams to use for discovery of DNS64 prefixes
    let filters: [DnsProxyFilter] // Filters to pass into proxy
    let ipv6Available: Bool // True if IPv6 is available
    let rulesBlockingMode: DnsProxyBlockingMode // How to respond to requests blocked by AdBlock-style rules
    let hostsBlockingMode: DnsProxyBlockingMode // How to respond to requests blocked by hosts-style rules
    let blockedResponseTtlSecs: Int // TTL of the record for the blocked domains (in seconds)
    let customBlockingIpv4: String? // Custom IPv4 address to return for filtered requests
    let customBlockingIpv6: String? // Custom IPv6 address to return for filtered requests
    let blockIpv6: Bool // Block AAAA requests
}

// MARK: - DnsProxyUpstream

struct DnsProxyUpstream: Equatable {
    let dnsUpstreamInfo: DnsUpstream
    let dnsBootstraps: [DnsUpstream]
    let id: Int
}

// MARK: - DnsProxyBlockingMode

extension DnsProxyBlockingMode {
    var agRulesBlockingMode: AGBlockingMode {
        switch self {
        case .defaultMode: return AGDnsProxyConfig.getDefault().adblockRulesBlockingMode
        case .refused: return .AGBM_REFUSED
        case .nxdomain: return .AGBM_NXDOMAIN
        case .unspecifiedAddress: return .AGBM_ADDRESS
        case .customAddress: return .AGBM_ADDRESS
        }
    }

    var agHostsRulesBlockingMode: AGBlockingMode {
        switch self {
        case .defaultMode: return AGDnsProxyConfig.getDefault().hostsRulesBlockingMode
        case .refused: return .AGBM_REFUSED
        case .nxdomain: return .AGBM_NXDOMAIN
        case .unspecifiedAddress: return .AGBM_ADDRESS
        case .customAddress: return .AGBM_ADDRESS
        }
    }
}
