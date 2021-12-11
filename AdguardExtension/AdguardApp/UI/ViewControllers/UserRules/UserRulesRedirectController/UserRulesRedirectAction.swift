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
    case enableSiteProtection(domain: String, absoluteDomainString: String)
    case disableSiteProtection(domain: String, absoluteDomainString: String)
    case addToBlocklist(domain: String, absoluteDomainString: String)
    case removeAllBlocklistRules(domain: String, absoluteDomainString: String)

    var scheme: String {
        switch self {
        case .enableSiteProtection(_, _): return "\(Bundle.main.inAppScheme)://safariWebExtension?action=enableSiteProtection&domain="
        case .disableSiteProtection(_, _): return "\(Bundle.main.inAppScheme)://safariWebExtension?action=disableSiteProtection&domain="
        case .addToBlocklist(_, _): return "\(Bundle.main.inAppScheme)://safariWebExtension?action=addToBlocklist&domain="
        case .removeAllBlocklistRules(_, _): return "\(Bundle.main.inAppScheme)://safariWebExtension?action=removeAllBlocklistRules&domain="
        }
    }

    static func action(from actionString: String, domain: String, absoluteDomainString: String) -> Self {
        switch actionString {
        case "enableSiteProtection": return .enableSiteProtection(domain: domain, absoluteDomainString: absoluteDomainString)
        case "disableSiteProtection": return .disableSiteProtection(domain: domain, absoluteDomainString: absoluteDomainString)
        case "addToBlocklist": return .addToBlocklist(domain: domain, absoluteDomainString: absoluteDomainString)
        case "removeAllBlocklistRules": return .removeAllBlocklistRules(domain: domain, absoluteDomainString: absoluteDomainString)
        default:
            assertionFailure("Undefined action=\(actionString) in scheme")
            return .enableSiteProtection(domain: "", absoluteDomainString: "")
        }
    }
}
