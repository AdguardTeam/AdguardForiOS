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
import ContentBlockerConverter

class AboutViewController: UIViewController {
    @IBOutlet var loginButton: UIBarButtonItem!

    @IBOutlet weak var logoImageView: ThemableImageView!
    @IBOutlet weak var versionLabel: ThemableLabel!
    @IBOutlet weak var copyrightLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!


    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!

    /// Tracks whether the detailed (expanded) library versions are shown, so the
    /// correct font can be re-applied after a trait-collection change (e.g. the
    /// snapshot taken when the app is backgrounded).
    private var isFullVersionShown = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpVersionLabel()
        setUpCopyrightLabel()
        updateTheme()
        setupBackButton()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showFullVersion))
        versionLabel.isUserInteractionEnabled = true
        versionLabel.addGestureRecognizer(tapGesture)

        // Re-apply the version label font on a trait-collection change. The
        // app-switcher snapshot taken when the app is backgrounded toggles
        // userInterfaceStyle (not just the size class), which would otherwise
        // revert the label to its storyboard font; subscribe to both
        // userInterfaceStyle and the size-class traits (AG-55363).
        if #available(iOS 17.0, *) {
            registerForTraitChanges(
                [
                    UITraitUserInterfaceStyle.self,
                    UITraitVerticalSizeClass.self,
                    UITraitHorizontalSizeClass.self
                ],
                action: #selector(reapplyVersionLabelFont)
            )
        }
    }

    @objc
    private func reapplyVersionLabelFont() {
        setUpVersionLabel(showFullVersion: isFullVersionShown)
    }

    // traitCollectionDidChange is deprecated on iOS 17+, where the same work is
    // done by registerForTraitChanges above. Kept for the iOS 13 deployment
    // target and annotated to silence the deprecation warning.
    @available(iOS, deprecated: 17.0, message: "Handled by registerForTraitChanges in viewDidLoad")
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 17.0, *) { return }
        setUpVersionLabel(showFullVersion: isFullVersionShown)
    }

    // MARK: - Actions

    @IBAction func moreInfoTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "more_info", from: "about", buildVersion: productInfo.buildVersion())
    }

    @IBAction func readMoreTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "acknowledgments", from: "about", buildVersion: productInfo.buildVersion())
    }

    @IBAction func eulaTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "eula", from: "about", buildVersion: productInfo.buildVersion())
    }

    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "privacy", from: "about", buildVersion: productInfo.buildVersion())
    }



    @objc
    private func showFullVersion() {
        isFullVersionShown = true
        setUpVersionLabel(showFullVersion: true)
    }

    private func setUpVersionLabel(showFullVersion: Bool = false) {
        let version = productInfo.versionWithBuildNumber() ?? ""
        var versionFormat = String.localizedString("about_version_format")

        if showFullVersion {
            versionFormat += "\n\n"
            versionFormat += "SafariConverterLib v\(ContentBlockerConverterVersion.library)\n"
            versionFormat += "Scriptlets v\(ContentBlockerConverterVersion.scriptlets)\n"
            versionFormat += "ExtendedCss v\(ContentBlockerConverterVersion.extendedCSS)\n"
        }

        // Own the font in code for both states so trait changes do not revert it
        // to the storyboard value. See AG-55363.
        versionLabel.font = desiredVersionFont(showFullVersion: showFullVersion)
        versionLabel.text = String(format: versionFormat, version)
    }

    /// The version label owns its font in code so it can be re-asserted after
    /// UIKit resets it. Collapsed sizes match the former storyboard values
    /// (iPad 40 / iPhone 26 bold); the expanded state uses the smaller sizes
    /// (iPad 20 / iPhone 16 bold).
    private func desiredVersionFont(showFullVersion: Bool) -> UIFont {
        let fontSize: CGFloat = showFullVersion
            ? (isIpadTrait ? 20.0 : 16.0)
            : (isIpadTrait ? 40.0 : 26.0)
        return .systemFont(ofSize: fontSize, weight: .bold)
    }

    private func setUpCopyrightLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYearString = dateFormatter.string(from: Date())
        let copyrightFormat = String.localizedString("copyright_format")
        copyrightLabel.text = String(format: copyrightFormat, currentYearString)
    }
}

extension AboutViewController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupImage(logoImageView)
    }
}
