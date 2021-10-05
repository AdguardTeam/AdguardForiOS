
import XCTest

class PredefinedSafariMetaStorageTest: XCTestCase {
    let workingUrl = TestsFileManager.workingUrl
    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorageProtocol!

    override func setUpWithError() throws {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
        TestsFileManager.putDbFileToDirectory(Bundle(for: type(of: self)))
        productionDbManager = try! ProductionDatabaseManager(dbContainerUrl: workingUrl)
        metaStorage = MetaStorage(productionDbManager: productionDbManager!)
    }

    override func tearDown() {
        TestsFileManager.deleteTestFolder()
        TestsFileManager.clearRootDirectory()
    }

    func testSetupPredefinedWithSuccess() {
        let sfGroups = collectSafariGroups()
        let oldGroups = filter(groups: sfGroups)
        try! metaStorage.setupPredefinedMeta(with: sfGroups, currentLanguage: "en-US")
        let newGroups = filter(groups: collectSafariGroups())


        oldGroups.enumerated().forEach { iterator in
            XCTAssertNotEqual(newGroups[iterator.offset].isEnabled, iterator.element.isEnabled)
            iterator.element.filters.enumerated().forEach { filterIterator in

                let oldFilter = filterIterator.element
                let newFilter = newGroups[iterator.offset].filters[filterIterator.offset]
                XCTAssertNotEqual(oldFilter.isEnabled, newFilter.isEnabled)
            }
        }
    }

    func testSetupPredefinedWithBadLanguage() {
        let sfGroups = collectSafariGroups()
        let oldGroups = filter(groups: sfGroups)
        try! metaStorage.setupPredefinedMeta(with: sfGroups, currentLanguage: "foo")
        let newGroups = filter(groups: collectSafariGroups())


        oldGroups.enumerated().forEach { iterator in

            if iterator.element.groupType == .custom && newGroups[iterator.offset].groupType == .custom {
                XCTAssertNotEqual(newGroups[iterator.offset].isEnabled, iterator.element.isEnabled)
            } else {
                XCTAssertEqual(newGroups[iterator.offset].isEnabled, iterator.element.isEnabled)
            }
            iterator.element.filters.enumerated().forEach { filterIterator in
                let oldFilter = filterIterator.element
                let newFilter = newGroups[iterator.offset].filters[filterIterator.offset]
                XCTAssertEqual(oldFilter.isEnabled, newFilter.isEnabled)
            }
        }
    }

    func testSetupPredefinedWithEmptyGroupsArray() {
        let sfGroups = collectSafariGroups()
        let oldGroups = filter(groups: sfGroups)
        try! metaStorage.setupPredefinedMeta(with: [], currentLanguage: "en-US")
        let newGroups = filter(groups: collectSafariGroups())


        oldGroups.enumerated().forEach { iterator in

            if iterator.element.groupType == .custom && newGroups[iterator.offset].groupType == .custom {
            XCTAssertEqual(newGroups[iterator.offset].isEnabled, iterator.element.isEnabled)
            XCTAssert(newGroups[iterator.offset].filters.isEmpty)
            }

            iterator.element.filters.enumerated().forEach { filterIterator in
                let oldFilter = filterIterator.element
                let newFilter = newGroups[iterator.offset].filters[filterIterator.offset]
                XCTAssertEqual(oldFilter.isEnabled, newFilter.isEnabled)
            }
        }
    }

    private func filter(groups: [SafariGroup]) -> [SafariGroup] {
        let predefinedGroups: [SafariGroup.GroupType] = [.ads, .privacy, .languageSpecific, .custom]
        let filteredGroups = groups.filter { predefinedGroups.contains($0.groupType) }

        return filteredGroups.map { group in
            let filters = group.filters.filter { filter in
                filter.tags.contains(where: { $0.tagType == .recommended })
            }

            return SafariGroup(filters: filters, isEnabled: group.isEnabled, groupType: group.groupType, groupName: group.groupName, displayNumber: group.displayNumber)
        }
    }

    private func collectSafariGroups() -> [SafariGroup] {
        let groups = try! metaStorage.getAllLocalizedGroups(forLanguage: "en")
        return groups.map { group in
            let sfGroup = SafariGroup(dbGroup: group, filters: [])
            let filters = try! metaStorage.getLocalizedFiltersForGroup(withId: group.groupId, forLanguage: "en")

            let sfFilters: [SafariGroup.Filter] = filters.map { dbFilter in
                let tags = try! metaStorage.getTagsForFilter(withId: dbFilter.filterId)

                return SafariGroup.Filter(dbFilter: dbFilter, group: sfGroup, rulesCount: 0, languages: ["en"], tags: tags, filterDownloadPage: "")
            }

            return SafariGroup(dbGroup: group, filters: sfFilters)
        }

    }
}
