import XCTest

class SafariProtectionBackgroundFetchTest: XCTestCase {
    var configuration: SafariConfigurationMock!
    var defaultConfiguration: SafariConfigurationMock!
    var userDefaults: UserDefaultsStorageMock!
    var filters: FiltersServiceMock!
    var converter: FiltersConverterServiceMock!
    var cbStorage: ContentBlockersInfoStorageMock!
    var cbService: ContentBlockerServiceMock!
    var safariManagers: SafariUserRulesManagersProviderMock!
    var dnsBackgroundFetchUpdater: DnsBackgroundFetchUpdaterMock!

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
        dnsBackgroundFetchUpdater = DnsBackgroundFetchUpdaterMock()
        safariProtection = SafariProtection(configuration: configuration,
                                            defaultConfiguration: defaultConfiguration,
                                            userDefaults: userDefaults,
                                            filters: filters,
                                            converter: converter,
                                            cbStorage: cbStorage,
                                            cbService: cbService,
                                            safariManagers: safariManagers,
                                            dnsBackgroundFetchUpdater: dnsBackgroundFetchUpdater)
    }

    func testUpdateSafariProtectionInBackgroundExecutesInRightSequence() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNil(fetchResult.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)


        let expectedResult2 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .reloadContentBlockers,
            oldBackgroundFetchState: .convertFilters,
            error: nil
        )
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult2)
            XCTAssertNil(fetchResult.error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)


        let expectedResult3 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .updateFinished,
            oldBackgroundFetchState: .reloadContentBlockers,
            error: nil
        )
        let expectation3 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult3)
            XCTAssertNil(fetchResult.error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)


        let expectedResult4 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .updateFinished,
            error: nil
        )
        let expectation4 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult4)
            XCTAssertNil(fetchResult.error)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)
    }

    func testUpdateSafariProtectionInBackgroundExecutesInRightSequenceWithErrors() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .noData,
            newBackgroundFetchState: .loadAndSaveFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        filters.updateAllMetaResult = .error(MetaStorageMockError.error)
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNotNil(fetchResult.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)


        let expectedResult2 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation2 = XCTestExpectation()
        filters.updateAllMetaResult = .success(FiltersUpdateResult())
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult2)
            XCTAssertNil(fetchResult.error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)


        let expectedResult3 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .noData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .convertFilters,
            error: nil
        )
        let expectation3 = XCTestExpectation()
        cbStorage.stubbedSaveError = MetaStorageMockError.error
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult3)
            XCTAssertNotNil(fetchResult.error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)


        let expectedResult4 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .reloadContentBlockers,
            oldBackgroundFetchState: .convertFilters,
            error: nil
        )
        let expectation4 = XCTestExpectation()
        cbStorage.stubbedSaveError = nil
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult4)
            XCTAssertNil(fetchResult.error)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.invokedSaveCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)


        let expectedResult5 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .noData,
            newBackgroundFetchState: .reloadContentBlockers,
            oldBackgroundFetchState: .reloadContentBlockers,
            error: nil
        )
        let expectation5 = XCTestExpectation()
        cbService.updateContentBlockersError = MetaStorageMockError.error
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult5)
            XCTAssertNotNil(fetchResult.error)
            expectation5.fulfill()
        }
        wait(for: [expectation5], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.invokedSaveCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)


        let expectedResult6 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .updateFinished,
            oldBackgroundFetchState: .reloadContentBlockers,
            error: nil
        )
        let expectation6 = XCTestExpectation()
        cbService.updateContentBlockersError = nil
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult6)
            XCTAssertNil(fetchResult.error)
            expectation6.fulfill()
        }
        wait(for: [expectation6], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 2)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.invokedSaveCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 2)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)


        let expectedResult7 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .updateFinished,
            error: nil
        )
        let expectation7 = XCTestExpectation()
        filters.updateAllMetaResult = .success(FiltersUpdateResult())
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult7)
            XCTAssertNil(fetchResult.error)
            expectation7.fulfill()
        }
        wait(for: [expectation7], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 3)
        XCTAssertEqual(converter.convertFiltersCalledCount, 2)
        XCTAssertEqual(cbStorage.invokedSaveCount, 2)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 2)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 3)
    }

    func testFinishBackgroundUpdateFromLoadAndSaveFiltersStateWithSuccess() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNil(fetchResult.error)
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
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)
    }

    func testFinishBackgroundUpdateFromConvertFiltersStateWithSuccess() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNil(fetchResult.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)


        let expectedResult2 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .reloadContentBlockers,
            oldBackgroundFetchState: .convertFilters,
            error: nil
        )
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult2)
            XCTAssertNil(fetchResult.error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.invokedSaveCount = 0


        let expectation3 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertNil(error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)

        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)
    }

    func testFinishBackgroundUpdateFromConvertFiltersStateWithError() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNil(fetchResult.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)


        let expectedResult2 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .reloadContentBlockers,
            oldBackgroundFetchState: .convertFilters,
            error: nil
        )
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult2)
            XCTAssertNil(fetchResult.error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.invokedSaveCount = 0


        cbService.updateContentBlockersError = MetaStorageMockError.error
        let expectation3 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertEqual(error as! MetaStorageMockError, .error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)

        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)
    }

    func testFinishBackgroundUpdateFromReloadContentBlockersState() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .convertFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNil(fetchResult.error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)


        let expectedResult2 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .reloadContentBlockers,
            oldBackgroundFetchState: .convertFilters,
            error: nil
        )
        let expectation2 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult2)
            XCTAssertNil(fetchResult.error)
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.5)


        let expectedResult3 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .newData,
            newBackgroundFetchState: .updateFinished,
            oldBackgroundFetchState: .reloadContentBlockers,
            error: nil
        )
        let expectation3 = XCTestExpectation()
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult3)
            XCTAssertNil(fetchResult.error)
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)
        filters.updateAllMetaCalledCount = 0
        converter.convertFiltersCalledCount = 0
        cbStorage.invokedSaveCount = 0
        cbService.updateContentBlockersCalledCount = 0


        let expectation4 = XCTestExpectation()
        safariProtection.finishBackgroundUpdate { error in
            XCTAssertNil(error)
            expectation4.fulfill()
        }
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertEqual(filters.updateAllMetaCalledCount, 0)
        XCTAssertEqual(converter.convertFiltersCalledCount, 0)
        XCTAssertEqual(cbStorage.invokedSaveCount, 0)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 0)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 1)
    }

    func testFinishBackgroundUpdateFromLoadAndSaveFiltersStateWithDnsFiltersUpdateError() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .noData,
            newBackgroundFetchState: .loadAndSaveFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        dnsBackgroundFetchUpdater.updateFiltersInBackgroundError = CommonError.error(message: "")
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNotNil(fetchResult.error)
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

        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)
    }

    func testFinishBackgroundUpdateFromLoadAndSaveFiltersStateWithSafariAndDnsUpdateError() {
        let expectedResult1 = BackgroundFetchUpdateResult(
            backgroundFetchResult: .noData,
            newBackgroundFetchState: .loadAndSaveFilters,
            oldBackgroundFetchState: .loadAndSaveFilters,
            error: nil
        )
        let expectation = XCTestExpectation()
        filters.updateAllMetaResult = .error(MetaStorageMockError.error)
        safariProtection.updateSafariProtectionInBackground { fetchResult in
            XCTAssertEqual(fetchResult, expectedResult1)
            XCTAssertNotNil(fetchResult.error)
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

        XCTAssertEqual(filters.updateAllMetaCalledCount, 1)
        XCTAssertEqual(converter.convertFiltersCalledCount, 1)
        XCTAssertEqual(cbStorage.invokedSaveCount, 1)
        XCTAssertEqual(cbService.updateContentBlockersCalledCount, 1)
        XCTAssertEqual(dnsBackgroundFetchUpdater.updateFiltersInBackgroundCalledCount, 2)
    }
}
