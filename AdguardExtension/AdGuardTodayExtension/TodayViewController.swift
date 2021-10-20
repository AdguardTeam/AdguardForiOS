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
import SafariAdGuardSDK

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

    private let resources: AESharedResourcesProtocol = AESharedResources()
    private let serviceInitializer: ServiceInitializerProtocol

    private var prevRequestNumber = 0
    private var requestNumber = 0
    private var encryptedNumber = 0

    private var timer: Timer?

    // MARK: View Controller lifecycle

    required init?(coder: NSCoder) {
        Self.initLogger(with: resources)

        // Services initialising
        do {
            self.serviceInitializer = try ServiceInitializer(resources: resources)
        } catch {
            DDLogError("(TodayViewController) - init; error - \(error)")
            return nil
        }

        super.init(coder: coder)

        DDLogInfo("(TodayViewController) - init end")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DDLogInfo("(TodayViewController) - viewDidLoad")

        height.constant = extensionContext?.widgetMaximumSize(for: .compact).height ?? 110.0

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded

        initTimer(timeInterval: 1.0)
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

        if activeDisplayMode == .compact {
            showForCompactMode()
            preferredContentSize = maxSize
        } else {
            showForExpandedMode()
            let height:CGFloat = 225.0
            preferredContentSize = CGSize(width: maxSize.width, height: height)
        }
    }

    // MARK: - Actions

    @IBAction func safariSwitch(_ sender: UISwitch) {
        let enabled = sender.isOn
        serviceInitializer.complexProtection.switchSafariProtection(state: enabled, for: self) { (error) in
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
        let complexProtection = serviceInitializer.complexProtection
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

    private func initTimer(timeInterval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            guard let self = self else {
                self?.timer?.invalidate()
                self?.timer = nil
                return
            }

            self.changeTextForButton()

            guard self.prevRequestNumber < self.requestNumber else { return }
            var timeInterval: TimeInterval = 0.0

            if self.requestNumber >= 10000 {
                timeInterval = 60.0
            } else if self.requestNumber >= 100 {
                timeInterval = 2.0
            } else {
                timeInterval = 1.0
            }

            self.timer?.invalidate()
            self.timer = nil
            self.initTimer(timeInterval: timeInterval)
        }
    }

    /// Updates safari protection view
    private func updateWidgetSafari(){
        let safariEnabled = serviceInitializer.complexProtection.safariProtectionEnabled

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

    /// Updates DNS protection view
    private func updateWidgetSystem(){
        let vpnEnabled = serviceInitializer.complexProtection.systemProtectionEnabled

        let alpha: CGFloat = vpnEnabled ? 1.0 : 0.5
        self.systemSwitchOutlet.isOn = vpnEnabled
        self.systemImageView.alpha = alpha
        self.systemTitleLabel.alpha = alpha
        self.systemTextLabel.alpha = alpha

        self.systemTextLabel.text = self.getServerName()
    }

    /// Updates complex protection view
    private func updateWidgetComplex() {
        let complexProtection = serviceInitializer.complexProtection
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
        safariTitleLabel.textColor = widgetTitleColor
        safariTextLabel.textColor = widgetTextColor

        systemTitleLabel.textColor = widgetTitleColor
        systemTextLabel.textColor = widgetTextColor

        complexProtectionTitle.textColor = widgetTitleColor
        complexStatusLabel.textColor = widgetTextColor
        complexStatisticsLabel.textColor = widgetTextColor

        allTimeStaisticsLabel.textColor = widgetTitleColor
        requestsLabel.textColor = widgetTitleColor
        encryptedLabel.textColor = widgetTitleColor
        elapsedLabel.textColor = widgetTitleColor

        labels.forEach({ $0.textColor = widgetTextColor })

        safariSwitchOutlet.layer.cornerRadius = safariSwitchOutlet.frame.height / 2
        systemSwitchOutlet.layer.cornerRadius = systemSwitchOutlet.frame.height / 2
        complexSwitchOutlet.layer.cornerRadius = complexSwitchOutlet.frame.height / 2
    }

    /// Animates an appearing of compact mode
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

    /// Animates an appearing of expanded mode
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

    /// Gets current server name from vpnManager
    private func getServerName() -> String {

        if resources.dnsImplementation == .native {
            return serviceInitializer.complexProtection.systemProtectionEnabled ? String.localizedString("native_dns_working") : String.localizedString("native_dns_not_working")
        }

        let serverName = serviceInitializer.dnsProvidersManager.activeServerName
        return serverName
    }

    /// Changes number of requests for specific button
    private func changeTextForButton(){
        DispatchQueue.asyncSafeMain { [weak self] in
            guard let self = self else { return }
            let statisticRecord = try? self.serviceInitializer.activityStatistics.getCounters(for: .all)

            let requestsNumber = statisticRecord?.requests ?? 0
            let encryptedNumber = statisticRecord?.encrypted ?? 0
            let elapsedSumm = statisticRecord?.elapsedSumm ?? 0

            self.requestsLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: requestsNumber))
            self.prevRequestNumber = self.requestNumber
            self.requestNumber = requestsNumber

            self.encryptedLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: encryptedNumber))
            self.encryptedNumber = encryptedNumber

            let averageElapsed = requestsNumber == 0 ? 0 : Double(elapsedSumm) / Double(requestsNumber)
            self.elapsedLabel.text = String.simpleSecondsFormatter(NSNumber(floatLiteral: averageElapsed))
        }
    }

    /// Initializes logger
    private static func initLogger(with resources: AESharedResourcesProtocol) {
        // Init Logger
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())

        let isDebugLogs = resources.isDebugLogs
        DDLogInfo("Start today extension with log level: \(isDebugLogs ? "DEBUG" : "Normal")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
    }
}

/// Themable colors for today extension
fileprivate extension TodayViewController {
    var widgetTextColor: UIColor {
        return UIColor(named: "widgetTextColor")!
    }

    var widgetTitleColor: UIColor {
        return UIColor(named: "widgetTitleColor")!
    }
}
