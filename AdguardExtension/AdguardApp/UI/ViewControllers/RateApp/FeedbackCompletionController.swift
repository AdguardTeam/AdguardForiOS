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

class FeedbackCompletionController: UIViewController {

    @IBOutlet weak var feedBackTitle: ThemableLabel!
    @IBOutlet weak var manImageView: UIImageView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var messageLabel: ThemableLabel!
    @IBOutlet weak var homeButton: UIButton!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        homeButton.makeTitleTextUppercased()
        homeButton.layer.cornerRadius = homeButton.frame.height / 2
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          homeButton.layer.cornerRadius = homeButton.frame.height / 2
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        navigationController?.dismiss(animated: true)
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.popupBackgroundColor
        theme.setupLabel(titleLabel)
        theme.setupLabel(messageLabel)
        theme.setupLabel(feedBackTitle)
    }
}
