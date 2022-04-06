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

import UIKit
import SharedAdGuardSDK
import SafariAdGuardSDK
import DnsAdGuardSDK

final class MainPageController: UIViewController, DateTypeChangedProtocol, ComplexSwitchDelegate, OnboardingControllerDelegate, LicensePageViewControllerDelegate, MainPageModelDelegate {

    // MARK: - Nav bar elements

    @IBOutlet weak var updateButton: UIBarButtonItem! {
        didSet{
            updateButton.accessibilityLabel = String.localizedString("update_filters_voiceover")
            let icon = UIImage(named: "refresh-icon")
            let iconSize = CGRect(origin: .zero, size: CGSize(width: 24.0, height: 24.0))
            let tintColor = UIColor.AdGuardColor.lightGreen1
            iconButton = UIButton(frame: iconSize)
            iconButton?.setBackgroundImage(icon, for: .normal)
            iconButton?.tintColor = tintColor
            iconButton?.contentVerticalAlignment = .fill
            iconButton?.contentHorizontalAlignment = .fill
            updateButton.customView = iconButton
            iconButton?.addTarget(self, action: #selector(updateFilters(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Protection status elements

    private lazy var safariProtectionButton = { getButton(for: .safari) }()
    private lazy var systemProtectionButton = { getButton(for: .system) }()
    private lazy var vpnUpsellButton: RoundRectButton? = {
        if !ChineseUserExposer.isUserFromChina {
            return getButton(for: .vpn)
        }
        return nil
    }()

    @IBOutlet weak var protectionButtonsStackView: UIStackView!

    @IBOutlet weak var protectionStateLabel: ThemableLabel!
    @IBOutlet weak var protectionStatusLabel: ThemableLabel!


    // MARK: - Complex protection switch

    @IBOutlet weak var complexProtectionView: UIView!
    @IBOutlet weak var complexProtectionSwitch: ComplexProtectionSwitch!


    // MARK: - Statistics elements

    @IBOutlet weak var changeStatisticsDatesButtonContainer: UIView!
    @IBOutlet weak var changeStatisticsDatesButton: UIButton!
    @IBOutlet var chartView: ChartView!
    private var stabView: UIView?

    @IBOutlet weak var statisticsStackView: UIStackView!

    @IBOutlet weak var requestsButton: UIButton!
    @IBOutlet weak var encryptedButton: UIButton!
    @IBOutlet weak var elapsedButton: UIButton!

    @IBOutlet weak var requestsNumberLabel: ThemableLabel!
    @IBOutlet weak var encryptedNumberLabel: ThemableLabel!
    @IBOutlet weak var elapsedNumberLabel: ThemableLabel!

    @IBOutlet weak var requestsTextLabel: ThemableLabel!
    @IBOutlet weak var encryptedTextLabel: ThemableLabel!
    @IBOutlet weak var elapsedTextLabel: ThemableLabel!


    // MARK: Get Pro elements

    @IBOutlet weak var getProView: UIView!
    @IBOutlet weak var adguardManImageView: UIImageView!
    @IBOutlet weak var manDialogView: UIView!
    @IBOutlet weak var manDialogText: ThemableLabel!
    @IBOutlet weak var getProButton: UIButton!

    // MARK: - Native DNS view

    @IBOutlet weak var nativeDnsTitleLabel: ThemableLabel!
    @IBOutlet weak var nativeDnsView: UIView!
    @IBOutlet weak var dnsProviderNameLabel: ThemableLabel!
    @IBOutlet weak var dnsProtocolNameLabel: ThemableLabel!

    // MARK: - Content blockers view

    @IBOutlet weak var contentBlockerViewIphone: UIView!
    @IBOutlet weak var contentBlockerViewIpad: UIView!


    // MARK: - Themable labels

    @IBOutlet var themableLabels: [ThemableLabel]!


    // MARK: - Constraints
    @IBOutlet weak var contentBlockerViewConstraint: NSLayoutConstraint!

    // MARK: - Constraints to change for iphone SE - like devices

    @IBOutlet weak var complexSwitchWidth: NSLayoutConstraint!
    @IBOutlet weak var complexSwitchHeight: NSLayoutConstraint!
    @IBOutlet weak var fromButtonsToTopHeight: NSLayoutConstraint!
    @IBOutlet weak var fixItIphoneButton: UIButton!
    @IBOutlet weak var fixItiPadButton: UIButton!

    var stateFromWidget: Bool?

    var importSettings: ImportSettings?

    var domainToEnableProtectionFor: String?

    // MARK: - Variables

    private var iconButton: UIButton? = nil
    private var remoteMigrationInfoView: RemoteMigrationInfoView?
    private let getProSegueId = "getProSegue"

    private var proStatus: Bool { configuration.proStatus }
    private var contentBlockersGestureRecognizer: UIPanGestureRecognizer? = nil

    // We change constraints only for iphone SE - like devices
    private let isIphoneSeLike = UIScreen.main.bounds.width == 320.0
    private let screenIsLessThanIphone6 = UIScreen.main.bounds.width <= 414.0

    // Indicates whether filters are updating
    private var updateInProcess = false

    // Show helper only once during app lifecycle
    private var contentBlockerHelperWasShown = false

    private var onBoardingIsInProcess = false

    private var safariUpdateEnded = true
    private var dnsUpdateEnded = true

    private var remoteMigrationInfoViewClosedByUser = false


    // MARK: - Services

    private lazy var configuration: ConfigurationServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var resources: AESharedResourcesProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var complexProtection: ComplexProtectionServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var nativeDnsManager: NativeDnsSettingsManagerProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var safariProtection: SafariProtectionProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var dnsProtection: DnsProtectionProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var dnsProvidersManager: DnsProvidersManagerProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var dnsConfigAssistant: DnsConfigManagerAssistantProtocol = {
        ServiceLocator.shared.getService()! }()
    private lazy var remoteMigrationService: RemoteMigrationService = { ServiceLocator.shared.getService()! }()

    // MARK: - View models
    private lazy var mainPageModel: MainPageModelProtocol = { MainPageModel(safariProtection: safariProtection, dnsProtection: dnsProtection, dnsConfigAssistant: dnsConfigAssistant) }()
    private var chartModel: ChartViewModelProtocol!

    // MARK: - Observers
    private var appWillEnterForeground: NotificationToken?
    private var vpnConfigurationObserver: NotificationToken!
    private var contentBlockerObserver: NotificationToken!
    private var dnsImplementationObserver: NotificationToken?
    private var currentDnsServerObserver: NotificationToken?
    private var proStatusObserver: NotificationToken?
    private var remoteMigrationObserver: NotificationToken?

    // MARK: - View Controller life cycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProtectionButtonsStackView()
        updateTheme()
        initChartViewModel()
        statisticsPeriodChanged(statisticsPeriod: resources.chartDateType)
        addObservers()
        setUIForRequestType(true)
        setupVoiceOverLabels()

        complexProtectionSwitch.delegate = self
        mainPageModel.delegate = self


        contentBlockersGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleContentBlockersView(_:)))
        if let recognizer = contentBlockersGestureRecognizer {
            contentBlockerViewIpad.addGestureRecognizer(recognizer)
        }

        configuration.checkContentBlockerEnabled()

        if let stateFromWidget = self.stateFromWidget {
            complexProtection.switchComplexProtection(state: stateFromWidget, for: self) { (_, _) in
            }
        }

        if importSettings != nil {
            showImportSettings()
        }

        processDnsServerChange()
        checkAdGuardVpnIsInstalled()
        observeContentBlockersState()

        if let domain = domainToEnableProtectionFor, !domain.isEmpty {
            processDomainAndEnableProtection(domain)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        processState()
        updateProtectionStates()
        updateProtectionStatusText()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let nav = navigationController as? MainNavigationController {
            nav.addGestureRecognizer()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        chartModel.chartViewSizeChanged(frame: chartView.frame)

        if isIphoneSeLike {
            setupConstraintsForIphoneSe()
        }
        if screenIsLessThanIphone6 {
            setupFontsForSmallScreen()
        }

        getProButton.layer.cornerRadius = getProButton.frame.height / 2
        fixItIphoneButton.layer.cornerRadius = fixItIphoneButton.frame.height / 2
        fixItiPadButton.layer.cornerRadius = fixItiPadButton.frame.height / 2
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusbarStyle()
    }

    private func processContentBlockersHelper() {
        if #available(iOS 15.0, *), !resources.whatsNewScreenShown {
            showWhatsNewWithAdvancedProtectionInfo { [weak self] in
                self?.showContentBlockersHelperIfNeeded()
            }
            resources.whatsNewScreenShown = true
        } else {
            showContentBlockersHelperIfNeeded()
        }
    }

    // MARK: - Actions


    // MARK: - Nav Bar Actions

    @objc private func updateFilters(_ sender: Any) {
        mainPageModel.updateFilters()
    }

    // MARK: - Protection Status Actions

    @objc private final func changeSafariProtectionState(_ sender: RoundRectButton) {
        safariProtectionButton.buttonIsOn = !safariProtectionButton.buttonIsOn

        applyingChangesStarted()
        complexProtection.switchSafariProtection(state: safariProtectionButton.buttonIsOn, for: self) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.applyingChangesEnded()

                if error != nil {
                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: error?.localizedDescription)
                }
            }
        }
        updateProtectionStates()
    }

    @objc private final func changeSystemProtectionState(_ sender: RoundRectButton) {
        if resources.dnsImplementation == .native {
            if systemProtectionButton.buttonIsOn {
                if #available(iOS 14.0, *) {
                    nativeDnsManager.removeDnsConfig { error in
                        DDLogError("Error removing dns manager: \(error.debugDescription)")
                    }
                }
            } else if #available(iOS 14.0, *) {
                nativeDnsManager.saveDnsConfig { error in
                    if let error = error {
                        DDLogError("Received error when turning system protection on; Error: \(error.localizedDescription)")
                    }
                    DispatchQueue.main.async {
                        AppDelegate.shared.presentHowToSetupController()
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.updateProtectionStates()
            }
            return
        }

        systemProtectionButton.buttonIsOn = !systemProtectionButton.buttonIsOn
        if configuration.proStatus {
            applyingChangesStarted()
            complexProtection.switchSystemProtection(state: systemProtectionButton.buttonIsOn, for: self) { [weak self] error in
                DispatchQueue.main.async {
                    guard let self = self else { return }

                    self.applyingChangesEnded()
                    if error != nil {
                        ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: error?.localizedDescription)
                    }
                }
            }
        }
        else {
            performSegue(withIdentifier: getProSegueId, sender: self)
        }
        updateProtectionStates()
    }

    @objc private final func vpnUpsellTapped(_ sender: RoundRectButton) {
        if UIApplication.adGuardVpnIsInstalled {
            UIApplication.openAdGuardVpnAppIfInstalled()
        } else {
            presentUpsellScreen()
        }
    }

    // MARK: - Complex protection switch action

    @IBAction func complexProtectionState(_ sender: ComplexProtectionSwitch) {
        let enabled = sender.isOn
        applyingChangesStarted()
        complexProtection.switchComplexProtection(state: enabled, for: self) { [weak self] (safariError, systemError) in
            DispatchQueue.asyncSafeMain { [weak self] in
                guard let self = self else { return }
                self.applyingChangesEnded()

                if safariError != nil {
                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: safariError?.localizedDescription)
                }

                if systemError != nil {
                    ACSSystemUtils.showSimpleAlert(for: self, withTitle: nil, message: systemError?.localizedDescription)
                }
            }
        }
        updateProtectionStates()
    }


    // MARK: - Statistics Actions

    @IBAction func changeStatisticDates(_ sender: UIButton) {
        showChartDateTypeController()
    }

    @IBAction func requestsTapped(_ sender: UIButton) {
        chooseRequest()
    }

    @IBAction func encryptedTapped(_ sender: UIButton) {
        chooseEncrypted()
    }

    @IBAction func averageTimeTapped(_ sender: UIButton) {
        chooseElapsedTime()
    }

    // MARK: - Content blockers view actions

    @IBAction func crossTapped(_ sender: UIButton) {
        hideContentBlockersInfo()
    }

    @IBAction func fixItTapped(_ sender: UIButton) {
        showContentBlockersHelper()
    }

    // MARK: - DateTypeChangedProtocol method

    func statisticsPeriodChanged(statisticsPeriod: StatisticsPeriod) {
        resources.chartDateType = statisticsPeriod
        changeStatisticsDatesButton.setTitle(statisticsPeriod.dateTypeString, for: .normal)
        chartModel.statisticsPeriod = statisticsPeriod
    }


    // MARK: - Complex switch delegate

    func beginTracking() {
        if let nav = navigationController as? MainNavigationController {
            nav.removeGestureRecognizer()
        }
    }

    // MARK: - OnboardingViewController delegate

    func onboardingDidFinish() {
        resources.sharedDefaults().set(true, forKey: OnboardingWasShown)
        configuration.showStatusBar = true
        onBoardingIsInProcess = false
        processPresentingDialogs()
    }

    // MARK: - LicensePageViewControllerDelegate delegate

    func controllerDismissed() {
        onboardingDidFinish()
    }

    // MARK: - view model delegate methods

    func updateStarted() {
        protectionStatusLabel.text = String.localizedString("update_filter_start_message")
        safariUpdateEnded = false
        dnsUpdateEnded = false
        updateStartedInternal()
    }

    func updateFinished(message: String) {
        protectionStatusLabel.text = message
        safariUpdateEnded = true
        dnsUpdateEnded = true
        endUpdate()
    }

    // MARK: - Private methods

    private func processDomainAndEnableProtection(_ domain: String) {
        if resources.invertedWhitelist {
            let rule = UserRule(ruleText: domain, isEnabled: true)
            try? safariProtection.add(rule: rule, for: .invertedAllowlist, override: true, onCbReloaded: nil)
        } else {
            try? safariProtection.removeRule(withText: domain, for: .allowlist, onCbReloaded: nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard
                let self = self,
                !self.complexProtection.safariProtectionEnabled,
                !self.safariProtectionButton.buttonIsOn
            else {
                return
            }
            self.changeSafariProtectionState(self.safariProtectionButton)
        }
    }

    /**
     Presents ChartDateTypeController
     */
    private func showChartDateTypeController(){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ChartDateTypeController") as? ChartDateTypeController else { return }
        controller.delegate = self
        controller.periodType = resources.chartDateType
        present(controller, animated: true, completion: nil)
    }

    /**
    Changes number of requests for all buttons
    */
    private func updateTextForButtons(requestsCount: Int, encryptedCount: Int, averageElapsed: Double){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }

            self.requestsNumberLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: requestsCount))
            self.encryptedNumberLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: encryptedCount))
            self.elapsedNumberLabel.text = String.simpleSecondsFormatter(NSNumber(floatLiteral: averageElapsed))
        }
    }

    /**
     Called when "requests" button tapped
     */
    private func chooseRequest(){
        if chartModel.chartType == .requests {
            let title = String.localizedString("requests_info_alert_title")
            let message = String.localizedString("requests_info_alert_message")
            presentSimpleAlert(title: title, message: message)
        } else {
            setUIForRequestType()
        }
    }

    private func setUIForRequestType(_ initial: Bool = false) {
        /*
         When we call this method in viewDidLoad we don't need set chartView.activeChart,
         because it will redraw chart, and then we call chartModel.chartRequestType that also redraws chart
        */
        if !initial {
            chartView.activeChart = .requests
        }
        chartModel.chartType = .requests

        requestsNumberLabel.alpha = 1.0
        encryptedNumberLabel.alpha = 0.5

        requestsTextLabel.alpha = 1.0
        encryptedTextLabel.alpha = 0.5
    }

    /**
    Called when "blocked" button tapped
    */
    private func chooseEncrypted(){
        if chartModel.chartType == .encrypted {
            let title = String.localizedString("encrypted_info_alert_title")
            let message = String.localizedString("encrypted_info_alert_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
        } else {
            chartView.activeChart = .encrypted
            chartModel.chartType = .encrypted

            requestsNumberLabel.alpha = 0.5
            encryptedNumberLabel.alpha = 1.0

            requestsTextLabel.alpha = 0.5
            encryptedTextLabel.alpha = 1.0
        }
    }

    /**
    Called when "data daved" button tapped
    */
    private func chooseElapsedTime(){
        ACSSystemUtils.showSimpleAlert(for: self, withTitle: String.localizedString("average_info_alert_title"), message: String.localizedString("average_info_alert_message"))
    }

    /**
    Checks if AdGuard VPN is installed and changes VPN upsell button color
    */
    private func checkAdGuardVpnIsInstalled() {
        vpnUpsellButton?.buttonIsOn = UIApplication.adGuardVpnIsActive
    }

    /**
     Adds observers to controller
     */
    private func addObservers() {

        appWillEnterForeground = NotificationCenter.default.observe(name: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: {[weak self] (notification) in
            self?.updateProtectionStates()
            self?.updateProtectionStatusText()
            self?.checkAdGuardVpnIsInstalled()
            self?.processState()
        })

        proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            self?.processState()
        }

        contentBlockerObserver = NotificationCenter.default.observe(name: .contentBlockersStateChanged, object: nil, queue: .main) { [weak self] _ in
            self?.observeContentBlockersState()
        }

        vpnConfigurationObserver = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateProtectionStates()
            self?.updateProtectionStatusText()
        }

        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            self?.processState()
            self?.processDnsServerChange()
        }

        currentDnsServerObserver = NotificationCenter.default.observe(name: .currentDnsServerChanged, object: nil, queue: .main) { [weak self] _ in
            self?.processDnsServerChange()
        }

        // Add observer only if it is not ASL app
        if UIApplication.shared.aslApp { return }

        remoteMigrationObserver = NotificationCenter.default.observe(name: .needForMigration, object: nil, queue: .main) { [weak self] _ in
            self?.processNeedForMigrationObserver()
            self?.processState()
        }
    }

    /**
     Starts to rotate refresh button
     */
    private func updateStartedInternal(){
        updateInProcess = true
        iconButton?.isUserInteractionEnabled = false
        updateButton.customView?.rotateImage(isNeeded: true)
    }

    /**
     Stops to rotate refresh button
     */
    private func updateEndedInternal(){
        DispatchQueue.main.async {[weak self] in
            self?.updateInProcess = false
            self?.iconButton?.isUserInteractionEnabled = true
            self?.updateButton.customView?.rotateImage(isNeeded: false)
            self?.updateProtectionStates()

            // return status title few seconds later
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.updateProtectionStatusText()
            }
        }
    }

    /**
     Starts indicating that changes are applied
     */
    private func applyingChangesStarted(){
        protectionStatusLabel.text = String.localizedString("applying_changes")
    }

    /**
    Stops indicating that changes are applied
    */
    private func applyingChangesEnded(){
        updateProtectionStatusText()
        updateProtectionStates()
    }

    /* States views by pro status and dns implementation */
    private func processState() {
        let isNativeImplementation = resources.dnsImplementation == .native

        getProView.isHidden = true
        statisticsStackView.isHidden = true
        nativeDnsView.isHidden = true
        changeStatisticsDatesButton.isHidden = true

        if proStatus {
            if isNativeImplementation {
                nativeDnsView.isHidden = false
            } else {
                statisticsStackView.isHidden = false
                changeStatisticsDatesButton.isHidden = false
            }
        } else {
            let isNeedToHide = !remoteMigrationInfoViewClosedByUser && (remoteMigrationService.isNeedRemoteMigration || UIApplication.shared.legacyAppDetected)
            getProView.isHidden = isNeedToHide
        }

        // We need to check if user install / deinstall legacy apps and change UI
        addRemoteMigrationInfoViewIfNeeded()

        systemProtectionButton.buttonIsOn = complexProtection.systemProtectionEnabled
    }

    private func processDnsServerChange() {
        guard resources.dnsImplementation == .native else {
            return
        }

        if resources.dnsImplementation == .native {
            dnsProviderNameLabel.text = dnsProvidersManager.activeDnsProvider.name
            dnsProtocolNameLabel.text = dnsProvidersManager.activeDnsServer.type.localizedName
        } else {
            dnsProviderNameLabel.text = nil
            dnsProtocolNameLabel.text = nil
        }
    }

    /**
    Update state of safari, system and complex protection
     and updates UI
    */

    private func updateProtectionStatusText() {

        let complexText: String

        switch (complexProtection.safariProtectionEnabled, complexProtection.systemProtectionEnabled, complexProtection.complexProtectionEnabled) {
        case (true, true, true):
            complexText = String.localizedString("complex_enabled")
        case (_, _, false):
            complexText = String.localizedString("complex_disabled")
        case (true, _, _):
            complexText = String.localizedString("safari_enabled")
        case (_, true, _):
            complexText = String.localizedString("system_enabled")
        case (false, false, true):
            // incorrect state
            complexText = ""
        }

        protectionStatusLabel.text = safariUpdateEnded && dnsUpdateEnded ? complexText : String.localizedString("update_filter_start_message")
        complexProtectionSwitch.accessibilityLabel = safariUpdateEnded && dnsUpdateEnded ? complexText : String.localizedString("update_filter_start_message")

        nativeDnsTitleLabel.text = complexProtection.systemProtectionEnabled ? String.localizedString("native_dns_working") : String.localizedString("native_dns_not_working")
    }

    private func updateProtectionStates() {
        let enabledText = complexProtection.complexProtectionEnabled ? String.localizedString("protection_enabled") : String.localizedString("protection_disabled")
        protectionStateLabel.text = enabledText

        self.safariProtectionButton.buttonIsOn = complexProtection.safariProtectionEnabled
        self.systemProtectionButton.buttonIsOn = complexProtection.systemProtectionEnabled
        self.chartView.isEnabled = complexProtection.systemProtectionEnabled
        self.complexProtectionSwitch.setOn(on: complexProtection.complexProtectionEnabled)
    }

    /**
    Checks state of content blockers
     and updates UI
    */
    private func observeContentBlockersState() {
        DDLogInfo("Content blockers states changed; allContentBlockersEnabled = \(configuration.allContentBlockersEnabled)")
        if configuration.allContentBlockersEnabled {
            hideContentBlockersInfo()
        } else {
            showContentBlockersInfo()
        }

        let onboardingShown = resources.sharedDefaults().bool(forKey: OnboardingWasShown)

        DDLogInfo("Content blockers states changed; onboardingShown = \(onboardingShown); onBoardingIsInProcess = \(onBoardingIsInProcess)")
        if !onBoardingIsInProcess {
            if !onboardingShown {
                configuration.showStatusBar = false
                showOnboarding()
            } else {
                processContentBlockersHelper()
            }
        }
    }

    /**
     Shows iPad content blockers info
     */
    private func showIpadContentBlockersInfo(){
        contentBlockerViewIpad.alpha = 0.0
        contentBlockerViewIpad.isHidden = false
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.contentBlockerViewIpad.alpha = 1.0
        }
    }

    /**
     Hides iPad content blockers info
     */
    private func hideIpadContentBlockersInfo(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.contentBlockerViewIpad.alpha = 0.0
        }) {[weak self] (success) in
            self?.contentBlockerViewIpad.isHidden = true
        }
    }

    /**
     Shows iPhone content blockers info
    */
    private func showIphoneContentBlockersInfo(){
       contentBlockerViewIphone.isHidden = false
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.contentBlockerViewConstraint.constant = 64.0
        }
    }

    /**
     Hides iPhone content blockers info
    */
    private func hideIphoneContentBlockersInfo(){
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.contentBlockerViewConstraint.constant = 0.0
        }) {[weak self] (success) in
            self?.contentBlockerViewIphone.isHidden = true
        }
    }

    /**
     Shows content blockers info
     */
    private func showContentBlockersInfo() {
        DispatchQueue.main.async {[weak self] in
            self?.showIphoneContentBlockersInfo()
            self?.showIpadContentBlockersInfo()
        }
    }

    /**
     Hides content blockers info
     */
    private func hideContentBlockersInfo() {
        DispatchQueue.main.async {[weak self] in
            self?.hideIpadContentBlockersInfo()
            self?.hideIphoneContentBlockersInfo()
        }
    }

    @objc private func handleContentBlockersView(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)
        let x = translation.x
        let y = translation.y
        let gestureViewX = gestureRecognizer.view?.center.x ?? 0.0
        let gestureViewY = gestureRecognizer.view?.center.y ?? 0.0

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            contentBlockerViewIpad.center = CGPoint(x: gestureViewX + x, y: gestureViewY + y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }

    private func showOnboarding() {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            if let navController = storyboard.instantiateViewController(withIdentifier: "OnboardingNavigationController") as? UINavigationController {
                if let controller = navController.viewControllers.first as? IntroductionOnboardingController {
                    controller.delegate = self
                }
                self?.onBoardingIsInProcess = true
                self?.present(navController, animated: true)
            }
        }
    }

    private func showContentBlockersHelper() {
        DispatchQueue.main.async { [weak self] in
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            if let navController = storyboard.instantiateViewController(withIdentifier: "OnboardingNavigationController") as? UINavigationController, let controller = storyboard.instantiateViewController(withIdentifier: "OnboardingController") as? OnboardingController{
                navController.viewControllers = [controller]
                controller.delegate = self
                controller.needsShowingPremium = false
                self?.present(navController, animated: true)
            }
        }
    }

    private func showWhatsNewWithAdvancedProtectionInfo(_ completion: (() -> Void)?) {
        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "WhatsNewBottomAlertController") as? WhatsNewBottomAlertController {
            controller.onDismissCompletion = completion
            controller.delegate = self
            present(controller, animated: true)
        }
    }

    private func processPresentingDialogs() {
        let notification: UserNotificationServiceProtocol = ServiceLocator.shared.getService()!
        notification.requestPermissions { _ in
            DispatchQueue.main.async { [weak self] in
                if UIApplication.shared.aslApp {
                    self?.processPresentingLegacyAppDialogIfNeeded()
                } else {
                    self?.processPresentingRemoteMigrationDialogIfNeeded()
                }
            }
        }
    }

    /**
     As iPhone SE screen is very small we need different constraints for it
     */
    private func setupConstraintsForIphoneSe(){
        fromButtonsToTopHeight.constant = 10.0

        fixItIphoneButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .bold)
        manDialogText.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)

        protectionStateLabel.font = protectionStateLabel.font.withSize(20.0)
        protectionStatusLabel.font = protectionStatusLabel.font.withSize(14.0)

        complexSwitchWidth.constant = 80.0
        complexSwitchHeight.constant = 30.0

        view.layoutIfNeeded()
    }

    private func setupFontsForSmallScreen(){
        requestsTextLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        encryptedTextLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        elapsedTextLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }

    private func setupVoiceOverLabels(){
        safariProtectionButton.accessibilityLabel = String.localizedString("safari_enabled")
        systemProtectionButton.accessibilityLabel = String.localizedString("system_enabled")

        requestsButton.accessibilityLabel = String.localizedString("requests_number_voiceover")
        encryptedButton.accessibilityLabel = String.localizedString("encrypted_number_voiceover")
        elapsedButton.accessibilityLabel = String.localizedString("elapsed_time_voiceover")

        safariProtectionButton.onAccessibilityTitle = String.localizedString("safari_protection_enabled_voiceover")
        safariProtectionButton.offAccessibilityTitle = String.localizedString("safari_protection_disabled_voiceover")

        systemProtectionButton.onAccessibilityTitle = String.localizedString("tracking_protection_enabled_voiceover")
        systemProtectionButton.offAccessibilityTitle = String.localizedString("tracking_protection_disabled_voiceover")
    }

    private func endUpdate()
    {
        switch(safariUpdateEnded, dnsUpdateEnded){
        case (true, true):
            updateEndedInternal()
        default:
            break
        }
    }

    private func showImportSettings() {
        let storyboard = UIStoryboard(name: "ImportSettings", bundle: nil)

        guard let importController = storyboard.instantiateViewController(withIdentifier: "ImportSettingsController") as? ImportSettingsController else {
            DDLogError("can not instantiate ImportSettingsController")
            return
        }

        guard let settings = importSettings else { return }

        importController.settings = settings
        present(importController, animated: true, completion: nil)
    }

    private func showContentBlockersHelperIfNeeded() {
        if !configuration.someContentBlockersEnabled && !contentBlockerHelperWasShown {
            showContentBlockersHelper()
            contentBlockerHelperWasShown = true
        } else {
            processPresentingDialogs()
        }
    }

    private func initChartViewModel() {
        let chartStatistics: ChartStatisticsProtocol = ServiceLocator.shared.getService()!
        let activityStatistics: ActivityStatisticsProtocol = ServiceLocator.shared.getService()!
        chartModel = ChartViewModel(statisticsPeriod: resources.chartDateType, activityStatistics: activityStatistics, chartStatistics: chartStatistics)

        chartModel.delegate = self
    }

    private func processNeedForMigrationObserver() {
        let isNeedRemoteMigration = remoteMigrationService.isNeedRemoteMigration
        let remoteMigrationDialogShown = resources.remoteMigrationDialogShown

        if isNeedRemoteMigration, !remoteMigrationDialogShown {
            DDLogInfo("(MainPageController) Start presenting remote migration dialog from observer")
            presentRemoteMigrationDialog()
            return
        }

        DDLogWarn("(MainPageController) Remote migration dialog not presented. Is needed for remote migration = \(isNeedRemoteMigration), remote migration dialog has already been shown = \(remoteMigrationDialogShown)")
    }

    private func processPresentingLegacyAppDialogIfNeeded() {
        if resources.legacyAppDetectedDialogShown {
            DDLogInfo("(MainPageController) Legacy app dialog already has been shown")
            processPresentingsRateAppDialog()
            return
        }

        guard let legacyApp = UIApplication.shared.detectLegacyAppInstalled() else {
            DDLogInfo("(MainPageController) Legacy app dialog was not presented, legacy apps wasn't detected")
            processPresentingsRateAppDialog()
            return
        }

        presentLegacyAppDetectedDialog(legacyApp)
    }

    private func processPresentingRemoteMigrationDialogIfNeeded() {
        // We need to check if we need to inform the user that migration is necessary on each 'ready' shot
        let isNeedRemoteMigration = remoteMigrationService.isNeedRemoteMigration
        let remoteMigrationDialogShown = resources.remoteMigrationDialogShown

        guard isNeedRemoteMigration, !remoteMigrationDialogShown else {
            DDLogInfo("(MainPageController) Remote migration dialog was not presented. Is need migration = \(isNeedRemoteMigration), is remote migration dialog has been shown = \(remoteMigrationDialogShown)")
            processPresentingsRateAppDialog()
            return
        }

        DDLogInfo("(MainPageController) Present remote migration dialog on callOnReady")
        presentRemoteMigrationDialog()
    }

    private func presentRemoteMigrationDialog() {
        let presentOn = lastPresentedController
        if presentOn is RemoteMigrationDialog {
            DDLogWarn("(MainPageController) \(RemoteMigrationDialog.self) already presented")
            return
        }

        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        let dialog = storyboard.instantiateViewController(withIdentifier: "\(RemoteMigrationDialog.self)")

        DDLogInfo("(MainPageController) Start presenting remote migration dialog")

        presentOn.present(dialog, animated: true) { [weak self] in
            // Reset all the flags to avoid duplicates
            self?.resources.remoteMigrationDialogShown = true
            self?.resources.backgroundFetchRemoteMigrationRequestResult = false
        }
    }

    private func presentLegacyAppDetectedDialog(_ legacy: UIApplication.LegacyAppType) {
        let presentOn = lastPresentedController
        if presentOn is AdGuardProFoundDialog || presentOn is AdGuardFoundDialog {
            DDLogWarn("(MainPageController) LegacyAppDialog already presented")
            return
        }

        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        let dialog = storyboard.instantiateViewController(withIdentifier: legacy == .adguard ? "\(AdGuardFoundDialog.self)" : "\(AdGuardProFoundDialog.self)")
        presentOn.present(dialog, animated: true) {
            self.resources.legacyAppDetectedDialogShown = true
        }
    }

    private func processPresentingsRateAppDialog() {
        // Show rate app dialog when main page is initialized
        if !remoteMigrationService.isNeedRemoteMigration {
            showRateAppDialogIfNeeded()
        }
    }

    private func showRateAppDialogIfNeeded() {
        let rateService: RateAppServiceProtocol = ServiceLocator.shared.getService()!
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            if rateService.shouldShowRateAppDialog {
                AppDelegate.shared.presentRateAppController()
                self?.resources.rateAppShown = true
            }
        }
    }





    /// Functions to work with migration info view

    private func  addRemoteMigrationInfoViewIfNeeded() {
        let newAppDetectLegacyApp = UIApplication.shared.legacyAppDetected
        let legacyAppWithNeedingMigration =  remoteMigrationService.isNeedRemoteMigration && !UIApplication.shared.aslApp
        let needToShowRemoteMigrationInfoView = !remoteMigrationInfoViewClosedByUser && (newAppDetectLegacyApp || legacyAppWithNeedingMigration)

        guard needToShowRemoteMigrationInfoView else {
            resetRemoteMigrationInfoViewIfNeeded()
            resetChartViewIfNeeded()
            return
        }

        resetRemoteMigrationInfoViewIfNeeded()

        if isIpadTrait {
            setupIpadRemoteMigrationInfoViewConstraints()
        } else {
            setupIphoneRemoteMigrationInfoViewConstraints()
        }
    }

    private func setupIpadRemoteMigrationInfoViewConstraints() {
        let infoView = createRemoteMigrationInfoViewAndAddToHierarchy()

        let constraints = [
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            infoView.bottomAnchor.constraint(equalTo: contentBlockerViewIpad.topAnchor, constant: -4.0)
        ]

        // We need to activate this specific bottom constraint asyncronously in iOS 12.4 and below, and only on iPad, to prevent
        // the app from crashing
        if #available(iOS 13, *) {
            NSLayoutConstraint.activate(constraints)
        } else {
            // Lets schedule constraint activation task to end of queue
            DispatchQueue.main.async { NSLayoutConstraint.activate(constraints) }
        }

        removeChartViewIfNeeded()
    }

    private func setupIphoneRemoteMigrationInfoViewConstraints() {
        let infoView = createRemoteMigrationInfoViewAndAddToHierarchy()

        let constraint: NSLayoutConstraint
        switch resources.dnsImplementation {
            case .adGuard:
                if proStatus {
                    constraint = infoView.bottomAnchor.constraint(equalTo: changeStatisticsDatesButton.topAnchor)
                } else {
                    constraint = infoView.bottomAnchor.constraint(equalTo: contentBlockerViewIphone.topAnchor, constant: -16.0)
                }
            case .native:
                constraint = infoView.bottomAnchor.constraint(equalTo: nativeDnsTitleLabel.topAnchor, constant: -4.0)
        }

        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            constraint
        ])

        removeChartViewIfNeeded()
    }

    private func createRemoteMigrationInfoViewAndAddToHierarchy() -> UIView {
        if let infoView = remoteMigrationInfoView {
            view.addSubview(infoView)
            return infoView
        }

        remoteMigrationInfoView = RemoteMigrationInfoView(contentType: UIApplication.shared.aslApp ? .legacyAppDialog : .infoDialog)
        remoteMigrationInfoView?.updateTheme()
        remoteMigrationInfoView?.delegate = self

        view.addSubview(remoteMigrationInfoView!)
        remoteMigrationInfoView?.translatesAutoresizingMaskIntoConstraints = false
        return remoteMigrationInfoView!
    }

    private func removeChartViewIfNeeded() {
        guard statisticsStackView.arrangedSubviews.contains(chartView) else { return }

        let stabView = UIView()
        stabView.backgroundColor = .clear
        self.stabView = stabView
        statisticsStackView.insertArrangedSubview(stabView, at: 0)
        statisticsStackView.removeArrangedSubview(chartView)
        chartView.removeFromSuperview()
    }


    /// Removes remote migration info view and returns back chart view
    private func resetRemoteMigrationInfoViewIfNeeded() {
        guard let infoView = remoteMigrationInfoView else { return }
        statisticsStackView.removeArrangedSubview(infoView)
        infoView.removeFromSuperview()
        remoteMigrationInfoView = nil
    }

    private func resetChartViewIfNeeded() {
        guard let stabView = self.stabView else { return }
        statisticsStackView.removeArrangedSubview(stabView)
        stabView.removeFromSuperview()
        self.stabView = nil

        if let dateButtonContainerIndex = statisticsStackView.arrangedSubviews.index(of: changeStatisticsDatesButtonContainer) {
            let insertIndex = dateButtonContainerIndex + 1
            guard statisticsStackView.arrangedSubviews.count >= insertIndex else { return }
            statisticsStackView.insertArrangedSubview(chartView, at: insertIndex)
        }
    }
}

extension MainPageController: ThemableProtocol {
    func updateTheme(){
        navigationController?.view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)

        chartView.updateTheme()
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        getProView.backgroundColor = theme.backgroundColor
        remoteMigrationInfoView?.updateTheme()

        contentBlockerViewIphone.backgroundColor = theme.notificationWindowColor
        contentBlockerViewIpad.backgroundColor = UIColor.AdGuardColor.lightGray6
        nativeDnsView.backgroundColor = theme.backgroundColor
    }
}

extension MainPageController: WhatsNewBottomAlertControllerDelegate {
    func continueButtonForNonProTapped() {
        if configuration.proStatus { return }
        resources.whatsNewScreenShown = true
        self.dismiss(animated: true) {
            let _ = AppDelegate.shared.presentAdvancedProtectionController(enableAdvancedProtection: nil)
        }
    }
}

extension MainPageController: ChartViewModelDelegate {
    func numberOfRequestsChanged(with points: (requests: [CGPoint], encrypted: [CGPoint]),
                                 countersStatisticsRecord: CountersStatisticsRecord?,
                                 firstFormattedDate: String,
                                 lastFormattedDate: String,
                                 maxRequests: Int) {

        chartView.chartPoints = points
        updateTextForButtons(requestsCount: countersStatisticsRecord?.requests ?? 0, encryptedCount: countersStatisticsRecord?.encrypted ?? 0, averageElapsed: Double(countersStatisticsRecord?.averageElapsed ?? 0))

        chartView.leftDateLabelText = firstFormattedDate
        chartView.rightDateLabelText = lastFormattedDate
        chartView.maxRequests = maxRequests
    }
}

// MARK: - MainPageController + Protection buttons stack view setup

fileprivate extension MainPageController {

    enum ProtectionType: CaseIterable {
        case safari
        case system
        case vpn

        var image: UIImage? {
            switch self {
            case .safari: return UIImage(named: "safari")
            case .system: return UIImage(named: "ic_adguard")
            case .vpn: return UIImage(named: "vpn_logo")
            }
        }

        var selector: Selector {
            switch self {
            case .safari: return #selector(changeSafariProtectionState(_:))
            case .system: return #selector(changeSystemProtectionState(_:))
            case .vpn: return #selector(vpnUpsellTapped(_:))
            }
        }
    }

    func setupProtectionButtonsStackView() {
        protectionButtonsStackView.alignment = .center
        protectionButtonsStackView.axis = .horizontal
        protectionButtonsStackView.distribution = .fillEqually
        protectionButtonsStackView.spacing = isIphoneSeLike ? 20.0 : 28.0

        protectionButtonsStackView.addArrangedSubview(safariProtectionButton)
        protectionButtonsStackView.addArrangedSubview(systemProtectionButton)
        if let vpnButton = vpnUpsellButton {
            protectionButtonsStackView.addArrangedSubview(vpnButton)
        }
    }

    func getButton(for type: ProtectionType) -> RoundRectButton {
        let button = RoundRectButton()
        button.onTintColor = UIColor.AdGuardColor.lightGreen1
        button.offTintColor = UIColor.AdGuardColor.lightGray3
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.setImage(type.image, for: .normal)
        button.addTarget(self, action: type.selector, for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        let side: CGFloat = isIphoneSeLike ? 24.0 : (isIpadTrait ? 42.0 : 32.0)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: side),
            button.heightAnchor.constraint(equalToConstant: side)
        ])
        return button
    }
}

extension MainPageController : RemoteMigrationInfoViewDelegate {
    func linkTapped(for type: RemoteMigrationInfoView.ContentType) {
        let storyboard = UIStoryboard(name: "MainPage", bundle: nil)
        let vc: UIViewController
        switch type {
            case .infoDialog:
                vc = storyboard.instantiateViewController(withIdentifier: "\(RemoteMigrationDialog.self)")
            case .legacyAppDialog:
                guard let detected = UIApplication.shared.detectLegacyAppInstalled() else { return }
                vc = storyboard.instantiateViewController(withIdentifier: detected == .adguard ? "\(AdGuardFoundDialog.self)" : "\(AdGuardProFoundDialog.self)")
        }

        present(vc, animated: true)
    }

    func closeButtonTapped() {
        remoteMigrationInfoViewClosedByUser = true
        processState()
    }
}
