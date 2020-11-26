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
        
        var resultFilters: [DefaultCBFilterSettings] = []
        for var filter in settings.defaultCbFilters ?? [] {
            if filter.status == .enabled {

                let cbFilter = filtersService.groups.flatMap { (group) -> [Filter] in
                    return group.filters
                }.first {
                    $0.filterId == filter.id
                }
                
                if cbFilter != nil {
                    filtersService.setFilter(cbFilter!, enabled: true)
                }
                else {
                    filter.status = .unsuccessful
                }
            }
            
            filter.status = .successful
            
            resultFilters.append(filter)
        }
        
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
        
        var resultDnsFilters: [DnsFilterSettings] = []
        
        for var filter in settings.dnsFilters ?? [] {
            
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
        
        resultSettings.dnsFilters = resultDnsFilters
        
        // set dns server
        if let dnsSettings = settings.dnsSetting {
            if settings.dnsStatus == .enabled {
                setDnsServer(dnsSettings: dnsSettings)
            }
            
            resultSettings.dnsStatus = .successful
        }
        
        // license
        if let license = settings.license {
            if settings.licenseStatus == .enabled {
                purchaseService.login(withLicenseKey: license)
            }
            
            resultSettings.licenseStatus = .successful
        }
        
        // user rules
        if let rules = settings.userRules {
            if settings.userRulesStatus == .enabled {
                let agRules = rules.map { ASDFilterRule(text: $0, enabled: true) }
                
                antibanner.import(agRules, filterId: NSNumber(value: ASDF_USER_FILTER_ID))
            }
            
            resultSettings.userRulesStatus = .successful
        }
        
        // whitelistRules
        if let rules = settings.allowlistRules {
            if settings.userRulesStatus == .enabled {
                for rule in rules {
                    group.enter()
                    contentBlockerService.addWhitelistDomain(rule) { (error) in
                        group.leave()
                    }
                }
                
                group.wait()
                
                resultSettings.userRulesStatus = .successful
            }
        }
        
        
        
        // dns rules
        if let dnsRules = settings.dnsUserRules, settings.dnsRulesStatus == .enabled {
            for rule in dnsRules {
                dnsFiltersService.addBlacklistRule(rule)
            }
        }
        
        resultSettings.dnsRulesStatus = .successful
        
        // tada
        callback(resultSettings)
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
                self.filtersService.addCustomFilter(parserResult)
                callback(true)
                return
            }
            
            callback(false)
        }
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
    
    private func setDnsServer(dnsSettings: DnsFilteringSettings) {
        let providerId: Int
        switch dnsSettings.name ?? .adguardDefault {
        case .adguardDefault:
            providerId = DnsProvidersService.adguardId
        case .adguardFamily:
            providerId = DnsProvidersService.adguardFamilyId
        case .adguardNonFiltering:
            providerId = DnsProvidersService.adguardNonFilteredId
        }
        
        let dnsProtocol: DnsProtocol
        switch dnsSettings.dnsProtocol ?? .doh {
        case .dns:
            dnsProtocol = .dns
        case .dnsCrypt:
            dnsProtocol = .dnsCrypt
        case .doh:
            dnsProtocol = .doh
        case .doq:
            dnsProtocol = .doq
        case .dot:
            dnsProtocol = .dot
        }
        let provider = dnsProvidersService.allProviders.first { $0.id == providerId }
        let server = provider?.servers?.first { $0.dnsProtocol == dnsProtocol }
        
        dnsProvidersService.activeDnsServer = server
    }
}
