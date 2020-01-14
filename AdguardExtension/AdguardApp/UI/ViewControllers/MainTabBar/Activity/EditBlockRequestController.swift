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

class EditBlockRequestController: BottomAlertController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var domainNameTextField: UITextField!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    var type: DnsLogButtonType = .addDomainToWhitelist
    var domain: String = ""
    var delegate: AddDomainToListDelegate?
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = type == .addDomainToWhitelist ? String.localizedString("whitelist_request") : String.localizedString("block_request")
        
        domainNameTextField.text = type == .addDomainToWhitelist ? domain : "||" + domain + "^"
        domainNameTextField.becomeFirstResponder()
        
        updateTheme()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: UIButton) {
        let domain = domainNameTextField.text ?? ""
        delegate?.add(domain: domain, needsCorrecting: false, by: type)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
    
    // MARK: - private methods
    private func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupTextField(domainNameTextField)
        theme.setupPopupLabels(themableLabels)
    }

}

