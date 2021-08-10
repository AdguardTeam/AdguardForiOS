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

extension DateInterval {
    /// Returns date between `start` and `end`
    var middle: Date {
        let sum = end.timeIntervalSince1970 + start.timeIntervalSince1970
        let middle = sum / 2
        return Date(timeIntervalSince1970: middle)
    }
}

extension Date {
    /// Returns date between `start` and `end`
    /// `end` >= `start`
    static func middleDate(between start: Date, and end: Date) -> Date {
        let interval = DateInterval(start: start, end: end)
        return interval.middle
    }
}
