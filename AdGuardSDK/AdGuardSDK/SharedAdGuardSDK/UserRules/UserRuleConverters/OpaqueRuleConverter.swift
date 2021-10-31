///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import Foundation

public struct OpaqueRuleConverter: UserRuleConverterProtocol {

    public init() {}

    /*
     This functions do nothing.
     Blocklist, DNS blocklist and allowlist rules are not modified by ourselves
     Blocklist syntax can be rather complicated and
     we suppose that user provided the correct rule
     */

    public func convertDomainToRule(_ domain: String) -> String {
        return domain
    }

    public func convertRuleToDomain(_ rule: String) -> String {
        return rule
    }

    /* Returns all converted rules joined by new line */
    public func convertRulesToString(_ rules: [UserRule]) -> String {
        return rules.map { $0.ruleText }
                    .joined(separator: "\n")
    }
}
