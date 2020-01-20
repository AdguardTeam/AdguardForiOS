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

class RuleAddedController: BottomAlertController {
    
    @IBOutlet weak var okButton: RoundRectButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    @IBOutlet var themableButtons: [RoundRectButton]!
    
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        super.viewDidLoad()
        updateTheme()
        okButton.makeTitleTextUppercased()
    }
    
    @IBAction func okAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupLabels(themableLabels)
        theme.setupPopupButtons(themableButtons)
        theme.setupSeparators(separators)
    }
}
