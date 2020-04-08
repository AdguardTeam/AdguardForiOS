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
    private var safariService: SafariService
    private var complexProtection: ComplexProtectionServiceProtocol
    private let networkService = ACNNetworking()
    private var purchaseService: PurchaseServiceProtocol
    private var configuration: ConfigurationService
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    private let dnsProvidersService: DnsProvidersServiceProtocol
    
    private var requestNumber = 0
    private var encryptedNumber = 0
    
    // MARK: View Controller lifecycle
    
    required init?(coder: NSCoder) {
        
        // Init Logger
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        
        #if DEBUG
        ACLLogger.singleton()?.logLevel = ACLLDebugLevel
        #endif
        
        DDLogInfo("(TodayViewController) - init start")
        ACLLogger.singleton()?.flush()
        
        safariService = SafariService(resources: resources)
        purchaseService = PurchaseService(network: networkService, resources: resources)
        configuration = ConfigurationService(purchaseService: purchaseService, resources: resources, safariService: safariService)
        dnsProvidersService = DnsProvidersService(resources: resources)
        dnsStatisticsService = DnsStatisticsService(resources: resources)
        let vpnManager = VpnManager(resources: resources, configuration: configuration, networkSettings: NetworkSettingsService(resources: resources), dnsProviders: dnsProvidersService as! DnsProvidersService)
        
        let safariProtection = SafariProtectionService(resources: resources)
        complexProtection = ComplexProtectionService(resources: resources, safariService: safariService, configuration: configuration, vpnManager: vpnManager, safariProtection: safariProtection)
        
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
        
        let records = dnsStatisticsService.getAllRecords()
        changeTextForButton(records: records)
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
        let records = dnsStatisticsService.getAllRecords()
        changeTextForButton(records: records)
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
        
        complexProtection.switchSystemProtection(state: enabled, for: nil) { _ in }
        
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
            safariTextLabel.text = String(format: ACLocalizedString("filter_date_format", nil), dateString)
        }
    }
    
    /**
     Updates Tracking protection view
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
                
        let enabledText = complexEnabled ? ACLocalizedString("protection_enabled", nil) : ACLocalizedString("protection_disabled", nil)
        
        self.complexSwitchOutlet.isOn = complexEnabled
        self.complexProtectionTitle.text = enabledText
        
        var complexText = ""
        
        if safariEnabled && systemEnabled {
            complexText = ACLocalizedString("complex_enabled", nil)
        } else if !complexEnabled{
            complexText = ACLocalizedString("complex_disabled", nil)
        } else if safariEnabled {
            complexText = ACLocalizedString("safari_enabled", nil)
        } else if systemEnabled {
            complexText = ACLocalizedString("system_enabled", nil)
        }
        self.complexStatusLabel.text = complexText
        
        self.complexStatisticsLabel.text = String(format: ACLocalizedString("widget_statistics", nil), self.requestNumber, self.encryptedNumber)
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
    private func changeTextForButton(records: [DnsStatisticsRecord]){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            
            var requests = 0
            var encrypted = 0
            var elapsedSumm = 0
            
            for record in records {
                requests += record.requests
                encrypted += record.encrypted
                elapsedSumm += record.elapsedSumm
            }
            
            let requestsNumber = self.resources.tempRequestsCount
            self.requestsLabel.text = "\(requests + requestsNumber)"
            self.requestNumber = requests + requestsNumber
            
            let encryptedNumber = self.resources.tempEncryptedRequestsCount
            self.encryptedLabel.text = "\(encrypted + encryptedNumber)"
            self.encryptedNumber = encrypted + encryptedNumber
            
            let averageElapsed = requests == 0 ? 0 : Double(elapsedSumm) / Double(requests)
            self.elapsedLabel.text = String.simpleDecimalFormatter(NSNumber(floatLiteral: averageElapsed))
        }
    }
    
    private func addStatisticsObservers() {
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsRequests, options: .new, context: nil)
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsEncryptedRequests, options: .new, context: nil)
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
        if #available(iOS 11.0, *) {
            return UIColor(named: "widgetTextColor")!
        } else {
            return UIColor(hexString: "#515353")
        }
    }
    
    @objc class var widgetTitleColor: UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "widgetTitleColor")!
        } else {
            return UIColor(hexString: "#131313")
        }
    }
}
