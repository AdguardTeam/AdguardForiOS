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
@_implementationOnly import class ContentBlockerConverter.WebExtensionHelpers

public struct AllowlistRuleConverter: UserRuleConverterProtocol {

    public init() {}

    /*
     This function converts domain to allowlist rule @@||domain^$document
     If passed domain already contains '@@||' or '^$document' they won't be repeated
     */
    public func convertDomainToRule(_ domain: String) -> String {
        let helper = WebExtensionHelpers()
        return helper.convertDomainToAllowlistRule(domain)
    }

    /*
     This function converts rule with @@||domain^$document format to domain
     If passed rule doesn't contain '@@||' or '^$document'
     the function will return rule without modifying it
     */
    public func convertRuleToDomain(_ ruleText: String) -> String {
        let helper = WebExtensionHelpers()
        return helper.convertAllowlistRuleToDomain(ruleText)
    }

    /*
     Returns all converted rules joined by new line
     The result string looks like:
 
     @@||domain1^$document
     @@||domain2^$document
     @@||domain3^$document
     */
    public func convertRulesToString(_ rules: [UserRule]) -> String {
        return rules.map { convertDomainToRule($0.ruleText) }
                    .joined(separator: "\n")
    }
}
