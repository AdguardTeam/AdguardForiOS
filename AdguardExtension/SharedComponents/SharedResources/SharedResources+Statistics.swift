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

import enum DnsAdGuardSDK.StatisticsPeriod

extension AESharedResourcesProtocol {

    dynamic var activityStatisticsType: StatisticsPeriod {
        get {
            let periodType = sharedDefaults().object(forKey: ActivityStatisticsPeriodType) as? Int
            let rawValue = periodType ?? StatisticsPeriod.day.rawValue
            return StatisticsPeriod(rawValue: rawValue) ?? .day
        }
        set {
            let rawValue = newValue.rawValue
            sharedDefaults().set(rawValue, forKey: ActivityStatisticsPeriodType)
        }
    }

    dynamic var chartDateType: StatisticsPeriod {
        get {
            let periodType = sharedDefaults().object(forKey: StatisticsPeriodType) as? Int
            let rawValue = periodType ?? StatisticsPeriod.day.rawValue
            return StatisticsPeriod(rawValue: rawValue) ?? .day
        }
        set {
            let rawValue = newValue.rawValue
            sharedDefaults().set(rawValue, forKey: StatisticsPeriodType)
        }
    }
}
