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

import SafariAdGuardSDK

enum RulesType {
    case safariWhitelist, invertedSafariWhitelist, systemWhitelist, systemBlacklist, safariUserfilter, wifiExceptions
}

protocol AddRuleControllerDelegate: AnyObject {
    func addRule(_ ruleText: String) throws
}

final class AddRuleController: BottomAlertController, UITextViewDelegate {
    
    weak var delegate : AddRuleControllerDelegate?
    var type: RulesType = .safariUserfilter
    
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var rulePlaceholderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editCaption: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textViewUnderline: TextFieldIndicatorView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let textViewCharectersLimit = 50
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = type.title
        editCaption.text = type.captionText
        
        addButton.isEnabled = false
        
        if type == .wifiExceptions {
            fillTextViewWithCurrentWiFiName()
        }
        
        if (type == .safariWhitelist || type == .invertedSafariWhitelist || type == .systemWhitelist){
            ruleTextView.keyboardType = .URL
        }
        
        if type == .safariUserfilter {
            ruleTextView.font = UIFont(name: "PTMono-Regular", size: 14.0)
        }
        
        ruleTextView.textContainer.lineFragmentPadding = 0
        ruleTextView.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        updateTheme()
        
        addButton.makeTitleTextUppercased()
        cancelButton.makeTitleTextUppercased()
        changeKeyboardReturnKeyTypeIfNeeded()
        addButton.applyStandardGreenStyle()
        cancelButton.applyStandardOpaqueStyle()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ruleTextView.becomeFirstResponder()
        rulePlaceholderLabel.text = type.placeholderText
    }
    
    // MARK: - Actions
    
    @IBAction func saveAction(_ sender: Any) {
        addRuleInternal()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true) {}
    }
    
    // MARK: - TextViewDelegateMethods
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard text != "\n" else {
            saveIfNeeded(text: textView.text)
            return false
        }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
    
        rulePlaceholderLabel.isHidden = updatedText.count > 0
        addButton.isEnabled = updatedText.count > 0
        
        if type != .wifiExceptions { return true }
    
        if updatedText.count >= textViewCharectersLimit {
            textView.text = String(updatedText.prefix(textViewCharectersLimit))
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewUnderline.state = .enabled
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewUnderline.state = .disabled
    }

    // MARK: - private methods
    
    private func fillTextViewWithCurrentWiFiName() {
        let networkSettingsService: NetworkSettingsServiceProtocol = ServiceLocator.shared.getService()!
        networkSettingsService.fetchCurrentWiFiName { [weak self] ssid in
            guard let self = self else { return }
            if let ssid = ssid, ssid.count <= self.textViewCharectersLimit {
                self.ruleTextView.text = ssid
                self.ruleTextView.selectAll(self)
                self.rulePlaceholderLabel.isHidden = true
                self.addButton.isEnabled = true
            }
        }
    }
    
    private func saveIfNeeded(text: String) {
        if !text.isEmpty, type == .wifiExceptions {
            ruleTextView.resignFirstResponder()
            addRuleInternal()
        }
    }
    
    private func changeKeyboardReturnKeyTypeIfNeeded() {
        if type == .wifiExceptions {
            ruleTextView.returnKeyType = .done
        }
    }
    
    private func addRuleInternal() {
        
        do {
            try delegate?.addRule(ruleTextView.text!)
            dismiss(animated: true, completion: nil)
        }
        catch {
            if case UserRulesStorageError.ruleAlreadyExists(ruleString: _) = error {
                showRuleExistsAlert()
            } else {
                showUnknownErrorAlert()
            }
        }
    }
    
    private func showRuleExistsAlert() {
        let title = String.localizedString("common_error_title")
        let message = String.localizedString("user_rule_exists_error")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.localizedString("common_action_ok"), style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - AddRuleController + ThemableProtocol

fileprivate extension RulesType {
    var title: String {
        switch self {
        case .safariUserfilter: return String.localizedString("add_blacklist_rule_title")
        case .systemBlacklist: return String.localizedString("add_blacklist_rule_title")
        case .systemWhitelist: return String.localizedString("add_whitelist_domain_title")
        case .safariWhitelist: return String.localizedString("add_whitelist_domain_title")
        case .invertedSafariWhitelist: return String.localizedString("add_whitelist_domain_title")
        case .wifiExceptions: return String.localizedString("add_wifi_name_placeholder")
        }
    }
    
    var captionText: String {
        switch self {
        case .safariUserfilter: return String.localizedString("add_blacklist_rule_caption")
        case .systemBlacklist: return String.localizedString("add_blacklist_rule_caption")
        case .systemWhitelist: return String.localizedString("add_whitelist_domain_caption")
        case .safariWhitelist: return String.localizedString("add_whitelist_domain_caption")
        case .invertedSafariWhitelist: return String.localizedString("add_whitelist_domain_caption")
        case .wifiExceptions: return String.localizedString("add_wifi_name_caption")
        }
    }
    
    var placeholderText: String {
        switch self {
        case .safariUserfilter: return String.localizedString("add_blacklist_rule_placeholder")
        case .systemBlacklist: return String.localizedString("add_blacklist_rule_placeholder")
        case .systemWhitelist: return String.localizedString("add_whitelist_domain_placeholder")
        case .safariWhitelist: return String.localizedString("add_whitelist_domain_placeholder")
        case .invertedSafariWhitelist: return String.localizedString("add_whitelist_domain_placeholder")
        case .wifiExceptions: return String.localizedString("add_wifi_name_placeholder")
        }
    }
}

// MARK: - AddRuleController + ThemableProtocol

extension AddRuleController: ThemableProtocol {
    func updateTheme() {
        rulePlaceholderLabel.textColor = theme.placeholderTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextView(ruleTextView)
    }
}
