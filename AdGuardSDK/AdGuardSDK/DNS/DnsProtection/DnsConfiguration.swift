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

/// `PacketTunnelProvider` operating modes
public enum TunnelMode: Int, CustomDebugStringConvertible {
    case split = 0 // Compatible with other VPN apps
    case full // Incompatible with other apps, all traffic is routed via `PacketTunnelProvider`
    case fullWithoutVpnIcon // The same as `full`, but VPN icon in status bar is hidden

    public var debugDescription: String {
        switch self {
        case .split: return "SPLIT"
        case .full: return "FULL"
        case .fullWithoutVpnIcon: return "FULL WITHOUT VPN ICON"
        }
    }
}

/**
 These modes specify how to respond to blocked requests
 This is an `AGDnsProxy` setting
 - Seealso `AGDnsProxy.h`
 */
public enum DnsProxyBlockingMode: Int {
    /// Default blocking mode can be every mode bellow, it is specified in `AGDnsProxy.h`
    case defaultMode = 0

    /// Respond with REFUSED response code
    case refused

    /// Respond with NXDOMAIN response code
    case nxdomain

    /// Respond with an address that is all-zeroes
    case unspecifiedAddress

    /**
     Respond with an address that is all-zeroes, or
     a custom blocking address, if it is specified, or
     an empty SOA response if request type is not A/AAAA.
     */
    case customAddress
}

public protocol DnsConfigurationProtocol: ConfigurationProtocol {
    var blocklistIsEnabled: Bool { get set }
    var allowlistIsEnabled: Bool { get set }
    var dnsFilteringIsEnabled: Bool { get set }
    var dnsImplementation: DnsImplementation { get set }

    // low level settings
    var lowLevelConfiguration: LowLevelDnsConfiguration { get set }
}

/// All DNS protection settings
public final class DnsConfiguration: DnsConfigurationProtocol {
    public var currentLocale: Locale
    public var proStatus: Bool
    public var dnsFilteringIsEnabled: Bool
    public var dnsImplementation: DnsImplementation
    public var blocklistIsEnabled: Bool
    public var allowlistIsEnabled: Bool
    public var lowLevelConfiguration: LowLevelDnsConfiguration

    public init(currentLocale: Locale, proStatus: Bool, dnsFilteringIsEnabled: Bool, dnsImplementation: DnsImplementation, blocklistIsEnabled: Bool, allowlistIsEnabled: Bool, lowLevelConfiguration: LowLevelDnsConfiguration) {
        self.currentLocale = currentLocale
        self.proStatus = proStatus
        self.dnsFilteringIsEnabled = dnsFilteringIsEnabled
        self.dnsImplementation = dnsImplementation
        self.blocklistIsEnabled = blocklistIsEnabled
        self.allowlistIsEnabled = allowlistIsEnabled
        self.lowLevelConfiguration = lowLevelConfiguration
    }
}

/**
 Low level settings user provided for configuring `AGDnsProxy`
 They are configured in `LowLevelSettingsController`
 - Seealso `LowLevelSettingsController.swift`, `AGDnsProxy.h`
 */
public struct LowLevelDnsConfiguration {
    public var tunnelMode: TunnelMode // PacketTunnelProvider operating mode
    public var fallbackServers: [String]? // Fallback upstreams settings
    public var bootstrapServers: [String]? // Bootstrap upstreams settings
    public var blockingMode: DnsProxyBlockingMode // How to respond to requests blocked
    public var blockingIp: String? // Custom address to return for filtered requests
    public var blockedTtl: Int // TTL of the record for the blocked domains (in seconds)
    public var blockIpv6: Bool // Block AAAA requests
    public var restartByReachability: Bool // Reinitialize PacketTunnelProvider when network changes

    public init(tunnelMode: TunnelMode, fallbackServers: [String]? = nil, bootstrapServers: [String]? = nil, blockingMode: DnsProxyBlockingMode, blockingIp: String? = nil, blockedTtl: Int, blockIpv6: Bool, restartByReachability: Bool) {
        self.tunnelMode = tunnelMode
        self.fallbackServers = fallbackServers
        self.bootstrapServers = bootstrapServers
        self.blockingMode = blockingMode
        self.blockingIp = blockingIp
        self.blockedTtl = blockedTtl
        self.blockIpv6 = blockIpv6
        self.restartByReachability = restartByReachability
    }
}

extension DnsConfigurationProtocol {

    //TODO: Need tests
    func updateConfig(with newConfig: DnsConfigurationProtocol) {
        self.currentLocale = newConfig.currentLocale
        self.proStatus = newConfig.proStatus
        self.dnsFilteringIsEnabled = newConfig.dnsFilteringIsEnabled
        self.dnsImplementation = newConfig.dnsImplementation
        self.blocklistIsEnabled = newConfig.blocklistIsEnabled
        self.allowlistIsEnabled = newConfig.allowlistIsEnabled
    }
}
