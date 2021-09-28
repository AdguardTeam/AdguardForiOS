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

/// Manage custom dns provider
final class NewDnsServerModel {

    // MARK: - Properties

    /// Provider name
    var providerName: String {
        return provider?.name ?? ""
    }

    /// Provider upstream
    var providerUpstream: String {
        guard let server = provider?.server,
              let upstream = server.upstreams.first?.upstream else { return "" }

        return upstream
    }


    let provider: CustomDnsProviderProtocol?
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let vpnManager: VpnManagerProtocol

    // MARK: - Init

    init(dnsProvidersManager: DnsProvidersManagerProtocol,
         vpnManager: VpnManagerProtocol,
         provider: CustomDnsProviderProtocol? = nil) {

        self.dnsProvidersManager = dnsProvidersManager
        self.vpnManager = vpnManager
        self.provider = provider
    }

    /// Function to add custom provider
    func addCustomProvider(name: String, upstream: String) throws {
        try dnsProvidersManager.addCustomProvider(name: name, upstreams: [upstream], selectAsCurrent: true)
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
}
