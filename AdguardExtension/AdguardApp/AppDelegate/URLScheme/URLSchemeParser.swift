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
}

struct URLSchemeParser: IURLSchemeParser {
    
    private let executor: IURLSchemeExecutor
    private let configurationService: ConfigurationServiceProtocol
    
    init(executor: IURLSchemeExecutor, configurationService: ConfigurationServiceProtocol) {
        self.executor = executor
        self.configurationService = configurationService
    }
    
    func parse(url: URL) -> Bool {
        var command: StringConstants!
        var params: [String: Any]?
        let scheme = getStringConstant(string: url.scheme)
        
        if let host = url.host {
            if scheme == .sdnsScheme {
                command = .sdnsScheme
            } else {
                guard let const = getStringConstant(string: host) else { return false }
                command = const
            }
            params = getParameters(from: url, for: command)
            
        } else {
            let result = url.parseUrl()
            guard let const = getStringConstant(string: result.command) else { return false }
            command = const
            params = result.params
        }
        
        if command == .activateLicense && Bundle.main.isPro {
            return false
        }
        
        switch (scheme, command) {
        // Adding new user rule from safari
        case (.urlScheme, .urlSchemeCommandAdd):
            let rule = String(url.path.suffix(url.path.count - 1))
            guard !rule.isEmpty else { return false }
            let processor = OpenUserFilterControllerProcessor(executor: executor)
            return processor.process(parameters: ["rule": rule])
            
        // Turning on/off DNS protection from widget
        case (.urlScheme, .openSystemProtection):
            let showLaunchScreen = true
            guard let enabled = protectionStateIsEnabled(url: url) else { return false }
            let processor = OpenDnsSettingsControllerProcessor(executor: executor)
            return processor.process(parameters: ["showLaunchScreen": showLaunchScreen, "dnsProtectionIsEnabled": enabled])
            
        // Turning on/off complex protection from widget
        case (.urlScheme, .openComplexProtection):
            let showLaunchScreen = true
            guard let enabled = protectionStateIsEnabled(url: url) else { return false }
            let processor = OpenMainPageControllerProcessor(executor: executor)
            return processor.process(parameters: ["showLaunchScreen": showLaunchScreen, "complexProtectionIsEnabled": enabled])
            
        // Activate license by URL
        case (.urlScheme, .activateLicense):
            DDLogInfo("(URLSchemeParser) - activate license key from openUrl")
            if let license = params?["license"] as? String, !license.isEmpty {
                DDLogInfo("(URLSchemeParser) - activate license key from openUrl")
                let showLaunchScreen = true
                let processor = OpenLoginControllerProcessor(executor: executor)
                return processor.process(parameters: ["showLaunchScreen": showLaunchScreen, "license": license])
            } else {
                DDLogInfo("(URLSchemeParser) - update license from openUrl")
                let showLaunchScreen = false
                let processor = OpenMainPageControllerProcessor(executor: executor)
                return processor.process(parameters: ["showLaunchScreen": showLaunchScreen])
            }
            
        // Adding custom DNS server
        case (.sdnsScheme, _):
            DDLogInfo("(URLSchemeParser) openurl sdns: \(url.absoluteString)")
            if !configurationService.proStatus {
                let showLaunchScreen = false
                let processor = OpenDnsSettingsControllerProcessor(executor: executor)
                return processor.process(parameters: ["showLaunchScreen": showLaunchScreen])
            } else {
                let showLaunchScreen = false
                let processor = OpenDnsProvidersControllerProcessor(executor: executor)
                return processor.process(parameters: ["showLaunchScreen": showLaunchScreen ,"UrlAbsoluteString": url.absoluteString])
            }
        
        // Import settings
        case (.urlScheme, .applySettings):
            DDLogInfo("(URLSchemeParser) openurl - apply settings")
            guard let json = params?["json"] as? String, !json.isEmpty else {
                DDLogError("(URLSchemeParser) there is no param 'json' in url")
                return false
            }
            let showLaunchScreen = true
            let processor = OpenImportSettingsControllerProcessor(executor: executor)
            return processor.process(parameters: ["showLaunchScreen": showLaunchScreen, "json": json])
            
        // Subscribe to custom safari filter
        case (_, .subscribe):
            DDLogInfo("(URLSchemeParser) openurl - subscribe filter")
            guard var params = params else { return false }
            let showLaunchScreen = true
            params["showLaunchScreen"] = showLaunchScreen
            let processor = OpenFiltersMasterControllerProcessor(executor: executor)
            return processor.process(parameters: params)
        
        // Open Tunnel Mode settings
        case (_, .openTunnelModeSettings):
            DDLogInfo("(URLSchemeParser) openurl - open tunnel mode settings")
            let showLaunchScreen = false
            let processor = OpenTunnelModeControllerProcessor(executor: executor)
            return processor.process(parameters: ["showLaunchScreen": showLaunchScreen])

        // Log in by social networks
        case (.urlScheme, .authScheme):
            DDLogInfo("(URLSchemeParser) openurl - Log in by social networks")
            guard let params = params else { return false }
            let processor = SocialNetworkAuthParametersProcessor(executor: executor)
            return processor.process(parameters: params)
            
        default: return false
        }
    }
    
    private func getParameters(from url: URL, for command: StringConstants) -> [String: Any]? {
        switch command {
        case .authScheme:
            return url.parseAuthUrl().params
        default:
            return url.parseUrl().params
        }
    }
    
    private func getStringConstant(string: String?) -> StringConstants? {
        guard let string = string else { return nil }
        
        if string == "adguard" || string == "adguard-pro" {
            return .urlScheme
        }
        
        guard let const = StringConstants(rawValue: string) else { return nil }
        return const
    }
    
    private func protectionStateIsEnabled(url: URL) -> Bool? {
        let suffix = String(url.path.suffix(url.path.count - 1))
        let parameters = suffix.split(separator: "/")
        
        let enabledString = String(parameters.first ?? "")
        let isSufixValid = enabledString == "on" || enabledString == "off"
        if isSufixValid {
            return enabledString == "on"
        }
        return nil
    }
    
}
