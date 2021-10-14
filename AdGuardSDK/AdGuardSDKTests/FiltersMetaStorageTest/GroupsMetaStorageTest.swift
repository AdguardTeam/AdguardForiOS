import XCTest
import SQLite

class GroupsMetaStorageTest: XCTestCase {

    let rootDirectory = TestsFileManager.rootDirectory
    let workingUrl = TestsFileManager.workingUrl
    let fileManager = FileManager.default

    var productionDbManager: ProductionDatabaseManager!
    var metaStorage: MetaStorage!

    override func setUp() {
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

    func testGetAllLocalizedGroupsWithSuccess() {
        var groups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"])
        XCTAssertEqual(groups.count, 8)
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }

        groups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["fr"])
        XCTAssertEqual(groups.count, 8)
        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
    }

    func testGetAllLocalizedGroupsWithNonExistingLanguage() {
        let groups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["123"])
        XCTAssertEqual(groups.count, 8)

        groups.forEach {
            XCTAssertNotNil($0.isEnabled)
            XCTAssertNotNil($0.displayNumber)
            XCTAssertNotNil($0.groupId)
            XCTAssertNotNil($0.name)
            XCTAssertFalse($0.name.isEmpty)
        }
    }

    func testGetAllLocalizedGroupsWithDefaultLocalization() {
        let enLocalization = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"])
        XCTAssertEqual(enLocalization.count, 8)
        var frLocalization = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["fr"])
        XCTAssertEqual(frLocalization.count, 8)

        enLocalization.forEach { enLocal in
            XCTAssert(frLocalization.contains {
                $0.name != enLocal.name
            })
        }

        //Delete localization for language FR to test default localization from filter_group table data fetch
        try! productionDbManager?.filtersDb.run("DELETE FROM filter_group_localizations WHERE (\"lang\" = \"fr\")")
        let count = try! productionDbManager?.filtersDb.scalar("SELECT count(*) FROM filter_group_localizations WHERE (\"lang\" = \"fr\")") as! Int64
        XCTAssertEqual(count, 0)

        frLocalization = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["fr"])
        enLocalization.forEach { enLocal in
            XCTAssert(frLocalization.contains {
                $0.name == enLocal.name
            })
        }
    }

    func testSetGroup() {
        let adsGroup = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"]).first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        try! metaStorage.setGroup(withId: SafariGroup.GroupType.ads.id, enabled: !adsGroup.isEnabled)
        let updatedAdsGroup = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"]).first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        XCTAssertNotEqual(adsGroup.isEnabled, updatedAdsGroup.isEnabled)
    }

    func testUpdateGroups() {
        var groups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"])
        XCTAssertEqual(groups.count, 8)

        // Modify 2 groups
        let adsGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        let privacyGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.privacy.id })!
        let customGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.custom.id })!

        let newAdsGroup = ExtendedFiltersMeta.Group(groupId: adsGroup.groupId, groupName: adsGroup.name, displayNumber: 100)
        let newPrivacyGroup = ExtendedFiltersMeta.Group(groupId: privacyGroup.groupId, groupName: privacyGroup.name, displayNumber: 101)

        // Update with new groups
        try! metaStorage.update(groups: [newAdsGroup, newPrivacyGroup])

        groups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"])
        XCTAssertEqual(groups.count, 8)

        let updatedAdsGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.ads.id })!
        let updatedPrivacyGroup = groups.first(where: { $0.groupId == SafariGroup.GroupType.privacy.id })!
        let customGroupAfterUpdate = groups.first(where: { $0.groupId == SafariGroup.GroupType.custom.id })!

        XCTAssertEqual(updatedAdsGroup.displayNumber, 100)
        XCTAssertEqual(updatedPrivacyGroup.displayNumber, 101)
        XCTAssertEqual(customGroup, customGroupAfterUpdate)
    }

    func testUpdateAllWithEmptyValue() {
        XCTAssertEqual(try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"]).count, 8)
        try! metaStorage.update(groups: [])
        // Nothing should change
        XCTAssertEqual(try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"]).count, 8)
    }


    func testDefaultLocalization() {
        let enGroups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"])
        let fooGroups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["foo"])


        XCTAssertEqual(enGroups.count, 8)
        XCTAssertEqual(fooGroups.count, 8)

        for i in 0..<fooGroups.count {
            XCTAssertEqual(fooGroups[i].name, enGroups[i].name)
        }
    }

    func testDifferentLanguages() {

        let enGroups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["en"])
        let ptGroups = try! metaStorage.getAllLocalizedGroups(forSuitableLanguages: ["pt_BR"])

        XCTAssertEqual(ptGroups.count, 8)
        XCTAssertEqual(enGroups.count, 8)

        for i in 0..<enGroups.count {
            // Custom group don't have localization
            guard ptGroups[i].name != "Custom" else { continue }
            XCTAssertNotEqual(ptGroups[i].name, enGroups[i].name)
        }
    }

    func testCollectGroupsMetaLocalizationLanguageWithSuccess() {
        let enLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: ["en"])
        let fooLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: ["foo"])
        XCTAssertEqual(enLanguage, fooLanguage)
    }

    func testCollectGroupsMetaLocalizationLanguageWithSuitableList() {
        let enLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: ["en"])
        let frLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: ["Foo", "Bar", "fr"])
        XCTAssertNotEqual(enLanguage, frLanguage)
        XCTAssertEqual(frLanguage, "fr")
    }

    func testCollectGroupsMetaLocalizationLanguageWithEmptySuitableLanguageList() {
        let enLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: ["en"])
        let emptyLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: [])
        XCTAssertEqual(enLanguage, emptyLanguage)
    }

    func testCollectGroupsMetaLocalizationLanguageWithSpecialRegionLanguage() {
        insertIntoDBLocalizationForSpecialRegion(languageName: "aa_BB")
        let aaLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: ["foo", "bar", "aa"])
        XCTAssertEqual(aaLanguage, "aa_BB")
    }

    func testCollectGroupsMetaLocalizationLanguageWithWrongSpecialRegionLanguage() {
        insertIntoDBLocalizationForSpecialRegion(languageName: "aa_BB")
        let aaLanguage = try! metaStorage.collectGroupsMetaLocalizationLanguage(from: ["foo", "bar", "bb"])
        XCTAssertEqual(aaLanguage, "en")
    }

    private func insertIntoDBLocalizationForSpecialRegion(languageName: String) {
        let setters = [FilterGroupLocalizationsTable.groupId <- 123456,
                       FilterGroupLocalizationsTable.lang <- languageName,
                       FilterGroupLocalizationsTable.name <- "\(languageName) name",]

        let query = FilterGroupLocalizationsTable.table.insert(setters)
        try! metaStorage.filtersDb.run(query)
    }
}
