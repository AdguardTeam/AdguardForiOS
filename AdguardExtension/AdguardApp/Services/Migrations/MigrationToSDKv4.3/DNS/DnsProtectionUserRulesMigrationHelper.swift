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

/// This object is a helper for `SDKMigrationServiceHelper`
/// It is responsible for providing DNS allowlist and blocklist rules migration
/// And removing obsolete files
protocol DnsProtectionUserRulesMigrationHelperProtocol: AnyObject {
    /// Moves DNS allowlist and blocklist rules content to new files
    func moveOldDnsUserRulesToNewFiles() throws

    /// Removes files where DNS allowlist and blocklist rules used to be saved
    func removeOldDnsUserRulesFiles() throws
}

/// Implementation of `DnsProtectionUserRulesMigrationHelperProtocol`
final class DnsProtectionUserRulesMigrationHelper: DnsProtectionUserRulesMigrationHelperProtocol {

    private let oldDnsUserRulesContainerFolderUrl: URL
    private let newDnsUserRulesContainerFolderUrl: URL

    init(
        oldDnsUserRulesContainerFolderUrl: URL,
        newDnsUserRulesContainerFolderUrl: URL
    ) {
        self.oldDnsUserRulesContainerFolderUrl = oldDnsUserRulesContainerFolderUrl
        self.newDnsUserRulesContainerFolderUrl = newDnsUserRulesContainerFolderUrl
    }

    /**
     In App version 4.2 and earlier DNS allowlist and blocklists rules were stored in files with name `dns_filter_\(id).txt`
     Now they are stored as `\(id).txt`
     What is more a new feature(enable/disable DNS user rules) was implemented and now we need 2 files for user rules filter
     Besides custom DNS filters ids have changed
     It was so:
        blocklistFilterId = 1
        allowlistFilterId = 2
        customDnsFilters = 3+
     It is now:
        customFilters = 0…10000
        enabledBlocklist = 10001
        enabledAllowlist = 10002
        allRulesBlocklist = 10003
        allRulesAllowlist = 10004
     */
    func moveOldDnsUserRulesToNewFiles() throws {
        DDLogInfo("(DnsProtectionUserRulesMigrationHelper) - moveOldDnsUserRulesToNewFiles; Migrating DNS blocklist rules")
        try migrateBlocklistRules()
        DDLogInfo("(DnsProtectionUserRulesMigrationHelper) - moveOldDnsUserRulesToNewFiles; Migrated DNS blocklist rules")

        DDLogInfo("(DnsProtectionUserRulesMigrationHelper) - moveOldDnsUserRulesToNewFiles; Migrating DNS allowlist rules")
        try migrateAllowlistRules()
        DDLogInfo("(DnsProtectionUserRulesMigrationHelper) - moveOldDnsUserRulesToNewFiles; Migrated DNS allowlist rules")
    }

    func removeOldDnsUserRulesFiles() throws {
        DDLogInfo("(DnsProtectionUserRulesMigrationHelper) - removeOldDnsUserRulesFiles; Removing old DNS user rules files")

        let oldDnsBlocklistFileUrl = oldDnsUserRulesContainerFolderUrl.appendingPathComponent("dns_filter_1.txt")
        let oldDnsAllowlistFileUrl = oldDnsUserRulesContainerFolderUrl.appendingPathComponent("dns_filter_2.txt")

        // Files can not exist
        if FileManager.default.fileExists(atPath: oldDnsBlocklistFileUrl.path) {
            try FileManager.default.removeItem(at: oldDnsBlocklistFileUrl)
        }
        if FileManager.default.fileExists(atPath: oldDnsAllowlistFileUrl.path) {
            try FileManager.default.removeItem(at: oldDnsAllowlistFileUrl)
        }

        DDLogInfo("(DnsProtectionUserRulesMigrationHelper) - removeOldDnsUserRulesFiles; Removed old DNS user rules files")
    }

    // MARK: - Private methods

    private func migrateBlocklistRules() throws {
        let oldDnsBlocklistFileUrl = oldDnsUserRulesContainerFolderUrl.appendingPathComponent("dns_filter_1.txt")
        let newAllDnsBlocklistRulesFileUrl = newDnsUserRulesContainerFolderUrl.appendingPathComponent("10004.txt")
        let newEnabledDnsBlocklistRulesFileUrl = newDnsUserRulesContainerFolderUrl.appendingPathComponent("10002.txt")

        if let oldDnsBlocklistContent = try? String(contentsOf: oldDnsBlocklistFileUrl).trimmingCharacters(in: .whitespacesAndNewlines) {
            try oldDnsBlocklistContent.write(to: newAllDnsBlocklistRulesFileUrl, atomically: true, encoding: .utf8)
            try oldDnsBlocklistContent.write(to: newEnabledDnsBlocklistRulesFileUrl, atomically: true, encoding: .utf8)
        }
    }

    private func migrateAllowlistRules() throws {
        let oldDnsAllowlistFileUrl = oldDnsUserRulesContainerFolderUrl.appendingPathComponent("dns_filter_2.txt")
        let newAllDnsAllowlistRulesFileUrl = newDnsUserRulesContainerFolderUrl.appendingPathComponent("10003.txt")
        let newEnabledDnsAllowlistRulesFileUrl = newDnsUserRulesContainerFolderUrl.appendingPathComponent("10001.txt")

        if let oldDnsAllowlistContent = try? String(contentsOf: oldDnsAllowlistFileUrl) {
            let domainsString = createDomainsFromObsoleteAllowlistRules(oldDnsAllowlistContent)
            try domainsString.write(to: newAllDnsAllowlistRulesFileUrl, atomically: true, encoding: .utf8)
            try domainsString.write(to: newEnabledDnsAllowlistRulesFileUrl, atomically: true, encoding: .utf8)
        }
    }

    /**
     In version before 4.2 DNS allowlist domains were saved as rules
     If we don't remove old suffix and prefix the user will see rules in his list
     Besides there will be a problem while converting rules
     So this obsolete prefix and suffix must be removed
     */
    private func createDomainsFromObsoleteAllowlistRules(_ rulesString: String) -> String {
        let rules = rulesString.split(separator: "\n")
        let domains: [String] = rules.map {
            let prefix = "@@||"
            let suffix = "^|$important"
            if $0.hasPrefix(prefix) && $0.hasSuffix(suffix) {
                var oldRule = $0
                oldRule.removeFirst(prefix.count)
                oldRule.removeLast(suffix.count)
                return String(oldRule)
            }
            return String($0)
        }
        return domains.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
