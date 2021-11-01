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
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import Foundation
import enum SharedAdGuardSDK.CommonError

protocol SafariProtectionAllowlistRulesMigrationHelperProtocol: AnyObject {
    /// Returns swift allowlist rules objects from obsolete rules objects
    func getAllowlistRules() throws -> [SDKSafariMigrationRule]

    /// Returns swift inverted allowlist rules objects from obsolete rules objects
    func getInvertedAllowlistRules() throws -> [SDKSafariMigrationRule]

    /// Removes old files where allowlist rules used to store
    func removeOldRuleFiles() throws
}

/// This object is a helper for `SDKMigrationServiceHelper`
/// It is responsible for providing old allowlist and inverted allowlist rules objects and removing obsolete files
final class SafariProtectionAllowlistRulesMigrationHelper: SafariProtectionAllowlistRulesMigrationHelperProtocol {

    private let rulesContainerDirectoryPath: String // Directory path where old allowlist rules files are saved

    /* File names where allowlist and inverted allowlist rules were stored */
    private let oldSafariInvertedAllowListRulesFileName = "safari-inverdet-whitelist-rules.data" // Exactly inverDet, don't fix it
    private let oldSafariAllowListRulesFileName = "safari-whitelist-rules.data"

    private let fileManager = FileManager.default

    init(rulesContainerDirectoryPath: String) {
        self.rulesContainerDirectoryPath = rulesContainerDirectoryPath

        NSKeyedUnarchiver.setClass(SDKSafariMigrationAllowlistRule.self, forClassName: "ASDFilterRule")
        NSKeyedUnarchiver.setClass(SDKSafariMigrationInvertedAllowlistDomainObject.self, forClassName: "AEInvertedWhitelistDomainsObject")
    }

    func getAllowlistRules() throws -> [SDKSafariMigrationRule] {
        DDLogInfo("(SafariProtectionAllowlistRulesMigrationHelper) - Start fetching data from allowlist rule file")
        let url = URL(fileURLWithPath: rulesContainerDirectoryPath).appendingPathComponent(oldSafariAllowListRulesFileName)
        guard fileManager.fileExists(atPath: url.path) else {
            DDLogWarn("(SafariProtectionAllowlistRulesMigrationHelper) -  allowlist rules file doesn't exist")
            return []
        }

        let data = try Data(contentsOf: url)
            guard let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [SDKSafariMigrationAllowlistRule] else {
            DDLogWarn("(SafariProtectionAllowlistRulesMigrationHelper) - NSKeyedUnarchiver return nil data for allowlist rules file")
            return []
        }

        DDLogInfo("(SafariProtectionAllowlistRulesMigrationHelper) - Allowlist data successfully fetched, rules count: \(result.count)")
        return result
    }

    func getInvertedAllowlistRules() throws -> [SDKSafariMigrationRule] {
        DDLogInfo("(SafariProtectionAllowlistRulesMigrationHelper) - Start fetching data from inverted allowlist rules file")
        let url = URL(fileURLWithPath: rulesContainerDirectoryPath).appendingPathComponent(oldSafariInvertedAllowListRulesFileName)
        guard fileManager.fileExists(atPath: url.path) else {
            DDLogWarn("(SafariProtectionAllowlistRulesMigrationHelper) -  inverted allowlist rules file doesn't exist")
            return []
        }

        let data = try Data(contentsOf: url)
        guard let result = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? SDKSafariMigrationInvertedAllowlistDomainObject else {
            DDLogWarn("(SafariProtectionAllowlistRulesMigrationHelper) - NSKeyedUnarchiver return nil data for inverted allowlist rules file")
            return []
        }

        DDLogInfo("(SafariProtectionAllowlistRulesMigrationHelper) - Inverted allowlist data successfully fetched, rules count: \(result.rules.count)")
        return result.rules
    }

    func removeOldRuleFiles() throws {
        DDLogInfo("(SafariProtectionAllowlistRulesMigrationHelper) - Start removing rule files")

        let invertedAllowlistRulesFileUrl = URL(fileURLWithPath: rulesContainerDirectoryPath).appendingPathComponent(oldSafariInvertedAllowListRulesFileName)
        let allowlistRulesFileUrl = URL(fileURLWithPath: rulesContainerDirectoryPath).appendingPathComponent(oldSafariAllowListRulesFileName)

        if fileManager.fileExists(atPath: invertedAllowlistRulesFileUrl.path) {
            try fileManager.removeItem(atPath: invertedAllowlistRulesFileUrl.path)
        }

        if fileManager.fileExists(atPath: allowlistRulesFileUrl.path) {
            try fileManager.removeItem(atPath: allowlistRulesFileUrl.path)
        }
    }
}
