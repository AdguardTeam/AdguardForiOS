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

class EditingUserFilterController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var helperLabel: ThemableLabel!
    @IBOutlet weak var textView: UITextView!
    
    var model: ListOfRulesModelProtocol? = nil
    
    // MARK: - Private variables
    
    private var themeObserver: Any? = nil
    
    /* Services */
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.font = UIFont(name: "PTMono-Regular", size: 15.0)
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        textView.textContainer.lineFragmentPadding = 0.0
        
        themeObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
                self?.updateTheme()
        }
        
        helperLabel.text = model?.helperLabelText
        
        updateTheme()
    }
    
    // MARK: - TextView delegate methods
    
    func textViewDidChange(_ textView: UITextView) {
        helperLabel.isHidden = !(textView.text.count == 0)
    }
    
    // MARK: - Private methods
    
    private func updateTheme(){
        textView.backgroundColor = theme.backgroundColor
        theme.setupTextView(textView)
        theme.setupLabel(helperLabel)
    }
}
