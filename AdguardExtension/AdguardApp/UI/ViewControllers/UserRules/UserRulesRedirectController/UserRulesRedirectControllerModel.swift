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

import SharedAdGuardSDK
import SafariAdGuardSDK
import UIKit

protocol UserRulesRedirectControllerModelProtocol: AnyObject {
    var title: String { get }
    var description: String { get }
    var icon: UIImage? { get }
    func processAction()
}

final class UserRulesRedirectControllerModel: UserRulesRedirectControllerModelProtocol {

    var title: String { action.title }
    var description: String { action.getDescription(resources.invertedWhitelist) }
    var icon: UIImage? { action.getIcon(resources.invertedWhitelist) }

    private let action: UserRulesRedirectAction

    private let safariProtection: SafariProtectionProtocol
    private let resources: AESharedResourcesProtocol

    init(action: UserRulesRedirectAction, safariProtection: SafariProtectionProtocol, resources: AESharedResourcesProtocol) {
        self.action = action
        self.safariProtection = safariProtection
        self.resources = resources
    }

    func processAction() {
        switch action {
        case .disableSiteProtection(let domain, _):
            if resources.invertedWhitelist {
                try? safariProtection.removeRule(withText: domain, for: .invertedAllowlist, onCbReloaded: nil)
            } else {
                let rule = UserRule(ruleText: domain, isEnabled: true)
                try? safariProtection.add(rule: rule, for: .allowlist, override: true, onCbReloaded: nil)
            }
        case .enableSiteProtection(let domain, _):
            if resources.invertedWhitelist {
                let rule = UserRule(ruleText: domain, isEnabled: true)
                try? safariProtection.add(rule: rule, for: .invertedAllowlist, override: true, onCbReloaded: nil)
            } else {
                try? safariProtection.removeRule(withText: domain, for: .allowlist, onCbReloaded: nil)
            }
        case .addToBlocklist(let domain, _):
            let rule = UserRule(ruleText: domain, isEnabled: true)
            try? safariProtection.add(rule: rule, for: .blocklist, override: true, onCbReloaded: nil)
        case .removeAllBlocklistRules(let domain, _):
            safariProtection.removeAllUserRulesAssociatedWith(domain: domain, onCbReloaded: nil)
        }
    }
}

// MARK: - UserRulesRedirectAction + Helper variables and methods

fileprivate extension UserRulesRedirectAction {
    var title: String {
        switch self {
        case .disableSiteProtection(_, let domain): return domain
        case .enableSiteProtection(_, let domain): return domain
        case .addToBlocklist(_, let domain): return domain
        case .removeAllBlocklistRules(_, let domain): return domain
        }
    }

    func getIcon(_ allowlistIsInverted: Bool) -> UIImage? {
        switch self {
        case .disableSiteProtection(_, _):
            if allowlistIsInverted {
                return UIImage(named: "kill_switch")
            } else {
                return UIImage(named: "thumbsup")
            }
        case .enableSiteProtection(_, _):
            if allowlistIsInverted {
                return UIImage(named: "thumbsup")
            } else {
                return UIImage(named: "kill_switch")
            }
        case .addToBlocklist(_, _): return UIImage(named: "ad_blocking_feature_logo")
        case .removeAllBlocklistRules(_, _): return UIImage(named: "kill_switch")
        }
    }

    func getDescription(_ allowlistIsInverted: Bool) -> String {
        let color = UIColor.AdGuardColor.lightGreen1
        let format: String
        switch self {
        case .disableSiteProtection(_, _):
            if allowlistIsInverted {
                format = String.localizedString("user_rules_allowlist_rule_removed")
            } else {
                format = String.localizedString("user_rules_allowlist_rule_added")
            }
        case .enableSiteProtection(_, _):
            if allowlistIsInverted {
                format = String.localizedString("user_rules_allowlist_rule_added")
            } else {
                format = String.localizedString("user_rules_allowlist_rule_removed")
            }
        case .addToBlocklist(_, _): format = String.localizedString("user_rules_blocklist_rule_added")
        case .removeAllBlocklistRules(_, _): format = String.localizedString("user_rules_blocklist_rules_removed")
        }
        return String(format: format, color.hex())
    }
}
