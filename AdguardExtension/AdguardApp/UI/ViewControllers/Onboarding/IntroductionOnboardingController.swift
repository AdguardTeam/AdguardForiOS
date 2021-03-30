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

class IntroductionOnboardingController: UIViewController {
    
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var licenseTextView: UITextView!
    @IBOutlet weak var nextButton: RoundRectButton!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    var delegate: OnboardingControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.applyStandardGreenStyle()
        updateTheme()
        setupBackButton()
        
        if let navController = navigationController as? MainNavigationController {
            navController.removeGestureRecognizer()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OnboardingAnimationsController {
            controller.delegate = delegate
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return theme.statusbarStyle()
    }
    
    //MARK: - Actions
    //MARK: - Private mathods
    private func setupLicenseTextView() {
        let format = String.localizedString("introduction_license_agreement")
        let privacy = UIApplication.shared.adguardUrl(action: "privacy", from: "license", buildVersion: productInfo.buildVersion())
        let eula = UIApplication.shared.adguardUrl(action: "eula", from: "license", buildVersion: productInfo.buildVersion())
        let htmlString = String(format: format, privacy, eula)
        
        let font = licenseTextView.font ?? UIFont.systemFont(ofSize: 16.0)
        let attributeString = NSMutableAttributedString.fromHtml(htmlString, fontSize: font.pointSize, color: theme.blackTextColor, attachmentImage: nil, textAlignment: .center)
        
        licenseTextView.attributedText = attributeString
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabel(titleLabel)
        theme.setupTextView(licenseTextView)
        setupLicenseTextView()
        theme.setupNavigationBar(navigationController?.navigationBar)
    }
}

extension IntroductionOnboardingController: ThemableProtocol {
    func themeNeedUpdate() {
        updateTheme()
    }
}
