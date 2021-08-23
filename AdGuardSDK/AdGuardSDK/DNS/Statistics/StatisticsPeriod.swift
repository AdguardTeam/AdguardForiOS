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

public enum StatisticsPeriod: CaseIterable, CustomDebugStringConvertible {
    case today
    case day
    case week
    case month
    case all
    
    public var debugDescription: String {
        switch self {
        case .today: return "TODAY"
        case .day: return "DAY"
        case .week: return "WEEK"
        case .month: return "MONTH"
        case .all: return "ALL"
        }
    }
    
    public static var allCases = [Self.today, .day, .week,.month, .all]
    
    /// Date interval for a certain `Period`
    var interval: DateInterval {
        let now = Date()
        let hour = 3600.0 // 1 hour in seconds
        
        switch self {
        case .today:
            let calendar = Calendar.current
            let hours = Double(calendar.component(.hour, from: now))
            let minutes = Double(calendar.component(.minute, from: now))
            let seconds = Double(calendar.component(.second, from: now))
            let interval = hours * hour + minutes * 60.0 + seconds
            return DateInterval(start: now - interval, end: now)
        case .day:
            let day = 24 * hour // 1 day in seconds
            return DateInterval(start: now - day, end: now)
        case .week:
            let week = 7 * 24 * hour // 1 week in seconds
            return DateInterval(start: now - week, end: now)
        case .month:
            let month = 30 * 24 * hour // 1 month in seconds
            return DateInterval(start: now - month, end: now)
        case .all:
            return DateInterval(start: Date(timeIntervalSinceReferenceDate: 0.0), end: now)
        }
    }
}
