import XCTest

class FitlerServiceTest: XCTestCase {
    
    var filterService: FiltersServiceProtocol!
    var metaStorage: MetaStorageMock!
    var filterFileStorage: FilterFilesStorageMock!
    var httpRequestService: HttpRequestServiceMock!
    var userDefaultsStorage: UserDefaultsStorageMock!
    
    override class func setUp() {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func setUpWithError() throws {
        MetaStorageTestProcessor.deleteTestFolder()
        MetaStorageTestProcessor.clearRootDirectory()
        
        metaStorage = MetaStorageMock()
        filterFileStorage = FilterFilesStorageMock()
        userDefaultsStorage = UserDefaultsStorageMock()
        
        let jsonUrl = Bundle(for: type(of: self)).url(forResource: "filters_test", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonUrl)
        let decoder = JSONDecoder()
        let extendedFiltersMeta = try decoder.decode(ExtendedFiltersMeta.self, from: jsonData)
        
        httpRequestService = HttpRequestServiceMock(loadFiltersMetadataResult: extendedFiltersMeta,
                               sendFeedbackResult: nil)

        
        filterService = try FiltersService(configuration: ConfigurationMock(),
                                              filterFilesStorage: filterFileStorage,
                                              metaStorage: metaStorage,
                                              userDefaultsStorage: userDefaultsStorage,
                                              httpRequestService:  httpRequestService)
    }
    
    func testUpdateAllMetaWithSuccess() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))

        let berforeUpdateDate = userDefaultsStorage.lastFiltersUpdateCheckDate
        
        
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { error in
            XCTAssertNil(error)
            let filters = self.filterService.groups.first(where: { $0.groupType == .ads })!.filters
            XCTAssertFalse(filters.isEmpty)
            expectation.fulfill()
        })
        
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        let afterUpdateDate = userDefaultsStorage.lastFiltersUpdateCheckDate
        XCTAssert(afterUpdateDate > berforeUpdateDate)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssert(metaStorage.updateAllLangsCalled)
        XCTAssert(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testUpdateAllMetaWithUpdatePeriodError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        filtersUpdateFinishedExpectation.isInverted = true
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        filtersUpdateStartedExpectation.isInverted = true
        
        userDefaultsStorage.lastFiltersUpdateCheckDate = Date()

        
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: false, onFiltersUpdated: { error in
            if case FiltersService.FilterServiceError.updatePeriodError(lastUpdateTime: _) = error! {
                XCTAssert(true)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testUpdateAllMetaWithUpdateFilesError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        
        filterFileStorage.updateFilterResult = .error(FilterFilesStorageMockError.updateFilterError)
        
        
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { error in
            if case FilterFilesStorageMockError.updateFilterError = error! {
                XCTAssert(true)
            } else {
                XCTFail()
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssert(metaStorage.updateAllLangsCalled)
        XCTAssert(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testUpdateAllFiltersError() {
        metaStorage.updateAllFiltersResult = .error(MetaStorageMockError.updateAllFiltersError)
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! MetaStorageMockError, MetaStorageMockError.updateAllFiltersError)
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testUpdateAllGroupsError() {
        metaStorage.updateAllGroupsResult = .error(MetaStorageMockError.updateAllGroupsError)
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! MetaStorageMockError, MetaStorageMockError.updateAllGroupsError)
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
        
    }
    
    func testUpdateAllTagsError() {
        metaStorage.updateAllTagsResult = .error(MetaStorageMockError.updateAllTagsError)
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! MetaStorageMockError, MetaStorageMockError.updateAllTagsError)
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssert(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testUpdateAllLangsError() {
        metaStorage.updateAllLangsResult = .error(MetaStorageMockError.updateAllLangsError)
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! MetaStorageMockError, MetaStorageMockError.updateAllLangsError)
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssert(metaStorage.updateAllLangsCalled)
        XCTAssert(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testUpdateLocalizationForFilterError() {
        metaStorage.updateLocalizationForFilterResult = .error(MetaStorageMockError.updateLocalizationForFilterError)
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! MetaStorageMockError, MetaStorageMockError.updateLocalizationForFilterError)
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssert(metaStorage.updateAllLangsCalled)
        XCTAssert(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testUpdateLocalizationForGroupErorr() {
        metaStorage.updateLocalizationForGroupResult = .error(MetaStorageMockError.updateLocalizationForGroupErorr)
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! MetaStorageMockError, MetaStorageMockError.updateLocalizationForGroupErorr)
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssert(metaStorage.updateAllLangsCalled)
        XCTAssert(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
    }
    
    func testGetAllLocalizedGroupsError() {
        metaStorage.getAllLocalizedGroupsResult = .error(MetaStorageMockError.getAllLocalizedGroupsError)
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertFalse(filterFileStorage.updateFilterCalled)
        XCTAssertFalse(metaStorage.updateAllFiltersCalled)
        XCTAssertFalse(metaStorage.updateAllGroupsCalled)
        XCTAssertFalse(metaStorage.updateAllLangsCalled)
        XCTAssertFalse(metaStorage.updateAllTagsCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForGroupCalled)
        XCTAssertFalse(metaStorage.updateLocalizationForFilterCalled)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! MetaStorageMockError, MetaStorageMockError.getAllLocalizedGroupsError)
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.updateFilterCalled)
        XCTAssert(metaStorage.updateAllFiltersCalled)
        XCTAssert(metaStorage.updateAllGroupsCalled)
        XCTAssert(metaStorage.updateAllLangsCalled)
        XCTAssert(metaStorage.updateAllTagsCalled)
        XCTAssert(metaStorage.updateLocalizationForGroupCalled)
        XCTAssert(metaStorage.updateLocalizationForFilterCalled)
        XCTAssert(metaStorage.getAllLocalizedGroupsCalled)
    }
    
    func testSetGroupWithSuccess() {
        do {
            let group = filterService.groups.first(where: { $0.groupType == .ads })!
            let oldValue = group.isEnabled
            
            XCTAssertFalse(metaStorage.setGroupCalled)

            try filterService.setGroup(withId: group.groupId, enabled: !group.isEnabled)
            guard let group = filterService.groups.first(where: { $0.groupType == .ads }) else { return XCTFail() }
            XCTAssertNotEqual(oldValue, group.isEnabled)
            
            
            XCTAssert(metaStorage.setGroupCalled)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetGroupWithNonExistingGroupId() {
        XCTAssertThrowsError(try filterService.setGroup(withId: -123466, enabled: false), "") { error in
            if case FiltersService.FilterServiceError.nonExistingGroupId(groupId: _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
    }
    
    func testSetGroupWithFailure() {
        metaStorage.setGroupResult = .error(MetaStorageMockError.setGroupError)
        XCTAssertFalse(metaStorage.setGroupCalled)
        XCTAssertThrowsError(try filterService.setGroup(withId: 1, enabled: false), "") { error in
            if case MetaStorageMockError.setGroupError = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        
        XCTAssert(metaStorage.setGroupCalled)
    }
    
    func testSetFilterWithSuccess() {
        do {
            var fitler = (filterService.groups.first(where: { $0.groupType == .ads})?.filters.first)!
            let oldValue = fitler.isEnabled
            XCTAssertFalse(metaStorage.setFilterCalled)

            try filterService.setFilter(withId: fitler.filterId, SafariGroup.GroupType.ads.rawValue, enabled: !fitler.isEnabled)
            fitler = (filterService.groups.first(where: { $0.groupType == .ads })?.filters.first(where: { $0.filterId == fitler.filterId }))!
            XCTAssertNotEqual(oldValue, fitler.isEnabled)
            XCTAssert(metaStorage.setFilterCalled)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetFilterWithNonExistingFilterId() {
        XCTAssertThrowsError(try filterService.setFilter(withId: -123123, -123123, enabled: false), "") { error in
            if case FiltersService.FilterServiceError.nonExistingFilterId(filterId: _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
    }
    
    func testSetFilterWithFailure() {
        metaStorage.setFilterResult = .error(MetaStorageMockError.setFilterError)
        XCTAssertFalse(metaStorage.setFilterCalled)
        XCTAssertThrowsError(try filterService.setFilter(withId: 1, 1, enabled: false), "") { error in
            if case MetaStorageMockError.setFilterError = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        XCTAssert(metaStorage.setFilterCalled)
    }
    
    func testAddCustomFilter() {
        let filterId = metaStorage.nextCustomFilterId
        let filterDownloadPage = "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt"
        let lastUpdateDate = Date()
        let filter = CustomFilterMeta(name: "Foo",
                             description: "Bar",
                             version: "123",
                             lastUpdateDate: lastUpdateDate,
                             updateFrequency: 123,
                             homePage: "url",
                             licensePage: "license",
                             issuesReportPage: "issuePage",
                             communityPage: "page",
                             filterDownloadPage: filterDownloadPage,
                             rulesCount: 1)
        
        XCTAssertFalse(metaStorage.addFilterCalled)
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        
        let expectation = XCTestExpectation()
        filterService.add(customFilter: filter, enabled: false) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssert(metaStorage.addFilterCalled)
        XCTAssert(filterFileStorage.updateCustomFilterCalled)
        let newFilter = filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId })!
        
        XCTAssertEqual(newFilter?.name, "Foo")
        XCTAssertEqual(newFilter?.description, "Bar")
        XCTAssertEqual(newFilter?.version, "123")
        XCTAssertEqual(newFilter?.lastUpdateDate, lastUpdateDate)
        XCTAssertEqual(newFilter?.updateFrequency, 123)
        XCTAssertEqual(newFilter?.homePage, "url")
        XCTAssertEqual(newFilter?.filterDownloadPage, filterDownloadPage)
        
        XCTAssertEqual(filterFileStorage.customFilters.count, 1)
    }
    
    func testAddCustomFilterWithAddError() {
        let filterDownloadPage = "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt"
        let filterId = metaStorage.nextCustomFilterId
        metaStorage.addResult = .error(MetaStorageMockError.addError)
        let customFilter = CustomFilterMeta(name: "Foo",
                                            description: "Bar",
                                            version: "123",
                                            lastUpdateDate: Date(),
                                            updateFrequency: 123,
                                            homePage: "url",
                                            licensePage: "license",
                                            issuesReportPage: "issuePage",
                                            communityPage: "page",
                                            filterDownloadPage: filterDownloadPage,
                                            rulesCount: 1)
        
        XCTAssertFalse(metaStorage.addFilterCalled)
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        
        let expectation = XCTestExpectation()
        filterService.add(customFilter: customFilter, enabled: false) { error in
            XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.addError)
            XCTAssert(self.metaStorage.addFilterCalled)
            XCTAssert(self.filterFileStorage.updateCustomFilterCalled)
            XCTAssertEqual(self.filterFileStorage.customFilters.count, 1)
            XCTAssertNil(self.filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testAddCustomFilterWithUpdateCustomFilterError() {
        let filterDownloadPage = "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt"
        let filterId = metaStorage.nextCustomFilterId
        let customFilter = CustomFilterMeta(name: "Foo",
                                            description: "Bar",
                                            version: "123",
                                            lastUpdateDate: Date(),
                                            updateFrequency: 123,
                                            homePage: "url",
                                            licensePage: "license",
                                            issuesReportPage: "issuePage",
                                            communityPage: "page",
                                            filterDownloadPage: filterDownloadPage,
                                            rulesCount: 1)
        filterFileStorage.updateCustomFilterResult = .error(FilterFilesStorageMockError.updateCustomFilterError)
        XCTAssertFalse(metaStorage.addFilterCalled)
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
        
        let expectation = XCTestExpectation()
        filterService.add(customFilter: customFilter, enabled: false) { error in
            XCTAssertEqual(error as! FilterFilesStorageMockError, FilterFilesStorageMockError.updateCustomFilterError)
            XCTAssertFalse(self.metaStorage.addFilterCalled)
            XCTAssert(self.filterFileStorage.updateCustomFilterCalled)
            XCTAssert(self.filterFileStorage.customFilters.isEmpty)
            XCTAssertNil(self.filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testAddCustomFilterWithMissedDownloadPageError() {
        let filterId = metaStorage.nextCustomFilterId
        let customFilter = CustomFilterMeta(name: "Foo",
                                            description: "Bar",
                                            version: "123",
                                            lastUpdateDate: Date(),
                                            updateFrequency: 123,
                                            homePage: "url",
                                            licensePage: "license",
                                            issuesReportPage: "issuePage",
                                            communityPage: "page",
                                            filterDownloadPage: nil,
                                            rulesCount: 1)
        XCTAssertFalse(metaStorage.addFilterCalled)
        XCTAssertFalse(filterFileStorage.updateCustomFilterCalled)
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
        
        let expectation = XCTestExpectation()
        filterService.add(customFilter: customFilter, enabled: false) { error in
            guard case FiltersService.FilterServiceError.missedFilterDownloadPage(filterName: _) = error! else {
                XCTFail()
                return
            }
            XCTAssertFalse(self.metaStorage.addFilterCalled)
            XCTAssertFalse(self.filterFileStorage.updateCustomFilterCalled)
            XCTAssert(self.filterFileStorage.customFilters.isEmpty)
            XCTAssertNil(self.filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testDeleteCustomFilterWithSuccess() {
        do {
            let filterId = metaStorage.nextCustomFilterId
            let filterDownloadPage = "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt"
            let filter = CustomFilterMeta(name: "Foo",
                                 description: "Bar",
                                 version: "123",
                                 lastUpdateDate: Date(),
                                 updateFrequency: 123,
                                 homePage: "url",
                                 licensePage: "license",
                                 issuesReportPage: "issuePage",
                                 communityPage: "page",
                                 filterDownloadPage: filterDownloadPage,
                                 rulesCount: 1)
            

            let expectation = XCTestExpectation()
            filterService.add(customFilter: filter, enabled: false) { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.5)
            
            XCTAssertFalse(filterFileStorage.customFilters.isEmpty)
            XCTAssertNotNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
            
            XCTAssertFalse(metaStorage.deleteFilterCalled)
            XCTAssertFalse(filterFileStorage.deleteFilterCalled)
            
            try filterService.deleteCustomFilter(withId: filterId)
            
            XCTAssert(metaStorage.deleteFilterCalled)
            XCTAssert(filterFileStorage.deleteFilterCalled)
            XCTAssert(filterFileStorage.customFilters.isEmpty)
            XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteCustomFilterWithDeleteMetaError() {
        let filterId = metaStorage.nextCustomFilterId
        metaStorage.deleteResult = .error(MetaStorageMockError.deleteError)
        XCTAssertFalse(metaStorage.deleteFilterCalled)
        XCTAssertFalse(filterFileStorage.deleteFilterCalled)
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: metaStorage.nextCustomFilterId), "") { error in
            if case MetaStorageMockError.deleteError = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        
        XCTAssert(metaStorage.deleteFilterCalled)
        XCTAssertFalse(filterFileStorage.deleteFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)

    }
    
    func testDeleteCustomFilterWithDeleteFilterError() {
        let filterId = metaStorage.nextCustomFilterId
        XCTAssertFalse(metaStorage.deleteFilterCalled)
        XCTAssertFalse(filterFileStorage.deleteFilterCalled)
        filterFileStorage.deleteResult = .error(FilterFilesStorageMockError.deleteError)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: metaStorage.nextCustomFilterId), "") { error in
            if case FilterFilesStorageMockError.deleteError = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        XCTAssert(metaStorage.deleteFilterCalled)
        XCTAssert(filterFileStorage.deleteFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
    }
    
    func testDeleteCustomFilterWithNegativeId() {
        let filterId = metaStorage.nextCustomFilterId

        XCTAssertFalse(metaStorage.deleteFilterCalled)
        XCTAssertFalse(filterFileStorage.deleteFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: -12345), "") { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        XCTAssertFalse(metaStorage.deleteFilterCalled)
        XCTAssertFalse(filterFileStorage.deleteFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
    }
    
    func testDeleteCustomFilterWithWrongId() {
        let filterId = metaStorage.nextCustomFilterId

        XCTAssertFalse(metaStorage.deleteFilterCalled)
        XCTAssertFalse(filterFileStorage.deleteFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: 1), "") { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        XCTAssertFalse(metaStorage.deleteFilterCalled)
        XCTAssertFalse(filterFileStorage.deleteFilterCalled)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssert(filterFileStorage.customFilters.isEmpty)
    }
    
    func testRenameCustomFilterWithSuccess() {
        do {
            let filterId = metaStorage.nextCustomFilterId
            XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
            let filter = CustomFilterMeta(name: "Foo",
                                 description: "Bar",
                                 version: "123",
                                 lastUpdateDate: Date(),
                                 updateFrequency: 123,
                                 homePage: "url",
                                 licensePage: "license",
                                 issuesReportPage: "issuePage",
                                 communityPage: "page",
                                 filterDownloadPage: "downloadPage",
                                 rulesCount: 1)
            
            let expectation = XCTestExpectation()
            filterService.add(customFilter: filter, enabled: false) { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.5)
            
            XCTAssertNotNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
            
            XCTAssertFalse(metaStorage.renameFilterCalled)
            try filterService.renameCustomFilter(withId: filterId, to: "Bar")
            
            XCTAssert(metaStorage.renameFilterCalled)

            let renamedFilter = filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId })
            
            XCTAssertNotNil(renamedFilter)
            XCTAssert(renamedFilter?.name == "Bar")
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testRenameCustomFilterWithRenameError() {
        metaStorage.renameResult = .error(MetaStorageMockError.renameError)
        XCTAssertFalse(metaStorage.renameFilterCalled)
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: metaStorage.nextCustomFilterId, to: "foo"), "") { error in
            if case MetaStorageMockError.renameError = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        XCTAssert(metaStorage.renameFilterCalled)
    }
    
    func testRenameCustomFilterWithNegativeId() {
        XCTAssertFalse(metaStorage.renameFilterCalled)
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: -123, to: "some"), "") { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        XCTAssertFalse(metaStorage.renameFilterCalled)
    }
    
    func testRenameCustomFilterWithWrongId() {
        XCTAssertFalse(metaStorage.renameFilterCalled)
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: 1, to: "some"), "") { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {
                XCTAssert(true)
            } else {
                XCTFail()
            }
        }
        XCTAssertFalse(metaStorage.renameFilterCalled)
    }
}
