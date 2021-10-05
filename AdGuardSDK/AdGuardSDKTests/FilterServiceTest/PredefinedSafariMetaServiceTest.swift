
import XCTest

class PredefinedSafariMetaServiceTest: XCTestCase {

    var configuration: SafariConfigurationMock!
    var metaStorage: MetaStorageMock!
    var predefinedService: PredefinedSafariMetaServiceProtocol!

    override func setUpWithError() throws {
        configuration = SafariConfigurationMock()
        metaStorage = MetaStorageMock()
        predefinedService = PredefinedSafariMetaService(safariConfiguration: configuration, metaStorage: metaStorage)
    }

    func testSetupPredefinedWithSuccess() {
        let groupsTable = metaStorage.groupsTableMock
        let groups = groupsTable.map { generateFilters(for: $0) }

        configuration.currentLanguage = "en-US"
        try! predefinedService.predefine(with: groups)
        XCTAssertEqual(metaStorage.setGroupCalledCount, 4)
        XCTAssertEqual(metaStorage.setFilterCalledCount, 4)
    }

    func testSetupPredefinedWithEmptyGroups() {
        try! predefinedService.predefine(with: [])
        XCTAssertEqual(metaStorage.setGroupCalledCount, 0)
        XCTAssertEqual(metaStorage.setFilterCalledCount, 0)
    }

    func testSetupPredefinedWithNotSupportedLanguage() {
        let groupsTable = metaStorage.groupsTableMock
        let groups = groupsTable.map { generateFilters(for: $0) }

        configuration.currentLanguage = "foo"
        try! predefinedService.predefine(with: groups)
        XCTAssertEqual(metaStorage.setGroupCalledCount, 4)
        XCTAssertEqual(metaStorage.setFilterCalledCount, 0)
    }

    func testSetupPredefinedWithSetGroupError() {
        let groupsTable = metaStorage.groupsTableMock
        let groups = groupsTable.map { generateFilters(for: $0) }

        metaStorage.setGroupResultError = MetaStorageMockError.setGroupError
        configuration.currentLanguage = "en-US"

        XCTAssertThrowsError(try predefinedService.predefine(with: groups))
        XCTAssertEqual(metaStorage.setGroupCalledCount, 1)
        XCTAssertEqual(metaStorage.setFilterCalledCount, 0)
    }

    func testSetupPredefinedWithSetFilterError() {
        let groupsTable = metaStorage.groupsTableMock
        let groups = groupsTable.map { generateFilters(for: $0) }

        metaStorage.setFilterResultError = MetaStorageMockError.setFilterError
        configuration.currentLanguage = "en-US"

        XCTAssertThrowsError(try predefinedService.predefine(with: groups))
        XCTAssertEqual(metaStorage.setGroupCalledCount, 1)
        XCTAssertEqual(metaStorage.setFilterCalledCount, 1)
    }

    private func generateFilters(for group: FilterGroupsTable) -> SafariGroup {
        let sfGroup = SafariGroup(dbGroup: group, filters: [])

        let recommendedFilter = SafariGroup.Filter.init(name: "name1", description: "description", isEnabled: false, filterId: 1, version: "version", lastUpdateDate: Date(), updateFrequency: 0, group: sfGroup, displayNumber: 1, languages: ["en"], tags: [.init(tagId: 0, tagType: .recommended, tagName: "some")], homePage: "homePage", filterDownloadPage: "subscriptionUrl", rulesCount: 0)

        let notRecommendedFilter = SafariGroup.Filter.init(name: "name1", description: "description", isEnabled: false, filterId: 1, version: "version", lastUpdateDate: Date(), updateFrequency: 0, group: sfGroup, displayNumber: 1, languages: ["en"], tags: [.init(tagId: 0, tagType: .platform, tagName: "some")], homePage: "homePage", filterDownloadPage: "subscriptionUrl", rulesCount: 0)


        let filters: [SafariGroup.Filter]
        switch sfGroup.groupType {
        case .privacy:
            filters = [recommendedFilter, notRecommendedFilter]
        case .ads:
            filters = [recommendedFilter, recommendedFilter, notRecommendedFilter]
        case .annoyances: filters = [recommendedFilter]
        case .custom: filters = []
        case .languageSpecific:
            filters = [recommendedFilter, notRecommendedFilter]
        case .other: filters = []
        case .security: filters = []
        case .socialWidgets: filters = []
        }

        return SafariGroup(dbGroup: group, filters: filters)
    }
}
