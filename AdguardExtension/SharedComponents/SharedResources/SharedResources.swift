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

import Foundation

extension AESharedResourcesProtocol {

    // TODO: - Remove obsolete data from defaults when migrating; Keys to delete: AEDefaultsRequests, AEDefaultsEncryptedRequests

    dynamic var tunnelErrorCode: Int? {
        get {
            return sharedDefaults().object(forKey: TunnelErrorCode) as? Int
        }
        set {
            sharedDefaults().set(newValue, forKey: TunnelErrorCode)
        }
    }

    dynamic var appEntryCount: Int {
        get {
            return sharedDefaults().integer(forKey: AEDefaultsAppEntryCount)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsAppEntryCount)
        }
    }

    dynamic var rateAppShown: Bool {
        get {
            return sharedDefaults().bool(forKey: AEDefaultsRateAppShown)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsRateAppShown)
        }
    }

    dynamic var safariWhitelistEnabled: Bool {
        get {
            if let boolObject = sharedDefaults().value(forKey: AEDefaultsSafariWhitelistEnabled) as? Bool {
                return boolObject
            }
            return true
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsSafariWhitelistEnabled)
        }
    }

    dynamic var invertedWhitelist: Bool {
        get {
            sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsInvertedWhitelist)
        }
    }

    dynamic var safariUserFilterEnabled: Bool {
        get {
            if let boolObject = sharedDefaults().value(forKey: AEDefaultsUserFilterEnabled) as? Bool {
                return boolObject
            }
            return true
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsUserFilterEnabled)
        }
    }

    dynamic var systemUserFilterEnabled: Bool {
        get {
            if let boolObject = sharedDefaults().value(forKey: AEDefaultsDnsBlacklistEnabled) as? Bool {
                return boolObject
            }
            return true
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsDnsBlacklistEnabled)
        }
    }

    dynamic var systemWhitelistEnabled: Bool {
        get {
            if let boolObject = sharedDefaults().value(forKey: AEDefaultsDnsWhitelistEnabled) as? Bool {
                return boolObject
            }
            return true
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsDnsWhitelistEnabled)
        }
    }

    dynamic var restartByReachability: Bool {
        get {
            guard let value = sharedDefaults().object(forKey: AEDefaultsRestartByReachability) as? Bool else {
                return false
            }
            return value
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsRestartByReachability)
        }
    }

    dynamic var complexProtectionEnabled: Bool {
        get {
            guard let value = sharedDefaults().object(forKey: AEComplexProtectionEnabled) as? Bool else {
                return true
            }

            return value
        }
        set {
            sharedDefaults().set(newValue, forKey: AEComplexProtectionEnabled)
        }
    }

    dynamic var needUpdateFilters: Bool {
        get {
            return sharedDefaults().bool(forKey: NeedToUpdateFiltersKey)
        }
        set {
            sharedDefaults().set(newValue, forKey: NeedToUpdateFiltersKey)
        }
    }

    dynamic var buildVersion: Int {
        get {
            return sharedDefaults().integer(forKey: AEDefaultsProductBuildVersion)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsProductBuildVersion)
        }
    }

    dynamic var purchasedThroughInApp: Bool {
        get {
            return sharedDefaults().bool(forKey: AEDefaultsIsProPurchasedThroughInApp)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsIsProPurchasedThroughInApp)
        }
    }

    dynamic var purchasedThroughSetapp: Bool {
        get {
            return sharedDefaults().bool(forKey: AEDefaultsIsProPurchasedThroughSetapp)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsIsProPurchasedThroughSetapp)
        }
    }

    dynamic var customFallbackServers: [String]? {
           get {
               return sharedDefaults().array(forKey: CustomFallbackServers) as? [String]
           }

           set {
               sharedDefaults().setValue(newValue, forKey: CustomFallbackServers)
           }
       }

       dynamic var customBootstrapServers: [String]? {
           get {
               return sharedDefaults().array(forKey: CustomBootstrapServers) as? [String]
           }

           set {
               sharedDefaults().setValue(newValue, forKey: CustomBootstrapServers)
           }
       }



    dynamic var blockedResponseTtlSecs: Int {
        get {
            guard let ttl = sharedDefaults().object(forKey: BlockedResponseTtlSecs) as? Int else { return 2 }
            return ttl
        }
        set {
            sharedDefaults().setValue(newValue, forKey: BlockedResponseTtlSecs)
        }
    }

    dynamic var customBlockingIpv4: String? {
        get {
            return sharedDefaults().string(forKey: CustomBlockingIpv4)
        }
        set {
            sharedDefaults().setValue(newValue, forKey: CustomBlockingIpv4)
        }
    }

    dynamic var customBlockingIpv6: String? {
        get {
            return sharedDefaults().string(forKey: CustomBlockingIpv6)
        }
        set {
            sharedDefaults().setValue(newValue, forKey: CustomBlockingIpv6)
        }
    }

    dynamic var blockIpv6: Bool {
        get {
            return sharedDefaults().bool(forKey: BlockIpv6)
        }

        set {
            sharedDefaults().setValue(newValue, forKey: BlockIpv6)
        }
    }

    // MARK: - Content blockers rules count

    dynamic var generalContentBlockerRulesCount : Int {
        get {
            sharedDefaults().integer(forKey: AEDefaultsGeneralContentBlockerRulesCount)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsGeneralContentBlockerRulesCount)
        }
    }

    dynamic var privacyContentBlockerRulesCount : Int {
        get {
            sharedDefaults().integer(forKey: AEDefaultsPrivacyContentBlockerRulesCount)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsPrivacyContentBlockerRulesCount)
        }
    }

    dynamic var socialContentBlockerRulesCount : Int {
        get {
            sharedDefaults().integer(forKey: AEDefaultsSocialContentBlockerRulesCount)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsSocialContentBlockerRulesCount)
        }
    }

    dynamic var otherContentBlockerRulesCount : Int {
        get {
            sharedDefaults().integer(forKey: AEDefaultsOtherContentBlockerRulesCount)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsOtherContentBlockerRulesCount)
        }
    }

    dynamic var customContentBlockerRulesCount : Int {
        get {
            sharedDefaults().integer(forKey: AEDefaultsCustomContentBlockerRulesCount)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsCustomContentBlockerRulesCount)
        }
    }

    dynamic var securityContentBlockerRulesCount : Int {
        get {
            sharedDefaults().integer(forKey: AEDefaultsSecurityContentBlockerRulesCount)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsSecurityContentBlockerRulesCount)
        }
    }

    dynamic var lastDnsFiltersUpdateTime: Date? {
        get {
            sharedDefaults().object(forKey: LastDnsFiltersUpdateTime) as? Date
        }
        set {
            sharedDefaults().set(newValue, forKey: LastDnsFiltersUpdateTime)
        }
    }

    dynamic var wifiOnlyUpdates: Bool {
        get {
            let wifiOnlyObject = sharedDefaults().object(forKey: AEDefaultsWifiOnlyUpdates) as? NSNumber
            return wifiOnlyObject?.boolValue ?? true
        }

        set {
            sharedDefaults().set(NSNumber(value: newValue), forKey: AEDefaultsWifiOnlyUpdates)
        }
    }

    dynamic var firstRun: Bool {
        get {
            sharedDefaults().object(forKey: AEDefaultsFirstRunKey) as? Bool ?? true
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsFirstRunKey)
        }
    }

    dynamic var setappUsed: Bool {
        get {
            sharedDefaults().bool(forKey: setAppUsedKey)
        }
        set {
            sharedDefaults().set(newValue, forKey: setAppUsedKey)
        }
    }

    // TODO: - This shit is awful, but there is no time now to rewrite it
    // MARK: - Pro status variables

    /* PurchaseService variables */

    var isProPurchased: Bool {
        purchasedThroughInApp || purchasedThroughSetapp || hasActiveLicense
    }

    /* LoginService variables */

    var hasActiveLicense: Bool {
        loggedIn && userHasPremiumLicense && licenseIsActive
    }

    var licenseExpirationDate: Date? {
        get {
            return sharedDefaults().object(forKey: AEDefaultsPremiumExpirationDate) as? Date
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsPremiumExpirationDate)
        }
    }

    var userHasPremiumLicense: Bool {
        get {
            return sharedDefaults().bool(forKey: AEDefaultsHasPremiumLicense)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsHasPremiumLicense)
        }
    }

    var loggedIn: Bool {
        get {
            return sharedDefaults().bool(forKey: AEDefaultsIsProPurchasedThroughLogin)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsIsProPurchasedThroughLogin)
        }
    }

    var licenseIsActive: Bool {
        if let licenseExpirationDate = licenseExpirationDate {
            return licenseExpirationDate > Date()
        }
        return false
    }

    /* Advanced protection state */
    var advancedProtection: Bool {
        get {
            sharedDefaults().bool(forKey: advancedProtectionKey)
        }
        set {
            sharedDefaults().set(newValue, forKey: advancedProtectionKey)
        }
    }
    /* Advanced protection permission granted for Safari Web Extension */
    var advancedProtectionPermissionsGranted: Bool {
        get {
            sharedDefaults().bool(forKey: advancedProtectionPermissionsGrantedKey)
        }
        set {
            sharedDefaults().set(newValue, forKey: advancedProtectionPermissionsGrantedKey)
        }
    }
    /* Safari Web Extension in enabled */
    var safariWebExtensionIsOn: Bool {
        get {
            sharedDefaults().bool(forKey: safariWebExtensionIsOnKey)
        }
        set {
            sharedDefaults().set(newValue, forKey: safariWebExtensionIsOnKey)
        }
    }

    var whatsNewScreenShown: Bool {
        get {
            sharedDefaults().bool(forKey: whatsNewScreenShownKey)
        }
        set {
            sharedDefaults().set(newValue, forKey: whatsNewScreenShownKey)
        }
    }
}

fileprivate extension AESharedResourcesProtocol {
    var setAppUsedKey: String { "setAppActivatedKey" }
    var advancedProtectionKey: String  { "advancedProtectionKey" }
    var advancedProtectionPermissionsGrantedKey: String { "advancedProtectionPermissionsGrantedKey" }
    var safariWebExtensionIsOnKey: String { "safariWebExtensionIsOnKey" }
    var whatsNewScreenShownKey: String { "whatsNewScreenShownKey" }
}

extension Notification.Name {
    static var dnsImplementationChanged: Notification.Name { return .init(rawValue: "dnsImplementationChanged") }
}
