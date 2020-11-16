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
    
    dynamic var activityStatisticsType: ChartDateType {
        get {
            let periodType = sharedDefaults().object(forKey: ActivityStatisticsPeriodType) as? Int
            let rawValue = periodType ?? ChartDateType.day.rawValue
            return ChartDateType(rawValue: rawValue) ?? .day
        }
        set {
            let rawValue = newValue.rawValue
            sharedDefaults().set(rawValue, forKey: ActivityStatisticsPeriodType)
        }
    }
    
    dynamic var chartDateType: ChartDateType {
        get {
            let periodType = sharedDefaults().object(forKey: StatisticsPeriodType) as? Int
            let rawValue = periodType ?? ChartDateType.day.rawValue
            return ChartDateType(rawValue: rawValue) ?? .day
        }
        set {
            let rawValue = newValue.rawValue
            sharedDefaults().set(rawValue, forKey: StatisticsPeriodType)
        }
    }
    
    dynamic var tempRequestsCount: Int {
        get {
            return sharedDefaults().integer(forKey: AEDefaultsRequests)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsRequests)
        }
    }
    
    dynamic var tempEncryptedRequestsCount: Int {
        get {
            return sharedDefaults().integer(forKey: AEDefaultsEncryptedRequests)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsEncryptedRequests)
        }
    }
    
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
    
    dynamic var tunnelMode: APVpnManagerTunnelMode {
        get {
            guard let value = sharedDefaults().object(forKey: AEDefaultsVPNTunnelMode) as? UInt else {
                return APVpnManagerTunnelModeSplit
            }
            
            return APVpnManagerTunnelMode(value)
        }
        set {
            sharedDefaults().set(newValue.rawValue, forKey: AEDefaultsVPNTunnelMode)
        }
    }
    
    dynamic var restartByReachability: Bool {
        get {
            guard let value = sharedDefaults().object(forKey: AEDefaultsRestartByReachability) as? Bool else {
                return true
            }
            return value
        }
        
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsRestartByReachability)
        }
    }
    
    dynamic var isDebugLogs: Bool {
        get {
            return sharedDefaults().bool(forKey: AEDefaultsDebugLogs)
        }
        set {
            sharedDefaults().set(newValue, forKey: AEDefaultsDebugLogs)
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
    
    dynamic var backgroundFetchState: BackgroundFetchState {
        get {
            guard let value = sharedDefaults().object(forKey: BackgroundFetchStateKey) as? Int else {
                return .notStarted
            }
            return BackgroundFetchState(rawValue: value)!
        }
        set {
            DDLogInfo("(SharedResources) set background fetch state: \(newValue.rawValue)")
            sharedDefaults().set(newValue.rawValue, forKey: BackgroundFetchStateKey)
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
    
    // MARK: - private methods
    
    private func filterEnabled(defaultsKey: String)->Bool {
        let defaultValue = true
        guard let value = sharedDefaults().object(forKey: defaultsKey) as? Bool else {
            return defaultValue
        }
        
        guard let advancedMode = sharedDefaults().object(forKey: AEDefaultsDeveloperMode) as? Bool else {
            return defaultValue
        }
        
        if !advancedMode {
            return defaultValue
        }
        
        return value
    }
}
