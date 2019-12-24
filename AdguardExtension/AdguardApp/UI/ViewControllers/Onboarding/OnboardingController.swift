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

import Foundation

protocol OnboardingControllerDelegate {
    func showVideoAction(sender: UIViewController)
}

class OnboardingController: UIViewController {
    
    var delegate: OnboardingControllerDelegate?
    
    // MARK: - services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    
    // MARK: - outlets
    @IBOutlet weak var settingsLabel: ThemableLabel!
    @IBOutlet weak var safariLabel: ThemableLabel!
    @IBOutlet weak var switchLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    @IBOutlet weak var videoButton: RoundRectButton!
    
    // MARK: - view controller live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
            self?.setupLabels()
        }
        setupLabels()
        
        updateTheme()
    }
    
    // MARK: - actions
    @IBAction func videoAction(_ sender: Any) {
        delegate?.showVideoAction(sender: self)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - private methods
    
    func setupLabels() {
        settingsLabel.attributedText = NSMutableAttributedString.fromHtml(String.localizedString("onboarding_first_step_text"), fontSize: 16, color: theme.grayTextColor, attachmentImage: UIImage(named: "settings"))
        
        safariLabel.attributedText = NSMutableAttributedString.fromHtml(String.localizedString("onboarding_second_step_text"), fontSize: 16, color: theme.grayTextColor, attachmentImage: UIImage(named: "safari_onboarding"))
        
        switchLabel.attributedText = NSMutableAttributedString.fromHtml(String.localizedString("onboarding_third_step_text"), fontSize: 16, color: theme.grayTextColor, attachmentImage: UIImage(named: "switch"))   
    }
    
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupPopupButton(videoButton)
    }
}
