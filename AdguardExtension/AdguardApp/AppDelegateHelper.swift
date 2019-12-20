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
    
    lazy var resources: AESharedResourcesProtocol = { ServiceLocator.shared.getService()! }()
    lazy var themeService: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var contentBlockerService: ContentBlockerService = { ServiceLocator.shared.getService()! }()
    lazy var dnsFiltersService: DnsFiltersServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var antibannerController: AntibannerControllerProtocol = { ServiceLocator.shared.getService()! }()
    lazy var antibanner: AESAntibannerProtocol = { ServiceLocator.shared.getService()! }()
    lazy var purchaseService: PurchaseServiceProtocol = { ServiceLocator.shared.getService()! }()
    lazy var filtersService: FiltersServiceProtocol =  { ServiceLocator.shared.getService()! }()
    lazy var vpnManager: APVPNManager = { ServiceLocator.shared.getService()! }()
    lazy var configuration: ConfigurationService = { ServiceLocator.shared.getService()! }()
    
    private var showStatusBarNotification: NotificationToken?
    private var hideStatusBarNotification: NotificationToken?
    private var orientationChangeNotification: NotificationToken?
    
    private var showStatusBarIsEnabled: Bool {
        return resources.sharedDefaults().bool(forKey: AEDefaultsShowStatusBar)
    }
    
    private var statusBarWindow: UIWindow?
    private var statusBarIsShown = false
    private let statusView = StatusView()
    
    var purchaseObservation: Any?
    
    // MARK: String Constants
    private let openSystemProtection = "systemProtection"
    
    private var firstRun: Bool {
        get {
            resources.sharedDefaults().object(forKey: AEDefaultsFirstRunKey) as? Bool ?? true
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsFirstRunKey)
        }
    }
    
    @objc
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
        super.init()
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        antibannerController.start()
        
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
    
    var statusViewCounter = 0
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        createStatusBarWindow()
        
        statusBarWindow?.isHidden = true
                
        showStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.ShowStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let sSelf = self else { return }
            
            if !sSelf.showStatusBarIsEnabled {
                return
            }
            
            sSelf.statusViewCounter += 1
            
            guard let text = notification.userInfo?[AEDefaultsShowStatusViewInfo] as? String else { return }
            
            if !sSelf.statusBarIsShown{
                sSelf.statusBarIsShown = true
                DispatchQueue.main.async {
                    sSelf.showStatusView(with: text)
                }
            } else {
                sSelf.changeTextForStatusView(text: text)
            }
        })
        
        hideStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.HideStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let sSelf = self else { return }
            
            sSelf.statusViewCounter -= 1
            
            if sSelf.statusBarIsShown && sSelf.statusViewCounter == 0 {
                DispatchQueue.main.async {
                    self?.hideStatusView()
                }
            }
        })
        
        orientationChangeNotification = NotificationCenter.default.observe(name: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            DispatchQueue.main.async {
                self?.changeOrientation()
            }
        })
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
            self.vpnManager.removeVpnConfiguration()
            self.resources.reset()
            
            let group = DispatchGroup()
            group.enter()
            
            self.purchaseService.reset {
                group.leave()
            }
            group.wait()
            
            self.dnsFiltersService.reset()
            
            // force load filters to fill database
            self.filtersService.load(refresh: true) {}
            
            DispatchQueue.main.async { [weak self] in
                self?.appDelegate.window.rootViewController?.dismiss(animated: true) {
                    let nav = self?.getNavigationController()
                    nav?.popToRootViewController(animated: true)
                }
            }
        }
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
        if command == AE_URLSCHEME_COMMAND_ADD || command == openSystemProtection {
            appDelegate.window.rootViewController = launchScreenController
        }
     
        if url.scheme == AE_URLSCHEME && command == AE_URLSCHEME_COMMAND_ADD {
            antibannerController.onReady { (antibanner) in
                DispatchQueue.main.async {
                        
                    let path = String(url.path.suffix(url.path.count - 1))
                    
                    let main = nav.viewControllers[0]
                    if main.isKind(of: MainController.self) {
                        let menuStoryboard = UIStoryboard(name: "MainMenu", bundle: Bundle.main)
                        let menuController = menuStoryboard.instantiateViewController(withIdentifier: "MainMenuController")
                        let userFilterStoryboard = UIStoryboard(name: "UserFilter", bundle: Bundle.main)
                        guard let userFilterController = userFilterStoryboard.instantiateViewController(withIdentifier: "UserFilterController") as? ListOfRulesController else { return }
                        
                        let model: ListOfRulesModelProtocol = UserFilterModel(resources: self.resources, contentBlockerService: self.contentBlockerService, antibanner: self.antibanner, theme: self.themeService)
                        
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
        
        if url.scheme == AE_URLSCHEME && command == openSystemProtection {
            let enabledString = String(url.path.suffix(url.path.count - 1))
            let enabled = enabledString == "on"
            
            let main = nav.viewControllers[0]
            if main.isKind(of: MainController.self) {
                let menuStoryboard = UIStoryboard(name: "MainMenu", bundle: Bundle.main)
                let menuController = menuStoryboard.instantiateViewController(withIdentifier: "MainMenuController")
                
                let proStatus = configuration.proStatus
        
                if proStatus {
                    let dnsSettingsStoryBoard = UIStoryboard(name: "DnsSettings", bundle: Bundle.main)
                    guard let dnsSettingsController = dnsSettingsStoryBoard.instantiateViewController(withIdentifier: "DnsSettingsController") as? DnsSettingsController else { return false }
            
                    dnsSettingsController.stateFromWidget = enabled
                    
                    let proViewControllers = [main, menuController, dnsSettingsController]
                    nav.viewControllers = proViewControllers
                    
                    main.loadViewIfNeeded()
                    menuController.loadViewIfNeeded()
                    dnsSettingsController.loadViewIfNeeded()
                } else {
                    let licenseStoryBoard = UIStoryboard(name: "License", bundle: Bundle.main)
                    guard let getProController = licenseStoryBoard.instantiateViewController(withIdentifier: "GetProController") as? GetProController else { return false }
                    
                    let toPurchaseViewControllers = [main, getProController]
                    nav.viewControllers = toPurchaseViewControllers
                    
                    main.loadViewIfNeeded()
                    getProController.loadViewIfNeeded()
                }
                
                self.appDelegate.window.rootViewController = nav
            } else{
                DDLogError("(AppDelegate) Can't open systemProtection because mainController is not found.")
            }
        }
        return false
    }
    
    private func addPurchaseStatusObserver() {
        if purchaseObservation == nil {
            purchaseObservation = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: nil, queue: nil) { (notification) in
                        
                        guard let type =  notification.userInfo?[PurchaseService.kPSNotificationTypeKey] as? String else { return }
                        
                        if type == PurchaseService.kPSNotificationPremiumExpired {
                            self.userNotificationService.postNotification(title: ACLocalizedString("premium_expired_title", nil), body: ACLocalizedString("premium_expired_message", nil))
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
            sSelf.statusView.text = text
            sSelf.statusBarWindow?.frame.origin.y -= sSelf.statusBarWindow?.frame.height ?? 0.0
        }
    }
    
    private func hideStatusView(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let sSelf = self else { return }
            sSelf.statusBarWindow?.frame.origin.y += sSelf.statusBarWindow?.frame.height ?? 0.0
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
}
