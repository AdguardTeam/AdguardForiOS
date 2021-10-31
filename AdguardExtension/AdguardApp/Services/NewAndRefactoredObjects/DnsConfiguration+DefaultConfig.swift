///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import DnsAdGuardSDK

extension DnsConfiguration {
    convenience init(bundle: Bundle = .main, currentLocale: Locale = .current, resources: AESharedResourcesProtocol, isProPurchased: Bool) {
        let sdkDnsImplementation: DnsAdGuardSDK.DnsImplementation = resources.dnsImplementation == .adGuard ? .adGuard : .native
        self.init(
            currentLocale: currentLocale,
            proStatus: bundle.isPro ? true : isProPurchased,
            dnsFilteringIsEnabled: resources.systemProtectionEnabled,
            dnsImplementation: sdkDnsImplementation,
            blocklistIsEnabled: resources.systemUserFilterEnabled,
            allowlistIsEnabled: resources.systemWhitelistEnabled,
            lowLevelConfiguration: LowLevelDnsConfiguration.fromResources(resources)
        )
    }

    static func defaultConfiguration(from resources: AESharedResourcesProtocol, bundle: Bundle = .main, currentLocale: Locale = .current) -> DnsConfiguration {
        return DnsConfiguration(
            currentLocale: currentLocale,
            proStatus: bundle.isPro ? true : false,
            dnsFilteringIsEnabled: false,
            dnsImplementation: .adGuard,
            blocklistIsEnabled: false,
            allowlistIsEnabled: false,
            lowLevelConfiguration: LowLevelDnsConfiguration.defaultConfiguration
        )
    }
}
