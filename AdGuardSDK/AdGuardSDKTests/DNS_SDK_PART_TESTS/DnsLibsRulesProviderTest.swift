import XCTest

class DnsLibsRulesProviderTest: XCTestCase {
   
    var filesStorage: FilterFilesStorageMock!
    var dnsFiltersManager: DnsFiltersManagerMock!
    var configuration: DnsConfigurationMock!
    var dnsLibsRulesProvider: DnsLibsRulesProviderProtocol!
    
    override func setUp() {
        filesStorage = FilterFilesStorageMock()
        dnsFiltersManager = DnsFiltersManagerMock()
        configuration = DnsConfigurationMock()
        dnsLibsRulesProvider = DnsLibsRulesProvider(
            dnsFiltersManager: dnsFiltersManager,
            filterFilesStorage: filesStorage,
            configuration: configuration
        )
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
    
    func testBlocklistFilterPathWithBlocklistEnabled() {
        configuration.blocklistIsEnabled = true
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url
        
        XCTAssertEqual(dnsLibsRulesProvider.blocklistFilterPath, url.path)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 1)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterParameter, DnsUserRuleType.blocklist.enabledRulesFilterId)
    }
    
    func testBlocklistFilterPathWithBlocklistDisabled() {
        configuration.blocklistIsEnabled = false
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url
        
        XCTAssertNil(dnsLibsRulesProvider.blocklistFilterPath)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 0)
        XCTAssertNil(filesStorage.invokedGetUrlForFilterParameter)
    }
    
    func testAllowlistFilterPathWithAllowlistEnabled() {
        configuration.allowlistIsEnbaled = true
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url
        
        XCTAssertEqual(dnsLibsRulesProvider.allowlistFilterPath, url.path)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 1)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterParameter, DnsUserRuleType.allowlist.enabledRulesFilterId)
    }
    
    func testAllowlistFilterPathWithAllowlistDisabled() {
        configuration.allowlistIsEnbaled = false
        let url = URL(string: "https://filters.com")!
        filesStorage.stubbedGetUrlForFilterResult = url
        
        XCTAssertNil(dnsLibsRulesProvider.allowlistFilterPath)
        XCTAssertEqual(filesStorage.invokedGetUrlForFilterCount, 0)
        XCTAssertNil(filesStorage.invokedGetUrlForFilterParameter)
    }
}
