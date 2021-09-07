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

final class UserRulesRedirectController: BottomAlertController {

    var action: Action = .addToAllowlist(domain: "domain.com")
    var state: State = .processing
    
    enum Action {
        case removeFromAllowlist(domain: String)
        case addToAllowlist(domain: String)
        case addToBlocklist(domain: String)
        case removeAllBlocklistRules(domain: String)
        
        fileprivate var title: String {
            switch self {
            case .removeFromAllowlist(let domain): return domain
            case .addToAllowlist(let domain): return domain
            case .addToBlocklist(let domain): return domain
            case .removeAllBlocklistRules(let domain): return domain
            }
        }
        
        fileprivate var description: String {
            switch self {
            case .removeFromAllowlist(let domain): return "Waiting for content \(domain)"
            case .addToAllowlist(let domain): return "Waiting for content \(domain)"
            case .addToBlocklist(let domain): return "Waiting for content \(domain)"
            case .removeAllBlocklistRules(let domain): return "Waiting for content \(domain)"
            }
        }
        
        fileprivate var icon: UIImage? {
            switch self {
            case .removeFromAllowlist(_): return UIImage(named: "kill_switch")
            case .addToAllowlist(_): return UIImage(named: "thumbsup")
            case .addToBlocklist(_): return UIImage(named: "ad_blocking_feature_logo")
            case .removeAllBlocklistRules(_): return UIImage(named: "kill_switch")
            }
        }
    }
    
    enum State {
        case processing
        case done(action: Action)
        
        fileprivate var title: String {
            switch self {
            case .processing: return String.localizedString("user_rules_processing_title")
            case .done(let action): return action.title
            }
        }
        
        fileprivate var description: String {
            switch self {
            case .processing: return String.localizedString("user_rules_processing_desct")
            case .done(let action): return action.description
            }
        }
    }
    
    // MARK: - UI Elements
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var okButton: UIButton!
    
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isHidden = true
        imageView.image = action.icon
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        titleLabel.text = state.title
        descriptionLabel.text = state.description
        
        setupOkButton()
        updateTheme()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.setNormal()
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
        UIView.animate(withDuration: 0.3) {
            self.setTexts()
        }
        activityIndicator.fadeOut(0.3, 0.0) { success in
            self.activityIndicator.stopAnimating()
            self.imageView.fadeIn(0.3, 0.0, onCompletion: nil)
        }
    }
    
    private func setProcessing() {
        state = .processing
        UIView.animate(withDuration: 0.3) {
            self.setTexts()
        }
        imageView.fadeOut(0.3, 0.0) { success in
            self.activityIndicator.startAnimating()
            self.activityIndicator.fadeIn(0.3, 0.0, onCompletion: nil)
        }
    }
    
    private func setTexts() {
        titleLabel.text = state.title
        descriptionLabel.text = state.description
    }
}

extension UserRulesRedirectController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = themeService.popupBackgroundColor
        themeService.setupLabel(titleLabel)
        themeService.setupLabel(descriptionLabel)
        activityIndicator.style = themeService.indicatorStyle
    }
}
