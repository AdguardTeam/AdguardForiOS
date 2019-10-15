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

/**
 AppDelegateHelper is a helper class for AppDelegate
 all new functions we must write in this swift class instead of old obj-c AppDelegate
 */

@objcMembers
class AppDelegateHelper: NSObject {
    
    let appDelegate: AppDelegate
    lazy var userNotificationService: UserNotificationServiceProtocol =  { ServiceLocator.shared.getService()! }()
    
    lazy var aeService: AEServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var resources: AESharedResourcesProtocol = { ServiceLocator.shared.getService()! }()
    lazy var themeService: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var contentBlockerService: ContentBlockerService = { ServiceLocator.shared.getService()! }()
    lazy var dnsFiltersService: DnsFiltersServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    var purchaseObservation: Any?
    let antibanner: AESAntibannerProtocol
    let resources: AESharedResourcesProtocol
    let purchaseService: PurchaseServiceProtocol
    
    private var firstRun: Bool {
        get {
            resources.sharedDefaults().object(forKey: AEDefaultsFirstRunKey) as? Bool ?? true
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsFirstRunKey)
        }
    }
    @objc
    init(antibanner: AESAntibannerProtocol, resources: AESharedResourcesProtocol, purchaseService: PurchaseService) {
        self.antibanner = antibanner
        self.resources = resources
        self.purchaseService = purchaseService
        super.init()
    }
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        super.init()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // request permission for user notifications posting
        userNotificationService.requestPermissions()
        
        addPurchaseStatusObserver()
        
        if (firstRun) {
            AESProductSchemaManager.install()
            purchaseService.checkLicenseStatus()
        } else {
            AESProductSchemaManager.upgrade(withAntibanner: antibanner)
        }
        
        return true;
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func performFetch() {
        addPurchaseStatusObserver()
    }
    
    // MARK: - private methods
    
    private func getNavigationController()->UINavigationController? {
        return appDelegate.window.rootViewController as? UINavigationController
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DDLogError("(AppDelegate) application Open URL.");
            
        /*
        When we open an app from action extension we show user a launch screen, while view controllers are being loaded, when they are, we show UserFilterController. It is done by changing app's window.
        https://github.com/AdguardTeam/AdguardForiOS/issues/1135
        */
        
        let command = url.host
        
        guard let nav = self.getNavigationController() else {
            DDLogError("(AppDeegate) application open url error. There is no nav controller")
            return false
        }
        
        if nav.viewControllers.count == 0 {
            return false
        }
        
        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        let launchScreenController = launchScreenStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
        if command == AE_URLSCHEME_COMMAND_ADD {
            appDelegate.window.rootViewController = launchScreenController
        }
     
        if url.scheme == AE_URLSCHEME && command == AE_URLSCHEME_COMMAND_ADD {
            aeService.onReady {
                DispatchQueue.main.async {
                        
                    let path = String(url.path.suffix(url.path.count - 1))
                    
                    let main = nav.viewControllers[0]
                    if main.isKind(of: MainController.self) {
                        let menuStoryboard = UIStoryboard(name: "MainMenu", bundle: Bundle.main)
                        let menuController = menuStoryboard.instantiateViewController(withIdentifier: "MainMenuController")
                        let userFilterStoryboard = UIStoryboard(name: "UserFilter", bundle: Bundle.main)
                        guard let userFilterController = userFilterStoryboard.instantiateViewController(withIdentifier: "UserFilterController") as? ListOfRulesController else { return }
                        
                        let model = ListOfRulesModel(listOfRulesType: .safariUserFilter, resources: self.resources, contentBlockerService: self.contentBlockerService, antibanner: self.aeService.antibanner(), theme: self.themeService, dnsFiltersService: self.dnsFiltersService)
                        
                        userFilterController.model = model
                        userFilterController.newRuleText = path
                        
                        let filtersStoryboard = UIStoryboard(name: "Filters", bundle: Bundle.main)
                        let safariProtectionController = filtersStoryboard.instantiateViewController(withIdentifier: "SafariProtectionController")
                        
                        nav.viewControllers = [main, menuController, safariProtectionController, userFilterController]
                        
                        main.loadViewIfNeeded()
                        menuController.loadViewIfNeeded()
                        safariProtectionController.loadViewIfNeeded()
                        userFilterController.loadViewIfNeeded()
                        
                        self.appDelegate.window.rootViewController = nav
                    }
                    else{
                        DDLogError("(AppDelegate) Can't add rule because mainController is not found.");
                    }
                }
            }
            return true
        }
        return false
    }
    
    private func addPurchaseStatusObserver() {
        if purchaseObservation == nil {
            purchaseObservation = NotificationCenter.default.addObserver(forName: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: nil, queue: nil) { (notification) in
                        
                        guard let type =  notification.userInfo?[PurchaseService.kPSNotificationTypeKey] as? String else { return }
                        
                        if type == PurchaseService.kPSNotificationPremiumExpired {
                            self.userNotificationService.postNotification(title: ACLocalizedString("premium_expired_title", nil), body: ACLocalizedString("premium_expired_message", nil))
                        }
                    }
        }
    }
}
