//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

/**
 Our app supports background fetch mode
 These are background fetch intervals user can choose
 - Seealso https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623125-application
 */
enum BackgroundFetchUpdateInterval: Int, CaseIterable {
    case defaultPeriod = 0
    case everyHour
    case every3Hour
    case every12Hours
    case every24Hours

    // We use smaller interval for default (1 hour).
    // For 1 hour we actually use the minimum available interval.
    var interval: TimeInterval {
        let hour: TimeInterval = 3600.0

        switch self {
        case .defaultPeriod: return hour
        case .everyHour: return 0
        case .every3Hour: return 3 * hour
        case .every12Hours: return 12 * hour
        case .every24Hours: return 24 * hour
        }
    }
}


