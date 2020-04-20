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

@objc
protocol SupportServiceProtocol {
    func proFeaturesStatus()->String
}

@objc
class SupportService: NSObject, SupportServiceProtocol {
    
    let resources: AESharedResourcesProtocol
    let configuration: ConfigurationServiceProtocol
    let complexProtection: ComplexProtectionServiceProtocol
    let dnsProviders: DnsProvidersServiceProtocol
    let networkSettings: NetworkSettingsServiceProtocol
    let dnsFilters: DnsFiltersServiceProtocol
    
    @objc
    init(resources: AESharedResourcesProtocol, configuration: ConfigurationServiceProtocol, complexProtection: ComplexProtectionServiceProtocol, dnsProviders: DnsProvidersServiceProtocol, networkSettings: NetworkSettingsServiceProtocol, dnsFilters: DnsFiltersServiceProtocol) {
        self.resources = resources
        self.configuration = configuration
        self.complexProtection = complexProtection
        self.dnsProviders = dnsProviders
        self.networkSettings = networkSettings
        self.dnsFilters = dnsFilters
        super.init()
    }
    
    func proFeaturesStatus() -> String {
    
        let tunnelMode: String
        switch resources.tunnelMode {
        case APVpnManagerTunnelModeSplit:
            tunnelMode = "SPLIT"
        case APVpnManagerTunnelModeFull:
            tunnelMode = "FULL"
        case APVpnManagerTunnelModeFullWithoutVPNIcon:
            tunnelMode = "WITHOUT_VPN_ICON"
        default:
            tunnelMode = "UNKNOWN"
        }
        
        let server = dnsProviders.activeDnsServer
        
        var resultString = """
        
        
        PRO:
        Pro feature \(configuration.proStatus ? "ENABLED" : "DISABLED").

        System protection enabled: \( complexProtection.systemProtectionEnabled)
        Tunnel mode \(tunnelMode)
        DNS server: \(server?.name ?? "System default")
        Restart when network changes: \(resources.restartByReachability)
        Filter mobile data: \(networkSettings.filterMobileDataEnabled)
        Filter wi-fi data: \(networkSettings.filterWifiDataEnabled)

        Dns server id: \(server?.serverId ?? "")
        """
        
        for upstream in server?.upstreams ?? [] {
            resultString.append("\r\nDns upstream: \(upstream)")
        }
        
        if networkSettings.exceptions.count > 0 {
            resultString.append("\r\n\r\nWi-Fi exceptions:")
            for exception in networkSettings.exceptions {
                resultString.append("\r\nWi-Fi name=\"\(exception.rule)\" Enabled=\(exception.enabled)")
            }
        }
        
        if dnsFilters.filters.count > 0 {
            resultString.append("Dns filters: \r\n");
            
            for filter in dnsFilters.filters {
                resultString.append("name: \(filter.name ?? "UNDEFINED") id: \(filter.id) url: \(filter.subscriptionUrl ?? "UNDEFINED") enabled: \(filter.enabled)\r\n")
            }
        }
        
        return resultString
    }
}
