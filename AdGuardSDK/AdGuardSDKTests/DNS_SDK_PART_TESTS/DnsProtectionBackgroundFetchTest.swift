import XCTest

class DnsProtectionBackgroundFetchTest: XCTestCase {
    
    var dnsProtection: DnsProtectionProtocol!
    var dnsConfiguration: DnsConfigurationMock!
    var dnsDefaultConfiguration: DnsConfigurationMock!
    var dnsProvidersManager: DnsProvidersManagerMock!
    var dnsUserRulesManagersProvider: DnsUserRulesManagersProviderMock!
    var dnsFiltersManager: DnsFiltersManagerMock!
    var filterFilesStorage: FilterFilesStorageMock!
    
    override func setUp() {
        self.dnsConfiguration = DnsConfigurationMock()
        self.dnsDefaultConfiguration = DnsConfigurationMock()
        self.dnsProvidersManager = DnsProvidersManagerMock()
        self.dnsUserRulesManagersProvider = DnsUserRulesManagersProviderMock()
        self.dnsFiltersManager = DnsFiltersManagerMock()
        self.filterFilesStorage = FilterFilesStorageMock()
        
        dnsProtection =  DnsProtection(configuration: dnsConfiguration,
                                       defaultConfiguration: dnsDefaultConfiguration,
                                       dnsProvidersManager: dnsProvidersManager,
                                       dnsUserRulesManagerProvider: dnsUserRulesManagersProvider,
                                       dnsFiltersManager: dnsFiltersManager,
                                       filterFilesStorage: filterFilesStorage)
    }
    
    func testUpdateDnsProtectionInBackgroundExecutesInRightSequence() {
        let expectation = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 1)

        
        let expectation2 = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNil(error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 2)
        
        let expectation3 = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNil(error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 3)
        
        let expectation4 = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNil(error)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 4)
    }
    
    func testUpdateDnsProtectionInBackgroundExecutesInRightSequenceWithErrors() {
        let expectation = XCTestExpectation()
        dnsFiltersManager.invokedUpdateAllFiltersReturnResult = DnsFiltersUpdateResult(updatedFiltersIds: [], unupdatedFiltersIds: [1,2,3])
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 1)

        let expectation2 = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNotNil(error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 2)

        let expectation3 = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNotNil(error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 3)


        let expectation4 = XCTestExpectation()
        dnsProtection.updateFiltersInBackground { error in
            XCTAssertNotNil(error)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(dnsFiltersManager.invokedUpdateAllFiltersCount, 4)
    }
}
