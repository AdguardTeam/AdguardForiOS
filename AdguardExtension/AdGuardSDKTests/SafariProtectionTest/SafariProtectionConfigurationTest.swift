import XCTest

class SafariProtectionConfigurationTest: XCTestCase {
    var configuration: ConfigurationMock!
    var defaultConfiguration: ConfigurationMock!
    var userDefaults: UserDefaultsStorageMock!
    var filters: FiltersServiceMock!
    var converter: FiltersConverterServiceMock!
    var cbStorage: ContentBlockersInfoStorageMock!
    var cbService: ContentBlockerServiceMock!
    var userRulesManagersProvider: UserRulesManagersProviderMock!
    
    var safariProtection: SafariProtectionProtocol!
    
    override func setUp() {
        configuration = ConfigurationMock()
        defaultConfiguration = ConfigurationMock()
        userDefaults = UserDefaultsStorageMock()
        filters = FiltersServiceMock()
        converter = FiltersConverterServiceMock()
        cbStorage = ContentBlockersInfoStorageMock()
        cbService = ContentBlockerServiceMock()
        userRulesManagersProvider = UserRulesManagersProviderMock()
        safariProtection = SafariProtection(configuration: configuration,
                                            defaultConfiguration: defaultConfiguration,
                                            userDefaults: userDefaults,
                                            filters: filters,
                                            converter: converter,
                                            cbStorage: cbStorage,
                                            cbService: cbService,
                                            userRulesManagersProvider: userRulesManagersProvider)
    }
    
    func testProStatus() {
        configuration.proStatus = true
        XCTAssert(safariProtection.proStatus)
        
        configuration.proStatus = false
        XCTAssertFalse(safariProtection.proStatus)
    }
    
    func testSafariProtectionEnabled() {
        configuration.safariProtectionEnabled = true
        XCTAssert(safariProtection.safariProtectionEnabled)
        
        configuration.safariProtectionEnabled = false
        XCTAssertFalse(safariProtection.safariProtectionEnabled)
    }
    
    func testBlocklistIsEnabled() {
        configuration.blocklistIsEnabled = true
        XCTAssert(safariProtection.blocklistIsEnabled)
        
        configuration.blocklistIsEnabled = false
        XCTAssertFalse(safariProtection.blocklistIsEnabled)
    }
    
    func testAllowlistIsEnbaled() {
        configuration.allowlistIsEnbaled = true
        XCTAssert(safariProtection.allowlistIsEnbaled)
        
        configuration.allowlistIsEnbaled = false
        XCTAssertFalse(safariProtection.allowlistIsEnbaled)
    }
    
    func testAllowlistIsInverted() {
        configuration.allowlistIsInverted = true
        XCTAssert(safariProtection.allowlistIsInverted)
        
        configuration.allowlistIsInverted = false
        XCTAssertFalse(safariProtection.allowlistIsInverted)
    }
    
    // MARK: - Test updateProStatus
    
    func testUpdateProStatusWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.proStatus
        safariProtection.update(proStatus: sameValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.proStatus, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testUpdateProStatusWithDifferentValue() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.proStatus
        safariProtection.update(proStatus: differentValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.proStatus, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateProStatusWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.safariProtectionEnabled
        
        converter.convertFiltersResult = .error(MetaStorageMockError.error)
        
        safariProtection.update(safariProtectionEnabled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.safariProtectionEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test updateSafariProtectionEnabled
    
    func testUpdateSafariProtectionWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.safariProtectionEnabled
        safariProtection.update(safariProtectionEnabled: sameValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.safariProtectionEnabled, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testUpdateSafariProtectionWithDifferentValue() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.safariProtectionEnabled
        safariProtection.update(safariProtectionEnabled: differentValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.safariProtectionEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateSafariProtectionWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.safariProtectionEnabled
        
        cbStorage.saveCbInfosError = MetaStorageMockError.error
        
        safariProtection.update(safariProtectionEnabled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.safariProtectionEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test updateBlocklistIsEnabled
    
    func testUpdateBlocklistIsEnabledWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.blocklistIsEnabled
        safariProtection.update(blocklistIsEnabled: sameValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.blocklistIsEnabled, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testUpdateBlocklistIsEnabledWithDifferentValue() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.blocklistIsEnabled
        safariProtection.update(blocklistIsEnabled: differentValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.blocklistIsEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateBlocklistIsEnabledWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.blocklistIsEnabled
        
        cbStorage.saveCbInfosError = MetaStorageMockError.error
        
        safariProtection.update(blocklistIsEnabled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.blocklistIsEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - updateAllowlistIsEnbaled
    
    func testUpdateAllowlistIsEnbaledWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.allowlistIsEnbaled
        safariProtection.update(allowlistIsEnbaled: sameValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsEnbaled, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testUpdateAllowlistIsEnbaledWithDifferentValue() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.allowlistIsEnbaled
        safariProtection.update(allowlistIsEnbaled: differentValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsEnbaled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateAllowlistIsEnbaledWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.allowlistIsEnbaled
        
        cbService.updateContentBlockersError = MetaStorageMockError.error
        
        safariProtection.update(allowlistIsEnbaled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsEnbaled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    // MARK: - updateAllowlistIsInverted
    
    func testUpdateAllowlistIsInvertedWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.allowlistIsInverted
        safariProtection.update(allowlistIsInverted: sameValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsInverted, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testUpdateAllowlistIsInvertedWithDifferentValue() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.allowlistIsInverted
        safariProtection.update(allowlistIsInverted: differentValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsInverted, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateAllowlistIsInvertedWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.allowlistIsInverted
        
        cbService.updateContentBlockersError = MetaStorageMockError.error
        
        safariProtection.update(allowlistIsInverted: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsInverted, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
}
