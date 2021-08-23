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

protocol DnsProvidersVendorProtocol {
    /**
     Returns DNS providers objects with actual states relying on active provider, server and DNS implementation
     - Parameter implementation: DNS implementation. Native implementation doesn't support some DNS protocols, so this function will return only supported objects
     - Parameter activeDns: Active DNS info. It stores active provider and server id
     - Returns objects with their actual states
     */
    func getProvidersWithState(for implementation: DnsImplementation, activeDns: DnsProvidersManager.ActiveDnsInfo) -> DnsProvidersVendor.Providers
}

/**
 This object is responsible for vendoring DNS providers objects with actual states
 */
final class DnsProvidersVendor: DnsProvidersVendorProtocol {
    
    // MARK: - Providers
    
    struct Providers {
        let predefined: [DnsProviderProtocol]
        let custom: [CustomDnsProviderProtocol]
        let activeDnsProvider: DnsProviderMetaProtocol
        let activeDnsServer: DnsServerMetaProtocol
    }
    
    // MARK: - Private variables
    
    private let predefinedProviders: [PredefinedDnsProvider]
    private let customProvidersStorage: CustomDnsProvidersStorageProtocol
    
    // MARK: - Initialization
    
    init(predefinedProviders: PredefinedDnsProvidersDecoderProtocol, customProvidersStorage: CustomDnsProvidersStorageProtocol) {
        self.predefinedProviders = predefinedProviders.providers
        self.customProvidersStorage = customProvidersStorage
    }
    
    // MARK: - Public methods
    
    /**
     The main difficulty of setting DNS providers and servers states is the fact that not all DNS protocols are supported in Native Implementation.
     The goal of this function is to return only supported servers and providers and to set **isEnabled** states.
     Constructing DNS providers with states consists of 3 steps:
     1. We need to reveal active DNS provider and server id.
     2. According to this ids set active provider and server
     3. Return created objects
     */
    func getProvidersWithState(for implementation: DnsImplementation, activeDns: DnsProvidersManager.ActiveDnsInfo) -> Providers {
        // 1st step
        let revealedActiveDns = revealActiveDns(for: implementation, activeDns: activeDns)
        
        // 2nd step
        let predefined = makePredefinedProviders(for: implementation, with: revealedActiveDns)
        let custom = makeCustomProviders(for: implementation, with: revealedActiveDns)
            
        let enabledProvider: DnsProviderMetaProtocol
        let enabledServer: DnsServerMetaProtocol

        if let provider = predefined.1, let server = predefined.2 {
            enabledProvider = provider
            enabledServer = server
        } else {
            enabledProvider = custom.1!
            enabledServer = custom.2!
        }
        
        // 3rd step
        return Providers(predefined: predefined.0, custom: custom.0, activeDnsProvider: enabledProvider, activeDnsServer: enabledServer)
    }
    
    // MARK: - Private methods
    
    private func revealActiveDns(for implementation: DnsImplementation, activeDns: DnsProvidersManager.ActiveDnsInfo) -> DnsProvidersManager.ActiveDnsInfo {
        // Need to check if current DNS could be suppoted by implementation
        var enabledProvider: DnsProviderMetaProtocol?
        var enabledServer: DnsServerMetaProtocol?
        
        // Iterate over predefined providers searching for active provider and server
        providersLoop: for pr in predefinedProviders {
            // Need to remove system default server in native implementation
            if implementation == .native && pr.providerId == PredefinedDnsProvider.systemDefaultProviderId {
                continue
            }
            
            let isEnabled = pr.providerId == activeDns.providerId
            if isEnabled {
                let servers = pr.servers.map { DnsServer(server: $0, isEnabled: false) }
                enabledProvider = DnsProvider(provider: pr, servers: servers, isEnabled: false)
                for sr in servers {
                    let serverIsEnabled = sr.id == activeDns.serverId
                    // Check if enabled server is suppported by implementation
                    if serverIsEnabled && implementation.supportedProtocols.contains(sr.type) {
                        enabledServer = sr
                        break providersLoop
                    }
                }
            }
        }
        
        // Iterate over custom providers searhing for active provider and server
        for cst in customProvidersStorage.providers {
            let isEnabled = cst.providerId == activeDns.providerId
            if isEnabled {
                enabledProvider = cst
                let serverIsEnabled = cst.server.id == activeDns.serverId
                // Check if enabled server is suppported by implementation
                if serverIsEnabled && implementation.supportedProtocols.contains(cst.server.type) {
                    enabledServer = cst.server
                    break
                }
            }
        }
        
        // If one of these variables is nil than it means that either server or provider is not supported
        // In that case we set AdGuard DoH server as default
        let shouldSetAdguardProvider = enabledProvider == nil || enabledServer == nil
        let adguardDnsInfo = DnsProvidersManager.ActiveDnsInfo(providerId: PredefinedDnsProvider.adguardDnsProviderId,
                                                               serverId: PredefinedDnsServer.adguardDohServerId)
        let revealedActiveDns = shouldSetAdguardProvider ? adguardDnsInfo : activeDns
        
        return revealedActiveDns
    }
    
    private func makePredefinedProviders(for implementation: DnsImplementation,
                                         with activeDns: DnsProvidersManager.ActiveDnsInfo) -> ([DnsProvider], DnsProviderMetaProtocol?, DnsServerMetaProtocol?) {
        
        var enabledProvider: DnsProviderMetaProtocol?
        var enabledServer: DnsServerMetaProtocol?
        
        let predefined: [DnsProvider] = predefinedProviders.compactMap { provider in
            // Need to remove system default server in native implementation
            if implementation == .native && provider.providerId == PredefinedDnsProvider.systemDefaultProviderId {
                return nil
            }
            
            let servers = provider.servers.compactMap { predefinedServer -> DnsServer? in
                let serverIsEnabled = predefinedServer.id == activeDns.serverId
                if implementation.supportedProtocols.contains(predefinedServer.type) {
                    let server = DnsServer(server: predefinedServer, isEnabled: serverIsEnabled)
                    if serverIsEnabled {
                        enabledServer = server
                    }
                    return server
                } else {
                    return nil
                }
            }
            
            if servers.isEmpty {
                return nil
            } else {
                let providerIsEnabled = provider.providerId == activeDns.providerId
                let prov = DnsProvider(provider: provider, servers: servers, isEnabled: providerIsEnabled)
                if providerIsEnabled {
                    enabledProvider = prov
                }
                return prov
            }
        }
        return (predefined, enabledProvider, enabledServer)
    }
    
    private func makeCustomProviders(
        for implementation: DnsImplementation,
        with activeDns: DnsProvidersManager.ActiveDnsInfo
    ) -> ([CustomDnsProvider], DnsProviderMetaProtocol?, DnsServerMetaProtocol?) {
        
        var enabledProvider: DnsProviderMetaProtocol?
        var enabledServer: DnsServerMetaProtocol?
        
        let customProviders: [CustomDnsProvider] = customProvidersStorage.providers.compactMap { provider in
            if implementation.supportedProtocols.contains(provider.server.type) {
                let serverIsEnabled = provider.server.id == activeDns.serverId
                let server = CustomDnsServer(upstreams: provider.server.upstreams,
                                             providerId: provider.providerId,
                                             type: provider.server.type,
                                             id: provider.server.id,
                                             isEnabled: serverIsEnabled)
                
                if serverIsEnabled {
                    enabledServer = server
                }
                
                let providerIsEnabled = provider.providerId == activeDns.providerId
                let provider = CustomDnsProvider(name: provider.name,
                                                 server: server,
                                                 providerId: provider.providerId,
                                                 isEnabled: providerIsEnabled)
                if providerIsEnabled {
                    enabledProvider = provider
                }
                return provider
            } else {
                return nil
            }
        }
        return (customProviders, enabledProvider, enabledServer)
    }
}
