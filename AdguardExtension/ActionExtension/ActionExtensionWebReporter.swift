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

protocol ActionExtensionWebReporterProtocol {
    func composeWebReportUrl(_ url: URL) -> URL
}

struct ActionExtensionWebReporter: ActionExtensionWebReporterProtocol {
    
    private let reportUrl = "https://reports.adguard.com/new_issue.html"
    
    private let safariProtection: SafariProtectionProtocol
    
    init(safariProtection: SafariProtectionProtocol) {
        self.safariProtection = safariProtection
    }
    
    func composeWebReportUrl(_ url: URL) -> URL {
        var params: [String: String] = [
            "url": url.absoluteString,
            "product_type": "iOS",
            "product_version": ADProductInfo().version(),
            "browser": "Safari"
        ]
        
        var enabledFiltersIdsString = ""
        for group in safariProtection.groups {
            if !group.isEnabled { continue }
            
            for filter in group.filters {
                if !filter.isEnabled { continue }
                
                if enabledFiltersIdsString.isEmpty {
                    enabledFiltersIdsString = "\(filter.filterId)"
                } else {
                    enabledFiltersIdsString += ".\(filter.filterId)"
                }
            }
        }
        params["filters"] = enabledFiltersIdsString
        
        
        let paramsString = ABECRequest.createString(fromParameters: params)
        let url = "\(reportUrl)?\(paramsString)"
        
        return URL(string: url)!
    }
}
