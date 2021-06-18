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

struct AllowlistRuleConverter: UserRuleConverterProtocol {
    
    private static let allowlistPrefix = "@@||"
    private static let allowlistSuffix = "^$document"
    
    /*
     This function converts domain to allowlist rule @@||domain^$document
     If passed domain already contains '@@||' or '^$document' they won't be repeated
     */
    func convertDomainToRule(_ domain: String) -> String {
        var rule = domain
        
        if !rule.hasPrefix(Self.allowlistPrefix) {
            rule = Self.allowlistPrefix + rule
        }
        
        if !rule.hasSuffix(Self.allowlistSuffix) {
            rule += Self.allowlistSuffix
        }
        
        return rule
    }
    
    /*
     This function converts rule with @@||domain^$document format to domain
     If passed rule doesn't contain '@@||' or '^$document'
     the function will return rule without modifying it
     */
    func convertRuleToDomain(_ ruleText: String) -> String {
        var domain = ruleText
        
        if domain.hasPrefix(Self.allowlistPrefix) {
            domain.removeFirst(Self.allowlistPrefix.count)
        }
        
        if domain.hasSuffix(Self.allowlistSuffix) {
            domain.removeLast(Self.allowlistSuffix.count)
        }
        
        return domain
    }
    
    /*
     Returns all converted rules joined by new line
     The result string looks like:
     
     @@||domain1^$document
     @@||domain2^$document
     @@||domain3^$document
     */
    func convertRulesToString(_ rules: [UserRuleProtocol]) -> String {
        return rules.map { convertDomainToRule($0.ruleText) }
                    .joined(separator: "/n")
    }
}
