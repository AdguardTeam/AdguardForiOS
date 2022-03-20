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

import SafariAdGuardSDK
import DnsAdGuardSDK
import SharedAdGuardSDK

protocol MigrationServiceProtocol {
    func migrateIfNeeded()
}

private let LOG = LoggerFactory.getLoggerWrapper(MigrationService.self)

/// This object is responsible for running migration code
/// It has a knowledge of previous and current product versions
/// And runs migrations according to these versions
final class MigrationService: MigrationServiceProtocol {

    private let resources: AESharedResourcesProtocol
    private let networking: ACNNetworkingProtocol
    private let configurationService: ConfigurationServiceProtocol
    private let productInfo: ADProductInfoProtocol
    private let safariProtection: SafariProtectionProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let networkSettings: NetworkSettingsServiceProtocol
    private let versionProvider: MigrationServiceVersionProvider
    private let dnsConfigAssistant: DnsConfigManagerAssistantProtocol
    private let settingsResetService: SettingsResetServiceProtocol
    private let dnsProtection: DnsProtectionProtocol

    private let migrationQueue = DispatchQueue(label: "MigrationService queue", qos: .userInitiated)

    init(
            resources: AESharedResourcesProtocol,
            networking: ACNNetworkingProtocol,
            configurationService: ConfigurationServiceProtocol,
            productInfo: ADProductInfoProtocol,
            safariProtection: SafariProtectionProtocol,
            dnsProvidersManager: DnsProvidersManagerProtocol,
            networkSettings: NetworkSettingsServiceProtocol,
            dnsConfigAssistant: DnsConfigManagerAssistantProtocol,
            settingsResetService: SettingsResetServiceProtocol,
            dnsProtection: DnsProtectionProtocol
    ) {
        self.resources = resources
        self.networking = networking
        self.configurationService = configurationService
        self.productInfo = productInfo
        self.safariProtection = safariProtection
        self.dnsProvidersManager = dnsProvidersManager
        self.networkSettings = networkSettings
        self.versionProvider = MigrationServiceVersionProvider(resources: resources)
        self.dnsConfigAssistant = dnsConfigAssistant
        self.settingsResetService = settingsResetService
        self.dnsProtection = dnsProtection
    }

    func migrateIfNeeded(){
        migrationQueue.sync {
            minorAndPatchMigration()
        }
    }

    private func minorAndPatchMigration() {
        LOG.info("minorAndPatchMigration")

        /*
         There was a migration here but it is removed now.
         We've decided to remove this migration code in 4.3 because code base has greatly changed
         And it is inconvenient and will take us lots of time to support this.
         PLEASE NOTE that this migration is not supported anymore.

         In app version 4.2 (693) DNS-lib was updated
         If user had custom quic:// URLs and DoQ sdns:// stamps in his server list,
         they should be changed from `quic://example.org` to `quic://example.org:784`.
         DoQ sdns:// stamps should also be patched to include port, if they are in list
         */


        /*
         We've made a big code refactoring in 4.3 and practically all old code became useless.
         There were lots of migration before 4.1 but it would have taken lots of time for our team to rewrite and support it.
         So, we've decided just to reset all the settings to default for users that had a version before 4.1.
         */
        if versionProvider.isLastVersionLessThan4_1 {
            LOG.info("Reset the app to default state")
            settingsResetService.resetAllSettings(sync: true, fromUI: false, resetLicense: false)
            // For older versions after resetting settings mark it as a "first run" to conduct necessary init.
            resources.firstRun = true

            // TODO: reconsider the way the state is being reset since migration is called on the main thread
            // The current implementation tried to perform heavy operations during the settings reset, it must not be
            // called this way.
        }

        /*
         Migration:
         In app version 4.3 (800+) we've moved all Safari and DNS protection logic to our own SDK to make this logic reusable in other products
         All data from User rules, allowlist rules, inverted allowlist rules, DNS blocklist, DNS allowlist, filters(safari/dns) data was replaced in different storages
         So we need to migrate this data respectively
         */
        if versionProvider.isMigrationFrom4_1To4_3Needed {
            LOG.info("App migration to 4.3 started")

            let oldFilesMigration = SDKMigrationOldFilesHelper(
                oldFilesContainerUrl: resources.sharedResuorcesURL(),
                cbJsonFolderUrl: SharedStorageUrls().cbJsonsFolderUrl
            )
            oldFilesMigration.removeOldUnusedFiles()
            oldFilesMigration.replaceCbJsonFiles()

            let networkSettingsMigration = NetworkSettingsMigrations(networkSettingsService: networkSettings, resources: resources)
            networkSettingsMigration.startMigration()

            do {
                let dnsMigration = try DnsMigration4_3(resources: resources, dnsProvidersManager: dnsProvidersManager)
                let safariMigration = try SafariMigration4_3(resources: resources, safariProtection: safariProtection)
                let sdkMigrationHelper = SDKMigrationServiceHelper(
                    safariMigration: safariMigration,
                    dnsMigration: dnsMigration
                )

                try sdkMigrationHelper.migrate()
                // Reloads Tunnel if it is active to apply migrated DNS settings
                dnsConfigAssistant.applyDnsPreferences(for: .modifiedDnsSettings, completion: nil)
                LOG.info("Successfully migrated old data to SDK")
            } catch {
                LOG.error("Failed to migrate old data to SDK; Error: \(error)")
            }
        }

        if versionProvider.isMigrationFrom4_3_0To4_3_1Needed {
            LOG.info("Starting migrate rules from 4.3.0 to 4.3.1")
            let safariMigration4_3_1 = SafariMigration4_3_1(resources: resources, safariProtection: safariProtection as! SafariProtectionMigrationsProtocol)
            let dnsMigration4_3_1 = DnsMigration4_3_1(resources: resources, dnsProtection: dnsProtection)

            safariMigration4_3_1.migrate()
            LOG.info("Successfully migrate safari rules from 4.3.0 to 4.3.1")

            dnsMigration4_3_1.migrate()
            LOG.info("Successfully migrate dns rules from 4.3.0 to 4.3.1")
        }

        let currentBuildVersion = Int(productInfo.buildNumber())
        resources.buildVersion = currentBuildVersion ?? 0
        resources.isMigrationTo4_3Passed = true
        resources.isMigrationTo4_3_1Passed = true
    }
}

