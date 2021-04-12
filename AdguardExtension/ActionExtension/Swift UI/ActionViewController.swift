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

import UIKit
import CoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    
    private var url: URL? = nil
    private var iconUrl: URL? = nil
    private var host: String? = nil
    private var injectScriptSupported = false
    private var enabled = false
    private var dbObserver: Any?
    private var configuration: SimpleConfigurationSwift
    
    var systemStyleIsDark: Bool {
        if #available(iOSApplicationExtension 13.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .light:
                return false
            case .dark:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }
    
    // MARK: - Constants
    
    private let AEActionErrorDomain = "AEActionErrorDomain"
    private let aeProductionDb = "adguard.db"
    private let AEActionErrorNoDefaults = 100
    private let AEActionErrorNoDb = 200
    private let userFriendlyDelay = 0.5
    private let segueId = "loader"
    
    // MARK: - Services
    
    private let sharedResources: AESharedResourcesProtocol = AESharedResources()
    private let safariService: SafariService
    private let contentBlockerService: ContentBlockerService
    private let networking = ACNNetworking()
    private let antibannerController: AntibannerControllerProtocol
    private let webReporter: ActionWebReporterProtocol
    private var theme: ThemeServiceProtocol?
    private let asDataBase = ASDatabase()
    private let productInfo: ADProductInfoProtocol
    
    private var notificationToken1: NotificationToken?
    private var notificationToken2: NotificationToken?
    
    // MARK: - View Controller LifeCycle
    
    required init?(coder: NSCoder) {
        safariService = SafariService(resources: sharedResources)
        let antibanner = AESAntibanner(networking: networking, resources: sharedResources)
        configuration = SimpleConfigurationSwift(withResources: sharedResources, systemAppearenceIsDark: true)
        
        productInfo = ADProductInfo()
        
        self.antibannerController = AntibannerController(antibanner: antibanner, resources: sharedResources, productInfo: productInfo)
        
        let safariProtectoin = SafariProtectionService(resources: sharedResources)
        
        let dnsFiltersService = DnsFiltersService(resources: sharedResources, vpnManager: nil, configuration: configuration, complexProtection: nil)
        
        let safariProtection = SafariProtectionService(resources: sharedResources)
        
        let dnsProviders = DnsProvidersService(resources: sharedResources)
        
        let networkSettings = NetworkSettingsService(resources: sharedResources)

        let vpnManager = VpnManager(resources: sharedResources, configuration: configuration, networkSettings: networkSettings, dnsProviders: dnsProviders)
        
        let nativeProviders = NativeProvidersService(dnsProvidersService: dnsProviders, networkSettingsService: networkSettings, resources: sharedResources, configuration: configuration)
        
        let complexProtection = ComplexProtectionService(resources: sharedResources, safariService: safariService, configuration: configuration, vpnManager: vpnManager, safariProtection: safariProtectoin, productInfo: productInfo, nativeProvidersService: nativeProviders)
 
        contentBlockerService = ContentBlockerService(resources: sharedResources,
                                                      safariService: safariService,
                                                      antibanner: antibanner,
                                                      safariProtection: safariProtection)
        
        webReporter = ActionWebReporter(productInfo: productInfo,
                                    antibanner: antibanner,
                                    complexProtection: complexProtection,
                                    dnsProviders: dnsProviders,
                                    configuration: configuration,
                                    dnsFilters: dnsFiltersService)
        
        super.init(coder: coder)
    }
    
    deinit {
        DDLogDebug("(ActionViewController) run deinit.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configuration.systemAppearenceIsDark = systemStyleIsDark
        self.theme = ThemeService(configuration)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        title = LocalizationNotNeeded(Constants.aeProductName())
        var errorMessage = ACLocalizedString("support_error_safari_extension", nil)
        guard let item: NSExtensionItem = self.extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider: NSItemProvider = item.attachments?.first else { return }
        
        if !itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
            DDLogError("(ActionViewController) Error  - itemProvider does not conform to type \(String(kUTTypePropertyList))")
            stopProcessing(with: errorMessage)
            return
        }
        
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil) {[weak self] (results, error) in
            
            var succeed = false
            
            defer {
                if !succeed {
                    self?.stopProcessing(with: errorMessage)
                }
            }
            
            guard let self = self else { return }
            
            guard let dictResult = results as? Dictionary<String, Any> else {
                DDLogError("(ActionViewController) Error - result dict incorrect. Results: \(results.debugDescription )")
                return
            }
            
            guard let theDict = dictResult[NSExtensionJavaScriptPreprocessingResultsKey] as? Dictionary<String, Any> else {
                DDLogError("(ActionViewController) Error - can not get NSExtensionJavaScriptPreprocessingResultsKey. Results: \(results.debugDescription )")
                return
            }
            
            if let urlString = theDict["urlString"] as? String {
                self.url = URL(string: urlString)
            }
            
            self.host = self.url?.hostWithPort()
            
            if let supported = theDict["injectScriptSupported"] as? Int {
                self.injectScriptSupported = supported == 0 ? false : true
            }
            
            if error != nil {
                DDLogError("(ActionViewController) Error of obtaining page url from Safari:\(error?.localizedDescription ?? "nil")" )
            } else if self.host?.isEmpty ?? true || self.host == nil {
                DDLogError("(ActionViewController) Error of obtaining page url from Safari: url is empty.")
                errorMessage = ACLocalizedString("hostname_obtaining_error", "(Action Extension - ActionViewController) Can't obtain hostname when starting.")
            } else {
                
                let error = self.prepareDataModel()
                
                if error != nil {
                    DDLogError("(ActionViewController) can not prepare data model. \(error!.localizedDescription)")
                    if error?.code == self.AEActionErrorNoDb {
                        errorMessage = error?.localizedDescription ?? ""
                    }
                } else {
                    succeed = true
                    
                    self.antibannerController.onReady { (antibanner) in
                        // Add observers for application notifications
                        self.addObservers()
                        
                        let formattedString = String(format: "%@://%@/favicon.ico", self.url?.scheme ?? "", self.url?.hostWithPort() ?? "")
                        self.iconUrl = URL(string: formattedString)
                        
                        self.startProcessing()
                    }
                }
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configuration.systemAppearenceIsDark = systemStyleIsDark
        updateTheme()
    }
    
    // MARK: - Prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            guard let mainVC = segue.destination as? ActionExtensionMainController else { return }
            mainVC.resources = sharedResources
            mainVC.safariService = safariService
            mainVC.contentBlockerService = contentBlockerService
            mainVC.webReporter = webReporter
            mainVC.domainName = host
            mainVC.iconUrl = iconUrl
            mainVC.domainEnabled = enabled
            mainVC.injectScriptSupported = injectScriptSupported
            mainVC.enableChangeDomainFilteringStatus = true
            mainVC.url = url
        }
    }
    
    
    // MARK: - Methods
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    
    // MARK: - Private methods
    
    private func startProcessing(){
        DispatchQueue.main.async {[weak self] in
            guard let sSelf = self else { return }
            sSelf.loadIndicator.startAnimating()
            sSelf.messageLabel.text = ""
            sSelf.messageLabel.isHidden = true
        }
        
        let inverted = sharedResources.sharedDefaults().bool(forKey: AEDefaultsInvertedWhitelist)
        
        if inverted {
            enabled = isHostInInvertedWhitelist(host: host ?? "")
        } else {
            enabled = domainObjectIfExistsFromContentBlockingWhitelistFor(host: host ?? "") == nil
        }
        
        DispatchQueue.main.async {[weak self] in
            guard let sSelf = self else { return }
            sSelf.performSegue(withIdentifier: sSelf.segueId, sender: sSelf)
        }
    }
    
    private func stopProcessing(with message: String){
        DispatchQueue.main.async {[weak self] in
            self?.loadIndicator.stopAnimating()
            if !message.isEmpty {
                self?.messageLabel.text = message
            }
            self?.messageLabel.isHidden = false
        }
    }
    
    private func addObservers() {
        notificationToken1 = NotificationCenter.default.observe(name: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.sharedResources.synchronizeSharedDefaults()
        }
        notificationToken2 = NotificationCenter.default.observe(name: UIApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.sharedResources.synchronizeSharedDefaults()
        }
    }
    
    private func isHostInInvertedWhitelist(host: String) -> Bool {
        let invertedDomainsObj = sharedResources.invertedWhitelistContentBlockingObject
        guard let rules = invertedDomainsObj?.rules else { return false }
        
        for rule in rules{
            if rule.ruleText.caseInsensitiveCompare(host) == ComparisonResult.orderedSame && rule.isEnabled.boolValue {
                return true
            }
        }
        
        return false
    }
    
    private func domainObjectIfExistsFromContentBlockingWhitelistFor(host: String) -> AEWhitelistDomainObject? {
        DDLogDebug("(ActionViewController) domainObjectIfExistsFromContentBlockingWhitelistFor:\(host)")
        guard let rules = sharedResources.whitelistContentBlockingRules else { return nil }
        return domainObjectIfExists(host: host, rules: rules)
    }
    
    private func domainObjectIfExists(host: String, rules: NSArray) -> AEWhitelistDomainObject? {
        let predicate = NSPredicate(format: "ruleText CONTAINS[cd] %@", host)
        let filteredRules = rules.filtered(using: predicate)
        
        if filteredRules.count > 0 {
            var obj: AEWhitelistDomainObject? = AEWhitelistDomainObject()
            for rule in filteredRules {
                guard let safeRule = rule as? ASDFilterRule else {
                    obj = nil
                    continue
                }
                obj = AEWhitelistDomainObject.init(rule: safeRule)
                if let _ = AEWhitelistDomainObject.init(rule: safeRule) {
                    break
                }
            }
            return obj
        }
        return nil
    }
    
    private func prepareDataModel() -> NSError? {
        // Init Logger
        ACLLogger.singleton()?.initLogger(sharedResources.sharedAppLogsURL())
        
        let isDebugLogs = sharedResources.isDebugLogs
        DDLogInfo("Start action extension with log level: \(isDebugLogs ? "DEBUG" : "Normal")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
        
        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif
        
        // Registering standart Defaults
        let appPath = Bundle.main.bundlePath as NSString
        let fullPath = appPath.appendingPathComponent("../../") as String
        guard let path = Bundle(path: fullPath)?.path(forResource: "defaults", ofType: "plist") else {
            DDLogInfo("(ActionViewController) wrong appPath");
            return nil
        }
        if let defs = NSDictionary(contentsOfFile: path) as? [String : Any] {
            DDLogInfo("(ActionViewController) default.plist loaded!")
            sharedResources.sharedDefaults().register(defaults: defs)
        } else {
            DDLogError("(ActionViewController) default.plist was not loaded.")
            return NSError(domain: AEActionErrorDomain, code: AEActionErrorNoDefaults, userInfo: nil)
        }
        //-------------------------------
        
        // Init database
        let dbUrl = sharedResources.sharedResuorcesURL().appendingPathComponent(aeProductionDb)
        asDataBase.initDb(with: dbUrl, upgradeDefaultDb: false, buildVersion: productInfo.buildVersion())
        
        if asDataBase.error != nil {
            DDLogError("(ActionViewController) production DB was not created before.")
            let messageFormat = ACLocalizedString("action_extension_no_configuration_message_format", nil)
            let formattedString = String(format: messageFormat, Constants.aeProductName(), Constants.aeProductName())
            let userInfo = [NSLocalizedDescriptionKey : formattedString]
            return NSError.init(domain: AEActionErrorDomain, code: AEActionErrorNoDb, userInfo: userInfo)
        }
        
        DispatchQueue.main.async {[weak self] in
            guard let sSelf = self else { return }
            //------------ Checking DB status -----------------------------
            if sSelf.asDataBase.error != nil {
                DDLogError("(ActionViewController) production DB was not created before.")
            } else if !sSelf.asDataBase.ready {
                sSelf.dbObserver = sSelf.asDataBase.observe(\.ready, options: .new, changeHandler: { (db, change) in
                    if sSelf.asDataBase.ready{
                        sSelf.antibannerController.start()
                    }
                })
            }
            //--------------------- Start Services ---------------------------
            else {
                sSelf.antibannerController.start()
            }
        }
        return nil
    }
    
    private func updateTheme() {
        view.backgroundColor = theme?.backgroundColor
        theme?.setupNavigationBar(navigationController?.navigationBar)
    }
}
