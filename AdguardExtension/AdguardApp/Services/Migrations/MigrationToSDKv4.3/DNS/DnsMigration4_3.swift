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
import DnsAdGuardSDK
import SharedAdGuardSDK

protocol DnsMigration4_3Protocol {
    func migrate()
}

class DnsMigration4_3: DnsMigration4_3Protocol {

    private let resources: AESharedResourcesProtocol
    private let stateManager: MigrationStateManagerProtocol
    private let dnsFiltersMigration: DnsProtectionFiltersMigrationHelperProtocol
    private let dnsRulesMigration: DnsProtectionUserRulesMigrationHelperProtocol
    private let dnsProvidersMigration: DnsProtectionCustomProvidersMigrationHelperProtocol
    private let lowLevelSettingsMigration: LowlevelSettingsMigrationHelperProtocol
    private let dnsStatisticsMigration: DnsStatisticsMigrationHelperProtocol

    init(resources: AESharedResourcesProtocol, dnsProvidersManager: DnsProvidersManagerProtocol) {
        self.resources = resources

        dnsFiltersMigration = DnsProtectionFiltersMigrationHelper(
            oldDnsFiltersContainerFolderUrl: resources.sharedResuorcesURL(),
            newDnsFiltersContainerFolderUrl: SharedStorageUrls().dnsFiltersFolderUrl,
            resources: resources
        )

        dnsRulesMigration = DnsProtectionUserRulesMigrationHelper(
            oldDnsUserRulesContainerFolderUrl: resources.sharedResuorcesURL(),
            newDnsUserRulesContainerFolderUrl: SharedStorageUrls().dnsFiltersFolderUrl
        )

        dnsProvidersMigration = DnsProtectionCustomProvidersMigrationHelper(resources: resources, dnsProvidersManager: dnsProvidersManager)

        lowLevelSettingsMigration = LowlevelSettingsMigrationHelper(resources: resources)

        dnsStatisticsMigration = DnsStatisticsMigrationHelper(oldContainerFolderUrl: resources.sharedResuorcesURL(), newContainerDbUrl: SharedStorageUrls().statisticsFolderUrl)

        stateManager = MigrationStateManager(resources: resources, migrationKey: "Dns4_3MigrationKey")
    }

    func migrate() {

        if stateManager.state == .notStarted {
            stateManager.start()

            do {
                try migrateDnsProtection()
                try migrateDnsStatistics()
                stateManager.finish()
            }
            catch {
                stateManager.failure()
            }
        }
    }

    // MARK: - private methods

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

    private func migrateDnsStatistics() throws {
        try dnsStatisticsMigration.removeOldRequestLogDatabase()
        try dnsStatisticsMigration.migrateStatistics()
        try dnsStatisticsMigration.migrateActivity()
        try dnsStatisticsMigration.removeOldStatisticsDatabase()
    }
}
