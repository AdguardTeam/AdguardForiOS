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

/// This screen is needed to provide a model for `ActionExtensionTableController`
/// If any error is occured it displays it
final class ActionExtensionLoaderViewController: UIViewController {

    // MARK: - UI Elements

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private variables

    private var modelToPass: ActionExtensionTableController.Model?
    private let segueId = "showActionExtensionSegueId"

    private let themeService = ServicesInitializer.shared.themeService
    private let configuration = ServicesInitializer.shared.configuration

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        configuration.systemAppearenceIsDark = systemStyleIsDark
        updateTheme()

        navigationController?.navigationBar.shadowImage = UIImage()
        title = Bundle.main.applicationName

        let contextProvider = ContextProvider()
        contextProvider.process(context: extensionContext) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let context):
                let isSafariProtectionEnabled = self.isSafariProtectionEnabled(for: context.domain)
                self.modelToPass = ActionExtensionTableController.Model(context: context, isSafariProtectionEnabled: isSafariProtectionEnabled)
                self.performSegue(withIdentifier: self.segueId, sender: self)
            case .failure(let error):
                self.receivedError(error: error)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ActionExtensionTableController, let model = modelToPass else {
            return
        }
        destinationVC.model = model
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOSApplicationExtension 13.0, *) {
            guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
                return
            }
            configuration.systemAppearenceIsDark = systemStyleIsDark
            updateTheme()
        }
    }

    // MARK: - Close action

    @IBAction func closeAction(_ sender: UIButton) {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }

    // MARK: - Private methods

    private func isSafariProtectionEnabled(for domain: String) -> Bool {
        let resources = ServicesInitializer.shared.resources
        let safariProtection = ServicesInitializer.shared.safariProtection

        let isAllowlistInverted = resources.invertedWhitelist
        let rules = safariProtection.allRules(for: isAllowlistInverted ? .invertedAllowlist : .allowlist)
        let enabledRules = rules.compactMap { $0.isEnabled ? $0.ruleText : nil }
        let isDomainInRules = enabledRules.contains(domain)
        return isAllowlistInverted ? isDomainInRules : !isDomainInRules
    }

    private func receivedError(error: ContextProvider.ContextError) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        messageLabel.isHidden = false
        messageLabel.text = error.localizedErrorDescription
    }
}

// MARK: - ContextProvider.ContextError + localizedErrorDescription

fileprivate extension ContextProvider.ContextError {
    var localizedErrorDescription: String {
        switch self {
        case .typeInconformance, .errorLoadingItem: return String.localizedString("support_error_safari_extension")
        case .obtainDomain: return String.localizedString("hostname_obtaining_error")
        }
    }
}

// MARK: - ActionExtensionLoaderViewController + Theme update

extension ActionExtensionLoaderViewController {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupNavigationBar(navigationController?.navigationBar)
        activityIndicator.style = themeService.indicatorStyle
    }
}
