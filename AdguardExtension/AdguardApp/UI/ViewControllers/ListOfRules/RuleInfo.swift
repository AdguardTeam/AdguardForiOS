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

enum RuleType {
    case blacklist
    case whitelist
    case comment
    case css
    case cssException
}

class RuleInfo: NSObject {
    var rule: String
    var attributedString: NSAttributedString?
    var selected: Bool
    var textColor: UIColor!
    var font: UIFont!
    var enabled: Bool
    
    // we define the type of rule by special makers that we look for in the text of rule
    // https://kb.adguard.com/en/general/how-to-create-your-own-ad-filters#basic-rules-syntax
    private let whitelistPrefix = "@@"
    
    // https://kb.adguard.com/en/general/how-to-create-your-own-ad-filters#comments
    private let commentPrefix = "!"
    
    // https://kb.adguard.com/en/general/how-to-create-your-own-ad-filters#cosmetic-elemhide-rules
    private let elemhideMarkers = ["##", "#@#", "#?#", "#@?#"]
    
    // https://kb.adguard.com/en/general/how-to-create-your-own-ad-filters#cosmetic-css-rules
    private let cssMarkers = ["#$#", "#@$#", "#$?#", "#@$?#"]
    
    private let whitelistColor = UIColor(hexString: "35605F")
    private let elemhodeColor = UIColor(hexString: "5586C0")
    private let cssColor = UIColor(hexString: "3A669C")
    private let commentColor = UIColor(hexString: "6D6D6D")
    
    init(_ rule: String, _ selected: Bool, _ enabled: Bool, _ themeService: ThemeServiceProtocol) {
        self.rule = rule
        self.selected = selected
        self.enabled = enabled
        
        super.init()
        
        let ruleType = self.type(rule)
        
        let font = ruleType == .comment ? UIFont.italicSystemFont(ofSize: 15.0) : (UIFont(name: "PT Mono", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0))
        
        var color: UIColor?
        switch ruleType {
        case .whitelist:
            color = whitelistColor
        case .css:
            color = elemhodeColor
        case .cssException:
            color = cssColor
        case .comment:
            color = commentColor
        default:
            color = themeService.ruleTextColor
        }
        self.textColor = color!
        self.font = font
    }
    
    private func type(_ rule: String) -> RuleType {
        
        if rule.starts(with: commentPrefix) {
            return .comment
        }
        
        if rule.starts(with: whitelistPrefix) {
            return .whitelist
        }
        if elemhideMarkers.contains(where: { (marker) in return rule.contains(marker) }) {
            return .css
        }
        
        if cssMarkers.contains(where: { (marker) in return rule.contains(marker) }) {
            return .cssException
        }
        
        return .blacklist
    }
}
