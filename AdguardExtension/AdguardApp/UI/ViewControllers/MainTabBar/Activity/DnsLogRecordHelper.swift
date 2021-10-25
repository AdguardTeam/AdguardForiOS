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

import SharedAdGuardSDK
import DnsAdGuardSDK

/** this class is helper for DnsLogRecord  */
final class DnsLogRecordHelper {

    private let dnsProtection: DnsProtectionProtocol
    private let dnsTrackers: DnsTrackersProviderProtocol
    private let domainConverter: DomainConverterProtocol

    init(dnsProtection: DnsProtectionProtocol, dnsTrackers: DnsTrackersProviderProtocol, domainConverter: DomainConverterProtocol) {
        self.dnsProtection = dnsProtection
        self.dnsTrackers = dnsTrackers
        self.domainConverter = domainConverter
    }

    func addDomainToAllowlist(_ domain: String) throws {
        try dnsProtection.add(rule: UserRule(ruleText: domain), override: true, for: .allowlist)
    }

    func addDomainToUserRules(_ domain: String) throws {
        let rule = domainConverter.userFilterBlockRuleFromDomain(domain)
        try dnsProtection.add(rule: UserRule(ruleText: rule), override: true, for: .blocklist)
    }

    func removeDomainFromAllowlist(_ domain: String) throws {
        try dnsProtection.removeDomainFromAllowlist(domain)
    }

    func removeDomainFromUserRules(_ domain: String) throws {
        try dnsProtection.removeDomainFromUserFilter(domain)
    }

    func getUserFilterStatusForDomain(_ domain: String) -> UserFilterStatus {
        // we should check user rules for all domains
        let subdomains: [String] = String.generateSubDomains(from: domain)

        // check allowlist
        for subdomain in subdomains {
            if dnsProtection.checkEnabledRuleExists(subdomain, for: .allowlist) {
                return .allowlisted
            }
        }

        // check blocklist
        for subdomain in subdomains {
            let rule = domainConverter.userFilterBlockRuleFromDomain(subdomain)
            if dnsProtection.checkEnabledRuleExists(rule, for: .blocklist) {
                return .blocklisted
            }
        }

        return .none
    }
}
