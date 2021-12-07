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

import Foundation

enum UserRulesRedirectAction {
    case enableSiteProtection(domain: String, domainLevels: String)
    case disableSiteProtection(domain: String, domainLevels: String)
    case addToBlocklist(domain: String, domainLevels: String)
    case removeAllBlocklistRules(domain: String, domainLevels: String)

    var scheme: String {
        switch self {
        case .enableSiteProtection(_, _): return "\(Bundle.main.appScheme)://safariWebExtension?action=enableSiteProtection&domain="
        case .disableSiteProtection(_, _): return "\(Bundle.main.appScheme)://safariWebExtension?action=disableSiteProtection&domain="
        case .addToBlocklist(_, _): return "\(Bundle.main.appScheme)://safariWebExtension?action=addToBlocklist&domain="
        case .removeAllBlocklistRules(_, _): return "\(Bundle.main.appScheme)://safariWebExtension?action=removeAllBlocklistRules&domain="
        }
    }

    static func action(from actionString: String, domain: String, domainLevels: String) -> Self {
        switch actionString {
        case "enableSiteProtection": return .enableSiteProtection(domain: domain, domainLevels: domainLevels)
        case "disableSiteProtection": return .disableSiteProtection(domain: domain, domainLevels: domainLevels)
        case "addToBlocklist": return .addToBlocklist(domain: domain, domainLevels: domainLevels)
        case "removeAllBlocklistRules": return .removeAllBlocklistRules(domain: domain, domainLevels: domainLevels)
        default:
            assertionFailure("Undefined action=\(actionString) in scheme")
            return .enableSiteProtection(domain: "", domainLevels: "")
        }
    }
}
