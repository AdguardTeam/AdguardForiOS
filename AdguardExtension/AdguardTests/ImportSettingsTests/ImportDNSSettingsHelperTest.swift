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

import DnsAdGuardSDK
import XCTest

class ImportDNSSettingsHelperTest: XCTestCase {

    var helper: ImportDNSSettingsHelper!
    var dnsProviderManager: InAppDnsProvidersManagerMock!
    var dnsProtection: DnsProtectionMock!

    override func setUp() {
        self.dnsProviderManager = InAppDnsProvidersManagerMock()
        self.dnsProtection = DnsProtectionMock()
        self.helper = ImportDNSSettingsHelper(dnsProvidersManager: dnsProviderManager,
                                              dnsProtection: dnsProtection)
    }

    private let rules = ["Rule1", "Rule2", "Rule3"]
    private let providersIds = [0, 1, 2, 3, 4, 5, 6, 7]
    private let error = NSError.init(domain: "test_domain", code: 1, userInfo: nil)

    // MARK: - Test ImportDnsBlocklistRules

    func testImportDnsBlocklistRules() {
        XCTAssertEqual(dnsProtection.removeAllRulesCalledCount, 0)
        XCTAssertEqual(dnsProtection.setRulesCalledCount, 0)

        helper.importDnsBlocklistRules(rules, override: false)
        XCTAssertEqual(dnsProtection.removeAllRulesCalledCount, 0)
        XCTAssertEqual(dnsProtection.setRulesCalledCount, 1)

        dnsProtection.removeAllRulesCalledCount = 0
        dnsProtection.setRulesCalledCount = 0
        helper.importDnsBlocklistRules(rules, override: true)
        XCTAssertEqual(dnsProtection.removeAllRulesCalledCount, 1)
        XCTAssertEqual(dnsProtection.setRulesCalledCount, 1)

        dnsProtection.removeAllRulesCalledCount = 0
        dnsProtection.setRulesCalledCount = 0
        helper.importDnsBlocklistRules([], override: false)
        XCTAssertEqual(dnsProtection.removeAllRulesCalledCount, 0)
        XCTAssertEqual(dnsProtection.setRulesCalledCount, 1)

        dnsProtection.removeAllRulesCalledCount = 0
        dnsProtection.setRulesCalledCount = 0
        helper.importDnsBlocklistRules([], override: true)
        XCTAssertEqual(dnsProtection.removeAllRulesCalledCount, 1)
        XCTAssertEqual(dnsProtection.setRulesCalledCount, 1)
    }

    // MARK: - Test importDnsServer

    func testImportDnsServer() {
        let servers = generateDnsServers(providersIds: providersIds)
        let providers = generateDnsProviders(dnsServers: servers)
        dnsProviderManager.stubbedAllProviders = providers
        dnsProviderManager.stubbedActiveDnsServer = servers.last!

        XCTAssertEqual(dnsProviderManager.invokedSelectProviderCount, 0)
        XCTAssert(helper.importDnsServer(serverId: servers.first!.id))
        XCTAssertEqual(dnsProviderManager.invokedSelectProviderCount, 1)

        dnsProviderManager.invokedSelectProviderCount = 0
        dnsProviderManager.stubbedSelectProviderError = error
        XCTAssertFalse(helper.importDnsServer(serverId: servers.first!.id))
        XCTAssertEqual(dnsProviderManager.invokedSelectProviderCount, 1)

        dnsProviderManager.invokedSelectProviderCount = 0
        dnsProviderManager.stubbedSelectProviderError = nil
        XCTAssertFalse(helper.importDnsServer(serverId: 1234567))
        XCTAssertEqual(dnsProviderManager.invokedSelectProviderCount, 0)

        dnsProviderManager.invokedSelectProviderCount = 0
        dnsProviderManager.stubbedActiveDnsServer = servers.first!
        XCTAssert(helper.importDnsServer(serverId: servers.first!.id))
        XCTAssertEqual(dnsProviderManager.invokedSelectProviderCount, 0)
    }

    // MARK: - Test importFilters

    func testImportFilters() {
        let settings = generateImportSettings()
        let expectation = XCTestExpectation()
        dnsProtection.filters = generateDnsFilters()
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
        helper.importDnsFilters(settings, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach { XCTAssertEqual($0.status, .successful) }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 3)
        XCTAssertEqual(dnsProtection.filters.count, 6)
    }

    func testImportFiltersWithEmptyImport() {
        let expectation = XCTestExpectation()
        dnsProtection.filters = generateDnsFilters()
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
        dnsProtection.filters = generateDnsFilters()
        helper.importDnsFilters([], override: false) { result in
            XCTAssertEqual(result.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
    }

    func testImportFiltersWithAddFilterError() {
        let settings = generateImportSettings()
        let expectation = XCTestExpectation()
        dnsProtection.filters = generateDnsFilters()
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
        dnsProtection.addFilterResult = error
        helper.importDnsFilters(settings, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach { XCTAssertEqual($0.status, .unsuccessful) }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 3)
        XCTAssertEqual(dnsProtection.filters.count, 3)
    }

    func testImportFiltersWithNonValidUrl() {
        let settings = generateImportSettings(url: "#$%^")
        let expectation = XCTestExpectation()
        dnsProtection.filters = generateDnsFilters()
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
        helper.importDnsFilters(settings, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach { XCTAssertEqual($0.status, .unsuccessful) }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
    }

    func testImportFiltersWithDisabledImportStatus() {
        let settings = generateImportSettings(isImportEnabled: false)
        let expectation = XCTestExpectation()
        dnsProtection.filters = generateDnsFilters()
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
        helper.importDnsFilters(settings, override: false) { result in
            XCTAssertEqual(result.count, 3)
            result.forEach { XCTAssertEqual($0.status, .notImported) }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
    }

    func testImportFiltersWithOverride() {
        let settings = generateImportSettings()
        let expectation = XCTestExpectation()
        dnsProtection.filters = generateDnsFilters()
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
        dnsProtection.filters = generateDnsFilters()
        helper.importDnsFilters(settings, override: true) { result in
            XCTAssertEqual(result.count, 3)
            result.enumerated().forEach {
                XCTAssertEqual($0.element.name, self.dnsProtection.filters[$0.offset].name)
                XCTAssertEqual($0.element.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 3)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 3)
        XCTAssertEqual(dnsProtection.filters.count, 3)
    }

    func testImportFiltersWithOverrideAndEmptyImport() {
        let expectation = XCTestExpectation()
        dnsProtection.filters = generateDnsFilters()
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 3)
        dnsProtection.filters = generateDnsFilters()
        helper.importDnsFilters([], override: true) { result in
            XCTAssertEqual(result.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(dnsProtection.removeFilterCalledCount, 3)
        XCTAssertEqual(dnsProtection.addFilterCalledCount, 0)
        XCTAssertEqual(dnsProtection.filters.count, 0)
    }

    // MARK: - Private methods

    private func generateDnsProviders(dnsServers: [DnsServer]) -> [DnsProvider] {
        dnsServers.map {
            DnsProvider(name: "DnsProvider#\($0.providerId)", providerDescription: "description", servers: [$0], providerId: $0.providerId, logo: nil, logoDark: nil, homepage: "homepage", isEnabled: false)
        }
    }

    private func generateDnsServers(providersIds: [Int]) -> [DnsServer] {
        providersIds.map {
            DnsServer(features: [], upstreams: [], providerId: $0, type: .dnscrypt, id: $0, name: "DnsServer#\($0)", isEnabled: false)
        }
    }

    private func generateImportSettings(isImportEnabled: Bool = true, url: String = "example.org") -> [ImportSettings.FilterSettings] {
        var result: [ImportSettings.FilterSettings] = []
        for i in 0..<3 {
            result.append(ImportSettings.FilterSettings(name: "name#\(i)", url: url, isImportEnabled: isImportEnabled))
        }
        return result
    }

    private func generateDnsFilters() -> [DnsFilter] {
        var result: [DnsFilter] = []
        for i in 0..<3 {
            result.append(DnsFilter(filterId: i, subscriptionUrl: URL(string: "URL")!, isEnabled: true, name: "", description: "", version: "", lastUpdateDate: nil, updateFrequency: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: nil, rulesCount: i))
        }
        return result
    }
}
