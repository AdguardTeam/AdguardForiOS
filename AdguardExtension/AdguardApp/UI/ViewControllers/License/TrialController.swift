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

class TrialController: UIViewController {
    
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var trialDescriptionLabel: UILabel!
    @IBOutlet weak var tryButton: RoundRectButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    private let mobileImage = UIImage(named: "trial-mobile") ?? UIImage()
    private let ipadImage = UIImage(named: "trial-ipad") ?? UIImage()
    private let ipadLandScape = UIImage(named: "trial-ipad-landscape") ?? UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isTranslucent = true
        guard let nav = self.navigationController as? MainNavigationController else { return }
        nav.customStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isTranslucent = false
        guard let nav = self.navigationController as? MainNavigationController else { return }
        nav.customStatusBarStyle = nil
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        backgroundImageView.image = getBackgroundImage()
    }
    
    override func viewWillLayoutSubviews() {
        initialSetups()
    }
    
    private func getBackgroundImage() -> UIImage {
        if UIDevice.current.userInterfaceIdiom == .phone || traitCollection.horizontalSizeClass == .compact{
            return mobileImage
        } else {
            return UIDevice.current.orientation.isLandscape ? ipadLandScape : ipadImage
        }
    }
    
    private func initialSetups(){
        backgroundImageView.image = getBackgroundImage()
        
        if traitCollection.horizontalSizeClass == .regular  {
            trialLabel.font = trialLabel.font.withSize(48.0)
            trialDescriptionLabel.font = trialDescriptionLabel.font.withSize(24.0)
            tryButton.layer.cornerRadius = 30.0
            tryButton.titleLabel?.font = tryButton.titleLabel?.font.withSize(22.0)
            loginButton.titleLabel?.font = loginButton.titleLabel?.font.withSize(22.0)
        } else {
            trialLabel.font = trialLabel.font.withSize(32.0)
            trialDescriptionLabel.font = trialDescriptionLabel.font.withSize(15.0)
            tryButton.layer.cornerRadius = 20.0
            tryButton.titleLabel?.font = tryButton.titleLabel?.font.withSize(17.0)
            loginButton.titleLabel?.font = loginButton.titleLabel?.font.withSize(14.0)
        }
    }
}
