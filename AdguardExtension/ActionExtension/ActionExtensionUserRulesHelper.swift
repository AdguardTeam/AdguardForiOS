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

import SafariAdGuardSDK
import SharedAdGuardSDK

// TODO: - We should write tests for it

/// This object is a helper for `ActionExtensionTableController` to interact with user rules objects
/// It is the key logic of the extension and it can be tested
struct ActionExtensionUserRulesHelper {

    private let domain: String
    private let safariProtection: SafariProtectionUserRulesProtocol & SafariProtectionContentBlockersProtocol

    init(domain: String, safariProtection: SafariProtectionUserRulesProtocol & SafariProtectionContentBlockersProtocol) {
        self.domain = domain
        self.safariProtection = safariProtection
    }

    func addDomainToAllowlist() -> (success: Bool, overlimit: Bool) {
        let isOverlimit = self.isOverlimit()
        if isOverlimit {
            return (false, isOverlimit)
        }

        let rule = UserRule(ruleText: domain, isEnabled: true)

        do {
            let group = DispatchGroup()
            group.enter()
            try safariProtection.add(rule: rule, for: .allowlist, override: true) { _ in
                group.leave()
            }
            group.wait()
            return (true, isOverlimit)
        }
        catch {
            return (false, isOverlimit)
        }
    }

    func removeDomainFromAllowlist() -> Bool {
        do {
            let group = DispatchGroup()
            group.enter()
            try safariProtection.removeRule(withText: domain, for: .allowlist) { _ in
                group.leave()
            }
            group.wait()
            return true
        }
        catch {
            return false
        }
    }

    func addDomainToInvertedAllowlist() -> (success: Bool, overlimit: Bool) {
        let isOverlimit = self.isOverlimit()
        if isOverlimit {
            return (false, isOverlimit)
        }

        let rule = UserRule(ruleText: domain, isEnabled: true)

        do {
            let group = DispatchGroup()
            group.enter()
            try safariProtection.add(rule: rule, for: .invertedAllowlist, override: true) { _ in
                group.leave()
            }
            group.wait()
            return (true, isOverlimit)
        }
        catch {
            return (false, isOverlimit)
        }
    }

    func removeDomainFromInvertedAllowlist() -> Bool {
        do {
            let group = DispatchGroup()
            group.enter()
            try safariProtection.removeRule(withText: domain, for: .invertedAllowlist) { _ in
                group.leave()
            }
            group.wait()
            return true
        }
        catch {
            return false
        }
    }

    /// There is a limit of available CB rules, for iOS 15 and later it is 150K and 50k for older ones
    /// User rules are placed in every CB, so if one CB is overlimited than we suppose that it is overlimited in general
    private func isOverlimit() -> Bool {
        let converterResults = safariProtection.allConverterResults
        let isOverLimit = converterResults.reduce(false, { $0 || $1.result.overlimit })
        return isOverLimit
    }
}
