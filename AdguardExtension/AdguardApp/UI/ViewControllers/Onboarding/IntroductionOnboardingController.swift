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
    @IBOutlet weak var nextButton: UIButton!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    
    var delegate: OnboardingControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        setupBackButton()
        
        if let navController = navigationController as? MainNavigationController {
            navController.removeGestureRecognizer()
        }
                
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }
    
    private func setupLicenseTextView() {
        let format = String.localizedString("introduction_license_agreement")
        let privacy = UIApplication.shared.adguardUrl(action: "privacy", from: "license", buildVersion: productInfo.buildVersion())
        let eula = UIApplication.shared.adguardUrl(action: "eula", from: "license", buildVersion: productInfo.buildVersion())
        let htmlString = String(format: format, privacy, eula)
        
        let font = licenseTextView.font ?? UIFont.systemFont(ofSize: 16.0)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        guard let data = htmlString.data(using: .utf8) else { return }
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding:NSNumber(value:String.Encoding.utf8.rawValue)],
            documentAttributes: nil) else { return }
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: theme.grayTextColor, NSAttributedString.Key.paragraphStyle : style], range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attributedString.length))
        
        licenseTextView.attributedText = attributedString
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabel(titleLabel)
        theme.setupTextView(licenseTextView)
        setupLicenseTextView()
        theme.setupNavigationBar(navigationController?.navigationBar)
    }
}
