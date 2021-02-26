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

class DnsFiltersServiceMock: DnsFiltersServiceProtocol {
    
    func addFilter(name: String, url: URL, networking: ACNNetworkingProtocol, callback: ((Bool) -> Void)?) {
        let filter = DnsFilter(subscriptionUrl: url.absoluteString, name: name, date: Date(), enabled: true, desc: nil, importantDesc: nil, version: nil, rulesCount: nil, homepage: nil)
        filters.append(filter)
        
        callback?(true)
    }
    
    var filters: [DnsFilter] = []
    
    var enabledFiltersCount: Int = 0
    
    var enabledRulesCount: Int = 0
    
    var filtersJson: String = ""
    
    var whitelistRules: [String] = []
    
    var userRules: [String] = []
    
    var filtersAreUpdating: Bool = false
    
    func setFilter(filterId: Int, enabled: Bool) {
        
    }
    
    func addFilter(_ filter: DnsFilter, data: Data?) {
        
    }
    
    func deleteFilter(_ filter: DnsFilter, completionHandler: (() -> Void)?) {
        
    }
    
    func disableAllFilters() {
        for filter in filters {
            filter.enabled = false
        }
    }
    
    func updateFilters(networking: ACNNetworkingProtocol, callback: (() -> Void)?) {
        
    }
    
    func reset() {
        
    }
    
    func addWhitelistRule(_ rule: String) {
        
    }
    
    func addBlacklistRule(_ rule: String) {
        userRules.append(rule)
    }
    
    func removeWhitelistRules(_ rules: [String]) {
        
    }
    
    func removeUserRules(_ rules: [String]) {
        
    }
    
    func readFiltersMeta() {
        
    }
    
    
}
