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

protocol UserRuleProtocol {
    associatedtype Converter: UserRuleConverterProtocol
    
    /* Domain is a string that user did enter in the rule field */
    var domain: String { get set }
    
    /*
     We create rule from domain by ourselves
     If domain is already a rule than we won't modify it
     */
    var rule: String { get }
    
    /* State of rule */
    var isEnabled: Bool { get set }
}

struct UserRule<Converter: UserRuleConverterProtocol>: UserRuleProtocol {
    var rule: String
    var domain: String
    var isEnabled: Bool
    
    init(domain: String, isEnabled: Bool = true) {
        self.rule = Converter.convertDomainToRule(domain)
        self.domain = domain
        self.isEnabled = isEnabled
    }
}
