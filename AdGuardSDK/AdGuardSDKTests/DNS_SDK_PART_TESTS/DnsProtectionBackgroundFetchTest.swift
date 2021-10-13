import XCTest

class DnsProtectionBackgroundFetchTest: XCTestCase {

    var dnsProtection: DnsProtectionProtocol!
    var dnsConfiguration: DnsConfigurationMock!
    var dnsDefaultConfiguration: DnsConfigurationMock!
    var dnsUserRulesManagersProvider: DnsUserRulesManagersProviderMock!
    var dnsFiltersManager: DnsFiltersManagerMock!
    var filterFilesStorage: FilterFilesStorageMock!

    override func setUp() {
        self.dnsConfiguration = DnsConfigurationMock()
        self.dnsDefaultConfiguration = DnsConfigurationMock()
        self.dnsUserRulesManagersProvider = DnsUserRulesManagersProviderMock()
        self.dnsFiltersManager = DnsFiltersManagerMock()
        self.filterFilesStorage = FilterFilesStorageMock()

        dnsProtection =  DnsProtection(configuration: dnsConfiguration,
                                       defaultConfiguration: dnsDefaultConfiguration,
                                       dnsUserRulesManagerProvider: dnsUserRulesManagersProvider,
                                       dnsFiltersManager: dnsFiltersManager,
                                       filterFilesStorage: filterFilesStorage)
    }

    func testUpdateDnsProtectionInBackgroundExecutesWithSuccess() {
        let expectation = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 1)
    }

    func testUpdateDnsProtectionInBackgroundExecutesWithFailure() {
        let expectation = XCTestExpectation()
        dnsFiltersManager.invokedUpdateAllFiltersReturnResult = DnsFiltersUpdateResult(updatedFiltersIds: [], unupdatedFiltersIds: [1,2,3])
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 1)
    }
}
