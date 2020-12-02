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

/** this class is responsible for applying the imported settings */
protocol ImportSettingsServiceProtocol {
    func applySettings(_ settings: Settings, callback: @escaping (Settings)->Void)
}

protocol ImportSettingsServiceDelegate {
    func applySettingsFinished()
}

class ImportSettingsService: ImportSettingsServiceProtocol {
    
    private let antibanner: AESAntibannerProtocol
    private let networking: ACNNetworkingProtocol
    private let filtersService: FiltersServiceProtocol
    private let dnsFiltersService: DnsFiltersServiceProtocol
    private let dnsProvidersService: DnsProvidersServiceProtocol
    private let purchaseService: PurchaseServiceProtocol
    private let contentBlockerService: ContentBlockerServiceProtocol
    
    init(antibanner: AESAntibannerProtocol, networking: ACNNetworkingProtocol, filtersService: FiltersServiceProtocol, dnsFiltersService: DnsFiltersServiceProtocol, dnsProvidersService: DnsProvidersServiceProtocol, purchaseService: PurchaseServiceProtocol, contentBlockerService: ContentBlockerServiceProtocol) {
        self.antibanner = antibanner
        self.networking = networking
        self.filtersService = filtersService
        self.dnsFiltersService = dnsFiltersService
        self.dnsProvidersService = dnsProvidersService
        self.purchaseService = purchaseService
        self.contentBlockerService = contentBlockerService
    }
    
    func applySettings(_ settings: Settings, callback: @escaping (Settings) -> Void) {
        DispatchQueue(label: "import settings queue").async { [weak self] in
            self?.applySettingsSync(settings, callback: callback)
        }
    }
        
    private func applySettingsSync(_ settings: Settings, callback: (Settings) -> Void) {
        
        var resultSettings = settings
        
        // cb filters
        
        let resultFilters = applyCBFilters(settings.defaultCbFilters, override: settings.overrideCbFilters ?? false)
        
        let group = DispatchGroup()
        
        resultSettings.defaultCbFilters = resultFilters
        
        var resultCbFilters:[CustomCBFilterSettings] = []
        
        // custom cb filters
        for var filter in settings.customCbFilters ?? [] {
            if filter.status == .enabled {
                group.enter()
                subscribeCustomCBFilter(filter) { (success) in
                    filter.status = success ? .successful : .unsuccessful
                    resultCbFilters.append(filter)
                    group.leave()
                }
            }
            else {
                resultCbFilters.append(filter)
            }
        }
        
        group.wait()
        
        resultSettings.customCbFilters = resultCbFilters
        
        // dns filters
        
        if let dnsFilters = settings.dnsFilters {
            let resultDnsFilters = applyDnsFilters(dnsFilters, override: settings.overrideDnsFilters ?? false)
            resultSettings.dnsFilters = resultDnsFilters
        }
        
        // set dns server
        if let dnsServerId = settings.dnsServerId {
            if settings.dnsStatus == .enabled {
                setDnsServer(serverId: dnsServerId)
                resultSettings.dnsStatus = .successful
            }
        }
        
        // license
        if let license = settings.license {
            if settings.licenseStatus == .enabled {
                purchaseService.login(withLicenseKey: license)
                resultSettings.licenseStatus = .successful
            }
        }
        
        // user rules
        if settings.userRulesStatus == .enabled {
            applyCbRules(settings.userRules, override: settings.overrideUserRules ?? false)
            resultSettings.userRulesStatus = .successful
        }
        
        // dns rules
        if settings.dnsRulesStatus == .enabled {
            applyDnsRules(settings.dnsUserRules, override: settings.overrideDnsUserRules ?? false)
            resultSettings.dnsRulesStatus = .successful
        }
        
        // tada
        callback(resultSettings)
    }
    
    private func applyCBFilters(_ filters: [DefaultCBFilterSettings]?, override: Bool)-> [DefaultCBFilterSettings]{
        
        if override {
            filtersService.disableAllFilters()
        }
        
        var resultFilters: [DefaultCBFilterSettings] = []
        
        let allFilters = filtersService.groups.flatMap { $0.filters }
        for var filter in filters ?? [] {
            if filter.status == .enabled {

                let cbFilter = allFilters.first { $0.filterId == filter.id }
                
                if cbFilter != nil {
                    filtersService.setFilter(cbFilter!, enabled: filter.enable)
                    filter.status = .successful
                }
                else {
                    filter.status = .unsuccessful
                }
            }
            
            resultFilters.append(filter)
        }
        
        return resultFilters
    }
    
    private func subscribeCustomCBFilter(_ filter: CustomCBFilterSettings, callback: @escaping (Bool)->Void) {
        
        let parser = AASFilterSubscriptionParser()
        guard let url = URL(string: filter.url) else {
            DDLogError("import custom cb filter error - can not parse url: \(filter.url)")
            callback(false)
            return
        }
        
        parser.parse(from: url, networking: networking) { [weak self]  (result, error) in
            guard let self = self else { return }
            
            if let parserError = error {
                DDLogError("import custom cb filter error: \(parserError.localizedDescription)")
                callback(false)
                return
            }

            if let parserResult = result {
                if filter.name.count > 0 {
                    parserResult.meta.name = filter.name
                }
                self.filtersService.addCustomFilter(parserResult)
                callback(true)
                return
            }
            
            callback(false)
        }
    }
    
    private func applyDnsFilters(_ filters: [DnsFilterSettings], override: Bool)->[DnsFilterSettings] {
        
        if override {
            dnsFiltersService.disableAllFilters()
        }
        
        var resultDnsFilters: [DnsFilterSettings] = []
        
        let group = DispatchGroup()
        for var filter in filters {
            
            if filter.status == .enabled {
                group.enter()
                
                subscribeDnsFilter(filter) { (success) in
                    filter.status = success ? .successful : .unsuccessful
                    resultDnsFilters.append(filter)
                    group.leave()
                }
            }
            else {
                resultDnsFilters.append(filter)
            }
        }
        
        group.wait()
        
        return resultDnsFilters
    }
    
    private func subscribeDnsFilter(_ filter: DnsFilterSettings, callback: @escaping (Bool)->Void) {
        
        guard let url = URL(string: filter.url) else {
            callback(false)
            return
        }
        dnsFiltersService.addFilter(name: filter.name, url: url, networking: networking) { (success) in
            callback(success)
        }
    }
    
    private func setDnsServer(serverId: Int) {
        
        let server = dnsProvidersService.getServer(serverId: serverId)
        dnsProvidersService.activeDnsServer = server
    }
    
    func applyDnsRules(_ rules: [String]?, override: Bool) {
        
        if override {
            dnsFiltersService.userRules = []
        }
        
        if let dnsRules = rules {
            for rule in dnsRules {
                dnsFiltersService.addBlacklistRule(rule)
            }
        }
    }
    
    func applyCbRules(_ rules: [String]?, override: Bool) {
        
        if override {
            antibanner.disableUserRules()
        }
        
        for rule in rules ?? [] {
            let agRule = ASDFilterRule(text: rule, enabled: true)
            agRule.filterId = ASDF_USER_FILTER_ID as NSNumber
            antibanner.add(agRule)
        }
    }
}
