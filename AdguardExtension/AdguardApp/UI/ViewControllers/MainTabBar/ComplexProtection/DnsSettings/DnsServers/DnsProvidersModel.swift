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
final class DnsProvidersModel {
    
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
        guard let serverId = provider.enabledServerId else { return }
        try dnsProvidersManager.selectProvider(withId: provider.providerId, serverId: serverId)
        vpnManager.updateSettings(completion: nil)
    }
    

    
    //MARK: - Private methods
    private func getCellModels(providers: [DnsProviderMetaProtocol]) -> [DnsProviderCellModel] {        
        var result: [DnsProviderCellModel] = []
        for provider in providers {
            result.append(prepareCellModel(provider: provider))
        }
        return result
    }
    
    private func prepareCellModel(provider: DnsProviderMetaProtocol) -> DnsProviderCellModel {
        let name = provider.name
        var description: String?
        
        if let predefined = provider as? DnsProviderProtocol {
            description = predefined.providerDescription
        }
        
        return DnsProviderCellModel(name: name,
                                    description: description,
                                    isCurrent: provider.isEnabled,
                                    isDefaultProvider: provider.providerId == 10000, // id of system default provider
                                    isCustomProvider: provider.isCustom,
                                    providerId: provider.providerId,
                                    provider: provider)
    }
}
