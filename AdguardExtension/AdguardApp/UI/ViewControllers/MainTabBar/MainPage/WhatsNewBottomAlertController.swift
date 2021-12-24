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

/// WhatsNewBottomAlertControllerDelegate - Delegate protocol
protocol WhatsNewBottomAlertControllerDelegate: AnyObject {
    func continueButtonForNonProTapped()
}

/// WhatsNewBottomAlertController - Responsible for representation new features available in new version of app
final class WhatsNewBottomAlertController: BottomAlertController {

    // MARK: - Outlets

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!

    // MARK: - Properties

    weak var delegate: WhatsNewBottomAlertControllerDelegate?

    // MARK: - Services

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!

    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.applyStandardGreenStyle()
        updateTheme()
    }

    // MARK: - Actions

    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if !configuration.proStatus {
            delegate?.continueButtonForNonProTapped()
            return
        }

        dismiss(animated: true) {
            let _ = AppDelegate.shared.presentAdvancedProtectionController(enableAdvancedProtection: nil)
        }
    }
}

extension WhatsNewBottomAlertController: ThemableProtocol {
    func updateTheme() {
        themeService.setupLabels(themableLabels)
        self.contentView.backgroundColor = themeService.popupBackgroundColor
    }
}
