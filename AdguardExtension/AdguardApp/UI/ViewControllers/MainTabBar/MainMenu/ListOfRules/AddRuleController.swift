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

protocol AddRuleControllerDelegate {
    func addRule(rule: String)
}

class AddRuleController: BottomAlertController, UITextViewDelegate {
    
    var delegate : AddRuleControllerDelegate?
    var type: RulesType = .safariUserfilter
    
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var rulePlaceholderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editCaption: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textViewUnderline: TextFieldIndicatorView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let textViewCharectersLimit = 50
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name:
            UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        titleLabel.text = getTitleText()
        editCaption.text = getEditCaptionText()
        
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
        cancelButton.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.lightGray4)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ruleTextView.becomeFirstResponder()
        rulePlaceholderLabel.text = getPlaceholderText()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveAction(_ sender: Any) {
        delegate?.addRule(rule: ruleTextView.text!)
        dismiss(animated: true, completion: nil)
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
        let ssid = networkSettingsService.getCurrentWiFiName()
        
        if let ssid = ssid, ssid.count <= textViewCharectersLimit {
            ruleTextView.text = ssid
            ruleTextView.selectAll(self)
            rulePlaceholderLabel.isHidden = true
            addButton.isEnabled = true
        }
    }
    
    private func getTitleText() -> String {
        switch type {
        case .safariUserfilter:
            return ACLocalizedString("add_blacklist_rule_title", nil)
        case .systemBlacklist:
            return ACLocalizedString("add_blacklist_rule_title", nil)
        case .systemWhitelist:
            return ACLocalizedString("add_whitelist_domain_title", nil)
        case .safariWhitelist:
            return ACLocalizedString("add_whitelist_domain_title", nil)
        case .invertedSafariWhitelist:
            return ACLocalizedString("add_whitelist_domain_title", nil)
        case .wifiExceptions:
            return ACLocalizedString("add_wifi_name_placeholder", nil)
        }
    }
    
    private func getEditCaptionText() -> String {
        switch type {
        case .safariUserfilter:
            return ACLocalizedString("add_blacklist_rule_caption", nil)
        case .systemBlacklist:
            return ACLocalizedString("add_blacklist_rule_caption", nil)
        case .systemWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .safariWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .invertedSafariWhitelist:
            return ACLocalizedString("add_whitelist_domain_caption", nil)
        case .wifiExceptions:
            return ACLocalizedString("add_wifi_name_caption", nil)
        }
    }
    
    private func getPlaceholderText() -> String {
        switch type {
        case .safariUserfilter:
            return ACLocalizedString("add_blacklist_rule_placeholder", nil)
        case .systemBlacklist:
            return ACLocalizedString("add_blacklist_rule_placeholder", nil)
        case .systemWhitelist:
            return ACLocalizedString("add_whitelist_domain_placeholder", nil)
        case .safariWhitelist:
            return ACLocalizedString("add_whitelist_domain_placeholder", nil)
        case .invertedSafariWhitelist:
            return ACLocalizedString("add_whitelist_domain_placeholder", nil)
        case .wifiExceptions:
            return ACLocalizedString("add_wifi_name_placeholder", nil)
        }
    }
    
    private func saveIfNeeded(text: String) {
        if !text.isEmpty, type == .wifiExceptions {
            ruleTextView.resignFirstResponder()
            delegate?.addRule(rule: text)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func changeKeyboardReturnKeyTypeIfNeeded() {
        if type == .wifiExceptions {
            ruleTextView.returnKeyType = .done
        }
    }
}

extension AddRuleController: ThemableProtocol {
    func updateTheme() {
        rulePlaceholderLabel.textColor = theme.placeholderTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextView(ruleTextView)
    }
}
