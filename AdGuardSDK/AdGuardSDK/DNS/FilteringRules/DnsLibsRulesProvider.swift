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

struct DnsProxyFilter {
    let filterId: Int
    let filterPath: String
}

protocol DnsLibsRulesProviderProtocol {
    var enabledCustomDnsFilters: [DnsProxyFilter] { get }
    var blocklistFilter: DnsProxyFilter { get }
    var allowlistFilter: DnsProxyFilter { get }
}

final class DnsLibsRulesProvider: DnsLibsRulesProviderProtocol {
    
    var enabledCustomDnsFilters: [DnsProxyFilter] {
        dnsFiltersManager.getDnsLibsFilters().map { DnsProxyFilter(filterId: $0.key, filterPath: $0.value) }
    }
    
    var blocklistFilter: DnsProxyFilter {
        let filterId = DnsUserRuleType.blocklist.enabledRulesFilterId
        let path = filterFilesStorage.getUrlForFilter(withId: filterId).path
        return DnsProxyFilter(filterId: filterId, filterPath: path)
    }
    
    var allowlistFilter: DnsProxyFilter {
        let filterId = DnsUserRuleType.allowlist.enabledRulesFilterId
        let path = filterFilesStorage.getUrlForFilter(withId: filterId).path
        return DnsProxyFilter(filterId: filterId, filterPath: path)
    }
    
    private let dnsFiltersManager: DnsFiltersManagerProtocol
    private let filterFilesStorage: CustomFilterFilesStorageProtocol
    
    init(dnsFiltersManager: DnsFiltersManagerProtocol, filterFilesStorage: CustomFilterFilesStorageProtocol) {
        self.dnsFiltersManager = dnsFiltersManager
        self.filterFilesStorage = filterFilesStorage
    }
}
