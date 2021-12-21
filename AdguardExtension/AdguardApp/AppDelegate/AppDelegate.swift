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

    // MARK: - Application init

    override init() {
        let resources = StartupService.initResources()

        AppDelegate.initLogger(resources: resources)
        StartupService.start()

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

        super.init()

        DDLogInfo("Application started. Version: \(productInfo.buildVersion() ?? "nil")")
    }

    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: TunnelErrorCode)
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        //------------- Preparing for start application. Stage 1. -----------------
        migrationService.migrateIfNeeded()
        purchaseService.checkLicenseStatus()

        activateWithOpenUrl = false

        DDLogInfo("(AppDelegate) Preparing for start application. Stage 1.")

        //------------ Interface Tuning -----------------------------------
        self.window?.backgroundColor = UIColor.clear

        if (application.applicationState != .background) {
            purchaseService.checkPremiumStatusChanged()
        }

        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        SentrySDK.start { options in
            options.dsn = Constants.Sentry.dsnUrl
            options.enableAutoSessionTracking = false
        }

        prepareControllers()

        //------------- Preparing for start application. Stage 2. -----------------
        DDLogInfo("(AppDelegate) Preparing for start application. Stage 2.")

        let interval = resources.backgroundFetchUpdatePeriod.interval
        AppDelegate.setBackgroundFetchInterval(interval)
        subscribeToNotifications()

        // Install default DNS filter if needed
        let defaultDnsFilterInstaller = DefaultDnsFilterInstaller(resources: resources, dnsProtection: dnsProtection)
        defaultDnsFilterInstaller.installDefaultDnsFilterIfNeeded()

        if firstRun {
            configuration.showStatusBar = false
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

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        addPurchaseStatusObserver()
        purchaseService.checkLicenseStatus()

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
            completionHandler(.noData)
            return
        }

        // Update filters in background
        safariProtection.updateSafariProtectionInBackground { [weak self] result in
            if let error = result.error {
                DDLogError("(AppDelegate) - backgroundFetch; Received error from SDK: \(error)")
                completionHandler(result.backgroundFetchResult)
                return
            }
            // If there was a phase with downloading filters, than we need to restart tunnel to apply newest ones
            if result.oldBackgroundFetchState == .updateFinished || result.oldBackgroundFetchState == .loadAndSaveFilters {
                self?.dnsConfigAssistant.applyDnsPreferences(for: .modifiedDnsFilters) { _ in
                    DDLogInfo("(AppDelegate) - backgroundFetch; Background fetch ended call performFetchWithCompletionHandler after updating dns preferences")
                    completionHandler(result.backgroundFetchResult)
                }
            } else {
                DDLogInfo("(AppDelegate) - backgroundFetch; Background fetch ended call performFetchWithCompletionHandler")
                completionHandler(result.backgroundFetchResult)
            }
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

    // TODO: - Change the way we show overlimit error for DNS filters and handle the error
    private func postDnsFiltersOverlimitNotificationIfNedeed(){
        let rulesNumberString = String.simpleThousandsFormatting(NSNumber(integerLiteral: 1)) // dnsFiltersService.enabledRulesCount
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
        DDLogInfo("(AppDelegate) Init app with loglevel %s", level: isDebugLogs ? .debug : .all)
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel

        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif

        dynamicLogLevel = DDLogLevel(rawValue: UInt(ddLogLevel)) ?? .info

        AGLogger.setLevel(isDebugLogs ? .AGLL_TRACE : .AGLL_INFO)
        AGLogger.setCallback { _, msg, length in
            guard let msg = msg else { return }
            let data = Data(bytes: msg, count: Int(length))
            if let str = String(data: data, encoding: .utf8) {
                DDLogInfo("(DnsLibs) \(str)")
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
}
