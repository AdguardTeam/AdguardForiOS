/**
      This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
      Copyright © Adguard Software Limited. All rights reserved.

      Adguard for iOS is free software: you can redistribute it and/or modify
      it under the terms of the GNU General Public License as published by
      the Free Software Foundation, either version 3 of the License, or
      (at your option) any later version.

      Adguard for iOS is distributed in the hope that it will be useful,
      but WITHOUT ANY WARRANTY; without even the implied warranty of
      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
      GNU General Public License for more details.

      You should have received a copy of the GNU General Public License
      along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import SafariAdGuardSDK
import DnsAdGuardSDK

enum ImportRowType {
    case cbFilter
    case customCbFilter
    case dnsFilter
    case dnsSettings
    case license
    case userRules
    case dnsRules
}

struct SettingRow {
    var enabled: Bool = true
    var imported: Bool = false
    var importStatus: ImportSettings.ImportSettingStatus = .notImported
    var title: String = ""
    var subtitle: String = ""

    var type: ImportRowType
    var index: Int

    mutating func setImportStatus(imported: Bool, status: ImportSettings.ImportSettingStatus) {

        let result: ImportSettings.ImportSettingStatus
        if imported {
            result = status
        } else {
            result = .notImported
        }

        self.importStatus = result

        if result == .unsuccessful {
            self.subtitle = String.localizedString("import_unseccuessful")
        }
    }
}

protocol ImportSettingsViewModelProtocol {
    var rows: [SettingRow] { get }

    func setState(_ state: Bool, forRow: Int)
    func applySettings(callback: @escaping ()->Void)
}

class ImportSettingsViewModel: ImportSettingsViewModelProtocol {

    var rows: [SettingRow]

    private var settings: ImportSettings
    private let importService: ImportSettingsServiceProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let safariProtection: SafariProtectionProtocol

    init(settings: ImportSettings, importSettingsService: ImportSettingsServiceProtocol, dnsProvidersManager: DnsProvidersManagerProtocol, safariProtection: SafariProtectionProtocol) {
        self.settings = settings
        self.importService = importSettingsService
        self.safariProtection = safariProtection
        self.dnsProvidersManager = dnsProvidersManager

        rows = []
        fillRows(imported: false)
    }

    func setState(_ state: Bool, forRow index: Int) {
        var row = rows[index]

        switch(row.type) {
        case .cbFilter:
            settings.defaultSafariFilters?[row.index].isImportEnabled = state
        case .customCbFilter:
            settings.customSafariFilters?[row.index].isImportEnabled = state
        case .dnsFilter:
            settings.dnsFilters?[row.index].isImportEnabled = state
        case .dnsRules:
            settings.isDnsBlocklistRulesImportEnabled = state
        case .dnsSettings:
            settings.isDnsServerImportEnabled = state
        case .license:
            settings.isLicenseImportEnabled = state
        case .userRules:
            settings.isSafariBlocklistRulesImportEnabled = state
        }

        row.enabled = state
        rows[index] = row
    }

    func applySettings(callback: @escaping ()->Void) {

        importService.applySettings(settings) { [weak self] (result) in
            guard let self = self else { return }
            self.settings = result
            self.fillRows(imported: true)
            callback()
        }
    }

    private func fillRows(imported: Bool) {

        rows = []

        fillCBFilters(imported)

        fillCustomCBFilters(imported)

        fillDnsFilters(imported)

        fillDns(imported)

        fillLicense(imported)

        fillUserRules(imported)

        fillDnsRules(imported)
    }

    fileprivate func fillDnsRules(_ imported: Bool) {

        if settings.dnsBlocklistRules?.count ?? 0 > 0 {
            var row = SettingRow(type: .dnsRules, index: 0)
            row.title = String.localizedString("import_dns_user_rules")
            row.imported = imported
            row.enabled = settings.isDnsServerImportEnabled
            row.setImportStatus(imported: imported, status: settings.importDnsBlocklistRulesStatus)

            rows.append(row)
        }
    }

    private func fillUserRules(_ imported: Bool) {

        let userRulesCount = settings.safariBlocklistRules?.count ?? 0
        if userRulesCount > 0 {
            var row = SettingRow(type: .userRules, index: 0)
            row.title = String.localizedString("import_user_rules")
            row.imported = imported
            row.enabled = settings.isSafariBlocklistRulesImportEnabled
            row.setImportStatus(imported: imported, status: settings.importSafariBlocklistRulesStatus)

            rows.append(row)
        }
    }

    private func fillLicense(_ imported: Bool) {

        if !Bundle.main.isPro && settings.license?.count ?? 0 > 0 {
            var row = SettingRow(type: .license, index: 0)
            let format = String.localizedString("import_license_format")
            row.title = String(format: format, settings.license!)
            row.imported = imported
            row.enabled = settings.isLicenseImportEnabled
            row.setImportStatus(imported: imported, status: settings.importLicenseStatus)

            rows.append(row)
        }
    }

    private func fillDns(_ imported: Bool) {

        if let serverId = settings.dnsServerId {
            var row = SettingRow(type: .dnsSettings, index: 0)

            let format = String.localizedString("import_dns_settings_format")
            let provider = dnsProvidersManager.allProviders.first { $0.dnsServers.contains(where: { $0.id == serverId }) }

            row.title = String(format:format, provider?.name ?? "")
            row.imported = imported
            row.enabled = settings.isDnsServerImportEnabled
            row.setImportStatus(imported: imported, status: settings.importDnsServerStatus)

            rows.append(row)
        }
    }

    private func fillDnsFilters(_ imported: Bool) {

        var index = 0
        for filter in settings.dnsFilters ?? [] {

            let titleFormat = String.localizedString("import_dns_filter_format")
            let title = String(format: titleFormat, filter.name)
            var row = SettingRow(type: .dnsFilter, index: index)

            row.title = title
            row.imported = imported
            row.enabled = filter.isImportEnabled
            row.setImportStatus(imported: imported, status: filter.status)

            rows.append(row)
            index += 1
        }
    }

    private func fillCustomCBFilters(_ imported: Bool) {

        var index = 0
        for filter in settings.customSafariFilters ?? [] {
            let titleFormat = String.localizedString("import_custom_cb_filter_format")
            let title = String(format: titleFormat, filter.name)

            var row = SettingRow(type: .customCbFilter, index: index)

            row.title = title
            row.imported = imported
            row.enabled = filter.isImportEnabled
            row.setImportStatus(imported: imported, status: filter.status)

            rows.append(row)
            index += 1
        }
    }

    fileprivate func fillCBFilters(_ imported: Bool) {

        var index = 0

        for filter in settings.defaultSafariFilters ?? [] {
            var row = SettingRow(type: .cbFilter, index: index)
            let format = String.localizedString(filter.enable ? "enable_cb_filter_format" : "disable_cb_filter_format")

            let filters:[SafariFilterProtocol] = safariProtection.groups.flatMap { group in
                return group.filters
            }

            if let filterMeta = filters.first(where: { $0.filterId == filter.id })  {
                let name = filterMeta.name ?? ""
                row.title = String(format: format, name)
            }
            else {
                DDLogError("unknown filter")
            }

            row.imported = imported
            row.enabled = filter.isImportEnabled
            row.setImportStatus(imported: imported, status: filter.status)

            rows.append(row)
            index += 1
        }
    }
}
