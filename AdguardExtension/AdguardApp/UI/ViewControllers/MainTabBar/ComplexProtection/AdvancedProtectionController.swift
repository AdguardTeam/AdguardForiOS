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
        onOffLabel.text = uiSwitch.isOn ? String.localizedString("on_state") : String.localizedString("off_state")

        purchaseButton.applyStandardGreenStyle()
        setupBackButton()
        updateTheme()

        configureScreenContent()

        proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            self?.configureScreenContent()
        }
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
        onOffLabel.text = sender.isOn ? String.localizedString("on_state") : String.localizedString("off_state")
        safariProtection.update(advancedProtectionEnabled: newAdvancedProtection, onCbReloaded: nil)
    }

    // MARK: - Private methods

    private func hideAdvancedProtectionView() {
        advancedProtectionView.isHidden = true

        firstDescriptionLabelTopConstraint.isActive = false
        firstDescriptionLabelTopConstraint = firstDescriptionLabel.topAnchor.constraint(equalTo: uiSwitch.bottomAnchor, constant: 24.0)
        firstDescriptionLabelTopConstraint.isActive = true

        advancedProtectionViewTopConstraint.constant = 0
    }

    private func showAdvancedProtectionView() {
        advancedProtectionView.isHidden = false
        firstDescriptionLabelTopConstraint.isActive = false
        firstDescriptionLabelTopConstraint = firstDescriptionLabel.topAnchor.constraint(equalTo: advancedProtectionView.bottomAnchor, constant: 24.0)
        firstDescriptionLabelTopConstraint.isActive = true
        advancedProtectionViewTopConstraint.constant = isIpadTrait ? 40.0 : 27.0
    }

    private func configureScreenContent() {
        purchaseButton.isHidden = configurationService.proStatus
        let hideView = resources.safariWebExtensionIsOn && resources.advancedProtectionPermissionsGranted
        advancedProtectionIsHidden =  hideView || !configurationService.proStatus
    }
}

extension AdvancedProtectionController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        contentView.backgroundColor = themeService.backgroundColor
        advancedProtectionView.updateTheme()
        themeService.setupLabels(themableLabels)
        themeService.setupSwitch(uiSwitch)
    }
}
