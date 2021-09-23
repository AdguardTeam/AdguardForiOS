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
import UIKit

protocol RuleDetailsControllerDelegate {
    func removeRule(_ ruleText: String, at indexPath: IndexPath) throws
    func modifyRule(_ oldRuleText: String, newRule: UserRule, at indexPath: IndexPath) throws
}

final class RuleDetailsController: BottomAlertController, UITextViewDelegate {
    
    struct Context {
        let rule: UserRule
        let ruleIndexPath: IndexPath
        let delegate: RuleDetailsControllerDelegate
        let ruleType: RulesType
    }
    
    // MARK: - Internal properties
    
    var context: Context!
    
    // MARK: IB outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ruleTextView: UITextView!
    @IBOutlet weak var textUnderline: TextFieldIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var domainOrRuleLabel: ThemableLabel!
    
    // MARK: - Private properties
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let enabledLineColor = UIColor.AdGuardColor.lightGray2
    private let disabledLineColor = UIColor.AdGuardColor.lightGray5
    private let textViewCharectersLimit = 50
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        domainOrRuleLabel.text = context.ruleType.editCaptionText
        ruleTextView.text = context.ruleType == .wifiExceptions ? String(context.rule.ruleText.prefix(textViewCharectersLimit)) : context.rule.ruleText
        
        ruleTextView.textContainer.lineFragmentPadding = 0
        ruleTextView.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        if context.ruleType == .safariWhitelist || context.ruleType == .invertedSafariWhitelist || context.ruleType == .systemWhitelist {
            ruleTextView.keyboardType = .URL
        }
        
        if context.ruleType == .safariUserfilter {
            ruleTextView.font = UIFont(name: "PTMono-Regular", size: 14.0)
        }
                
        updateTheme()
        
        changeKeyboardReturnKeyTypeIfNeeded()
        saveButton.applyStandardGreenStyle()
        deleteButton.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.red)
        
        ruleTextView.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func saveAction(_ sender: Any) {
        let ruleText = ruleTextView.text ?? ""
        if ruleText == context.rule.ruleText {
            dismiss(animated: true, completion: nil)
            return
        }
        
        do {
            let newRule = UserRule(ruleText: ruleText, isEnabled: context.rule.isEnabled)
            try context.delegate.modifyRule(context.rule.ruleText, newRule: newRule, at: context.ruleIndexPath)
            dismiss(animated: true, completion: nil)
        } catch {
            if case UserRulesStorageError.ruleAlreadyExists(ruleString: _) = error {
                showRuleExistsAlert()
            } else {
                showUnknownErrorAlert()
            }
        }
    }
    
    @IBAction func removeAction(_ sender: Any) {
        do {
            try context.delegate.removeRule(context.rule.ruleText, at: context.ruleIndexPath)
            dismiss(animated: true, completion: nil)
        }
        catch {
            DDLogError("(RuleDetailsController) - removeAction; Error removing rule: \(error)")
            showUnknownErrorAlert()
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
    
        saveButton.isEnabled = updatedText.count > 0
        
        if context.ruleType != .wifiExceptions { return true }
    
        if updatedText.count >= textViewCharectersLimit {
            textView.text = String(updatedText.prefix(textViewCharectersLimit))
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textUnderline.state = .enabled
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textUnderline.state = .disabled
    }
    
    // MARK: - private methods
    
    private func changeKeyboardReturnKeyTypeIfNeeded() {
        if context.ruleType == .wifiExceptions {
            ruleTextView.returnKeyType = .done
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

// MARK: - RulesType + Strings

fileprivate extension RulesType {
    var editCaptionText: String {
        switch self {
        case .safariUserfilter: return String.localizedString("add_blacklist_rule_caption")
        case .systemBlacklist: return String.localizedString("add_blacklist_rule_caption")
        case .systemWhitelist: return String.localizedString("add_whitelist_domain_caption")
        case .safariWhitelist: return String.localizedString("add_whitelist_domain_caption")
        case .invertedSafariWhitelist: return String.localizedString("add_whitelist_domain_caption")
        case .wifiExceptions: return String.localizedString("add_wifi_name_caption")
        }
    }
}

// MARK: - RuleDetailsController + ThemableProtocol

extension RuleDetailsController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        titleLabel.textColor = theme.popupTitleTextColor
        theme.setupPopupLabels(themableLabels)
        theme.setupTextView(ruleTextView)
    }
}
