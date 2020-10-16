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
import Setapp

/**
 AppDelegateHelper is a helper class for AppDelegate
 all new functions we must write in this swift class instead of old obj-c AppDelegate
 */

@objcMembers
class AppDelegateHelper: NSObject {
    
    let appDelegate: AppDelegate
    lazy var userNotificationService: UserNotificationServiceProtocol =  { ServiceLocator.shared.getService()! }()
    lazy var resources: AESharedResourcesProtocol = { ServiceLocator.shared.getService()! }()
    lazy var themeService: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var contentBlockerService: ContentBlockerService = { ServiceLocator.shared.getService()! }()
    lazy var dnsFiltersService: DnsFiltersServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var antibannerController: AntibannerControllerProtocol = { ServiceLocator.shared.getService()! }()
    lazy var antibanner: AESAntibannerProtocol = { ServiceLocator.shared.getService()! }()
    lazy var purchaseService: PurchaseServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var filtersService: FiltersServiceProtocol =  { ServiceLocator.shared.getService()! }()
    lazy var vpnManager: VpnManagerProtocol = { ServiceLocator.shared.getService()! }()
    lazy var configuration: ConfigurationService = { ServiceLocator.shared.getService()! }()
    lazy var networking: ACNNetworking = { ServiceLocator.shared.getService()! }()
    lazy var activityStatisticsService: ActivityStatisticsServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var dnsStatisticsService: DnsStatisticsServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var dnsLogRecordsService: DnsLogRecordsServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var migrationService: MigrationServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var productInfo: ADProductInfoProtocol = { ServiceLocator.shared.getService()! }()
    
    private var showStatusBarNotification: NotificationToken?
    private var hideStatusBarNotification: NotificationToken?
    private var orientationChangeNotification: NotificationToken?
    private var tunnelErrorCodeObserver: ObserverToken?
    
    private var statusBarWindow: UIWindow?
    private var statusBarIsShown = false
    private let statusView = StatusView()
    
    var purchaseObservation: Any?
    var proStatusObservation: Any?
    
    // MARK: String Constants
    private let openSystemProtection = "systemProtection"
    private let openComplexProtection = "complexProtection"
    private let activateLicense = "license"
    private let subscribe = "subscribe"
    
    private var firstRun: Bool {
        get {
            resources.sharedDefaults().object(forKey: AEDefaultsFirstRunKey) as? Bool ?? true
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsFirstRunKey)
        }
    }
    
    @objc var fetchState: BackgroundFetchState {
        get {
            return resources.backgroundFetchState
        }
        set {
            resources.backgroundFetchState = newValue
        }
    }
    
    @objc
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        super.init()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        if !Bundle.main.isPro {
            SetappManager.shared.start(with: .default)
            SetappManager.shared.logLevel = .debug
            
            SetappManager.shared.setLogHandle { (message: String, logLevel: SetappLogLevel) in
              DDLogInfo("(Setapp) [\(logLevel)], \(message)")
            }
        }
        
        guard let mainTabBar = getMainTabController() else {
            assertionFailure("there is no MainTabBar")
            return
        }
        
        guard let firstPageNavController = mainTabBar.viewControllers?[TabBarTabs.mainTab.rawValue] as? MainNavigationController else {
            assertionFailure("there is no navigation controller on first page")
            return
        }
        
        guard let mainPage = firstPageNavController.viewControllers.first as? MainPageController else {
            assertionFailure("there is no MainPageController on first page")
            return
        }
        
        mainPage.onReady = { [weak self] in
            // request permission for user notifications posting
            self?.userNotificationService.requestPermissions()
        }
        
        guard let activityPageNavController = mainTabBar.viewControllers?[TabBarTabs.activityTab.rawValue] as? MainNavigationController else {
            assertionFailure("there is no navigation controller on activity page")
            return
        }
        
        guard let dnsLogContainerVC = activityPageNavController.viewControllers.first as? DnsLogContainerController else {
            assertionFailure("there is no ActivityViewController on activity page")
            return
        }
        /**
         To quickly show stats in ActivityViewController, we load ViewController when app starts
         */
        dnsLogContainerVC.loadViewIfNeeded()
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        antibannerController.start()
        
        addPurchaseStatusObserver()
        
        antibannerController.onReady { [weak self] (_) in
            guard let self = self else { return }
            if (self.firstRun) {
                self.migrationService.install()
                self.purchaseService.checkLicenseStatus()
                self.firstRun = false
            }
               
            self.migrationService.migrateIfNeeded(inBackground: self.appDelegate.background)
        }
        
        return true
    }
    
    var statusViewCounter = 0
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        createStatusBarWindow()
        
        statusBarWindow?.isHidden = true
                
        showStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.ShowStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.statusViewCounter += 1
                
                if !self.configuration.showStatusBar {
                    return
                }
        
                guard let text = notification.userInfo?[AEDefaultsShowStatusViewInfo] as? String else { return }
                    
                if !self.statusBarIsShown{
                    self.statusBarIsShown = true
                    self.showStatusView(with: text)
                } else {
                    self.changeTextForStatusView(text: text)
                }
            }
        })
        
        hideStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.HideStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.statusViewCounter > 0{
                    self.statusViewCounter -= 1
                }
                
                if self.statusViewCounter == 0 {
                    self.hideStatusView()
                }
            }
        })
        
        orientationChangeNotification = NotificationCenter.default.observe(name: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            DispatchQueue.main.async {
                self?.changeOrientation()
            }
        })
        
        tunnelErrorCodeObserver = resources.sharedDefaults().addObseverWithToken(self, keyPath: TunnelErrorCode, options: .new, context: nil)
    }
    
    // MARK: - Observing Values from User Defaults
       
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == TunnelErrorCode, resources.tunnelErrorCode == 3 {
            postDnsFiltersOverlimitNotificationIfNedeed()
        }
    }
    
    func performFetch() {
        addPurchaseStatusObserver()
    }
    
    /** resets all settings. It removes database and reinit it from default database.
     Also it removes vpn profile. And reomves all keys from keychain (reset authorisation) */
    func resetAllSettings() {
        
        let alert = UIAlertController(title: nil, message: String.localizedString("loading_message"), preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        appDelegate.window.rootViewController?.present(alert, animated: true, completion: nil)
        
        DispatchQueue(label: "reset_queue").async { [weak self] in
            guard let self = self else { return }
            DDLogInfo("(AppDelegate) resetAllSettings")

            self.filtersService.reset()
            self.antibannerController.reset()
            self.vpnManager.removeVpnConfiguration { _ in }
            self.resources.reset()
            self.resetStatistics()
            
            let group = DispatchGroup()
            group.enter()
            
            self.purchaseService.reset {
                group.leave()
            }
            group.wait()
            
            self.dnsFiltersService.reset()
            
            self.appDelegate.setAppInterfaceStyle()
            
            let providersService: DnsProvidersService = ServiceLocator.shared.getService()!
            providersService.reset()
            
            // force load filters to fill database
            self.filtersService.load(refresh: true) {}
            
            // Notify that settings were reset
            NotificationCenter.default.post(name: NSNotification.resetSettings, object: self)
            
            DispatchQueue.main.async { [weak self] in
                self?.appDelegate.window.rootViewController?.dismiss(animated: true) {
                    let tabController = self?.getMainTabController()
                    let navController = tabController?.viewControllers?[TabBarTabs.mainTab.rawValue] as? MainNavigationController
                    tabController?.selectedViewController = navController
                    
                    if let tabs = tabController?.viewControllers {
                        for viewController in tabs {
                            if let navController = viewController as? UINavigationController {
                                navController.popToRootViewController(animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Open DnsFiltersController function
    
    func openDnsFiltersController(){
        guard let tab = self.getMainTabController() else {
            DDLogError("(AppDeegateHelper) openDnsFiltersController error. There is no tab controller")
            return
        }
        
        if tab.viewControllers?.count == 0 {
            DDLogError("(AppDeegateHelper) openDnsFiltersController error. TabBar viewcontrollers number is 0")
            return
        }
        
        guard let navController = tab.viewControllers?[TabBarTabs.protectionTab.rawValue] as? MainNavigationController else {
            DDLogError("(AppDeegateHelper) openDnsFiltersController error. Failed getting navigation controller from TabBar tab")
            return
        }
        
        if let complexProtectionController = navController.viewControllers.first as? ComplexProtectionController {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                
                let dnsSettingsStoryboard = UIStoryboard(name: "DnsSettings", bundle: nil)
                let dnsSettingsController = dnsSettingsStoryboard.instantiateViewController(withIdentifier: "DnsSettingsController")
                dnsSettingsController.loadViewIfNeeded()
                
                let requestsBlockingController = dnsSettingsStoryboard.instantiateViewController(withIdentifier: "RequestsBlockingController")
                requestsBlockingController.loadViewIfNeeded()
                
                let dnsFiltersController = dnsSettingsStoryboard.instantiateViewController(withIdentifier: "DnsFiltersController")
                
                navController.viewControllers = [complexProtectionController, dnsSettingsController, requestsBlockingController, dnsFiltersController]
                tab.selectedViewController = navController
                self.appDelegate.window.rootViewController = tab
            }
        }
    }

    func showCommonAlertForTopVc(_ body: String?, _ title: String?) {
        DispatchQueue.main.async {[weak self] in
            guard let tab = self?.getMainTabController() else {
                DDLogError("(AppDeegateHelper) showCommonAlertForTopVc error. There is no tab controller")
                return
            }
            
            if let selectedNavController = tab.selectedViewController as? MainNavigationController {
                if let topVC = selectedNavController.topViewController {
                    ACSSystemUtils.showSimpleAlert(for: topVC, withTitle: body, message: title)
                }
            }
        }
    }
    
    // MARK: - private methods
    
    private func postDnsFiltersOverlimitNotificationIfNedeed(){
        guard let tab = self.getMainTabController() else {
            DDLogError("(AppDeegateHelper) postDnsFiltersOverlimitNotificationIfNedeed error. There is no tab controller")
            return
        }
        
        if let selectedVC = tab.selectedViewController as? MainNavigationController {
            if let _ = selectedVC.viewControllers.last as? DnsFiltersController {
                return
            }
        }
        
        let rulesNumberString = String.simpleThousandsFormatting(NSNumber(integerLiteral: dnsFiltersService.enabledRulesCount))
        let title = String.localizedString("dns_filters_notification_title")
        let body = String(format: String.localizedString("dns_filters_overlimit_title"), rulesNumberString)
        let userInfo: [String : Int] = [PushNotificationCommands.command : PushNotificationCommands.openDnsFiltersController.rawValue]
        userNotificationService.postNotification(title: title, body: body, userInfo: userInfo)
    }
    
    private func getMainTabController()->MainTabBarController? {
        return appDelegate.window.rootViewController as? MainTabBarController
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DDLogError("(AppDelegate) application Open URL: \(url.absoluteURL)");
        
        if !Bundle.main.isPro {
            if SetappManager.shared.canOpen(url: url) {
                return SetappManager.shared.open(url: url, options: options)
            }
        }
            
        /*
        When we open an app from action extension we show user a launch screen, while view controllers are being loaded, when they are, we show UserFilterController. It is done by changing app's window.
        https://github.com/AdguardTeam/AdguardForiOS/issues/1135
        */
        
        var command: String?
        var params: [String: String]?
        
        if url.host != nil {
            command = url.host!
        } else {
            let result = parseCustomUrlScheme(url)
            command = result.command
            params = result.params
        }
        
        
        guard let tab = getMainTabController() else {
            DDLogError("(AppDeegate) application open url error. There is no tab controller")
            return false
        }

        if tab.viewControllers?.count == 0 {
            DDLogError("(AppDeegateHelper) applicationOpenUrl error. TabBar viewcontrollers number is 0")
            return false
        }
        
        if command == activateLicense && Bundle.main.isPro {
            return false
        }

        let launchScreenStoryboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        let launchScreenController = launchScreenStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
        if command == AE_URLSCHEME_COMMAND_ADD || command == openSystemProtection || command == openComplexProtection || command == activateLicense || command == subscribe {
            appDelegate.window.rootViewController = launchScreenController
        }
        
        // 4-th Navigation Controller is settings tab
        guard let navController = tab.viewControllers?[TabBarTabs.settingTab.rawValue] as? MainNavigationController else {
            DDLogError("(AppDeegateHelper) applicationOpenUrl error. Failed getting navigation controller from TabBar tab")
            return false
        }

        if let mainMenuController = navController.viewControllers.first as? MainMenuController {
            // Adding new user rule from safari
            switch(url.scheme, command) {
           
            case (AE_URLSCHEME, AE_URLSCHEME_COMMAND_ADD) :
                antibannerController.onReady { (antibanner) in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        let path = String(url.path.suffix(url.path.count - 1))
                        
                        let userFilterStoryboard = UIStoryboard(name: "UserFilter", bundle: Bundle.main)
                        guard let userFilterController = userFilterStoryboard.instantiateViewController(withIdentifier: "UserFilterController") as? ListOfRulesController else { return }
                        
                        let model: ListOfRulesModelProtocol = UserFilterModel(resources: self.resources, contentBlockerService: self.contentBlockerService, antibanner: self.antibanner, theme: self.themeService, productInfo: self.productInfo)
                        
                        userFilterController.model = model
                        userFilterController.newRuleText = path
                        
                        let filtersStoryboard = UIStoryboard(name: "Filters", bundle: Bundle.main)
                        let safariProtectionController = filtersStoryboard.instantiateViewController(withIdentifier: "SafariProtectionController")
                        
                        safariProtectionController.loadViewIfNeeded()
                                                
                        navController.viewControllers = [mainMenuController, safariProtectionController, userFilterController]
                        
                        tab.selectedViewController = navController
                        self.appDelegate.window.rootViewController = tab
                    }
                }
            
            // Turning on/off DNS protection from widget
            case (AE_URLSCHEME, openSystemProtection):
                let suffix = String(url.path.suffix(url.path.count - 1))
                let parameters = suffix.split(separator: "/")
                
                let enabledString = String(parameters.first ?? "")
                let enabled = enabledString == "on"
                
                let dnsSettingsStoryBoard = UIStoryboard(name: "DnsSettings", bundle: Bundle.main)
                guard let dnsSettingsController = dnsSettingsStoryBoard.instantiateViewController(withIdentifier: "DnsSettingsController") as? DnsSettingsController else { return false }
                
                dnsSettingsController.stateFromWidget = enabled
                
                navController.viewControllers = [mainMenuController, dnsSettingsController]
                
                tab.selectedViewController = navController
                self.appDelegate.window.rootViewController = tab
            
            case (AE_URLSCHEME, openComplexProtection):
             
                guard let mainTabNavController = tab.viewControllers?[TabBarTabs.mainTab.rawValue] as? MainNavigationController else { return false }
                
                let suffix = String(url.path.suffix(url.path.count - 1))
                let parameters = suffix.split(separator: "/")
                
                let enabledString = String(parameters.first ?? "")
                let enabled = enabledString == "on"
                
                let mainTabStoryboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
                guard let mainPageController = mainTabStoryboard.instantiateViewController(withIdentifier: "MainPageController") as? MainPageController else { return false }
                
                mainPageController.stateFromWidget = enabled
                
                mainTabNavController.viewControllers = [mainPageController]
                
                tab.selectedViewController = mainTabNavController
                self.appDelegate.window.rootViewController = tab
                
            case (AE_URLSCHEME, activateLicense):
                guard let mainTabNavController = tab.viewControllers?[TabBarTabs.mainTab.rawValue] as? MainNavigationController else { return false }
                
                let license = params?["license"]
                
                DDLogInfo("(AppDelegateHelper) - activate license key from openUrl")
                let mainTabStoryboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
                guard let mainPageController = mainTabStoryboard.instantiateViewController(withIdentifier: "MainPageController") as? MainPageController else { return false }
                
                
                if license == nil || license!.isEmpty {
                    DDLogInfo("(AppDelegateHelper) - update license from openUrl")
                    
                    mainTabNavController.viewControllers = [mainPageController]
                    
                    tab.selectedViewController = mainTabNavController
                    self.appDelegate.window.rootViewController = tab
                    
                    purchaseService.checkLicenseStatus()
                }
                else {
                    DDLogInfo("(AppDelegateHelper) - activate license key from openUrl")
                    
                    let licenseStoryboard = UIStoryboard(name: "License", bundle: Bundle.main)
                    guard let getProController = licenseStoryboard.instantiateViewController(withIdentifier: "GetProController") as? GetProController else {
                        return false
                    }
                    
                    guard let loginController = licenseStoryboard.instantiateViewController(withIdentifier: "LoginScene") as? LoginController else { return false}
                    
                    loginController.licenseKey = license
                    mainTabNavController.viewControllers = [mainPageController, getProController, loginController]
                    
                    tab.selectedViewController = mainTabNavController
                    self.appDelegate.window.rootViewController = tab
                }
                
            case (AE_SDNS_SCHEME, _):
                DDLogInfo("(AppDelegateHelper) openurl sdns: \(url.absoluteString)");
                
                let dnsSettingsStoryBoard = UIStoryboard(name: "DnsSettings", bundle: Bundle.main)
                guard let dnsSettingsController = dnsSettingsStoryBoard.instantiateViewController(withIdentifier: "DnsSettingsController") as? DnsSettingsController else { return false }
                
                dnsSettingsController.loadViewIfNeeded()
                
                if !configuration.proStatus {
                    navController.viewControllers = [mainMenuController, dnsSettingsController]
                }
                else {
                    guard let dnsProvidersController = dnsSettingsStoryBoard.instantiateViewController(withIdentifier: "DnsProvidersController") as? DnsProvidersController else { return false }
                    
                    dnsProvidersController.loadViewIfNeeded()
                    
                    dnsProvidersController.openUrl = url.absoluteString
                    navController.viewControllers = [mainMenuController, dnsSettingsController, dnsProvidersController]
                }
                
                tab.selectedViewController = navController
                self.appDelegate.window.rootViewController = tab
                
            case (_, subscribe):
                DDLogInfo("(AppDelegateHelper) openurl - subscribe filter")
                
                let filtersStoryboard = UIStoryboard(name: "Filters", bundle: Bundle.main)
                let safariProtectionController = filtersStoryboard.instantiateViewController(withIdentifier: "SafariProtectionController")
                
                safariProtectionController.loadViewIfNeeded()
                
                guard let filtersMasterController = filtersStoryboard.instantiateViewController(withIdentifier: "FiltersMasterController") as? FiltersMasterController else { return false }
                
                filtersMasterController.loadViewIfNeeded()
            
                let groupsController = filtersMasterController.children.first { $0 is GroupsController } as? GroupsController
                
                groupsController?.openUrl = params?["location"]
                groupsController?.openTitle = params?["title"]
                
                navController.viewControllers = [mainMenuController, safariProtectionController, filtersMasterController]
                
                tab.selectedViewController = navController
                self.appDelegate.window.rootViewController = tab
                
            default:
                break
            }
                
            
        } else {
            DDLogError("(AppDelegate) Can't add rule because mainController is not found.");
        }
        
        return false
    }
    
    private func addPurchaseStatusObserver() {
        if purchaseObservation == nil {
            purchaseObservation = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: nil, queue: nil) { (notification) in
                guard let type =  notification.userInfo?[PurchaseService.kPSNotificationTypeKey] as? String else { return }
                        
                if type == PurchaseService.kPSNotificationPremiumExpired {
                    self.userNotificationService.postNotification(title: ACLocalizedString("premium_expired_title", nil), body: ACLocalizedString("premium_expired_message", nil), userInfo: nil)
                }
            }
        }
        
        if proStatusObservation == nil {
            proStatusObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
                guard let self = self else { return }
                if !self.configuration.proStatus && self.vpnManager.vpnInstalled {
                    DDLogInfo("(AppDelegateHelper) Remove vpn configuration")
                    self.vpnManager.removeVpnConfiguration { (error) in
                        if error != nil {
                            DDLogError("(AppDelegateHelper) Remove vpn configuration failed: \(error!)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Methods to deal with statusViewBar
    
    private func createStatusBarWindow(){
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        var bottomSafeAreaInset: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            bottomSafeAreaInset = keyWindow.safeAreaInsets.bottom / 2.0
        }
                
        let frame = CGRect(x: 0.0, y: keyWindow.frame.maxY, width: keyWindow.frame.width, height: 16.0 + bottomSafeAreaInset)
        
        let bannerWindow = UIWindow(frame: frame)
        bannerWindow.backgroundColor = UIColor(hexString: "#d8d8d8")
        bannerWindow.windowLevel = UIWindow.Level.statusBar
        bannerWindow.addSubview(statusView)
        bannerWindow.isHidden = false
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.topAnchor.constraint(equalTo: bannerWindow.topAnchor).isActive = true
        statusView.leftAnchor.constraint(equalTo: bannerWindow.leftAnchor).isActive = true
        statusView.rightAnchor.constraint(equalTo: bannerWindow.rightAnchor).isActive = true
        statusView.bottomAnchor.constraint(equalTo: bannerWindow.bottomAnchor).isActive = true
        
        statusBarWindow = bannerWindow
    }
    
    private func showStatusView(with text: String?){
        statusBarWindow?.isHidden = false
        
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let sSelf = self else { return }
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            
            sSelf.statusView.text = text
            let height = sSelf.statusBarWindow?.frame.height ?? 0.0
            sSelf.statusBarWindow?.frame.origin.y = keyWindow.frame.maxY - height
        }
    }
    
    private func hideStatusView(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let sSelf = self else { return }
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            
            sSelf.statusBarWindow?.frame.origin.y = keyWindow.frame.maxY
        }) {[weak self] (success) in
            self?.statusBarIsShown = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
                self?.statusBarWindow?.isHidden = true
            }
        }
    }
    
    private func changeOrientation(){
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let sSelf = self else { return }
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            let height = sSelf.statusBarWindow?.frame.height ?? 0.0
            
            if sSelf.statusBarIsShown {
                let frame = CGRect(x: 0.0, y: keyWindow.frame.maxY - height, width: keyWindow.frame.width, height: height)
                sSelf.statusBarWindow?.frame = frame
            } else {
                let frame = CGRect(x: 0.0, y: keyWindow.frame.maxY, width: keyWindow.frame.width, height: height)
                sSelf.statusBarWindow?.frame = frame
            }
        }
    }
    
    private func changeTextForStatusView(text: String){
        DispatchQueue.main.async {[weak self] in
            self?.statusView.text = text
        }
    }
    
    private func resetStatistics(){
        /* Reseting statistics Start*/
        self.activityStatisticsService.stopDb()
        self.dnsStatisticsService.stopDb()
        
        // delete database file
        let url = self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db")
        try? FileManager.default.removeItem(atPath: url.path)
        
        /* Reseting statistics end */
        self.activityStatisticsService.startDb()
        self.dnsStatisticsService.startDb()
        
        self.dnsLogRecordsService.reset()
    }
    
    private func parseCustomUrlScheme(_ url: URL)->(command: String?, params:[String: String]?) {
        
        let components = url.absoluteString.split(separator: ":", maxSplits: 1)
        if components.count != 2 {
            DDLogError("(AppDelegateHelper) parseCustomUrlScheme error - unsopported url format")
            return (nil, nil)
        }
     
        let querry = components.last
        
        // try to parse url with question (adguard:subscribe?location=https://easylist.to/easylist/easylist.txt&title=EasyList)
        let questionComponents = querry?.split(separator: "?", maxSplits: 1)
        
        if questionComponents?.count == 2 {
            let command = String((questionComponents?.first)!)
            let params = ACNUrlUtils.parameters(fromQueryString: String((questionComponents?.last)!))
            
            return (command, params)
        }
        else if questionComponents?.count == 1 {
            // try to parse url without question (adguard:license=AAAA)
            let params = ACNUrlUtils.parameters(fromQueryString: String((questionComponents?.last)!))
            let command = String(params.first!.key)
            return (command, params)
        }
        
        DDLogError("(AppDelegateHelper) parseCustomUrlScheme error - unsopported url format")
        return (nil, nil)
    }
}
