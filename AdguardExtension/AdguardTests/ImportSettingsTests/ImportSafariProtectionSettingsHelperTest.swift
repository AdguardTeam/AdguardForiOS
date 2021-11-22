//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import XCTest
import SharedAdGuardSDK
import SafariAdGuardSDK

class ImportSafariProtectionSettingsHelperTest: XCTestCase {

    private var helper: ImportSafariProtectionSettingsHelper!
    private var safariProtection: SafariProtectionMock!
    private var parser: CustomFiltersMetaParserMock!

    override func setUp() {
        self.parser = CustomFiltersMetaParserMock()
        self.safariProtection = SafariProtectionMock()
        self.helper = ImportSafariProtectionSettingsHelper(safariProtection: safariProtection, parser: parser)
    }

    private let error = NSError.init(domain: "test_domain", code: 1, userInfo: nil)
    private let rules = ["Rule1", "Rule2", "Rule3"]
    private let presettedRules = [UserRule(ruleText: "PresettedRule1"), UserRule(ruleText: "PresettedRule2"), UserRule(ruleText: "PresettedRule3")]

    func testImportSafariBlocklistRules() {
        XCTAssertEqual(safariProtection.setRulesCalledCount, 0)
        helper.importSafariBlocklistRules(rules, override: false)
        XCTAssertEqual(safariProtection.setRulesCalledCount, 1)

        safariProtection.setRulesCalledCount = 0
        helper.importSafariBlocklistRules([], override: false)
        XCTAssertEqual(safariProtection.setRulesCalledCount, 1)

        safariProtection.rules = presettedRules
        safariProtection.setRulesCalledCount = 0
        helper.importSafariBlocklistRules(rules, override: true)
        XCTAssertEqual(safariProtection.setRulesCalledCount, 1)

        safariProtection.rules = presettedRules
        safariProtection.setRulesCalledCount = 0
        helper.importSafariBlocklistRules([], override: true)
        XCTAssertEqual(safariProtection.setRulesCalledCount, 1)
    }

    // MARK: - Test importSafariFilters

    func testImportSafariFiltersWithSuccess() {
        let filtersToImport = generateFiltersToImport()
        safariProtection.groups = generateSafariGroupsWithFilters()

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters(filtersToImport, override: false)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 3)
        XCTAssertEqual(result.count, 3)
        result.enumerated().forEach {
            XCTAssertEqual($0.element.id, $0.offset)
            XCTAssertEqual($0.element.status, .successful)
        }
        
        XCTAssertEqual(safariProtection.setGroupCalledCount, 3)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 3)
    }

    func testImportSafariFiltersWithSetFilterError() {
        let filtersToImport = generateFiltersToImport()
        safariProtection.groups = generateSafariGroupsWithFilters()
        safariProtection.setFilterError = error

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters(filtersToImport, override: false)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 3)
        XCTAssertEqual(result.count, 3)
        result.enumerated().forEach {
            XCTAssertEqual($0.element.id, $0.offset)
            XCTAssertEqual($0.element.status, .unsuccessful)
        }
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 0)
    }

    func testImportSafariFiltersWithImportEnabledStateFalse() {
        let filtersToImport = generateFiltersToImport(isImportEnabled: false)
        safariProtection.groups = generateSafariGroupsWithFilters()

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters(filtersToImport, override: false)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        XCTAssertEqual(result.count, 3)
        result.enumerated().forEach {
            XCTAssertEqual($0.element.id, $0.offset)
            XCTAssertEqual($0.element.status, .notImported)
        }
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 0)
    }

    func testImportSafariFiltersWithEmptyFilterList() {
        let filtersToImport = generateFiltersToImport()
        safariProtection.groups = []

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters(filtersToImport, override: false)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        XCTAssertEqual(result.count, 3)
        result.enumerated().forEach {
            XCTAssertEqual($0.element.id, $0.offset)
            XCTAssertEqual($0.element.status, .unsuccessful)
        }
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 0)
    }

    func testImportSafariFiltersWithEmptyImports() {
        safariProtection.groups = generateSafariGroupsWithFilters()

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters([], override: false)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        XCTAssertEqual(result.count, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 0)
    }

    func testImportSafariFiltersWithEnablingGroupsError() {
        let filtersToImport = generateFiltersToImport()
        safariProtection.groups = generateSafariGroupsWithFilters()
        safariProtection.setGroupError = error

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters(filtersToImport, override: false)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 3)
        XCTAssertEqual(result.count, 3)
        result.enumerated().forEach {
            XCTAssertEqual($0.element.id, $0.offset)
            XCTAssertEqual($0.element.status, .successful)
        }
        XCTAssertEqual(safariProtection.setGroupCalledCount, 3)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 0)
    }

    func testImportSafariFiltersWithOverrideTrue() {
        let filtersToImport = generateFiltersToImport()
        safariProtection.groups = generateSafariGroupsWithFilters()

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters(filtersToImport, override: true)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 10)
        XCTAssertEqual(result.count, 3)
        result.enumerated().forEach {
            XCTAssertEqual($0.element.id, $0.offset)
            XCTAssertEqual($0.element.status, .successful)
        }

        let filters = safariProtection.groups.flatMap { $0.filters }
        filters.forEach { filter in
            if filtersToImport.contains(where: { $0.id == filter.filterId }) {
                XCTAssert(filter.isEnabled)
            } else {
                XCTAssertFalse(filter.isEnabled)
            }
        }


        XCTAssertEqual(safariProtection.setGroupCalledCount, 10)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 3)
    }

    func testImportSafariFiltersWithOverrideFalse() {
        let filtersToImport = generateFiltersToImport()
        safariProtection.groups = generateSafariGroupsWithFilters(groupsEnabled: true, filtersEnabled: true)

        XCTAssertEqual(safariProtection.setFilterCalledCount, 0)
        let result = helper.importSafariFilters(filtersToImport, override: false)
        XCTAssertEqual(safariProtection.setFilterCalledCount, 3)
        XCTAssertEqual(result.count, 3)
        result.enumerated().forEach {
            XCTAssertEqual($0.element.id, $0.offset)
            XCTAssertEqual($0.element.status, .successful)
        }

        let filters = safariProtection.groups.flatMap { $0.filters }
        filters.forEach { filter in
            XCTAssert(filter.isEnabled)
        }

        XCTAssertEqual(safariProtection.setGroupCalledCount, 3)
        XCTAssertEqual(safariProtection.groups.filter { $0.isEnabled }.count, 8)
    }

    // MARK: - Test importCustomSafariFilters

    func testImportCustomSafariFiltersWithSuccess() {
        let filtersToImport = generateCustomSafariFilters()
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: false)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 3)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 3)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 1)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 1)
    }

    func testImportCustomSafariFiltersWithAddFilterError() {
        let filtersToImport = generateCustomSafariFilters()
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: false)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        safariProtection.addCustomFilterResult = error
        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .unsuccessful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 3)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 3)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 0)
    }

    func testImportCustomSafariFiltersWithParserError() {
        let filtersToImport = generateCustomSafariFilters()
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: false)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        parser.stubbedParseError = error
        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .unsuccessful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 3)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 0)
    }

    func testImportCustomSafariFiltersWithBadUrl() {
        let filtersToImport = generateCustomSafariFilters(url: "#$%^!")
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: false)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .unsuccessful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 0)
    }

    func testImportCustomSafariFiltersWithImportIsNotEnabled() {
        let filtersToImport = generateCustomSafariFilters(isImportEnabled: false)
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: false)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .notImported)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 0)
    }

    func testImportCustomSafariFiltersWithEmptyImportFilters() {
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: false)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters([], override: false) { result in
            XCTAssertEqual(result.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 0)
    }

    func testImportCustomSafariFiltersWithNotEnablingCustomGroupIfItAlreadyEnabled() {
        let filtersToImport = generateCustomSafariFilters()
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: true)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 3)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 3)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 1)
    }

    func testImportCustomSafariFiltersWithOverride() {
        let filtersToImport = generateCustomSafariFilters()
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroupsWithFilters()
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: true) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 3)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 1)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 3)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 1)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 1)
    }

    func testImportCustomSafariFiltersWithOverrideAndEmptyFiltersInStorage() {
        let filtersToImport = generateCustomSafariFilters()
        let expectation = XCTestExpectation()
        safariProtection.groups = generateSafariGroups(groupsEnabled: false)
        parser.stubbedParseResult = CustomFilterMeta(name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: 0)

        XCTAssertEqual(parser.invokedParseCount, 0)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 0)
        helper.importCustomSafariFilters(filtersToImport, override: true) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(parser.invokedParseCount, 3)
        XCTAssertEqual(safariProtection.deleteCustomFilterCalledCount, 0)
        XCTAssertEqual(safariProtection.addCustomFilterCalledCount, 3)
        XCTAssertEqual(safariProtection.setGroupCalledCount, 1)
        XCTAssertEqual(safariProtection.groups.filter { $0.groupType == .custom && $0.isEnabled }.count, 1)
    }

    // MARK: - Private methods

    private func generateCustomSafariFilters(isImportEnabled: Bool = true, url: String = "example.org") -> [ImportSettings.FilterSettings] {
        var result: [ImportSettings.FilterSettings] = []
        for i in 0..<3 {
            result.append(
                ImportSettings.FilterSettings.init(name: "name#\(i)", url: url, isImportEnabled: isImportEnabled, status: .notImported)
            )
        }
        return result
    }

    private func generateFiltersToImport(filterEnabled: Bool = true, isImportEnabled: Bool = true, status: ImportSettings.ImportSettingStatus = .notImported) -> [ImportSettings.DefaultSafariFilterSettings] {
        var result: [ImportSettings.DefaultSafariFilterSettings] = []
        for i in 0..<3 {
            result.append(
                ImportSettings.DefaultSafariFilterSettings(id: i, enable: filterEnabled, isImportEnabled: isImportEnabled, status: status)
            )
        }
        return result
    }

    private func generateSafariGroupsWithFilters(groupsEnabled: Bool = false, filtersEnabled: Bool = false) -> [SafariGroup] {
        var result: [SafariGroup] = []
        let groups = generateSafariGroups(groupsEnabled: groupsEnabled)

        for (i, group) in groups.enumerated() {
            let filter = SafariGroup.Filter(name: "Filter#\(i)", description: "", isEnabled: filtersEnabled, filterId: i, version: nil, lastUpdateDate: nil, group: groups[i], displayNumber: i, languages: [], tags: [], homePage: nil, filterDownloadPage: nil, rulesCount: i)

            result.append(SafariGroup(filters: [filter],
                            isEnabled: group.isEnabled,
                            groupType: group.groupType,
                            groupName: group.groupName,
                            displayNumber: group.displayNumber))
        }

        return result
    }

    private func generateSafariGroups(groupsEnabled: Bool) -> [SafariGroup] {
        var result: [SafariGroup] = []
        let groupType: [SafariGroup.GroupType] = [.ads, .annoyances, .languageSpecific, .other, .privacy, .security, .socialWidgets, .custom]
        for i in 0..<groupType.count {
            result.append(
                SafariGroup(filters: [], isEnabled: groupsEnabled, groupType: groupType[i], groupName: "group#\(i)", displayNumber: i)
            )
        }
        return result
    }
}
