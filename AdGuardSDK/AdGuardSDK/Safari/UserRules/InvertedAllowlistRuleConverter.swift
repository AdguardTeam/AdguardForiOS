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
import class ContentBlockerConverter.WebExtensionHelpers

public struct InvertedAllowlistRuleConverter: UserRuleConverterProtocol {

    private static let invertedAllowlistPrefix = "~"

    public init() {}

    /*
     This function converts domain to inverted allowlist rule ~domain
     If passed domain already contains '~' it won't be repeated
     */
    public func convertDomainToRule(_ domain: String) -> String {
        let helper = WebExtensionHelpers()
        return helper.convertDomainToInvertedAllowlistRule(domain)
    }

    /*
     This function converts rule with ~domain format to domain
     If passed rule doesn't contain '~' prefix the function will return rule without modifying it
     */
    public func convertRuleToDomain(_ rule: String) -> String {
        let helper = WebExtensionHelpers()
        return helper.convertInvertedAllowlistRuleToDomain(rule)
    }

    /*
     This function returns all converted rules separated by '|'
     The result rule must start with '@@||*$document,domain='
     So the result looks like: @@||*$document,domain=~domain1|~domain2|~domain3
     If rules are empty the result rule will look like this: @@||*$document
     */
    public func convertRulesToString(_ rules: [UserRule]) -> String {
        return rules.map { convertDomainToRule($0.ruleText) }
                    .joined(separator: "\n")
    }
}
