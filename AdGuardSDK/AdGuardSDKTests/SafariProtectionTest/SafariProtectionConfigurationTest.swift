import XCTest

class SafariProtectionConfigurationTest: XCTestCase {
    var configuration: SafariConfigurationMock!
    var defaultConfiguration: SafariConfigurationMock!
    var userDefaults: UserDefaultsStorageMock!
    var filters: FiltersServiceMock!
    var converter: FiltersConverterServiceMock!
    var cbStorage: ContentBlockersInfoStorageMock!
    var cbService: ContentBlockerServiceMock!
    var safariManagers: SafariUserRulesManagersProviderMock!
    
    var safariProtection: SafariProtectionProtocol!
    
    override func setUp() {
        configuration = SafariConfigurationMock()
        defaultConfiguration = SafariConfigurationMock()
        userDefaults = UserDefaultsStorageMock()
        filters = FiltersServiceMock()
        converter = FiltersConverterServiceMock()
        cbStorage = ContentBlockersInfoStorageMock()
        cbService = ContentBlockerServiceMock()
        safariManagers = SafariUserRulesManagersProviderMock()
        safariProtection = SafariProtection(configuration: configuration,
                                            defaultConfiguration: defaultConfiguration,
                                            userDefaults: userDefaults,
                                            filters: filters,
                                            converter: converter,
                                            cbStorage: cbStorage,
                                            cbService: cbService,
                                            safariManagers: safariManagers)
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
    
    func testAdvancedProtectionEnabled() {
        configuration.advancedBlockingIsEnabled = true
        XCTAssert(safariProtection.advancedProtectionIsEnabled)
        
        configuration.advancedBlockingIsEnabled = false
        XCTAssertFalse(safariProtection.advancedProtectionIsEnabled)
    }
    
    func testBlocklistIsEnabled() {
        configuration.blocklistIsEnabled = true
        XCTAssert(safariProtection.blocklistIsEnabled)
        
        configuration.blocklistIsEnabled = false
        XCTAssertFalse(safariProtection.blocklistIsEnabled)
    }
    
    func testAllowlistIsEnabled() {
        configuration.allowlistIsEnabled = true
        XCTAssert(safariProtection.allowlistIsEnabled)
        
        configuration.allowlistIsEnabled = false
        XCTAssertFalse(safariProtection.allowlistIsEnabled)
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
            if case CommonError.dataDidNotChange = error as! CommonError {}
            else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.proStatus, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
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
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    // MARK: - Test updateSafariProtectionEnabled
    
    func testUpdateSafariProtectionWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.safariProtectionEnabled
        safariProtection.update(safariProtectionEnabled: sameValue) { error in
            if case CommonError.dataDidNotChange = error as! CommonError {}
            else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.safariProtectionEnabled, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
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
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateSafariProtectionWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.safariProtectionEnabled
        
        cbStorage.stubbedSaveError = MetaStorageMockError.error
        
        safariProtection.update(safariProtectionEnabled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.safariProtectionEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test updateAdvancedProtectionEnabled
    
    func testUpdateAdvancedProtectionEnabledWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.advancedBlockingIsEnabled
        safariProtection.update(advancedProtectionEnabled: sameValue) { error in
            if case CommonError.dataDidNotChange = error as! CommonError {}
            else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.advancedBlockingIsEnabled, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testUpdateAdvancedProtectionEnabledWithDifferentValue() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.advancedBlockingIsEnabled
        safariProtection.update(advancedProtectionEnabled: differentValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.advancedBlockingIsEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateAdvancedProtectionEnabledWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.advancedBlockingIsEnabled
        
        cbStorage.stubbedSaveError = MetaStorageMockError.error
        
        safariProtection.update(advancedProtectionEnabled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.advancedBlockingIsEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test updateBlocklistIsEnabled
    
    func testUpdateBlocklistIsEnabledWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.blocklistIsEnabled
        safariProtection.update(blocklistIsEnabled: sameValue) { error in
            if case CommonError.dataDidNotChange = error as! CommonError {}
            else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.blocklistIsEnabled, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
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
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateBlocklistIsEnabledWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.blocklistIsEnabled
        
        cbStorage.stubbedSaveError = MetaStorageMockError.error
        
        safariProtection.update(blocklistIsEnabled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.blocklistIsEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - updateAllowlistIsEnabled
    
    func testUpdateAllowlistIsEnabledWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.allowlistIsEnabled
        safariProtection.update(allowlistIsEnabled: sameValue) { error in
            if case CommonError.dataDidNotChange = error as! CommonError {}
            else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsEnabled, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testUpdateAllowlistIsEnabledWithDifferentValue() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.allowlistIsEnabled
        safariProtection.update(allowlistIsEnabled: differentValue) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateAllowlistIsEnabledWithError() {
        let expectation = XCTestExpectation()
        let differentValue = !configuration.allowlistIsEnabled
        
        cbService.updateContentBlockersError = MetaStorageMockError.error
        
        safariProtection.update(allowlistIsEnabled: differentValue) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsEnabled, differentValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    // MARK: - updateAllowlistIsInverted
    
    func testUpdateAllowlistIsInvertedWithSameValue() {
        let expectation = XCTestExpectation()
        let sameValue = configuration.allowlistIsInverted
        safariProtection.update(allowlistIsInverted: sameValue) { error in
            if case CommonError.dataDidNotChange = error as! CommonError {}
            else {
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let sp = safariProtection as! SafariProtection
        XCTAssertEqual(sp.configuration.allowlistIsInverted, sameValue)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
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
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
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
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateConfig() {
        let protection = safariProtection as! SafariProtection
        let newConfig = SafariConfiguration(iosVersion: 1,
                            currentLanguage: "currentLanguage",
                            proStatus: false,
                            safariProtectionEnabled: true,
                            advancedBlockingIsEnabled: false,
                            blocklistIsEnabled: true,
                            allowlistIsEnabled: false,
                            allowlistIsInverted: true,
                            appBundleId: "appBundleId",
                            appProductVersion: "appProductVersion",
                            appId: "appId",
                            cid: "cid")
        protection.updateConfig(with: newConfig)
        
        XCTAssertEqual(protection.configuration.iosVersion, newConfig.iosVersion)
        XCTAssertEqual(protection.configuration.currentLanguage, newConfig.currentLanguage)
        XCTAssertEqual(protection.configuration.proStatus, newConfig.proStatus)
        XCTAssertEqual(protection.configuration.safariProtectionEnabled, newConfig.safariProtectionEnabled)
        XCTAssertEqual(protection.configuration.advancedBlockingIsEnabled, newConfig.advancedBlockingIsEnabled)
        XCTAssertEqual(protection.configuration.blocklistIsEnabled, newConfig.blocklistIsEnabled)
        XCTAssertEqual(protection.configuration.allowlistIsEnabled, newConfig.allowlistIsEnabled)
        XCTAssertEqual(protection.configuration.allowlistIsInverted, newConfig.allowlistIsInverted)
        XCTAssertEqual(protection.configuration.appBundleId, newConfig.appBundleId)
        XCTAssertEqual(protection.configuration.appProductVersion, newConfig.appProductVersion)
        XCTAssertEqual(protection.configuration.appId, newConfig.appId)
        XCTAssertEqual(protection.configuration.cid, newConfig.cid)
        XCTAssert(protection.configuration === configuration)
        
    }
}
