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

import DnsAdGuardSDK

extension StatisticsPeriod {

    /**
      Title for changeStatisticsDatesButton when it is changed
     */
    var dateTypeString: String{
        switch self {
        case .day:
            return String.localizedString("chart_24hours")
        case .today:
            return String.localizedString("chart_date_today")
        case .week:
            return String.localizedString("chart_7days")
        case .month:
            return String.localizedString("chart_30days")
        case .all:
            return String.localizedString("chart_alltime")
        }
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
        case .all:
            dateFormatter.dateFormat = "MM.yy"
        }
        return dateFormatter.string(from: date)
    }
}
