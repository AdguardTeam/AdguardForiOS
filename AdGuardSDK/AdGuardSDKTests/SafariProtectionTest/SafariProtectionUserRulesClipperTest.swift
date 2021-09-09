import XCTest
@_implementationOnly import ContentBlockerConverter

class SafariProtectionUserRulesClipperTest: XCTestCase {
    var configuration: SafariConfigurationMock!
    var defaultConfiguration: SafariConfigurationMock!
    var userDefaults: UserDefaultsStorageMock!
    var filters: FiltersServiceMock!
    var converter: FiltersConverterServiceMock!
    var cbStorage: ContentBlockersInfoStorageMock!
    var cbService: ContentBlockerServiceMock!
    var userRulesClipper: UserRulesClipperMock!
    var safariManagers: SafariUserRulesManagersProviderMock!
    
    var safariProtection: SafariProtectionUserRulesClipperProtocol!
    
    override func setUp() {
        configuration = SafariConfigurationMock()
        defaultConfiguration = SafariConfigurationMock()
        userDefaults = UserDefaultsStorageMock()
        filters = FiltersServiceMock()
        converter = FiltersConverterServiceMock()
        cbStorage = ContentBlockersInfoStorageMock()
        cbService = ContentBlockerServiceMock()
        userRulesClipper = UserRulesClipperMock()
        safariManagers = SafariUserRulesManagersProviderMock()
        safariProtection = SafariProtection(configuration: configuration,
                                            defaultConfiguration: defaultConfiguration,
                                            userDefaults: userDefaults,
                                            filters: filters,
                                            converter: converter,
                                            cbStorage: cbStorage,
                                            cbService: cbService,
                                            safariManagers: safariManagers,
                                            userRulesClipper: userRulesClipper)
    }
    
    // MARK: - Test quickAddRuleToAllowlist
    
    func testQuickAddRuleToAllowlistWithSuccess() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickAddRuleToAllowlist(by: "domain", onCbReloaded: { error in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testQuickAddRuleToAllowlistWithProviderError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.addRuleError = CommonError.error(message: "")
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        
        do {
            try safariProtection.quickAddRuleToAllowlist(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickAddRuleToAllowlistWithClipperError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addAllowlistRuleResult = .error(CommonError.error(message: ""))
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickAddRuleToAllowlist(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickAddRuleToAllowlistWithCbStorageError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = CommonError.error(message: "")
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickAddRuleToAllowlist(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickAddRuleToAllowlistWithCbReloadError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = CommonError.error(message: "")
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickAddRuleToAllowlist(by: "domain", onCbReloaded: { error in
            self.check(error: error!)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    // MARK: - Test quickAddInvertedAllowlistRule
    
    func testQuickAddInvertedAllowlistRuleWithSuccess() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickAddInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testQuickAddInvertedAllowlistRuleWithProviderError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.addRuleError = CommonError.error(message: "")
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        
        do {
            try safariProtection.quickAddInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickAddInvertedAllowlistRuleWithClipperError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addInvertedAllowlistRuleResult = .error(CommonError.error(message: ""))
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickAddInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickAddInvertedAllowlistRuleWithCbStorageError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = CommonError.error(message: "")
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickAddInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickAddInvertedAllowlistRuleWithCbReloadError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.addRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = CommonError.error(message: "")
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickAddInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
            self.check(error: error!)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.addRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.addInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    // MARK: - Test quickRemoveAllowlistRule
    
    func testQuickRemoveAllowlistRuleWithSuccess() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickRemoveAllowlistRule(by: "domain", onCbReloaded: { error in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testQuickRemoveAllowlistRuleWithProviderError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.removeRuleError = CommonError.error(message: "")
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.addAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        
        do {
            try safariProtection.quickRemoveAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickRemoveAllowlistRuleWithClipperError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeAllowlistRuleResult = .error(CommonError.error(message: ""))
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickRemoveAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickRemoveAllowlistRuleWithCbStorageError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = CommonError.error(message: "")
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickRemoveAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickRemoveAllowlistRuleWithCbReloadError() {
        let allowlistManager = safariManagers.allowlistRulesManager as! UserRulesManagerMock
        allowlistManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = CommonError.error(message: "")
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickRemoveAllowlistRule(by: "domain", onCbReloaded: { error in
            self.check(error: error!)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(allowlistManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    // MARK: - Test quickRemoveInvertedAllowlistRule
    
    func testQuickRemoveInvertedAllowlistRuleWithSuccess() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickRemoveInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
            XCTAssertNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testQuickRemoveInvertedAllowlistRuleWithProviderError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.removeRuleError = CommonError.error(message: "")
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        
        do {
            try safariProtection.quickRemoveInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickRemoveInvertedAllowlistRuleWithClipperError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeInvertedAllowlistRuleResult = .error(CommonError.error(message: ""))
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickRemoveInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickRemoveInvertedAllowlistRuleWithCbStorageError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = CommonError.error(message: "")
        cbService.updateContentBlockersError = nil
        
        let expectation = XCTestExpectation()
        do {
            try safariProtection.quickRemoveInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
                self.check(error: error!)
                expectation.fulfill()
            })
            XCTFail()
        } catch {
            check(error: error)
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testQuickRemoveInvertedAllowlistRuleWithCbReloadError() {
        let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager as! UserRulesManagerMock
        invertedAllowlistRulesManager.removeRuleError = nil
        cbStorage.stubbedAllConverterResults = getFilterConvertionResults()
        userRulesClipper.removeInvertedAllowlistRuleResult = .success(mockConversionResult())
        cbStorage.stubbedSaveError = nil
        cbService.updateContentBlockersError = CommonError.error(message: "")
        
        let expectation = XCTestExpectation()
        try! safariProtection.quickRemoveInvertedAllowlistRule(by: "domain", onCbReloaded: { error in
            self.check(error: error!)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(invertedAllowlistRulesManager.removeRuleCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedAllConverterResultsGetterCount, 1)
        XCTAssertEqual(userRulesClipper.removeInvertedAllowlistRuleCalledParams.0, "domain")
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveParameter.count, ContentBlockerType.allCases.count)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    // MARK: - Private methods
    
    private func mockConversionResult() -> ConversionResult {
        return ConversionResult(totalConvertedCount: 0, convertedCount: 0, errorsCount: 0, overLimit: true, converted: "", message: "")
    }
    
    private func getFilterConvertionResults() -> [ConverterResult] {
        let results = [
            FiltersConverterResult(type: .general, jsonString: "some_string", totalRules: 100, totalConverted: 20, overlimit: true, errorsCount: 1, advancedBlockingConvertedCount: 1, advancedBlockingJson: "some_json", advancedBlockingText: "some_text", message: "message"),
            FiltersConverterResult(type: .privacy, jsonString: "some_string_1", totalRules: 120, totalConverted: 30, overlimit: false, errorsCount: 0, advancedBlockingConvertedCount: 100, advancedBlockingJson: nil, advancedBlockingText: "some_text_1", message: "message_1"),
            FiltersConverterResult(type: .socialWidgetsAndAnnoyances, jsonString: "some_string_2", totalRules: 90, totalConverted: 34, overlimit: true, errorsCount: 2, advancedBlockingConvertedCount: 3, advancedBlockingJson: nil, advancedBlockingText: "some_text_2", message: "message_2"),
            FiltersConverterResult(type: .other, jsonString: "some_string_3", totalRules: 80, totalConverted: 32, overlimit: false, errorsCount: 1, advancedBlockingConvertedCount: 21, advancedBlockingJson: "some_json_2", advancedBlockingText: "some_text_3", message: "message_3"),
            FiltersConverterResult(type: .custom, jsonString: "some_string_4", totalRules: 130, totalConverted: 45, overlimit: true, errorsCount: 3, advancedBlockingConvertedCount: 89, advancedBlockingJson: nil, advancedBlockingText: "some_text_4", message: "message_4"),
            FiltersConverterResult(type: .security, jsonString: "some_string_5", totalRules: 400, totalConverted: 68, overlimit: false, errorsCount: 9, advancedBlockingConvertedCount: 1, advancedBlockingJson: nil, advancedBlockingText: "some_text_5", message: "message_5")
        ]
        
        let someUrl = TestsFileManager.workingUrl
        return results.map { ConverterResult(result: $0, jsonUrl: someUrl) }
    }
    
    private func check(error: Error) {
        if case CommonError.error(message: _) = error as! CommonError {}
        else {
            XCTFail()
        }
    }
}
