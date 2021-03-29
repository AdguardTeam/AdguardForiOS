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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Properties
    let statusBarWindow: IStatusBarWindow
    var window: UIWindow?
    
    // AppDelegate+StatusBarWindow notifications
    var showStatusBarNotification: NotificationToken?
    var hideStatusBarNotification: NotificationToken?
    var orientationChangeNotification: NotificationToken?
    // AppDelegate addPurchaseStatusObserver notifications
    private var purchaseObservation: NotificationToken?
    private var proStatusObservation: NSKeyValueObservation?
    
    
    private var fetchPerformer: IBackgroundFetchPerformer?
    private var fetchNotificationHandler: BackgroundFetchNotificationHandler?
    private var firstRun: Bool {
        get {
            resources.firstRun
        }
        set {
            resources.firstRun = newValue
        }
    }
    private var activateWithOpenUrl: Bool = false

    //MARK: - Services
    private var resources: AESharedResourcesProtocol
    private var antibannerController: AntibannerControllerProtocol
    private var contentBlockerService: ContentBlockerService
    private var purchaseService: PurchaseServiceProtocol
    private var antibanner: AESAntibannerProtocol
    private var dnsFiltersService: DnsFiltersServiceProtocol
    private var networking: ACNNetworking
    private var configuration: ConfigurationService
    private var safariService: SafariService
    private var productInfo: ADProductInfoProtocol
    private var migrationService: MigrationServiceProtocol
    private var userNotificationService: UserNotificationServiceProtocol
    private var vpnManager: VpnManagerProtocol
    private var setappService: SetappServiceProtocol
    private var activityStatisticsService: ActivityStatisticsServiceProtocol
    private var dnsStatisticsService: DnsStatisticsServiceProtocol
    private var dnsLogRecordsService: DnsLogRecordsServiceProtocol
    private var rateService: RateAppServiceProtocol
    private var complexProtection: ComplexProtectionServiceProtocol
    private var themeService: ThemeServiceProtocol
    private var filtersService: FiltersServiceProtocol
    
    //MARK: - Application init
    override init() {
        StartupService.start()
        self.resources = ServiceLocator.shared.getService()!
        self.antibannerController = ServiceLocator.shared.getService()!
        self.contentBlockerService = ServiceLocator.shared.getService()!
        self.purchaseService = ServiceLocator.shared.getService()!
        self.antibanner = ServiceLocator.shared.getService()!
        self.dnsFiltersService = ServiceLocator.shared.getService()!
        self.networking = ServiceLocator.shared.getService()!
        self.configuration = ServiceLocator.shared.getService()!
        self.safariService = ServiceLocator.shared.getService()!
        self.productInfo = ServiceLocator.shared.getService()!
        self.migrationService = ServiceLocator.shared.getService()!
        self.userNotificationService = ServiceLocator.shared.getService()!
        self.vpnManager = ServiceLocator.shared.getService()!
        self.setappService = ServiceLocator.shared.getService()!
        self.activityStatisticsService = ServiceLocator.shared.getService()!
        self.dnsStatisticsService = ServiceLocator.shared.getService()!
        self.dnsLogRecordsService = ServiceLocator.shared.getService()!
        self.rateService = ServiceLocator.shared.getService()!
        self.complexProtection = ServiceLocator.shared.getService()!
        self.themeService = ServiceLocator.shared.getService()!
        self.filtersService = ServiceLocator.shared.getService()!
        
        self.statusBarWindow = StatusBarWindow(configuration: configuration)
        super.init()
        
        self.fetchPerformer = BackgroundFetchPerformer(resources: resources,
                                                   purchaseService: purchaseService,
                                                   configuration: configuration,
                                                   vpnManager: vpnManager,
                                                   userNotificationService: userNotificationService,
                                                   contentBlockerService: contentBlockerService,
                                                   antibanner: antibanner,
                                                   complexProtection: complexProtection,
                                                   dnsFiltersService: dnsFiltersService,
                                                   safariService: safariService,
                                                   networking: networking,
                                                   antibannerController: antibannerController)
        
        self.fetchNotificationHandler = BackgroundFetchNotificationHandler(fetchPerformer: fetchPerformer!,
                                                                           antibanner: antibanner,
                                                                           contentBlockerService: contentBlockerService,
                                                                           resources: resources)
    }
    
    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: TunnelErrorCode)
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //------------- Preparing for start application. Stage 1. -----------------
        
        startAntibannerController()
        
        fetchPerformer?.setBackgroundStatusToDefault()
        activateWithOpenUrl = false
        
        initLogger()
        DDLogInfo("(AppDelegate) Preparing for start application. Stage 1.")
        
        //------------ Interface Tuning -----------------------------------
        self.window?.backgroundColor = UIColor.clear
        
        if (application.applicationState != .background) {
            purchaseService.checkPremiumStatusChanged()
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        prepareControllers()
        
        //------------- Preparing for start application. Stage 2. -----------------
        DDLogInfo("(AppDelegate) Preparing for start application. Stage 2.")
        
        subscribeToUserNotificationServiceNotifications()
        AppDelegate.setPeriodForCheckingFilters()
        subscribeToNotifications()
        
        return true
    }
    
    
    //MARK: - Application Delegate Methods
    
    func applicationWillResignActive(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillResignActive.")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationDidEnterBackground.")
        resources.synchronizeSharedDefaults()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillEnterForeground.")
        antibanner.applicationWillEnterForeground()
        configuration.checkContentBlockerEnabled()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationDidBecomeActive.")
        initStatusBarNotifications(application)
        
        // If theme mode is System Default gets current style
        setAppInterfaceStyle()
        updateAntibannerContoller()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillTerminate.")
        resources.synchronizeSharedDefaults()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        addPurchaseStatusObserver()
        fetchPerformer?.performFetch(with: completionHandler)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DDLogError("(AppDelegate) application Open URL.")
        activateWithOpenUrl = true
        
        let urlParser: IURLSchemeParser = URLSchemeParser(executor: self,
                                                          configurationService: configuration,
                                                          purchaseService: purchaseService)
        
        return urlParser.parse(url: url)
    }
    
    //MARK: - Public methods
    
    func resetAllSettings() {
        let resetProcessor = SettingsResetor(appDelegate: self,
                                             dnsFiltersService: dnsFiltersService,
                                             filtersService: filtersService,
                                             antibannerController: antibannerController,
                                             vpnManager: vpnManager,
                                             resources: resources,
                                             purchaseService: purchaseService,
                                             activityStatisticsService: activityStatisticsService,
                                             dnsStatisticsService: dnsStatisticsService,
                                             dnsLogRecordsService: dnsLogRecordsService)
        resetProcessor.resetAllSettings()
    }
    
    func setAppInterfaceStyle() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let window = self.window else { return }
            if #available(iOS 13.0, *) {
                switch (window.traitCollection.userInterfaceStyle) {
                case .dark:
                    self.configuration.systemAppearenceIsDark = true
                default:
                    self.configuration.systemAppearenceIsDark = false
                }
            } else {
                self.configuration.systemAppearenceIsDark = false
            }
        }
    }
    
    // MARK: - Observing Values from User Defaults
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == TunnelErrorCode, resources.tunnelErrorCode == 3 {
            postDnsFiltersOverlimitNotificationIfNedeed()
        }
    }
    
    //MARK: - Private methods
    
    private func prepareControllers() {
        setappService.start()
        
        guard let mainPageController = getMainPageController() else {
            DDLogError("mainPageController is nil")
            return
        }
        
        mainPageController.onReady = { [weak self] in
            // request permission for user notifications posting
            self?.userNotificationService.requestPermissions()
            
            // Show rate app dialog when main page is initialized
            self?.showRateAppDialogIfNedeed()
        }
        
        guard let dnsLogContainerVC = getDnsLogContainerController() else {
            DDLogError("dnsLogContainerVC is nil")
            return
        }
        /**
         To quickly show stats in ActivityViewController, we load ViewController when app starts
         */
        dnsLogContainerVC.loadViewIfNeeded()
    }
    
    
    private func postDnsFiltersOverlimitNotificationIfNedeed(){
        let rulesNumberString = String.simpleThousandsFormatting(NSNumber(integerLiteral: dnsFiltersService.enabledRulesCount))
        let title = String.localizedString("dns_filters_notification_title")
        let body = String(format: String.localizedString("dns_filters_overlimit_title"), rulesNumberString)
        let userInfo: [String : Int] = [PushNotificationCommands.command : PushNotificationCommands.openDnsFiltersController.rawValue]
        userNotificationService.postNotification(title: title, body: body, userInfo: userInfo)
    }
    
    private func showRateAppDialogIfNedeed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            if self.rateService.shouldShowRateAppDialog {
                AppDelegate.shared.presentRateAppController()
                self.resources.rateAppShown = true
            }
        }
    }
    
    private func startAntibannerController() {
        antibannerController.start()
        
        antibannerController.onReady { [weak self] (_) in
            guard let self = self else { return }
            guard let fetchPerformer = self.fetchPerformer else { return }
            if (self.firstRun) {
                self.migrationService.install()
                self.purchaseService.checkLicenseStatus()
                self.firstRun = false
            }
            
            self.migrationService.migrateIfNeeded(inBackground: fetchPerformer.isBackground)
        }
    }
    
    private func updateAntibannerContoller() {
        antibannerController.onReady { antibanner in
            antibanner.repairUpdateState { [weak self] in
                guard let self = self else { return }
                if self.activateWithOpenUrl {
                    self.activateWithOpenUrl = false
                    DDLogInfo("(AppDelegate - applicationDidBecomeActive) Update process did not start because app activated with open URL.")
                    return
                }
                
                if antibanner.updatesRightNow {
                    DDLogInfo("(AppDelegate - applicationDidBecomeActive) Update process did not start because it is performed right now.")
                    return
                }
                
                self.fetchPerformer?.invalidateAntibannerIfNeeded()
            }
        }
    }
    
    private func addPurchaseStatusObserver() {
         if purchaseObservation == nil {
             purchaseObservation = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: nil, queue: nil) { (notification) in
                 guard let type =  notification.userInfo?[PurchaseService.kPSNotificationTypeKey] as? String else { return }
                 
                 DDLogInfo("(AppDelegate) - Received notification type = \(type)")
                 
                 if type == PurchaseService.kPSNotificationPremiumExpired {
                     self.userNotificationService.postNotification(title: ACLocalizedString("premium_expired_title", nil), body: ACLocalizedString("premium_expired_message", nil), userInfo: nil)
                 }
             }
         }
         
         if proStatusObservation == nil {
             proStatusObservation = configuration.observe(\.proStatus) { [weak self] (_, _) in
                 guard let self = self else { return }
                 if !self.configuration.proStatus && self.vpnManager.vpnInstalled {
                     DDLogInfo("(AppDelegate) Remove vpn configuration")
                     self.vpnManager.removeVpnConfiguration { (error) in
                         if error != nil {
                             DDLogError("(AppDelegate) Remove vpn configuration failed: \(error!)")
                         }
                     }
                 }
             }
         }
     }
    
    private func subscribeToNotifications() {
        resources.sharedDefaults().addObserver(self, forKeyPath: TunnelErrorCode, options: .new, context: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ConfigurationService.themeChangeNotification), object: nil, queue: nil) { [weak self] _ in
            self?.window?.backgroundColor = self?.themeService.backgroundColor
        }
    }
    
    //MARK: - Init logger
    
    private func initLogger() {
        let isDebugLogs = resources.sharedDefaults().bool(forKey: AEDefaultsDebugLogs)
        DDLogInfo("(AppDelegate) Init app with loglevel %s", level: isDebugLogs ? .debug : .all)
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
        
        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif
        
        DDLogInfo("Application started. Version: \(productInfo.buildVersion() ?? "nil")")
    }
}


