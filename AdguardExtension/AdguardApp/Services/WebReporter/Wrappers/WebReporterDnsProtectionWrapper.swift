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

import DnsAdGuardSDK

//TODO: Need write tests
/// Dns protection web reporter wrapper aggregate info about dns protection, dns servers and dns filters
struct WebReporterDnsProtectionWrapper: WebReporterWrapperProtocol {
    
    //MARK: - Private properties
    private let dnsProtection: DnsProtectionProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersManager: DnsProvidersManagerProtocol = ServiceLocator.shared.getService()!
    
    //MARK: - Public methods
    func collectParams() -> [String : String] {
        var params: [String: String] = [:]
        
        let dnsIsEnabled = dnsProtection.dnsProtectionEnabled
        params["dns.enabled"] = dnsIsEnabled ? "true" : "false"
        
        guard dnsIsEnabled else { return params }
        let server = dnsProvidersManager.activeDnsServer
        let dnsFilters = collectPreparedDnsFilters()
        let dnsServers = collectPreparedDnsServers(server: server)
        params["dns.filters_enabled"] = dnsFilters.isEmpty ? "false" : "true"
        if !dnsFilters.isEmpty { params["dns.filters"] = dnsFilters }
        if !dnsServers.isEmpty { params["dns.servers"] = dnsServers }
        
        return params
    }
    
    //MARK: - Private methods
    private func collectPreparedDnsFilters() -> String {
        return dnsProtection.filters.reduce("") { partialResult, filter in
            if filter.isEnabled {
                let separator = partialResult.isEmpty ? "" : ","
                return partialResult + "\(separator)\(filter.subscriptionUrl)"
            }
            return partialResult
        }
    }
    
    private func collectPreparedDnsServers(server: DnsServerMetaProtocol) -> String {
        return server.upstreams.reduce("") { partialResult, server in
            let separator = partialResult.isEmpty ? "" : ","
            return partialResult + "\(separator)\(server.upstream)"
        }
    }
}
