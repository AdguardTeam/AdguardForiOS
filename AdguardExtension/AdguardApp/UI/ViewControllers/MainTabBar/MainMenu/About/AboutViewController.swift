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

class AboutViewController: UIViewController {
    @IBOutlet var loginButton: UIBarButtonItem!
    
    @IBOutlet weak var logoImageView: ThemeableImageView!
    @IBOutlet weak var versionLabel: ThemableLabel!
    @IBOutlet weak var copyrightLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        updateTheme()
        setupBackButton()
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
    
    // MARK: - private methods
    private func setupLabels() {
        let version = productInfo.versionWithBuildNumber() ?? ""
        let versionFormat = String.localizedString("about_version_format")
        versionLabel.text = String(format: versionFormat, version)
        
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
