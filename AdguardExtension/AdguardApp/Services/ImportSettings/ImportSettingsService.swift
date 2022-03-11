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

import SharedAdGuardSDK
import DnsAdGuardSDK
import SafariAdGuardSDK

/// Descendant of this protocol applies the import settings
protocol ImportSettingsServiceProtocol {
    /// Applies the import settings. Returns settings import result in completion
    func applySettings(_ settings: ImportSettings, completion: @escaping (ImportSettings) -> Void)
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(ImportSettingsService.self)

/// This class is responsible for applying the imported settings
final class ImportSettingsService: ImportSettingsServiceProtocol {

    struct FiltersImportContainer {
        let toImportFilters: [ImportSettings.FilterSettings]
        let toEnableFilters: [ImportSettings.FilterSettings]
    }

    // MARK: - Services

    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let safariProtection: SafariProtectionProtocol
    private let dnsProtection: DnsProtectionProtocol
    private let vpnManager: VpnManagerProtocol
    private let purchaseService: PurchaseServiceProtocol

    //MARK: - Private properties

    private let safariImportHelper: ImportSafariProtectionSettingsHelperProtocol
    private let dnsImportHelper: ImportDNSSettingsHelperProtocol

    private let workingQueue = DispatchQueue(label: "AdGuardApp.ImportSettingsQueue")

    // MARK: - Init

    init(dnsProvidersManager: DnsProvidersManagerProtocol, safariProtection: SafariProtectionProtocol, dnsProtection: DnsProtectionProtocol, vpnManager: VpnManagerProtocol, purchaseService: PurchaseServiceProtocol
    ) {
        self.dnsProvidersManager = dnsProvidersManager
        self.safariProtection = safariProtection
        self.dnsProtection = dnsProtection
        self.vpnManager = vpnManager
        self.purchaseService = purchaseService

        self.safariImportHelper = ImportSafariProtectionSettingsHelper(safariProtection: safariProtection)
        self.dnsImportHelper = ImportDNSSettingsHelper(dnsProvidersManager: dnsProvidersManager, dnsProtection: dnsProtection)
    }

    /// Init for tests
    init(dnsProvidersManager: DnsProvidersManagerProtocol, safariProtection: SafariProtectionProtocol, dnsProtection: DnsProtectionProtocol, vpnManager: VpnManagerProtocol, purchaseService: PurchaseServiceProtocol, safariImportHelper: ImportSafariProtectionSettingsHelperProtocol, dnsImportHelper: ImportDNSSettingsHelperProtocol) {

        self.dnsProvidersManager = dnsProvidersManager
        self.safariProtection = safariProtection
        self.dnsProtection = dnsProtection
        self.vpnManager = vpnManager
        self.purchaseService = purchaseService
        self.safariImportHelper = safariImportHelper
        self.dnsImportHelper = dnsImportHelper
    }

    // MARK: - Internal methods

    func applySettings(_ settings: ImportSettings, completion: @escaping (ImportSettings) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                completion(settings)
                return
            }

            let result = self.applySettingsInternal(settings)
            completion(result)
        }
    }

    // MARK: - Private methods

    private func applySettingsInternal(_ settings: ImportSettings) -> ImportSettings {
        var resultSettings = settings

        // Safari protection imports

        let importSafariFiltersResult = safariImportHelper.importSafariFilters(settings.defaultSafariFilters ?? [], override: settings.overrideDefaultSafariFilters ?? false)
        let importSafariCustomFiltersResult = importSafariCustomFilters(settings: settings)
        let importSafariBlocklistResult = importSafariBlocklistRules(settings: settings)

        resultSettings.defaultSafariFilters = importSafariFiltersResult
        resultSettings.customSafariFilters = importSafariCustomFiltersResult
        resultSettings.importSafariBlocklistRulesStatus = importSafariBlocklistResult

        if importSafariFiltersResult.contains(where: { $0.status == .successful }) ||
            importSafariCustomFiltersResult.contains(where: { $0.status == .successful }) ||
            importSafariBlocklistResult == .successful {
            updateMetaAndReloadCB()
        }

        let importLicenseResult = importLicense(settings: settings)
        resultSettings.importLicenseStatus = importLicenseResult

        // Import DNS settings only if application PRO or successfully logged in with license and login status is not .unsuccessful
        let availableStatus = importLicenseResult != .unsuccessful
        let isLicensePurchased = purchaseService.isProPurchased || Bundle.main.isPro
        guard availableStatus && isLicensePurchased else {
            return resultSettings
        }

        // DNS Imports

        let importDnsFiltersResult = importDnsFilters(settings: settings)
        let importDnsServerResult = importDnsServer(settings: settings)
        let importDnsRulesResult = importDnsRules(settings: settings)

        resultSettings.dnsFilters = importDnsFiltersResult
        resultSettings.importDnsServerStatus = importDnsServerResult
        resultSettings.importDnsBlocklistRulesStatus = importDnsRulesResult

        if importDnsFiltersResult.contains(where: { $0.status == .successful }) ||
            importDnsRulesResult == .successful ||
            importDnsServerResult == .successful {
            vpnManager.updateSettings(completion: nil)
        }

        return resultSettings
    }

    // MARK: - Safari protection imports

    private func importSafariBlocklistRules(settings: ImportSettings) -> ImportSettings.ImportSettingStatus {

        if settings.isSafariBlocklistRulesImportEnabled, let rules = settings.safariBlocklistRules {
            safariImportHelper.importSafariBlocklistRules(rules, override: settings.overrideSafariBlocklistRules ?? false)
            return .successful
        }
        return settings.importSafariBlocklistRulesStatus
    }

    private func importSafariCustomFilters(settings: ImportSettings) -> [ImportSettings.FilterSettings] {
        let uniqueImportCustomSafariFilters = settings.customSafariFilters?.uniqueElements { $0.url } ?? []
        let customFilters = safariProtection.groups.first { $0.groupType == .custom }?.filters ?? []
        let overrideCustomFilters = settings.overrideCustomSafariFilters ?? false

        let importFilters = parseFiltersToImport(filters: customFilters, filtersToImport: uniqueImportCustomSafariFilters, override: overrideCustomFilters)

        var resultSettings = [ImportSettings.FilterSettings]()
        let group = DispatchGroup()
        group.enter()
        safariImportHelper.importCustomSafariFilters(importFilters, override: overrideCustomFilters) { result in
            resultSettings = result
            group.leave()
        }
        group.wait()
        return resultSettings
    }

    // MARK: - DNS Imports

    // DNS filters
    private func importDnsFilters(settings: ImportSettings) -> [ImportSettings.FilterSettings] {
        let uniqueImportDnsFilters = settings.dnsFilters?.uniqueElements { $0.url } ?? []
        let dnsFilters = dnsProtection.filters
        let overrideDnsFilters = settings.overrideDnsFilters ?? false

        let importFilters = parseFiltersToImport(filters: dnsFilters, filtersToImport: uniqueImportDnsFilters, override: overrideDnsFilters)

        var resultSettings = [ImportSettings.FilterSettings]()
        let group = DispatchGroup()
        group.enter()
        dnsImportHelper.importDnsFilters(importFilters, override: overrideDnsFilters) { result in
            resultSettings = result
            group.leave()
        }
        group.wait()
        return resultSettings
    }

    // DNS server
    private func importDnsServer(settings: ImportSettings) -> ImportSettings.ImportSettingStatus {
        if let dnsServerId = settings.dnsServerId {
            if settings.isDnsServerImportEnabled {
                let result = dnsImportHelper.importDnsServer(serverId: dnsServerId)
                return result ? .successful : .unsuccessful
            }
        }
        return settings.importDnsServerStatus
    }

    // DNS Blocklist rules
    private func importDnsRules(settings: ImportSettings) -> ImportSettings.ImportSettingStatus {
        guard let dnsUserRules = settings.dnsBlocklistRules else { return settings.importDnsBlocklistRulesStatus }
        if settings.isDnsBlocklistRulesImportEnabled {
            let overrideDnsUserRules = settings.overrideDnsBlocklistRules ?? false
            dnsImportHelper.importDnsBlocklistRules(dnsUserRules, override: overrideDnsUserRules)
            return .successful
        }
        return settings.importDnsBlocklistRulesStatus
    }

    private func parseFiltersToImport(filters: [FilterMetaProtocol], filtersToImport: [ImportSettings.FilterSettings], override: Bool) -> FiltersImportContainer {

        if override {
            return FiltersImportContainer(toImportFilters: filtersToImport, toEnableFilters: [])
        }

        var toImportFilters: [ImportSettings.FilterSettings] = []
        var toEnableFilters: [ImportSettings.FilterSettings] = []
        filtersToImport.forEach { filterToImport in
            if filters.contains(where: { $0.filterDownloadPage == filterToImport.url }) {
                toEnableFilters.append(filterToImport)
            } else {
                toImportFilters.append(filterToImport)
            }
        }

        return FiltersImportContainer(toImportFilters: toImportFilters, toEnableFilters: toEnableFilters)
    }

    private func updateMetaAndReloadCB() {
        let group = DispatchGroup()
        group.enter()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_):
                LOG.info("Successfully updates filters meta and localizations")
            case .error(let error):
                LOG.error("Error occurred while updating filters meta and localizations; Error: \(error)")
            }
            group.leave()
        } onCbReloaded: { error in
            if let error = error {
                LOG.error("Error occurred while reloading content blockers; Error: \(error)")
                return
            }
            LOG.info("Content blockers successfully reloaded")
        }
        group.wait()
    }

    // MARK: - License import

    private func importLicense(settings: ImportSettings) -> ImportSettings.ImportSettingStatus {
        guard settings.isLicenseImportEnabled && !(Bundle.main.isPro || purchaseService.isProPurchased) else { return .notImported }
        guard let license = settings.license else { return .unsuccessful }

        let group = DispatchGroup()

        var result: ImportSettings.ImportSettingStatus = .unsuccessful
        group.enter()
        purchaseService.login(withLicenseKey: license) { loginResult in
            result = loginResult ? .successful : .unsuccessful
            group.leave()
        }

        group.wait()
        return result
    }
}
