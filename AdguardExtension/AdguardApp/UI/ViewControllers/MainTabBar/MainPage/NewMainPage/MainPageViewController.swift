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

final class MainPageViewController: PullableContainerController {
    
    // MARK: - UI Elements
    
    private let refreshIconButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "refresh-icon")
        let iconSize = CGRect(origin: .zero, size: CGSize(width: 24.0, height: 24.0))
        let tintColor = UIColor.AdGuardColor.lightGreen1
        button.frame = iconSize
        button.setBackgroundImage(icon, for: .normal)
        button.tintColor = tintColor
        button.addTarget(self, action: #selector(updateFilters), for: .touchUpInside)
        return button
    }()
    @IBOutlet weak var updateFiltersButton: UIBarButtonItem! {
        didSet{
            updateFiltersButton.accessibilityLabel = String.localizedString("update_filters_voiceover")
            updateFiltersButton.customView = refreshIconButton
        }
    }
    @IBOutlet weak var chooseStatisticsDateTypeButton: UIButton!
    @IBOutlet weak var complexProtectionSwitch: ComplexProtectionSwitch! {
        didSet {
            complexProtectionSwitch.delegate = self
        }
    }
    @IBOutlet weak var protectionStateLabel: ThemableLabel!
    @IBOutlet weak var protectionStatusLabel: ThemableLabel!
    
    /* Icons stack view */
    @IBOutlet weak var iconsStackView: UIStackView!
    @IBOutlet weak var iconsStackViewWidthConstraint: NSLayoutConstraint!
    private var stackViewWidth: CGFloat {
        let iconsCount = CGFloat(iconsStackView.arrangedSubviews.count)
        let itemSize: CGFloat = isIpadTrait ? 40.0 : 32.0
        let spacing: CGFloat = 24.0
        return itemSize * iconsCount + spacing * (iconsCount - 1)
    }
    
    /* Protection buttons */
    private lazy var safariProtectionButton: RoundRectButton = {
        let button = RoundRectButton()
        button.addTarget(self, action: #selector(safariProtectionTapped), for: .touchUpInside)
        button.onTintColor = UIColor.AdGuardColor.lightGreen1
        button.offTintColor = UIColor.AdGuardColor.lightGray4
        let safariImage = UIImage(named: "safari")
        button.setBackgroundImage(safariImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var systemProtectionButton: RoundRectButton = {
        let button = RoundRectButton()
        button.addTarget(self, action: #selector(systemProtectionTapped), for: .touchUpInside)
        button.onTintColor = UIColor.AdGuardColor.lightGreen1
        button.offTintColor = UIColor.AdGuardColor.lightGray4
        let safariImage = UIImage(named: "ic_adguard")
        button.setBackgroundImage(safariImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var vpnProtectionButton: RoundRectButton = {
        let button = RoundRectButton()
        button.addTarget(self, action: #selector(vpnProtectionTapped), for: .touchUpInside)
        button.onTintColor = UIColor.AdGuardColor.lightGreen1
        button.offTintColor = UIColor.AdGuardColor.lightGray4
        let safariImage = UIImage(named: "vpn_logo")
        button.setBackgroundImage(safariImage, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var contentBlockersView: ContentBlockersNoteView = {
        let view = ContentBlockersNoteView()
        view.onViewTapped = { [weak self] in
            self?.showContentBlockersHelperController()
        }
        return view
    }()
    
    // MARK: - Public properties
    
    /*
     Sometimes we need to show onboarding and maybe other controllers in the future
     onReady closure will be called when controller presented all the controllers
     */
    var onReady: (() -> Void)?
    
    /*
     When complex protection is switched from widget this variable will become non optional
     We should process this variable when view is loaded
     */
    var complexProtectionStateFromWidget: Bool?
    
    // MARK: - Private properties
    
    /* Services */
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    
    /* Models */
    private let datePickerModel: StatisticsDatePickerModelProtocol
    private let statisticsModel: StatisticsModelProtocol = ServiceLocator.shared.getService()!
    private let contentBlockersModel: ContentBlockersStateModelProtocol
    private let protectionModel: MainPageProtectionModelProtocol

    /* Helper variables */
    private let getProSegueId = "getProSegue"
    
    // MARK: - ViewController lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle { theme.statusbarStyle() }
    
    required init?(coder: NSCoder) {
        datePickerModel = StatisticsDatePickerModel(resources: resources, configuration: configuration)
        contentBlockersModel = ContentBlockersStateModel(configuration: configuration)
        protectionModel = MainPageProtectionModel(resources: resources, complexProtection: complexProtection, nativeProviders: nativeProviders)
        super.init(coder: coder)
        
        (datePickerModel as! StatisticsDatePickerModel).delegate = self
        (contentBlockersModel as! ContentBlockersStateModel).delegate = self
        (protectionModel as! MainPageProtectionModel).delegate = self
    }
    
    override func viewDidLoad() {
        let mainPageExtraInfoVC = storyboard?.instantiateViewController(withIdentifier: "MainPageExtraInfoController") as! MainPageExtraInfoController
        self.contentController = mainPageExtraInfoVC
        super.viewDidLoad()
        
        statisticsModel.observers.append(self)
        
        /* Initial UI setup */
        setStatisticsDateButtonTitle()
        chooseStatisticsDateTypeButton.isHidden = !datePickerModel.shouldShowDateTypePicker
        contentBlockersStateChanged()
        protectionStateChanged()
        processProtectionButtons()
        
        if resources.onboardingWasShown {
            onReady?()
        } else {
            showOnboarding()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        protectionModel.checkProtectionsState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nav = navigationController as? MainNavigationController {
            nav.addGestureRecognizer()
        }
    }
    
    // MARK: - Actions
    
    @objc private func updateFilters() {
        
    }
    
    @objc private func safariProtectionTapped() {
        do {
            try protectionModel.turnSafariProtection(to: !safariProtectionButton.buttonIsOn)
            safariProtectionButton.buttonIsOn = !safariProtectionButton.buttonIsOn
        } catch {
            DDLogDebug("(MainPageViewController) - error: \(error.localizedDescription)")
        }
    }
    
    @objc private func systemProtectionTapped() {
        if !configuration.proStatus {
            performSegue(withIdentifier: getProSegueId, sender: self)
            return
        }
        do {
            try protectionModel.turnSystemProtection(to: !systemProtectionButton.buttonIsOn, for: self)
        } catch {
            DDLogDebug("(MainPageViewController) - error: \(error.localizedDescription)")
        }
    }
    
    @objc private func vpnProtectionTapped() {
        if UIApplication.adGuardVpnIsInstalled {
            UIApplication.openAdGuardVpnAppIfInstalled()
        } else {
            presentUpsellScreen()
        }
    }
    
    @IBAction func complexProtectionSwitched(_ sender: ComplexProtectionSwitch) {
        do {
            try protectionModel.turnComplexPtotection(to: complexProtectionSwitch.isOn, for: self)
        } catch {
            DDLogDebug("(MainPageViewController) - error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func chooseStatisticsDateTapped(_ sender: UIButton) {
        presentChooseStatisticsDateAlert { [weak self] dateType in
            self?.statisticsModel.mainPageDateType = dateType
        }
    }
    
    // MARK: - Private methods
    
    private func setStatisticsDateButtonTitle() {
        let statisticsButtonTitle = statisticsModel.mainPageDateType.getDateTypeString()
        chooseStatisticsDateTypeButton.setTitle(statisticsButtonTitle, for: .normal)
    }
    
    private func processProtectionButtons() {
        /* Safari icon */
        let safariIconIsInStack = iconsStackView.arrangedSubviews.contains(safariProtectionButton)
        if protectionModel.visibleProtectionButtons.safariProtectionIsVisible {
            if !safariIconIsInStack {
                iconsStackView.addArrangedSubview(safariProtectionButton)
            }
        } else {
            if safariIconIsInStack {
                iconsStackView.removeArrangedSubview(safariProtectionButton)
            }
        }
        
        /* DNS icon */
        let dnsIconIsInStack = iconsStackView.arrangedSubviews.contains(systemProtectionButton)
        if protectionModel.visibleProtectionButtons.systemProtectionIsVisible {
            if !dnsIconIsInStack {
                iconsStackView.addArrangedSubview(systemProtectionButton)
            }
        } else {
            if dnsIconIsInStack {
                iconsStackView.removeArrangedSubview(systemProtectionButton)
            }
        }
        
        /* VPN icon */
        let vpnIconIsInStack = iconsStackView.arrangedSubviews.contains(vpnProtectionButton)
        if protectionModel.visibleProtectionButtons.vpnProtectionIsVisible {
            if !vpnIconIsInStack {
                iconsStackView.addArrangedSubview(vpnProtectionButton)
            }
        } else {
            if vpnIconIsInStack {
                iconsStackView.removeArrangedSubview(vpnProtectionButton)
            }
        }
        
        iconsStackViewWidthConstraint.constant = stackViewWidth
    }
}

// MARK: - MainPageViewController + MainPageProtectionModelDelegate

extension MainPageViewController: MainPageProtectionModelDelegate {
    func protectionStateChanged() {
        safariProtectionButton.buttonIsOn = protectionModel.protection.safariProtectionEnabled
        systemProtectionButton.buttonIsOn = protectionModel.protection.systemProtectionEnabled
        vpnProtectionButton.buttonIsOn = protectionModel.protection.vpnProtectionEnabled
        complexProtectionSwitch.setOn(on: protectionModel.protection.complexProtectionEnabled)
        protectionStateLabel.text = protectionModel.protection.protectionState
        DDLogError("🦬 saf=\(protectionModel.protection.safariProtectionEnabled); sys=\(protectionModel.protection.systemProtectionEnabled); com=\(protectionModel.protection.complexProtectionEnabled)")
        if !protectionModel.protectionsAreUpdating {
            protectionStatusLabel.text = protectionModel.protection.protectionStatus
        }
    }
    
    func safariProtectionStateUpdateStarted() {
        protectionsUpdateStarted()
    }
    
    func safariProtectionStateUpdateFinished(withError error: Error?) {
        protectionsUpdateFinished()
        if let error = error {
            presentSimpleAlert(title: nil, message: error.localizedDescription)
        }
    }
    
    func systemProtectionStateUpdateStarted() {
        protectionsUpdateStarted()
    }
    
    func systemProtectionStateUpdateFinished(withError error: Error?) {
        protectionsUpdateFinished()
        if let error = error {
            presentSimpleAlert(title: nil, message: error.localizedDescription)
        }
    }
    
    func complexProtectionStateUpdateStarted() {
        protectionsUpdateStarted()
    }
    
    func complexProtectionStateUpdateFinished(_ safariError: Error?, _ systemError: Error?) {
        if let safariError = safariError {
            presentSimpleAlert(title: nil, message: safariError.localizedDescription)
        }
        
        if let systemError = systemError {
            presentSimpleAlert(title: nil, message: systemError.localizedDescription)
        }
        
        protectionsUpdateFinished()
    }
    
    private func protectionsUpdateStarted() {
        if !protectionModel.protectionsAreUpdating { return }
        protectionStatusLabel.text = String.localizedString("applying_changes")
    }
    
    private func protectionsUpdateFinished() {
        if protectionModel.protectionsAreUpdating { return }
        protectionStatusLabel.text = protectionModel.protection.protectionStatus
    }
}

// MARK: - MainPageViewController + StatisticsDatePickerModelDelegate

extension MainPageViewController: StatisticsDatePickerModelDelegate {
    func shouldShowDateTypePickerChanged() {
        chooseStatisticsDateTypeButton.isHidden = !datePickerModel.shouldShowDateTypePicker
    }
}

// MARK: - MainPageViewController + StatisticsModelObserver

extension MainPageViewController: StatisticsModelObserver {
    func statisticsChanged() {
        setStatisticsDateButtonTitle()
    }
    
    func mainPageDateTypeChanged() {
        setStatisticsDateButtonTitle()
    }
    
    func activityPageDateTypeChanged() {
        // Unimplemented
    }
}

// MARK: - MainPageViewController + ContentBlockersStateModelDelegate

extension MainPageViewController: ContentBlockersStateModelDelegate {
    func contentBlockersStateChanged() {
        if contentBlockersModel.shouldShowContentBlockersView {
            showContentBlockersView()
        } else {
            contentBlockersView.dismiss()
        }
    }
    
    private func showContentBlockersView() {
        contentBlockersView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(contentBlockersView, belowSubview: pullableView)
        
        contentBlockersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: isIpadTrait ? -182.0 : -116.0).isActive = true
        if isIpadTrait {
            contentBlockersView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            contentBlockersView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.5).isActive = true
        } else {
            contentBlockersView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
            contentBlockersView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        }
    }
}

// MARK: - MainPageViewController + UIGestureRecognizerDelegate

extension MainPageViewController {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer,
              let mainPageExtraInfoVC = contentController as? MainPageExtraInfoController,
              let collectionView = mainPageExtraInfoVC.collectionView else {
            return false
        }
        let direction = gesture.velocity(in: view).y

        if (isCompact == false && collectionView.contentOffset.y == 0 && direction > 0) || isCompact == true {
            collectionView.isScrollEnabled = false
        } else {
            collectionView.isScrollEnabled = true
        }
        return false
    }
}

// MARK: - MainPageViewController + Show controllers

fileprivate extension UIViewController {
    func showContentBlockersHelperController() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "OnboardingNavigationController") as? UINavigationController,
              let controller = storyboard.instantiateViewController(withIdentifier: "OnboardingController") as? OnboardingController else {
            return
        }
        navController.viewControllers = [controller]
        controller.delegate = self as? OnboardingControllerDelegate
        controller.needsShowingPremium = false
        present(navController, animated: true)
    }
    
    func showOnboarding() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let navController = storyboard.instantiateViewController(withIdentifier: "OnboardingNavigationController") as? UINavigationController,
              let controller = navController.viewControllers.first as? IntroductionOnboardingController
        else {
            return
        }
        controller.delegate = self as? OnboardingControllerDelegate
       
        present(navController, animated: true)
    }
}

// MARK: - MainPageViewController + ComplexSwitchDelegate

extension MainPageViewController: ComplexSwitchDelegate {
    func beginTracking() {
        if let nav = navigationController as? MainNavigationController {
            nav.removeGestureRecognizer()
        }
    }
}

// MARK: - MainPageViewController + OnboardingControllerDelegate

extension MainPageViewController: OnboardingControllerDelegate {
    func onboardingDidFinish() {
        resources.onboardingWasShown = true
        onReady?()
    }
}

// MARK: - MainPageViewController + GetProControllerDelegate

extension MainPageViewController: GetProControllerDelegate {
    func getProControllerClosed() {
        onboardingDidFinish()
    }
}

// MARK: - MainPageViewController + ThemableProtocol

extension MainPageViewController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupLabels([protectionStateLabel, protectionStatusLabel])
    }
}
