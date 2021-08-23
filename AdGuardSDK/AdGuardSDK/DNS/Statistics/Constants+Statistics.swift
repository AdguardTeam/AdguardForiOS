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

extension Constants {
    struct Statistics {
        enum StatisticsType {
            case dnsLog
            case activity
            case chart
            
            var tableName: String {
                switch self {
                case .dnsLog: return "DNS_log_table"
                case .activity: return "activity_statistics_table"
                case .chart: return "chart_statistics_table"
                }
            }
            
            var dbFileName: String {
                switch self {
                case .dnsLog: return "DNS_log_statistics.db"
                case .activity: return "activity_statistics.db"
                case .chart: return "activity_statistics.db"
                }
            }
        }
        
        // Date format for DB
        static let dbDateFormat = "yyyy-MM-dd HH:mm:ss"
    }
}
