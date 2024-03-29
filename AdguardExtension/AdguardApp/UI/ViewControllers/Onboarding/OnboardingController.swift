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

import Foundation

protocol OnboardingControllerDelegate {
    func onboardingDidFinish()
}

final class OnboardingController: UIViewController {

    var delegate: OnboardingControllerDelegate?
    var needsShowingPremium: Bool?

    // MARK: - Services

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!

    private var contenBlockerObserver: NotificationToken?

    private let showLicenseSegue = "ShowLicenseSegue"

    // MARK: - Outlets

    @IBOutlet weak var settingsLabel: ThemableLabel!
    @IBOutlet weak var safariLabel: ThemableLabel!
    @IBOutlet weak var switchLabel: ThemableLabel!
    @IBOutlet weak var onboardingContentView: OnboardingContentView!
    @IBOutlet weak var onboardingContentViewTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var watchManualButtonIpad: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        contenBlockerObserver = NotificationCenter.default.observe(name: .contentBlockersStateChanged, object: nil, queue: .main, using: { [weak self] _ in
            self?.observeContentBlockersState()
        })

        watchManualButtonIpad.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.lightGreen1)

        if #available(iOS 15.0, *) {
            onboardingContentViewTopConstraint.constant = 48.0
            onboardingContentView.onboardingType = .withAdvancedProtection
        } else {
            onboardingContentViewTopConstraint.constant = 30.0
            onboardingContentView.onboardingType = .withoutAdvancedProtection
        }
        self.updateTheme()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let licenseController = segue.destination as? LicensePageViewController {
            navigationController?.setNavigationBarHidden(false, animated: true)
            licenseController.showExitButton = true
            if let licenseControllerDelegate = delegate as? LicensePageViewControllerDelegate {
                licenseController.delegate = licenseControllerDelegate
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return theme.statusbarStyle()
    }

    // MARK: - Actions

    @IBAction func closeAction(_ sender: Any) {
        // We mustn't show License screen for japannese in onboarding
        let isJapanesse = Locale.current.languageCode == "ja"

        if needsShowingPremium == true && !configuration.proStatus && !isJapanesse{
            performSegue(withIdentifier: self.showLicenseSegue, sender: self)
        } else {
            dismiss(animated: true) { [weak self] in
                self?.delegate?.onboardingDidFinish()
            }
        }
    }

    @IBAction func videoAction(_ sender: UIButton) {
        showVideoTutorial()
    }

    // MARK: - Private methods

    private func setupLabels() {
        DispatchQueue.asyncSafeMain { [weak self] in
            guard let self = self else { return }

            let settingsLabelText: String
            let safariLabelText: String
            let switchLabelText: String
            switch self.onboardingContentView.onboardingType {
            case .withAdvancedProtection:
                settingsLabelText = String.localizedString("advanced_protection_onboarding_first_step_text")
                safariLabelText = String.localizedString("advanced_protection_onboarding_second_step_text")
                switchLabelText = String.localizedString("advanced_protection_onboarding_third_step_text")
            case .withoutAdvancedProtection:
                settingsLabelText = String.localizedString("onboarding_first_step_text")
                safariLabelText = String.localizedString("onboarding_second_step_text")
                switchLabelText = String.localizedString("onboarding_third_step_text")
            }

            let fontSize: CGFloat = self.isIpadTrait ? 24.0 : 16.0

            self.settingsLabel.setAttributedTitle(settingsLabelText, fontSize: fontSize, color: self.theme.grayTextColor)
            self.safariLabel.setAttributedTitle(safariLabelText, fontSize: fontSize, color: self.theme.grayTextColor)
            self.switchLabel.setAttributedTitle(switchLabelText, fontSize: fontSize, color: self.theme.grayTextColor)
        }
    }

    private func observeContentBlockersState(){
        // We mustn't show License screen for japannese in onboarding
        let isJapanesse = Locale.current.languageCode == "ja"

        if needsShowingPremium == true && configuration.someContentBlockersEnabled && !configuration.proStatus {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                if isJapanesse {
                    self.dismiss(animated: true) {
                        self.delegate?.onboardingDidFinish()
                    }
                } else {
                    self.performSegue(withIdentifier: self.showLicenseSegue, sender: self)
                }
            }
        }
    }
}

extension OnboardingController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        setupLabels()
        onboardingContentView.updateTheme()
    }
}
