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
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
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
    private var setappObservation: NotificationToken?
    
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
    private var antibanner: AESAntibannerProtocol
    private var dnsFiltersService: DnsFiltersServiceProtocol
    private var networking: ACNNetworking
    private var configuration: ConfigurationService
    private var productInfo: ADProductInfoProtocol
    private var migrationService: MigrationServiceProtocol
    private var vpnManager: VpnManagerProtocol
    private var setappService: SetappServiceProtocol
    private var activityStatisticsService: ActivityStatisticsServiceProtocol
    private var dnsStatisticsService: DnsStatisticsServiceProtocol
    private var dnsLogRecordsService: DnsLogRecordsServiceProtocol
    private var complexProtection: ComplexProtectionServiceProtocol
    private var filtersService: FiltersServiceProtocol
    
    //MARK: - Application init
    override init() {
        StartupService.start()
        self.resources = ServiceLocator.shared.getService()!
        self.antibanner = ServiceLocator.shared.getService()!
        self.dnsFiltersService = ServiceLocator.shared.getService()!
        self.networking = ServiceLocator.shared.getService()!
        self.configuration = ServiceLocator.shared.getService()!
        self.productInfo = ServiceLocator.shared.getService()!
        self.migrationService = ServiceLocator.shared.getService()!
        self.vpnManager = ServiceLocator.shared.getService()!
        self.setappService = ServiceLocator.shared.getService()!
        self.activityStatisticsService = ServiceLocator.shared.getService()!
        self.dnsStatisticsService = ServiceLocator.shared.getService()!
        self.dnsLogRecordsService = ServiceLocator.shared.getService()!
        self.complexProtection = ServiceLocator.shared.getService()!
        self.filtersService = ServiceLocator.shared.getService()!
        
        self.statusBarWindow = StatusBarWindow(configuration: configuration)
        super.init()
        
        self.fetchPerformer = BackgroundFetchPerformer(resources: resources,
                                                   configuration: configuration,
                                                   vpnManager: vpnManager,
                                                   antibanner: antibanner,
                                                   complexProtection: complexProtection,
                                                   dnsFiltersService: dnsFiltersService,
                                                   networking: networking)
        
        self.fetchNotificationHandler = BackgroundFetchNotificationHandler(fetchPerformer: fetchPerformer!,
                                                                           antibanner: antibanner,
                                                                           resources: resources)
    }
    
    deinit {
        resources.sharedDefaults().removeObserver(self, forKeyPath: TunnelErrorCode)
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //------------- Preparing for start application. Stage 1. -----------------
        
//        startAntibannerController()
        
        fetchPerformer?.setBackgroundStatusToDefault()
        activateWithOpenUrl = false
        
//        initLogger()
        DDLogInfo("(AppDelegate) Preparing for start application. Stage 1.")
        
        //------------ Interface Tuning -----------------------------------
        self.window?.backgroundColor = UIColor.clear
        return true
    }
    static func GetUserID(){
        let url = URL(string: DOMAIN_TO_GET_USER_ID)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse{
                        if httpResponse.statusCode == 200{
                            StoreData.saveMyPlist(key: "userid", value: json["deviceId"] as! String)
                        }
                    }
                }
            }catch _{
                
            }
        }
        task.resume()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        prepareControllers()
        if StoreData.getMyPlist(key: "userid") == nil{
            AppDelegate.GetUserID()
        }
        //------------- Preparing for start application. Stage 2. -----------------
        DDLogInfo("(AppDelegate) Preparing for start application. Stage 2.")
        
        AppDelegate.setPeriodForCheckingFilters()
//        subscribeToNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, err) in
                print("granted: \(granted)")
            }
        UNUserNotificationCenter.current().delegate = self
        
        //register firebase
        FirebaseApp.configure() // gọi hàm để cấu hình 1 app Firebase mặc định
        Messaging.messaging().delegate = self //Nhận các message từ FirebaseMessaging
        configApplePush(application) // đăng ký nhận push.
        return true
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if StoreData.getMyPlist(key: "userid") == nil{
            AppDelegate.GetUserID()
        }
        if StoreData.getMyPlist(key: "userid") != nil
        {
            if StoreData.getMyPlist(key: "status_code_vip") == nil
            {
                self.postRequestSendToken(deviceId: StoreData.getMyPlist(key: "userid") as! String, token: fcmToken!)
            }
            else{
                if StoreData.getMyPlist(key: "status_code_vip") as! Int != 1
                {
                    self.postRequestSendToken(deviceId: (StoreData.getMyPlist(key: "userid") as! String).lowercased(), token: fcmToken!)
                }
            }
        }
    }
    func postRequestSendToken(deviceId:String, token:String){
        StoreData.saveMyPlist(key: "status_code_token", value: 2)
        struct RequestData: Codable {
            var deviceId:String
            var token:String
        }
        let url = URL(string: DOMAIN_SEND_TOKEN)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let request_json = RequestData(
            deviceId: deviceId, token:token )
        print("tokenfire")
        print((request_json))
        let jsonData = try? JSONEncoder().encode(request_json)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                print(json)
                DispatchQueue.main.async {
                    if json["msg"] as! String == ""
                    {
                        print("SEND_TOKEN_TRUE")
                        StoreData.saveMyPlist(key: "status_code_token", value: 1)
                    }
                    else
                    {
                        print("SEND_TOKEN_FALSE")
                        StoreData.saveMyPlist(key: "status_code_token",value: 0)
                    }
                }
            }catch let jsonErr{
                print(jsonErr)
           }
        }
        task.resume()
    }
    func configApplePush(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if let token = Messaging.messaging().fcmToken {
            print("FCM token: \(token)")
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
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
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationDidBecomeActive.")
        initStatusBarNotifications(application)
        
        // If theme mode is System Default gets current style
        setAppInterfaceStyle()
//        updateAntibannerContoller()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        DDLogInfo("(AppDelegate) applicationWillTerminate.")
        resources.synchronizeSharedDefaults()
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        addPurchaseStatusObserver()
        fetchPerformer?.performFetch(with: completionHandler)
    }
    
    //MARK: - Public methods
    
    func resetAllSettings() {
        let resetProcessor = SettingsResetor(appDelegate: self,
                                             dnsFiltersService: dnsFiltersService,
                                             filtersService: filtersService,
                                             vpnManager: vpnManager,
                                             resources: resources,
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
        setappService.start()}
    
    private func postDnsFiltersOverlimitNotificationIfNedeed(){
    }
}
extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
