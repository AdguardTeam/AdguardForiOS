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


/// WhatsNewBottomAlertControllerDelegate - Delegate protocol
protocol WhatsNewBottomAlertControllerDelegate: AnyObject {
    func enableButtonForNonProTapped()
}



/// WhatsNewBottomAlertController - Responsible for representation new features available in new version of app
final class WhatsNewBottomAlertController: BottomAlertController {
    
    //MARK: - Outlets
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    //MARK: - Properties
    weak var delegate: WhatsNewBottomAlertControllerDelegate?
    //MARK: - Services
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resoruces: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    //MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableButton.applyStandardGreenStyle()
        updateTheme()
    }
    
    //MARK: - Actions
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        if !configuration.proStatus {
            delegate?.enableButtonForNonProTapped()
            return
        }
        
        resoruces.advancedProtection = true
        dismiss(animated: true, completion: onDismissCompletion)
    }
}

extension WhatsNewBottomAlertController: ThemableProtocol {
    func updateTheme() {
        themeService.setupLabels(themableLabels)
        self.contentView.backgroundColor = themeService.popupBackgroundColor
    }
}
