import XCTest

class SafariProtectionFiltersTest: XCTestCase {
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
        
        safariProtection.setGroup(.ads, enabled: true) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setGroupCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testSetGroupWithFiltersServiceError() {
        filters.setGroupError = MetaStorageMockError.error
        
        let expectation = XCTestExpectation()
        
        safariProtection.setGroup(.ads, enabled: true) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setGroupCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test setFilter
    
    func testSetFilterWithSuccess() {
        let expectation = XCTestExpectation()
        
        safariProtection.setFilter(withId: 1, 1, enabled: true) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testSetFilterWithFiltersServiceError() {
        filters.setFilterError = MetaStorageMockError.error
        
        let expectation = XCTestExpectation()
        
        safariProtection.setFilter(withId: 1, 1, enabled: true) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.setFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test addCustomFilter
    
    func testAddCustomFilterWithSuccess() {
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
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.addCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
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
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.addCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test deleteCustomFilter
    
    func testDeleteCustomFilterWithSuccess() {
        let expectation = XCTestExpectation()
        
        safariProtection.deleteCustomFilter(withId: 1) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.deleteCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testDeleteCustomFilterWithFiltersServiceError() {
        filters.deleteCustomFilterError = MetaStorageMockError.error
        let expectation = XCTestExpectation()
        
        safariProtection.deleteCustomFilter(withId: 1) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.deleteCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test renameCustomFilter
    
    func testRenameCustomFilterWithSuccess() {
        XCTAssertNoThrow(try safariProtection.renameCustomFilter(withId: 9, to: "some_name"))
        
        XCTAssertEqual(filters.renameCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testRenameCustomFilterWithFiltersServiceError() {
        filters.renameCustomFilterError = MetaStorageMockError.error
        XCTAssertThrowsError(try safariProtection.renameCustomFilter(withId: 9, to: "some_name")) { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
        }
        
        XCTAssertEqual(filters.renameCustomFilterCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    // MARK: - Test updateFiltersMetaAndLocalizations
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaAndReloadCbSuccess() {
        let expectation = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): break
            case .error(_): XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaFailureAndReloadCbSuccess() {
        filters.updateAllMetaResult = .error(MetaStorageMockError.error)
    
        let expectation = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, .error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaSuccessAndReloadCbFailure() {
        cbService.updateContentBlockersError = MetaStorageMockError.error
        
        let expectation = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, .error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateFiltersMetaAndLocalizationsWithUpdateAllMetaAndReloadCbFailure() {
        filters.updateAllMetaResult = .error(MetaStorageMockError.error)
        cbService.updateContentBlockersError = MetaStorageMockError.setGroupError
        
        let expectation = XCTestExpectation()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, .setGroupError)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
}
