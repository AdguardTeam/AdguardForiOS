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
    
    @IBOutlet weak var addButton: RoundRectButton!
    @IBOutlet weak var backButton: RoundRectButton!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    var type: DnsLogButtonType = .addDomainToWhitelist
    var domain: String = ""
    var originalDomain: String = ""
    var delegate: AddDomainToListDelegate?
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = type == .addDomainToWhitelist ? String.localizedString("whitelist_request") : String.localizedString("block_request")
        
        let converter = DomainsConverter()
        
        domainNameTextField.text = type == .addDomainToWhitelist ? domain : converter.blacklistRuleFromDomain(domain)
        domainNameTextField.becomeFirstResponder()
        
        updateTheme()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        addButton.makeTitleTextUppercased()
        backButton.makeTitleTextUppercased()
        addButton.applyStandardGreenStyle()
        backButton.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.gray)
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: UIButton) {
        let domain = domainNameTextField.text ?? ""
        let needsCorrecting = type == .addDomainToWhitelist
        delegate?.add(domain: domain, needsCorrecting: needsCorrecting, by: type)
        dismiss(animated: true)
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        let presenter = presentingViewController
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            presenter?.presentBlockRequestController(with: self.originalDomain, type: self.type, delegate: self.delegate)
        }
    }
    
    // MARK: - private methods
    private func updateTheme() {
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupTextField(domainNameTextField)
        theme.setupPopupLabels(themableLabels)
    }
}

