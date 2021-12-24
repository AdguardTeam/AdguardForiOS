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

/**
 In app version less than 4.3 we've stored alllowlist and inverted allowlist rules in files
 They were encoded by objc NSKeyedArchiver
 Now they are stored in UserDefaults and encoded/decoded by JSONEncoder/Decoder
 These objects are wrappers for old rules objects
 They are responsible for decoding old objc objects into new swift objects
 */

protocol SDKSafariMigrationRule {
    var filterId: Int { get }
    var ruleText: String { get }
    var isEnabled: Bool { get }
    var affinity: Int? { get }
}

final class SDKSafariMigrationAllowlistRule: NSObject, NSCoding, SDKSafariMigrationRule {

    let filterId: Int
    let ruleId: Int
    let ruleText: String
    let isEnabled: Bool
    let affinity: Int?

    init(filterId: Int,
         ruleId: Int,
         ruleText: String,
         isEnabled: Bool,
         affinity: Int?) {

        self.filterId = filterId
        self.ruleId = ruleId
        self.ruleText = ruleText
        self.isEnabled = isEnabled
        self.affinity = affinity

        super.init()
    }

    // Encoder used only for tests
    func encode(with coder: NSCoder) {
        coder.encode(filterId as Any?, forKey: "filterId")
        coder.encode(ruleId as Any?, forKey: "ruleId")
        coder.encode(ruleText as Any?, forKey: "ruleText")
        coder.encode(isEnabled as Any?, forKey: "isEnabled")
        coder.encode(affinity as Any?, forKey: "affinity")
    }

    required convenience init?(coder: NSCoder) {
        guard let unarchivedFilterId = coder.decodeObject(forKey: "filterId") as? Int,
              let unarchivedRuleId = coder.decodeObject(forKey: "ruleId") as? Int,
              let unarchivedRuleText = coder.decodeObject(forKey: "ruleText") as? String,
              let unarchivedIsEnabled = coder.decodeObject(forKey: "isEnabled") as? Bool
        else { return nil }
        let unarchivedAffinity = coder.decodeObject(forKey: "affinity") as? Int

        // In version before 4.2 allowlist domains were saved as rules
        // If we don't remove old suffix and prefix the user will see rules in his list
        // Besides there will be a problem while converting rules
        // So this obsolete prefix and suffix must be removed
        var ruleText = unarchivedRuleText
        let obsoleteAllowlistPrefix = "@@||"
        let obsoleteAllowlistSuffix = "$document"
        if ruleText.hasPrefix(obsoleteAllowlistPrefix) && ruleText.hasSuffix(obsoleteAllowlistSuffix) {
            ruleText.removeFirst(obsoleteAllowlistPrefix.count)
            ruleText.removeLast(obsoleteAllowlistSuffix.count)
        }

        self.init(filterId: unarchivedFilterId,
                  ruleId: unarchivedRuleId,
                  ruleText: ruleText,
                  isEnabled: unarchivedIsEnabled,
                  affinity: unarchivedAffinity)
    }
}

final class SDKSafariMigrationInvertedAllowlistDomainObject: NSObject, NSCoding {

    let rules: [SDKSafariMigrationAllowlistRule]

    init(rules: [SDKSafariMigrationAllowlistRule]) {
        self.rules = rules
        super.init()
    }

    // Encoder used only for tests
    func encode(with coder: NSCoder) {
        coder.encode(rules, forKey: "rules")
    }

    required convenience init?(coder: NSCoder) {
        guard let unarchivedRules = coder.decodeObject(forKey: "rules") as? [SDKSafariMigrationAllowlistRule] else { return nil }
        self.init(rules: unarchivedRules)
    }
}
