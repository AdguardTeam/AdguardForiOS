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

public enum TunnelMode: Int {
    case split, full, fullWithoutVpnIcon
    
    public var name: String {
        switch self {
        case .split:
            return "Split"
        case .full:
            return "Full"
        case .fullWithoutVpnIcon:
            return "Full without VPN icon"
        }
    }
}

public enum BlockingMode: Int {
    case `default`, refused, nxdomain, unspecifiedAddress, customAddress
    
    public var name: String {
        switch self {
        case .`default`:
            return "Default"
        case .refused:
            return "REFUSED"
        case .nxdomain:
            return "NXDOMAIN"
        case .unspecifiedAddress:
            return "Unspecified IP"
        case .customAddress:
            return "Custom IP"
        }
    }
}
    
public protocol DnsConfigurationProtocol: ConfigurationProtocol {
    var blocklistIsEnabled: Bool { get set }
    var allowlistIsEnabled: Bool { get set }
    var dnsFilteringIsEnabled: Bool { get set }
    var dnsImplementation: DnsImplementation { get set }
    
    // low level settings
    var tunnelMode: TunnelMode { get set }
    var fallbackServers: [String]? { get set }
    var bootstrapServers: [String]? { get set}
    var blockingMode: BlockingMode { get set }
    var blockingIp: [String]? { get set }
    var blockedTtl: Int { get set}
    var blockIpv6: Bool { get set }
    var restartByReachability: Bool { get set }
}

public final class DnsConfiguration: DnsConfigurationProtocol {
    
    public var currentLanguage: String
    public var proStatus: Bool
    public var dnsFilteringIsEnabled: Bool
    public var dnsImplementation: DnsImplementation
    public var blocklistIsEnabled: Bool
    public var allowlistIsEnabled: Bool
    
    public var tunnelMode: TunnelMode
    public var fallbackServers: [String]?
    public var bootstrapServers: [String]?
    public var blockingMode: BlockingMode
    public var blockingIp: [String]?
    public var blockedTtl: Int
    public var blockIpv6: Bool
    public var restartByReachability: Bool
    
    
    public init(currentLanguage: String, proStatus: Bool, dnsFilteringIsEnabled: Bool, dnsImplementation: DnsImplementation, blocklistIsEnabled: Bool, allowlistIsEnabled: Bool, tunnelMode: TunnelMode, fallbackServers: [String]?, bootstrapServers: [String]?, blockingMode: BlockingMode, blockingIp: [String]?, blockedTtl: Int, blockIpv6: Bool, restartByReachability: Bool) {
        self.currentLanguage = currentLanguage
        self.proStatus = proStatus
        self.dnsFilteringIsEnabled = dnsFilteringIsEnabled
        self.dnsImplementation = dnsImplementation
        self.blocklistIsEnabled = blocklistIsEnabled
        self.allowlistIsEnabled = allowlistIsEnabled
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
