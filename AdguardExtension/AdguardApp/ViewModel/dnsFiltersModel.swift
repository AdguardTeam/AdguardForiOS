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

class DnsFilter {
    let name: String
    let date: Date
    let enabled: Bool
    
    init(name: String, date: Date, enabled: Bool) {
        self.name = name
        self.date = date
        self.enabled = enabled
    }
}

class DnsFiltersModel {
    var filters: [DnsFilter] = []
    
    init() {
        fillFilters()
    }
    
    private func fillFilters(){
        let filter1 = DnsFilter(name: "AdGuard Simplified domain names filter", date: Date(), enabled: true)
        let filter2 = DnsFilter(name: "DNS User filter", date: Date(), enabled: true)
        
        filters.append(filter1)
        filters.append(filter2)
    }
}
