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

protocol BlockedResponseTtlDelegate: AnyObject {
    func setTtlDescription(ttl: String)
}

final class BlockedResponseTtlController: BottomAlertController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: RoundRectButton!
    @IBOutlet weak var cancelButton: RoundRectButton!
    @IBOutlet weak var ttlTextField: AGTextField!
    @IBOutlet weak var scrollContentView: UIView!

    @IBOutlet var themableLabels: [ThemableLabel]!

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let dnsConfigAssistant: DnsConfigManagerAssistantProtocol = ServiceLocator.shared.getService()!

    weak var delegate: BlockedResponseTtlDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        ttlTextField.delegate = self
        ttlTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)

        ttlTextField.text = String(resources.blockedResponseTtlSecs)
        ttlTextField.keyboardType = .numberPad
        ttlTextField.becomeFirstResponder()

        updateSaveButton(ttlTextField.text)
        updateTheme()
        saveButton.makeTitleTextCapitalized()
        saveButton.applyStandardGreenStyle()
        saveButton.setBackgroundColor()

        cancelButton.makeTitleTextCapitalized()
        cancelButton.applyStandardOpaqueStyle()
    }

    // MARK: - Actions
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAction(_ sender: UIButton) {
        guard let text = ttlTextField.text, !text.isEmpty else { return }
        guard let numeric = Int(text), numeric >= 0 else { return }
        resources.blockedResponseTtlSecs = numeric
        dnsConfigAssistant.applyDnsPreferences(for: .modifiedLowLevelSettings, completion: nil)
        delegate?.setTtlDescription(ttl: String(numeric))
        dismiss(animated: true)
    }

    // MARK: - UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        ttlTextField.borderState = .enabled
        ttlTextField.rightView?.isHidden = updatedText.isEmpty
        updateSaveButton(updatedText)
        return true
    }

    // MARK: - Private methods

    private func updateSaveButton(_ text: String?) {
        let ttl = text ?? ""
        guard !ttl.isEmpty && Int(ttl) != nil else { saveButton.isEnabled = false; return }
        saveButton?.isEnabled = true
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        updateSaveButton(sender.text)
    }
}

extension BlockedResponseTtlController: ThemableProtocol {
    func updateTheme() {
        titleLabel.textColor = theme.popupTitleTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextField(ttlTextField)
        saveButton?.indicatorStyle = theme.indicatorStyle
        ttlTextField.updateTheme()
    }
}
