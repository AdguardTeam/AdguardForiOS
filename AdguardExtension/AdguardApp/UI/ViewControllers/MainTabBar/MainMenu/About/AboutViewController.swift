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
    
    @IBOutlet weak var loginLogoutButton: UIButton!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    
    private var themeToken: NotificationToken?
    private var proStatusObservation: NSKeyValueObservation?
    
    private let loginSegueId = "loginSegueId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        themeToken =  NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        proStatusObservation = configuration.observe(\.proStatus) {(_, _) in
            DispatchQueue.main.async {[weak self] in
                self?.processProStatus()
            }
        }
        
        processProStatus()
        setupLabels()
        updateTheme()
        setupBackButton()
    }

    // MARK: - Actions
    
    @IBAction func readMoreTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "home", from: "about", buildVersion: productInfo.buildVersion())
    }
    
    @IBAction func eulaTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "eula", from: "about", buildVersion: productInfo.buildVersion())
    }
    
    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        UIApplication.shared.openAdguardUrl(action: "privacy", from: "about", buildVersion: productInfo.buildVersion())
    }
    
    @IBAction func loginLogoutTapped(_ sender: UIButton) {
        if configuration.proStatus {
            showLogoutAlert()
        } else {
            performSegue(withIdentifier: loginSegueId, sender: self)
        }
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupImage(logoImageView)
    }
    
    private func processProStatus() {
        navigationItem.rightBarButtonItems = configuration.proStatus ? [] : [loginButton]
        
        if Bundle.main.isPro {
            loginLogoutButton.isHidden = true
            return
        }
        
        let redColor = UIColor(hexString: "#DF3812")
        let greenColor = UIColor(hexString: "#67B279")
        
        let color = configuration.proStatus ? redColor : greenColor
        let title = configuration.proStatus ? String.localizedString("common_logout") : String.localizedString("common_license")
        
        loginLogoutButton.setTitleColor(color, for: .normal)
        loginLogoutButton.setTitle(title, for: .normal)
    }
    
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
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: nil, message: ACLocalizedString("confirm_logout_text", nil), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: ACLocalizedString("common_action_yes", nil), style: .destructive) {
            [weak self] (action) in
            if self?.purchaseService.logout() ?? false {
                DispatchQueue.main.async {
                    self?.processProStatus()
                }
            }
        }
        alert.addAction(okAction)
        
        if let presenter = alert.popoverPresentationController{
            presenter.sourceView = loginLogoutButton
            presenter.sourceRect = loginLogoutButton.bounds
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
