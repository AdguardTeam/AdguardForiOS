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
import NetworkExtension

protocol NativeProvidersServiceProtocol {
    var providers: [DnsProviderInfo] { get }
    
    /* Resets all providers and reinitialize them */
    func reset()
}


class NativeProvidersService: NativeProvidersServiceProtocol {
    
    // MARK: - Public properties
    lazy var providers: [DnsProviderInfo] = { initializeProviders() }()
    
    // MARK: - Private properties
    @available(iOS 14.0, *)
    private var dnsManager: NEDNSSettingsManager { NEDNSSettingsManager.shared() }
    
    /* DNS protocols supported by native implementation */
    private var supportedProtocols = [DnsProtocol.doh, .dot]
    
    // MARK: - Services
    private let dnsProvidersService: DnsProvidersServiceProtocol
    
    required init (dnsProvidersService: DnsProvidersServiceProtocol) {
        self.dnsProvidersService = dnsProvidersService
    }
    
    // MARK: - Public methods
    
    func reset() {
        
    }
    
    // MARK: - Private methods
    
    private func initializeProviders() -> [DnsProviderInfo] {
        let providers = dnsProvidersService.allProviders
        var nativerProviders: [DnsProviderInfo] = []
        for provider in providers {
            let supportedServers = getSupportedServers(provider.servers ?? [])
            let protocols = supportedServers.map { $0.dnsProtocol }
            let nativeProvider = DnsProviderInfo(name: provider.name, logo: provider.logo, logoDark: provider.logoDark, summary: provider.summary, protocols: protocols, features: provider.features, website: provider.website, servers: supportedServers)
            nativerProviders.append(nativeProvider)
        }
        return nativerProviders
    }
    
    /*
     Returns only DoT and DoH servers
     Other DNS protocols are not supported by NEDnsSettings yet
     */
    private func getSupportedServers(_ servers: [DnsServerInfo]) -> [DnsServerInfo] {
        return servers.compactMap { server -> DnsServerInfo? in
            guard supportedProtocols.contains(server.dnsProtocol) else {
                return nil
            }
            return server
        }
    }
    
    @available(iOS 14.0, *)
    private func saveDnsConfiguration(upstreams: [String], description: String, _ onErrorReceived: @escaping (_ error: Error?) -> ()) {
        let configuration = NEDNSSettings(servers: upstreams)
        dnsManager.dnsSettings = configuration
        dnsManager.saveToPreferences(completionHandler: onErrorReceived)
    }
}
