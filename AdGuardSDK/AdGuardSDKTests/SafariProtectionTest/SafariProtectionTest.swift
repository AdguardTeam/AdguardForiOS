import XCTest

class SafariProtectionTest: XCTestCase {
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
    
    func testResetWithFiltersServiceError() {
        filters.resetError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(safariManagers.resetCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedResetCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithUserRulesError() {
        safariManagers.resetError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(safariManagers.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedResetCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithCbStorageError() {
        cbStorage.stubbedResetError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(safariManagers.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedResetCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testResetWithSaveCbsError() {
        cbStorage.stubbedSaveError = MetaStorageMockError.resetError
        let expectation = XCTestExpectation()
        
        safariProtection.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, .resetError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(safariManagers.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedResetCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
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
        
        XCTAssertEqual(safariManagers.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedResetCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testResetWithSuccess() {
        let expectation = XCTestExpectation()
        safariProtection.reset { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(safariManagers.resetCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedResetCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testExecuteBlockAndReloadCbsWithThrowingBlock() {
        let expectation = XCTestExpectation()
        let sp = safariProtection as! SafariProtection
        
        do {
            try sp.executeBlockAndReloadCbs {
                throw MetaStorageMockError.error
            } onCbReloaded: { error in
                XCTAssertEqual(error as! MetaStorageMockError, .error)
                expectation.fulfill()
            }
        }
        catch {
            XCTAssertEqual(error as! MetaStorageMockError, .error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
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
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
}
