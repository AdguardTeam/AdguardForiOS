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

protocol DnsLibsRulesProviderProtocol {
    var enabledDnsFiltersIds: [Int] { get }
    var dnsFiltersPaths: [String] { get }
    var blocklistFilterPath: String { get }
    var allowlistFilterPath: String { get }
}

struct DnsLibsRulesProvider: DnsLibsRulesProviderProtocol {
    
    var enabledDnsFiltersIds: [Int] { dnsFiltersManager.getDnsLibsFilters().map { $0.key } }
    var dnsFiltersPaths: [String] { dnsFiltersManager.getDnsLibsFilters().map { $0.value } }
    var blocklistFilterPath: String { filterFilesStorage.getUrlForFilter(withId: DnsUserRuleType.blocklist.enabledRulesFilterId).path }
    var allowlistFilterPath: String { filterFilesStorage.getUrlForFilter(withId: DnsUserRuleType.allowlist.enabledRulesFilterId).path }
    
    private let dnsFiltersManager: DnsFiltersManagerProtocol
    private let filterFilesStorage: CustomFilterFilesStorageProtocol
    
    init(dnsFiltersManager: DnsFiltersManagerProtocol, filterFilesStorage: CustomFilterFilesStorageProtocol) {
        self.dnsFiltersManager = dnsFiltersManager
        self.filterFilesStorage = filterFilesStorage
    }
}
