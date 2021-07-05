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
import NotificationCenter
import NetworkExtension
import AdGuardSDK

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var safariSwitchOutlet: UISwitch!
    @IBOutlet weak var systemSwitchOutlet: UISwitch!
    
    @IBOutlet weak var safariImageView: UIImageView!
    @IBOutlet weak var systemImageView: UIImageView!
    
    @IBOutlet weak var safariTitleLabel: UILabel!
    
    @IBOutlet weak var safariTextLabel: UILabel!
    
    @IBOutlet weak var systemTitleLabel: UILabel!
    
    @IBOutlet weak var systemTextLabel: UILabel!
    
    @IBOutlet weak var allTimeStaisticsLabel: UILabel!
    
    @IBOutlet weak var requestsLabel: UILabel!
    
    @IBOutlet weak var encryptedLabel: UILabel!
    
    @IBOutlet weak var elapsedLabel: UILabel!
    
    @IBOutlet var labels: [UILabel]!

    @IBOutlet weak var expandedStackView: UIStackView!
    @IBOutlet weak var compactView: UIView!
    
    @IBOutlet weak var complexSwitchOutlet: UISwitch!
    @IBOutlet weak var complexProtectionTitle: UILabel!
    @IBOutlet weak var complexStatusLabel: UILabel!
    @IBOutlet weak var complexStatisticsLabel: UILabel!
    
    
    private let resources: AESharedResources = AESharedResources()
    private var safariProtection: SafariProtectionProtocol
    private var complexProtection: ComplexProtectionServiceProtocol
    private let networkService = ACNNetworking()
    private var purchaseService: PurchaseServiceProtocol
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    private let dnsProvidersService: DnsProvidersServiceProtocol
    private let productInfo: ADProductInfoProtocol
    
    private var requestNumber = 0
    private var encryptedNumber = 0
    
    private var counters: DnsCounters?
    
    // MARK: View Controller lifecycle
    
    required init?(coder: NSCoder) {
        
        // Init Logger
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        
        let isDebugLogs = resources.isDebugLogs
        DDLogInfo("Start today extension with log level: \(isDebugLogs ? "DEBUG" : "Normal")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
        
        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif
        
        DDLogInfo("(TodayViewController) - init start")
        ACLLogger.singleton()?.flush()
        
        // todo:
        let configuration = Configuration(currentLanguage: "", proStatus: true, safariProtectionEnabled: true, blocklistIsEnabled: true, allowlistIsEnbaled: true, allowlistIsInverted: true, updateOverWifiOnly: true, appBundleId: "", appProductVersion: "", appId: "", cid: "")
        safariProtection = try! SafariProtection(configuration: configuration, defaultConfiguration: configuration, filterFilesDirectoryUrl: URL(string: "")!, dbContainerUrl: URL(string: "")!, jsonStorageUrl: URL(string: "")!, userDefaults: UserDefaults(suiteName: "")!)
        
        productInfo = ADProductInfo()
        purchaseService = PurchaseService(network: networkService, resources: resources, productInfo: productInfo)
        let oldConfiguration = ConfigurationService(purchaseService: purchaseService, resources: resources, safariProtection: safariProtection)
        dnsProvidersService = DnsProvidersService(resources: resources)
        dnsStatisticsService = DnsStatisticsService(resources: resources)
        let vpnManager = VpnManager(resources: resources, configuration: oldConfiguration, networkSettings: NetworkSettingsService(resources: resources), dnsProviders: dnsProvidersService as! DnsProvidersService)
        
        let networkSettings = NetworkSettingsService(resources: resources)
        let nativeProviders = NativeProvidersService(dnsProvidersService: dnsProvidersService, networkSettingsService: networkSettings, resources: resources, configuration: oldConfiguration)
        complexProtection = ComplexProtectionService(resources: resources, configuration: oldConfiguration, vpnManager: vpnManager, productInfo: productInfo, nativeProvidersService: nativeProviders, safariProtection: safariProtection)
        
        super.init(coder: coder)
        
        DDLogInfo("(TodayViewController) - init end")
        ACLLogger.singleton()?.flush()
        ACLLogger.singleton()?.flush()
    }
    
    override func viewDidLoad() {
        DDLogInfo("(TodayViewController) - viewDidLoad")
        ACLLogger.singleton()?.flush()
        super.viewDidLoad()
        
        height.constant = extensionContext?.widgetMaximumSize(for: .compact).height ?? 110.0
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        counters = dnsStatisticsService.getAllCounters()
        changeTextForButton(counters: counters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DDLogInfo("(TodayViewController) - viewWillAppear")
        super.viewWillAppear(animated)
        addStatisticsObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeStatisticsObservers()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        DDLogInfo("(TodayViewController) - observeValue")
        
        if keyPath == LastStatisticsSaveTime {
            counters = dnsStatisticsService.getAllCounters()
        }
        
        changeTextForButton(counters: counters)
    }
        
    // MARK: - NCWidgetProviding methods
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        setColorsToLabels()
        updateWidgetSafari()
        updateWidgetSystem()
        updateWidgetComplex()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        updateWidgetComplex()
        updateWidgetSystem()
        updateWidgetSafari()
        
        if (activeDisplayMode == .compact) {
            showForCompactMode()
            preferredContentSize = maxSize
        }
        else {
            showForExpandedMode()
            
            let height:CGFloat = 225.0
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        }
    }
    
    // MARK: - Actions

    @IBAction func safariSwitch(_ sender: UISwitch) {
        let enabled = sender.isOn
        complexProtection.switchSafariProtection(state: enabled, for: self) { (error) in
            if error != nil {
                DDLogError("Error invalidating json from Today Extension")
            } else {
                DDLogInfo("Successfull invalidating of json from Today Extension")
            }
        }
        
        updateWidgetSafari()
    }
    
    @IBAction func systemSwitch(_ sender: UISwitch) {
        let enabled = sender.isOn
        
        let alpha: CGFloat = enabled ? 1.0 : 0.5
        systemImageView.alpha = alpha
        systemTextLabel.alpha = alpha
        systemTitleLabel.alpha = alpha
        systemSwitchOutlet.isOn = enabled
        
        turnProtection(.system, to: enabled)
    }
    
    @IBAction func complexSwitch(_ sender: UISwitch) {
        let enabled = sender.isOn
        
        let systemEnabledOldValue = complexProtection.systemProtectionEnabled
        complexProtection.switchComplexProtection(state: enabled, for: nil) { (_, _) in }
        
        if systemEnabledOldValue != complexProtection.systemProtectionEnabled {
            turnProtection(.complex, to: complexProtection.systemProtectionEnabled)
        }
        updateWidgetComplex()
    }
    
    // MARK: Private methods
    
    enum Protection {
        case complex, system
    }
    
    func turnProtection(_ protection: Protection, to state: Bool) {
        var openSystemProtectionUrl = AE_URLSCHEME + (protection == .system ? "://systemProtection/" : "://complexProtection/")
        openSystemProtectionUrl += state ? "on" : "off"

        if let url = URL(string: openSystemProtectionUrl){
            extensionContext?.open(url, completionHandler: { (success) in
                if !success {
                    DDLogError("Error redirecting to app from Today Extension")
                }
            })
        } else {
            DDLogError("Error redirecting to app from Today Extension")
        }
    }
    
    /**
     Updates safari protection view
     */
    private func updateWidgetSafari(){
        let safariEnabled = complexProtection.safariProtectionEnabled
        
        let alpha: CGFloat = safariEnabled ? 1.0 : 0.5
        safariImageView.alpha = alpha
        safariTextLabel.alpha = alpha
        safariTitleLabel.alpha = alpha
        safariSwitchOutlet.isOn = safariEnabled
        
        if let lastUpdateDate = resources.sharedDefaults().object(forKey: AEDefaultsCheckFiltersLastDate) as? Date {
    
            let dateString = lastUpdateDate.formatedString() ?? ""
            safariTextLabel.text = String(format: String.localizedString("filter_date_format"), dateString)
        }
    }
    
    /**
     Updates DNS protection view
     */
    private func updateWidgetSystem(){
            
        let vpnEnabled = complexProtection.systemProtectionEnabled
        
        let alpha: CGFloat = vpnEnabled ? 1.0 : 0.5
        self.systemSwitchOutlet.isOn = vpnEnabled
        self.systemImageView.alpha = alpha
        self.systemTitleLabel.alpha = alpha
        self.systemTextLabel.alpha = alpha
        
        self.systemTextLabel.text = self.getServerName()
    }
    
    /**
     Updates complex protection view
     */
    private func updateWidgetComplex() {
        let safariEnabled = complexProtection.safariProtectionEnabled
        let systemEnabled = complexProtection.systemProtectionEnabled
        let complexEnabled = complexProtection.complexProtectionEnabled
                
        let enabledText = complexEnabled ? String.localizedString("protection_enabled") : String.localizedString("protection_disabled")
        
        self.complexSwitchOutlet.isOn = complexEnabled
        self.complexProtectionTitle.text = enabledText
        
        var complexText = ""
        
        if safariEnabled && systemEnabled {
            complexText = String.localizedString("complex_enabled")
        } else if !complexEnabled{
            complexText = String.localizedString("complex_disabled")
        } else if safariEnabled {
            complexText = String.localizedString("safari_enabled")
        } else if systemEnabled {
            complexText = String.localizedString("system_enabled")
        }
        self.complexStatusLabel.text = complexText
        
        self.complexStatisticsLabel.text = String(format: String.localizedString("widget_statistics"), self.requestNumber, self.encryptedNumber)
    }
    
    /**
     Set text colors and switches backgrounds
     Must be called from NCWidgetProviding method in ios 13
     */
    private func setColorsToLabels(){
        safariTitleLabel.textColor = .widgetTitleColor
        safariTextLabel.textColor = .widgetTextColor
        
        systemTitleLabel.textColor = .widgetTitleColor
        systemTextLabel.textColor = .widgetTextColor
        
        complexProtectionTitle.textColor = .widgetTitleColor
        complexStatusLabel.textColor = .widgetTextColor
        complexStatisticsLabel.textColor = .widgetTextColor
        
        allTimeStaisticsLabel.textColor = .widgetTitleColor
        requestsLabel.textColor = .widgetTitleColor
        encryptedLabel.textColor = .widgetTitleColor
        elapsedLabel.textColor = .widgetTitleColor
        
        labels.forEach({ $0.textColor = .widgetTextColor })
        
        safariSwitchOutlet.layer.cornerRadius = safariSwitchOutlet.frame.height / 2
        systemSwitchOutlet.layer.cornerRadius = systemSwitchOutlet.frame.height / 2
        complexSwitchOutlet.layer.cornerRadius = complexSwitchOutlet.frame.height / 2
    }
    
    /**
     Animates an appearing of compact mode
     */
    private func showForCompactMode(){
        compactView.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let self = self else { return }
            self.expandedStackView.alpha = 0.0
            self.compactView.alpha = 1.0
        }) {[weak self] (success) in
            guard let self = self else { return }
            if success {
                self.expandedStackView.isHidden = true
            }
        }
    }
    
    /**
     Animates an appearing of expanded mode
     */
    private func showForExpandedMode(){
        expandedStackView.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let self = self else { return }
            self.expandedStackView.alpha = 1.0
            self.compactView.alpha = 0.0
        }) {[weak self] (success) in
            guard let self = self else { return }
            if success {
                self.compactView.isHidden = true
            }
        }
    }

    /**
     Gets current server name from vpnManager
     */
    private func getServerName() -> String {
        
        if resources.dnsImplementation == .native {
            return complexProtection.systemProtectionEnabled ? String.localizedString("native_dns_working") : String.localizedString("native_dns_not_working")
        }
        guard let server = dnsProvidersService.activeDnsServer else {
            return String.localizedString("system_dns_server")
        }
        
        let provider = dnsProvidersService.activeDnsProvider
        let protocolName = String.localizedString(DnsProtocol.stringIdByProtocol[server.dnsProtocol]!)
        
        return "\(provider?.name ?? server.name) (\(protocolName))"
    }
    
    /**
     Changes number of requests for specific button
     */
    private func changeTextForButton(counters: DnsCounters?){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            
            let requests = counters?.totalRequests ?? 0
            let encrypted = counters?.encrypted ?? 0
            let elapsedSumm = counters?.totalTime ?? 0
            
            let requestsNumber = self.resources.tempRequestsCount + requests
            self.requestsLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: requestsNumber))
            self.requestNumber = requestsNumber
            
            let encryptedNumber = self.resources.tempEncryptedRequestsCount + encrypted
            self.encryptedLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: encryptedNumber))
            self.encryptedNumber = encryptedNumber
            
            let averageElapsed = requests == 0 ? 0 : Double(elapsedSumm) / Double(requests)
            self.elapsedLabel.text = String.simpleSecondsFormatter(NSNumber(floatLiteral: averageElapsed))
        }
    }
    
    private func addStatisticsObservers() {
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsRequests, options: .new, context: nil)
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsEncryptedRequests, options: .new, context: nil)
        resources.sharedDefaults().addObserver(self, forKeyPath: LastStatisticsSaveTime, options: .new, context: nil)
    }
    
    private func removeStatisticsObservers() {
        resources.sharedDefaults().removeObserver(self, forKeyPath: AEDefaultsRequests, context: nil)
        resources.sharedDefaults().removeObserver(self, forKeyPath: AEDefaultsEncryptedRequests, context: nil)
    }
}

/**
 Themable colors for today extension
 */
extension UIColor {
    @objc class var widgetTextColor: UIColor {
        return UIColor(named: "widgetTextColor")!
    }
    
    @objc class var widgetTitleColor: UIColor {
        return UIColor(named: "widgetTitleColor")!
    }
}
