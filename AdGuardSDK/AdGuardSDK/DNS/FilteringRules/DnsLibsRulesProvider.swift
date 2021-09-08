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
    var blocklistFilterPath: String? { get }
    var allowlistFilterPath: String? { get }
}

final class DnsLibsRulesProvider: DnsLibsRulesProviderProtocol {
    
    var enabledDnsFiltersIds: [Int] { dnsFiltersManager.getDnsLibsFilters().map { $0.key } }
    var dnsFiltersPaths: [String] { dnsFiltersManager.getDnsLibsFilters().map { $0.value } }
    
    var blocklistFilterPath: String? {
        if configuration.blocklistIsEnabled {
            return filterFilesStorage.getUrlForFilter(withId: DnsUserRuleType.blocklist.enabledRulesFilterId).path
        } else {
            return nil
        }
    }
    var allowlistFilterPath: String? {
        if configuration.allowlistIsEnabled {
            return filterFilesStorage.getUrlForFilter(withId: DnsUserRuleType.allowlist.enabledRulesFilterId).path
        } else {
            return nil
        }
    }
    
    private let dnsFiltersManager: DnsFiltersManagerProtocol
    private let filterFilesStorage: CustomFilterFilesStorageProtocol
    private let configuration: DnsConfigurationProtocol
    
    init(dnsFiltersManager: DnsFiltersManagerProtocol, filterFilesStorage: CustomFilterFilesStorageProtocol, configuration: DnsConfigurationProtocol) {
        self.dnsFiltersManager = dnsFiltersManager
        self.filterFilesStorage = filterFilesStorage
        self.configuration = configuration
    }
}
