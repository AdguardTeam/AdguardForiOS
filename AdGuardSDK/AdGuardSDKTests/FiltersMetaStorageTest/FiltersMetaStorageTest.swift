import XCTest
import SQLite

class FiltersMetaStorageTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl

    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!

    override func setUp() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        TestsFileManager.putDbFileToDirectory(Bundle(for: type(of: self)))
        productionDbManager = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)
        try! productionDbManager?.updateDatabaseIfNeeded()
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
    }

    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }

    func testCustomGroupExists() {
        metaStorage = MetaStorage(productionDbManager: productionDbManager)

        let count = try! productionDbManager.filtersDb.scalar("SELECT count(*) FROM filter_groups WHERE group_id = \(SafariGroup.GroupType.custom.rawValue)") as! Int64
        XCTAssertEqual(count, 1)
    }

    func testGetAllFiltersWithSuccess() {
        // Test with en language
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)
        filters.forEach {
            XCTAssertNotNil($0.filterId)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.version)
            XCTAssertFalse($0.version!.isEmpty)
            XCTAssertNotNil($0.lastUpdateTime)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.description)
            XCTAssertFalse($0.description.isEmpty)
            XCTAssertNotNil($0.homePage)
            XCTAssertFalse($0.homePage!.isEmpty)
            XCTAssertFalse($0.subscriptionUrl!.isEmpty)
        }

        // Test with fr language
        let privacyGroupId = SafariGroup.GroupType.privacy.id
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: privacyGroupId, forSuitableLanguages: ["fr"])
        XCTAssertEqual(filters.count, 5)
        filters.forEach {
            XCTAssertNotNil($0.filterId)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.version)
            XCTAssertFalse($0.version!.isEmpty)
            XCTAssertNotNil($0.lastUpdateTime)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.description)
            XCTAssertFalse($0.description.isEmpty)
            XCTAssertNotNil($0.homePage)
            XCTAssertFalse($0.homePage!.isEmpty)
            XCTAssertFalse($0.subscriptionUrl!.isEmpty)
        }
    }

    func testGetAllFiltersWithNonExistingLang() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        let filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["123"])
        XCTAssertEqual(filters.count, 4)
        filters.forEach {
            XCTAssertNotNil($0.filterId)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.version)
            XCTAssertFalse($0.version!.isEmpty)
            XCTAssertNotNil($0.lastUpdateTime)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertFalse($0.name.isEmpty)
            XCTAssertNotNil($0.description)
            XCTAssertFalse($0.description.isEmpty)
            XCTAssertNotNil($0.homePage)
            XCTAssertFalse($0.homePage!.isEmpty)
            XCTAssertFalse($0.subscriptionUrl!.isEmpty)
        }
    }

    func testSetGroup() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        let filter = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"]).first!

        try! metaStorage.setFilter(withId: filter.filterId, enabled: !filter.isEnabled)

        let updatedFilter = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"]).first(where: { $0.filterId == filter.filterId})!
        XCTAssertNotEqual(filter.isEnabled, updatedFilter.isEnabled)
    }

    func testUpdateFilterWithNewDate() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let filterToModify = filters.first!
        let updateDate = Date(timeIntervalSinceReferenceDate: 123)
        let modifiedFilter = getMeta(filter: filterToModify, updateDate: updateDate)

        let isUpdated = try! metaStorage.update(filter: modifiedFilter)
        XCTAssert(isUpdated)

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let modifiedFilterAfterUpdate = filters.first(where: { filterToModify.filterId == $0.filterId })!
        XCTAssertEqual(modifiedFilterAfterUpdate.displayNumber, 0)
        XCTAssertEqual(modifiedFilterAfterUpdate.version, "2.2.2.2")
        XCTAssertEqual(modifiedFilterAfterUpdate.lastUpdateTime, updateDate)
    }

    func testUpdateFilterWithSameDate() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let filterToModify = filters.first!
        let modifiedFilter = getMeta(filter: filterToModify, updateDate: filterToModify.lastUpdateTime)

        let isUpdated = try! metaStorage.update(filter: modifiedFilter)
        XCTAssertFalse(isUpdated)

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let modifiedFilterAfterUpdate = filters.first(where: { filterToModify.filterId == $0.filterId })!
        XCTAssertEqual(modifiedFilterAfterUpdate.displayNumber, filterToModify.displayNumber)
        XCTAssertEqual(modifiedFilterAfterUpdate.version, filterToModify.version)
        XCTAssertEqual(modifiedFilterAfterUpdate.lastUpdateTime, filterToModify.lastUpdateTime)
    }

    func testUpdateFilterWithNilDate() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let filterToModify = filters.first!
        let modifiedFilter = getMeta(filter: filterToModify, updateDate: nil)

        let isUpdated = try! metaStorage.update(filter: modifiedFilter)
        XCTAssert(isUpdated)

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let modifiedFilterAfterUpdate = filters.first(where: { filterToModify.filterId == $0.filterId })!
        XCTAssertEqual(modifiedFilterAfterUpdate.displayNumber, 0)
        XCTAssertEqual(modifiedFilterAfterUpdate.version, "2.2.2.2")
        XCTAssertEqual(modifiedFilterAfterUpdate.lastUpdateTime, nil)
    }

    func testUpdateFilterWithNilDateInDBForFilter() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let filterToModify = filters.first!
        let _ = try! productionDbManager.filtersDb.scalar("UPDATE filters SET last_update_time = NULL WHERE filter_id = \(filterToModify.filterId)")
        let modifiedFilter = getMeta(filter: filterToModify, updateDate: filterToModify.lastUpdateTime)

        let isUpdated = try! metaStorage.update(filter: modifiedFilter)
        XCTAssert(isUpdated)

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let modifiedFilterAfterUpdate = filters.first(where: { filterToModify.filterId == $0.filterId })!
        XCTAssertEqual(modifiedFilterAfterUpdate.displayNumber, 0)
        XCTAssertEqual(modifiedFilterAfterUpdate.version, "2.2.2.2")
        XCTAssertEqual(modifiedFilterAfterUpdate.lastUpdateTime, filterToModify.lastUpdateTime)

    }

    func testUpdateFilters() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let filterToModify = filters[1]
        let filterToModify2 = filters[2]
        let unchangedFilter = filters[3]

        let date = Date(timeIntervalSinceReferenceDate: 123)
        let modifiedFilter = ExtendedFiltersMeta.Meta(filterId: filterToModify.filterId,
                                                      name: "newName",
                                                      description: "newDescription",
                                                      homePage: filterToModify.homePage,
                                                      displayNumber: 0,
                                                      group: ExtendedFiltersMeta.Group(groupId: adsGroupId, groupName: "name", displayNumber: 1),
                                                      filterDownloadPage: filterToModify.subscriptionUrl,
                                                      trustLevel: .full,
                                                      version: filterToModify.version! + "dddd",
                                                      lastUpdateDate: date,
                                                      languages: [],
                                                      tags: [],
                                                      rulesCount: 0)

        let modifiedFilter2 = ExtendedFiltersMeta.Meta(filterId: filterToModify2.filterId,
                                                                 name: "newName112",
                                                                 description: "newDescription323",
                                                                 homePage: filterToModify2.homePage,
                                                                 displayNumber: 210,
                                                                 group: ExtendedFiltersMeta.Group(groupId: adsGroupId, groupName: "name", displayNumber: 1),
                                                                 filterDownloadPage: filterToModify2.subscriptionUrl,
                                                                 trustLevel: .full,
                                                                 version: filterToModify2.version!,
                                                                 lastUpdateDate: date,
                                                                 languages: [],
                                                                 tags: [],
                                                                 rulesCount: 0)

        let updatedFilterIds = try! metaStorage.update(filters: [modifiedFilter, modifiedFilter2])
        XCTAssertEqual(updatedFilterIds, [filterToModify.filterId, filterToModify2.filterId])

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let changedFilter = filters.first(where: { $0.filterId == filterToModify.filterId })!
        let changedFilter2 = filters.first(where: { $0.filterId == filterToModify2.filterId })!
        let unchangedFilterAfterUpdate = filters.first(where: { $0.filterId == unchangedFilter.filterId })

        // Note that name and desc won't change as they are fetched from localizations
        XCTAssertNotEqual(changedFilter, filterToModify)
        XCTAssertNotEqual(changedFilter2, filterToModify2)
        XCTAssertEqual(changedFilter.displayNumber, 0)
        XCTAssertEqual(changedFilter2.displayNumber, 210)
        XCTAssertEqual(changedFilter.version, filterToModify.version! + "dddd")
        XCTAssertEqual(changedFilter2.version, filterToModify2.version!)
        XCTAssertEqual(unchangedFilterAfterUpdate, unchangedFilter)
    }

    func testUpdateFiltersWithEmptyList() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)

        let updateFilterIds = try! metaStorage.update(filters: [])
        XCTAssert(updateFilterIds.isEmpty)

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 4)
    }

    func testDeleteFilters() {
        let groupId = SafariGroup.GroupType.languageSpecific.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forSuitableLanguages: ["en"]).filter { $0.filterId == 1 || $0.filterId == 6 || $0.filterId == 7}
        XCTAssertEqual(filters.count, 3)

        filters.forEach {
            XCTAssertFalse(try! metaStorage.getTagsForFilter(withId: $0.filterId).isEmpty)
            XCTAssertFalse(try! metaStorage.getLangsForFilter(withId: $0.filterId).isEmpty)
            XCTAssertNotNil(try! metaStorage.getLocalizationForFilter(withId: $0.filterId, forLanguage: "en"))
        }

        let filterIds = filters.map { $0.filterId }
        try! metaStorage.deleteFilters(withIds: filterIds)

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forSuitableLanguages: ["en"]).filter { $0.filterId == 1 || $0.filterId == 6 || $0.filterId == 7}
        XCTAssertEqual(filters.count, 0)

        filterIds.forEach {
            XCTAssert(try! metaStorage.getTagsForFilter(withId: $0).isEmpty)
            XCTAssert(try! metaStorage.getLangsForFilter(withId: $0).isEmpty)
            XCTAssertNil(try! metaStorage.getLocalizationForFilter(withId: $0, forLanguage: "en"))
        }
    }

    func testRenameFilter() {
        let groupId = SafariGroup.GroupType.custom.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forSuitableLanguages: ["en"])
        XCTAssert(filters.isEmpty)

        let customFilterId = metaStorage.nextCustomFilterId
        let customFilter = ExtendedFiltersMeta.Meta(filterId: customFilterId,
                                                    name: "Custom filter",
                                                    description: "Custom filter description",
                                                    homePage: "some.home.page",
                                                    displayNumber: 0,
                                                    group: ExtendedFiltersMeta.Group(groupId: groupId, groupName: "name", displayNumber: 1),
                                                    filterDownloadPage: "some.download.page",
                                                    trustLevel: .full,
                                                    version: "1.1.1",
                                                    lastUpdateDate: nil,
                                                    languages: [],
                                                    tags: [],
                                                    rulesCount: 0)

        try! metaStorage.add(filter: customFilter, enabled: true)

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 1)
        XCTAssertEqual(filters[0].name, "Custom filter")
        XCTAssertEqual(filters[0].description, "Custom filter description")

        try! metaStorage.renameFilter(withId: customFilterId, name: "New name")

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: groupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 1)
        XCTAssertEqual(filters[0].name, "New name")
        XCTAssertEqual(filters[0].description, "Custom filter description")
    }

    func testReset() {
        let customGroupId = SafariGroup.GroupType.custom.id
        var filters = try! metaStorage.getLocalizedFiltersForGroup(withId: customGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 0)

        let customFilterId = metaStorage.nextCustomFilterId
        let customFilter = ExtendedFiltersMeta.Meta(filterId: customFilterId,
                                                    name: "Custom filter",
                                                    description: "Custom filter description",
                                                    homePage: "some.home.page",
                                                    displayNumber: 0,
                                                    group: ExtendedFiltersMeta.Group(groupId: customGroupId, groupName: "name", displayNumber: 1),
                                                    filterDownloadPage: "some.download.page",
                                                    trustLevel: .full,
                                                    version: "1.1.1",
                                                    lastUpdateDate: nil,
                                                    languages: [],
                                                    tags: [],
                                                    rulesCount: 0)
        try! metaStorage.add(filter: customFilter, enabled: true)
        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: customGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 1)

        try! metaStorage.reset()

        filters = try! metaStorage.getLocalizedFiltersForGroup(withId: customGroupId, forSuitableLanguages: ["en"])
        XCTAssertEqual(filters.count, 0)
    }

    func testDefaultLocalization() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        let fooFilters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["foo"])
        let enFilters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])

        XCTAssertEqual(fooFilters.count, 4)
        XCTAssertEqual(enFilters.count, 4)

        for i in 0..<fooFilters.count {
            XCTAssertEqual(fooFilters[i].name, enFilters[i].name)
            XCTAssertEqual(fooFilters[i].description, enFilters[i].description)
        }
    }

    func testDifferentLanguages() {
        let adsGroupId = SafariGroup.GroupType.ads.id
        let ptFilters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["pt_BR"])
        let enFilters = try! metaStorage.getLocalizedFiltersForGroup(withId: adsGroupId, forSuitableLanguages: ["en"])

        XCTAssertEqual(ptFilters.count, 4)
        XCTAssertEqual(enFilters.count, 4)

        for i in 0..<ptFilters.count {
            XCTAssertNotEqual(ptFilters[i].description, enFilters[i].description)
        }
    }

    func testCollectFiltersMetaLocalizationLanguageWithSuccess() {
        let enLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: ["en"])
        let fooLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: ["foo"])
        XCTAssertEqual(enLanguage, fooLanguage)
    }

    func testCollectFiltersMetaLocalizationLanguageWithSuitableList() {
        let enLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: ["en"])
        let frLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: ["Foo", "Bar", "fr"])
        XCTAssertNotEqual(enLanguage, frLanguage)
        XCTAssertEqual(frLanguage, "fr")
    }

    func testCollectFiltersMetaLocalizationLanguageWithEmptySuitableLanguageList() {
        let enLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: ["en"])
        let emptyLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: [])
        XCTAssertEqual(enLanguage, emptyLanguage)
    }

    func testCollectFiltersMetaLocalizationLanguageWithSpecialRegionLanguage() {
        insertIntoDBLocalizationForSpecialRegion(languageName: "aa_BB")
        let aaLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: ["foo", "bar", "aa"])
        XCTAssertEqual(aaLanguage, "aa_BB")
    }

    func testCollectFiltersMetaLocalizationLanguageWithWrongSpecialRegionLanguage() {
        insertIntoDBLocalizationForSpecialRegion(languageName: "aa_BB")
        let aaLanguage = try! metaStorage.collectFiltersMetaLocalizationLanguage(from: ["foo", "bar", "bb"])
        XCTAssertEqual(aaLanguage, "en")
    }

    private func insertIntoDBLocalizationForSpecialRegion(languageName: String) {
        let setters = [FilterLocalizationsTable.filterId <- 123456,
                       FilterLocalizationsTable.lang <- languageName,
                       FilterLocalizationsTable.name <- "\(languageName) name",
                       FilterLocalizationsTable.description <- "\(languageName) description"]

        let query = FilterLocalizationsTable.table.insert(setters)
        try! metaStorage.filtersDb.run(query)
    }

    private func getMeta(filter: FiltersTable, updateDate: Date?, groupId: Int = SafariGroup.GroupType.ads.id) -> ExtendedFiltersMeta.Meta {
        return ExtendedFiltersMeta.Meta(filterId: filter.filterId,
                                                      name: "newName",
                                                      description: "newDescription",
                                                      homePage: filter.homePage,
                                                      displayNumber: 0,
                                                      group: ExtendedFiltersMeta.Group(groupId: groupId, groupName: "name", displayNumber: 1),
                                                      filterDownloadPage: filter.subscriptionUrl,
                                                      trustLevel: .full,
                                                      version: "2.2.2.2",
                                                      lastUpdateDate: updateDate,
                                                      languages: [],
                                                      tags: [],
                                                      rulesCount: 0)
    }
 }
