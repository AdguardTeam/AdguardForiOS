//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

final class EditBlockRequestController: BottomAlertController {

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var domainNameTextField: AGTextField!

    @IBOutlet weak var addButton: RoundRectButton!
    @IBOutlet weak var backButton: RoundRectButton!

    @IBOutlet var themableLabels: [ThemableLabel]!

    var type: DnsLogButtonType = .addDomainToAllowList
    var domain: String = ""
    var originalDomain: String = ""
    var delegate: AddDomainToListDelegate?

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    override func viewDidLoad() {
        super.viewDidLoad()
        domainNameTextField.delegate = self
        domainNameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)

        titleLabel.text = (type == .addDomainToAllowList) ? String.localizedString("whitelist_request") : String.localizedString("block_request")

        let converter = DomainConverter()

        domainNameTextField.text = (type == .addDomainToAllowList) ? domain : converter.userFilterBlockRuleFromDomain(domain)
        domainNameTextField.becomeFirstResponder()

        updateTheme()

        addButton.makeTitleTextCapitalized()
        backButton.makeTitleTextCapitalized()
        addButton.applyStandardGreenStyle()
        addButton.setBackgroundColor()
        backButton.applyStandardOpaqueStyle()
    }

    // MARK: - Actions

    @IBAction func addTapped(_ sender: UIButton) {
        let domain = domainNameTextField.text ?? ""

        switch type {
        case .removeDomainFromWhitelist, .removeRuleFromUserFilter: break
        case .addDomainToAllowList: delegate?.add(domain: domain, by: .addDomainToAllowList)
        case .addRuleToUserFlter: delegate?.addEditedBlocklistRule(domain)
        }
        dismiss(animated: true)
    }

    @IBAction func backTapped(_ sender: UIButton) {
        let presenter = presentingViewController
        dismiss(animated: true) {[weak self] in
            guard let self = self else { return }
            presenter?.presentBlockRequestController(with: self.originalDomain, type: self.type, delegate: self.delegate)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        addButton.isEnabled = !updatedText.trimmingCharacters(in: .whitespaces).isEmpty
        return true
    }

    // MARK: - Private methods

    @objc private final func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        addButton.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension EditBlockRequestController: ThemableProtocol {
    func updateTheme() {
        titleLabel.textColor = theme.popupTitleTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupTextField(domainNameTextField)
        theme.setupPopupLabels(themableLabels)
        domainNameTextField.updateTheme()
    }
}
