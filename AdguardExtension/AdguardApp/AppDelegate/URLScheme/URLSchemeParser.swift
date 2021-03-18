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


/* URL's that might be processed
 <adguardScheme> = adguard or adguard-pro
 
 1. <adguardScheme>:license=<LICENSE>                               <--- Activate license by URL
 2. <adguardScheme>://add/<RULE>                                    <--- Adding new user rule from safari
 3. <adguardScheme>://systemProtection/<VALUE ("on" or "off")>      <--- Turning on/off DNS protection from widget
 4. <adguardScheme>://complexProtection/<VALUE ("on" or "off")>     <--- Turning on/off complex protection from widget
 5. sdns://<DNSCrypt>                                               <--- Adding custom DNS server
 6. <adguardScheme>://apply_settings?json=<JSON>                    <--- Import settings
 7. abp://subscribe?location=<LOCATION URL>&title=<TITLE>           <--- Subscribe to custom safari filter
 8. <adguardScheme>://openTunnelModeSettings                        <--- Open Tunnel Mode settings
 9. adguard://auth#access_token=<TOKEN>&token_type=<TOKEN TYPE>&state=<STATE>&expires_in=<EXPIRES IN>   <--- Log in by social networks
 
 */

protocol IURLSchemeParser {
    func parse(url: URL) -> Bool
}

fileprivate enum StringConstants: String {
    case openSystemProtection = "systemProtection"
    case openComplexProtection = "complexProtection"
    case activateLicense = "license"
    case subscribe = "subscribe"
    case openTunnelModeSettings = "openTunnelModeSettings"
    case applySettings = "apply_settings"
    case authScheme = "auth"
    case sdnsScheme = "sdns"
    case urlScheme = "adguardScheme"
    case urlSchemeCommandAdd = "add"
    
    static func getStringConstant(string: String?) -> StringConstants? {
        guard let string = string else { return nil }
        
        if string == "adguard" || string == "adguard-pro" {
            return .urlScheme
        }
        
        guard let const = StringConstants(rawValue: string) else { return nil }
        return const
    }
}

struct URLSchemeParser: IURLSchemeParser {
    
    private let executor: IURLSchemeExecutor
    private let configurationService: ConfigurationServiceProtocol
    
    init(executor: IURLSchemeExecutor, configurationService: ConfigurationServiceProtocol) {
        self.executor = executor
        self.configurationService = configurationService
    }
    
    func parse(url: URL) -> Bool {
        let scheme = StringConstants.getStringConstant(string: url.scheme)
        var command = StringConstants.getStringConstant(string: url.host)
        if command == nil {
            command = StringConstants.getStringConstant(string: url.parseUrl().command)
        }
        
        if command == .activateLicense && Bundle.main.isPro {
            return false
        }
        
        switch (scheme, command) {
        // Adding new user rule from safari
        case (.urlScheme, .urlSchemeCommandAdd):
            DDLogInfo("(URLSchemeParser) openurl - adding new user rule from safari")
            let processor = OpenUserFilterControllerParser(executor: executor)
            return processor.parse(url)
            
        // Turning on/off DNS protection from widget
        case (.urlScheme, .openSystemProtection):
            DDLogInfo("(URLSchemeParser) openurl - turning on/off DNS protection from widget")
            let processor = OpenDnsSettingsControllerWithLaunchScreenParser(executor: executor)
            return processor.parse(url)
            
        // Turning on/off complex protection from widget
        case (.urlScheme, .openComplexProtection):
            DDLogInfo("(URLSchemeParser) openurl - turning on/off complex protection from widget")
            let processor = OpenMainPageControllerControllerWithLaunchScreenParser(executor: executor)
            return processor.parse(url)
            
        // Activate license by URL
        case (.urlScheme, .activateLicense):
            DDLogInfo("(URLSchemeParser) - activate license key from openUrl")
            let loginParser = OpenLoginControllerParser(executor: executor)
            if loginParser.parse(url) {
               return true
            }
            
            DDLogInfo("(URLSchemeParser) - update license from openUrl")
            let mainPageParser = OpenMainPageControllerParser(executor: executor)
            return mainPageParser.parse(url)
            
        // Adding custom DNS server
        case (.sdnsScheme, _):
            DDLogInfo("(URLSchemeParser) openurl sdns: \(url.absoluteString)")
            if !configurationService.proStatus {
                let processor = OpenDnsSettingsControllerParser(executor: executor)
                return processor.parse(url)
            } else {
                let processor = OpenDnsProvidersControllerParser(executor: executor)
                return processor.parse(url)
            }
        
        // Import settings
        case (.urlScheme, .applySettings):
            DDLogInfo("(URLSchemeParser) openurl - apply settings")
            let processor = OpenImportSettingsControllerParser(executor: executor)
            return processor.parse(url)
            
        // Subscribe to custom safari filter
        case (_, .subscribe):
            DDLogInfo("(URLSchemeParser) openurl - subscribe filter")
            let processor = OpenFiltersMasterControllerParser(executor: executor)
            return processor.parse(url)
        
        // Open Tunnel Mode settings
        case (_, .openTunnelModeSettings):
            DDLogInfo("(URLSchemeParser) openurl - open tunnel mode settings")
            let processor = OpenTunnelModeControllerParser(executor: executor)
            return processor.parse(url)

        // Log in by social networks
        case (.urlScheme, .authScheme):
            DDLogInfo("(URLSchemeParser) openurl - Log in by social networks")
            let processor = SocialNetworkAuthParametersParser(executor: executor)
            return processor.parse(url)
            
        default: return false
        }
    }
}
