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

    // MARK: - Public properties

    let headerTitle: String = String.localizedString("dns_provider_controller_title")

    let headerDescription: String = String.localizedString("dns_provider_controller_description")

    var tableModels: [DnsProvidersTableModel] {
        let allProviders = dnsProvidersManager.allProviders
        return allProviders.map { DnsProvidersTableModel(provider: $0) }
    }

    // MARK: - Private properties

    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let vpnManager: VpnManagerProtocol
    private let resources: AESharedResourcesProtocol

    // MARK: - Init

    init(dnsProvidersManager: DnsProvidersManagerProtocol, vpnManager: VpnManagerProtocol, resources: AESharedResourcesProtocol) {
        self.dnsProvidersManager = dnsProvidersManager
        self.vpnManager = vpnManager
        self.resources = resources
    }

    // MARK: - Public methods

    func setProviderActive(provider: DnsProviderMetaProtocol) throws {
        let serverId = getActiveServerId(provider: provider)
        try dnsProvidersManager.selectProvider(withId: provider.providerId, serverId: serverId)
        vpnManager.updateSettings(completion: nil)
        NotificationCenter.default.post(name: .currentDnsServerChanged, object: nil)
    }

    // MARK: - Private methods

    /// Return enabled server id. If enabled server doesn't exists then return id of first server from `dnsServers` array.
    /// `dnsServers` - is array of provider DNS servers and it is not empty for all  providers
    private func getActiveServerId(provider: DnsProviderMetaProtocol) -> Int {
        if provider.isCustom { return provider.custom.server.id }

        if let activeDnsProtocol = resources.dnsActiveProtocols[provider.providerId] {
            let serverId = provider.dnsServers.first { $0.type == activeDnsProtocol }?.id
            return serverId ?? provider.dnsServers.first!.id
        }

        return provider.dnsServers.first!.id
    }
}

extension Notification.Name {
    static var currentDnsServerChanged: Notification.Name { return .init(rawValue: "currentDnsServerChanged") }
}
