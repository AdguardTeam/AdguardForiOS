protocol IAppDelegateHelper {
    var activateWithOpenUrl: Bool { get set }
    func willFinishLaunching()
    func didFinishLaunching()
    func performFetch(with completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    func didBecomeActive(_ application: UIApplication)
}

fileprivate enum AEUpdateResult: UInt {
    case AEUpdateNotStarted,
         AEUpdateStarted,
         AEUpdateNewData,
         AEUpdateFailed,
         AEUpdateNoData
}

//MARK: - Constants
private let AS_EXECUTION_PERIOD_TIME: Double = 3600 // 1 hours
private let AS_EXECUTION_LEEWAY: Double = 5 // 5 seconds
private let AS_EXECUTION_DELAY: Double = 2 // 2 seconds

private let AS_CHECK_FILTERS_UPDATES_PERIOD: Double = AS_EXECUTION_PERIOD_TIME * 6
private let AS_CHECK_FILTERS_UPDATES_FROM_UI_DELAY: Double = AS_EXECUTION_DELAY
private let AS_CHECK_FILTERS_UPDATES_LEEWAY: Double = AS_EXECUTION_LEEWAY
private let AS_CHECK_FILTERS_UPDATES_DEFAULT_PERIOD: Double = AS_EXECUTION_PERIOD_TIME * 6

private let AS_FETCH_UPDATE_STATUS_PERIOD: Double = AS_CHECK_FILTERS_UPDATES_PERIOD / 6

/// Timeout for downloading of data from the remote services
private let AS_URL_LOAD_TIMEOUT: Double = 60
// ----------------------------------

private let DNS_FILTERS_CHECK_LIMIT:Double = 21600 // 6 hours

final class AppDelegateHelper: NSObject, IAppDelegateHelper {
    //MARK: - Init
    init(resources: AESharedResourcesProtocol,
         migrationService: MigrationServiceProtocol,
         purchaseService: PurchaseServiceProtocol,
         configuration: ConfigurationService,
         vpnManager: VpnManagerProtocol,
         userNotificationService: UserNotificationServiceProtocol,
         contentBlockerService: ContentBlockerServiceProtocol,
         antibanner: AESAntibannerProtocol,
         complexProtection: ComplexProtectionServiceProtocol,
         dnsFiltersService: DnsFiltersServiceProtocol,
         safariService: SafariServiceProtocol,
         networking: ACNNetworking,
         productInfo: ADProductInfoProtocol,
         antibannerController: AntibannerControllerProtocol,
         statusBarProcessor: IStatusBarProcessor,
         appDelegate: AppDelegate) {
        
        self.resources = resources
        self.migrationService = migrationService
        self.purchaseService = purchaseService
        self.configuration = configuration
        self.vpnManager = vpnManager
        self.userNotificationService = userNotificationService
        self.contentBlockerService = contentBlockerService
        self.antibanner = antibanner
        self.complexProtection = complexProtection
        self.dnsFiltersService = dnsFiltersService
        self.safariService = safariService
        self.networking = networking
        self.productInfo = productInfo
        self.antibannerController = antibannerController
        self.statusBarProcessor = statusBarProcessor
        self.appDelegate = appDelegate
    }
    
    //MARK: - Properties
    private let ASAntibannerUpdatedFiltersKey = "ASAntibannerUpdatedFiltersKey"
    private let ASAntibannerInstalledNotification = "ASAntibannerInstalledNotification"
    private let ASAntibannerNotInstalledNotification = "ASAntibannerNotInstalledNotification"
    private let ASAntibannerReadyNotification = "ASAntibannerReadyNotification"
    private let ASAntibannerUpdateFilterRulesNotification = "ASAntibannerUpdateFilterRulesNotification"
    private let ASAntibannerStartedUpdateNotification = "ASAntibannerStartedUpdateNotification"
    private let ASAntibannerDidntStartUpdateNotification = "ASAntibannerDidntStartUpdateNotification"
    private let ASAntibannerFinishedUpdateNotification = "ASAntibannerFinishedUpdateNotification"
    private let ASAntibannerFailuredUpdateNotification = "ASAntibannerFailuredUpdateNotification"
    private let ASAntibannerUpdateFilterFromUINotification = "ASAntibannerUpdateFilterFromUINotification"
    private let ASAntibannerUpdatePartCompletedNotification = "ASAntibannerUpdatePartCompletedNotification"
    private let ASAntibannerFilterEnabledNotification = "ASAntibannerFilterEnabledNotification"
    
    private let appDelegateUpdatedFiltersKey = "AppDelegateUpdatedFiltersKey"
    
    private let resources: AESharedResourcesProtocol
    private let migrationService: MigrationServiceProtocol
    private let purchaseService: PurchaseServiceProtocol
    private let configuration: ConfigurationService
    private let vpnManager: VpnManagerProtocol
    private let userNotificationService: UserNotificationServiceProtocol
    private let contentBlockerService: ContentBlockerServiceProtocol
    private let antibanner: AESAntibannerProtocol
    private let complexProtection: ComplexProtectionServiceProtocol
    private let dnsFiltersService: DnsFiltersServiceProtocol
    private let safariService: SafariServiceProtocol
    private let networking: ACNNetworking
    private let productInfo: ADProductInfoProtocol
    private let statusBarProcessor: IStatusBarProcessor
    private let appDelegate: AppDelegate
    
    private var fetchCompletion: ((UIBackgroundFetchResult) -> Void)?
    private var downloadCompletion: (() -> Void)?
    private var updatedFilters = [ASDFilterMetadata]()
    
    private var antibanerUpdateResult: AEUpdateResult?
    private var blockingSubscriptionsUpdateResult: AEUpdateResult?
    
    private var purchaseObservation: Any?
    private var proStatusObservation: Any?
    
    private var showStatusBarNotification: NotificationToken?
    private var hideStatusBarNotification: NotificationToken?
    private var orientationChangeNotification: NotificationToken?
    
    private var firstRun: Bool {
        get {
            resources.sharedDefaults().object(forKey: AEDefaultsFirstRunKey) as? Bool ?? true
        }
        set {
            resources.sharedDefaults().set(newValue, forKey: AEDefaultsFirstRunKey)
        }
    }
    
    private var fetchState: BackgroundFetchState {
        get {
            return resources.backgroundFetchState
        }
        set {
            resources.backgroundFetchState = newValue
        }
    }
    
    private var isBackground: Bool {
        return (fetchCompletion != nil) || (downloadCompletion != nil)
    }
    
    private let antibannerController: AntibannerControllerProtocol
    
    var activateWithOpenUrl: Bool = false
    
    
    //MARK: - IAppDelegateHelp methods
    func willFinishLaunching() {
        antibannerController.start()
        
        addPurchaseStatusObserver()
        
        antibannerController.onReady { [weak self] (_) in
            guard let self = self else { return }
            if (self.firstRun) {
                self.migrationService.install()
                self.purchaseService.checkLicenseStatus()
                self.firstRun = false
            }
            
            
            self.migrationService.migrateIfNeeded(inBackground: self.isBackground)
        }
        
        // Init Logger
        let isDebugLogs = resources.sharedDefaults().bool(forKey: AEDefaultsDebugLogs)
        DDLogInfo("(AppDelegateHelper) Init app with loglevel %s", level: isDebugLogs ? .debug : .all)
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
        
        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif
        
        
        DDLogInfo("Application started. Version: \(productInfo.buildVersion() ?? "nil")")
        
        DDLogInfo("(AppDelegateHelper) Preparing for start application. Stage 1.")
        
        fetchCompletion = nil
        downloadCompletion = nil
        activateWithOpenUrl = false
    }
    
    func didFinishLaunching() {
        //------------ Subscribe to Antibanner notifications -----------------------------
        subscribeToAntibannerNotifications()
        
        //------------ Subscribe other notifications -----------------------------
        subscribeToOtherNotifications()
        
        //---------------------- Set period for checking filters ---------------------
        setPeriodForCheckingFilters()
    }
    
    func performFetch(with completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        addPurchaseStatusObserver()
        DDLogInfo("(AppDelegateHelper) application perform Fetch.")
        
        if fetchCompletion != nil {
            // In this case we receive fetch event when previous event still not processed.
            DDLogInfo("(AppDelegateHelper) Previous Fetch still not processed.")
            
            // handle new completion handler
            fetchCompletion = completionHandler
            
            return
        }
        
        let checkResult = self.checkAutoUpdateConditions()
        
        //Entry point for updating of the filters
        fetchCompletion = completionHandler
        
        // Update safari filters
        
        antibannerController.onReady { [weak self] antibaner in
            guard let self = self else { return }
            self.antibanner.repairUpdateState {
                if self.antibanner.updatesRightNow {
                    DDLogInfo("(AppDelegateHelper) Update process did not start because it is performed right now.")
                    return
                }
                
                if !checkResult {
                    DDLogInfo("(AppDelegateHelper - Background Fetch) Cancel fetch. App settings permit updates only over WiFi.")
                    self.antibanerUpdateResult = AEUpdateResult(rawValue: UIBackgroundFetchResult.noData.rawValue)
                } else {
                    self.antibanerUpdateResult = .AEUpdateStarted
                }
                
                switch self.fetchState {
                case .notStarted, .filtersupdating:
                    self.fetchState = .filtersupdating
                    
                    if !(checkResult && self.invalidateAntibanner(fromUI: false, interactive: false)) {
                        self.fetchState = .notStarted
                        self.antibanerUpdateFinished(result: .AEUpdateNoData)
                    }
                case .filtersupdated, .contentBlockersUpdating:
                    self.fetchState = .contentBlockersUpdating
                    self.contentBlockerService.reloadJsons(backgroundUpdate: true) { [weak self] error in
                        if let _ = error {
                            self?.fetchState = .notStarted
                        } else {
                            self?.fetchState = .contentBlockersUpdated
                        }
                        self?.antibanerUpdateFinished(result: .AEUpdateNoData)
                    }
                case .contentBlockersUpdated, .safariUpdating:
                    self.fetchState = .safariUpdating
                    self.safariService.invalidateBlockingJsons { [weak self] _ in
                        self?.fetchState = .notStarted
                        self?.antibanerUpdateFinished(result: .AEUpdateNoData)
                    }
                default:
                    self.antibanerUpdateFinished(result: .AEUpdateNoData)
                }
            }
            
            self.purchaseService.checkPremiumStatusChanged()
        }
    }
    
    func didBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        DDLogInfo("(AppDelegateHelper) applicationDidBecomeActive.")
        onApplicationDidBecomeActive(application)
        
        // If theme mode is System Default gets current style
        appDelegate.setAppInterfaceStyle()
        
        antibannerController.onReady { antibanner in
            antibanner.repairUpdateState { [weak self] in
                guard let self = self else { return }
                if self.activateWithOpenUrl {
                    self.activateWithOpenUrl = false
                    DDLogInfo("(AppDelegateHelper - applicationDidBecomeActive) Update process did not start because app activated with open URL.")
                    return
                }
                
                if antibanner.updatesRightNow {
                    DDLogInfo("(AppDelegateHelper - applicationDidBecomeActive) Update process did not start because it is performed right now.")
                    return
                }
                
                //Entry point for updating of the filters
                if self.checkAutoUpdateConditions() {
                    _ = self.invalidateAntibanner(fromUI: false, interactive: true)
                }
            }
        }
    }
    
    private func onApplicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        statusBarProcessor.createStatusBarWindow()
        statusBarProcessor.statusBarWindowIsHidden = true
        
        showStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.ShowStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.statusBarProcessor.showStatusViewIfNeeded(configuration: self.configuration, notification: notification)
            }
        })
        
        hideStatusBarNotification = NotificationCenter.default.observe(name: NSNotification.Name.HideStatusView, object: nil, queue: nil, using: {[weak self] (notification) in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.statusBarProcessor.hideStatusViewIfNeeded()
            }
        })
        
        orientationChangeNotification = NotificationCenter.default.observe(name: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            DispatchQueue.main.async { [weak self] in
                self?.statusBarProcessor.changeOrientation()
            }
        })
        
        resources.sharedDefaults().addObserver(self, forKeyPath: TunnelErrorCode, options: .new, context: nil)
    }
    
    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: TunnelErrorCode)
    }
    
    //MARK: - Antibanner methods
    private func invalidateAntibanner(fromUI: Bool, interactive: Bool) -> Bool {
        
        DispatchQueue(label: "AppDelegateHelper-queue").sync {
            guard let lastCheck = resources.sharedDefaults().object(forKey: AEDefaultsCheckFiltersLastDate) as? NSDate else { return false }
            if fromUI || (lastCheck.timeIntervalSinceNow * -1.0) >= AS_CHECK_FILTERS_UPDATES_PERIOD {
                
                if fromUI {
                    DDLogInfo("(AppDelegateHelper) Update process started from UI.")
                } else {
                    DDLogInfo("(AppDelegateHelper) Update process started by timer.")
                }
                
                var result = false;
                
                antibanner.beginTransaction()
                DDLogInfo("(AppDelegateHelper) Begin of the Update Transaction from - invalidateAntibanner.")
                
                result = antibanner.startUpdatingForced(fromUI, interactive: interactive)
                
                if !result {
                    DDLogInfo("(AppDelegateHelper) Update process did not start because [antibanner startUpdatingForced] return NO.")
                    antibanner.rollbackTransaction()
                    DDLogInfo("(AppDelegateHelper) Rollback of the Update Transaction from ASAntibannerDidntStartUpdateNotification.")
                }
                
                return result
            }
            
            DDLogInfo("(AppDelegateHelper) Update process NOT started by timer. Time period from previous update too small.")
            
            antibanerUpdateFinished(result: .AEUpdateFailed)
            
            return false
        }
    }
    
    //MARK: - Observers methods
    private func addPurchaseStatusObserver() {
        if purchaseObservation == nil {
            purchaseObservation = NotificationCenter.default.observe(name: Notification.Name(PurchaseService.kPurchaseServiceNotification), object: nil, queue: nil) { (notification) in
                guard let type =  notification.userInfo?[PurchaseService.kPSNotificationTypeKey] as? String else { return }
                
                DDLogInfo("(AppDelegateHelper) - Received notification type = \(type)")
                
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
    
    //MARK: - Notification selectors
    @objc private func antibannerNotify(notification: Notification) {
        // Update filter rules
        if notification.name == .ASAntibannerUpdateFilterRules {
            if self.isBackground {
                DDLogInfo("(AppDelegateHelper) antibannerNotify. Skip in background")
                return
            }
            
            contentBlockerService.reloadJsons(backgroundUpdate: false) { [weak self] error in
                guard let self = self else { return }
                if let _ = error {
                    self.antibanner.rollbackTransaction()
                    DDLogInfo("(AppDelegateHelper) Rollback of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.")
                    
                    self.updateFailuredNotify()
                    
                    DispatchQueue.main.async {
                        guard let nav = self.getNavigationController() else { return }
                        if let topViewController = nav.topViewController, UIApplication.shared.applicationState != .background {
                            ACSSystemUtils.showSimpleAlert(for: topViewController,
                                                           withTitle: ACLocalizedString("common_error_title", "(AEUISubscriptionController) Alert title. When converting rules process finished in foreground updating."),
                                                           message: ACLocalizedString("load_to_safari_error", "(AppDelegateHelper) Alert message. When converting rules process finished in foreground updating."))
                        }
                    }
                } else  {
                    // Success antibanner updated from backend
                    
                    self.resources.sharedDefaults().setValue(Date(), forKey: AEDefaultsCheckFiltersLastDate)
                    DDLogInfo("(AppDelegateHelper) End of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.")
                    self.updateFinishedNotify(filtersUpdated: false)
                }
            }
        }
        // Update started
        else if notification.name == .ASAntibannerStartedUpdate {
            if !isBackground {
                // turn on network activity indicator
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.updateStartedNotify()
            }
        }
        // Update did not start
        else if notification.name == .ASAntibannerDidntStartUpdate {
            self.updateDidNotStartNotify()
            
            if antibanner.inTransaction() {
                antibanner.rollbackTransaction()
                DDLogInfo("(AppDelegateHelper) Rollback of the Update Transaction from ASAntibannerDidntStartUpdateNotification.")
            }
            // Special update case.
            fetchState = .notStarted
            self.antibanerUpdateFinished(result: .AEUpdateFailed)
        }
        // Update performed
        else if notification.name == .ASAntibannerFinishedUpdate {
            if isBackground {
                fetchState = .filtersupdated
                antibanner.endTransaction()
                self.antibanerUpdateFinished(result: .AEUpdateNewData)
                return
            }
            
            if let updatedFilters = notification.userInfo?[ASAntibannerUpdatedFiltersKey] as? [ASDFilterMetadata] {
                self.updatedFilters = updatedFilters
            }
            
            contentBlockerService.reloadJsons(backgroundUpdate: true) { [weak self] _ in
                guard let self = self else { return }
                if self.antibanner.inTransaction() {
                    // Success antibanner updated from backend
                    self.resources.sharedDefaults().setValue(Date(), forKey: AEDefaultsCheckFiltersLastDate)
                    self.antibanner.endTransaction()
                    DDLogInfo("(AppDelegateHelper) End of the Update Transaction from ASAntibannerFinishedUpdateNotification.")
                    self.updateFinishedNotify(filtersUpdated: true)
                }
                
                // Special update case (in background).
                self.antibanerUpdateFinished(result: .AEUpdateNewData)
            }
            
            // turn off network activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        // Update failed
        else if notification.name == .ASAntibannerFailuredUpdate {
            
            if antibanner.inTransaction() {
                antibanner.rollbackTransaction()
                DDLogInfo("(AppDelegateHelper) Rollback of the Update Transaction from ASAntibannerFailuredUpdateNotification.")
            }
            
            self.updateFailuredNotify()
            
            // Special update case.
            fetchState = .notStarted
            self.antibanerUpdateFinished(result: .AEUpdateFailed)
            
            // turn off network activity indicator
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        } else if notification.name == .ASAntibannerUpdatePartCompleted {
            DDLogInfo("(AppDelegateHelper) Antibanner update PART notification.")
            
        } else if notification.name == .ASAntibannerInstalled {
            contentBlockerService.reloadJsons(backgroundUpdate: true) { _ in
                DDLogInfo("(AppDelegateHelper) content blocker reloaded after antibanner notification ASAntibannerInstalledNotification")
            }
        }
    }
    
    @objc private func showAlertNotification(notification: Notification) {
        let body = notification.userInfo?[UserNotificationService.notificationBody] as? String
        let title = notification.userInfo?[UserNotificationService.notificationTitle] as? String
        showCommonAlertForTopVc(body, title)
    }
    
    @objc private func openDnsFiltersController(notification: Notification) {
        let success = appDelegate.presentDnsFiltersController()
        DDLogInfo("Presented DnsFiltersController successfully = \(success ? "Yes" : "No")")
    }
    
    private func showCommonAlertForTopVc(_ body: String?, _ title: String?) {
        DispatchQueue.main.async {
            if let topVC = AppDelegate.topViewController() {
                ACSSystemUtils.showSimpleAlert(for: topVC, withTitle: body, message: title)
            }
        }
    }
    
    //MARK: - Update Manager methods (private)
    
    private func updateStartedNotify() {
        ACSSystemUtils.call {
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AppDelegateHelper) Started update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateStartedUpdateNotification, object: self)
        }
    }
    
    private func updateDidNotStartNotify() {
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AppDelegateHelper) Did not started update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateUpdateDidNotStartedNotification, object: self)
        }
    }
    
    private func updateFailuredNotify() {
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AppDelegateHelper) Failured update process. AppState = \(appState.rawValue)")
            
            NotificationCenter.default.post(name: .appDelegateFailuredUpdateNotification, object: self)
        }
    }
    
    private func updateFinishedNotify(filtersUpdated: Bool) {
        DDLogInfo("(AppDelegateHelper) Finished update process.")
        
        var metas = [ASDFilterMetadata]()
        
        if filtersUpdated {
            metas = updatedFilters
            updatedFilters.removeAll()
        }
        
        ACSSystemUtils.call { [weak self] in
            let appState = UIApplication.shared.applicationState
            DDLogInfo("(AppDelegateHelper) Finished update process, updated filters = \(metas.count). AppState = \(appState.rawValue)")
            
            let userInfo = [Notification.Name.appDelegateUpdatedFiltersKey: metas.count]
            NotificationCenter.default.post(name: .appDelegateFinishedUpdateNotification, object: self, userInfo: userInfo)
        }
    }
    
    private func resultDescription(result: AEUpdateResult) -> String {
        let names = ["AEUpdateNotStarted",
                     "AEUpdateStarted",
                     "AEUpdateNewData",
                     "AEUpdateFailed",
                     "AEUpdateNoData"]
        
        return names[Int(result.rawValue)]
    }
    
    private func antibanerUpdateFinished(result: AEUpdateResult) {
        DDLogInfo("(AppDelegateHelper) antibanerUpdateFinished with result: \(self.resultDescription(result: result))")
        self.antibanerUpdateResult = result
        
        updateDnsFiltersIfNeeded { [weak self] in
            self?.updateFinished()
        }
    }
    
    private func updateFinished() {
        
        DDLogInfo("(AppDelegateHelper) updateFinished")
        
        if(self.antibanerUpdateResult == .AEUpdateStarted || self.blockingSubscriptionsUpdateResult == .AEUpdateStarted) {
            return
        }
        
        var result: UIBackgroundFetchResult!
        
        if(self.antibanerUpdateResult == .AEUpdateNewData || self.blockingSubscriptionsUpdateResult == .AEUpdateNewData) {
            result = .newData
        } else if (self.antibanerUpdateResult == .AEUpdateNoData && self.blockingSubscriptionsUpdateResult == .AEUpdateNoData) {
            result = .noData
        } else {
            result = .failed
        }
        
        self.callCompletionHandler(result: result)
    }
    
    private func callCompletionHandler(result: UIBackgroundFetchResult) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.fetchCompletion != nil {
                let resultName = [
                    "NewData",
                    "NoData",
                    "Failed"]
                DDLogInfo("(AppDelegateHelper - Background Fetch) Call fetch Completion. With result: \(resultName[Int(result.rawValue)])")
                self.fetchCompletion?(result)
                self.fetchCompletion = nil
            } else if self.downloadCompletion != nil {
                DDLogInfo("(AppDelegateHelper - Background update downloads) Call Completion.")
                self.downloadCompletion?()
                self.downloadCompletion = nil
            }
        }
    }
    
    private func setPeriodForCheckingFilters() {
        
        var interval: TimeInterval = TimeInterval(AS_FETCH_UPDATE_STATUS_PERIOD)
        if (interval < UIApplication.backgroundFetchIntervalMinimum) {
            interval = UIApplication.backgroundFetchIntervalMinimum
        }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(interval)
        DDLogInfo("(AppDelegateHelper) Set background fetch interval: \(interval)")
        
    }
    
    //MARK: - Notification subscription
    
    private func subscribeToAntibannerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: NSNotification.Name(rawValue: ASAntibannerFailuredUpdateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: NSNotification.Name(rawValue: ASAntibannerFinishedUpdateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: NSNotification.Name(rawValue: ASAntibannerStartedUpdateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: NSNotification.Name(rawValue: ASAntibannerDidntStartUpdateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: NSNotification.Name(rawValue: ASAntibannerUpdateFilterRulesNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: NSNotification.Name(rawValue: ASAntibannerUpdatePartCompletedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(antibannerNotify(notification:)), name: NSNotification.Name(rawValue: ASAntibannerInstalledNotification), object: nil)
    }
    
    private func subscribeToOtherNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertNotification(notification:)), name: NSNotification.showCommonAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openDnsFiltersController(notification:)), name: NSNotification.showDnsFiltersController, object: nil)
    }
    
    //MARK: - Update tunnel
    private func updateDnsFiltersIfNeeded( callback: @escaping ()->Void) {
            let lastCheckTime = resources.lastDnsFiltersUpdateTime ?? Date(timeIntervalSince1970: 0)
            let interval = Date().timeIntervalSince(lastCheckTime)
            let checkResult = checkAutoUpdateConditions()
            if !dnsFiltersService.filtersAreUpdating
                && Int(interval) > Int(DNS_FILTERS_CHECK_LIMIT)
                && configuration.proStatus
                && checkResult {
                resources.lastDnsFiltersUpdateTime = Date()
                
                DDLogInfo("(AppDelegateHelper) updateDnsFiltersIfNeeded - update dns filters")
                dnsFiltersService.updateFilters(networking: networking) { [weak self] in
                    
                    DDLogInfo("(AppDelegateHelper) updateDnsFiltersIfNeeded - dns filters are updeted")
                    self?.updateTunnelSettingsIfAppropriate {
                        callback()
                    }
                }
            }
            else {
                DDLogInfo("(AppDelegateHelper) updateDnsFiltersIfNeeded - not all conditions are met")
                callback()
            }
        }
    /**
     Do not update VPN configuration if:
     1. System protection is disabled
     2. DNS implementation is native
     3. Application is in background state (we are not sure if VPN configuration is active)
     */
    
    private func updateTunnelSettingsIfAppropriate(callback: @escaping ()->Void ) {
        vpnManager.getConfigurationStatus { [weak self] (status) in
            guard let self = self else { return }
            if self.complexProtection.systemProtectionEnabled, self.resources.dnsImplementation == .adGuard, status.configurationIsActive, self.dnsFiltersService.enabledFiltersCount > 0 {
                self.vpnManager.updateSettings { _ in
                    callback()
                }
            }
            else {
                callback()
            }
        }
    }
    
    private func getNavigationController() -> UINavigationController? {
        guard let nav = appDelegate.window?.rootViewController as? UINavigationController else { return nil }
        return nav
    }
    
    private func checkAutoUpdateConditions()->Bool {
        
        if !resources.wifiOnlyUpdates {
            return true
        }
        
        let reachability = Reachability.forInternetConnection()
        let reachable = reachability?.isReachableViaWiFi() ?? false
        if !reachable {
            DDLogInfo("(AppDelegateHelper - checkAutoUpdateConditions) App settings permit updates only over WiFi.")
        }
        return reachable
    }
}

extension Notification.Name {
    static let appDelegateStartedUpdateNotification = Notification.Name("AppDelegateStartedUpdateNotification")
    static let appDelegateUpdateDidNotStartedNotification = Notification.Name("AppDelegateUpdateDidNotStartedNotification")
    static let appDelegateFinishedUpdateNotification = Notification.Name("AppDelegateFinishedUpdateNotification")
    static let appDelegateFailuredUpdateNotification = Notification.Name("AppDelegateFailuredUpdateNotification")
    static let appDelegateUpdatedFiltersKey = Notification.Name("AppDelegateUpdatedFiltersKey")
}
