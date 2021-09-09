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

import SafariAdGuardSDK
import DnsAdGuardSDK

extension ConfigurationService {
    static var appBundleId: String { Bundle.main.bundleIdentifier ?? "" }
    static var appProductVersion: String  { ADProductInfo().version() ?? "" }
    static var currentLanguage: String { "\(ADLocales.lang() ?? "en")-\(ADLocales.region() ?? "US")" }
    static var appId: String { Bundle.main.isPro ? "ios_pro" : "ios" }
    static var cid: String { UIDevice.current.identifierForVendor?.uuidString ?? "" }
    
    static func createSafariSDKConfig(proStatus: Bool, resources: AESharedResourcesProtocol) -> SafariConfigurationProtocol {
        return SafariConfiguration(iosVersion: UIDevice.current.iosVersion,
                                   currentLanguage: currentLanguage,
                                   proStatus: proStatus,
                                   safariProtectionEnabled: resources.safariProtectionEnabled,
                                   advancedBlockingIsEnabled: true, // TODO: - Don't forget to change
                                   blocklistIsEnabled: resources.safariUserFilterEnabled,
                                   allowlistIsEnabled: resources.safariWhitelistEnabled,
                                   allowlistIsInverted: resources.invertedWhitelist,
                                   appBundleId: appBundleId,
                                   appProductVersion: appProductVersion,
                                   appId: appId,
                                   cid: cid)
    }
    
    static func createDefaultSafariSDKConfig() -> SafariConfigurationProtocol {
        return SafariConfiguration(iosVersion: UIDevice.current.iosVersion,
                                   currentLanguage: currentLanguage,
                                   proStatus: false,
                                   safariProtectionEnabled: true,
                                   advancedBlockingIsEnabled: true, // TODO: - Don't forget to change
                                   blocklistIsEnabled: false,
                                   allowlistIsEnabled: false,
                                   allowlistIsInverted: false,
                                   appBundleId: appBundleId,
                                   appProductVersion: appProductVersion,
                                   appId: appId,
                                   cid: cid)
    }
    
    static func createDnsSDKConfig(proStatus: Bool, resources: AESharedResourcesProtocol) -> DnsConfigurationProtocol {
        let sdkDnsImplementation: DnsAdGuardSDK.DnsImplementation = resources.dnsImplementation == .adGuard ? .adguard : .native
        
        return DnsConfiguration(currentLanguage: currentLanguage,
                                proStatus: proStatus,
                                dnsFilteringIsEnabled: resources.systemProtectionEnabled,
                                dnsImplementation: sdkDnsImplementation,
                                blocklistIsEnabled: resources.systemUserFilterEnabled,
                                allowlistIsEnabled: resources.systemWhitelistEnabled)
    }
    
    static func createDefaultDnsSDKConfig() -> DnsConfigurationProtocol {
        return DnsConfiguration(currentLanguage: currentLanguage,
                                proStatus: false,
                                dnsFilteringIsEnabled: false,
                                dnsImplementation: .adguard,
                                blocklistIsEnabled: false,
                                allowlistIsEnabled: false)
    }
}

