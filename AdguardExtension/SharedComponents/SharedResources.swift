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

extension AESharedResourcesProtocol {
    
    dynamic var firstLaunchDate: Date? {
        get {
            if let date = sharedDefaults().value(forKey: AEDefaultsFirstLaunchDate) as? Date {
                return date
            }
            return nil
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsFirstLaunchDate)
        }
    }

    dynamic var cancelTappedWhenAppRating: Bool? {
        get {
            if let tapped = sharedDefaults().value(forKey: CancelTappedWhenAppRating) as? Bool {
                return tapped
            }
            return nil
        }
        set {
            sharedDefaults().set(newValue, forKey: CancelTappedWhenAppRating)
        }
    }
    
    dynamic var appRatingNotificationShown: Bool {
        get {
            if let shown = sharedDefaults().value(forKey: AppRatingNotificationShown) as? Bool {
                return shown
            }
            return false
        }
        set {
            sharedDefaults().set(newValue, forKey: AppRatingNotificationShown)
        }
    }
    
    dynamic var minTimeIntervalToRate: Int {
        get {
            if let interval = sharedDefaults().value(forKey: MinTimeIntervalToRate) as? Int {
                return interval
            }
            return 24 * 3600 // 1 day
        }
        set {
            sharedDefaults().set(newValue, forKey: MinTimeIntervalToRate)
        }
    }
    
    dynamic var dnsActiveProtocols: [String: Int] {
        get {
            if let protocols = sharedDefaults().value(forKey: DnsActiveProtocols) as? [String: Int]{
                return protocols
            }
            return [:]
        }
        set {
            sharedDefaults().set(newValue, forKey: DnsActiveProtocols)
        }
    }
    
    dynamic var safariWhitelistEnabled: Bool {
        get {
            filterEnabled(defaultsKey: AEDefaultsSafariWhitelistEnabled)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsSafariWhitelistEnabled)
        }
    }
    
    dynamic var safariUserFilterEnabled: Bool {
        get {
            filterEnabled(defaultsKey: AEDefaultsUserFilterEnabled)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsUserFilterEnabled)
        }
    }
    
    dynamic var systemUserFilterEnabled: Bool {
        get {
            filterEnabled(defaultsKey: AEDefaultsDnsBlacklistEnabled)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsDnsBlacklistEnabled)
        }
    }
    
    dynamic var systemWhitelistEnabled: Bool {
        get {
            filterEnabled(defaultsKey: AEDefaultsDnsWhitelistEnabled)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsDnsWhitelistEnabled)
        }
    }
    
    dynamic var dnsRequestBlockingEnabled: Bool {
        get {
            filterEnabled(defaultsKey: AEDefaultsDNSRequestsBlocking)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsDNSRequestsBlocking)
        }
    }
    
    private func filterEnabled(defaultsKey: String)->Bool {
        let defaultValue = true
        guard let value = sharedDefaults().object(forKey: defaultsKey) as? Bool else {
            return defaultValue
        }
        
        guard let developerMode = sharedDefaults().object(forKey: AEDefaultsDeveloperMode) as? Bool else {
            return defaultValue
        }
        
        if !developerMode {
            return defaultValue
        }
        
        return value
    }
}
