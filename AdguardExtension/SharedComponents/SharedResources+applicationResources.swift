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

    dynamic var dnsImplementation: DnsImplementation {
        get {
            if let savedImplementation = sharedDefaults().object(forKey: DnsImplementationKey) as? Int {
                return DnsImplementation(rawValue: savedImplementation) ?? .adGuard
            }
            return .adGuard
        }
        set {
            if dnsImplementation != newValue {
                sharedDefaults().set(newValue.rawValue, forKey: DnsImplementationKey)
                NotificationCenter.default.post(name: .dnsImplementationChanged, object: nil)
            }
        }
    }

    dynamic var blockingMode: BlockingModeSettings  {
        get {
            guard let value = sharedDefaults().object(forKey: BlockingMode) as? Int else {
                return .agDefault
            }
            
            return BlockingModeSettings(rawValue: value)!
        }
        set {
            sharedDefaults().setValue(newValue.rawValue, forKey: BlockingMode)
        }
    }
}
