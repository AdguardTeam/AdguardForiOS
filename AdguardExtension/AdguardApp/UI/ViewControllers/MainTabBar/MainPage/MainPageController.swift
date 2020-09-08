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

class MainPageController: UIViewController, DateTypeChangedProtocol, NumberOfRequestsChangedDelegate, ComplexSwitchDelegate, OnboardingControllerDelegate, GetProControllerDelegate, MainPageModelDelegate {
    
    var ready = false
    var onReady: (()->Void)? {
        didSet {
            if ready && onReady != nil {
                callOnready()
            }
        }
    }
    
    // MARK: - Nav bar elements
    
    @IBOutlet weak var updateButton: UIBarButtonItem! {
        didSet{
            updateButton.accessibilityLabel = String.localizedString("update_filters_voiceover")
            let icon = UIImage(named: "refresh-icon")
            let iconSize = CGRect(origin: .zero, size: CGSize(width: 24.0, height: 24.0))
            let tintColor = UIColor(hexString: "#67b279")
            iconButton = UIButton(frame: iconSize)
            iconButton?.setBackgroundImage(icon, for: .normal)
            iconButton?.tintColor = tintColor
            updateButton.customView = iconButton
            iconButton?.addTarget(self, action: #selector(updateFilters(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Protection status elements
    
    @IBOutlet weak var safariProtectionButton: RoundRectButton!
    @IBOutlet weak var systemProtectionButton: RoundRectButton!
    
    @IBOutlet weak var protectionStateLabel: ThemableLabel!
    @IBOutlet weak var protectionStatusLabel: ThemableLabel!
    
    
    // MARK: - Complex protection switch
    
    @IBOutlet weak var complexProtectionView: UIView!
    @IBOutlet weak var complexProtectionSwitch: ComplexProtectionSwitch!
    
    
    // MARK: - Statistics elements
    
    @IBOutlet weak var changeStatisticsDatesButton: UIButton!
    @IBOutlet weak var chartView: ChartView!
    
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
    
    
    // MARK: - Content blockers view
    
    @IBOutlet weak var contentBlockerViewIphone: UIView!
    @IBOutlet weak var contentBlockerViewIpad: UIView!

    
    // MARK: - Themable labels
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    // MARK: - Constraints
    @IBOutlet weak var contentBlockerViewConstraint: NSLayoutConstraint!
    
    // MARK: - Constraints to change for iphone SE - like devices
    
    @IBOutlet weak var safariIconHeight: NSLayoutConstraint!
    @IBOutlet weak var safariIconWidth: NSLayoutConstraint!
    
    @IBOutlet weak var systemIconWidth: NSLayoutConstraint!
    @IBOutlet weak var systemIconHeight: NSLayoutConstraint!
    
    @IBOutlet weak var safariIconCenterSpace: NSLayoutConstraint!
    @IBOutlet weak var systemIconCenterSpace: NSLayoutConstraint!
    
    @IBOutlet weak var complexSwitchWidth: NSLayoutConstraint!
    @IBOutlet weak var complexSwitchHeight: NSLayoutConstraint!
    @IBOutlet weak var fromButtonsToTopHeight: NSLayoutConstraint!
    @IBOutlet weak var fixItIphoneButton: UIButton!
    @IBOutlet weak var fixItiPadButton: UIButton!
    
    var stateFromWidget: Bool?
    
    // MARK: - Variables
    
    private var iconButton: UIButton? = nil
    private let getProSegueId = "getProSegue"
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
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
    
    
    // MARK: - Services
    
    private lazy var configuration: ConfigurationService = { ServiceLocator.shared.getService()! }()
    private lazy var antibanner: AESAntibannerProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var resources: AESharedResourcesProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var complexProtection: ComplexProtectionServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var dnsFiltersService: DnsFiltersServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    // MARK: - View models
    private let mainPageModel: MainPageModelProtocol
    private lazy var chartModel: ChartViewModelProtocol = { ServiceLocator.shared.getService()! }()
    
    
    // MARK: - Observers
    
    private var themeNotificationToken: NotificationToken?
    private var appWillEnterForeground: NotificationToken?
    private var observations: [NSKeyValueObservation] = []
    private var vpnConfigurationObserver: NotificationToken!
    
    // MARK: - View Controller life cycle
    
    required init?(coder: NSCoder) {
        mainPageModel = MainPageModel(antibanner: ServiceLocator.shared.getService()!)
        super.init(coder: coder)
        
        mainPageModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartModel.chartView = chartView
        
        addObservers()
        setUIForRequestType(true)
        setupVoiceOverLabels()
    
        chartModel.chartPointsChangedDelegates.append(self)
        complexProtectionSwitch.delegate = self
        
        dateTypeChanged(dateType: resources.chartDateType)
        
        contentBlockersGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleContentBlockersView(_:)))
        if let recognizer = contentBlockersGestureRecognizer {
            contentBlockerViewIpad.addGestureRecognizer(recognizer)
        }
        
        configuration.checkContentBlockerEnabled()
        
        if let stateFromWidget = self.stateFromWidget {
            complexProtection.switchComplexProtection(state: stateFromWidget, for: self) { (_, _) in
            }
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateTheme()
        observeProStatus()
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
        if !configuration.someContentBlockersEnabled && !contentBlockerHelperWasShown {
            showContentBlockersHelper()
            contentBlockerHelperWasShown = true
        } else {
            ready = true
            callOnready()
        }
    }

    // MARK: - Actions

    
    // MARK: - Nav Bar Actions
    
    @objc private func updateFilters(_ sender: Any) {
        
        dnsUpdateEnded = false
        
        dnsFiltersService.updateFilters(networking: ACNNetworking()) {
            DispatchQueue.main.async {  [weak self] in
                
                self?.dnsUpdateEnded = true
                
                self?.safariUpdateEnded = false
                self?.mainPageModel.updateFilters()
            }
        }
    }
    
    // MARK: - Protection Status Actions
    
    @IBAction func changeSafariProtectionState(_ sender: RoundRectButton) {
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
    
    @IBAction func changeSystemProtectionState(_ sender: RoundRectButton) {
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
    
    // MARK: - Complex protection switch action
    
    @IBAction func complexProtectionState(_ sender: ComplexProtectionSwitch) {
        let enabled = sender.isOn
        applyingChangesStarted()
        complexProtection.switchComplexProtection(state: enabled, for: self) { [weak self] (safariError, systemError) in
            DispatchQueue.main.async {
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
    
    // MARK: - ChartPointsChangedDelegate method
    
    func numberOfRequestsChanged(requestsCount: Int, encryptedCount: Int, averageElapsed: Double) {
        updateTextForButtons(requestsCount: requestsCount, encryptedCount: encryptedCount, averageElapsed: averageElapsed)
    }
    
    // MARK: - DateTypeChangedProtocol method
    
    func dateTypeChanged(dateType: ChartDateType) {
        resources.chartDateType = dateType
        changeStatisticsDatesButton.setTitle(dateType.getDateTypeString(), for: .normal)
        chartModel.chartDateType = dateType
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
        onBoardingIsInProcess = false
        ready = true
        callOnready()
    }
    
    // MARK: - GetProControllerDelegate delegate
    
    func getProControllerClosed() {
        onboardingDidFinish()
    }
    
    // MARK: - view model delegate methods
    
    func updateStarted() {
        protectionStatusLabel.text = String.localizedString("update_filter_start_message")
        safariUpdateEnded = false
        updateStartedInternal()
    }
    
    func updateFinished(message: String) {
        protectionStatusLabel.text = message
        safariUpdateEnded = true
        endUpdate()
    }
    
    func updateFailed(error: String) {
        protectionStatusLabel.text = error
        safariUpdateEnded = true
        endUpdate()
    }
    
    // MARK: - Private methods
    
    /**
     Updates theme when notification is observed
     */
    private func updateTheme(){
        navigationController?.view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        
        chartView.updateTheme()
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        getProView.backgroundColor = theme.backgroundColor
        
        contentBlockerViewIphone.backgroundColor = theme.notificationWindowColor
    }
    
    /**
     Presents ChartDateTypeController
     */
    private func showChartDateTypeController(){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ChartDateTypeController") as? ChartDateTypeController else { return }
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
            
    /**
    Changes number of requests for all buttons
    */
    private func updateTextForButtons(requestsCount: Int, encryptedCount: Int, averageElapsed: Double){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            
            let requestsNumberDefaults = self.resources.tempRequestsCount
            let requestsNumber = requestsCount + requestsNumberDefaults
            
            let encryptedNumberDefaults = self.resources.tempEncryptedRequestsCount
            let encryptedNumber = encryptedCount + encryptedNumberDefaults
            
            self.requestsNumberLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: requestsNumber))
            self.encryptedNumberLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: encryptedNumber))
            self.elapsedNumberLabel.text = String.simpleSecondsFormatter(NSNumber(floatLiteral: averageElapsed))
        }
    }
    
    /**
     Called when "requests" button tapped
     */
    private func chooseRequest(){
        if chartModel.chartRequestType == .requests {
            let title = String.localizedString("requests_info_alert_title")
            let message = String.localizedString("requests_info_alert_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
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
        chartModel.chartRequestType = .requests
        
        requestsNumberLabel.alpha = 1.0
        encryptedNumberLabel.alpha = 0.5
        
        requestsTextLabel.alpha = 1.0
        encryptedTextLabel.alpha = 0.5
    }
    
    /**
    Called when "blocked" button tapped
    */
    private func chooseEncrypted(){
        if chartModel.chartRequestType == .encrypted {
            let title = String.localizedString("encrypted_info_alert_title")
            let message = String.localizedString("encrypted_info_alert_message")
            ACSSystemUtils.showSimpleAlert(for: self, withTitle: title, message: message)
        } else {
            chartView.activeChart = .encrypted
            chartModel.chartRequestType = .encrypted
            
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
     Adds observers to controller
     */
    private func addObservers(){

        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        appWillEnterForeground = NotificationCenter.default.observe(name: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            self?.updateProtectionStates()
            self?.updateProtectionStatusText()
        })
        
        let proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            guard let self = self else { return }
            self.observeProStatus()
        }
        
        let contenBlockerObservation = configuration.observe(\.contentBlockerEnabled) {[weak self] (_, _) in
            guard let self = self else { return }
            self.observeContentBlockersState()
        }
        
        vpnConfigurationObserver = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: nil) { [weak self] (note) in
            DispatchQueue.main.async {
                self?.updateProtectionStates()
                self?.updateProtectionStatusText()
            }
        }

        observations.append(proObservation)
        observations.append(contenBlockerObservation)
    }
    
    /**
     Starts to rotate refresh button
     */
    private func updateStartedInternal(){
        updateInProcess = true
        iconButton?.isUserInteractionEnabled = false
        updateButton.customView?.rotateImage(isNedeed: true)
    }
    
    /**
     Stops to rotate refresh button
     */
    private func updateEndedInternal(){
        DispatchQueue.main.async {[weak self] in
            self?.updateInProcess = false
            self?.iconButton?.isUserInteractionEnabled = true
            self?.updateButton.customView?.rotateImage(isNedeed: false)
            self?.updateProtectionStates()
            
            // return statur title few secconds latter
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.updateProtectionStatusText()
            }
        }
    }
    
    /**
     Starts indicating that changes are applied
     */
    private func applyingChangesStarted(){
        protectionStatusLabel.text = ACLocalizedString("applying_changes", nil)
    }
    
    /**
    Stops indicating that changes are applied
    */
    private func applyingChangesEnded(){
        updateProtectionStatusText()
        updateProtectionStates()
    }
    
    /**
     States views by pro status
     */
    private func observeProStatus(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            
            self.getProView.isHidden = self.proStatus
            self.statisticsStackView.isHidden = !self.proStatus
            self.changeStatisticsDatesButton.isHidden = !self.proStatus
            self.systemProtectionButton.buttonIsOn = self.complexProtection.systemProtectionEnabled
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
            complexText = ACLocalizedString("complex_enabled", nil)
        case (_, _, false):
            complexText = ACLocalizedString("complex_disabled", nil)
        case (true, _, _):
            complexText = ACLocalizedString("safari_enabled", nil)
        case (_, true, _):
            complexText = ACLocalizedString("system_enabled", nil)
        case (false, false, true):
            // incorrect state
            complexText = ""
        }
        
        protectionStatusLabel.text = complexText
        complexProtectionSwitch.accessibilityLabel = complexText
    }
    
    private func updateProtectionStates(){
            
        let enabledText = complexProtection.complexProtectionEnabled ? ACLocalizedString("protection_enabled", nil) : ACLocalizedString("protection_disabled", nil)
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
        if configuration.allContentBlockersEnabled {
            hideContentBlockersInfo()
        } else {
            showContentBlockersInfo()
        }
        
        let onboardingShown = resources.sharedDefaults().bool(forKey: OnboardingWasShown)
        
        if !onBoardingIsInProcess {
            if !onboardingShown && !configuration.someContentBlockersEnabled && !configuration.proStatus{
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
    private func showContentBlockersInfo(){
        DispatchQueue.main.async {[weak self] in
            self?.showIphoneContentBlockersInfo()
            self?.showIpadContentBlockersInfo()
        }
    }
    
    /**
     Hides content blockers info
     */
    private func hideContentBlockersInfo(){
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
    
    private func showContentBlockersHelper(){
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
    
    private func callOnready() {
        onReady?()
        onReady = nil
    }

    /**
     As iPhone SE screen is very small we need different constraints for it
     */
    private func setupConstraintsForIphoneSe(){
        fromButtonsToTopHeight.constant = 10.0
        
        fixItIphoneButton.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .bold)
        manDialogText.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
        
        safariIconHeight.constant = 24.0
        safariIconWidth.constant = 24.0
        
        systemIconWidth.constant = 24.0
        systemIconHeight.constant = 24.0
        
        safariIconCenterSpace.constant = -20.0
        systemIconCenterSpace.constant = 20.0
        
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
}
