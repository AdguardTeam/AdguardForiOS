import XCTest

class FiltersMetaStorage_FiltersTest: XCTestCase {
    
    let rootDirectory = FiltersMetaStorageTestProcessor.rootDirectory
    let workingUrl = FiltersMetaStorageTestProcessor.workingUrl
    let fileManager = FileManager.default
    
    var productionDbManager: ProductionDatabaseManager?
    var filtersStorage: FiltersMetaStorage?
    
    var testFilters = [
        ExtendedFiltersMeta.Meta(filterId: 10001,
                                 name: "foo",
                                 description: "bar",
                                 timeAdded: Date(),
                                 homePage: "some",
                                 updateFrequency: 1,
                                 displayNumber: 2,
                                 group: ExtendedFiltersMeta.Group(groupId: 123123123, groupName: "foo", displayNumber: 0),
                                 filterDownloadPage: "some",
                                 trustLevel: .full,
                                 version: "112",
                                 lastUpdateDate: Date(),
                                 languages: [],
                                 tags: []),
        ExtendedFiltersMeta.Meta(filterId: 10002,
                                 name: "foo",
                                 description: "bar",
                                 timeAdded: Date(),
                                 homePage: "some",
                                 updateFrequency: 1,
                                 displayNumber: 2,
                                 group: ExtendedFiltersMeta.Group(groupId: 123123123, groupName: "foo", displayNumber: 0),
                                 filterDownloadPage: "some",
                                 trustLevel: .full,
                                 version: "112",
                                 lastUpdateDate: Date(),
                                 languages: [],
                                 tags: []),
        ExtendedFiltersMeta.Meta(filterId: 10003,
                                 name: "foo",
                                 description: "bar",
                                 timeAdded: Date(),
                                 homePage: "some",
                                 updateFrequency: 1,
                                 displayNumber: 2,
                                 group: ExtendedFiltersMeta.Group(groupId: 123123123, groupName: "foo", displayNumber: 0),
                                 filterDownloadPage: "some",
                                 trustLevel: .full,
                                 version: "112",
                                 lastUpdateDate: Date(),
                                 languages: [],
                                 tags: [])]
    
    override func setUpWithError() throws {
        productionDbManager = try ProductionDatabaseManager(dbContainerUrl: workingUrl)
        try productionDbManager?.updateDatabaseIfNeeded()
        filtersStorage = FiltersMetaStorage(productionDbManager: productionDbManager!)
    }
    
    override class func setUp() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    override class func tearDown() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }
    
    override func tearDown() {
        FiltersMetaStorageTestProcessor.deleteTestFolder()
        FiltersMetaStorageTestProcessor.clearRootDirectory()
    }

    func testGetAllFiltersWithSuccess() {
        let filtersStorage = filtersStorage!
        do {
            var filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en")
            XCTAssertFalse(filters.isEmpty)
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
            
            filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "fr")
            XCTAssertFalse(filters.isEmpty)
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
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGetAllFiltersWithNonExistingLang() {
        let filtersStorage = filtersStorage!
        do {
            let filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "123")
            XCTAssertFalse(filters.isEmpty)
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
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSetGroup() {
        let filtersStorage = filtersStorage!
        do {
            let filter = (try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").first)!
            let filterId = filter.filterId
            let oldValue = filter.isEnabled
            try filtersStorage.setFilter(withId: filterId, enabled: !filter.isEnabled)
            guard let filter = try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").first(where: { $0.filterId == filterId}) else { return XCTFail() }
            XCTAssertNotEqual(oldValue, filter.isEnabled)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testUpdateAll() {
        let filtersStorage = filtersStorage!
        do {
            
            var filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en")
            XCTAssertFalse(filters.isEmpty)
            XCTAssert(filters.count > 1)

            
            let modifiedFilters = filters.map {
                ExtendedFiltersMeta.Meta(filterId: $0.filterId,
                                         name: "foo",
                                         description: "bar",
                                         timeAdded: nil,
                                         homePage: "some",
                                         updateFrequency: 1,
                                         displayNumber: 2,
                                         group: ExtendedFiltersMeta.Group(groupId: $0.groupId, groupName: "123", displayNumber: 0),
                                         filterDownloadPage: "some",
                                         trustLevel: .full,
                                         version: "123",
                                         lastUpdateDate: nil,
                                         languages: [],
                                         tags: [])
            }
            
            try filtersStorage.updateAll(filters: modifiedFilters)
            
            filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en")
            modifiedFilters.forEach{ modifiedFilter in
                XCTAssert(filters.contains(where: {
                    $0.filterId == modifiedFilter.filterId &&
                        $0.homePage == modifiedFilter.homePage &&
                        $0.displayNumber == modifiedFilter.displayNumber &&
                        $0.groupId == modifiedFilter.group.groupId &&
                        $0.subscriptionUrl == modifiedFilter.filterDownloadPage! &&
                        $0.version == modifiedFilter.version
                }))
            }
            
            
            let modifiedFilter = modifiedFilters.first!
            try filtersStorage.updateAll(filters: [ExtendedFiltersMeta.Meta(filterId: modifiedFilter.filterId,
                                                                            name: "foo",
                                                                            description: "bar",
                                                                            timeAdded: nil,
                                                                            homePage: "some",
                                                                            updateFrequency: 1,
                                                                            displayNumber: 2,
                                                                            group: ExtendedFiltersMeta.Group(groupId: modifiedFilter.group.groupId, groupName: "123", displayNumber: 0),
                                                                            filterDownloadPage: "some",
                                                                            trustLevel: .full,
                                                                            version: "123",
                                                                            lastUpdateDate: nil,
                                                                            languages: [],
                                                                            tags: [])]
            )
            filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en")

            XCTAssertEqual(filters.count, 1)
            XCTAssert(filters.contains(where: {
                $0.filterId == modifiedFilter.filterId &&
                    $0.homePage == "some" &&
                    $0.displayNumber == 2 &&
                    $0.groupId == modifiedFilter.group.groupId &&
                    $0.subscriptionUrl == "some" &&
                    $0.version == "123"
            }))
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAllWithInserrtionNewFilters() {
        let filtersStorage = filtersStorage!
        do {
            XCTAssert(try filtersStorage.getLocalizedFiltersForGroup(withId: 123123123, forLanguage: "en").isEmpty)
            try filtersStorage.updateAll(filters: testFilters)
            XCTAssertFalse(try filtersStorage.getLocalizedFiltersForGroup(withId: 123123123, forLanguage: "en").isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testUpdateAllWithEmptyValue() {
        let filtersStorage = filtersStorage!
        do {
            XCTAssertFalse(try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").isEmpty)
            try filtersStorage.updateAll(filters: [])
            XCTAssert(try filtersStorage.getLocalizedFiltersForGroup(withId: 1, forLanguage: "en").isEmpty)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testDeleteFilters() {
        let filtersStorage = filtersStorage!
        do {
            var filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 7, forLanguage: "en").filter { $0.filterId == 1 || $0.filterId == 6 || $0.filterId == 7}
            
            XCTAssertEqual(filters.count, 3)
            
            var fetchedFilters: [FiltersTable] = []
            for index in 0..<filters.count {
                fetchedFilters.append(filters[index])
            }

            try fetchedFilters.forEach {
                XCTAssertFalse(try filtersStorage.getTagsForFilter(withId: $0.filterId).isEmpty)
                XCTAssertFalse(try filtersStorage.getLangsForFilter(withId: $0.filterId).isEmpty)
                print($0.filterId)
                XCTAssertNotNil(try filtersStorage.getLocalizationForFilter(withId: $0.filterId, forLanguage: "en"))
            }

            try filtersStorage.deleteFilters(withIds: fetchedFilters.map { $0.filterId })
            
            filters = try filtersStorage.getLocalizedFiltersForGroup(withId: 7, forLanguage: "en").filter { $0.filterId == 1 || $0.filterId == 6 || $0.filterId == 7}
            fetchedFilters = []
            for index in 0..<filters.count {
                fetchedFilters.append(filters[index])
            }
            
            try fetchedFilters.forEach {
                XCTAssert(try filtersStorage.getTagsForFilter(withId: $0.filterId).isEmpty)
                XCTAssert(try filtersStorage.getLangsForFilter(withId: $0.filterId).isEmpty)
                XCTAssertNil(try filtersStorage.getLocalizationForFilter(withId: $0.filterId, forLanguage: "en"))
            }
            
            XCTAssertEqual(filters.count, 0)

        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testRenameFilter() {
        let filtersStorage = filtersStorage!
        do {
            var count = try productionDbManager?.filtersDb.scalar("SELECT count(*) FROM filters WHERE (\"filter_id\" = \"123123\")") as! Int64
            XCTAssertEqual(count, 0)

            try productionDbManager?.filtersDb.run("INSERT INTO filters (filter_id, group_id, name, version, name, description, homepage, subscriptionUrl, expires) VALUES (123123, 101, \"Bar\", \"2.2.2\", \"name\", \"description\", \"homepage\", \"subscriptionUrl\", 1)")
            
            count = try productionDbManager?.filtersDb.scalar("SELECT count(*) FROM filters WHERE (\"filter_id\" = \"123123\")") as! Int64
            XCTAssertEqual(count, 1)
            
            var customFilters = try filtersStorage.getLocalizedFiltersForGroup(withId: 101, forLanguage: "en")
            XCTAssertFalse(customFilters.isEmpty)
            XCTAssertNotNil(customFilters.first(where: { $0.filterId == 123123 && $0.name == "Bar" }))
            
            try filtersStorage.renameFilter(withId: 123123, name: "Foo")
            
            customFilters = try filtersStorage.getLocalizedFiltersForGroup(withId: 101, forLanguage: "en")
            XCTAssertFalse(customFilters.isEmpty)
            XCTAssertNotNil(customFilters.first(where: { $0.filterId == 123123 && $0.name == "Foo" }))
        } catch {
            XCTFail("\(error)")
        }
    }
 }
