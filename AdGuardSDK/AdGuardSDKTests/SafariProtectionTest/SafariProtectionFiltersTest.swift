import XCTest

class SafariProtectionFiltersTest: XCTestCase {
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
    
    func testFiltersAreConverting() {
        converter.filtersAreConverting = false
        XCTAssertFalse(converter.filtersAreConverting)
        
        converter.filtersAreConverting = true
        XCTAssert(converter.filtersAreConverting)
    }
    
    func testGroupsVariable() {
        filters.groups = [
            SafariGroup(filters: [], isEnabled: true, groupId: 1, groupName: "group1", displayNumber: 1),
            SafariGroup(filters: [], isEnabled: false, groupId: 2, groupName: "group2", displayNumber: 2)
        ]
        XCTAssertEqual(safariProtection.groups.count, filters.groups.count)
        
        filters.groups = []
        XCTAssert(safariProtection.groups.isEmpty)
    }
    
    // MARK: - Test setGroup
    
    func testSetGroupWithSuccess() {
        let expectation = XCTestExpectation()
        
        try! safariProtection.setGroup(.ads, enabled: true) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setGroupCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testSetGroupWithFiltersServiceError() {
        filters.setGroupError = MetaStorageMockError.error
        
        let expectation = XCTestExpectation()
    
        do {
            try safariProtection.setGroup(.ads, enabled: true) { error in
                XCTAssertEqual(error as! MetaStorageMockError, .error)
                expectation.fulfill()
            }
            XCTFail()
        }
        catch {
            XCTAssertEqual(error as! MetaStorageMockError, .error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setGroupCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test setFilter
    
    func testSetFilterWithSuccess() {
        let expectation = XCTestExpectation()
        
        try! safariProtection.setFilter(withId: 1, 1, enabled: true) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testSetFilterWithFiltersServiceError() {
        filters.setFilterError = MetaStorageMockError.error
        
        let expectation = XCTestExpectation()
        
        do {
            try safariProtection.setFilter(withId: 1, 1, enabled: true) { error in
                XCTAssertEqual(error as! MetaStorageMockError, .error)
                expectation.fulfill()
            }
        }
        catch {
            XCTAssertEqual(error as! MetaStorageMockError, .error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test addCustomFilter
    
    func testAddCustomFilterWithSuccess() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        
        let customFilter = CustomFilterMeta(name: "name",
                                            description: "desc",
                                            version: "1.1.1.1",
                                            lastUpdateDate: nil,
                                            updateFrequency: nil,
                                            homePage: nil,
                                            licensePage: nil,
                                            issuesReportPage: nil,
                                            communityPage: nil,
                                            filterDownloadPage: nil,
                                            rulesCount: 199)
        safariProtection.add(customFilter: customFilter, enabled: true) { error in
            XCTAssertNil(error)
            expectation1.fulfill()
        } onCbReloaded: { error in
            XCTAssertNil(error)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 0.5)
        
        XCTAssertEqual(filters.addCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testAddCustomFilterWithFiltersServiceError() {
        filters.addCustomFilterError = MetaStorageMockError.error
        let expectation = XCTestExpectation()
        
        let customFilter = CustomFilterMeta(name: "name",
                                            description: "desc",
                                            version: "1.1.1.1",
                                            lastUpdateDate: nil,
                                            updateFrequency: nil,
                                            homePage: nil,
                                            licensePage: nil,
                                            issuesReportPage: nil,
                                            communityPage: nil,
                                            filterDownloadPage: nil,
                                            rulesCount: 199)
        safariProtection.add(customFilter: customFilter, enabled: true) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        } onCbReloaded: { error in
            
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.addCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test deleteCustomFilter
    
    func testDeleteCustomFilterWithSuccess() {
        let expectation = XCTestExpectation()
        
        try! safariProtection.deleteCustomFilter(withId: 1) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.deleteCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testDeleteCustomFilterWithFiltersServiceError() {
        filters.deleteCustomFilterError = MetaStorageMockError.error
        let expectation = XCTestExpectation()
        
        do {
            try safariProtection.deleteCustomFilter(withId: 1) { error in
                XCTAssertEqual(error as! MetaStorageMockError, .error)
                expectation.fulfill()
            }
        }
        catch {
            XCTAssertEqual(error as! MetaStorageMockError, .error)
        }
        
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.deleteCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test renameCustomFilter
    
    func testRenameCustomFilterWithSuccess() {
        XCTAssertNoThrow(try safariProtection.renameCustomFilter(withId: 9, to: "some_name"))
        
        XCTAssertEqual(filters.renameCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testRenameCustomFilterWithFiltersServiceError() {
        filters.renameCustomFilterError = MetaStorageMockError.error
        XCTAssertThrowsError(try safariProtection.renameCustomFilter(withId: 9, to: "some_name")) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
        }
        
        XCTAssertEqual(filters.renameCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test updateFiltersMetaAndLocalizations
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaAndReloadCbSuccess() {
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): break
            case .error(_): XCTFail()
            }
            expectation1.fulfill()
        } onCbReloaded: { error in
            XCTAssertNil(error)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaFailureAndReloadCbSuccess() {
        filters.updateAllMetaResult = .error(MetaStorageMockError.error)
    
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, .error)
            }
            expectation1.fulfill()
        } onCbReloaded: { error in
            XCTAssertNil(error)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaSuccessAndReloadCbFailure() {
        cbService.updateContentBlockersError = MetaStorageMockError.error
        
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): expectation.fulfill()
            case .error(_): XCTFail()
            }
        } onCbReloaded: { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation2.fulfill()
        }
        wait(for: [expectation, expectation2], timeout: 1.0)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaAndReloadCbFailure() {
        filters.updateAllMetaResult = .error(MetaStorageMockError.setGroupError)
        cbService.updateContentBlockersError = MetaStorageMockError.error
        
        let expectation1 = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, .setGroupError)
            }
            expectation1.fulfill()
        } onCbReloaded: { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation2.fulfill()
        }
        wait(for: [expectation1, expectation2], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
}
