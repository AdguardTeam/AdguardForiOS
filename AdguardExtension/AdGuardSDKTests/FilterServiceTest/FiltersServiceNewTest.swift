import XCTest

class FitlerServiceNewTest: XCTestCase {
    
    var filterService: FiltersServiceNewProtocol!
    var filtersMetaStorage: FiltersMetaStorageProtocol!
    
    override class func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func setUpWithError() throws {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
        
        let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: FiltersMetaStorageTestProcessor.workingUrl)
        try productionDbManager.updateDatabaseIfNeeded()
        filtersMetaStorage = FiltersMetaStorage(productionDbManager: productionDbManager)
        let jsonUrl = Bundle(for: type(of: self)).url(forResource: "filters_test", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonUrl)
        let decoder = JSONDecoder()
        let extendedFiltersMeta = try decoder.decode(ExtendedFiltersMeta.self, from: jsonData)
        
        filterService = try FiltersServiceNew(configuration: Configuration(),
                                              filterFilesStorage: FilterFilesStorageMock(),
                                              filtersMetaStorage: filtersMetaStorage,
                                              userDefaultsStorage: UserDefaultsStorageMock(),
                                              httpRequestService:  HttpRequestServiceMock(result: extendedFiltersMeta))
    }
    
    func testUpdateAllMetaWithSuccess() {
        do {
            guard let filters = filterService.groups.first(where: { $0.groupId == 1 }) else { return XCTFail() }
            let filtersId = filters.filters.map { $0.filterId }
            try filtersMetaStorage.deleteFilters(withIds: filtersId)
            XCTAssert(try filtersMetaStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").isEmpty)
            
            let isFiltersExists = filterService.groups.first(where: { $0.groupId == 1})!.filters.isEmpty
            XCTAssertFalse(isFiltersExists)
            
            
            
            let expectation = XCTestExpectation()
            let notificationExpectation = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished"))
            
            filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { error in
                XCTAssertNil(error)
                expectation.fulfill()
                
                let filters = self.filterService.groups.first(where: { $0.groupId == 1})!.filters
                XCTAssertFalse(filters.isEmpty)
                XCTAssertEqual(filters.count, filtersId.count)
                XCTAssertFalse(try! self.filtersMetaStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").isEmpty)
            })
            
            wait(for: [expectation, notificationExpectation], timeout: 1.0)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetGroupWithSuccess() {
        guard let group = filterService.groups.first(where: { $0.groupId == 1 }) else { return XCTFail() }
        let oldValue = group.isEnabled
        filterService.setGroup(withId: group.groupId, enabled: !group.isEnabled)
        guard let group = filterService.groups.first(where: { $0.groupId == 1 }) else { return XCTFail() }
        XCTAssertNotEqual(oldValue, group.isEnabled)
        
        filterService.setGroup(withId: -123466, enabled: false)
    }
    
    func testSetFilterWithSuccess() {
        guard let fitler = filterService.groups.first(where: { $0.groupId == 1})?.filters.first else { return XCTFail() }
        let oldValue = fitler.isEnabled
        filterService.setFilter(withId: fitler.filterId, 1, enabled: !fitler.isEnabled)
        guard let fitler = filterService.groups.first(where: { $0.groupId == 1})?.filters.first(where: { $0.filterId == fitler.filterId }) else { return XCTFail() }
        XCTAssertNotEqual(oldValue, fitler.isEnabled)
        
        filterService.setFilter(withId: -123123, -123123, enabled: false)
    }
    
    func testAddCustomFilter() {
        do {
            XCTAssert(filterService.groups.first(where: { $0.groupType == .custom })!.filters.isEmpty)
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
            
            XCTAssertNotNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
                                
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteCustomFilterWithSuccess() {
        do {
            
            XCTAssert(filterService.groups.first(where: { $0.groupType == .custom })!.filters.isEmpty)
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
            
            try filterService.deleteCustomFilter(withId: filterId)
            
            XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteCustomFilterWithFailure() {
        do {
            XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: -12345))
            XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: 1))

        } catch {
            XCTFail("\(error)")
        }
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
        do {
            XCTAssertThrowsError(try filterService.renameCustomFilter(withId: -123, to: "some"))
            XCTAssertThrowsError(try filterService.renameCustomFilter(withId: 1, to: "some"))
        } catch {
            XCTFail("\(error)")
        }
    }
}
