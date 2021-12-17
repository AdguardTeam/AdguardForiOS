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

    private var ttlEntered: String { ttlTextField.text ?? "" }

    override func viewDidLoad() {
        super.viewDidLoad()
        ttlTextField.delegate = self
        ttlTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)

        ttlTextField.text = String(resources.blockedResponseTtlSecs)
        ttlTextField.keyboardType = .numberPad
        ttlTextField.becomeFirstResponder()

        updateTheme()
        saveButton.makeTitleTextCapitalized()
        saveButton.applyStandardGreenStyle()
        saveButton.setBackgroundColor()

        cancelButton.makeTitleTextCapitalized()
        cancelButton.applyStandardOpaqueStyle()

        updateSaveButton()
    }

    // MARK: - Actions
    @IBAction func cancelAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAction(_ sender: UIButton) {
        let ttlString = ttlEntered.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            !ttlString.isEmpty,
            let numeric = Int(ttlString),
            numeric >= 0
        else {
            return
        }

        resources.blockedResponseTtlSecs = numeric
        dnsConfigAssistant.applyDnsPreferences(for: .modifiedLowLevelSettings, completion: nil)
        delegate?.setTtlDescription(ttl: String(numeric))
        dismiss(animated: true)
    }

    // MARK: - Private methods

    private func updateSaveButton() {
        let ttlStirng = ttlEntered.trimmingCharacters(in: .whitespacesAndNewlines)
        if let ttl = Int(ttlStirng) {
            saveButton.isEnabled = ttl >= 0
        } else {
            saveButton.isEnabled = false
        }
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        updateSaveButton()
        ttlTextField.borderState = .enabled
        ttlTextField.rightView?.isHidden = ttlEntered.isEmpty
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
