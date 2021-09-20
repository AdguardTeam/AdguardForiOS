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
import UIKit

/// Delegate for details controller
protocol DnsProviderDetailsModelDelegate: AnyObject {
    func serverSelected()
}

/// Model protocol
protocol DnsProviderDetailsModelProtocol {
    /// Provider logo for light color theme
    var providerLogo: UIImage? { get }
    /// Provider logo for dark color theme
    var providerDarkLogo: UIImage? { get }
    /// Provider url
    var providerHomepage: String { get }
    /// List of provider features
    var features: [DnsAdGuardSDK.DnsFeature] { get }
    /// Provider description
    var providerDescription: String { get }
    /// List of supported  protocols by this provider
    var dnsProtocols: [DnsAdGuardSDK.DnsProtocol] { get }
    /// Selected dns server
    var selectedDnsServer: DnsAdGuardSDK.DnsProtocol { get }
    
    /// This function select chosen server call delegate and restart vpn
    func selectServer(dnsProtocol: DnsAdGuardSDK.DnsProtocol)
}

/// ViewModel
final class DnsProviderDetailsModel: DnsProviderDetailsModelProtocol {
    
    
    //MARK: - Public properties
    var providerLogo: UIImage? {
        return provider.logo
    }
    
    var providerDarkLogo: UIImage? {
        //Not all providers have dark logo
        return provider.logoDark ?? providerLogo
    }
    
    var providerHomepage: String {
        return provider.homepage
    }
    
    var features: [DnsAdGuardSDK.DnsFeature] {
        var maxFeaturesIndex = 0
        let servers = provider.servers
        for i in 0..<servers.count {
            if servers[i].features.count > maxFeaturesIndex {
                maxFeaturesIndex = i
            }
        }
        return servers[maxFeaturesIndex].features
    }
    
    var providerDescription: String {
        return provider.providerDescription
    }
    
    var dnsProtocols: [DnsAdGuardSDK.DnsProtocol] {
        return provider.dnsServers.map { $0.type }
    }
    
    var selectedDnsServer: DnsAdGuardSDK.DnsProtocol {
     //TODO: return selected server protocol
        return .dns
    }

    
    weak var delegate: DnsProviderDetailsModelDelegate?
    
    //MARK: - Private properties
    private let provider: DnsProviderProtocol
    private let dnsProviderManager: DnsProvidersManagerProtocol
    private let vpnManager: VpnManagerProtocol
    
    //MARK: - Init
    init(provider: DnsProviderProtocol, dnsProviderManager: DnsProvidersManagerProtocol, vpnManager: VpnManagerProtocol) {
        self.provider = provider
        self.dnsProviderManager = dnsProviderManager
        self.vpnManager = vpnManager
    }
    
    //MARK: - Public methods
    func selectServer(dnsProtocol: DnsAdGuardSDK.DnsProtocol) {
        do {
            guard let serverId = getServerId(by: dnsProtocol) else { return }
            try dnsProviderManager.selectProvider(withId: provider.providerId, serverId: serverId)
            vpnManager.updateSettings(completion: nil)
            delegate?.serverSelected()
        } catch {
            
        }
    }
    
    //MARK: - Private methods
    private func getServerId(by dnsProtocol: DnsAdGuardSDK.DnsProtocol) -> Int? {
        var defaultServerId: Int?
        let server = provider.servers.first {
            if $0.type == .dns {
                defaultServerId = $0.id
            }
            
            return $0.type == dnsProtocol
        }
        
        return server?.id ?? defaultServerId
    }
}
