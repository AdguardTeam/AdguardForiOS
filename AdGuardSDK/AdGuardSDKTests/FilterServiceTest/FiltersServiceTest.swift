import XCTest

class FitlerServiceTest: XCTestCase {
    
    lazy var mockFiltersMeta: ExtendedFiltersMeta = {
        let groups = metaStorage.groupsTableMock.map { group in
            return ExtendedFiltersMeta.Group(groupId: group.groupId,
                                             groupName: group.name,
                                             displayNumber: group.displayNumber)
        }
        let tags = [
            ExtendedFiltersMeta.Tag(tagId: ExtendedFiltersMeta.Tag.TagType.lang.id, tagTypeId: ExtendedFiltersMeta.Tag.TagType.lang.id, tagName: "tag1")!,
            ExtendedFiltersMeta.Tag(tagId: ExtendedFiltersMeta.Tag.TagType.purpose.id, tagTypeId: ExtendedFiltersMeta.Tag.TagType.purpose.id, tagName: "tag1")!,
            ExtendedFiltersMeta.Tag(tagId: ExtendedFiltersMeta.Tag.TagType.platform.id, tagTypeId: ExtendedFiltersMeta.Tag.TagType.platform.id, tagName: "tag1")!,
            ExtendedFiltersMeta.Tag(tagId: ExtendedFiltersMeta.Tag.TagType.problematic.id, tagTypeId: ExtendedFiltersMeta.Tag.TagType.problematic.id, tagName: "tag1")!,
            ExtendedFiltersMeta.Tag(tagId: ExtendedFiltersMeta.Tag.TagType.recommended.id, tagTypeId: ExtendedFiltersMeta.Tag.TagType.recommended.id, tagName: "tag1")!,
            ExtendedFiltersMeta.Tag(tagId: ExtendedFiltersMeta.Tag.TagType.obsolete.id, tagTypeId: ExtendedFiltersMeta.Tag.TagType.obsolete.id, tagName: "tag1")!,
            ExtendedFiltersMeta.Tag(tagId: ExtendedFiltersMeta.Tag.TagType.problematic.id, tagTypeId: ExtendedFiltersMeta.Tag.TagType.problematic.id, tagName: "tag1")!
        ]
        let filters = metaStorage.filtersTableMock.map { filter in
            return ExtendedFiltersMeta.Meta(filterId: filter.filterId,
                                            name: filter.name,
                                            description: filter.description,
                                            timeAdded: filter.lastUpdateTime,
                                            homePage: filter.homePage,
                                            updateFrequency: filter.expires,
                                            displayNumber: filter.displayNumber,
                                            group: groups.first(where: { $0.groupId == filter.groupId })!,
                                            filterDownloadPage: filter.subscriptionUrl,
                                            trustLevel: .full,
                                            version: filter.version,
                                            lastUpdateDate: filter.lastUpdateTime,
                                            languages: [],
                                            tags: [])
        }
        return ExtendedFiltersMeta(groups: groups,
                                   tags: tags,
                                   filters: filters)
    }()
    
    lazy var mockFiltersLocalizations: ExtendedFiltersMetaLocalizations = {
        var groups: [Int : [String: ExtendedFiltersMetaLocalizations.GroupLocalization]] = [:]
        mockFiltersMeta.groups.forEach {
            let groupLocalization = ExtendedFiltersMetaLocalizations.GroupLocalization(name: "group_\($0.groupId)")
            groups[$0.groupId] = [:]
            groups[$0.groupId]?["en"] = groupLocalization
        }
    
        var tags: [Int: [String: ExtendedFiltersMetaLocalizations.TagLocalization]] = [:]
        mockFiltersMeta.tags.forEach {
            let tagLocalization = ExtendedFiltersMetaLocalizations.TagLocalization(name: "tag_name_\($0.tagId)", description: "tag_desc_\($0.tagId)")
            tags[$0.tagId] = [:]
            tags[$0.tagId]?["en"] = tagLocalization
        }
        
        var filters: [Int: [String: ExtendedFiltersMetaLocalizations.FilterLocalization]] = [:]
        mockFiltersMeta.filters.forEach {
            let filterLocalization = ExtendedFiltersMetaLocalizations.FilterLocalization(name: "filter_name_\($0.filterId)", description: "filter_desc_\($0.filterId)")
            filters[$0.filterId] = [:]
            filters[$0.filterId]?["en"] = filterLocalization
        }
        
        let localizations = ExtendedFiltersMetaLocalizations(groups: groups,
                                                             tags: tags,
                                                             filters: filters)
        return localizations
    }()
    
    let lastFiltersUpdateCheckDateKey = "AdGuardSDK.lastFiltersUpdateCheckDateKey"
    
    var filterService: FiltersServiceProtocol!
    var configuration: SafariConfigurationMock!
    var metaStorage: MetaStorageMock!
    var filterFileStorage: FilterFilesStorageMock!
    var apiMethods: SafariProtectionApiMethodsMock!
    var metaParser: MetaParserMock!
    var userDefaultsStorage: UserDefaultsStorageMock!
    
    let filtersUpdateFinishedNoteName = NSNotification.Name.init("AdGuardSDK.filtersUpdateFinished")
    let filtersUpdateStartedNoteName = NSNotification.Name.init("AdGuardSDK.filtersUpdateStarted")
    
    override class func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    override func setUpWithError() throws {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        
        configuration = SafariConfigurationMock()
        metaStorage = MetaStorageMock()
        filterFileStorage = FilterFilesStorageMock()
        userDefaultsStorage = UserDefaultsStorageMock()
        apiMethods = SafariProtectionApiMethodsMock()
        metaParser = MetaParserMock()
        
        filterService = try FiltersService(configuration: configuration,
                                           filterFilesStorage: filterFileStorage,
                                           metaStorage: metaStorage,
                                           userDefaultsStorage: userDefaultsStorage,
                                           metaParser: metaParser,
                                           apiMethods: apiMethods)
    }
    
    
    func testUpdateAllMetaWithUpdatePeriodError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        filtersUpdateStartedExpectation.isInverted = true
        filtersUpdateFinishedExpectation.isInverted = true
        
        userDefaultsStorage.storage.setValue(Date(), forKey: lastFiltersUpdateCheckDateKey)
        
        filterService.updateAllMeta(forcibly: false, onFiltersUpdated: { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                if case FiltersService.FilterServiceError.updatePeriodError(lastUpdateTime: _) = error {}
                else {
                    XCTFail()
                }
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 0)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 0)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 0)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 0)
        XCTAssertEqual(metaStorage.getAllLocalizedGroupsCalledCount, 1)
    }
    
    // All filter files were updated, but none of filter's version changed
    func testUpdateAllMetaWhenFiltersWereNotUpdatedBecauseVersionWasTheSame() {
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        
        let expectation = XCTestExpectation()
        let beforeUpdateDate = Date()
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(let updateResult):
                XCTAssert(updateResult.addedFilterIds.isEmpty)
                XCTAssert(updateResult.failedFilterIds.isEmpty)
                XCTAssert(updateResult.removedFiltersIds.isEmpty)
                XCTAssert(updateResult.updatedFilterIds.isEmpty)
                XCTAssertNil(updateResult.error)
            case .error(_):
                XCTFail()
            }
            expectation.fulfill()
        })
        
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        let afterUpdateDate = userDefaultsStorage.storage.value(forKey: lastFiltersUpdateCheckDateKey) as! Date
        XCTAssert(afterUpdateDate > beforeUpdateDate)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, metaStorage.filtersTableMock.filter{ $0.groupId == SafariGroup.GroupType.custom.id }.count)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, metaStorage.filtersTableMock.filter{ $0.groupId != SafariGroup.GroupType.custom.id }.count)
        XCTAssertEqual(apiMethods.loadFiltersMetadataCalledCount, 1)
        XCTAssertEqual(apiMethods.loadFiltersLocalizationsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
        XCTAssertEqual(metaStorage.addFilterCalledCount, 0)
        XCTAssertEqual(metaStorage.deleteFilterCalledCount, 0)
        XCTAssertEqual(metaStorage.getAllLocalizedGroupsCalledCount, 2)
    }
    
    // Predefined filter files failed to update, but custom succeded
    func testUpdateAllMetaWithUpdatePredefinedFiltersFilesError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        filterFileStorage.updateFilterResultError = FilterFilesStorageMockError.updateFilterError
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(let updateResult):
                XCTAssert(updateResult.addedFilterIds.isEmpty)
                XCTAssertEqual(updateResult.failedFilterIds.count, 28)
                XCTAssert(updateResult.removedFiltersIds.isEmpty)
                XCTAssert(updateResult.updatedFilterIds.isEmpty)
                XCTAssertNil(updateResult.error)
            case .error(_):
                XCTFail()
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
    }
    
    // Test case when we receive new filters from the server and some stored filters are missing and we need to delete them
    func testNewFiltersAddedAndSomeOldRemoved() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        let storedGroupIds = metaStorage.groupsTableMock.map{ $0.groupId }
        let storedFilterIds = metaStorage.filtersTableMock.map{ $0.filterId }
        filterService.groups.forEach { group in
            XCTAssert(storedGroupIds.contains(group.groupId))
            group.filters.forEach { XCTAssert(storedFilterIds.contains($0.filterId)) }
        }
        
        let removedFilterId = 3
        let modifiedFilterId = 10
        let addedFilterId = 31
        
        var modifiedFilters = mockFiltersMeta.filters
        modifiedFilters.removeAll(where: { $0.filterId ==  removedFilterId })
        
        var modifiedFilter = modifiedFilters.first(where: { $0.filterId == modifiedFilterId })!
        modifiedFilter = ExtendedFiltersMeta.Meta(filterId: modifiedFilter.filterId,
                                                  name: modifiedFilter.name! + "_mod",
                                                  description: modifiedFilter.description! + "_mod",
                                                  timeAdded: modifiedFilter.timeAdded,
                                                  homePage: modifiedFilter.homePage,
                                                  updateFrequency: modifiedFilter.updateFrequency,
                                                  displayNumber: modifiedFilter.displayNumber,
                                                  group: modifiedFilter.group,
                                                  filterDownloadPage: modifiedFilter.filterDownloadPage,
                                                  trustLevel: modifiedFilter.trustLevel,
                                                  version: modifiedFilter.version! + "1",
                                                  lastUpdateDate: modifiedFilter.lastUpdateDate,
                                                  languages: [],
                                                  tags: [])
        let modifiedFilterIndex = modifiedFilters.firstIndex(where: { $0.filterId == modifiedFilterId })!
        modifiedFilters[modifiedFilterIndex] = modifiedFilter
        
        let newFilterGroup = mockFiltersMeta.groups.first(where: { $0.groupId == SafariGroup.GroupType.annoyances.id })!
        let newFilter = ExtendedFiltersMeta.Meta(filterId: addedFilterId,
                                                 name: "newFilterName",
                                                 description: "newFilterDescription",
                                                 timeAdded: Date(),
                                                 homePage: "newFilterHomepage",
                                                 updateFrequency: 30000,
                                                 displayNumber: addedFilterId,
                                                 group: newFilterGroup,
                                                 filterDownloadPage: "newFilterDownloadPage",
                                                 trustLevel: .full,
                                                 version: "1.1.1.1",
                                                 lastUpdateDate: Date(),
                                                 languages: [],
                                                 tags: [])
        modifiedFilters.append(newFilter)
    
        let newMeta = ExtendedFiltersMeta(groups: mockFiltersMeta.groups, tags: mockFiltersMeta.tags, filters: modifiedFilters)
        apiMethods.loadFiltersMetadataResult = newMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        metaStorage.updateFiltersResult = .success([modifiedFilterId])
        
        filterService.updateAllMeta(forcibly: true) { result in
            switch result {
            case .success(let updateResult):
                XCTAssertEqual(updateResult.addedFilterIds, [addedFilterId])
                XCTAssertEqual(updateResult.removedFiltersIds, [removedFilterId])
                XCTAssertEqual(updateResult.failedFilterIds, [])
                XCTAssertEqual(updateResult.updatedFilterIds, [modifiedFilterId])
            case .error(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 29)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 2)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 2)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
    }
    
    // All filters files failed to update
    func testUpdateAllMetaWithUpdateAllFiltersFilesError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        filterFileStorage.updateFilterResultError = FilterFilesStorageMockError.updateFilterError
        filterFileStorage.updateCustomFilterError = FilterFilesStorageMockError.updateFilterError
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(let updateResult):
                XCTAssert(updateResult.addedFilterIds.isEmpty)
                XCTAssertEqual(updateResult.failedFilterIds.count, 30)
                XCTAssert(updateResult.removedFiltersIds.isEmpty)
                XCTAssert(updateResult.updatedFilterIds.isEmpty)
                XCTAssertNil(updateResult.error)
            case .error(_):
                XCTFail()
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 0)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
    }
    
    // Error updating meta for groups
    func testUpdateAllGroupsError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        metaStorage.updateGroupsResultError = MetaStorageMockError.updateAllGroupsError
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations

        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.updateAllGroupsError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 0)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
        
    }
    
    // Error updating meta for tags
    func testUpdateAllTagsError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        metaStorage.updateAllTagsResultError = MetaStorageMockError.updateAllTagsError
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        metaStorage.updateFiltersResult = .success([1, 10]) // Random filters ids

        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.updateAllTagsError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
    }
    
    // Error updating meta for langs
    func testUpdateAllLangsError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        metaStorage.updateAllLangsResultError = MetaStorageMockError.updateAllLangsError
        metaStorage.updateFiltersResult = .success([1, 10]) // Random filters ids
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
    
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.updateAllLangsError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
    }
    
    func testUpdateLocalizationForFilterError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)

        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        metaStorage.updateLocalizationForFilterResultError = MetaStorageMockError.updateLocalizationForFilterError
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.updateLocalizationForFilterError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 1)
    }
    
    func testUpdateLocalizationForGroupErorr() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)

        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        metaStorage.updateLocalizationForGroupResultError = MetaStorageMockError.updateLocalizationForGroupErorr
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.updateLocalizationForGroupErorr)
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 1)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 0)
    }
    
    func testGetAllLocalizedGroupsError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        metaStorage.getAllLocalizedGroupsResult = .error(MetaStorageMockError.getAllLocalizedGroupsError)
        
        filterService.updateAllMeta(forcibly: true, onFiltersUpdated: { result in
            switch result {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.getAllLocalizedGroupsError)
            }
            expectation.fulfill()
        })
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 2)
        XCTAssertEqual(filterFileStorage.updateFilterCalledCount, 28)
        XCTAssertEqual(metaStorage.updateFiltersCalledCount, 1)
        XCTAssertEqual(metaStorage.updateGroupsCalledCount, 1)
        XCTAssertEqual(metaStorage.updateAllLangsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateAllTagsCalledCount, 0)
        XCTAssertEqual(metaStorage.updateLocalizationForGroupCalledCount, 8)
        XCTAssertEqual(metaStorage.updateLocalizationForFilterCalledCount, 30)
    }
    
    func testSetGroupWithSuccess() {
        let group = filterService.groups.first(where: { $0.groupType == .ads })!
        try! filterService.setGroup(withId: group.groupId, enabled: !group.isEnabled)
        let groupAfterSet = filterService.groups.first(where: { $0.groupType == .ads })!
        XCTAssertNotEqual(groupAfterSet.isEnabled, group.isEnabled)
        XCTAssertEqual(metaStorage.setGroupCalledCount, 1)
    }
    
    func testSetGroupWithNonExistingGroupId() {
        XCTAssertThrowsError(try filterService.setGroup(withId: -123466, enabled: false)) { error in
            if case FiltersService.FilterServiceError.nonExistingGroupId(groupId: _) = error {}
            else {
                XCTFail()
            }
        }
    }
    
    func testSetGroupWithFailure() {
        metaStorage.setGroupResultError = MetaStorageMockError.setGroupError
        XCTAssertThrowsError(try filterService.setGroup(withId: SafariGroup.GroupType.ads.id, enabled: false), "") { error in
            XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.setGroupError)
        }
        
        XCTAssertEqual(metaStorage.setGroupCalledCount, 1)
    }
    
    func testSetFilterWithSuccess() {
        let fitler = (filterService.groups.first(where: { $0.groupType == .ads})?.filters.first)!
        try! filterService.setFilter(withId: fitler.filterId, SafariGroup.GroupType.ads.rawValue, enabled: !fitler.isEnabled)
        let fitlerAfterSet = (filterService.groups.first(where: { $0.groupType == .ads })?.filters.first(where: { $0.filterId == fitler.filterId }))!
        XCTAssertNotEqual(fitlerAfterSet.isEnabled, fitler.isEnabled)
        XCTAssertEqual(metaStorage.setFilterCalledCount, 1)
    }
    
    func testSetFilterWithNonExistingFilterId() {
        XCTAssertThrowsError(try filterService.setFilter(withId: -123123, -123123, enabled: false)) { error in
            if case FiltersService.FilterServiceError.nonExistingFilterId(filterId: _) = error {}
            else {
                XCTFail()
            }
        }
    }
    
    func testSetFilterWithFailure() {
        metaStorage.setFilterResultError = MetaStorageMockError.setFilterError
        XCTAssertThrowsError(try filterService.setFilter(withId: 1, 1, enabled: false), "") { error in
            XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.setFilterError)
        }
        XCTAssertEqual(metaStorage.setFilterCalledCount, 1)
    }
    
    func testAddCustomFilter() {
        let filterId = metaStorage.nextCustomFilterId
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
                             filterDownloadPage: "filterDownloadPage",
                             rulesCount: 10)
        
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
        
        let expectation = XCTestExpectation()
        
        filterService.add(customFilter: filter, enabled: true) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertEqual(metaStorage.addFilterCalledCount, 1)
        XCTAssertEqual(filterFileStorage.updateCustomFilterCalledCount, 1)
        
        let newFilter = filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId })!
        XCTAssertEqual(newFilter?.name, "Foo")
        XCTAssertEqual(newFilter?.description, "Bar")
        XCTAssertEqual(newFilter?.version, "123")
        XCTAssertEqual(newFilter?.lastUpdateDate, lastUpdateDate)
        XCTAssertEqual(newFilter?.updateFrequency, 123)
        XCTAssertEqual(newFilter?.homePage, "url")
        XCTAssertEqual(newFilter?.filterDownloadPage, "filterDownloadPage")
        
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 3)
    }
    
    func testAddCustomFilterWithAddError() {
        let filterId = metaStorage.nextCustomFilterId
        metaStorage.addResultError = MetaStorageMockError.addError
        let customFilter = CustomFilterMeta(name: "Foo",
                                            description: "Bar",
                                            version: "123",
                                            lastUpdateDate: Date(),
                                            updateFrequency: 123,
                                            homePage: "url",
                                            licensePage: "license",
                                            issuesReportPage: "issuePage",
                                            communityPage: "page",
                                            filterDownloadPage: "filterDownloadPage",
                                            rulesCount: 1)
        
        let expectation = XCTestExpectation()
        
        filterService.add(customFilter: customFilter, enabled: false) { error in
            XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.addError)
            XCTAssertEqual(self.metaStorage.addFilterCalledCount, 1)
            XCTAssertEqual(self.filterFileStorage.updateCustomFilterCalledCount, 1)
            XCTAssertEqual(self.filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
            XCTAssertNil(self.filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testAddCustomFilterWithUpdateCustomFilterError() {
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
                                            filterDownloadPage: "filterDownloadPage",
                                            rulesCount: 1)
        
        filterFileStorage.updateCustomFilterError = FilterFilesStorageMockError.updateCustomFilterError
        let expectation = XCTestExpectation()
        
        filterService.add(customFilter: customFilter, enabled: false) { error in
            XCTAssertEqual(error as! FilterFilesStorageMockError, FilterFilesStorageMockError.updateCustomFilterError)
            XCTAssertEqual(self.metaStorage.addFilterCalledCount, 0)
            XCTAssertEqual(self.filterFileStorage.updateCustomFilterCalledCount, 1)
            XCTAssertEqual(self.filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
            XCTAssertNil(self.filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testAddCustomFilterWithMissedDownloadPageError() {
        let filterId = CustomFilterMeta.baseCustomFilterId + 1
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

        let expectation = XCTestExpectation()
        filterService.add(customFilter: customFilter, enabled: false) { error in
            guard case FiltersService.FilterServiceError.missedFilterDownloadPage(filterName: _) = error! else {
                XCTFail()
                return
            }
            XCTAssertEqual(self.metaStorage.addFilterCalledCount, 0)
            XCTAssertEqual(self.filterFileStorage.updateCustomFilterCalledCount, 0)
            XCTAssertEqual(self.filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
            XCTAssertNil(self.filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: {$0.filterId == filterId }))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testDeleteCustomFilterWithSuccess() {
        let expectedFilterId = metaStorage.nextCustomFilterId
        let filter = CustomFilterMeta(name: "Foo",
                             description: "Bar",
                             version: "123",
                             lastUpdateDate: Date(),
                             updateFrequency: 123,
                             homePage: "url",
                             licensePage: "license",
                             issuesReportPage: "issuePage",
                             communityPage: "page",
                             filterDownloadPage: "filterDownloadPage",
                             rulesCount: 1)
        

        let expectation = XCTestExpectation()
        filterService.add(customFilter: filter, enabled: false) { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertFalse(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.isEmpty)
        XCTAssertNotNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == expectedFilterId }))
        XCTAssertEqual(metaStorage.deleteFilterCalledCount, 0)
        XCTAssertEqual(filterFileStorage.deleteFilterCalledCount, 0)
        
        try! filterService.deleteCustomFilter(withId: expectedFilterId)
        
        XCTAssertEqual(metaStorage.deleteFilterCalledCount, 1)
        XCTAssertEqual(filterFileStorage.deleteFilterCalledCount, 1)
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == expectedFilterId }))
    }
    
    func testDeleteCustomFilterWithDeleteMetaError() {
        let filterId = metaStorage.nextCustomFilterId
        metaStorage.deleteFilterResultError = MetaStorageMockError.deleteError
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: filterId)) { error in
            XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.deleteError)
        }
        
        XCTAssertEqual(metaStorage.deleteFilterCalledCount, 1)
        XCTAssertEqual(filterFileStorage.deleteFilterCalledCount, 0)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertEqual(self.filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
    }
    
    func testDeleteCustomFilterWithDeleteFilterError() {
        let filterId = metaStorage.nextCustomFilterId
        filterFileStorage.deleteResultError = FilterFilesStorageMockError.deleteError
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
        
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: metaStorage.nextCustomFilterId)) { error in
            XCTAssertEqual(error as! FilterFilesStorageMockError, FilterFilesStorageMockError.deleteError)
        }
        XCTAssertEqual(metaStorage.deleteFilterCalledCount, 1)
        XCTAssertEqual(filterFileStorage.deleteFilterCalledCount, 1)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
    }
    
    func testDeleteCustomFilterWithNotExistingId() {
        let filterId = metaStorage.nextCustomFilterId

        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
        
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: -12345)) { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {}
            else {
                XCTFail()
            }
        }
        XCTAssertEqual(metaStorage.deleteFilterCalledCount, 0)
        XCTAssertEqual(filterFileStorage.deleteFilterCalledCount, 0)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
    }
    
    func testDeleteCustomFilterWithWrongId() {
        let filterId = metaStorage.nextCustomFilterId
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
        
        XCTAssertThrowsError(try filterService.deleteCustomFilter(withId: 1)) { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {}
            else {
                XCTFail()
            }
        }
        XCTAssertEqual(metaStorage.deleteFilterCalledCount, 0)
        XCTAssertEqual(filterFileStorage.deleteFilterCalledCount, 0)
        XCTAssertNil(filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId }))
        XCTAssertEqual(filterService.groups.filter{$0.groupId == SafariGroup.GroupType.custom.id}[0].filters.count, 2)
    }
    
    func testRenameCustomFilterWithSuccess() {
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
        XCTAssertEqual(metaStorage.renameFilterCalledCount, 0)
        
        try! filterService.renameCustomFilter(withId: filterId, to: "Bar")
        
        XCTAssertEqual(metaStorage.renameFilterCalledCount, 1)

        let renamedFilter = filterService.groups.first(where: { $0.groupType == .custom })?.filters.first(where: { $0.filterId == filterId })
        
        XCTAssertNotNil(renamedFilter)
        XCTAssert(renamedFilter?.name == "Bar")
    }
    
    func testRenameCustomFilterWithRenameError() {
        metaStorage.renameResultError = MetaStorageMockError.renameError
        
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: metaStorage.nextCustomFilterId, to: "foo")) { error in
            XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.renameError)
        }
        XCTAssertEqual(metaStorage.renameFilterCalledCount, 1)
    }
    
    func testRenameCustomFilterWithNegativeId() {
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: -123, to: "some")) { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {}
            else {
                XCTFail()
            }
        }
        XCTAssertEqual(metaStorage.renameFilterCalledCount, 0)
    }
    
    func testRenameCustomFilterWithWrongId() {
        XCTAssertThrowsError(try filterService.renameCustomFilter(withId: 1, to: "some"), "") { error in
            if case FiltersService.FilterServiceError.invalidCustomFilterId(filterId: _) = error {}
            else {
                XCTFail()
            }
        }
        XCTAssertEqual(metaStorage.renameFilterCalledCount, 0)
    }
    
    func testResetWithSuccess() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        
        apiMethods.loadFiltersMetadataResult = mockFiltersMeta
        apiMethods.loadFiltersLocalizationsResult = mockFiltersLocalizations
        
        filterService.reset { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(metaStorage.resetCalledCount, 1)
        XCTAssertEqual(filterFileStorage.resetCalledCount, 1)
    }
    
    func testResetWithMetaStorageError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        filtersUpdateFinishedExpectation.isInverted = true
        filtersUpdateStartedExpectation.isInverted = true
        
        metaStorage.resetError = MetaStorageMockError.resetError
        
        filterService.reset { error in
            XCTAssertEqual(error as! MetaStorageMockError, MetaStorageMockError.resetError)
            expectation.fulfill()
        }
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(metaStorage.resetCalledCount, 1)
        XCTAssertEqual(filterFileStorage.resetCalledCount, 0)
    }
    
    func testResetWithFilterFilesStorageError() {
        let expectation = XCTestExpectation()
        let filtersUpdateFinishedExpectation = XCTNSNotificationExpectation(name: filtersUpdateFinishedNoteName)
        let filtersUpdateStartedExpectation = XCTNSNotificationExpectation(name: filtersUpdateStartedNoteName)
        filtersUpdateFinishedExpectation.isInverted = true
        filtersUpdateStartedExpectation.isInverted = true
        
        filterFileStorage.resetError = FilterFilesStorageMockError.resetError
        
        filterService.reset { error in
            XCTAssertEqual(error as! FilterFilesStorageMockError, FilterFilesStorageMockError.resetError)
            expectation.fulfill()
        }
        wait(for: [expectation, filtersUpdateFinishedExpectation, filtersUpdateStartedExpectation], timeout: 1.0)
        
        XCTAssertEqual(metaStorage.resetCalledCount, 1)
        XCTAssertEqual(filterFileStorage.resetCalledCount, 1)
    }
}
