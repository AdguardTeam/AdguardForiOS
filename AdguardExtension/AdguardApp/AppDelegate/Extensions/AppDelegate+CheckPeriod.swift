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

// Set period for minimum background fetch interval
extension AppDelegate {
    func setPeriodForCheckingFilters() {
        var interval: TimeInterval = TimeInterval(FiltersUpdatesConstants.fetchUpdateStatusPeriod)
        if (interval < UIApplication.backgroundFetchIntervalMinimum) {
            interval = UIApplication.backgroundFetchIntervalMinimum
        }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(interval)
        DDLogInfo("(AppDelegateProcessor) Set background fetch interval: \(interval)")
    }
}
