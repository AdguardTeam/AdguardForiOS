import XCTest

class DnsLibsRulesProviderTest: XCTestCase {
   
    var filesStorage: FilterFilesStorageMock!
    var dnsFiltersManager: DnsFiltersManagerMock!
    var dnsLibsRulesProvider: DnsLibsRulesProviderProtocol!
    
    override func setUp() {
        filesStorage = FilterFilesStorageMock()
        dnsFiltersManager = DnsFiltersManagerMock()
        dnsLibsRulesProvider = DnsLibsRulesProvider(dnsFiltersManager: dnsFiltersManager, filterFilesStorage: filesStorage)
    }
    
    func testDnsFiltersPaths() {
        let paths = [1: "path1", 2: "path2"]
        dnsFiltersManager.stubbedGetDnsLibsFiltersResult = paths
        XCTAssertEqual(dnsLibsRulesProvider.dnsFiltersPaths, paths.map { $0.value })
        XCTAssertEqual(dnsLibsRulesProvider.enabledDnsFiltersIds, paths.map { $0.key })
        XCTAssertEqual(dnsFiltersManager.invokedGetDnsLibsFiltersCount, 2)
        
        dnsFiltersManager.stubbedGetDnsLibsFiltersResult = [:]
        XCTAssert(dnsLibsRulesProvider.dnsFiltersPaths.isEmpty)
        XCTAssert(dnsLibsRulesProvider.enabledDnsFiltersIds.isEmpty)
        XCTAssertEqual(dnsFiltersManager.invokedGetDnsLibsFiltersCount, 4)
    }
    
    func testBlocklistFilterPath() {
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url
        
        XCTAssertEqual(dnsLibsRulesProvider.blocklistFilterPath, url.path)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 1)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterParameter, DnsUserRuleType.blocklist.enabledRulesFilterId)
    }
    
    func testAllowlistFilterPath() {
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url
        
        XCTAssertEqual(dnsLibsRulesProvider.allowlistFilterPath, url.path)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 1)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterParameter, DnsUserRuleType.allowlist.enabledRulesFilterId)
    }
}
