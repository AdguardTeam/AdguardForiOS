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

protocol DomainConverterProtocol {
    // converts blacklist domain to rule
    func userFilterBlockRuleFromDomain(_ domain: String) -> String
}

///  this class is responsible for converting domain names to dns user rules
final class DomainConverter: DomainConverterProtocol {

    private let blacklistPrefix = "||"
    private let blacklistSuffix = "^$important"

    func userFilterBlockRuleFromDomain(_ domain: String)->String {
        let trimmed = domain.hasSuffix(".") ? String(domain.dropLast()) : domain
        var rule = trimmed.hasPrefix(blacklistPrefix) ? trimmed : (blacklistPrefix + trimmed)
        rule = trimmed.hasSuffix(blacklistSuffix) ? rule : (rule + blacklistSuffix)
        return rule
    }
}
