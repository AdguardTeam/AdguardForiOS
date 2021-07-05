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
import AdGuardSDK

/** this class is responsible for applying the imported settings */
protocol ImportSettingsServiceProtocol {
    func applySettings(_ settings: Settings, callback: @escaping (Settings)->Void)
}

protocol ImportSettingsServiceDelegate {
    func applySettingsFinished()
}

class ImportSettingsService: ImportSettingsServiceProtocol {
    
    private let networking: ACNNetworkingProtocol
    private let dnsFiltersService: DnsFiltersServiceProtocol
    private let dnsProvidersService: DnsProvidersServiceProtocol
    private let purchaseService: PurchaseServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let safariProtection: SafariProtectionProtocol
    
    init(networking: ACNNetworkingProtocol, dnsFiltersService: DnsFiltersServiceProtocol, dnsProvidersService: DnsProvidersServiceProtocol, purchaseService: PurchaseServiceProtocol, resources: AESharedResourcesProtocol, safariProtection: SafariProtectionProtocol) {
        self.networking = networking
        self.dnsFiltersService = dnsFiltersService
        self.dnsProvidersService = dnsProvidersService
        self.purchaseService = purchaseService
        self.resources = resources
        self.safariProtection = safariProtection
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
        
        // todo: add to sdk
        let customFilters = [SafariFilterProtocol]() //filtersService.groups.filter { $0.groupId == AdGuardFilterGroup.custom.rawValue }.flatMap { $0.filters }
        let customDnsFilters = dnsFiltersService.filters
        
        let customCbFilters = settings.customCbFilters?.uniqueElements { $0.url }
        let dnsCustomFilters = settings.dnsFilters?.uniqueElements { $0.url }

        var uniqueCBFilterSettings = [CustomCBFilterSettings]()
        var uniqueCustomDnsFilterSettings = [DnsFilterSettings]()
        
        // custom cb filters
        if let cbFilters = customCbFilters {
            guard let uniqueFilters = uniqueCustomFilterSettings(filters: customFilters, filterSettings: cbFilters) as? [CustomCBFilterSettings] else { return }
            uniqueCBFilterSettings = uniqueFilters
        }
    
        for var filter in uniqueCBFilterSettings {
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
        
        // custom dns filters
        
        if let dnsFilters = dnsCustomFilters {
            // todo:
//            guard let uniqueFilters = uniqueCustomFilterSettings(filters: customDnsFilters, filterSettings: dnsFilters) as? [DnsFilterSettings] else { return }
//            uniqueCustomDnsFilterSettings = uniqueFilters
        }
        
        
        let resultDnsFilters = applyDnsFilters(uniqueCustomDnsFilterSettings, override: settings.overrideDnsFilters ?? false)
        resultSettings.dnsFilters = resultDnsFilters
        
        // set dns server
        if let dnsServerId = settings.dnsServerId {
            if settings.dnsStatus == .enabled {
                setDnsServer(serverId: dnsServerId)
                resultSettings.dnsStatus = .successful
            }
        }
        
        // license
        if let license = settings.license {
            if !Bundle.main.isPro && settings.licenseStatus == .enabled {
                group.enter()
                purchaseService.login(withLicenseKey: license) { (success) in
                    resultSettings.licenseStatus = success ? .successful :.unsuccessful
                    group.leave()
                }
                group.wait()
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
            // todo: add to sdk
//            disable all filters
        }
        
        var resultFilters: [DefaultCBFilterSettings] = []
        
        let allFilters = safariProtection.groups.flatMap { $0.filters }
        for var filter in filters ?? [] {
            if filter.status == .enabled {

                let cbFilter = allFilters.first { $0.filterId == filter.id }
                
                if cbFilter != nil {
                    safariProtection.setFilter(withId: cbFilter!.filterId, cbFilter!.group.groupId, enabled: filter.enable) { error in
                        //todo:
                    }
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
        
        guard let url = URL(string: filter.url) else {
            DDLogError("import custom cb filter error - can not parse url: \(filter.url)")
            callback(false)
            return
        }
        
        // todo: add custom filter from url
//        parser.parse(from: url, networking: networking) { [weak self]  (result, error) in
//            guard let self = self else { return }
//
//            if let parserError = error {
//                DDLogError("import custom cb filter error: \(parserError.localizedDescription)")
//                callback(false)
//                return
//            }
//
//            if let parserResult = result {
//                if !filter.name.isEmpty {
//                    parserResult.meta.name = filter.name
//                }
//                self.filtersService.addCustomFilter(parserResult, protectionEnabled: self.safariProtection.safariProtectionEnabled, userFilterEnabled: self.resources.safariUserFilterEnabled, whitelistEnabled: self.resources.safariWhitelistEnabled, invertedWhitelist: self.resources.invertedWhitelist)
//                callback(true)
//                return
//            }
//
//            callback(false)
//        }
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
        
        let agRules = (rules ?? []).map { UserRule(ruleText: $0)}
        safariProtection.add(rules: agRules, for: .blocklist, override: override) { error in
            // todo:
        }
    }
    
    private func uniqueCustomFilterSettings(filters: [SafariFilterProtocol], filterSettings: [CustomCBFilterSettings] ) -> [Any] {
        var result = [CustomCBFilterSettings]()
        for cbFilter in filterSettings {
            if !filters.contains(where: { $0.filterDownloadPage == cbFilter.url }) {
                result.append(cbFilter)
            }
        }
        return result
    }
}
