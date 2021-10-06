import XCTest

class DnsLibsRulesProviderTest: XCTestCase {

    var filesStorage: FilterFilesStorageMock!
    var dnsFiltersManager: DnsFiltersManagerMock!
    var dnsLibsRulesProvider: DnsLibsRulesProviderProtocol!
    var userRulesProvider: DnsUserRulesManagersProviderMock!

    override func setUp() {
        filesStorage = FilterFilesStorageMock()
        dnsFiltersManager = DnsFiltersManagerMock()
        userRulesProvider = DnsUserRulesManagersProviderMock()
        dnsLibsRulesProvider = DnsLibsRulesProvider(
            dnsFiltersManager: dnsFiltersManager,
            filterFilesStorage: filesStorage,
            userRulesProvider: userRulesProvider
        )
    }

    func testDnsFiltersPaths() {
        let paths = [1: "path1", 2: "path2"]
        dnsFiltersManager.stubbedGetDnsLibsFiltersResult = paths

        var filters = dnsLibsRulesProvider.enabledCustomDnsFilters
        filters.sort(by: { $0.filterId < $1.filterId })
        XCTAssertEqual(filters.count, 2)
        XCTAssertEqual(filters[0], DnsProxyFilter(filterId: 1, filterData: .file("path1")))
        XCTAssertEqual(filters[1], DnsProxyFilter(filterId: 2, filterData: .file("path2")))
        XCTAssertEqual(dnsFiltersManager.invokedGetDnsLibsFiltersCount, 1)

        dnsFiltersManager.stubbedGetDnsLibsFiltersResult = [:]
        filters = dnsLibsRulesProvider.enabledCustomDnsFilters
        XCTAssert(filters.isEmpty)
        XCTAssertEqual(dnsFiltersManager.invokedGetDnsLibsFiltersCount, 2)
    }

    func testBlocklistFilter() {
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url

        let blocklistFilter = dnsLibsRulesProvider.blocklistFilter
        XCTAssertEqual(blocklistFilter.filterId, DnsUserRuleType.blocklist.enabledRulesFilterId)
        XCTAssertEqual(blocklistFilter.filterData, .file(url.path))
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 1)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterParameter, DnsUserRuleType.blocklist.enabledRulesFilterId)
    }

    func testAllowlistFilter() {
        let rulesManager = UserRulesManagerMock()
        rulesManager.allRules = [UserRule(ruleText: "allowRule")]
        userRulesProvider.stubbedAllowlistRulesManager = rulesManager

        let allowlistFilter = dnsLibsRulesProvider.allowlistFilter

        XCTAssertEqual(allowlistFilter.filterId, DnsUserRuleType.allowlist.enabledRulesFilterId)
        XCTAssertEqual(allowlistFilter.filterData, .text("@@||allowRule^|\n"))
    }
}
