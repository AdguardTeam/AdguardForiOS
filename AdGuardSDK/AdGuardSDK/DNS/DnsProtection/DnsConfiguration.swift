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

public enum TunnelMode: Int, CustomDebugStringConvertible {
    case split = 0
    case full
    case fullWithoutVpnIcon

    public var debugDescription: String {
        switch self {
        case .split: return "SPLIT"
        case .full: return "FULL"
        case .fullWithoutVpnIcon: return "FULL WITHOUT VPN ICON"
        }
    }
}

public enum DnsProxyBlockingMode: Int {
    case `default` = 0
    case refused
    case nxdomain
    case unspecifiedAddress
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

public final class DnsConfiguration: DnsConfigurationProtocol {
    
    public var currentLanguage: String
    public var proStatus: Bool
    public var dnsFilteringIsEnabled: Bool
    public var dnsImplementation: DnsImplementation
    public var blocklistIsEnabled: Bool
    public var allowlistIsEnabled: Bool
    public var lowLevelConfiguration: LowLevelDnsConfiguration
    
    
    public init(currentLanguage: String, proStatus: Bool, dnsFilteringIsEnabled: Bool, dnsImplementation: DnsImplementation, blocklistIsEnabled: Bool, allowlistIsEnabled: Bool, lowLevelConfiguration: LowLevelDnsConfiguration) {
        self.currentLanguage = currentLanguage
        self.proStatus = proStatus
        self.dnsFilteringIsEnabled = dnsFilteringIsEnabled
        self.dnsImplementation = dnsImplementation
        self.blocklistIsEnabled = blocklistIsEnabled
        self.allowlistIsEnabled = allowlistIsEnabled
        self.lowLevelConfiguration = lowLevelConfiguration
    }
}

public struct LowLevelDnsConfiguration {
    public var tunnelMode: TunnelMode
    public var fallbackServers: [String]?
    public var bootstrapServers: [String]?
    public var blockingMode: DnsProxyBlockingMode
    public var blockingIp: String?
    public var blockedTtl: Int
    public var blockIpv6: Bool
    public var restartByReachability: Bool
    
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
        self.currentLanguage = newConfig.currentLanguage
        self.proStatus = newConfig.proStatus
        self.dnsFilteringIsEnabled = newConfig.dnsFilteringIsEnabled
        self.dnsImplementation = newConfig.dnsImplementation
        self.blocklistIsEnabled = newConfig.blocklistIsEnabled
        self.allowlistIsEnabled = newConfig.allowlistIsEnabled
    }
}
