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

class EnableListOfRulesCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var serviceStateLabel: ThemableLabel!
    @IBOutlet weak var serviceStateSwitch: UISwitch!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var separatorView: UIView!
    
    private let filterRulesAction = "filter_rules"
    private let openUrlFrom = "user_filter"
    
    var theme: ThemeServiceProtocol? {
        didSet {
            updateTheme()
        }
    }
    
    var rulesDescription: String? {
        didSet{
            descriptionTextView.text = rulesDescription
            descriptionTextView.textContainer.lineFragmentPadding = 0.0
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
            setupDescriptionTextView()
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
        theme?.setupTextView(descriptionTextView)
        theme?.setupSwitch(serviceStateSwitch)
        theme?.setupTableCell(self)
        separatorView.backgroundColor = theme?.separatorColor
    }
    
    private func setupDescriptionTextView(){
        let text = descriptionTextView.text
        if type == .safariUserfilter{
            let htmlStringFormat = text ?? ""
            let urlString = UIApplication.shared.adguardUrl(action: filterRulesAction, from: openUrlFrom)
            let htmlString = String(format: htmlStringFormat, urlString)
            if let headerText = htmlString.attributedStringFromHtml() {
                descriptionTextView.text = ""
                headerText.addAttribute(.foregroundColor, value: theme?.lightGrayTextColor ?? .black, range: NSRange(location: 0, length: headerText.length))
                headerText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: headerText.length))
                descriptionTextView.attributedText = headerText
            }
        } else {
            descriptionTextView.textColor = theme?.lightGrayTextColor
        }
    }
}

class AddRuleCell: UITableViewCell {
    @IBOutlet weak var addRuleHeight: NSLayoutConstraint!
    @IBOutlet weak var addRuleWidth: NSLayoutConstraint!
    @IBOutlet weak var addRuleLabel: ThemableLabel!
    
    var theme: ThemeServiceProtocol? {
        didSet{
            updateTheme()
        }
    }
    
    var type: RulesType?{
        didSet {
            setupLabel()
            setupImage()
        }
    }
    
    private func setupLabel(){
        if type == .safariUserfilter{
            addRuleLabel.font = UIFont(name: "PTMono-Regular", size: 15.0)
            addRuleLabel.text = ACLocalizedString("add_new_rule", nil)
        } else {
            addRuleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
            addRuleLabel.text = ACLocalizedString("add_domain", nil)
        }
        addRuleLabel.textColor = UIColor(hexString: "#67b279")
    }
    
    private func setupImage(){
        if type == .safariUserfilter{
            addRuleWidth.constant = 14.0
            addRuleHeight.constant = 14.0
        } else {
            addRuleWidth.constant = 20.0
            addRuleHeight.constant = 20.0
        }
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
    
    var theme: ThemeServiceProtocol? {
        didSet{
            updateTheme()
        }
    }
    
    var ruleName: String? {
        didSet{
            ruleNameLabel.text = ruleName
        }
    }
    
    var ruleState: Bool? {
        didSet{
            let state: Bool = ruleState ?? false
            let crossImage = UIImage(named: "cross") ?? UIImage()
            let tickImage = UIImage(named: "logocheck") ?? UIImage()
            
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
