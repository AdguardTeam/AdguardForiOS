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

enum ChartDateType: Int, CaseIterable {
    case alltime = 0, month, week, day, today
    
    /**
     Returns current bounds for the  given type
     */
    func getTimeInterval() -> (begin: Date, end: Date) {
        let hour = 60.0 * 60.0 // 1 hour
        let day = 24.0 * hour // 24 hours
        let week = 7.0 * day
        let month = 30.0 * day
        let now = Date()
        
        switch self {
        case .alltime:
            return (now, Date(timeIntervalSinceReferenceDate: 0))
        case .month:
            return (now, now - month)
        case .week:
            return (now, now - week)
        case .day:
            return (now, now - day)
        case .today:
            let calendar = Calendar.current
            let hours = Double(calendar.component(.hour, from: now))
            let minutes = Double(calendar.component(.minute, from: now))
            let interval = hours * hour + minutes * 60.0
            
            return (now, now - interval)
        }
    }
    
    /**
     Returns the first and last date of an array of [Date] that satisfy the given type
     */
    func getTimeInterval(requestsDates: [Date]) -> (begin: Date, end: Date){
        let firstDate: Date = requestsDates.first ?? now()
        let lastDate: Date = requestsDates.last ?? now()
        
        var interval: Double = 0.0
        
        let hour = 60.0 * 60.0 // 1 hour
        let day = 24.0 * hour // 24 hours
        let week = 7.0 * day
        let month = 30.0 * day
        
        switch self {
        case .today:
            let calendar = Calendar.current
            let hours = Double(calendar.component(.hour, from: lastDate))
            let minutes = Double(calendar.component(.minute, from: lastDate))
            
            interval = hours * hour + minutes * 60.0

        case .day:
            interval = day
        case .week:
            interval = week
        case .month:
            interval = month
        case .alltime:
            return (firstDate, lastDate)
        }
        
        var endDate = lastDate - interval
        if endDate < firstDate {
            endDate = firstDate
        }
        
        return (endDate, lastDate)
    }
    
    func getFormatterString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        switch self {
        case .today:
            dateFormatter.dateFormat = "HH:mm"
        case .day:
            dateFormatter.dateFormat = "E"
        case .week:
            dateFormatter.dateFormat = "E"
        case .month:
            dateFormatter.dateFormat = "dd.MM"
        case .alltime:
            dateFormatter.dateFormat = "MM.yy"
        }
        return dateFormatter.string(from: date)
    }
    
    /**
     Get title for changeStatisticsDatesButton when it is changed
     */
    func getDateTypeString() -> String{
        switch self {
        case .day:
            return String.localizedString("chart_24hours")
        case .today:
            return String.localizedString("chart_date_today")
        case .week:
            return String.localizedString("chart_7days")
        case .month:
            return String.localizedString("chart_30days")
        case .alltime:
            return String.localizedString("chart_alltime")
        }
    }
    
    private func now() -> Date {
        return Date()
    }
}
