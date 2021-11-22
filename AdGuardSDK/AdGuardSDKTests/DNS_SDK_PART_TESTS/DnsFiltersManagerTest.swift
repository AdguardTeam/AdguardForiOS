import XCTest

class DnsFiltersManagerTest: XCTestCase {

    var userDefaults: UserDefaultsStorageMock!
    var filtersStorage: FilterFilesStorageMock!
    var metaParser: MetaParserMock!
    var configuration: DnsConfigurationMock!
    var manager: DnsFiltersManagerProtocol!

    override func setUp() {
        userDefaults = UserDefaultsStorageMock()
        filtersStorage = FilterFilesStorageMock()
        metaParser = MetaParserMock()
        configuration = DnsConfigurationMock()
        manager = DnsFiltersManager(
            userDefaults: userDefaults,
            filterFilesStorage: filtersStorage,
            configuration: configuration,
            metaParser: metaParser
        )
    }

    let filters: [DnsFilter] = {
        let filter1 = DnsFilter(filterId: 1,
                                subscriptionUrl: URL(string: "https://filter.com")!,
                                isEnabled: true,
                                name: "Name1",
                                description: "Desc1",
                                version: "1.1.1.1",
                                lastUpdateDate: nil,
                                homePage: "homepage1",
                                licensePage: "licensepage1",
                                issuesReportPage: "issueReportPage1",
                                communityPage: "communityPage1",
                                filterDownloadPage: "filterDownloadPage1",
                                rulesCount: 120)

        let filter2 = DnsFilter(filterId: 2,
                                subscriptionUrl: URL(string: "https://filter2.com")!,
                                isEnabled: false,
                                name: "Name2",
                                description: "Desc2",
                                version: "1.1.1.2",
                                lastUpdateDate: nil,
                                homePage: "homepage2",
                                licensePage: "licensepage2",
                                issuesReportPage: "issueReportPage2",
                                communityPage: "communityPage2",
                                filterDownloadPage: "filterDownloadPage2",
                                rulesCount: 201)
        return [filter1, filter2]
    }()

    func testFilters() {
        XCTAssert(manager.filters.isEmpty)

        set(filters)
        XCTAssertEqual(manager.filters, filters)

        set([])
        XCTAssert(manager.filters.isEmpty)
    }

    // MARK: - Test setFilter

    func testSetFilterWithSuccess() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        try! manager.setFilter(withId: filters.first!.filterId, to: !filters.first!.isEnabled)
        XCTAssertEqual(manager.filters.first!.isEnabled, !filters.first!.isEnabled)
    }

    func testSetFilterWithAbcentFilter() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        XCTAssertThrowsError(try manager.setFilter(withId: 100, to: true)) { error in
            if case DnsFiltersManager.DnsFilterError.dnsFilterAbsent(filterId: 100) = error {}
            else {
                XCTFail()
            }
        }

        XCTAssertEqual(manager.filters, filters)
    }

    // MARK: - Test renameFilter

    func testRenameFilterWithSuccess() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        try! manager.renameFilter(withId: filters[1].filterId, to: "new name")
        XCTAssertEqual(manager.filters[1].name, "new name")
    }

    func testRenameFilterWithAbcentFilter() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        XCTAssertThrowsError(try manager.renameFilter(withId: 100, to: "new name")) { error in
            if case DnsFiltersManager.DnsFilterError.dnsFilterAbsent(filterId: 100) = error {}
            else {
                XCTFail()
            }
        }

        XCTAssertEqual(manager.filters, filters)
    }

    // MARK: - Test addFilter

    func testAddFilterWithSuccess() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let expectedFilter = DnsFilter(filterId: 3,
                                       subscriptionUrl: URL(string: "https://filter.com")!,
                                       isEnabled: true,
                                       name: "Added filter name",
                                       description: nil,
                                       version: nil,
                                       lastUpdateDate: nil,
                                       homePage: nil,
                                       licensePage: nil,
                                       issuesReportPage: nil,
                                       communityPage: nil,
                                       filterDownloadPage: nil,
                                       rulesCount: 0)

        let exp = XCTestExpectation()
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        manager.addFilter(withName: expectedFilter.name!, url: expectedFilter.subscriptionUrl, isEnabled: expectedFilter.isEnabled, onFilterAdded: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)

        var expectedFilters = filters
        expectedFilters.append(expectedFilter)
        XCTAssertEqual(manager.filters, expectedFilters)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
    }

    func testAddFilterWithSuccessParsingMeta() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let expectedFilter = DnsFilter(filterId: 3,
                                       subscriptionUrl: URL(string: "https://filter.com")!,
                                       isEnabled: true,
                                       name: "Added filter name",
                                       description: nil,
                                       version: nil,
                                       lastUpdateDate: nil,
                                       homePage: nil,
                                       licensePage: nil,
                                       issuesReportPage: nil,
                                       communityPage: nil,
                                       filterDownloadPage: nil,
                                       rulesCount: 0)

        let exp = XCTestExpectation()
        metaParser.parseWithFilterDownloadPageResult = .success(expectedFilter)
        filtersStorage.getFilterResultHandler = { _ in "content" }
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        manager.addFilter(withName: expectedFilter.name!, url: expectedFilter.subscriptionUrl, isEnabled: expectedFilter.isEnabled, onFilterAdded: { error in
            XCTAssertNil(error)
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)

        var expectedFilters = filters
        expectedFilters.append(expectedFilter)
        XCTAssertEqual(manager.filters, expectedFilters)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 1)

    }

    func testAddFilterWithFiltersStorageError() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)
        let exp = XCTestExpectation()
        filtersStorage.updateCustomFilterError = CommonError.missingData
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        manager.addFilter(withName: "name", url: URL(string: "https://filter.com")!, isEnabled: true, onFilterAdded: { error in
            if case CommonError.missingData = error as! CommonError {}
            else {
                XCTFail()
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
    }

    func testAddFilterWithParserEror() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)
        let exp = XCTestExpectation()

        filtersStorage.getFilterResultHandler = { _ in "content" }
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        manager.addFilter(withName: "name", url: URL(string: "https://filter.com")!, isEnabled: true, onFilterAdded: { error in
            if case CommonError.missingData = error as! CommonError {}
            else {
                XCTFail()
            }
            exp.fulfill()
        })

        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 1)
    }

    // MARK: - Test removeFilter

    func testRemoveFilterWithSuccess() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        try! manager.removeFilter(withId: 1)

        XCTAssertEqual(manager.filters, [filters[1]])
    }

    func testRemoveFilterWithFiltersStorageError() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        filtersStorage.deleteResultError = CommonError.missingData

        XCTAssertThrowsError(try manager.removeFilter(withId: 1)) { error in
            if case CommonError.missingData = error as! CommonError {}
            else {
                XCTFail()
            }
        }

        XCTAssertEqual(manager.filters, filters)
    }

    // MARK: - Test updateFilter

    func testUpdateFilterWithSuccess() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let expectedFilter = DnsFilter(filterId: filters.first!.filterId,
                                       subscriptionUrl: filters.first!.subscriptionUrl,
                                       isEnabled: filters.first!.isEnabled,
                                       name: filters.first!.name,
                                       description: nil,
                                       version: nil,
                                       lastUpdateDate: nil,
                                       homePage: nil,
                                       licensePage: nil,
                                       issuesReportPage: nil,
                                       communityPage: nil,
                                       filterDownloadPage: nil,
                                       rulesCount: 0)

        let exp = XCTestExpectation()
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        manager.updateFilter(withId: 1) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)

        XCTAssertEqual([expectedFilter, filters[1]], manager.filters)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
    }

    func testUpdateFilterWithSuccessParsingMeta() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let expectedFilter = DnsFilter(filterId: filters.first!.filterId,
                                       subscriptionUrl: filters.first!.subscriptionUrl,
                                       isEnabled: filters.first!.isEnabled,
                                       name: filters.first!.name,
                                       description: nil,
                                       version: nil,
                                       lastUpdateDate: nil,
                                       homePage: nil,
                                       licensePage: nil,
                                       issuesReportPage: nil,
                                       communityPage: nil,
                                       filterDownloadPage: nil,
                                       rulesCount: 0)

        let exp = XCTestExpectation()
        metaParser.parseWithFilterDownloadPageResult = .success(expectedFilter)
        filtersStorage.getFilterResultHandler = { _ in "content" }
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        manager.updateFilter(withId: 1) { error in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)

        XCTAssertEqual([expectedFilter, filters[1]], manager.filters)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 1)
    }

    func testUpdateFilterWithAbsentFilter() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let exp = XCTestExpectation()
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        manager.updateFilter(withId: 100) { error in
            if case DnsFiltersManager.DnsFilterError.dnsFilterAbsent(filterId: _) = error as! DnsFiltersManager.DnsFilterError {}
            else {
                XCTFail()
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
    }

    func testUpdateFilterWithFiltersStorageError() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        filtersStorage.updateCustomFilterError = CommonError.missingData

        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
        let exp = XCTestExpectation()
        manager.updateFilter(withId: 1) { error in
            if case CommonError.missingData = error as! CommonError {}
            else {
                XCTFail()
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)
    }

    func testUpdateFilterWithParserError() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 0)

        let exp = XCTestExpectation()
        filtersStorage.getFilterResultHandler = { _ in "content" }
        manager.updateFilter(withId: 1) { error in
            if case CommonError.missingData = error as! CommonError {}
            else {
                XCTFail()
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
        XCTAssertEqual(metaParser.parseWithFilterDownloadPageCalledCount, 1)
    }

    // MARK: - Test updateAllFilters

    func testUpdateAllFiltersWithAllFiltersUpdated() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let exp = XCTestExpectation()
        manager.updateAllFilters { result in
            XCTAssertEqual(result.updatedFiltersIds, [1])
            XCTAssertEqual(result.unupdatedFiltersIds, [])
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testUpdateAllFiltersWithAllFiltersNotUpdated() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        filtersStorage.updateCustomFilterError = CommonError.missingData

        let exp = XCTestExpectation()
        manager.updateAllFilters { result in
            XCTAssertEqual(result.updatedFiltersIds, [])
            XCTAssertEqual(result.unupdatedFiltersIds, [1])
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    func testUpdateAllFiltersWithZeroFilters() {
        set([])
        XCTAssert(manager.filters.isEmpty)

        let exp = XCTestExpectation()
        manager.updateAllFilters { result in
            XCTAssert(result.updatedFiltersIds.isEmpty)
            XCTAssert(result.unupdatedFiltersIds.isEmpty)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.5)
    }

    // MARK: - Test getDnsLibsFilters

    func testGetDnsLibsFiltersWithDnsFilteringEnabled() {
        configuration.dnsFilteringIsEnabled = true
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let url = URL(string: "https://filters.com")!
        filtersStorage.stubbedGetUrlForFilterResult = url

        let filters = manager.getDnsLibsFilters()

        XCTAssertEqual(filters.count, 1)
        XCTAssertNotNil(filters[1])
    }

    func testGetDnsLibsFiltersWithDnsFilteringDisabled() {
        configuration.dnsFilteringIsEnabled = false
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        let url = URL(string: "https://filters.com")!
        filtersStorage.stubbedGetUrlForFilterResult = url

        let filters = manager.getDnsLibsFilters()

        XCTAssert(filters.isEmpty)
    }

    // MARK: - Test reset

    func testResetWithSuccess() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        try! manager.reset()

        XCTAssert(manager.filters.isEmpty)
    }

    func testResetWithFilesStorageError() {
        set(filters)
        XCTAssertEqual(manager.filters, filters)

        filtersStorage.deleteResultError = CommonError.missingData

        XCTAssertThrowsError(try manager.reset()) { error in
            if case CommonError.missingData = error as! CommonError {}
            else {
                XCTFail()
            }
        }
    }

    private func set(_ filters: [DnsFilter]) {
        let key = "DnsAdGuardSDK.dnsFiltersKey"
        let encoder = JSONEncoder()
        let filtersData = try! encoder.encode(filters)
        userDefaults.storage.setValue(filtersData, forKey: key)
    }
}
