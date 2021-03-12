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

struct URLSchemeProcessor {
    
    //MARK: - String Constants
    
    private let openSystemProtection = "systemProtection"
    private let openComplexProtection = "complexProtection"
    private let activateLicense = "license"
    private let subscribe = "subscribe"
    private let openTunnelModeSettings = "openTunnelModeSettings"
    private let applySettings = "apply_settings"
    private let commonUrlScheme = "adguard"
    private let authScheme = "auth"
    private let socialErrorUserNotFound = "user_not_found"
    
    //MARK: - Properties
    
    private let appDelegate: AppDelegate
    private let antibannerController: AntibannerControllerProtocol
    private let resources: AESharedResourcesProtocol
    private let contentBlockerService: ContentBlockerService
    private let antibanner: AESAntibannerProtocol
    private let themeService: ThemeServiceProtocol
    private let productInfo: ADProductInfoProtocol
    private let purchaseService: PurchaseServiceProtocol
    private let configuration: ConfigurationService
    private let setappService: SetappServiceProtocol
        
    //MARK: - Init
    
    init(appDelegate: AppDelegate,
         antibannerController: AntibannerControllerProtocol,
         resources: AESharedResourcesProtocol,
         contentBlockerService: ContentBlockerService,
         antibanner: AESAntibannerProtocol,
         themeService: ThemeServiceProtocol,
         productInfo: ADProductInfoProtocol,
         purchaseService: PurchaseServiceProtocol,
         configuration: ConfigurationService,
         setappService: SetappServiceProtocol) {
        
        self.appDelegate = appDelegate
        self.antibannerController = antibannerController
        self.resources = resources
        self.contentBlockerService = contentBlockerService
        self.antibanner = antibanner
        self.themeService = themeService
        self.productInfo = productInfo
        self.purchaseService = purchaseService
        self.configuration = configuration
        self.setappService = setappService
    }
    
    //MARK: - Public methods
    
    func proccess(url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DDLogError("(URLSchemeProcessor) application Open URL: \(url.absoluteURL)");
        
        if !Bundle.main.isPro {
            if setappService.openUrl(url, options: options) {
                return true
            }
        }
            
        var command: String?
        var params: [String: String]?
        
        if url.host != nil {
            command = url.host!
            if command == authScheme {
                let result = url.parseAuthUrl()
                params = result.params
            } else if command == subscribe {
                let result = url.parseUrl()
                params = result.params
            }
        } else {
            let result = url.parseUrl()
            command = result.command
            params = result.params
        }
        
        if command == activateLicense && Bundle.main.isPro {
            return false
        }

        let success = process(url: url, command: command, params: params)
        return success
    }
    
    //MARK: - Private methods
    
    private func process(url: URL , command: String?, params: [String: String]?) -> Bool {
        let scheme = url.scheme
        
        /*
         When we open an app from action extension we show user a launch screen, while view controllers are being loaded, when they are, we show UserFilterController. It is done by changing app's window.
         https://github.com/AdguardTeam/AdguardForiOS/issues/1135
        */
        switch (scheme, command) {
        
        // Adding new user rule from safari
        case (AE_URLSCHEME, AE_URLSCHEME_COMMAND_ADD) :
            antibannerController.onReady { antibanner in
                DispatchQueue.main.async {
                    let model: ListOfRulesModelProtocol = UserFilterModel(resources: self.resources, contentBlockerService: self.contentBlockerService, antibanner: self.antibanner, theme: self.themeService, productInfo: self.productInfo)
                    let rule = String(url.path.suffix(url.path.count - 1))
                    appDelegate.presentUserFilterController(showLaunchScreen: true, model, newRule: rule)
                }
            }
            return true
            
        // Turning on/off DNS protection from widget
        case (AE_URLSCHEME, openSystemProtection):
            let suffix = String(url.path.suffix(url.path.count - 1))
            let parameters = suffix.split(separator: "/")
            
            let enabledString = String(parameters.first ?? "")
            let enabled = enabledString == "on"
            
            let success = appDelegate.presentDnsSettingsController(showLaunchScreen: true, dnsProtectionIsEnabled: enabled)
            return success
            
        // Turning on/off complex protection from widget
        case (AE_URLSCHEME, openComplexProtection):
            let suffix = String(url.path.suffix(url.path.count - 1))
            let parameters = suffix.split(separator: "/")
            
            let enabledString = String(parameters.first ?? "")
            let enabled = enabledString == "on"
            
            let success = appDelegate.presentMainPageController(showLaunchScreen: true, complexProtectionIsEnabled: enabled)
            return success
        
        // Activate license by URL
        case (AE_URLSCHEME, activateLicense):
            DDLogInfo("(URLSchemeProcessor) - activate license key from openUrl")
            let license = params?["license"]
            
            if license == nil || license!.isEmpty {
                DDLogInfo("(URLSchemeProcessor) - update license from openUrl")
                purchaseService.checkLicenseStatus()
                let success = appDelegate.presentMainPageController()
                return success
            } else {
                DDLogInfo("(URLSchemeProcessor) - activate license key from openUrl")
                let success = appDelegate.presentLoginController(showLaunchScreen: true, withLicenseKey: license)
                return success
            }
        
        // Adding custom DNS server
        case (AE_SDNS_SCHEME, _):
            DDLogInfo("(URLSchemeProcessor) openurl sdns: \(url.absoluteString)")
            if !configuration.proStatus {
                let success = appDelegate.presentDnsSettingsController()
                return success
            } else {
                let dnsInfo = DnsResolver.resolve(upstream: url.absoluteString)
                guard let dnsServer = dnsInfo.dnsServer else {
                    return false
                }
                let success = appDelegate.presentDnsProvidersController(url: dnsServer)
                return success
            }
            
        case (commonUrlScheme, applySettings):
            DDLogInfo("(URLSchemeProcessor) openurl - apply settings")
            let params = url.parseUrl().params
            guard let json = params?["json"] else {
                DDLogError("(URLSchemeProcessor) there is no param 'json' in url")
                return false
            }
            let parser = SettingsParser()
            let settings = parser.parse(querry: json)
            let success = appDelegate.presentImportSettingsController(showLaunchScreen: true, settings: settings)
            return success
        
        // Subscribe to custom filter
        case (_, subscribe):
            DDLogInfo("(URLSchemeProcessor) openurl - subscribe filter")
            
            let url = params?["location"]?.removingPercentEncoding
            let title = params?["title"]?.removingPercentEncoding
            
            let success = appDelegate.presentFiltersMasterController(showLaunchScreen: true, url: url, title: title)
            return success
            
        case (_, openTunnelModeSettings):
            DDLogInfo("(URLSchemeProcessor) openurl - open tunnel mode settings")
            configuration.advancedMode = true
            let success = appDelegate.presentTunnelModeController()
            return success
            
        // Log in by social networks
        case (commonUrlScheme, authScheme):
            DDLogInfo("(URLSchemeProcessor) openurl - Log in by social networks")
            if let error = params?["error"] {
                socialLoginErrorProcessor(error: error)
                return false
            } else {
                let token = params?["access_token"]
                let state = params?["state"]
                purchaseService.login(withAccessToken: token, state: state)
                return true
            }

            
        default: return false
        }
    }
    
    private func socialLoginErrorProcessor(error: String) {
        var userInfo = [AnyHashable: Any]()
        DDLogInfo("(URLSchemeProcessor) Social login error: \(error)")
        switch error {
        case socialErrorUserNotFound:
            userInfo[PurchaseService.kPSNotificationTypeKey] = PurchaseService.kPSNotificationLoginUserNotFound
            userInfo[PurchaseService.kPSNotificationErrorKey] = NSError(domain: LoginService.loginErrorDomain, code: LoginService.socialUserNotFound, userInfo: nil)
            
        default:
            break
        }
        NotificationCenter.default.post(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: self, userInfo: userInfo)

    }
}
