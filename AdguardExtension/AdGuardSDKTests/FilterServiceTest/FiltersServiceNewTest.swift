import XCTest

class FitlerServiceNewTest: XCTestCase {
    
    var filterService: FiltersServiceNewProtocol!
    var filtersMetaStorage: FiltersMetaStorageMock!
    var filterFileStorage: FilterFilesStorageMock!
    var httpRequestService: HttpRequestServiceMock!
    var userDefaultsStorage: UserDefaultsStorageMock!
    
    override class func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func setUpWithError() throws {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
        
        filtersMetaStorage = FiltersMetaStorageMock()
        filterFileStorage = FilterFilesStorageMock()
        userDefaultsStorage = UserDefaultsStorageMock()
        
        let jsonUrl = Bundle(for: type(of: self)).url(forResource: "filters_test", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonUrl)
        let decoder = JSONDecoder()
        let extendedFiltersMeta = try decoder.decode(ExtendedFiltersMeta.self, from: jsonData)
        
        httpRequestService = HttpRequestServiceMock(loadFiltersMetadataResult: extendedFiltersMeta,
                               sendFeedbackResult: nil)

        
        filterService = try FiltersServiceNew(configuration: ConfigurationMock(),
                                              filterFilesStorage: filterFileStorage,
                                              filtersMetaStorage: filtersMetaStorage,
                                              userDefaultsStorage: userDefaultsStorage,
                                              httpRequestService:  httpRequestService)
    }
    
    func testUpdateAllMetaWithSuccess() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
            NSNotification.Name.init( "AdGuardSDK.filtersUpdateStarted"))

        let berforeUpdateDate = userDefaultsStorage.lastFiltersUpdateCheckDate
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { error in
            XCTAssertNil(error)
            let filters = self.filterService.groups.first(where: { $0.groupType == .ads })!.filters
            XCTAssertFalse(filters.isEmpty)
            expectation.fulfill()
        })
        
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 5.0)
        let afterUpdateDate = userDefaultsStorage.lastFiltersUpdateCheckDate
        XCTAssert(afterUpdateDate > berforeUpdateDate)
    }
    
    func testUpdateAllMetaWithUpdatePeriodError() {
        let expectation = XCTestExpectation()
        userDefaultsStorage.lastFiltersUpdateCheckDate = Date()

        filterService.updateAllMeta(forcibly: false, onFiltersUpdated: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateAllMetaWithUpdateFilesError() {
        let expectation = XCTestExpectation()
        filterFileStorage.updateFilterResult = .error(FilterFilesStorageMockError.error)
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)

    }
    
    func testUpdateAllMetaWithUpdateMetaError() {
        filtersMetaStorage.updateAllFiltersResult = .error(FilterMetaStorageMockError.updateAllFiltersError)
        updateAllMetaWithError(error: .updateAllFiltersError)
        filtersMetaStorage.setResultsToDefault()

        filtersMetaStorage.updateAllGroupsResult = .error(FilterMetaStorageMockError.updateAllGroupsError)
        updateAllMetaWithError(error: .updateAllGroupsError)
        filtersMetaStorage.setResultsToDefault()

        filtersMetaStorage.updateAllTagsResult = .error(FilterMetaStorageMockError.updateAllTagsError)
        updateAllMetaWithError(error: .updateAllTagsError)
        filtersMetaStorage.setResultsToDefault()

        filtersMetaStorage.updateAllLangsResult = .error(FilterMetaStorageMockError.updateAllLangsError)
        updateAllMetaWithError(error: .updateAllLangsError)
        filtersMetaStorage.setResultsToDefault()

        filtersMetaStorage.updateLocalizationForFilterResult = .error(FilterMetaStorageMockError.updateLocalizationForFilterError)
        updateAllMetaWithError(error: .updateLocalizationForFilterError)
        filtersMetaStorage.setResultsToDefault()

        filtersMetaStorage.updateLocalizationForGroupResult = .error(FilterMetaStorageMockError.updateLocalizationForGroupErorr)
        updateAllMetaWithError(error: .updateLocalizationForGroupErorr)
        filtersMetaStorage.setResultsToDefault()
        
        filtersMetaStorage.getAllLocalizedGroupsResult = .error(FilterMetaStorageMockError.getAllLocalizedGroupsError)
        updateAllMetaWithError(error: .getAllLocalizedGroupsError)
        filtersMetaStorage.setResultsToDefault()
    }
    
    func testSetGroupWithSuccess() {
        do {
            let group = filterService.groups.first(where: { $0.groupType == .ads })!
            let oldValue = group.isEnabled
            try filterService.setGroup(withId: group.groupId, enabled: !group.isEnabled)
            guard let group = filterService.groups.first(where: { $0.groupType == .ads }) else { return XCTFail() }
            XCTAssertNotEqual(oldValue, group.isEnabled)
            
            try filterService.setGroup(withId: -123466, enabled: false)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetGroupWithFailure() {
        filtersMetaStorage.setGroupResult = .error(FilterMetaStorageMockError.setGropuError)
        XCTAssertThrowsError(try filterService.setGroup(withId: 1, enabled: false))
    }
    
    func testSetFilterWithSuccess() {
        do {
            var fitler = (filterService.groups.first(where: { $0.groupType == .ads})?.filters.first)!
            let oldValue = fitler.isEnabled
            try filterService.setFilter(withId: fitler.filterId, SafariGroup.GroupType.ads.rawValue, enabled: !fitler.isEnabled)
            fitler = (filterService.groups.first(where: { $0.groupType == .ads })?.filters.first(where: { $0.filterId == fitler.filterId }))!
            XCTAssertNotEqual(oldValue, fitler.isEnabled)
            
            try filterService.setFilter(withId: -123123, -123123, enabled: false)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetFilterWithFailure() {
        filtersMetaStorage.setFilterResult = .error(FilterMetaStorageMockError.setFilterError)
        XCTAssertThrowsError(try filterService.setFilter(withId: 1, 1, enabled: false))
    }
    
    func testAddCustomFilter() {
        do {
            let filterId = filtersMetaStorage.nextCustomFilterId
            
            let filter = CustomFilterMeta(name: "Foo",
                                 description: "Bar",
                                 version: "123",
                                 lastUpdateDate: Date(),
                                 updateFrequency: 123,
                                 homePage: "url",
                                 licensePage: "license",
                                 issuesReportPage: "issuePage",
                                 communityPage: "page",
                                 filterDownloadPage: "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt",
                                 rulesCount: 1)
            
            try filterService.add(customFilter: filter, enabled: false)
            
            XCTAssertNotNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
                                
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testAddCustomFilterWithFailure() {
        let filterDownloadPage = "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt"
        filtersMetaStorage.addResult = .error(FilterMetaStorageMockError.addError)
        addCustomFilterWithFailure(filterDownloadPage: filterDownloadPage)
        filtersMetaStorage.setResultsToDefault()
        filterFileStorage.setResultsToDefault()

        addCustomFilterWithFailure(filterDownloadPage: nil)
        filtersMetaStorage.setResultsToDefault()
        filterFileStorage.setResultsToDefault()
        
        filterFileStorage.updateCustomFilterResult = .error(FilterFilesStorageMockError.error)
        addCustomFilterWithFailure(filterDownloadPage: filterDownloadPage)
        filtersMetaStorage.setResultsToDefault()
        filterFileStorage.setResultsToDefault()
    }
    
    func testDeleteCustomFilterWithSuccess() {
        do {
            let filterId = filtersMetaStorage.nextCustomFilterId
            
            let filter = CustomFilterMeta(name: "Foo",
                                 description: "Bar",
                                 version: "123",
                                 lastUpdateDate: Date(),
                                 updateFrequency: 123,
                                 homePage: "url",
                                 licensePage: "license",
                                 issuesReportPage: "issuePage",
                                 communityPage: "page",
                                 filterDownloadPage: "https://gitcdn.xyz/cdn/farrokhi/adblock-iran/4eb5c3eae9bb7593d98731e200233af27760874c/filter.txt",
                                 rulesCount: 1)
            
            try filterService.add(customFilter: filter, enabled: false)
            
            XCTAssertNotNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
            
            try filterService.deleteCustomFilter(withId: filterId)
            
            XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteCustomFilterWithFailure() {
        filtersMetaStorage.deleteResult = .error(FilterMetaStorageMockError.deleteError)
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: filtersMetaStorage.nextCustomFilterId))
        filtersMetaStorage.setResultsToDefault()
    
        filterFileStorage.deleteResult = .error(FilterFilesStorageMockError.error)
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: filtersMetaStorage.nextCustomFilterId))
        filterFileStorage.setResultsToDefault()
        
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: -12345))
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: 1))
    }
    
    func testRenameCustomFilterWithSuccess() {
        do {
            let filterId = filtersMetaStorage.nextCustomFilterId
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
            
            try filterService.add(customFilter: filter, enabled: false)
            
            XCTAssertNotNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
            
            try filterService.renameCustomFilter(withId: filterId, to: "Bar")
            
            let renamedFilter = filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId })
            
            XCTAssertNotNil(renamedFilter)
            XCTAssert(renamedFilter?.name == "Bar")
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testRenameCustomFilterWithFailure() {
        
        filtersMetaStorage.renameResult = .error(FilterMetaStorageMockError.renameError)
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: filtersMetaStorage.nextCustomFilterId, to: "foo"))
        filtersMetaStorage.setResultsToDefault()
        
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: -123, to: "some"))
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: 1, to: "some"))
    }
    
    //MARK: - Private methods
    private func updateAllMetaWithError(error: FilterMetaStorageMockError) {
        let expectation = XCTestExpectation()
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: {
            XCTAssertEqual($0 as! FilterMetaStorageMockError, error)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    private func addCustomFilterWithFailure(filterDownloadPage: String?) {
        XCTAssertThrowsError(try filterService.add(customFilter: CustomFilterMeta(name: "Foo",
                                                             description: "Bar",
                                                             version: "123",
                                                             lastUpdateDate: Date(),
                                                             updateFrequency: 123,
                                                             homePage: "url",
                                                             licensePage: "license",
                                                             issuesReportPage: "issuePage",
                                                             communityPage: "page",
                                                             filterDownloadPage: filterDownloadPage,
                                                             rulesCount: 1),
                              enabled: false))
    }
}
