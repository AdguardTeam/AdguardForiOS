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
    /// Applies the import settings. Return settings import result in completion
    func applySettings(_ settings: Settings, completion: @escaping (Settings) -> Void)
}

protocol ImportSettingsServiceDelegate {
    func applySettingsFinished()
}

/// This class is responsible for applying the imported settings
final class ImportSettingsService: ImportSettingsServiceProtocol {

    // MARK: - Services

    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let safariProtection: SafariProtectionProtocol
    private let dnsProtection: DnsProtectionProtocol
    private let vpnManager: VpnManagerProtocol
    private let purchaseService: PurchaseServiceProtocol

    //MARK: - Private properties

    private let safariImportHelper: ImportSafariProtectionSettingsHelper
    private let dnsImportHelper: ImportDNSSettingsHelper

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

    // MARK: - Internal methods

    func applySettings(_ settings: Settings, completion: @escaping (Settings) -> Void) {
        workingQueue.async { [weak self] in
            self?.applySettingsInternal(settings, completion: completion)
        }
    }

    // MARK: - Private methods

    private func applySettingsInternal(_ settings: Settings, completion: (Settings) -> Void) {
        var resultSettings = settings

        // Safari protection imports

        let importSafariFiltersResult = safariImportHelper.importSafariFilters(settings.defaultCbFilters ?? [], override: settings.overrideCbFilters ?? false)
        let importSafariCustomFiltersResult = importSafariCustomFilters(settings: settings)
        let importSafariBlocklistResult = importSafariBlocklistRules(settings: settings)

        resultSettings.defaultCbFilters = importSafariFiltersResult
        resultSettings.customCbFilters = importSafariCustomFiltersResult
        resultSettings.userRulesStatus = importSafariBlocklistResult

        if !importSafariFiltersResult.isEmpty ||
            !importSafariCustomFiltersResult.isEmpty ||
            importSafariBlocklistResult == .successful {
            updateMetaAndReloadCB()
        }

        let importLicenseResult = importLicense(settings: settings)
        resultSettings.licenseStatus = importLicenseResult

        // Import DNS settings only if app is PRO or if import license settings was successful
        guard importLicenseResult == .successful || importLicenseResult == .enabled else {
            completion(settings)
            return
        }

        // DNS Imports

        let importDnsFiltersResult = importDnsFilters(settings: settings)
        let importDnsServerResult = importDnsServer(settings: settings)
        let importDnsRulesResult = importDnsRules(settings: settings)

        resultSettings.dnsFilters = importDnsFiltersResult
        resultSettings.dnsStatus = importDnsServerResult
        resultSettings.dnsRulesStatus = importDnsRulesResult

        if !importDnsFiltersResult.isEmpty ||
            importDnsRulesResult == .successful ||
            importDnsServerResult == .successful {
            vpnManager.updateSettings(completion: nil)
        }

        completion(resultSettings)
    }

    // MARK: - Safari protection imports

    private func importSafariBlocklistRules(settings: Settings) -> ImportSettingStatus {
        if settings.userRulesStatus == .enabled {
            let result = safariImportHelper.importSafariBlocklistRules(settings.userRules ?? [], override: settings.overrideUserRules ?? false)
            return result ? .successful : .unsuccessful
        }
        return settings.userRulesStatus
    }

    private func importSafariCustomFilters(settings: Settings) -> [CustomCBFilterSettings] {
        let uniqueImportCustomSafariFilters = settings.customCbFilters?.uniqueElements { $0.url } ?? []
        let customFilters = safariProtection.groups.first { $0.groupType == .custom }?.filters ?? []
        let overrideCustomFilters = settings.overrideCustomFilters ?? false

        guard let uniqueCustomSafariFiltersSettings = collectUniqueFiltersToImport(filters: customFilters, filtersToImport: uniqueImportCustomSafariFilters, override: overrideCustomFilters) as? [CustomCBFilterSettings] else { return [] }

        var resultSettings = [CustomCBFilterSettings]()
        let group = DispatchGroup()
        group.enter()
        safariImportHelper.importCustomSafariFilters(uniqueCustomSafariFiltersSettings, override: overrideCustomFilters) { result in
            resultSettings = result
            group.leave()
        }
        group.wait()
        return resultSettings
    }

    // MARK: - DNS Imports

    // DNS filters
    private func importDnsFilters(settings: Settings) -> [DnsFilterSettings] {
        let uniqueImportDnsFilters = settings.dnsFilters?.uniqueElements { $0.url } ?? []
        let dnsFilters = dnsProtection.filters
        let overrideDnsFilters = settings.overrideDnsFilters ?? false

        guard let uniqueCustomDnsFilterSettings = collectUniqueFiltersToImport(filters: dnsFilters, filtersToImport: uniqueImportDnsFilters, override: overrideDnsFilters) as? [DnsFilterSettings] else { return [] }

        var resultSettings = [DnsFilterSettings]()
        let group = DispatchGroup()
        group.enter()
        dnsImportHelper.importDnsFilters(uniqueCustomDnsFilterSettings, override: overrideDnsFilters) { result in
            resultSettings = result
            group.leave()
        }
        group.wait()
        return resultSettings
    }

    // DNS server
    private func importDnsServer(settings: Settings) -> ImportSettingStatus {
        if let dnsServerId = settings.dnsServerId {
            if settings.dnsStatus == .enabled {
                let result = dnsImportHelper.importDnsServer(serverId: dnsServerId)
                return result ? .successful : .unsuccessful
            }
        }
        return settings.dnsStatus
    }

    // DNS Blocklist rules
    private func importDnsRules(settings: Settings) -> ImportSettingStatus {
        guard let dnsUserRules = settings.dnsUserRules else { return settings.dnsRulesStatus }
        if settings.dnsRulesStatus == .enabled {
            let overrideDnsUserRules = settings.overrideDnsUserRules ?? false
            let rulesToImport = dnsUserRules.map { UserRule(ruleText: $0) }
            let result = dnsImportHelper.importDnsBlocklistRules(rulesToImport, override: overrideDnsUserRules)
            return result ? .successful : .unsuccessful
        }
        return settings.dnsRulesStatus
    }

    // Return unique filters
    private func collectUniqueFiltersToImport(filters: [FilterMetaProtocol], filtersToImport: [CustomFilterSettingsProtocol], override: Bool) -> [CustomFilterSettingsProtocol] {
        return filtersToImport.compactMap { filterToImport in
            if override || !filters.contains(where: { $0.filterDownloadPage == filterToImport.url }) {
                return filterToImport
            }
            return nil
        }
    }

    private func updateMetaAndReloadCB() {
        let group = DispatchGroup()
        group.enter()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_):
                DDLogInfo("(ImportSettingsService) - updateMetaAndReloadCB; Successfully updates filters meta and localizations")
            case .error(let error):
                DDLogError("(ImportSettingsService) - updateMetaAndReloadCB; Error occurred while updating filters meta and localizations; Error: \(error)")
            }
            group.leave()
        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(ImportSettingsService) - updateMetaAndReloadCB; Error occurred while reloading content blockers; Error: \(error)")
                return
            }
            DDLogInfo("(ImportSettingsService) - updateMetaAndReloadCB; Content blockers successfully reloaded")
        }
        group.wait()
    }

    // MARK: - License import

    private func importLicense(settings: Settings) -> ImportSettingStatus {
        guard !Bundle.main.isPro else { return .enabled }
        guard settings.licenseStatus == .enabled else { return .disabled }
        guard let license = settings.license else { return .unsuccessful }

        let group = DispatchGroup()

        var result: ImportSettingStatus = .enabled
        group.enter()
        purchaseService.login(withLicenseKey: license) { loginResult in
            result = loginResult ? .successful : .unsuccessful
            group.leave()
        }

        group.wait()
        return result
    }
}
