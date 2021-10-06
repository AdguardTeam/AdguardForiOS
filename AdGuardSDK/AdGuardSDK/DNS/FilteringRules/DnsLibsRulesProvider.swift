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

enum DnsProxyFilterData: Equatable {
    case file(String)
    case text(String)
}

struct DnsProxyFilter: Equatable {

    let filterId: Int
    let filterData: DnsProxyFilterData

    static func == (lhs: DnsProxyFilter, rhs: DnsProxyFilter) -> Bool {
        return lhs.filterId == rhs.filterId
    }
}

protocol DnsLibsRulesProviderProtocol {
    var enabledCustomDnsFilters: [DnsProxyFilter] { get }
    var blocklistFilter: DnsProxyFilter { get }
    var allowlistFilter: DnsProxyFilter { get }
}

final class DnsLibsRulesProvider: DnsLibsRulesProviderProtocol {

    var enabledCustomDnsFilters: [DnsProxyFilter] {
        dnsFiltersManager.getDnsLibsFilters().map { DnsProxyFilter(filterId: $0.key, filterData: .file($0.value)) }
    }

    var blocklistFilter: DnsProxyFilter {
        let filterId = DnsUserRuleType.blocklist.enabledRulesFilterId
        let path = filterFilesStorage.getUrlForFilter(withId: filterId).path
        return DnsProxyFilter(filterId: filterId, filterData: .file(path))
    }

    var allowlistFilter: DnsProxyFilter {
        let filterId = DnsUserRuleType.allowlist.enabledRulesFilterId
        let text = userRulesProvider.allowlistRulesManager.allowlistRulesString()
        return DnsProxyFilter(filterId: filterId, filterData: .text(text))
    }

    private let dnsFiltersManager: DnsFiltersManagerProtocol
    private let filterFilesStorage: CustomFilterFilesStorageProtocol
    private let userRulesProvider: DnsUserRulesManagersProviderProtocol

    init(dnsFiltersManager: DnsFiltersManagerProtocol, filterFilesStorage: CustomFilterFilesStorageProtocol, userRulesProvider: DnsUserRulesManagersProviderProtocol) {
        self.dnsFiltersManager = dnsFiltersManager
        self.filterFilesStorage = filterFilesStorage
        self.userRulesProvider = userRulesProvider
    }

}

fileprivate extension UserRulesManagerProtocol {
    func allowlistRulesString()->String {

        let converter = DnsAllowlistRulesConverter()
        let rules = self.allRules

        let text: String = rules.reduce("") { partialResult, rule in
            if rule.isEnabled {
                return partialResult + converter.convertDomainToRule(rule.ruleText) + "\n"
            }
            return partialResult
        }
        return text
    }
}

fileprivate class DnsAllowlistRulesConverter {
    func convertDomainToRule(_ domain: String)->String {
        return "@@||\(domain)^|$important"
    }
}
