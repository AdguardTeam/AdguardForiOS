import XCTest

class DnsLibsRulesProviderTest: XCTestCase {
 
    var filesStorage: FilterFilesStorageMock!
    var dnsFiltersManager: DnsFiltersManagerMock!
    var dnsLibsRulesProvider: DnsLibsRulesProviderProtocol!

    override func setUp() {
        filesStorage = FilterFilesStorageMock()
        dnsFiltersManager = DnsFiltersManagerMock()
        dnsLibsRulesProvider = DnsLibsRulesProvider(
            dnsFiltersManager: dnsFiltersManager,
            filterFilesStorage: filesStorage
        )
    }

    func testDnsFiltersPaths() {
        let paths = [1: "path1", 2: "path2"]
        dnsFiltersManager.stubbedGetDnsLibsFiltersResult = paths

        var filters = dnsLibsRulesProvider.enabledCustomDnsFilters
        filters.sort(by: { $0.filterId < $1.filterId })
        XCTAssertEqual(filters.count, 2)
        XCTAssertEqual(filters[0], DnsProxyFilter(filterId: 1, filterPath: "path1"))
        XCTAssertEqual(filters[1], DnsProxyFilter(filterId: 2, filterPath: "path2"))
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
        XCTAssertEqual(blocklistFilter.filterPath, url.path)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 1)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterParameter, DnsUserRuleType.blocklist.enabledRulesFilterId)
    }

    func testAllowlistFilter() {
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url

        let allowlistFilter = dnsLibsRulesProvider.allowlistFilter
        XCTAssertEqual(allowlistFilter.filterId, DnsUserRuleType.allowlist.enabledRulesFilterId)
        XCTAssertEqual(allowlistFilter.filterPath, url.path)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 1)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterParameter, DnsUserRuleType.allowlist.enabledRulesFilterId)
    }
}
