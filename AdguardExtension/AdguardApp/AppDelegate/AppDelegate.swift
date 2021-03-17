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
    var window: UIWindow?
    
    private let statusBarProcessor: IStatusBarWindow
    private var appDelegateHelper: IAppDelegateHelper?

    //MARK: - Services
    private lazy var resources: AESharedResourcesProtocol =  { ServiceLocator.shared.getService()! }()
    private lazy var antibannerController: AntibannerControllerProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var contentBlockerService: ContentBlockerService = { ServiceLocator.shared.getService()! }()
    private lazy var purchaseService: PurchaseServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var antibanner: AESAntibannerProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var dnsFiltersService: DnsFiltersServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var networking: ACNNetworking = { ServiceLocator.shared.getService()! }()
    private lazy var configuration: ConfigurationService = { ServiceLocator.shared.getService()! }()
    private lazy var safariService: SafariService = { ServiceLocator.shared.getService()! }()
    private lazy var productInfo: ADProductInfoProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var migrationService: MigrationServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var userNotificationService: UserNotificationServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var vpnManager: VpnManagerProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var setappService: SetappServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var activityStatisticsService: ActivityStatisticsServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var dnsStatisticsService: DnsStatisticsServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var dnsLogRecordsService: DnsLogRecordsServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var rateService: RateAppServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var complexProtection: ComplexProtectionServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var themeService: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var filtersService: FiltersServiceProtocol = { ServiceLocator.shared.getService()! }()

    //MARK: - Application init
    override init() {
        StartupService.start()
        self.statusBarProcessor = StatusBarWindow()
        super.init()
        
        appDelegateHelper = AppDelegateHelper(resources: resources,
                                          migrationService: migrationService,
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
                                          productInfo: productInfo,
                                          antibannerController: antibannerController,
                                          statusBarProcessor: statusBarProcessor,
                                          appDelegate: self)
        
        
    }
    
    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: TunnelErrorCode)
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //------------- Preparing for start application. Stage 1. -----------------
        appDelegateHelper?.willFinishLaunching()
        
        initLogger()
        DDLogInfo("(AppDelegateHelper) Preparing for start application. Stage 1.")

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
        
        appDelegateHelper?.didFinishLaunching()
        
        resources.sharedDefaults().addObserver(self, forKeyPath: TunnelErrorCode, options: .new, context: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: ConfigurationService.themeChangeNotification), object: nil, queue: nil) { [weak self] _ in
            self?.window?.backgroundColor = self?.themeService.backgroundColor
        }
        
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
        appDelegateHelper?.didBecomeActive(application)
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillTerminate.")
        resources.synchronizeSharedDefaults()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        appDelegateHelper?.performFetch(with: completionHandler)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DDLogError("(AppDelegate) application Open URL.")
        appDelegateHelper?.activateWithOpenUrl = true
        
        let urlParser: IURLSchemeParser = URLSchemeParser(executor: self,
                                                          configurationService: configuration)
        
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
    
    //MARK: - Init logger
    
    private func initLogger() {
        let isDebugLogs = resources.sharedDefaults().bool(forKey: AEDefaultsDebugLogs)
        DDLogInfo("(AppDelegateHelper) Init app with loglevel %s", level: isDebugLogs ? .debug : .all)
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
        
        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif
        
        DDLogInfo("Application started. Version: \(productInfo.buildVersion() ?? "nil")")
    }
}


