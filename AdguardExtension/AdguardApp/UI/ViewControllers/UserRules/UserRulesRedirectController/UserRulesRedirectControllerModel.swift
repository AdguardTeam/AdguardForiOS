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
    var state: UserRulesRedirectController.State { get set }

    var title: String { get }
    var description: String { get }
    var icon: UIImage? { get }

    func processAction(_ onCbReloaded: @escaping (Error?) -> Void)
}

final class UserRulesRedirectControllerModel: UserRulesRedirectControllerModelProtocol {

    var state: UserRulesRedirectController.State = .processing

    var title: String { state.title }
    var description: String { state.getDescription(resources.invertedWhitelist) }
    var icon: UIImage? { action.getIcon(resources.invertedWhitelist) }

    private let action: UserRulesRedirectAction

    private let safariProtection: SafariProtectionProtocol
    private let resources: AESharedResourcesProtocol

    init(action: UserRulesRedirectAction, safariProtection: SafariProtectionProtocol, resources: AESharedResourcesProtocol) {
        self.action = action
        self.safariProtection = safariProtection
        self.resources = resources
    }

    func processAction(_ onCbReloaded: @escaping (Error?) -> Void) {
        switch action {
        case .disableSiteProtection(let domain):
            if resources.invertedWhitelist {
                try? safariProtection.removeRule(withText: domain, for: .invertedAllowlist, onCbReloaded: onCbReloaded)
            } else {
                let rule = UserRule(ruleText: domain, isEnabled: true)
                try? safariProtection.add(rule: rule, for: .allowlist, override: true, onCbReloaded: onCbReloaded)
            }
        case .enableSiteProtection(let domain):
            if resources.invertedWhitelist {
                let rule = UserRule(ruleText: domain, isEnabled: true)
                try? safariProtection.add(rule: rule, for: .invertedAllowlist, override: true, onCbReloaded: onCbReloaded)
            } else {
                try? safariProtection.removeRule(withText: domain, for: .allowlist, onCbReloaded: onCbReloaded)
            }
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

    func getDescription(_ allowlistIsInverted: Bool) -> String {
        switch self {
        case .processing: return String.localizedString("user_rules_processing_descr")
        case .done(let action): return action.getDescription(allowlistIsInverted)
        }
    }
}

// MARK: - UserRulesRedirectAction + Helper variables and methods

fileprivate extension UserRulesRedirectAction {
    var title: String {
        switch self {
        case .disableSiteProtection(let domain): return domain
        case .enableSiteProtection(let domain): return domain
        case .addToBlocklist(let domain): return domain
        case .removeAllBlocklistRules(let domain): return domain
        }
    }

    func getIcon(_ allowlistIsInverted: Bool) -> UIImage? {
        switch self {
        case .disableSiteProtection(_):
            if allowlistIsInverted {
                return UIImage(named: "kill_switch")
            } else {
                return UIImage(named: "thumbsup")
            }
        case .enableSiteProtection(_):
            if allowlistIsInverted {
                return UIImage(named: "thumbsup")
            } else {
                return UIImage(named: "kill_switch")
            }
        case .addToBlocklist(_): return UIImage(named: "ad_blocking_feature_logo")
        case .removeAllBlocklistRules(_): return UIImage(named: "kill_switch")
        }
    }

    func getDescription(_ allowlistIsInverted: Bool) -> String {
        let color = UIColor.AdGuardColor.lightGreen1
        let format: String
        switch self {
        case .disableSiteProtection(_):
            if allowlistIsInverted {
                format = String.localizedString("user_rules_allowlist_rule_removed")
            } else {
                format = String.localizedString("user_rules_allowlist_rule_added")
            }
        case .enableSiteProtection(_):
            if allowlistIsInverted {
                format = String.localizedString("user_rules_allowlist_rule_added")
            } else {
                format = String.localizedString("user_rules_allowlist_rule_removed")
            }
        case .addToBlocklist(_): format = String.localizedString("user_rules_blocklist_rule_added")
        case .removeAllBlocklistRules(_): format = String.localizedString("user_rules_blocklist_rules_removed")
        }
        return String(format: format, color.hex())
    }
}
