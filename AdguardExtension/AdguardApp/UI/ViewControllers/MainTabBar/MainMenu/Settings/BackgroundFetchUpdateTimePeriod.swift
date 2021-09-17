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

enum BackgroundFetchUpdateTimePeriod: Int, CaseIterable {
    case defaultPeriod = 0 // 6 hours
    case everyHour
    case every3Hour
    case every12Hours
    case every24Hours
    
    var periodInterval: TimeInterval {
        switch self {
        case .defaultPeriod: return FiltersUpdatesConstants.checkFiltersUpdatesDefaultPeriod
        case .everyHour: return FiltersUpdatesConstants.executionPeriodTime
        case .every3Hour: return FiltersUpdatesConstants.executionPeriodTime * 3
        case .every12Hours: return FiltersUpdatesConstants.checkFiltersUpdatesDefaultPeriod * 2
        case .every24Hours: return FiltersUpdatesConstants.checkFiltersUpdatesDefaultPeriod * 4
        }
    }
}


