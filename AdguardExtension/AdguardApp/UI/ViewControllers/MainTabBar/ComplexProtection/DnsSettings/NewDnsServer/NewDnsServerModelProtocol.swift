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

/// Delegate protocol
protocol NewDnsServerModelDelegate: AnyObject {
    func errorOccurred(message: String)
    func customServerAdded()
    func customServerUpdated()
    func customServerRemoved()
}

///  Protocol to interact with model
protocol NewDnsServerModelProtocol {
    /// Provider name
    var providerName: String { get }
    /// Provider upstream
    var providerUpstream: String { get }
    /// Model delegate
    var delegate: NewDnsServerModelDelegate? { get set }
    
    /// Function to add custom provider
    func addCustomProvider(name: String, upstream: String, selectAsCurrent: Bool)
    /// Function to update custom provider
    func updateCustomProvider(newName: String, newUpstream: String)
    /// Function to remove custom provider
    func removeCustomProvider()
}

/// Manage custom dns provider
final class NewDnsServerModel: NewDnsServerModelProtocol {
    
    //MARK: - Properties
    var providerName: String {
        return provider?.name ?? ""
    }
    
    var providerUpstream: String {
        guard let server = provider?.dnsServers.first,
              let upstream = server.upstreams.first?.upstream else { return "" }
        
        return upstream
    }
    weak var delegate: NewDnsServerModelDelegate?
    
    //MARK: - Private properties
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let vpnManager: VpnManagerProtocol
    private let provider: DnsProviderMetaProtocol?

    //MARK: - Init
    init(dnsProvidersManager: DnsProvidersManagerProtocol, vpnManager: VpnManagerProtocol, provider: DnsProviderMetaProtocol? = nil) {
        self.dnsProvidersManager = dnsProvidersManager
        self.provider = provider
        self.vpnManager = vpnManager
    }
    
    //MARK: - Public methods
    func addCustomProvider(name: String, upstream: String, selectAsCurrent: Bool) {
        do {
            try dnsProvidersManager.addCustomProvider(name: name, upstreams: [upstream], selectAsCurrent: selectAsCurrent)
            vpnManager.updateSettings(completion: nil)
            delegate?.customServerAdded()
        } catch {
            delegate?.errorOccurred(message: String.localizedString("add_custom_dns_server_error"))
        }
    }
    
    func updateCustomProvider(newName: String, newUpstream: String) {
        do {
            guard let providerId = provider?.providerId else { return }
            try dnsProvidersManager.updateCustomProvider(withId: providerId, newName: newName, newUpstreams: [newUpstream], selectAsCurrent: false)
            vpnManager.updateSettings(completion: nil)
            delegate?.customServerUpdated()
        } catch {
            delegate?.errorOccurred(message: String.localizedString("update_custom_dns_server_error"))
        }
    }
    
    func removeCustomProvider() {
        do {
            guard let providerId = provider?.providerId else { return }
            try dnsProvidersManager.removeCustomProvider(withId: providerId)
            vpnManager.updateSettings(completion: nil)
            delegate?.customServerRemoved()
        } catch {
            delegate?.errorOccurred(message: String.localizedString("remove_custom_dns_server_error"))
        }
    }
}
