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

protocol IAppDelegateProcessor: AnyObject {
    var activateWithOpenUrl: Bool { get set }
    func willFinishLaunching(with options: [UIApplication.LaunchOptionsKey : Any]?, application: UIApplication) -> Bool
    func didFinishLaunching(with options: [UIApplication.LaunchOptionsKey : Any]?, application: UIApplication) -> Bool
    func applicationDidBecomeActive(_ application: UIApplication)
}

final class AppDelegateProcessor: IAppDelegateProcessor {
    
    //MARK:  - Properties
    private weak var appDelegate: AppDelegate?
    private let fetchProcessor: IAppDelegateFetchProcessor
    private let antibannerController: AntibannerControllerProtocol
    private let migrationService: MigrationServiceProtocol
    private let purchaseService: PurchaseServiceProtocol
    private let configuration: ConfigurationServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    private var showStatusBarNotification: NotificationToken?
    private var hideStatusBarNotification: NotificationToken?
    private var orientationChangeNotification: NotificationToken?
    
    private let statusBarWindow: IStatusBarWindow
    
    private var firstRun: Bool {
        get {
            resources.firstRun
        }
        set {
            resources.firstRun = newValue
        }
    }
    
    var activateWithOpenUrl: Bool = false
    
    //MARK: - Init
    
    init(appDelegate: AppDelegate,
         fetchProcessor: IAppDelegateFetchProcessor,
         statusBarWindow: IStatusBarWindow,
         antibannerController: AntibannerControllerProtocol,
         migrationService: MigrationServiceProtocol,
         purchaseService: PurchaseServiceProtocol,
         configuration: ConfigurationServiceProtocol,
         resources: AESharedResourcesProtocol) {
        
        self.appDelegate = appDelegate
        self.statusBarWindow = statusBarWindow
        self.fetchProcessor = fetchProcessor
        self.antibannerController = antibannerController
        self.migrationService = migrationService
        self.purchaseService = purchaseService
        self.configuration = configuration
        self.resources = resources
    }
    
    //MARK: - IAppDelegateProcessor methods
    
    
    
    func willFinishLaunching(with options: [UIApplication.LaunchOptionsKey : Any]?, application: UIApplication) -> Bool {
        antibannerController.start()
        
        fetchProcessor.addPurchaseStatusObserver()
        
        antibannerController.onReady { [weak self] (_) in
            guard let self = self else { return }
            if (self.firstRun) {
                self.migrationService.install()
                self.purchaseService.checkLicenseStatus()
                self.firstRun = false
            }
            
            
            self.migrationService.migrateIfNeeded(inBackground: self.fetchProcessor.isBackground)
        }
        
        fetchProcessor.setBackgroundStatusDefault()
        activateWithOpenUrl = false
        return true
    }
    
    func didFinishLaunching(with options: [UIApplication.LaunchOptionsKey : Any]?, application: UIApplication) -> Bool {
        //------------ Subscribe other notifications -----------------------------
        subscribeToOtherNotifications()
        
        //---------------------- Set period for checking filters ---------------------
        setPeriodForCheckingFilters()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        DDLogInfo("(AppDelegateProcessor) applicationDidBecomeActive.")
        initStatusBarNotifications(application)
        
        // If theme mode is System Default gets current style
        appDelegate?.setAppInterfaceStyle()
        
        antibannerController.onReady { antibanner in
            antibanner.repairUpdateState { [weak self] in
                guard let self = self else { return }
                if self.activateWithOpenUrl {
                    self.activateWithOpenUrl = false
                    DDLogInfo("(AppDelegateProcessor - applicationDidBecomeActive) Update process did not start because app activated with open URL.")
                    return
                }
                
                if antibanner.updatesRightNow {
                    DDLogInfo("(AppDelegateProcessor - applicationDidBecomeActive) Update process did not start because it is performed right now.")
                    return
                }
                
                self.fetchProcessor.invalidateAntibannerIfNeeded()
            }
        }
    }
    
    //MARK: - Private methods
    private func initStatusBarNotifications(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        statusBarWindow.createStatusBarWindow()
        statusBarWindow.statusBarWindowIsHidden = true
        
        showStatusBarNotification = NotificationCenter.default.observe(name: .ShowStatusView, object: nil, queue: nil, using: { [weak self] (notification) in
            guard let self = self else { return }
            self.statusBarWindow.showStatusViewIfNeeded(configuration: self.configuration, notification: notification)
        })
        
        hideStatusBarNotification = NotificationCenter.default.observe(name: .HideStatusView, object: nil, queue: nil, using: { [weak self] (notification) in
            guard let self = self else { return }
            self.statusBarWindow.hideStatusViewIfNeeded()
        })
        
        orientationChangeNotification = NotificationCenter.default.observe(name: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.statusBarWindow.changeOrientation()
        })
    }
    
    private func setPeriodForCheckingFilters() {
        
        var interval: TimeInterval = TimeInterval(FiltersUpdatesConstants.fetchUpdateStatusPeriod)
        if (interval < UIApplication.backgroundFetchIntervalMinimum) {
            interval = UIApplication.backgroundFetchIntervalMinimum
        }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(interval)
        DDLogInfo("(AppDelegateProcessor) Set background fetch interval: \(interval)")
        
    }
    
    private func subscribeToOtherNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAlertNotification(notification:)), name: .showCommonAlert, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openDnsFiltersController(notification:)), name: .showDnsFiltersController, object: nil)
    }
    
    @objc private func showAlertNotification(notification: Notification) {
        let body = notification.userInfo?[UserNotificationService.notificationBody] as? String
        let title = notification.userInfo?[UserNotificationService.notificationTitle] as? String
        showCommonAlertForTopVc(body, title)
    }
    
    @objc private func openDnsFiltersController(notification: Notification) {
        guard let appDelegate = appDelegate else { return }
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
}
