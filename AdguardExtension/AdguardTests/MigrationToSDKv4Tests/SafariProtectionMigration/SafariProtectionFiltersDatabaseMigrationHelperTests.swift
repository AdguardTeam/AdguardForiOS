import XCTest

/// Tests for `SafariProtectionFiltersDatabaseMigrationHelper`
class SafariProtectionFiltersDatabaseMigrationHelperTests: XCTestCase {

    let oldAdguardDBFileUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("adguard.db")
    let oldDefaultDBFileUrl = SDKMigrationsDirectoriesManager.rootUrl.appendingPathComponent("default.db")

    var oldDbWrapper: SDKMigrationOldDbWrapper!
    var filtersMigration: SafariProtectionFiltersDatabaseMigrationHelperProtocol!

    override func setUp() {
        SDKMigrationsDirectoriesManager.clear()
        SDKMigrationsDirectoriesManager.createFolders()

        oldDbWrapper = try! SDKMigrationOldDbWrapper(dbUrl: oldAdguardDBFileUrl)

        filtersMigration = try! SafariProtectionFiltersDatabaseMigrationHelper(
            oldAdguardDBFilePath: oldAdguardDBFileUrl.path,
            oldDefaultDBFilePath: oldDefaultDBFileUrl.path
        )
    }

    // MARK: - Test getGroupsStates

    func testGetGroupStatesWithZeroGroupInDB() {
        let result = try! filtersMigration.getGroupsStates()
        XCTAssert(result.isEmpty)
    }

    func testGetGroupStatesWithOneGroupInDB() {
        let testGroup = (groupId: 1, isEnabled: true)
        try! oldDbWrapper.addGroup(
            groupId: testGroup.groupId,
            isEnabled: testGroup.isEnabled
        )

        let result = try! filtersMigration.getGroupsStates()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(testGroup.groupId, result.first?.groupId)
        XCTAssertEqual(testGroup.isEnabled, result.first?.isEnabled)
    }

    func testGetGroupStatesWithMultipleGroupsInDB() {
        let testGroup1 = (groupId: 1, isEnabled: true)
        try! oldDbWrapper.addGroup(
            groupId: testGroup1.groupId,
            isEnabled: testGroup1.isEnabled
        )

        let testGroup2 = (groupId: 2, isEnabled: false)
        try! oldDbWrapper.addGroup(
            groupId: testGroup2.groupId,
            isEnabled: testGroup2.isEnabled
        )

        let testGroup3 = (groupId: 3, isEnabled: true)
        try! oldDbWrapper.addGroup(
            groupId: testGroup3.groupId,
            isEnabled: testGroup3.isEnabled
        )

        let result = try! filtersMigration.getGroupsStates()
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(testGroup1.groupId, result[0].groupId)
        XCTAssertEqual(testGroup1.isEnabled, result[0].isEnabled)
        XCTAssertEqual(testGroup2.groupId, result[1].groupId)
        XCTAssertEqual(testGroup2.isEnabled, result[1].isEnabled)
        XCTAssertEqual(testGroup3.groupId, result[2].groupId)
        XCTAssertEqual(testGroup3.isEnabled, result[2].isEnabled)
    }

    func testGetGroupsWithUserRulesGroup() {
        let testGroup = (groupId: 1, isEnabled: true)
        try! oldDbWrapper.addGroup(
            groupId: testGroup.groupId,
            isEnabled: testGroup.isEnabled
        )

        let userRulesGroupId = 0
        let userRulesGroup = (groupId: userRulesGroupId, isEnabled: true)
        try! oldDbWrapper.addGroup(
            groupId: userRulesGroup.groupId,
            isEnabled: userRulesGroup.isEnabled
        )

        let result = try! filtersMigration.getGroupsStates()
        // User rules group should be ignored
        // Only predefined and custom groups should be returned
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(testGroup.groupId, result.first?.groupId)
        XCTAssertEqual(testGroup.isEnabled, result.first?.isEnabled)
    }

    // MARK: - Test getFiltersStates

    func testGetFiltersStatesWithZeroFiltersInDb() {
        let result = try! filtersMigration.getFiltersStates()
        XCTAssert(result.isEmpty)
    }

    func testGetFiltersStatesWithOneFilterInDb() {
        let testFilter = (filterId: 1, groupId: 2, isEnabled: false)
        try! oldDbWrapper.addFilter(
            filterId: testFilter.filterId,
            groupId: testFilter.groupId,
            isEnabled: testFilter.isEnabled
        )

        let result = try! filtersMigration.getFiltersStates()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(testFilter.filterId, result.first?.filterId)
        XCTAssertEqual(testFilter.groupId, result.first?.groupId)
        XCTAssertEqual(testFilter.isEnabled, result.first?.isEnabled)
    }

    func testGetFiltersStatesWithMultipleFiltersInDb() {
        let testFilter1 = (filterId: 1, groupId: 2, isEnabled: false)
        try! oldDbWrapper.addFilter(
            filterId: testFilter1.filterId,
            groupId: testFilter1.groupId,
            isEnabled: testFilter1.isEnabled
        )

        let testFilter2 = (filterId: 3, groupId: 1, isEnabled: true)
        try! oldDbWrapper.addFilter(
            filterId: testFilter2.filterId,
            groupId: testFilter2.groupId,
            isEnabled: testFilter2.isEnabled
        )

        let testFilter3 = (filterId: 10, groupId: 1, isEnabled: true)
        try! oldDbWrapper.addFilter(
            filterId: testFilter3.filterId,
            groupId: testFilter3.groupId,
            isEnabled: testFilter3.isEnabled
        )

        let result = try! filtersMigration.getFiltersStates()
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(testFilter1.filterId, result[0].filterId)
        XCTAssertEqual(testFilter1.groupId, result[0].groupId)
        XCTAssertEqual(testFilter1.isEnabled, result[0].isEnabled)
        XCTAssertEqual(testFilter2.filterId, result[1].filterId)
        XCTAssertEqual(testFilter2.groupId, result[1].groupId)
        XCTAssertEqual(testFilter2.isEnabled, result[1].isEnabled)
        XCTAssertEqual(testFilter3.filterId, result[2].filterId)
        XCTAssertEqual(testFilter3.groupId, result[2].groupId)
        XCTAssertEqual(testFilter3.isEnabled, result[2].isEnabled)
    }

    func testGetFiltersStatesWithUserFilter() {
        let testFilter = (filterId: 1, groupId: 2, isEnabled: false)
        try! oldDbWrapper.addFilter(
            filterId: testFilter.filterId,
            groupId: testFilter.groupId,
            isEnabled: testFilter.isEnabled
        )

        let userRulesGroupId = 0
        let userRulesFilterId = 0
        let userRulesFilter = (filterId: userRulesFilterId, groupId: userRulesGroupId, isEnabled: false)
        try! oldDbWrapper.addFilter(
            filterId: userRulesFilter.filterId,
            groupId: userRulesFilter.groupId,
            isEnabled: userRulesFilter.isEnabled
        )

        let result = try! filtersMigration.getFiltersStates()
        // User rules filters should be ignored
        // Only predefined and custom filters should be returned
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(testFilter.filterId, result.first?.filterId)
        XCTAssertEqual(testFilter.groupId, result.first?.groupId)
        XCTAssertEqual(testFilter.isEnabled, result.first?.isEnabled)
    }

    // MARK: - Test getUserRules

    func testGetUserRulesWithZeroRules() {
        let result = try! filtersMigration.getUserRules()
        XCTAssert(result.isEmpty)
    }

    func testGetUserRulesWithMultipleRules() {
        let userRulesFilterId = 0
        let rules = [
            (filterId: userRulesFilterId, ruleId: 0, ruleText: "rule1", isEnabled: true, affinity: nil),
            (filterId: userRulesFilterId, ruleId: 1, ruleText: "rule2", isEnabled: false, affinity: nil),
            (filterId: 1, ruleId: 0, ruleText: "rule1", isEnabled: true, affinity: 1),
            (filterId: 1, ruleId: 1, ruleText: "rule2", isEnabled: false, affinity: nil),
            (filterId: 1, ruleId: 2, ruleText: "rule3", isEnabled: true, affinity: 2)
        ]
        try! oldDbWrapper.addFilterRules(rules)

        let result = try! filtersMigration.getUserRules()
        XCTAssertEqual(result.count, 2)

        XCTAssertEqual(rules[0].filterId, result[0].filterId)
        XCTAssertEqual(rules[0].ruleText, result[0].ruleText)
        XCTAssertEqual(rules[0].isEnabled, result[0].isEnabled)
        XCTAssertEqual(rules[0].affinity, result[0].affinity)

        XCTAssertEqual(rules[1].filterId, result[1].filterId)
        XCTAssertEqual(rules[1].ruleText, result[1].ruleText)
        XCTAssertEqual(rules[1].isEnabled, result[1].isEnabled)
        XCTAssertEqual(rules[1].affinity, result[1].affinity)
    }

    // MARK: - Test getCustomFilters

    func testGetCustomFiltersWithZeroCustomFilters() {
        let result = try! filtersMigration.getCustomFilters()
        XCTAssert(result.isEmpty)
    }

    func testGetCustomFiltersWithMultipleFilters() {
        let predefinedFilter = (
            filterId: 1,
            groupId: 2,
            isEnabled: false,
            version: "1.1",
            lastUpdateTime: 10,
            displayNumber: 1,
            name: "some name 1",
            description: "some descr 1",
            homePage: "homepage1",
            subscriptionUrl: "subscriptionUrl1"
        )
        let predefinedRules = [
            (filterId: predefinedFilter.filterId, ruleId: 0, ruleText: "rule1", isEnabled: true, affinity: 0),
            (filterId: predefinedFilter.filterId, ruleId: 1, ruleText: "rule2", isEnabled: true, affinity: 1),
            (filterId: predefinedFilter.filterId, ruleId: 2, ruleText: "rule3", isEnabled: true, affinity: 2)
        ]
        try! oldDbWrapper.addFilter(
            filterId: predefinedFilter.filterId,
            groupId: predefinedFilter.groupId,
            isEnabled: predefinedFilter.isEnabled,
            version: predefinedFilter.version,
            lastUpdateTime: predefinedFilter.lastUpdateTime,
            displayNumber: predefinedFilter.displayNumber,
            name: predefinedFilter.name,
            description: predefinedFilter.description,
            homePage: predefinedFilter.homePage,
            subscriptionUrl: predefinedFilter.subscriptionUrl
        )
        try! oldDbWrapper.addFilterRules(predefinedRules)

        let baseCustomFilterId = 10_000
        let customFilter = (
            filterId: baseCustomFilterId,
            groupId: 101,
            isEnabled: true,
            version: "0",
            lastUpdateTime: 20,
            displayNumber: 2,
            name: "some custom name",
            description: "some custom descr",
            homePage: "homepage1",
            subscriptionUrl: "some custom subscription url"
        )
        let customRules = [
            (filterId: baseCustomFilterId, ruleId: 0, ruleText: "rule1", isEnabled: true, affinity: 0),
            (filterId: baseCustomFilterId, ruleId: 1, ruleText: "rule2", isEnabled: true, affinity: 1)
        ]
        try! oldDbWrapper.addFilter(
            filterId: customFilter.filterId,
            groupId: customFilter.groupId,
            isEnabled: customFilter.isEnabled,
            version: customFilter.version,
            lastUpdateTime: customFilter.lastUpdateTime,
            displayNumber: customFilter.displayNumber,
            name: customFilter.name,
            description: customFilter.description,
            homePage: customFilter.homePage,
            subscriptionUrl: customFilter.subscriptionUrl
        )
        try! oldDbWrapper.addFilterRules(customRules)

        let result = try! filtersMigration.getCustomFilters()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].rules.count, 2)

        XCTAssertEqual(result[0].filterId, customFilter.filterId)
        XCTAssertEqual(result[0].groupId, customFilter.groupId)
        XCTAssertEqual(result[0].isEnabled, customFilter.isEnabled)
        XCTAssertEqual(result[0].version, customFilter.version)
        XCTAssertEqual(result[0].displayNumber, customFilter.displayNumber)
        XCTAssertEqual(result[0].name, customFilter.name)
        XCTAssertEqual(result[0].description, customFilter.description)
        XCTAssertEqual(result[0].homePage, customFilter.homePage)
        XCTAssertEqual(result[0].subscriptionUrl, customFilter.subscriptionUrl)

        XCTAssertEqual(result[0].rules[0].filterId, customRules[0].filterId)
        XCTAssertEqual(result[0].rules[0].ruleText, customRules[0].ruleText)
        XCTAssertEqual(result[0].rules[0].isEnabled, customRules[0].isEnabled)
        XCTAssertEqual(result[0].rules[0].affinity, customRules[0].affinity)

        XCTAssertEqual(result[0].rules[1].filterId, customRules[1].filterId)
        XCTAssertEqual(result[0].rules[1].ruleText, customRules[1].ruleText)
        XCTAssertEqual(result[0].rules[1].isEnabled, customRules[1].isEnabled)
        XCTAssertEqual(result[0].rules[1].affinity, customRules[1].affinity)
    }

    // MARK: - Test removeOldDBFiles

    func testRemoveOldDBFiles() {
        FileManager.default.createFile(atPath: oldDefaultDBFileUrl.path, contents: nil, attributes: [:])
        XCTAssert(FileManager.default.fileExists(atPath: oldDefaultDBFileUrl.path))
        XCTAssert(FileManager.default.fileExists(atPath: oldAdguardDBFileUrl.path))

        try! filtersMigration.removeOldDBFiles()

        XCTAssertFalse(FileManager.default.fileExists(atPath: oldDefaultDBFileUrl.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: oldAdguardDBFileUrl.path))
    }
}
