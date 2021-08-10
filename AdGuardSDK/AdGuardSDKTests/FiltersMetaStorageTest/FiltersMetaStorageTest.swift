import XCTest

class FiltersMetaStorageTest: XCTestCase {
    
    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!
    
    override func setUpWithError() throws {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        try productionDbManager?.updateDatabaseIfNeeded()
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
    }
    
    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }
    
    func testCustomGroupExists() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        
        productionDbManager = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)
        try! productionDbManager?.updateDatabaseIfNeeded()
        var count = try! productionDbManager.filtersDb.scalar("SELECT count(*) FROM filter_groups WHERE group_id = \(SafariGroup.GroupType.custom.rawValue)") as! Int64
        XCTAssertEqual(count, 0)
        
        metaStorage = MetaStorage(productionDbManager: productionDbManager)
        
        count = try! productionDbManager.filtersDb.scalar("SELECT count(*) FROM filter_groups WHERE group_id = \(SafariGroup.GroupType.custom.rawValue)") as! Int64
        XCTAssertEqual(count, 1)
    }

    func testGetAllFiltersWithSuccess() {
        // Test with en language
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 4)
        filters.forEach {
            XCTAssertNotNil($0.filterId)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.version)
            XCTAssertFalse($0.version!.isEmpty)
            XCTAssertNotNil($0.lastUpdateTime)
            XCTAssertNotNil($0.lastCheckTime)
            XCTAssertNotNil($0.editable)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.description)
            XCTAssertFalse($0.description.isEmpty)
            XCTAssertNotNil($0.homePage)
            XCTAssertFalse($0.homePage!.isEmpty)
            XCTAssertNotNil($0.removable)
            XCTAssertNotNil($0.expires)
            XCTAssertFalse($0.subscriptionUrl!.isEmpty)
        }
        
        // Test with fr language
        let privacyGroupId = SafariGroup.GroupType.privacy.id
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: privacyGroupId, forLanguage: "fr")
        XCTAssertEqual(filters.count, 5)
        filters.forEach {
            XCTAssertNotNil($0.filterId)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.version)
            XCTAssertFalse($0.version!.isEmpty)
            XCTAssertNotNil($0.lastUpdateTime)
            XCTAssertNotNil($0.lastCheckTime)
            XCTAssertNotNil($0.editable)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.description)
            XCTAssertFalse($0.description.isEmpty)
            XCTAssertNotNil($0.homePage)
            XCTAssertFalse($0.homePage!.isEmpty)
            XCTAssertNotNil($0.removable)
            XCTAssertNotNil($0.expires)
            XCTAssertFalse($0.subscriptionUrl!.isEmpty)
        }
    }
    
    func testGetAllFiltersWithNonExistingLang() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        let filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "123")
        XCTAssertEqual(filters.count, 4)
        filters.forEach {
            XCTAssertNotNil($0.filterId)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.version)
            XCTAssertFalse($0.version!.isEmpty)
            XCTAssertNotNil($0.lastUpdateTime)
            XCTAssertNotNil($0.lastCheckTime)
            XCTAssertNotNil($0.editable)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.description)
            XCTAssertFalse($0.description.isEmpty)
            XCTAssertNotNil($0.homePage)
            XCTAssertFalse($0.homePage!.isEmpty)
            XCTAssertNotNil($0.removable)
            XCTAssertNotNil($0.expires)
            XCTAssertFalse($0.subscriptionUrl!.isEmpty)
        }
    }
    
    func testSetGroup() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        let filter = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en").first!
    
        try! metaStorage.setFilter(withId: filter.filterId, enabled: !filter.isEnabled)
        
        let updatedFilter = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en").first(where: { $0.filterId == filter.filterId})!
        XCTAssertNotEqual(filter.isEnabled, updatedFilter.isEnabled)
    }

    func testUpdateFilterWithNewVersion() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 4)
        
        let filterToModify = filters.first!
        let modifiedFilter = ExtendedFiltersMeta.Meta(filterId: filterToModify.filterId,
                                                      name: "newName",
                                                      description: "newDescription",
                                                      timeAdded: nil,
                                                      homePage: filterToModify.homePage,
                                                      updateFrequency: filterToModify.expires,
                                                      displayNumber: 0,
                                                      group: ExtendedFiltersMeta.Group(groupId: adsGroupId, groupName: "name", displayNumber: 1),
                                                      filterDownloadPage: filterToModify.subscriptionUrl,
                                                      trustLevel: .full,
                                                      version: "2.2.2.2",
                                                      lastUpdateDate: filterToModify.lastUpdateTime,
                                                      languages: [],
                                                      tags: [])
        
        let isUpdated = try! metaStorage.update(filter: modifiedFilter)
        XCTAssert(isUpdated)
        
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 4)
        
        let modifiedFilterAfterUpdate = filters.first(where: { filterToModify.filterId == $0.filterId })!
        XCTAssertEqual(modifiedFilterAfterUpdate.displayNumber, 0)
        XCTAssertEqual(modifiedFilterAfterUpdate.version, "2.2.2.2")
    }
    
    func testUpdateFilterWithOldVersion() {
        func testUpdateFilterWithNewVersion() {
            let adsGroupId = SafariGroup.GroupType.ads.id
            var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
            XCTAssertEqual(filters.count, 4)
            
            let filterToModify = filters.first!
            let modifiedFilter = ExtendedFiltersMeta.Meta(filterId: filterToModify.filterId,
                                                          name: "newName",
                                                          description: "newDescription",
                                                          timeAdded: nil,
                                                          homePage: filterToModify.homePage,
                                                          updateFrequency: filterToModify.expires,
                                                          displayNumber: 0,
                                                          group: ExtendedFiltersMeta.Group(groupId: adsGroupId, groupName: "name", displayNumber: 1),
                                                          filterDownloadPage: filterToModify.subscriptionUrl,
                                                          trustLevel: .full,
                                                          version: filterToModify.version,
                                                          lastUpdateDate: filterToModify.lastUpdateTime,
                                                          languages: [],
                                                          tags: [])
            
            let isUpdated = try! metaStorage.update(filter: modifiedFilter)
            XCTAssertFalse(isUpdated)
            
            filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
            XCTAssertEqual(filters.count, 4)
            
            let modifiedFilterAfterUpdate = filters.first(where: { filterToModify.filterId == $0.filterId })!
            XCTAssertEqual(modifiedFilterAfterUpdate.displayNumber, filterToModify.displayNumber)
            XCTAssertEqual(modifiedFilterAfterUpdate.version, filterToModify.version)
        }
    }
    
    func testUpdateFilters() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 4)

        let filterToModify = filters[1]
        let freshFilter = filters[2]
        let unchangedFilter = filters[3]
        
        // Filter version is modified
        let modifiedFilter = ExtendedFiltersMeta.Meta(filterId: filterToModify.filterId,
                                                      name: "newName",
                                                      description: "newDescription",
                                                      timeAdded: nil,
                                                      homePage: filterToModify.homePage,
                                                      updateFrequency: filterToModify.expires,
                                                      displayNumber: 0,
                                                      group: ExtendedFiltersMeta.Group(groupId: adsGroupId, groupName: "name", displayNumber: 1),
                                                      filterDownloadPage: filterToModify.subscriptionUrl,
                                                      trustLevel: .full,
                                                      version: filterToModify.version! + "dddd",
                                                      lastUpdateDate: filterToModify.lastUpdateTime,
                                                      languages: [],
                                                      tags: [])
        // Filter version is not modified
        let filterThatShouldNotChange = ExtendedFiltersMeta.Meta(filterId: freshFilter.filterId,
                                                                 name: "newName112",
                                                                 description: "newDescription323",
                                                                 timeAdded: nil,
                                                                 homePage: freshFilter.homePage,
                                                                 updateFrequency: freshFilter.expires,
                                                                 displayNumber: 210,
                                                                 group: ExtendedFiltersMeta.Group(groupId: adsGroupId, groupName: "name", displayNumber: 1),
                                                                 filterDownloadPage: freshFilter.subscriptionUrl,
                                                                 trustLevel: .full,
                                                                 version: freshFilter.version!,
                                                                 lastUpdateDate: freshFilter.lastUpdateTime,
                                                                 languages: [],
                                                                 tags: [])
        
        let updatedFilterIds = try! metaStorage.update(filters: [modifiedFilter, filterThatShouldNotChange])
        XCTAssertEqual(updatedFilterIds, [filterToModify.filterId])
        
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 4)
        
        let changedFilter = filters.first(where: { $0.filterId == filterToModify.filterId })!
        let freshFilterAfterUpdate = filters.first(where: { $0.filterId == freshFilter.filterId })!
        let unchangedFilterAfterUpdate = filters.first(where: { $0.filterId == unchangedFilter.filterId })
        
        // Note that name and desc won't change as they are fetched from localizations
        XCTAssertNotEqual(changedFilter, filterToModify)
        XCTAssertEqual(changedFilter.displayNumber, 0)
        XCTAssertEqual(changedFilter.version, filterToModify.version! + "dddd")
        
        XCTAssertEqual(freshFilterAfterUpdate, freshFilter)
        XCTAssertEqual(unchangedFilterAfterUpdate, unchangedFilter)
    }
    
    func testUpdateFiltersWithEmptyList() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 4)
        
        let updateFilterIds = try! metaStorage.update(filters: [])
        XCTAssert(updateFilterIds.isEmpty)
        
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 4)
    }
    
    func testDeleteFilters() {
        let groupId = SafariGroup.GroupType.languageSpecific.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forLanguage: "en").filter { $0.filterId == 1 || $0.filterId == 6 || $0.filterId == 7}
        XCTAssertEqual(filters.count, 3)
        
        filters.forEach {
            XCTAssertFalse(try! metaStorage.getTagsForFilter(withId: $0.filterId).isEmpty)
            XCTAssertFalse(try! metaStorage.getLangsForFilter(withId: $0.filterId).isEmpty)
            XCTAssertNotNil(try! metaStorage.getLocalizationForFilter(withId: $0.filterId, forLanguage: "en"))
        }

        let filterIds = filters.map { $0.filterId }
        try! metaStorage.deleteFilters(withIds: filterIds)
        
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forLanguage: "en").filter { $0.filterId == 1 || $0.filterId == 6 || $0.filterId == 7}
        XCTAssertEqual(filters.count, 0)
        
        filterIds.forEach {
            XCTAssert(try! metaStorage.getTagsForFilter(withId: $0).isEmpty)
            XCTAssert(try! metaStorage.getLangsForFilter(withId: $0).isEmpty)
            XCTAssertNil(try! metaStorage.getLocalizationForFilter(withId: $0, forLanguage: "en"))
        }
    }
    
    func testRenameFilter() {
        let groupId = SafariGroup.GroupType.custom.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forLanguage: "en")
        XCTAssert(filters.isEmpty)
        
        let customFilterId = metaStorage.nextCustomFilterId
        let customFilter = ExtendedFiltersMeta.Meta(filterId: customFilterId,
                                                    name: "Custom filter",
                                                    description: "Custom filter description",
                                                    timeAdded: nil,
                                                    homePage: "some.home.page",
                                                    updateFrequency: 1000,
                                                    displayNumber: 0,
                                                    group: ExtendedFiltersMeta.Group(groupId: groupId, groupName: "name", displayNumber: 1),
                                                    filterDownloadPage: "some.download.page",
                                                    trustLevel: .full,
                                                    version: "1.1.1",
                                                    lastUpdateDate: nil,
                                                    languages: [],
                                                    tags: [])
        
        try! metaStorage.add(filter: customFilter, enabled: true)
        
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 1)
        XCTAssertEqual(filters[0].name, "Custom filter")
        XCTAssertEqual(filters[0].description, "Custom filter description")
        
        try! metaStorage.renameFilter(withId: customFilterId, name: "New name")
        
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 1)
        XCTAssertEqual(filters[0].name, "New name")
        XCTAssertEqual(filters[0].description, "Custom filter description")
    }
    
    func testReset() {
        let customGroupId = SafariGroup.GroupType.custom.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: customGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 0)
        
        let customFilterId = metaStorage.nextCustomFilterId
        let customFilter = ExtendedFiltersMeta.Meta(filterId: customFilterId,
                                                    name: "Custom filter",
                                                    description: "Custom filter description",
                                                    timeAdded: nil,
                                                    homePage: "some.home.page",
                                                    updateFrequency: 1000,
                                                    displayNumber: 0,
                                                    group: ExtendedFiltersMeta.Group(groupId: customGroupId, groupName: "name", displayNumber: 1),
                                                    filterDownloadPage: "some.download.page",
                                                    trustLevel: .full,
                                                    version: "1.1.1",
                                                    lastUpdateDate: nil,
                                                    languages: [],
                                                    tags: [])
        try! metaStorage.add(filter: customFilter, enabled: true)
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: customGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 1)
        
        try! metaStorage.reset()
        
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: customGroupId, forLanguage: "en")
        XCTAssertEqual(filters.count, 0)
    }
 }
