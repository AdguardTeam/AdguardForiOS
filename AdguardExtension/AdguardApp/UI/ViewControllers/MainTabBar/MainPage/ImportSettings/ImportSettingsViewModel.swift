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

import Foundation

enum ImportRowType {
    case cbFilter
    case customCbFilter
    case dnsFilter
    case dnsSettings
    case license
    case userRules
    case dnsRules
}

enum ImportStatus {
    case notImported
    case successfull
    case unsucessfull
}

struct SettingRow {
    var enabled: Bool = true
    var imported: Bool = false
    var importStatus: ImportStatus = .notImported
    var title: String = ""
    var subtitle: String = ""
    
    var type: ImportRowType
    var index: Int
    
    mutating func setImportStatus(imported: Bool, status: ImportSettingStatus) {
        
        var result: ImportStatus = .notImported
        if imported {
            switch status {
            case .disabled:
                result = .notImported
            case .successful:
                result = .successfull
            case .unsuccessful:
                result = .unsucessfull
            default:
                result = .notImported
            }
        }
        else {
            result = .notImported
        }
        
        self.importStatus = result
        
        if result == .unsucessfull {
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
    
    private var settings: Settings
    private let importService: ImportSettingsServiceProtocol
    private let antibanner :AESAntibannerProtocol
    private let dnsProvidersService: DnsProvidersServiceProtocol
    
    init(settings: Settings, importSettingsService: ImportSettingsServiceProtocol, antibanner: AESAntibannerProtocol, dnsProvidersService: DnsProvidersServiceProtocol) {
        self.settings = settings
        self.importService = importSettingsService
        self.antibanner = antibanner
        self.dnsProvidersService = dnsProvidersService
        
        rows = []
        fillRows(imported: false)
    }
    
    func setState(_ state: Bool, forRow index: Int) {
        var row = rows[index]
        
        let status: ImportSettingStatus = state ? .enabled : .disabled
        
        switch(row.type) {
        case .cbFilter:
            settings.defaultCbFilters?[row.index].status = status
        case .customCbFilter:
            settings.customCbFilters?[row.index].status = status
        case .dnsFilter:
            settings.dnsFilters?[row.index].status = status
        case .dnsRules:
            settings.dnsRulesStatus = status
        case .dnsSettings:
            settings.dnsStatus = status
        case .license:
            settings.licenseStatus = status
        case .userRules:
            settings.userRulesStatus = status
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
        
        if settings.dnsUserRules?.count ?? 0 > 0 {
            var row = SettingRow(type: .dnsRules, index: 0)
            row.title = String.localizedString("import_dns_user_rules")
            row.imported = imported
            row.enabled = settings.dnsRulesStatus == .enabled
            row.setImportStatus(imported: imported, status: settings.dnsRulesStatus)
            
            rows.append(row)
        }
    }
    
    private func fillUserRules(_ imported: Bool) {
        
        let userRulesCount = settings.userRules?.count ?? 0
        if userRulesCount > 0 {
            var row = SettingRow(type: .userRules, index: 0)
            row.title = String.localizedString("import_user_rules")
            row.imported = imported
            row.enabled = settings.userRulesStatus == .enabled
            row.setImportStatus(imported: imported, status: settings.userRulesStatus)
            
            rows.append(row)
        }
    }
    
    private func fillLicense(_ imported: Bool) {
        
        if !Bundle.main.isPro && settings.license?.count ?? 0 > 0 {
            var row = SettingRow(type: .license, index: 0)
            let format = String.localizedString("import_license_format")
            row.title = String(format: format, settings.license!)
            row.imported = imported
            row.enabled = settings.licenseStatus == .enabled
            row.setImportStatus(imported: imported, status: settings.licenseStatus)
            
            rows.append(row)
        }
    }
    
    private func fillDns(_ imported: Bool) {
        
        if let serverId = settings.dnsServerId {
            var row = SettingRow(type: .dnsSettings, index: 0)
            
            let format = String.localizedString("import_dns_settings_format")
            let serverName = serverId == 0 ? String.localizedString("default_dns_server_name") : dnsProvidersService.getServerName(serverId: serverId)
            
            row.title = String(format:format, serverName ?? "")
            row.imported = imported
            row.enabled = settings.dnsStatus == .enabled
            row.setImportStatus(imported: imported, status: settings.dnsStatus)
            
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
            row.enabled = filter.status == .enabled
            row.setImportStatus(imported: imported, status: filter.status)
            
            rows.append(row)
            index += 1
        }
    }
    
    private func fillCustomCBFilters(_ imported: Bool) {
        
        var index = 0
        for filter in settings.customCbFilters ?? [] {
            let titleFormat = String.localizedString("import_custom_cb_filter_format")
            let title = String(format: titleFormat, filter.name)
            
            var row = SettingRow(type: .customCbFilter, index: index)
            
            row.title = title
            row.imported = imported
            row.enabled = filter.status == .enabled
            row.setImportStatus(imported: imported, status: filter.status)
            
            rows.append(row)
            index += 1
        }
    }
    
    fileprivate func fillCBFilters(_ imported: Bool) {
        
        var index = 0
        
        for filter in settings.defaultCbFilters ?? [] {
            var row = SettingRow(type: .cbFilter, index: index)
            let format = String.localizedString(filter.enable ? "enable_cb_filter_format" : "disable_cb_filter_format")
            
            let localizations = antibanner.filtersI18n()
            let filters = antibanner.filters()
            if let filterMeta = filters.first(where: { Int(truncating: $0.filterId) == filter.id }) {
                let localization = localizations.localization(forFilter: filterMeta)
                
                let name = localization?.name ?? ""
                row.title = String(format: format, name)
            }
            else {
                DDLogError("unknown filter")
            }
            
            row.imported = imported
            row.enabled = filter.status == .enabled
            row.setImportStatus(imported: imported, status: filter.status)
            
            rows.append(row)
            index += 1
        }
    }
}
