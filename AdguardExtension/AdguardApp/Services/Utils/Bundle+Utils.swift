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

import Foundation

extension Bundle {
    
    /// do not foget to add "ProApplication" key to target info.plist file
    var isPro: Bool { infoDictionary?["ProApplication"] as? Bool ?? false }
    
    /**
     Returns locale code with script code
     Example:
        locale code = zh
        script code = Hans
     preferredLocaleCode = zh-Hans
     */
    var preferredLocaleCode: String {
        if let localeCode = self.preferredLocalizations.first {
            return localeCode
        }
        return Locale.current.languageCode ?? Locale.current.identifier
    }
    
    var applicationName: String {
        return infoDictionary?["CFBundleName"] as? String ?? "AdGuard"
    }
    
    var hostAppBundleId: String {
        Bundle.main.isPro ? "com.adguard.AdguardPro" : "com.adguard.AdguardExtension"
    }
    
    /// We use different app schemes for pro and normal adguard
    /// This variable  is used to get an app scheme without filling plist files
    var appScheme: String { isPro ? "adguard-pro" : "adguard" }
}
