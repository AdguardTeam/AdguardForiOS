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

final class UserRulesRedirectController: BottomAlertController {

    var action: UserRulesRedirectAction = .addToAllowlist(domain: "domain.com")
    var state: State = .processing {
        didSet {
            model.state = state
        }
    }
    
    enum State {
        case processing
        case done(action: UserRulesRedirectAction)
    }
    
    // MARK: - UI Elements
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var okButton: UIButton!
    
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private var model: UserRulesRedirectControllerModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = UserRulesRedirectControllerModel(safariProtection: safariProtection)
        model.action = action
        
        imageView.isHidden = true
        imageView.image = model.icon
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        setupOkButton()
        updateTheme()
        
        model.processAction { error in
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.setNormal()
            }
        }
    }
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupOkButton() {
        let title = String.localizedString("common_action_ok")
        okButton.setTitle(title, for: .normal)
        okButton.makeTitleTextUppercased()
        okButton.applyStandardGreenStyle()
    }
    
    private func setNormal() {
        state = .done(action: action)
        imageView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.activityIndicator.alpha = 0.0
            self.imageView.alpha = 1.0
            self.setTexts()
        } completion: { _ in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    private func setTexts() {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

// MARK: - UserRulesRedirectAction + ThemableProtocol

extension UserRulesRedirectController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = themeService.popupBackgroundColor
        themeService.setupLabel(titleLabel)
        themeService.setupLabel(descriptionLabel)
        activityIndicator.style = themeService.indicatorStyle
    }
}
