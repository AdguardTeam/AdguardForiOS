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

import SharedAdGuardSDK
import SafariAdGuardSDK
import DnsAdGuardSDK

protocol SDKMigrationServiceHelperProtocol: AnyObject {
    func migrate() throws
}

/// This object is a helper for `MigrationService`
/// It is responsible for migrating data to new storages our SDK uses
/// We've started to use AdGuard SDK in v4.3
final class SDKMigrationServiceHelper: SDKMigrationServiceHelperProtocol {

    private let safariProtection: SafariProtectionMigrationsProtocol
    private let filtersDbMigration: SafariProtectionFiltersDatabaseMigrationHelperProtocol
    private let allowlistRulesMigration: SafariProtectionAllowlistRulesMigrationHelperProtocol
    private let customFiltersMigration: SafariProtectionCustomFiltersMigrationHelperProtocol
    private let dnsFiltersMigration: DnsProtectionFiltersMigrationHelperProtocol
    private let dnsRulesMigration: DnsProtectionUserRulesMigrationHelperProtocol
    private let dnsProvidersMigration: DnsProtectionCustomProvidersMigrationHelperProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let lowLevelSettingsMigration: LowlevelSettingsMigrationHelperProtocol
    private let dnsStatisticsMigration: DnsStatisticsMigrationHelperProtocol

    init(
        safariProtection: SafariProtectionMigrationsProtocol,
        filtersDbMigration: SafariProtectionFiltersDatabaseMigrationHelperProtocol,
        allowlistRulesMigration: SafariProtectionAllowlistRulesMigrationHelperProtocol,
        customFiltersMigration: SafariProtectionCustomFiltersMigrationHelperProtocol,
        dnsFiltersMigration: DnsProtectionFiltersMigrationHelperProtocol,
        dnsRulesMigration: DnsProtectionUserRulesMigrationHelperProtocol,
        dnsProvidersMigration: DnsProtectionCustomProvidersMigrationHelperProtocol,
        dnsProvidersManager: DnsProvidersManagerProtocol,
        lowLevelSettingsMigration: LowlevelSettingsMigrationHelperProtocol,
        dnsStatisticsMigration: DnsStatisticsMigrationHelperProtocol
    ) {
        self.safariProtection = safariProtection
        self.filtersDbMigration = filtersDbMigration
        self.allowlistRulesMigration = allowlistRulesMigration
        self.customFiltersMigration = customFiltersMigration
        self.dnsFiltersMigration = dnsFiltersMigration
        self.dnsRulesMigration = dnsRulesMigration
        self.dnsProvidersMigration = dnsProvidersMigration
        self.dnsProvidersManager = dnsProvidersManager
        self.lowLevelSettingsMigration = lowLevelSettingsMigration
        self.dnsStatisticsMigration = dnsStatisticsMigration
    }

    func migrate() throws {
        try migrateSafariProtection()
        try migrateDnsProtection()
        try migrateDnsStatistics()
    }

    private func migrateSafariProtection() throws {
        /* Rules migration */
        let userRules = try filtersDbMigration.getUserRules()
        let allowlistRules = try allowlistRulesMigration.getAllowlistRules()
        let invertedAllowlistRules = try allowlistRulesMigration.getInvertedAllowlistRules()

        try migrate(userRules: userRules, for: .blocklist)
        try migrate(userRules: allowlistRules, for: .allowlist)
        try migrate(userRules: invertedAllowlistRules, for: .invertedAllowlist)

        /* DB migration */
        let customFilters = try filtersDbMigration.getCustomFilters()
        try customFiltersMigration.migrateCustomFilters(customFilters)

        let groupStates = try filtersDbMigration.getGroupsStates()
        try groupStates.forEach {
            if let groupType = SafariGroup.GroupType(rawValue: $0.groupId) {
                try safariProtection.setGroup(groupType, enabled: $0.isEnabled)
            }
        }

        let filtersStates = try filtersDbMigration.getFiltersStates()
        try filtersStates.forEach { try safariProtection.setFilter(withId: $0.filterId, $0.groupId, enabled: $0.isEnabled) }

        try safariProtection.reinitializeGroupsAndFilters()

        /* Remove old files */
        try allowlistRulesMigration.removeOldRuleFiles()
        try filtersDbMigration.removeOldDBFiles()

        safariProtection.convertFiltersAndReloadCbs(onCbReloaded: nil)
    }

    private func migrateDnsProtection() throws {
        /* DNS filters migration */
        let oldDnsFilters = dnsFiltersMigration.getDnsFiltersMeta()
        try dnsFiltersMigration.saveDnsFiltersToSDK(oldDnsFilters)
        try dnsFiltersMigration.replaceFilesForDnsFilters(with: oldDnsFilters.map { $0.id })
        dnsFiltersMigration.removeDnsFiltersDataFromOldStorage()

        /* DNS rules migration */
        try dnsRulesMigration.moveOldDnsUserRulesToNewFiles()
        try dnsRulesMigration.removeOldDnsUserRulesFiles()

        /* Custom DNS providers migration */
        let customDnsProviders = dnsProvidersMigration.getCustomDnsProviders()
        try dnsProvidersMigration.saveCustomDnsProviders(customDnsProviders)

        try dnsProvidersMigration.selectActiveDnsServer()
        dnsProvidersMigration.removeOldCustomDnsProvidersData()

        lowLevelSettingsMigration.migrateCustomBlockingIps()
    }

    private func migrate(userRules: [SDKSafariMigrationRule], for type: SafariUserRuleType) throws {
        let rules = userRules.map { UserRule(ruleText: $0.ruleText, isEnabled: $0.isEnabled) }
        try safariProtection.add(rules: rules, for: type, override: true)
    }

    private func migrateDnsStatistics() throws {
        try dnsStatisticsMigration.removeOldRequestLogDatabase()
        try dnsStatisticsMigration.migrateStatistics()
        try dnsStatisticsMigration.migrateActivity()
        try dnsStatisticsMigration.removeOldStatisticsDatabase()
    }
}
