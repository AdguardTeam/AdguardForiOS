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

final class SafariUserRulesTableModel: UserRulesTableModelProtocol {
    
    // MARK: - Internal properties
    
    weak var delegate: UserRulesTableModelDelegate?
    
    var title: String { type.title }
    
    var description: String { type.description }
    
    var isEnabled: Bool {
        get {
            switch type {
            case .blocklist: return resources.safariUserFilterEnabled
            case .allowlist, .invertedAllowlist: return resources.safariWhitelistEnabled
            }
        }
        set {
            switch type {
            case .blocklist: resources.safariUserFilterEnabled = newValue
            case .allowlist, .invertedAllowlist: resources.safariWhitelistEnabled = newValue
            }
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            guard isEditing != oldValue else { return }
            for i in 0..<rulesModels.count {
                rulesModels[i].isEditing = isEditing
            }
        }
    }
    
    var icon: UIImage? { type.icon }
    
    var rulesModels: [UserRuleCellModel]
    
    // MARK: - Private properties
    
    private let type: SafariUserRuleType
    private let safariProtection: SafariProtectionProtocol
    private let resources: AESharedResourcesProtocol
    
    // MARK: - Initialization
    
    init(type: SafariUserRuleType, safariProtection: SafariProtectionProtocol, resources: AESharedResourcesProtocol) {
        self.type = type
        self.safariProtection = safariProtection
        self.resources = resources
        self.rulesModels = safariProtection.allRules(for: type).map { UserRuleCellModel(rule: $0.ruleText, isEnabled: $0.isEnabled, isSelected: false, isEditing: false) }
    }
    
    // MARK: - Internal methods
    
    func addRule(_ ruleText: String) throws {
        let rule = UserRule(ruleText: ruleText, isEnabled: true)
        try safariProtection.add(rule: rule, for: type, override: false, onCbReloaded: nil)
        let model = UserRuleCellModel(rule: ruleText, isEnabled: true, isSelected: false, isEditing: isEditing)
        rulesModels.append(model)
        delegate?.ruleSuccessfullyAdded()
    }
    
    func ruleStateChanged(_ rule: String, newState: Bool) {
        do {
            let newRule = UserRule(ruleText: rule, isEnabled: newState)
            try safariProtection.modifyRule(rule, newRule, for: type, onCbReloaded: nil)
        }
        catch {
            DDLogError("(SafariUserRulesTableModel) - ruleStateChanged; Error: \(error)")
        }
    }
}

// MARK: - SafariUserRuleType + helper variables

fileprivate extension SafariUserRuleType {
    var title: String {
        switch self {
        case .blocklist: return String.localizedString("safari_userfilter_title")
        case .allowlist: return String.localizedString("whitelist_title")
        case .invertedAllowlist: return String.localizedString("inverted_whitelist_title")
        }
    }
    
    var description: String {
        let url = UIApplication.shared.adguardUrl(action: "filter_rules", from: "user_filter", buildVersion: ADProductInfo().buildVersion())
        switch self {
        case .blocklist:
            let format = String.localizedString("blacklist_text_format")
            return String(format: format, url)
        case .allowlist:
            let format = String.localizedString("whitelist_text")
            return String(format: format, url)
        case .invertedAllowlist:
            let format = String.localizedString("inverted_whitelist_text")
            return String(format: format, url)
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .blocklist: return UIImage(named: "user")
        case .allowlist, .invertedAllowlist: return UIImage(named: "thumbsup")
        }
    }
}
