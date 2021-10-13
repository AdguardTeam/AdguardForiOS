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

/// ViewModel
final class DnsProviderDetailsModel {

    // MARK: - Internal properties

    var provider: DnsProviderProtocol

    /// Provider logo for light color theme
    var providerLogo: UIImage? {
        return provider.logo
    }

    /// Provider logo for dark color theme
    var providerDarkLogo: UIImage? {
        //Not all providers have dark logo
        return provider.logoDark ?? providerLogo
    }

    /// Provider url
    var providerHomepage: String {
        return provider.homepage
    }

    /// List of provider features
    var features: [DnsAdGuardSDK.DnsFeature] {
        return provider.servers.first { $0.type == activeDnsProtocol }?.features ?? []
    }

    /// Provider description
    var providerDescription: String {
        return provider.providerDescription
    }

    /// List of supported  protocols by this provider
    var dnsProtocols: [DnsAdGuardSDK.DnsProtocol] {
        return provider.dnsServers.map { $0.type }
    }

    /// Active DNS protocol
    var activeDnsProtocol: DnsAdGuardSDK.DnsProtocol {
        get {
            let defaultDnsProtocol: DnsProtocol

            if provider.dnsServers.contains(where: { $0.type == .doh }) {
                defaultDnsProtocol = .doh
            }
            else if provider.dnsServers.contains(where: { $0.type == .dot }) {
                defaultDnsProtocol = .dot
            }
            else if provider.dnsServers.contains(where: { $0.type == .dns }) {
                defaultDnsProtocol = .dns
            }
            else {
                defaultDnsProtocol = provider.dnsServers.first!.type
            }

            /// Providers must always have at least one server
            /// If we were unable to find the server user did select than we'll take the default one
            if let selectedProtocol = resources.dnsActiveProtocols[provider.providerId] {
                return dnsProtocols.contains(selectedProtocol) ? selectedProtocol : defaultDnsProtocol
            } else {
                return defaultDnsProtocol
            }
        }
        set {
            resources.dnsActiveProtocols[provider.providerId] = newValue
        }
    }

    private let providerId: Int
    private let resources: AESharedResourcesProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol

    // MARK: - Init

    init(providerId: Int, resources: AESharedResourcesProtocol, dnsProvidersManager: DnsProvidersManagerProtocol) {
        self.providerId = providerId
        self.dnsProvidersManager = dnsProvidersManager
        self.resources = resources
        self.provider = dnsProvidersManager.allProviders.first(where: { $0.providerId == providerId })!.predefined
    }

    func dnsImplementationChanged() {
        provider = dnsProvidersManager.allProviders.first(where: { $0.providerId == providerId })!.predefined
    }
}
