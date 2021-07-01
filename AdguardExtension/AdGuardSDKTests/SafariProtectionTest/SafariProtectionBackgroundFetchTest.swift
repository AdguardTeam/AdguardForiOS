import XCTest

class SafariProtectionBackgroundFetchTest: XCTestCase {
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
    
    func testUpdateSafariProtectionInBackgroundExecutesInRightSequence() {
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        
        let expectation3 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        
        let expectation4 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testUpdateSafariProtectionInBackgroundExecutesInRightSequenceWithErrors() {
        let expectation = XCTestExpectation()
        filters.updateAllMetaResult = .error(MetaStorageMockError.error)
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .noData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        
        let expectation2 = XCTestExpectation()
        filters.updateAllMetaResult = .success(FiltersUpdateResult())
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        
        let expectation3 = XCTestExpectation()
        cbStorage.saveCbInfosError = MetaStorageMockError.error
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .noData)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        
        let expectation4 = XCTestExpectation()
        cbStorage.saveCbInfosError = nil
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        
        let expectation5 = XCTestExpectation()
        cbService.updateContentBlockersError = MetaStorageMockError.error
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .noData)
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        
        let expectation6 = XCTestExpectation()
        cbService.updateContentBlockersError = nil
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 2)
        
        let expectation7 = XCTestExpectation()
        filters.updateAllMetaResult = .success(FiltersUpdateResult())
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation7.fulfill()
        }
        wait(for: [expectation7], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 3)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 2)
    }
    
    func testFinishBackgroundUpdateFromLoadAndSaveFiltersStateWithSuccess() {
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        
        let expectation2 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertNil(error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testFinishBackgroundUpdateFromLoadAndSaveFiltersStateWithError() {
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        
        converter.convertFiltersResult = .error(MetaStorageMockError.error)
        let expectation2 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
    
    func testFinishBackgroundUpdateFromConvertFiltersStateWithSuccess() {
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.saveCbInfosCalledCount = 0
        
        let expectation3 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertNil(error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testFinishBackgroundUpdateFromConvertFiltersStateWithError() {
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.saveCbInfosCalledCount = 0
        
        cbService.updateContentBlockersError = MetaStorageMockError.error
        let expectation3 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        
        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
    }
    
    func testFinishBackgroundUpdateFromReloadContentBlockersState() {
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        
        let expectation3 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, .newData)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.saveCbInfosCalledCount = 0
        cbService.updateContentBlockersCalledCount = 0
        
        let expectation4 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertNil(error)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.saveCbInfosCalledCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
    }
}
