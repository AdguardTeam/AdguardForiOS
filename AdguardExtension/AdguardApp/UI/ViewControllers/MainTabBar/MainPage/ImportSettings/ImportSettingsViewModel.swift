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

struct SettingRow {
    var enabled: Bool = true
    var imported: Bool = false
    var successful: Bool = false
    var title: String = ""
    var subtitle: String = ""
    
    var type: ImportRowType
    var index: Int
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
    
    init(settings: Settings, importSettingsService: ImportSettingsServiceProtocol, antibanner: AESAntibannerProtocol) {
        self.settings = settings
        self.importService = importSettingsService
        self.antibanner = antibanner
        
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
        
        var index = 0
        
        // cb Filters
        for filter in settings.defaultCbFilters ?? [] {
            var row = SettingRow(type: .cbFilter, index: index)
            let format = String.localizedString("import_cb_filter_format")
            
            let localizations = antibanner.filtersI18n()
            let metagata = antibanner.metadata(forSubscribe: false)
            if let filterMeta = metagata?.filters?.first { Int($0.filterId) == filter.id } {
                let localization = localizations.localization(forFilter: filterMeta)
                
                let name = localization?.name ?? ""
                row.title = String(format: format, name)
            }
            else {
                DDLogError("unknown filter")
            }
            
            row.imported = imported
            row.enabled = filter.status == .enabled
            row.successful = imported && filter.status == .successful
            
            if imported && filter.status == .unsuccessful {
                row.subtitle = String.localizedString("import_unseccuessful")
            }
            
            rows.append(row)
            index += 1
        }
        
        // custom cb filters
        
        index = 0
        for filter in settings.customCbFilters ?? [] {
            let titleFormat = String.localizedString("import_custom_cb_filter_format")
            let title = String(format: titleFormat, filter.name)
            
            var row = SettingRow(type: .customCbFilter, index: index)
            
            row.title = title
            row.imported = imported
            row.enabled = filter.status == .enabled
            row.successful = imported && filter.status == .successful
            
            if imported && filter.status == .unsuccessful {
                row.subtitle = String.localizedString("import_unseccuessful")
            }
            
            rows.append(row)
            index += 1
        }
        
        // dns filters
        
        index = 0
        for filter in settings.dnsFilters ?? [] {
        
            let titleFormat = String.localizedString("import_dns_filter_format")
            let title = String(format: titleFormat, filter.name)
            var row = SettingRow(type: .dnsFilter, index: index)
        
            row.title = title
            row.imported = imported
            row.enabled = filter.status == .enabled
            row.successful = imported && filter.status == .successful

            if imported && filter.status == .unsuccessful {
                row.subtitle = String.localizedString("import_unseccuessful")
            }
            
            rows.append(row)
            index += 1
        }
        
        // dns settings
        
        if settings.dnsSetting != nil {
            var row = SettingRow(type: .dnsSettings, index: 0)
            let format = String.localizedString("import_dns_settings_format")
            
            // TODO: get dns server name
            let name = "name"
            row.title = String(format:format, name)
            row.imported = imported
            row.enabled = settings.dnsStatus == .enabled
            row.successful = imported && settings.dnsStatus == .successful
            
            if imported && settings.dnsStatus == .unsuccessful {
                row.subtitle = String.localizedString("import_unseccuessful")
            }
            
            rows.append(row)
        }
        
        // license
        
        if settings.license?.count ?? 0 > 0 {
            var row = SettingRow(type: .license, index: 0)
            let format = String.localizedString("import_license_format")
            row.title = String(format: format, settings.license!)
            row.imported = imported
            row.enabled = settings.licenseStatus == .enabled
            row.successful = imported && settings.licenseStatus == .successful
            
            if imported && settings.licenseStatus == .unsuccessful {
                row.subtitle = String.localizedString("import_unseccuessful")
            }
            
            rows.append(row)
        }
        
        // user rules
        
        let userRulesCount = settings.userRules?.count ?? 0
        let whitelistRulesCount = settings.allowlistRules?.count ?? 0
        if userRulesCount + whitelistRulesCount > 0 {
            var row = SettingRow(type: .userRules, index: 0)
            row.title = String.localizedString("import_user_rules")
            row.imported = imported
            row.enabled = settings.userRulesStatus == .enabled
            row.successful = imported && settings.userRulesStatus == .successful
            
            if imported && settings.userRulesStatus == .unsuccessful {
                row.subtitle = String.localizedString("import_unseccuessful")
            }
            
            rows.append(row)
        }
        
        // dns rules
        
        if settings.dnsUserRules?.count ?? 0 > 0 {
            var row = SettingRow(type: .dnsRules, index: 0)
            row.title = String.localizedString("import_dns_user_rules")
            row.imported = imported
            row.enabled = settings.dnsRulesStatus == .enabled
            row.successful = imported && settings.dnsRulesStatus == .successful
            
            if imported && settings.dnsRulesStatus == .unsuccessful {
                row.subtitle = String.localizedString("import_unseccuessful")
            }
            
            rows.append(row)
        }
    }
}
