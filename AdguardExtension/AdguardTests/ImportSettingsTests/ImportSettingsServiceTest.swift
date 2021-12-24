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
import SafariAdGuardSDK
import SharedAdGuardSDK
import DnsAdGuardSDK

class ImportSettingsServiceTest: XCTestCase {

    private var service: ImportSettingsServiceProtocol!
    private var dnsProviderManager: InAppDnsProvidersManagerMock!
    private var safariProtection: SafariProtectionMock!
    private var dnsProtection: DnsProtectionMock!
    private var vpnManager: VpnManagerMock!
    private var purchaseService: PurchaseServiceMock!
    private var importDNSHelper: ImportDNSSettingsHelperMock!
    private var importSafariHelper: ImportSafariProtectionSettingsHelperMock!

    override func setUp() {

        self.dnsProviderManager = InAppDnsProvidersManagerMock()
        self.safariProtection = SafariProtectionMock()
        self.dnsProtection = DnsProtectionMock()
        self.vpnManager = VpnManagerMock()
        self.purchaseService = PurchaseServiceMock()
        self.importDNSHelper = ImportDNSSettingsHelperMock()
        self.importSafariHelper = ImportSafariProtectionSettingsHelperMock()

        self.service = ImportSettingsService(dnsProvidersManager: dnsProviderManager,
                                             safariProtection: safariProtection,
                                             dnsProtection: dnsProtection,
                                             vpnManager: vpnManager,
                                             purchaseService: purchaseService,
                                             safariImportHelper: importSafariHelper,
                                             dnsImportHelper: importDNSHelper)
    }

    // MARK: - Test applySettings for safari filters

    func testApplySafariFiltersSettingsWithSuccess() {
        let expectation = XCTestExpectation()
        let filters = [
            ImportSettings.DefaultSafariFilterSettings(id: 1, enable: true, status: .successful),
            ImportSettings.DefaultSafariFilterSettings(id: 2, enable: true, status: .successful),
            ImportSettings.DefaultSafariFilterSettings(id: 3, enable: true, status: .successful)]

        let importSettings = generateImportSettings()
        importSafariHelper.stubbedImportSafariFiltersResult = filters

        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            result.defaultSafariFilters?.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 1)
    }

    func testApplySafariFiltersSettingsWithUnsuccessful() {
        let expectation = XCTestExpectation()
        let filters = [
            ImportSettings.DefaultSafariFilterSettings(id: 1, enable: true, status: .unsuccessful),
            ImportSettings.DefaultSafariFilterSettings(id: 2, enable: true, status: .unsuccessful),
            ImportSettings.DefaultSafariFilterSettings(id: 3, enable: true, status: .unsuccessful)]

        let importSettings = generateImportSettings()
        importSafariHelper.stubbedImportSafariFiltersResult = filters

        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            result.defaultSafariFilters?.forEach {
                XCTAssertEqual($0.status, .unsuccessful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
    }

    // MARK: - Test applySettings for custom safari filters

    func testApplyCustomSafariFiltersSettingsWithSuccess() {
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImport(filtersStatus: .successful)

        let importSettings = generateImportSettings(customSafariFilters: filters.filters)
        importSafariHelper.stubbedImportCustomSafariFiltersCompletionResult = filters.filtersResult
        safariProtection.groups = generateCustomGroupAndFilter()

        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.customSafariFilters!.count, 3)
            result.customSafariFilters!.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 1)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.count, 3)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toEnableFilters.count, 0)
        importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.enumerated().forEach {
            XCTAssertEqual($0.element.url, "url#\($0.offset)")
        }
    }

    func testApplyCustomSafariFiltersSettingsWithOverride() {
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImport(filtersStatus: .successful)

        let importSettings = generateImportSettings(overrideCustomSafariFilters: true, customSafariFilters: filters.filters)
        importSafariHelper.stubbedImportCustomSafariFiltersCompletionResult = filters.filtersResult
        safariProtection.groups = generateCustomGroupAndFilter()

        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            result.customSafariFilters!.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 1)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.count, 3)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toEnableFilters.count, 0)
        importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.enumerated().forEach {
            XCTAssertEqual($0.element.url, "url#\($0.offset)")
        }
    }

    func testApplyCustomSafariFiltersSettingsWithEmptyImport() {
        let expectation = XCTestExpectation()

        let importSettings = generateImportSettings()
        importSafariHelper.stubbedImportCustomSafariFiltersCompletionResult = []
        safariProtection.groups = generateCustomGroupAndFilter()

        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.count, 0)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toEnableFilters.count, 0)
        importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.enumerated().forEach {
            XCTAssertEqual($0.element.url, "url#\($0.offset + 1)")
        }
    }

    func testApplyCustomSafariFiltersSettingsWithImportEnabledFilters() {
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImport(filtersStatus: .successful)

        let importSettings = generateImportSettings(customSafariFilters: filters.filters)
        importSafariHelper.stubbedImportCustomSafariFiltersCompletionResult = filters.filtersResult
        safariProtection.groups = generateCustomGroupWithFiltersForEnabling(filterDownloadPage: "url")

        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.customSafariFilters!.count, 3)
            result.customSafariFilters!.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 1)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.count, 0)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toEnableFilters.count, 3)
        importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.enumerated().forEach {
            XCTAssertEqual($0.element.url, "url#\($0.offset)")
        }
    }

    func testApplyCustomSafariFiltersSettingsWithImportAllCases() {
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImportWithAllCases(filtersStatus: .successful)

        let importSettings = generateImportSettings(customSafariFilters: filters.filters)
        importSafariHelper.stubbedImportCustomSafariFiltersCompletionResult = filters.filtersResult
        safariProtection.groups = generateCustomGroupWithFiltersForEnabling(filterDownloadPage: "url")

        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.customSafariFilters!.count, 6)
            result.customSafariFilters!.forEach {
                XCTAssertEqual($0.status, .successful)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 1)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.count, 3)
        XCTAssertEqual(importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toEnableFilters.count, 3)

        importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toEnableFilters.enumerated().forEach {
            XCTAssertEqual($0.element.url, "url#\($0.offset)")
        }

        importSafariHelper.invokedImportCustomSafariFiltersParameters!.filtersContainer.toImportFilters.enumerated().forEach {
            XCTAssertEqual($0.element.url, "url#\($0.offset + 3)")
        }
    }

    // MARK: - Test applySettings for safari blocklist rules

    func testApplySafariBlocklistRulesWithSuccess() {
        let expectation = XCTestExpectation()

        let rules = ["Rule1", "Rule2", "Rule3"]
        let importSettings = generateImportSettings(isSafariBlocklistRulesImportEnabled: true, safariBlocklistRules: rules)

        XCTAssertEqual(importSafariHelper.invokedImportSafariBlocklistRulesCount, 0)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.safariBlocklistRules!, rules)
            XCTAssertEqual(result.importSafariBlocklistRulesStatus, .successful)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importSafariHelper.invokedImportSafariBlocklistRulesCount, 1)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 1)
    }

    func testApplySafariBlocklistRulesWithDisabledImport() {
        let expectation = XCTestExpectation()

        let rules = ["Rule1", "Rule2", "Rule3"]
        let importSettings = generateImportSettings(isSafariBlocklistRulesImportEnabled: false, safariBlocklistRules: rules)

        XCTAssertEqual(importSafariHelper.invokedImportSafariBlocklistRulesCount, 0)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.safariBlocklistRules!, rules)
            XCTAssertEqual(result.importSafariBlocklistRulesStatus, .notImported)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importSafariHelper.invokedImportSafariBlocklistRulesCount, 0)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
    }

    func testApplySafariBlocklistRulesWithEmptyRules() {
        let expectation = XCTestExpectation()

        let importSettings = generateImportSettings(isSafariBlocklistRulesImportEnabled: true, safariBlocklistRules: nil)

        XCTAssertEqual(importSafariHelper.invokedImportSafariBlocklistRulesCount, 0)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertNil(result.safariBlocklistRules)
            XCTAssertEqual(result.importSafariBlocklistRulesStatus, .notImported)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importSafariHelper.invokedImportSafariBlocklistRulesCount, 0)
        XCTAssertEqual(safariProtection.updateFiltersMetaAndLocalizationsCalledCount, 0)
    }

    // MARK: - Test import license

    func testApplyImportLicense() {
        let importSettings = generateImportSettings(isLicenseImportEnabled: true, license: "license")
        purchaseService.isProPurchased = false
        purchaseService.loginWithLicenseKeyResult = true

        let expectation = XCTestExpectation()

        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importLicenseStatus, .successful)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 1)
    }

    func testApplyImportLicenseWithImportDisabled() {
        let importSettings = generateImportSettings(isLicenseImportEnabled: false, license: "license")
        purchaseService.isProPurchased = false
        purchaseService.loginWithLicenseKeyResult = true

        let expectation = XCTestExpectation()

        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importLicenseStatus, .notImported)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
    }

    func testApplyImportLicenseWithNilLicense() {
        let importSettings = generateImportSettings(isLicenseImportEnabled: true, license: nil)
        purchaseService.isProPurchased = false
        purchaseService.loginWithLicenseKeyResult = true
        let expectation = XCTestExpectation()

        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importLicenseStatus, .unsuccessful)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
    }

    func testApplyImportLicenseWithLoginResultFalse() {
        let importSettings = generateImportSettings(isLicenseImportEnabled: true, license: "license")
        purchaseService.isProPurchased = false
        purchaseService.loginWithLicenseKeyResult = false
        let expectation = XCTestExpectation()

        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importLicenseStatus, .unsuccessful)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 1)
    }

    func testApplyImportLicenseWithProPurchased() {
        let importSettings = generateImportSettings(isLicenseImportEnabled: true, license: "license")
        purchaseService.isProPurchased = true
        purchaseService.loginWithLicenseKeyResult = true
        let expectation = XCTestExpectation()

        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importLicenseStatus, .notImported)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(purchaseService.loginWithLicenseKeyCalledCount, 0)
    }

    // MARK: - Test import dns filters

    func testApplyDnsFiltersWithSuccess() {
        var importSettings = generateImportSettings(isLicenseImportEnabled: true, license: "license")
        purchaseService.isProPurchased = true
        purchaseService.loginWithLicenseKeyResult = true
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImport(filtersStatus: .successful)
        importSettings.dnsFilters = filters.filters
        dnsProtection.filters = []
        importDNSHelper.stubbedImportDnsFiltersCompletionResult = filters.filtersResult

        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.dnsFilters?.count, 3)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toImportFilters.count, 3)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toEnableFilters.count, 0)
            result.dnsFilters?.enumerated().forEach {
                XCTAssertEqual($0.element.status, .successful)
                XCTAssertEqual($0.element.url, "url#\($0.offset)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 1)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 1)
    }

    func testApplyDnsFiltersWithOverride() {
        var importSettings = generateImportSettings(overrideDnsFilters: true, isLicenseImportEnabled: true, license: "license")
        purchaseService.isProPurchased = true
        purchaseService.loginWithLicenseKeyResult = true
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImport(filtersStatus: .successful)
        importSettings.dnsFilters = filters.filters
        dnsProtection.filters = generateDnsFilters()
        importDNSHelper.stubbedImportDnsFiltersCompletionResult = filters.filtersResult

        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.dnsFilters?.count, 3)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toImportFilters.count, 3)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toEnableFilters.count, 0)
            result.dnsFilters?.enumerated().forEach {
                XCTAssertEqual($0.element.status, .successful)
                XCTAssertEqual($0.element.url, "url#\($0.offset)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 1)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 1)
    }

    func testApplyDnsFiltersWithImportEnabledFilters() {
        var importSettings = generateImportSettings(isLicenseImportEnabled: true, license: "license")
        purchaseService.isProPurchased = true
        purchaseService.loginWithLicenseKeyResult = true
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImport(filtersStatus: .successful)
        importSettings.dnsFilters = filters.filters
        dnsProtection.filters = generateDnsFilters()
        importDNSHelper.stubbedImportDnsFiltersCompletionResult = filters.filtersResult

        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.dnsFilters?.count, 3)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toImportFilters.count, 0)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toEnableFilters.count, 3)
            result.dnsFilters?.enumerated().forEach {
                XCTAssertEqual($0.element.status, .successful)
                XCTAssertEqual($0.element.url, "url#\($0.offset)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 1)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 1)
    }

    func testApplyDnsFiltersWithImportAllCases() {
        var importSettings = generateImportSettings(isLicenseImportEnabled: true, license: "license")
        purchaseService.isProPurchased = true
        purchaseService.loginWithLicenseKeyResult = true
        let expectation = XCTestExpectation()

        let filters = generateFiltersToImportWithAllCases(filtersStatus: .successful)
        importSettings.dnsFilters = filters.filters
        dnsProtection.filters = generateDnsFilters()
        importDNSHelper.stubbedImportDnsFiltersCompletionResult = filters.filtersResult

        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.dnsFilters?.count, 6)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toImportFilters.count, 3)
            XCTAssertEqual(self.importDNSHelper.invokedImportDnsFiltersParameters?.filtersContainer.toEnableFilters.count, 3)
            result.dnsFilters?.enumerated().forEach {
                XCTAssertEqual($0.element.status, .successful)
                XCTAssertEqual($0.element.url, "url#\($0.offset)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsFiltersCount, 1)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 1)
    }

    // MARK: - Test import dns blocklist rules

    func testApplyImportDnsBlocklistRulesWithSuccess() {
        let importSettings = generateImportSettings(isDnsBlocklistRulesImportEnabled: true, dnsBlocklistRules: ["Rule1", "Rule2", "Rule3"])
        let expectation = XCTestExpectation()
        purchaseService.isProPurchased = true
        XCTAssertEqual(importDNSHelper.invokedImportDnsBlocklistRulesCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importDnsBlocklistRulesStatus, .successful)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsBlocklistRulesCount, 1)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 1)
    }


    func testApplyImportDnsBlocklistRulesWithDisabledImport() {
        let importSettings = generateImportSettings(isDnsBlocklistRulesImportEnabled: false, dnsBlocklistRules: ["Rule1", "Rule2", "Rule3"])
        let expectation = XCTestExpectation()
        purchaseService.isProPurchased = true
        XCTAssertEqual(importDNSHelper.invokedImportDnsBlocklistRulesCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importDnsBlocklistRulesStatus, .notImported)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsBlocklistRulesCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
    }

    // MARK: - Test import dns server

    func testApplyImportDnsServerWithSuccess() {
        let importSettings = generateImportSettings(isDnsServerImportEnabled: true, dnsServerId: 1)
        let expectation = XCTestExpectation()
        purchaseService.isProPurchased = true
        importDNSHelper.stubbedImportDnsServerResult = true
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importDnsServerStatus, .successful)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 1)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 1)
    }

    func testApplyImportDnsServerWithServerIdNil() {
        let importSettings = generateImportSettings(isDnsServerImportEnabled: true, dnsServerId: nil)
        let expectation = XCTestExpectation()
        purchaseService.isProPurchased = true
        importDNSHelper.stubbedImportDnsServerResult = true
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importDnsServerStatus, .notImported)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
    }

    func testApplyImportDnsServerWithImportDisabled() {
        let importSettings = generateImportSettings(isDnsServerImportEnabled: false, dnsServerId: 1)
        let expectation = XCTestExpectation()
        purchaseService.isProPurchased = true
        importDNSHelper.stubbedImportDnsServerResult = true
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importDnsServerStatus, .notImported)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
    }

    func testApplyImportDnsServerWithUnsuccessful() {
        let importSettings = generateImportSettings(isDnsServerImportEnabled: true, dnsServerId: 1)
        let expectation = XCTestExpectation()
        purchaseService.isProPurchased = true
        importDNSHelper.stubbedImportDnsServerResult = false
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 0)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
        service.applySettings(importSettings) { result in
            XCTAssertEqual(result.importDnsServerStatus, .unsuccessful)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(importDNSHelper.invokedImportDnsServerCount, 1)
        XCTAssertEqual(vpnManager.updateSettingsCalledCount, 0)
    }

    // MARK: - Private methods

    private func generateDnsFilters() -> [DnsFilter] {
        var result: [DnsFilter] = []
        for i in 0..<3 {
            result.append(
                DnsFilter(filterId: i, subscriptionUrl: URL(string: "url")!, isEnabled: false, name: nil, description: nil, version: nil, lastUpdateDate: nil, homePage: nil, licensePage: nil, issuesReportPage: nil, communityPage: nil, filterDownloadPage: "url#\(i)", rulesCount: 0)
            )
        }
        return result
    }

    private func generateFiltersToImport(filtersStatus: ImportSettings.ImportSettingStatus) -> (filters: [ImportSettings.FilterSettings], filtersResult: [ImportSettings.FilterSettings]) {
        let filters = [
            ImportSettings.FilterSettings(name: "filter#1", url: "url#0", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#2", url: "url#1", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#3", url: "url#1", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#3", url: "url#1", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#4", url: "url#2", isImportEnabled: true, status: .notImported)]

        let filtersResult = [
            ImportSettings.FilterSettings(name: "filter#1", url: "url#0", isImportEnabled: true, status: filtersStatus),
            ImportSettings.FilterSettings(name: "filter#2", url: "url#1", isImportEnabled: true, status: filtersStatus),
            ImportSettings.FilterSettings(name: "filter#3", url: "url#2", isImportEnabled: true, status: filtersStatus)]

        return (filters, filtersResult)
    }

    private func generateFiltersToImportWithAllCases(filtersStatus: ImportSettings.ImportSettingStatus) -> (filters: [ImportSettings.FilterSettings], filtersResult: [ImportSettings.FilterSettings]) {
        let filters = [
            ImportSettings.FilterSettings(name: "filter#1", url: "url#0", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#2", url: "url#1", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#3", url: "url#2", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#4", url: "url#3", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#5", url: "url#4", isImportEnabled: true, status: .notImported),
            ImportSettings.FilterSettings(name: "filter#6", url: "url#5", isImportEnabled: true, status: .notImported)]

        let filtersResult = [
            ImportSettings.FilterSettings(name: "filter#1", url: "url#0", isImportEnabled: true, status: filtersStatus),
            ImportSettings.FilterSettings(name: "filter#2", url: "url#1", isImportEnabled: true, status: filtersStatus),
            ImportSettings.FilterSettings(name: "filter#3", url: "url#2", isImportEnabled: true, status: filtersStatus),
            ImportSettings.FilterSettings(name: "filter#4", url: "url#3", isImportEnabled: true, status: filtersStatus),
            ImportSettings.FilterSettings(name: "filter#5", url: "url#4", isImportEnabled: true, status: filtersStatus),
            ImportSettings.FilterSettings(name: "filter#6", url: "url#5", isImportEnabled: true, status: filtersStatus)]
        return (filters, filtersResult)
    }


    private func generateCustomGroupAndFilter() -> [SafariGroup] {
        let group = SafariGroup(filters: [], isEnabled: false, groupType: .custom, groupName: "group", displayNumber: 0)
        let filter = SafariGroup.Filter(name: "PresetedFilter#", description: "", isEnabled: false, filterId: 0, version: nil, lastUpdateDate: nil, group: group, displayNumber: 0, languages: [], tags: [], homePage: nil, filterDownloadPage: "example.org", rulesCount: 0)

        return [SafariGroup(filters: [filter],
                        isEnabled: group.isEnabled,
                        groupType: group.groupType,
                        groupName: group.groupName,
                        displayNumber: group.displayNumber)]
    }

    private func generateCustomGroupWithFiltersForEnabling(filterDownloadPage: String = "example.org", numberOfFilters: Int = 3) -> [SafariGroup] {
        let group = SafariGroup(filters: [], isEnabled: false, groupType: .custom, groupName: "group", displayNumber: 0)

        var filters: [SafariGroup.Filter] = []
        for i in 0..<numberOfFilters {
            let filter = SafariGroup.Filter(name: "PresetedFilter#", description: "", isEnabled: false, filterId: 0, version: nil, lastUpdateDate: nil, group: group, displayNumber: 0, languages: [], tags: [], homePage: nil, filterDownloadPage: "\(filterDownloadPage)#\(i)", rulesCount: 0)
            filters.append(filter)
        }

        return [SafariGroup(filters: filters,
                        isEnabled: group.isEnabled,
                        groupType: group.groupType,
                        groupName: group.groupName,
                        displayNumber: group.displayNumber)]
    }

    private func generateImportSettings(
        overrideDefaultSafariFilters: Bool? = nil,
        overrideCustomSafariFilters: Bool? = nil,
        overrideSafariBlocklistRules: Bool? = nil,
        overrideDnsBlocklistRules: Bool? = nil,
        overrideDnsFilters: Bool? = nil,
        isDnsServerImportEnabled: Bool = false,
        isLicenseImportEnabled: Bool = false,
        isSafariBlocklistRulesImportEnabled: Bool = false,
        isDnsBlocklistRulesImportEnabled: Bool = false,
        defaultSafariFilters: [ImportSettings.DefaultSafariFilterSettings]? = nil,
        customSafariFilters: [ImportSettings.FilterSettings]? = nil,
        dnsFilters: [ImportSettings.FilterSettings]? = nil,
        dnsServerId: Int? = nil,
        license: String? = nil,
        safariBlocklistRules: [String]? = nil,
        dnsBlocklistRules: [String]? = nil,
        importDnsServerStatus: ImportSettings.ImportSettingStatus = .notImported,
        importLicenseStatus: ImportSettings.ImportSettingStatus = .notImported,
        importSafariBlocklistRulesStatus: ImportSettings.ImportSettingStatus = .notImported,
        importDnsBlocklistRulesStatus: ImportSettings.ImportSettingStatus = .notImported) -> ImportSettings {

            return ImportSettings(overrideDefaultSafariFilters: overrideDefaultSafariFilters,
                                  overrideCustomSafariFilters: overrideCustomSafariFilters,
                                  overrideSafariBlocklistRules: overrideSafariBlocklistRules,
                                  overrideDnsBlocklistRules: overrideDnsBlocklistRules,
                                  overrideDnsFilters: overrideDnsFilters,
                                  isDnsServerImportEnabled: isDnsServerImportEnabled,
                                  isLicenseImportEnabled: isLicenseImportEnabled,
                                  isSafariBlocklistRulesImportEnabled: isSafariBlocklistRulesImportEnabled,
                                  isDnsBlocklistRulesImportEnabled: isDnsBlocklistRulesImportEnabled,
                                  defaultSafariFilters: defaultSafariFilters,
                                  customSafariFilters: customSafariFilters,
                                  dnsFilters: dnsFilters,
                                  dnsServerId: dnsServerId,
                                  license: license,
                                  safariBlocklistRules: safariBlocklistRules,
                                  dnsBlocklistRules: dnsBlocklistRules,
                                  importDnsServerStatus: importDnsServerStatus,
                                  importLicenseStatus: importLicenseStatus,
                                  importSafariBlocklistRulesStatus: importSafariBlocklistRulesStatus,
                                  importDnsBlocklistRulesStatus: importDnsBlocklistRulesStatus)
        }
}
