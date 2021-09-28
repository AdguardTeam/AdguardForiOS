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

    // MARK: - Public properties

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

    /// active dns protocol
    var activeDnsProtocol: DnsAdGuardSDK.DnsProtocol {
        get {
            ///Providers alway have server.
            ///If we didn't find active server from User Defaults than we should take first protocol from provider dns servers
            if let activeProtocol = resources.dnsActiveProtocols[provider.providerId] {
                let defaultDnsProtocol = provider.dnsServers.first!.type
                return dnsProtocols.contains(activeProtocol) ? activeProtocol : defaultDnsProtocol
            }

            return provider.dnsServers.first!.type
        }
        set {
            resources.dnsActiveProtocols[provider.providerId] = newValue
        }
    }

    private let provider: DnsProviderProtocol
    private let resources: AESharedResourcesProtocol


    // MARK: - Init

    init(provider: DnsProviderProtocol, resources: AESharedResourcesProtocol) {
        self.provider = provider
        self.resources = resources
    }
}
