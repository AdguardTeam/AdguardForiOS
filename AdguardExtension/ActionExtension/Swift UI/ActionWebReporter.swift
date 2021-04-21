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

protocol ActionWebReporterProtocol {
    func composeWebReportUrl(_ site: URL?) -> URL
}

struct ActionWebReporter: ActionWebReporterProtocol {
    
    private let reportUrl = "https://reports.adguard.com/new_issue.html"
    
    private let productInfo: ADProductInfoProtocol
    private let antibanner: AESAntibannerProtocol
    private let complexProtection: ComplexProtectionServiceProtocol
    private let dnsProviders: DnsProvidersServiceProtocol
    private let configuration: ConfigurationServiceProtocol
    private let dnsFilters: DnsFiltersServiceProtocol
    
    init(productInfo: ADProductInfoProtocol,
         antibanner: AESAntibannerProtocol,
         complexProtection: ComplexProtectionServiceProtocol,
         dnsProviders: DnsProvidersServiceProtocol,
         configuration: ConfigurationServiceProtocol,
         dnsFilters: DnsFiltersServiceProtocol) {
        
        self.productInfo = productInfo
        self.antibanner = antibanner
        self.complexProtection = complexProtection
        self.dnsProviders = dnsProviders
        self.configuration = configuration
        self.dnsFilters = dnsFilters
    }
    
    
    func composeWebReportUrl(_ site: URL?) -> URL {
        var params: [String: String] = [:]
        
        if let site = site {
            params["url"] = site.absoluteString
        }
        
        params["product_type"] = "iOS"
        params["product_version"] = productInfo.version()
        params["browser"] = "Safari"
        
        let filterIDs = antibanner.activeFilterIDs().map { $0.stringValue }
        let filtersString = filterIDs.joined(separator: ".")
        
        params["filters"] = filtersString
        
        let dnsEnabled = complexProtection.systemProtectionEnabled
        
        params["dns.enabled"] = dnsEnabled ? "true" : "false"
        
        if (dnsEnabled){
            if let dnsServer = dnsProviders.activeDnsServer {
                params["dns.servers"] = dnsServer.upstreams.joined(separator: ",")
            }
            
            let filtersEnabled = configuration.advancedMode
            
            params["dns.filters_enabled"] = filtersEnabled ? "true" : "false"
            
            if filtersEnabled {
                let filters = dnsFilters.filters.filter { $0.enabled }
                let filterUrls = filters.compactMap { $0.subscriptionUrl }
                params["dns.filters"] = filterUrls.joined(separator: ",")
            }
        }
        
        let paramsString = ABECRequest.createString(fromParameters: params)
        let url = "\(reportUrl)?\(paramsString)"
        
        return URL(string: url)!
    }
}
