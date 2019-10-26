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
    
    private var showStatusBarNotification: NotificationToken?
    private var hideStatusBarNotification: NotificationToken?
    private var orientationChangeNotification: NotificationToken?
    private var keyboardChangeNotification: NotificationToken?
    private var keyboardAppearsNotification: NotificationToken?
    private var keyboardDisappearsNotification: NotificationToken?
    
    private var keyboardIsShown = false
    private var keyboardMinY: CGFloat = 0.0
    
    private var statusBarWindow: UIWindow?
    private var bottomSafeAreaInset: CGFloat = 0.0
    private var statusBarIsShown = false
    private let statusView = StatusView()
    
    var purchaseObservation: Any?
    
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
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        createStatusBarWindow()
                
        showStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.ShowStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let sSelf = self else { return }
            if !sSelf.statusBarIsShown{
                sSelf.statusBarIsShown = true
                guard let text = notification.userInfo?[AEDefaultsShowStatusViewInfo] as? String else { return }
                DispatchQueue.main.async {
                    sSelf.showStatusView(with: text)
                }
            }
        })
        
        hideStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.HideStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let sSelf = self else { return }
            if sSelf.statusBarIsShown{
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
        
        keyboardChangeNotification = NotificationCenter.default.observe(name: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let sSelf = self else { return }
            guard let userInfo = notification.userInfo else { return }
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            sSelf.keyboardMinY = keyboardFrame.minY
            if sSelf.statusBarIsShown{
                sSelf.keyboardChanged(minY: keyboardFrame.minY)
            }
        })
        
        keyboardAppearsNotification = NotificationCenter.default.observe(name: UIResponder.keyboardDidShowNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            self?.keyboardIsShown = true
        })
        
        keyboardDisappearsNotification = NotificationCenter.default.observe(name: UIResponder.keyboardDidHideNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            self?.keyboardIsShown = false
        })
    }
    
    func performFetch() {
        addPurchaseStatusObserver()
    }
    
    /** resets all settings. It removes database and reinit it from default database.
     Also it removes vpn profile. And reomves all keys from keychain (reset authorisation) */
    func resetAllSettings() {
        
        DDLogInfo("(AppDelegate) resetAllSettings")

        filtersService.reset()
        antibannerController.reset()
        vpnManager.removeVpnConfiguration()
        resources.reset()
        purchaseService.reset()
        
        // force load filters to fill database
        filtersService.load(refresh: true) {}
        
        let nav = self.getNavigationController()
        nav?.popToRootViewController(animated: true)
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
            antibannerController.onReady { (antibanner) in
                DispatchQueue.main.async {
                        
                    let path = String(url.path.suffix(url.path.count - 1))
                    
                    let main = nav.viewControllers[0]
                    if main.isKind(of: MainController.self) {
                        let menuStoryboard = UIStoryboard(name: "MainMenu", bundle: Bundle.main)
                        let menuController = menuStoryboard.instantiateViewController(withIdentifier: "MainMenuController")
                        let userFilterStoryboard = UIStoryboard(name: "UserFilter", bundle: Bundle.main)
                        guard let userFilterController = userFilterStoryboard.instantiateViewController(withIdentifier: "UserFilterController") as? ListOfRulesController else { return }
                        
                        let model = ListOfRulesModel(listOfRulesType: .safariUserFilter, resources: self.resources, contentBlockerService: self.contentBlockerService, antibanner: antibanner, theme: self.themeService, dnsFiltersService: self.dnsFiltersService)
                        
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
        
        if #available(iOS 11.0, *) {
            bottomSafeAreaInset = keyWindow.safeAreaInsets.bottom / 2
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
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        if keyboardIsShown {
            statusBarWindow?.frame = CGRect(x: 0.0, y: keyboardMinY, width: keyWindow.frame.width, height: 16.0)
        } else {
            statusBarWindow?.frame = CGRect(x: 0.0, y: keyWindow.frame.maxY, width: keyWindow.frame.width, height: 16.0 + bottomSafeAreaInset)
        }
        
        statusBarWindow?.isHidden = false
        
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let sSelf = self else { return }
            sSelf.statusView.text = text
            keyWindow.frame.size.height -= sSelf.statusBarWindow?.frame.height ?? 0.0
            sSelf.statusBarWindow?.frame.origin.y -= sSelf.statusBarWindow?.frame.height ?? 0.0
        }
    }
    
    private func hideStatusView(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let sSelf = self else { return }
            UIApplication.shared.keyWindow?.frame.size.height += sSelf.statusBarWindow?.frame.height ?? 0.0
            sSelf.statusBarWindow?.frame.origin.y += sSelf.statusBarWindow?.frame.height ?? 0.0
        }) {[weak self] (success) in
            self?.statusBarIsShown = false
            UIApplication.shared.keyWindow?.frame = UIScreen.main.bounds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
                self?.statusBarWindow?.isHidden = true
            }
        }
    }
    
    private func changeOrientation(){
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let sSelf = self else { return }
            if !sSelf.statusBarIsShown {
               UIApplication.shared.keyWindow?.frame = UIScreen.main.bounds
            } else {
                sSelf.resizeStatusViewWindow()
            }
        }
    }
    
    private func resizeStatusViewWindow(){
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        keyWindow.frame = UIScreen.main.bounds
        
        bottomSafeAreaInset = 0.0
        if #available(iOS 11.0, *) {
            bottomSafeAreaInset = keyWindow.safeAreaInsets.bottom / 2
        }
        
        keyWindow.frame.size.height -= (16.0 + bottomSafeAreaInset)
        
        let frame = CGRect(x: 0.0, y: keyWindow.frame.maxY, width: keyWindow.frame.width, height: 16.0 + bottomSafeAreaInset)
        statusBarWindow?.frame = frame
    }
    
    private func keyboardChanged(minY: CGFloat){
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        statusBarWindow?.frame = CGRect(x: 0.0, y: minY - 16.0 - bottomSafeAreaInset, width: keyWindow.frame.width, height: 16.0 + bottomSafeAreaInset)
    }
}
