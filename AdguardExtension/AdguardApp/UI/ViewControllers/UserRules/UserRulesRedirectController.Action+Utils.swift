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

enum UserRulesRedirectAction {
    case removeFromAllowlist(domain: String)
    case addToAllowlist(domain: String)
    case addToBlocklist(domain: String)
    case removeAllBlocklistRules(domain: String)
    
    var scheme: String {
        switch self {
        case .removeFromAllowlist(let domain): return "\(Bundle.main.appScheme)://safariWebExtension?action=removeFromAllowlist&domain=\(domain)"
        case .addToAllowlist(let domain): return "\(Bundle.main.appScheme)://safariWebExtension?action=addToAllowlist&domain=\(domain)"
        case .addToBlocklist(let domain): return "\(Bundle.main.appScheme)://safariWebExtension?action=addToBlocklist&domain=\(domain)"
        case .removeAllBlocklistRules(let domain): return "\(Bundle.main.appScheme)://safariWebExtension?action=removeAllBlocklistRules&domain=\(domain)"
        }
    }
    
    static func action(from actionString: String, domain: String) -> Self {
        switch actionString {
        case "removeFromAllowlist": return .removeFromAllowlist(domain: domain)
        case "addToAllowlist": return .addToAllowlist(domain: domain)
        case "addToBlocklist": return .addToBlocklist(domain: domain)
        case "removeAllBlocklistRules": return .removeAllBlocklistRules(domain: domain)
        default:
            assertionFailure("Undefined action=\(actionString) in scheme")
            return .removeFromAllowlist(domain: "")
        }
    }
}
