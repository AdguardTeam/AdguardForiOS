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

class SystemProtectionEnablerController: UIViewController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var enableButton: UIButton!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableButton.accessibilityLabel = String.localizedString("enable_system_protection_voiceover")
        enableButton.applyStandardGreenStyle()
        updateTheme()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }

    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupLabel(titleLabel)
    }
}
