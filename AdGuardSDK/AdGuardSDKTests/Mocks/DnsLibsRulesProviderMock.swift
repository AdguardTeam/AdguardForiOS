import Foundation

final class DnsLibsRulesProviderMock: DnsLibsRulesProviderProtocol {

    var invokedEnabledCustomDnsFiltersGetterCount = 0
    var stubbedEnabledCustomDnsFilters: [DnsProxyFilter] = []
    var enabledCustomDnsFilters: [DnsProxyFilter] {
        invokedEnabledCustomDnsFiltersGetterCount += 1
        return stubbedEnabledCustomDnsFilters
    }

    var invokedBlocklistFilterGetterCount = 0
    var stubbedBlocklistFilter: DnsProxyFilter!
    var blocklistFilter: DnsProxyFilter {
        invokedBlocklistFilterGetterCount += 1
        return stubbedBlocklistFilter
    }

    var invokedAllowlistFilterGetterCount = 0
    var stubbedAllowlistFilter: DnsProxyFilter!
    var allowlistFilter: DnsProxyFilter {
        invokedAllowlistFilterGetterCount += 1
        return stubbedAllowlistFilter
    }
}
