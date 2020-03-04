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

class TitleListOfRulesCell: UITableViewCell {
    @IBOutlet weak var titleLabel: ThemableLabel!
}

class EnableListOfRulesCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var serviceStateLabel: ThemableLabel!
    @IBOutlet weak var serviceStateSwitch: UISwitch!
    
    var theme: ThemeServiceProtocol? {
        didSet {
            updateTheme()
        }
    }
    
    var type: RulesType? {
        didSet{
            var image = UIImage()
            
            switch type {
            case .safariUserfilter:
                image = UIImage(named: "custom") ?? UIImage()
            case .safariWhitelist:
                image = UIImage(named: "thumbsup") ?? UIImage()
            case .invertedSafariWhitelist:
                image = UIImage(named: "thumbsup") ?? UIImage()
            case .systemWhitelist:
                image = UIImage(named: "thumbsup") ?? UIImage()
            case .systemBlacklist:
                image = UIImage(named: "blacklist-icon") ?? UIImage()
            case .wifiExceptions:
                image = UIImage()
            case .none:
                image = UIImage()
            }
            
            iconImageView.image = image
        }
    }
    
    var serviceState: Bool? {
        didSet{
            let state: Bool = serviceState ?? false
            serviceStateLabel.text = state ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
            serviceStateSwitch.isOn = state
        }
    }
    
    private func updateTheme(){
        theme?.setupLabel(serviceStateLabel)
        theme?.setupSwitch(serviceStateSwitch)
        theme?.setupTableCell(self)
    }
}

class DesciptionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var separatorView: UIView!
    
    var theme: ThemeServiceProtocol? {
        didSet {
            updateTheme()
        }
    }
    
    var rulesDescription: String? {
        didSet{
            descriptionTextView.textContainer.lineFragmentPadding = 0.0
            setDescriptionText(rulesDescription!)
        }
    }
    
    private func setDescriptionText(_ text: String){
        if let headerText = text.attributedStringFromHtml() {
            let font = descriptionTextView.font ?? UIFont.systemFont(ofSize: 14)
            descriptionTextView.text = ""
            headerText.addAttribute(.foregroundColor, value: theme?.lightGrayTextColor ?? .black, range: NSRange(location: 0, length: headerText.length))
            headerText.addAttribute(.font, value: font, range: NSRange(location: 0, length: headerText.length))
            descriptionTextView.attributedText = headerText
        }
    }
    
    private func updateTheme(){
        theme?.setupTextView(descriptionTextView)
        theme?.setupTableCell(self)
        separatorView.backgroundColor = theme?.separatorColor
    }
}

class AddRuleCell: UITableViewCell {
    @IBOutlet weak var addRuleLabel: ThemableLabel!
    
    var theme: ThemeServiceProtocol? {
        didSet{
            updateTheme()
        }
    }
    
    var type: RulesType?{
        didSet {
            setupLabel()
        }
    }
    
    private func setupLabel(){
        let fontSize = addRuleLabel.font.pointSize
        if type == .safariUserfilter {
            addRuleLabel.font = UIFont(name: "PTMono-Regular", size: fontSize)
            addRuleLabel.text = ACLocalizedString("add_new_rule", nil)
        } else {
            addRuleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
            addRuleLabel.text = type == .systemBlacklist ? String.localizedString("add_new_rule") : String.localizedString("add_domain")
        }
        addRuleLabel.textColor = UIColor(hexString: "#67b279")
    }
    
    private func updateTheme(){
        theme?.setupLabel(addRuleLabel)
        theme?.setupTableCell(self)
    }
}

class NormalRuleCell: UITableViewCell {
    @IBOutlet weak var ruleNameLabel: ThemableLabel!
    @IBOutlet weak var ruleStateImageView: UIImageView!
    @IBOutlet weak var changeRuleStateButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let crossImage = UIImage(named: "cross") ?? UIImage()
    private let tickImage = UIImage(named: "logocheck") ?? UIImage()
    
    var theme: ThemeServiceProtocol? {
        didSet{
            updateTheme()
        }
    }
    
    var rule: RuleInfo? {
        didSet{
            ruleNameLabel.text = rule?.rule
        }
    }
    
    var type: RulesType? {
        didSet{
            if type == .safariUserfilter || type == .systemBlacklist {
                ruleNameLabel.textColor = rule?.textColor
            }

            if type == .systemWhitelist || type == .systemBlacklist{
                ruleStateImageView.isHidden = true
            }
            
            let fontSize = ruleNameLabel.font.pointSize
            
            if type == .safariUserfilter {
                ruleNameLabel.font = UIFont(name: "PTMono-Regular", size: fontSize)
                topConstraint.constant = 6.0
                bottomConstraint.constant = 6.0
            } else {
                ruleNameLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
                topConstraint.constant = 16.0
                bottomConstraint.constant = 16.0
            }
        }
    }
    
    var ruleState: Bool? {
        didSet{
            let state: Bool = ruleState ?? false
            
            ruleStateImageView.image = state ? tickImage : crossImage
        }
    }
    
    private func updateTheme(){
        theme?.setupLabel(ruleNameLabel)
        theme?.setupTableCell(self)
        separatorView.backgroundColor = theme?.separatorColor
    }
}

class SelectRuleCell: UITableViewCell {
    @IBOutlet weak var selectRuleImageView: UIImageView!
    @IBOutlet weak var ruleNameLabel: ThemableLabel!
    @IBOutlet weak var separatorView: UIView!
    
    var theme: ThemeServiceProtocol? {
        didSet {
            updateTheme()
        }
    }
    
    var ruleName: String? {
        didSet{
            ruleNameLabel.text = ruleName
        }
    }
    
    var ruleIsSelected: Bool? {
        didSet{
            let selected = ruleIsSelected ?? false
            let selectedImage = UIImage(named: "check") ?? UIImage()
            let unselectedImage = UIImage(named: "check-off") ?? UIImage()
            
            selectRuleImageView.image = selected ? selectedImage : unselectedImage
        }
    }
    
    private func updateTheme(){
        theme?.setupLabel(ruleNameLabel)
        theme?.setupTableCell(self)
        separatorView.backgroundColor = theme?.separatorColor
    }
}
