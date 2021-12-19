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
import SafariAdGuardSDK

/// AdvancedProtectionController - Responsible for representation advanced settings for Safari Web Extension
final class AdvancedProtectionController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var onOffLabel: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    @IBOutlet weak var advancedProtectionView: OnboardingAdvancedProtectionView!

    @IBOutlet weak var purchaseButton: RoundRectButton!
    @IBOutlet weak var firstDescriptionLabel: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var firstDescriptionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var advancedProtectionViewTopConstraint: NSLayoutConstraint!

    @IBOutlet var themableLabels: [ThemableLabel]!

    // MARK: - URL redirect value

    /// If `enableAdvancedProtection` contains value then advanced protection state will be changed in `viewDidLoad`.
    /// After applying the new state, this variable will be set to nil.
    var enableAdvancedProtection: Bool?

    // MARK: - Private properties

    private let showLicenseSegue = "ShowLicenseSegueId"
    private var advancedProtectionViewHeightConstraintConst = 0.0
    private var advancedProtectionIsHidden: Bool = false {
        didSet {
            if advancedProtectionIsHidden {
                hideAdvancedProtectionView()
            } else {
                showAdvancedProtectionView()
            }
        }
    }

    private var proStatusObserver: NotificationToken?

    // MARK: - Services

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configurationService: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        advancedProtectionView.labelString = String.localizedString("onboarding_fours_step_text")

        uiSwitch.isOn = configurationService.isAdvancedProtectionEnabled
        onOffLabel.text = uiSwitch.isOn.localizedStateDescription

        purchaseButton.applyStandardGreenStyle()
        setupBackButton()
        updateTheme()

        configureScreenContent()

        proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            self?.configureScreenContent()
        }

        enableAdvancedProtectionIfNeeded()
        setupNavigationBarButtonItem()
    }

    // MARK: - Actions

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn && !configurationService.proStatus {
            performSegue(withIdentifier: self.showLicenseSegue, sender: self)
            sender.setOn(false, animated: false)
            return
        }

        let newAdvancedProtection = sender.isOn
        configurationService.isAdvancedProtectionEnabled = newAdvancedProtection
        onOffLabel.text = sender.isOn.localizedStateDescription
        safariProtection.update(advancedProtectionEnabled: newAdvancedProtection, onCbReloaded: nil)
    }

    // MARK: - Private methods

    private func hideAdvancedProtectionView() {
        advancedProtectionView.isHidden = true

        firstDescriptionLabelTopConstraint.isActive = false
        firstDescriptionLabelTopConstraint = firstDescriptionLabel.topAnchor.constraint(equalTo: uiSwitch.bottomAnchor, constant: isIpadTrait ? 96.0 : 24.0)
        firstDescriptionLabelTopConstraint.isActive = true

        advancedProtectionViewTopConstraint.constant = 0
    }

    private func showAdvancedProtectionView() {
        advancedProtectionView.isHidden = false
        firstDescriptionLabelTopConstraint.isActive = false
        firstDescriptionLabelTopConstraint = firstDescriptionLabel.topAnchor.constraint(equalTo: advancedProtectionView.bottomAnchor, constant: isIpadTrait ? 48.0 : 36.0)
        firstDescriptionLabelTopConstraint.isActive = true
        advancedProtectionViewTopConstraint.constant = isIpadTrait ? 96.0 : 24.0
    }

    private func configureScreenContent() {
        purchaseButton.isHidden = configurationService.proStatus
        let hideView = resources.safariWebExtensionIsOn && resources.advancedProtectionPermissionsGranted
        advancedProtectionIsHidden =  hideView || !configurationService.proStatus
    }

    private func enableAdvancedProtectionIfNeeded() {
        guard let state = enableAdvancedProtection else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.uiSwitch.setOn(state, animated: true)
            self.switchValueChanged(self.uiSwitch)
            self.enableAdvancedProtection = nil
        }
    }

    private func setupNavigationBarButtonItem() {
        guard let faqImage = UIImage(named: "faq") else { return }
        let barButton = UIBarButtonItem(image: faqImage, style: .done, target: self, action: #selector(onRightBarButtonItemTapped(_:)))
        navigationItem.rightBarButtonItem = barButton
    }

    @objc final private func onRightBarButtonItemTapped(_ sender: UIBarButtonItem) {
        let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
        UIApplication.shared.openAdguardUrl(action: "web_extension_more", from: "advanced_protection_screen", buildVersion: productInfo.buildVersion())
    }
}

extension AdvancedProtectionController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        contentView.backgroundColor = themeService.backgroundColor
        advancedProtectionView.updateTheme()
        themeService.setupLabels(themableLabels)
        themeService.setupSwitch(uiSwitch)
        themeService.setupNavigationBar(navigationController?.navigationBar)
    }
}
