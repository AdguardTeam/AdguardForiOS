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

protocol UserRulesRedirectControllerModelProtocol: AnyObject {
    var action: UserRulesRedirectAction { get set }
    var state: UserRulesRedirectController.State { get set }
    
    var title: String { get }
    var description: String { get }
    var icon: UIImage? { get }
    
    func processAction(_ onCbReloaded: @escaping (Error?) -> Void)
}

final class UserRulesRedirectControllerModel: UserRulesRedirectControllerModelProtocol {
    
    var action: UserRulesRedirectAction = .addToAllowlist(domain: "domain.com")
    var state: UserRulesRedirectController.State = .processing
    
    var title: String { state.title }
    var description: String { state.description }
    var icon: UIImage? { action.icon }
    
    private let safariProtection: SafariProtectionProtocol
    
    init(safariProtection: SafariProtectionProtocol) {
        self.safariProtection = safariProtection
    }
    
    func processAction(_ onCbReloaded: @escaping (Error?) -> Void) {
        switch action {
        case .removeFromAllowlist(let domain):
            try? safariProtection.removeRule(withText: domain, for: .allowlist, onCbReloaded: onCbReloaded)
        case .addToAllowlist(let domain):
            let rule = UserRule(ruleText: domain, isEnabled: true)
            try? safariProtection.add(rule: rule, for: .allowlist, override: true, onCbReloaded: onCbReloaded)
        case .addToBlocklist(let domain):
            let rule = UserRule(ruleText: domain, isEnabled: true)
            try? safariProtection.add(rule: rule, for: .blocklist, override: true, onCbReloaded: onCbReloaded)
        case .removeAllBlocklistRules(let domain):
            safariProtection.removeAllUserRulesAssociatedWith(domain: domain, onCbReloaded: onCbReloaded)
        }
    }
}

// MARK: - UserRulesRedirectController.State + Helper variables

fileprivate extension UserRulesRedirectController.State {
    var title: String {
        switch self {
        case .processing: return String.localizedString("user_rules_processing_title")
        case .done(let action): return action.title
        }
    }
    
    var description: String {
        switch self {
        case .processing: return String.localizedString("user_rules_processing_descr")
        case .done(let action): return action.description
        }
    }
}

// MARK: - UserRulesRedirectAction + Helper variables and methods

fileprivate extension UserRulesRedirectAction {
    var title: String {
        switch self {
        case .removeFromAllowlist(let domain): return domain
        case .addToAllowlist(let domain): return domain
        case .addToBlocklist(let domain): return domain
        case .removeAllBlocklistRules(let domain): return domain
        }
    }
    
    var description: String {
        let color = UIColor.AdGuardColor.lightGreen1
        let format: String
        switch self {
        case .removeFromAllowlist(_): format = String.localizedString("user_rules_allowlist_rule_removed")
        case .addToAllowlist(_): format = String.localizedString("user_rules_allowlist_rule_added")
        case .addToBlocklist(_): format = String.localizedString("user_rules_blocklist_rule_added")
        case .removeAllBlocklistRules(_): format = String.localizedString("user_rules_blocklist_rules_removed")
        }
        return String(format: format, color.hex())
    }
    
    var icon: UIImage? {
        switch self {
        case .removeFromAllowlist(_): return UIImage(named: "kill_switch")
        case .addToAllowlist(_): return UIImage(named: "thumbsup")
        case .addToBlocklist(_): return UIImage(named: "ad_blocking_feature_logo")
        case .removeAllBlocklistRules(_): return UIImage(named: "kill_switch")
        }
    }
}
