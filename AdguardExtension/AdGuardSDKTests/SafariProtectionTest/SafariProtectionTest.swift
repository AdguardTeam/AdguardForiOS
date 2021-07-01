import XCTest

class SafariProtectionTest: XCTestCase {
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
    
    func testResetWithFiltersServiceError() {
        filters.resetError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(userRulesManagersProvider.resetCalledCount, 0)
        XCTAssertEqual(cbStorage.resetCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithUserRulesError() {
        userRulesManagersProvider.resetError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(userRulesManagersProvider.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.resetCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithCbStorageError() {
        cbStorage.resetError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(userRulesManagersProvider.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.resetCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithConvertingFiltersError() {
        converter.convertFiltersResult = .error(MetaStorageMockError.resetError)
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(userRulesManagersProvider.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.resetCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithSaveCbsError() {
        cbStorage.saveCbInfosError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(userRulesManagersProvider.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.resetCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithReloadCbError() {
        cbService.updateContentBlockersError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(userRulesManagersProvider.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.resetCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testResetWithSuccess() {
        let expectation = XCTestExpectation()
        safariProtection.reset { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(userRulesManagersProvider.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.resetCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testExecuteBlockAndReloadCbsWithThrowingBlock() {
        let expectation = XCTestExpectation()
        let sp = safariProtection as! SafariProtection
        
        sp.executeBlockAndReloadCbs {
            throw MetaStorageMockError.error
        } onCbReloaded: { error in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testExecuteBlockAndReloadCbsWithNotThrowingBlock() {
        let expectation = XCTestExpectation()
        let sp = safariProtection as! SafariProtection
        sp.executeBlockAndReloadCbs {}
        onCbReloaded: { error in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
}
