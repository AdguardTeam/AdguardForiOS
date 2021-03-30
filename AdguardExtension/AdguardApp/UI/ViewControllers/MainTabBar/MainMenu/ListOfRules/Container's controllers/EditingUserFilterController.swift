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
    
    /* Services */
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fontSize = textView.font?.pointSize ?? 16.0
        let font = UIFont(name: "PTMono-Regular", size: fontSize)
        textView.font = font ?? UIFont.systemFont(ofSize: fontSize)
        textView.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        textView.textContainer.lineFragmentPadding = 0.0
        
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
        view.backgroundColor = theme.backgroundColor
        theme.setupTextView(textView)
        theme.setupLabel(helperLabel)
    }
}

extension EditingUserFilterController: ThemableProtocol {
    func themeNeedUpdate() {
        updateTheme()
    }
}
