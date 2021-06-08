import XCTest

class FitlerServiceNewTest: XCTestCase {
    
    var filterService: FiltersServiceNewProtocol!
    var filtersMetaStorage: FiltersMetaStorageProtocol!
    var userDefaultsStorage: UserDefaultsStorageMock!
    
    override class func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func setUpWithError() throws {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
        
        let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: FiltersMetaStorageTestProcessor.workingUrl)
        try productionDbManager.updateDatabaseIfNeeded()
        filtersMetaStorage = FiltersMetaStorageMock()
        userDefaultsStorage = UserDefaultsStorageMock()
        let jsonUrl = Bundle(for: type(of: self)).url(forResource: "filters_test", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonUrl)
        let decoder = JSONDecoder()
        let extendedFiltersMeta = try decoder.decode(ExtendedFiltersMeta.self, from: jsonData)
        
        filterService = try FiltersServiceNew(configuration: Configuration(),
                                              filterFilesStorage: FilterFilesStorageMock(),
                                              filtersMetaStorage: filtersMetaStorage,
                                              userDefaultsStorage: userDefaultsStorage,
                                              httpRequestService:  HttpRequestServiceMock(result: extendedFiltersMeta))
    }
    
    func testUpdateAllMetaWithSuccess() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name:
                                                                            NSNotification.Name.init(rawValue: "AdGuardSDK.filtersUpdateStarted"))

        let berforeUpdateDate = userDefaultsStorage.lastFiltersUpdateCheckDate
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { error in
            XCTAssertNil(error)
            expectation.fulfill()
            
            let filters = self.filterService.groups.first(where: { $0.groupType == .ads })!.filters
            XCTAssertFalse(filters.isEmpty)
            XCTAssertFalse(try! self.filtersMetaStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").isEmpty)
        })
        
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 5.0)
        let afterUpdateDate = userDefaultsStorage.lastFiltersUpdateCheckDate
        XCTAssert(afterUpdateDate > berforeUpdateDate)
    }
    
    func testSetGroupWithSuccess() {
        let group = filterService.groups.first(where: { $0.groupType == .ads })!
        let oldValue = group.isEnabled
        filterService.setGroup(withId: group.groupId, enabled: !group.isEnabled)
        guard let group = filterService.groups.first(where: { $0.groupType == .ads }) else { return XCTFail() }
        XCTAssertNotEqual(oldValue, group.isEnabled)
        
        filterService.setGroup(withId: -123466, enabled: false)
    }
    
    func testSetFilterWithSuccess() {
        var fitler = (filterService.groups.first(where: { $0.groupType == .ads})?.filters.first)!
        let oldValue = fitler.isEnabled
        filterService.setFilter(withId: fitler.filterId, SafariGroup.GroupType.ads.rawValue, enabled: !fitler.isEnabled)
        fitler = (filterService.groups.first(where: { $0.groupType == .ads })?.filters.first(where: { $0.filterId == fitler.filterId }))!
        XCTAssertNotEqual(oldValue, fitler.isEnabled)
        
        filterService.setFilter(withId: -123123, -123123, enabled: false)
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
    
    func testRenameCustomFilterWithFilure() {
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: -123, to: "some"))
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: 1, to: "some"))
    }
}
