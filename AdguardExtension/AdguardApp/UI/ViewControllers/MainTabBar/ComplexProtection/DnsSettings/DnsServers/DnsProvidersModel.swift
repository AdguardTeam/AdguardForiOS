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

protocol DnsProvidersModelProtocol {
    
    /// Header title
    var headerTitle: String { get }
    /// Header description
    var headerDescription: String { get }
    /// Default provider for custom dns provider
    var defaultNewDnsServerModel: NewDnsServerModelProtocol { get }
    /// Prepared table view cell model that represent providers
    var providers: [DnsProviderCellModel] { get }
    
    /// Set provider active
    func setProviderActive(with providerId: Int)
    /// Return model for custom provider
    func modelForCustomProvider(providerId: Int) -> NewDnsServerModelProtocol
    /// Return model for predefined provider
    func modelForPredefinedProvider(providerId: Int) -> DnsProviderDetailsModelProtocol?
}
/// Dns provider model that managering selected provider
final class DnsProvidersModel: DnsProvidersModelProtocol {
    
    //MARK: - Public properties
    let headerTitle: String = String.localizedString("dns_provider_controller_title")
    
    let headerDescription: String = String.localizedString("dns_provider_controller_description")
    
    var defaultNewDnsServerModel: NewDnsServerModelProtocol {
        return NewDnsServerModel(dnsProvidersManager: dnsProvidersManager,
                                    vpnManager: vpnManager,
                                    provider: nil)
    }
    
    var providers: [DnsProviderCellModel] {
        
        if resources.dnsImplementation == .native {
            //TODO: Add for native
            return []
        } else {
            let allProviders = dnsProvidersManager.allProviders
            return getCellModels(providers: allProviders)
        }
    }
    
    //MARK: - Private properties
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let resources: AESharedResourcesProtocol
    private let vpnManager: VpnManagerProtocol
    
    //MARK: - Init
    init(dnsProvidersManager: DnsProvidersManagerProtocol, resources: AESharedResourcesProtocol, vpnManager: VpnManagerProtocol) {
        self.dnsProvidersManager = dnsProvidersManager
        self.resources = resources
        self.vpnManager = vpnManager
    }
    
    //MARK: - Public methods
    func setProviderActive(with providerId: Int) {
        do {
            guard let provider = dnsProvidersManager.allProviders.first(where: { $0.providerId == providerId }),
                  let serverId = getServerId(dnsServers: provider.dnsServers) else { return }
            
            try dnsProvidersManager.selectProvider(withId: providerId, serverId: serverId)
            vpnManager.updateSettings(completion: nil)
            
        } catch {
            //TODO: Log
            // delegate show alert error
        }
    }
    
    func modelForCustomProvider(providerId: Int) -> NewDnsServerModelProtocol {
        let provider = dnsProvidersManager.customProviders.first { $0.providerId == providerId }
        return NewDnsServerModel(dnsProvidersManager: dnsProvidersManager,
                                    vpnManager: vpnManager,
                                    provider: provider)
    }
    
    func modelForPredefinedProvider(providerId: Int) -> DnsProviderDetailsModelProtocol? {
        guard let provider = dnsProvidersManager.predefinedProviders.first (where: { $0.providerId == providerId }) else { return nil }
        return DnsProviderDetailsModel(provider: provider,
                                       dnsProviderManager: dnsProvidersManager,
                                       vpnManager: vpnManager)
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
                             isDefaultProvider: provider.providerId == 10000,
                             isCustomProvider: provider.isCustom,
                             providerId: provider.providerId)
    }
    
    private func getServerId(dnsServers: [DnsServerMetaProtocol]) -> Int? {
        let serverId = dnsServers.first { $0.isEnabled }?.id
        return serverId ?? dnsServers.first { $0.type == .dns }?.id
    }
}
