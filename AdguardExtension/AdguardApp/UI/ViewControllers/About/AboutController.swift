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

class AboutController : UIViewController {
    
    private let otherPlatformsAction = "http://agrd.io/ios_adguard_products"
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var logoImage: ThemeableImageView!
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        versionLabel.text = ACLocalizedString("about_version", nil) + " " +  ADProductInfo.versionWithBuildNumber()
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func otherPlatformsAction(_ sender: Any) {
        if let url = URL(string : otherPlatformsAction) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - private methods
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupLabels(themableLabels)
        theme.setupImage(logoImage)
    }
}
