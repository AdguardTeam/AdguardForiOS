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

/// Dns providers view model
struct DnsProvidersModel {
    
    //MARK: - Public properties
    let headerTitle: String = String.localizedString("dns_provider_controller_title")
    
    let headerDescription: String = String.localizedString("dns_provider_controller_description")
    
    var providers: [DnsProviderCellModel] {
        let allProviders = dnsProvidersManager.allProviders
        return getCellModels(providers: allProviders)
    }
    
    //MARK: - Private properties
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let vpnManager: VpnManagerProtocol
    
    //MARK: - Init
    init(dnsProvidersManager: DnsProvidersManagerProtocol, vpnManager: VpnManagerProtocol) {
        self.dnsProvidersManager = dnsProvidersManager
        self.vpnManager = vpnManager
    }
    
    //MARK: - Public methods
    func setProviderActive(provider: DnsProviderMetaProtocol) throws {
        guard let serverId = getServerId(dnsServers: provider.dnsServers) else { return }
        try dnsProvidersManager.selectProvider(withId: provider.providerId, serverId: serverId)
        vpnManager.updateSettings(completion: nil)
    }
    
    /// Function to add custom provider
    func addCustomProvider(name: String, upstream: String, selectAsCurrent: Bool) throws {
        try dnsProvidersManager.addCustomProvider(name: name, upstreams: [upstream], selectAsCurrent: selectAsCurrent)
        vpnManager.updateSettings(completion: nil)
    }
    
    /// Function to update custom provider
    func updateCustomProvider(newName: String, newUpstream: String, provider: DnsProviderMetaProtocol) throws {
        let providerId = provider.providerId
        try dnsProvidersManager.updateCustomProvider(withId: providerId, newName: newName, newUpstreams: [newUpstream], selectAsCurrent: false)
        vpnManager.updateSettings(completion: nil)
    }
    
    /// Function to remove custom provider
    func removeCustomProvider(provider: DnsProviderMetaProtocol) throws {
        let providerId = provider.providerId
        try dnsProvidersManager.removeCustomProvider(withId: providerId)
        vpnManager.updateSettings(completion: nil)
    }
    
    //MARK: - Private methods
    private func getCellModels(providers: [DnsProviderMetaProtocol]) -> [DnsProviderCellModel] {
        let currentProviderId = dnsProvidersManager.activeDnsServer.providerId
        
        var result: [DnsProviderCellModel] = []
        for provider in providers {
            let isCurrent = currentProviderId == provider.providerId
            result.append(prepareCellModel(provider: provider, isCurrent: isCurrent))
        }
        return result
    }
    
    private func prepareCellModel(provider: DnsProviderMetaProtocol, isCurrent: Bool) -> DnsProviderCellModel {
        let name = provider.name
        var description: String?
        
        if let predefined = provider as? DnsProviderProtocol {
            description = predefined.providerDescription
        }
        
        return DnsProviderCellModel(name: name,
                                    description: description,
                                    isCurrent: isCurrent,
                                    isDefaultProvider: provider.providerId == 10000, // id of system default provider
                                    isCustomProvider: provider.isCustom,
                                    providerId: provider.providerId,
                                    provider: provider)
    }
    
    private func getServerId(dnsServers: [DnsServerMetaProtocol]) -> Int? {
        let serverId = dnsServers.first { $0.isEnabled }?.id
        return serverId ?? dnsServers.first { $0.type == .dns }?.id
    }
}
