//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK
import SafariAdGuardSDK
import DnsAdGuardSDK
import AGDnsProxy
import Sentry
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Public properties

    var window: UIWindow?

    // MARK: - Private properties

    private var statusBarManager: StatusBarManager?

    /* Pro status observers */
    private var purchaseObservation: NotificationToken?
    private var proStatusObservation: NotificationToken?
    private var setappObservation: NotificationToken?

    private var firstRun: Bool {
        get {
            resources.firstRun
        }
        set {
            resources.firstRun = newValue
        }
    }
    private var activateWithOpenUrl: Bool = false

    // MARK: - Services

    private let resources: AESharedResourcesProtocol
    private let safariProtection: SafariProtectionProtocol
    private let dnsProtection: DnsProtectionProtocol
    private let purchaseService: PurchaseServiceProtocol
    private let networking: ACNNetworking
    private let configuration: ConfigurationServiceProtocol
    private let productInfo: ADProductInfoProtocol
    private let migrationService: MigrationServiceProtocol
    private let userNotificationService: UserNotificationServiceProtocol
    private let vpnManager: VpnManagerProtocol
    private let setappService: SetappServiceProtocol
    private let rateService: RateAppServiceProtocol
    private let complexProtection: ComplexProtectionServiceProtocol
    private let themeService: ThemeServiceProtocol
    private let dnsConfigAssistant: DnsConfigManagerAssistantProtocol
    private let remoteMigrationService: RemoteMigrationService

    // MARK: - Application init

    override init() {
        let resources = StartupService.initResources()

        AppDelegate.initLogger(resources: resources)
        DDLogInfo("Starting application")

        // StartupService may perform slow operations involving working with files or SQLite database.
        // It is safer to try to protect it from suspending by using a background task.
        _ = UIBackgroundTask.execute(name: "AppDelegate.init") {
            StartupService.start()
        }

        self.resources = ServiceLocator.shared.getService()!
        self.safariProtection = ServiceLocator.shared.getService()!
        self.purchaseService = ServiceLocator.shared.getService()!
        self.networking = ServiceLocator.shared.getService()!
        self.configuration = ServiceLocator.shared.getService()!
        self.productInfo = ServiceLocator.shared.getService()!
        self.migrationService = ServiceLocator.shared.getService()!
        self.userNotificationService = ServiceLocator.shared.getService()!
        self.vpnManager = ServiceLocator.shared.getService()!
        self.setappService = ServiceLocator.shared.getService()!
        self.rateService = ServiceLocator.shared.getService()!
        self.complexProtection = ServiceLocator.shared.getService()!
        self.themeService = ServiceLocator.shared.getService()!
        self.dnsProtection = ServiceLocator.shared.getService()!
        self.dnsConfigAssistant = ServiceLocator.shared.getService()!
        self.remoteMigrationService = ServiceLocator.shared.getService()!

        super.init()

        DDLogInfo("Application has been started. Version: \(productInfo.buildVersion() ?? "nil")")
    }

    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: TunnelErrorCode)
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        DDLogInfo("(AppDelegate) willFinishLaunchingWithOptions called in background=\(application.applicationState == .background)")

        //------------- Preparing for start application. Stage 1. -----------------

        // Do not migrate data while background fetch
        if application.applicationState != .background {
            migrationService.migrateIfNeeded()
        }
        purchaseService.checkLicenseStatus(completion: nil)

        activateWithOpenUrl = false

        DDLogInfo("(AppDelegate) Preparing for start application. Stage 1.")

        //------------ Interface Tuning -----------------------------------
        self.window?.backgroundColor = UIColor.clear

        if application.applicationState != .background {
            purchaseService.checkPremiumStatusChanged()
            checkRemoteMigration()
        }

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        DDLogInfo("(AppDelegate) didFinishLaunchingWithOptions called in background=\(application.applicationState == .background)")

        SentrySDK.start { options in
            options.dsn = Constants.Sentry.dsnUrl
            options.enableAutoSessionTracking = false
        }

        if application.applicationState != .background {
            prepareControllers()
        }

        //------------- Preparing for start application. Stage 2. -----------------
        DDLogInfo("(AppDelegate) Preparing for start application. Stage 2.")

        let interval = resources.backgroundFetchUpdatePeriod.interval
        AppDelegate.setBackgroundFetchInterval(interval)
        subscribeToNotifications()

        // Install default DNS filter if needed
        if application.applicationState != .background {
            let defaultDnsFilterInstaller = DefaultDnsFilterInstaller(resources: resources, dnsProtection: dnsProtection)
            defaultDnsFilterInstaller.installDefaultDnsFilterIfNeeded()
        }

        if firstRun && application.applicationState != .background {
            configuration.showStatusBar = false
            // TODO: this is a slow operation that works with network and it is called on the main thread, rework this
            setupOnFirstAppRun()
            // After first app run we don't need to call finishBackgroundUpdate
            return true
        }

        // Background fetch consists of 3 steps, so if the update process didn't fully finish in the background than we should continue it here

        if application.applicationState != .background {
            safariProtection.finishBackgroundUpdate { error in
                if let error = error {
                    DDLogError("(AppDelegate) - didFinishLaunchingWithOptions; Finished background update with error: \(error)")
                    return
                }
                DDLogInfo("(AppDelegate) - didFinishLaunchingWithOptions; Finish background update successfully")
            }
        }

        return true
    }


    // MARK: - Application Delegate Methods

    func applicationWillResignActive(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillResignActive.")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationDidEnterBackground.")
        resources.synchronizeSharedDefaults()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillEnterForeground.")
        configuration.checkContentBlockerEnabled()
        let safariConfig = SafariConfiguration(resources: resources, isProPurchased: purchaseService.isProPurchased)
        let dnsConfig = DnsConfiguration(resources: resources, isProPurchased: purchaseService.isProPurchased)
        safariProtection.updateConfig(with: safariConfig)
        dnsProtection.updateConfig(with: dnsConfig)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationDidBecomeActive")
        application.applicationIconBadgeNumber = 0

        // If theme mode is System Default gets current style
        setAppInterfaceStyle()

        // Initialize status bar
        if statusBarManager == nil {
            let keyWindow: UIWindow?
            if #available(iOS 13.0, *) {
                keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            } else {
                keyWindow = UIApplication.shared.keyWindow
            }
            if let keyWindow = keyWindow {
                statusBarManager = StatusBarManager(configuration: configuration, keyWindow: keyWindow)
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillTerminate.")
        resources.synchronizeSharedDefaults()
    }

    // TODO: rework how background fetch works (read the description below)
    // Currently, we're using the old approach to background fetch. It guarantees that the background fetch is called
    // periodically without the need to schedule anything. The problem is that this type of fetches has rather strict
    // execution limits (i.e. it is only allowed to run for up to 30 seconds, and this value is not set in stone).
    // Our background operations may be time-consuming since both rules conversion and re-compiling Safari content
    // blockers require a lot of time. There's a solution to it in iOS 13, we should use the new Background Tasks API,
    // BGProcessingTask is ideal for our case.
    // Unfortunately, this way we'll run into a different problem. BGProcessingTask must be scheduled manually using
    // BGTaskScheduler. To make the task periodic, you may try to reschedule it again after it has been launched.
    // But once the user reboots the device, all your scheduled tasks are gone. In order to get it scheduled back, the
    // app must be launched again by the user (which may never happen in our case, users tend to not launch content
    // blockers). Also, you cannot use the old bg fetch method for scheduling since it won't work alongside the new API:
    // > In iOS 13 and later, adding a BGTaskSchedulerPermittedIdentifiers key to the Info.plist disables the
    // > application(_:performFetchWithCompletionHandler:)
    // The only feasible option to reschedule the BGProcessingTask would be to wake your app with a background push,
    // and this requires server-side changes, we'll need to actually send those push notifications when the filters
    // have been updated.
    // For more information on background update strategies check the documentation:
    // https://developer.apple.com/documentation/backgroundtasks/choosing_background_strategies_for_your_app
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Note that all heavy background operations should be accompanied by calling beginBackgroundTask/endBackgroundTask.
        // The explanation on why it is important can be found in the documentation (see the section on 0xdead10cc).
        // https://developer.apple.com/documentation/xcode/understanding-the-exception-types-in-a-crash-report
        // The problem is that it does not guarantee anything and helps only a little. There's still a high chance that
        // the app will be killed if it runs too long. Killing occurs when the system tries to suspends the app while
        // we're holding an open file handle, for instance when we are working with a file or an SQLite database. So it
        // is rather dangerous since there are risks of data corruption.
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask {
            DDLogInfo("(AppDelegate) - backgroundFetch; background task is expiring, remaining time: \(UIApplication.shared.backgroundTimeRemaining)")
        }

        if backgroundTaskId == UIBackgroundTaskIdentifier.invalid {
            DDLogError("(AppDelegate) - backgroundFetch; cannot start background operation")
            completionHandler(.noData)
            return
        }

        DDLogInfo("(AppDelegate) - backgroundFetch; start, remaining time: \(UIApplication.shared.backgroundTimeRemaining)")

        if UIApplication.shared.backgroundTimeRemaining < 20 {
            // If less than 20 seconds is available for the background task we simply don't run it.
            // The logic for using the 20 seconds limit: it takes at least 10 seconds to run rules conversion with the
            // default set of filter lists, and a couple more seconds on saving content blockers to files.
            DDLogInfo("(AppDelegate) - backgroundFetch; remaining time is not enough to complete the task, exiting immediately")
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            completionHandler(.noData)
            return
        }

        DispatchQueue.global().async {
            let result = self.backgroundFetch()
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            completionHandler(result)

            DDLogInfo("(AppDelegate) - backgroundFetch; finished successfully")
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DDLogError("(AppDelegate) application Open URL.")
        activateWithOpenUrl = true

        if setappService.openUrl(url, options: options) {
            return true
        }

        let urlParser: IURLSchemeParser = URLSchemeParser(executor: self,
                                                          configurationService: configuration)
        return urlParser.parse(url: url)
    }

    // MARK: - Public methods

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

    // TODO: - Change the way we show overlimit error for DNS filters
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == TunnelErrorCode, resources.tunnelErrorCode == 3 {
            postDnsFiltersOverlimitNotificationIfNedeed()
        }
    }

    // MARK: - Private methods

    private func backgroundFetch() -> UIBackgroundFetchResult {
        addPurchaseStatusObserver()
        purchaseService.checkLicenseStatus(completion: nil)

        checkRemoteMigrationInBackgroundFetch()

        func shouldUpdateFilters() -> Bool {
            if !resources.wifiOnlyUpdates {
                return true
            }
            let reachability = Reachability.forInternetConnection()
            let isWiFiNetwork = reachability?.isReachableViaWiFi() ?? false
            return isWiFiNetwork
        }

        let shouldUpdate = shouldUpdateFilters()
        DDLogInfo("(AppDelegate) - backgroundFetch; shouldUpdateFilters=\(shouldUpdate)")
        if !shouldUpdate {
            return .noData
        }

        // Update filters in background

        // Do not update filters in background while migration in the main process wasn't called.
        guard resources.isMigrationTo4_3Passed else {
            return .noData
        }

        var bgFetchResult: UIBackgroundFetchResult = .noData
        let group = DispatchGroup()
        group.enter()

        safariProtection.updateSafariProtectionInBackground { [weak self] result in
            if let error = result.error {
                DDLogError("(AppDelegate) - backgroundFetch; received error from SDK: \(error)")
                bgFetchResult = result.backgroundFetchResult
                group.leave()
                return
            }
            // If there was a phase with downloading filters, than we need to restart tunnel to apply newest ones.
            if result.oldBackgroundFetchState == .updateFinished || result.oldBackgroundFetchState == .loadAndSaveFilters {
                // TODO: this is rather strange that we update DNS filters as a part of SafariProtection update.
                self?.dnsConfigAssistant.applyDnsPreferences(for: .modifiedDnsFilters) { _ in
                    DDLogInfo("(AppDelegate) - backgroundFetch; background fetch ended call performFetchWithCompletionHandler after updating dns preferences")
                    bgFetchResult = result.backgroundFetchResult
                    group.leave()
                }
            } else {
                DDLogInfo("(AppDelegate) - backgroundFetch; background fetch ended call performFetchWithCompletionHandler")
                bgFetchResult = result.backgroundFetchResult
                group.leave()
            }
        }

        group.wait()
        return bgFetchResult
    }

    private func prepareControllers() {
        setappService.start()

        guard let mainPageController = getMainPageController() else {
            DDLogError("mainPageController is nil")
            return
        }

        guard let dnsLogContainerVC = getDnsLogContainerController() else {
            DDLogError("dnsLogContainerVC is nil")
            return
        }
        /**
         To quickly show stats in ActivityViewController, we load ViewController when app starts
         */
        dnsLogContainerVC.loadViewIfNeeded()
        DDLogInfo("Finished preparing controllers")
    }

    // TODO: - Change the way we show overlimit error for DNS filters and handle the error
    private func postDnsFiltersOverlimitNotificationIfNedeed(){
        let rulesNumberString = String.simpleThousandsFormatting(NSNumber(integerLiteral: 1)) // dnsFiltersService.enabledRulesCount
        let title = String.localizedString("dns_filters_notification_title")
        let body = String(format: String.localizedString("dns_filters_overlimit_title"), rulesNumberString)
        let userInfo: [String : Int] = [PushNotificationCommands.command : PushNotificationCommands.openDnsFiltersController.rawValue]
        userNotificationService.postNotification(title: title, body: body, userInfo: userInfo)
    }

    private func addPurchaseStatusObserver() {
         if purchaseObservation == nil {
             purchaseObservation = NotificationCenter.default.observe(name: Notification.Name(PurchaseAssistant.kPurchaseServiceNotification), object: nil, queue: nil) { (notification) in
                 guard let type =  notification.userInfo?[PurchaseAssistant.kPSNotificationTypeKey] as? String else { return }

                 DDLogInfo("(AppDelegate) - Received notification type = \(type)")

                 if type == PurchaseAssistant.kPSNotificationPremiumExpired {
                     self.userNotificationService.postNotification(title: String.localizedString("premium_expired_title"), body: String.localizedString("premium_expired_message"), userInfo: nil)
                 }
             }
         }

         if proStatusObservation == nil {
             proStatusObservation = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
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
        subscribeToUserNotificationServiceNotifications()

        resources.sharedDefaults().addObserver(self, forKeyPath: TunnelErrorCode, options: .new, context: nil)

        subscribeToThemeChangeNotification()

        setappObservation = NotificationCenter.default.observe(name: .setappDeviceLimitReched, object: nil, queue: OperationQueue.main) { _ in
            if let vc = Self.topViewController() {
                    ACSSystemUtils.showSimpleAlert(for: vc, withTitle: String.localizedString("common_error_title"), message: String.localizedString("setapp_device_limit_reached"))

            }
        }
    }

    // MARK: - Init logger

    private static func initLogger(resources: AESharedResourcesProtocol) {
        let isDebugLogs = resources.sharedDefaults().bool(forKey: AEDefaultsDebugLogs)
        dynamicLogLevel = isDebugLogs ? .debug : .info
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel

        DDLogInfo("(AppDelegate) - Init app, log level debug=\(isDebugLogs)")

        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif

        AGLogger.setLevel(isDebugLogs ? .AGLL_DEBUG : .AGLL_INFO)
        AGLogger.setCallback { level, msg, length in
            guard let msg = msg else { return }
            let data = Data(bytes: msg, count: Int(length))
            if let str = String(data: data, encoding: .utf8) {
                switch (level) {
                case AGLogLevel.AGLL_INFO:
                    Logger.logInfo("(DnsLibs) - \(str)")
                case AGLogLevel.AGLL_ERR, AGLogLevel.AGLL_WARN:
                    Logger.logError("(DnsLibs) - \(str)")
                default:
                    Logger.logDebug("(DnsLibs) - \(str)")
                }
            }
        }

        Logger.logDebug = { msg in
            DDLogDebug(msg)
        }

        Logger.logInfo = { msg in
            DDLogInfo(msg)
        }

        Logger.logError = { msg in
            DDLogError(msg)
        }
    }

    private func setupOnFirstAppRun() {
        guard firstRun else { return }
        firstRun = false

        do {
            try safariProtection.enablePredefinedGroupsAndFilters()
            DDLogInfo("(AppDelegate) - setupOnFirstAppRun; Successfully setup predefined groups and filters")
        } catch {
            DDLogError("(AppDelegate) - setupOnFirstAppRun; Error occurred while setup predefined groups and filters")
        }

        updateSafariProtectionMeta()
    }

    private func updateSafariProtectionMeta() {
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .success(_):
                DDLogInfo("(AppDelegate) - updateSafariProtectionMeta; Safari protection meta successfully updated")

            case .error(let error):
                DDLogError("(AppDelegate) - updateSafariProtectionMeta; On update safari protection meta error occurred: \(error)")
            }

        } onCbReloaded: { error in
            if let error = error {
                DDLogError("(AppDelegate) - updateSafariProtectionMeta; On reload CB error occurred: \(error)")
                return
            }

            DDLogInfo("(AppDelegate) - updateSafariProtectionMeta; Successfully reload CB")
        }
    }

    private func checkRemoteMigration() {
        // No needs to perform extra check if 'remote migration' status has been checked via background fetch
        guard !Bundle.main.isAslApp,
              !resources.backgroundFetchRemoteMigrationRequestResult else {
            DDLogInfo("(AppDelegate) Remote migration check result has been received in background fetch earlier")
            return
        }

        DDLogInfo("(AppDelegate) - Start checking if remote migration is needed")
        remoteMigrationService.checkRemoteMigration { result in
            DDLogInfo("(AppDelegate) - Remote migration check result = \(result)")
        }
    }

    private func checkRemoteMigrationInBackgroundFetch() {
        guard !Bundle.main.isAslApp else {
            DDLogWarn("(AppDelegate) No need to check remote migration state. It is not old app")
            return
        }

        remoteMigrationService.checkRemoteMigration { isNeedMigration in
            self.resources.backgroundFetchRemoteMigrationRequestResult = isNeedMigration
            guard isNeedMigration else {
                DDLogDebug("(AppDelegate) - Do not post remote migration local push notification, no needs for remote migration")
                return
            }

            DDLogDebug("(AppDelegate) - Start posting remote migration local push notification")
            let title = String.localizedString("remote_migration_notification_title")
            let body = String.localizedString("remote_migration_notification_body")
            self.userNotificationService.postNotification(title: title, body: body, userInfo: nil)
        }
    }
}
