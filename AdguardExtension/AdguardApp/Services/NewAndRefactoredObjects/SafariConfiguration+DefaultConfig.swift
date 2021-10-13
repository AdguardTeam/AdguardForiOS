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

import UIKit.UIDevice
import SafariAdGuardSDK

extension SafariConfiguration {
    convenience init(bundle: Bundle = .main, currentLocale: Locale = .current, resources: AESharedResourcesProtocol, isProPurchased: Bool) {
        self.init(iosVersion: UIDevice.current.iosVersion,
                  currentLocale: currentLocale,
                  proStatus: bundle.isPro ? true : isProPurchased,
                  safariProtectionEnabled: resources.safariProtectionEnabled,
                  advancedBlockingIsEnabled: true,
                  blocklistIsEnabled: resources.safariUserFilterEnabled,
                  allowlistIsEnabled: resources.safariWhitelistEnabled,
                  allowlistIsInverted: resources.invertedWhitelist,
                  appBundleId: bundle.bundleIdentifier ?? "",
                  appProductVersion: ADProductInfo().version() ?? "",
                  appId: bundle.isPro ? "ios_pro" : "ios",
                  cid: UIDevice.current.identifierForVendor?.uuidString ?? "")
    }

    static func defaultConfiguration(bundle: Bundle = .main, currentLocale: Locale = Locale.current) -> SafariConfiguration {
        return SafariConfiguration(
            iosVersion: UIDevice.current.iosVersion,
            currentLocale: currentLocale,
            proStatus: bundle.isPro ? true : false,
            safariProtectionEnabled: true,
            advancedBlockingIsEnabled: true, // TODO: - Don't forget to change
            blocklistIsEnabled: false,
            allowlistIsEnabled: false,
            allowlistIsInverted: false,
            appBundleId: bundle.bundleIdentifier ?? "",
            appProductVersion: ADProductInfo().version() ?? "",
            appId: bundle.isPro ? "ios_pro" : "ios",
            cid: UIDevice.current.identifierForVendor?.uuidString ?? ""
        )
    }
}
