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

/// DNS filter content. It can be .file with a path to file or .text with filter content as a String
enum DnsProxyFilterData: Equatable {
    case file(_ path: String)
    case text(_ text: String)
}

/// Information about DNS filter.
struct DnsProxyFilter: Equatable {
    let filterId: Int
    let filterData: DnsProxyFilterData
}

/// This class is responsible for providing DNS filters to the DNS proxy.
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

/// This extension is responsible for generating an allowlist.
/// UserRulesManager stores DNS allowlist as a list of **domain names**.
/// DnsProxy expects a list of allowlist **rules**.
/// This extension converts the list of domains to the list of rules.
fileprivate extension UserRulesManagerProtocol {
    /// returns all enabled allowlist rules as a String
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

/// DnsAllowlistRulesConverter is responsible for converting domain name to allowlist rule
fileprivate class DnsAllowlistRulesConverter {
    func convertDomainToRule(_ domain: String)->String {
        return "@@||\(domain)^|$important"
    }
}
