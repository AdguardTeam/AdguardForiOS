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

import DnsAdGuardSDK
import SharedAdGuardSDK

/// This object is responsible for migrating data related with DNS protection when transitioning the app to v4.3
protocol DnsMigration4_3Protocol {
    func migrate()
}

private let LOG = LoggerFactory.getLoggerWrapper(DnsMigration4_3.self)

class DnsMigration4_3: DnsMigration4_3Protocol {

    private let resources: AESharedResourcesProtocol
    private let stateManager: MigrationStateManagerProtocol
    private let dnsFiltersMigration: DnsProtectionFiltersMigrationHelperProtocol
    private let dnsRulesMigration: DnsProtectionUserRulesMigrationHelperProtocol
    private let dnsProvidersMigration: DnsProtectionCustomProvidersMigrationHelperProtocol
    private let lowLevelSettingsMigration: LowlevelSettingsMigrationHelperProtocol
    private let dnsStatisticsMigration: DnsStatisticsMigrationHelperProtocol

    init(resources: AESharedResourcesProtocol, dnsProvidersManager: DnsProvidersManagerProtocol) throws {
        self.resources = resources

        let sharedStorageUrls = SharedStorageUrls()
        // Create directories if don't exist
        try FileManager.default.createDirectory(at: sharedStorageUrls.dnsFiltersFolderUrl, withIntermediateDirectories: true, attributes: [:])
        try FileManager.default.createDirectory(at: sharedStorageUrls.statisticsFolderUrl, withIntermediateDirectories: true, attributes: [:])

        dnsFiltersMigration = DnsProtectionFiltersMigrationHelper(
            oldDnsFiltersContainerFolderUrl: resources.sharedResuorcesURL(),
            newDnsFiltersContainerFolderUrl: sharedStorageUrls.dnsFiltersFolderUrl,
            resources: resources
        )

        dnsRulesMigration = DnsProtectionUserRulesMigrationHelper(
            oldDnsUserRulesContainerFolderUrl: resources.sharedResuorcesURL(),
            newDnsUserRulesContainerFolderUrl: sharedStorageUrls.dnsFiltersFolderUrl
        )

        dnsProvidersMigration = DnsProtectionCustomProvidersMigrationHelper(resources: resources, dnsProvidersManager: dnsProvidersManager)

        lowLevelSettingsMigration = LowlevelSettingsMigrationHelper(resources: resources)

        dnsStatisticsMigration = DnsStatisticsMigrationHelper(oldContainerFolderUrl: resources.sharedResuorcesURL(), newContainerDbUrl: sharedStorageUrls.statisticsFolderUrl)

        stateManager = MigrationStateManager(resources: resources, migrationKey: "Dns4_3MigrationKey")
    }

    func migrate() {

        LOG.info("Migrate called")
        switch stateManager.state {
        case .notStarted:
            LOG.info("Start migration")
            stateManager.start()

            do {
                try migrateDnsProtection()
                try migrateDnsStatistics()
                stateManager.finish()

                LOG.info("Migration succeeded")
            }
            catch {
                LOG.error("Failure: \(error)")
                stateManager.failure()
            }

        case .finished:
            LOG.info("Allready migrated")
            return
        case .started:

            LOG.info("Allready started. Wait for finish.")
            // wait for finish
            let group = DispatchGroup()
            group.enter()
            stateManager.onMigrationFinished {
                LOG.info("Migration finished")
                group.leave()
            }

            // The timeout is a crutch because code for IPC is rather bad
            // TODO: - Refactor it later
            let waitResult = group.wait(timeout: .now() + 10.0)

            LOG.info("The wait is over; waitResult successeeded=\(waitResult == .success)")
            return
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
