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
import SafariAdGuardSDK

protocol MigrationServiceProtocol {
    func migrateIfNeeded()
}

final class MigrationService: MigrationServiceProtocol {

    private let currentSchemaVersion = 5

    private let vpnManager: VpnManagerProtocol
    private let resources: AESharedResourcesProtocol
    private let networking: ACNNetworkingProtocol
    private let configurationService: ConfigurationServiceProtocol
    private let productInfo: ADProductInfoProtocol
    private let safariProtection: SafariProtectionProtocol
    
    private let migrationQueue = DispatchQueue(label: "MigrationService queue", qos: .userInitiated)

    init(
        vpnManager: VpnManagerProtocol,
        resources: AESharedResourcesProtocol,
        networking: ACNNetworkingProtocol,
        configurationService: ConfigurationServiceProtocol,
        productInfo: ADProductInfoProtocol,
        safariProtection: SafariProtectionProtocol
    ) {
        self.vpnManager = vpnManager
        self.resources = resources
        self.networking = networking
        self.configurationService = configurationService
        self.productInfo = productInfo
        self.safariProtection = safariProtection

        resources.sharedDefaults().set(self.currentSchemaVersion, forKey: AEDefaultsProductSchemaVersion)
    }

    func migrateIfNeeded(){
        migrationQueue.async {[weak self] in
            guard let self = self else { return }
                self.migrateIfNeededPrivate()
        }
    }

    private func migrateIfNeededPrivate() {
        majorMigration()
        minorAndPatchMigration()
    }

    private func majorMigration() {
        let savedSchemaVersion = resources.sharedDefaults().integer(forKey: AEDefaultsProductSchemaVersion)

        /* For major migration */
        if savedSchemaVersion != currentSchemaVersion {
            DDLogInfo("(MigrationService) - Migration will be started. Current schema version: \(savedSchemaVersion), update to: \(currentSchemaVersion).")

            var result = true

            if savedSchemaVersion < 3 {

                if Bundle.main.isPro {
                    result = result && proFrom2To4Update()
                }
                else {
                    // TODO: - There is no antibanner anymore; enableGroupsWithEnabledFilters uses AntiBanner
                    result = result && enableGroupsWithEnabledFilters()
                    result = result && migrateVpnSettingsFromTunnelconfiguration()
                }
            }

            if savedSchemaVersion < 5 {
                // TODO: - There is no antibanner anymore
                //self.migrateFilterRulesIfNeeded(antibanner: antibanner, storage: filtersStorage)
            }

            /* If all migrations are successfull, than save current schema version */
            if result {
                resources.sharedDefaults().set(currentSchemaVersion, forKey: AEDefaultsProductSchemaVersion)
            }
        }
    }

    private func minorAndPatchMigration() {
        let lastBuildVersion = resources.buildVersion
        let currentBuildVersion = Int(productInfo.buildNumber())

        DDLogInfo("(MigrationService) - minorAndPatchMigration")

        // TODO: - This migration was using AntiBanner
        /// Migration: Update Antibanner and DnsFilters on every migration
        if lastBuildVersion != currentBuildVersion {
            DDLogInfo("(MigrationService) Patch migration from \(lastBuildVersion) to \(String(describing: currentBuildVersion))")

            resources.buildVersion = currentBuildVersion ?? 0

//            if inBackground {
//                resources.needUpdateFilters = true
//                resources.sharedDefaults().set(true, forKey: NeedToUpdateFiltersKey)
//            }
//            else {
//                updateAntibanner()
//                updateDnsFilters()
//            }
        }
        else if resources.needUpdateFilters {
            DDLogInfo("(MigrationService) finish migration started in background ")

//            updateAntibanner()
//            updateDnsFilters()
//
//            resources.needUpdateFilters = false
        }

        /// If lastBuildVersion is 0, it means that it is new install and migration is not needed
        if lastBuildVersion == 0 {
            return
        }

        if Bundle.main.isPro {

        }
        else {
            // TODO: - This migration was used for Alpha and Beta testers; Is there any reason for supporting it?
            /**
            Migration:
             In app version 4.0 (448) we've begun reseting all statistics while resetting the settings;
             In early versions of 4.0 we were detecting blocked requests instead of encrypted;
             Early app version hasn't reached app store, so we just reset old statistics and db files.
            */
            if lastBuildVersion < 448 {
                DDLogInfo("(MigrationService) - resetStatistics migration started. Current build version is: \(String(describing: currentBuildVersion)). Saved build version is: \(lastBuildVersion)")
                resetStatistics()
            }
        }

        /**
        Migration:
         In app version 4.1 (561) we've removed 'optimize' feature for filters, because it was confusing;
         Now this feature is set to false by default and we need to reload JSON for content blockers.
         Migration for AdGuard and AdGuard Pro
        */
        if lastBuildVersion < 561 {
            DDLogInfo("(MigrationService) -  removeOptimizeFeature started. Current build version is: \(String(describing: currentBuildVersion)). Saved build version is: \(lastBuildVersion)")
            removeOptimizeFeature()
        }


        // TODO: - setProtocolForCustomProviders uses DnsProvidersService that doesn't exist anymore
        /**
        Migration:
         In app version 4.0.4 (563) we began to inititalize custom dns servers with dns protocol
         for previously added custom servers we set protocol here
        */
        if lastBuildVersion < 563 {
            DDLogInfo("(MigrationService) - setProtocolForCustomProviders migration started. Current build version is: \(String(describing: currentBuildVersion)). Saved build version is: \(lastBuildVersion)")
            setProtocolForCustomProviders()
        }

        /**
        Migration:
         In app version 4.0.4 (585) we've changed PacketTunnelProvider ip adresses for identifying tunnel mode in AdGuard VPN
         Restart tunnel to update ip addresses
        */
        if lastBuildVersion < 585 {
            DDLogInfo("(MigrationService) - restart tunnel to change tunnel ip address. Current build version is: \(String(describing: currentBuildVersion)). Saved build version is: \(lastBuildVersion)")
            vpnManager.updateSettings(completion: nil)
        }

        /*
         In app version 4.1 (590) we've changed logic of showing rate app dialog
         this flag is useless now
        */
        if lastBuildVersion < 590 {
            resources.sharedDefaults().removeObject(forKey: "AEDefaultsLastBuildRateAppRequested")
        }

        // TODO: - This migration uses DnsProvidersService and NativeProvidersService that don't exist anymore
//        /**
//        Migration:
//         In app version 4.1 (593) we've added AdGuard DNS repository support and begun to use
//         all information from providers.json
//         Server id and provider id were added and now we need to set them for current DNS server otherwise it will be nil
//         isCustomProvider  property was added
//         providerId is not optional anymore
//
//         we've also rewritten some code from objc to swift and began to use JSONDecoder instead of NSKeyedUnarchver
//         So we need to get Data with NSKeyedUnarchver and resave it with JSONEncoder
//        */
//        if lastBuildVersion < 593, let dnsProvidersMigratable = dnsProvidersService as? DnsProvidersServiceMigratable {
//            DDLogInfo("(MigrationService) - DNS providers migrations started. Current build version is: \(String(describing: currentBuildVersion)). Saved build version is: \(lastBuildVersion)")
//
//            dnsProvidersMigratable.reinitializeDnsProvidersObjectsAndSetIdsAndFlags(resources: resources)
//            nativeProviders.reinitializeProviders()
//        }

        /**
         Migration:
            In app version 4.3 (800+) we've moved all Safari and DNS protection logic to our own SDK to make this logic reusable in other products
            All data from User rules, allowlist rules, inverted allowlist rules, DNS blocklist, DNS allowlist, filters(safari/dns) data was replaced in different storages
            So we need to migrate this data respectively
         */
        if lastBuildVersion < 800 {
            do {
                let filtersDbMigration = try SafariProtectionFiltersDatabaseMigrationHelper(
                    oldAdguardDBFilePath: resources.sharedResuorcesURL().appendingPathComponent("adguard.db").path,
                    oldDefaultDBFilePath: resources.sharedResuorcesURL().appendingPathComponent("default.db").path
                )
                let allowlistRulesMigration = SafariProtectionAllowlistRulesMigrationHelper(rulesContainerDirectoryPath: resources.sharedResuorcesURL().path)
                let customFiltersMigration = try SafariProtectionCustomFiltersMigrationHelper(
                    newDBFilePath: SharedStorageUrls().dbFolderUrl.appendingPathComponent("adguard.db").path,
                    filtersDirectoryUrl: SharedStorageUrls().filtersFolderUrl
                )
                let sdkMigrationHelper = SDKMigrationServiceHelper(
                    safariProtection: safariProtection as! SafariProtectionMigrationsProtocol,
                    filtersDbMigration: filtersDbMigration,
                    allowlistRulesMigration: allowlistRulesMigration,
                    customFiltersMigration: customFiltersMigration
                )
                try sdkMigrationHelper.migrate()
                DDLogInfo("(MigrationService) - Successfully migrated old data to SDK")
            } catch {
                DDLogError("(MigrationService) - Failed to migrate old data to SDK; Error: \(error)")
            }
        }
    }

    // MARK: - Methods for migrations

    // TODO: - This method uses DnsProvidersService that doesn't exist anymore
    private func setProtocolForCustomProviders(){
//        let customProviders = dnsProvidersService.customProviders
//        var changesCount = 0
//
//        let group = DispatchGroup()
//
//        for provider in customProviders {
//            if let server = provider.servers?.first, server.dnsProtocol == .dns, let upstream = server.upstreams.first {
//                let newProtocol = DnsProtocol.getProtocolByUpstream(upstream)
//                if newProtocol != server.dnsProtocol {
//                    DDLogInfo("(MigrationService) - setProtocolForCustomProviders, name: \(server.name); upstream: \(upstream); oldProtocol: \(DnsProtocol.stringIdByProtocol[server.dnsProtocol] ?? "Unknown"); newProtocol: \(DnsProtocol.stringIdByProtocol[newProtocol] ?? "Unknown")")
//                    changesCount += 1
//                    server.dnsProtocol = newProtocol
//                    group.enter()
//                    dnsProvidersService.updateProvider(provider, { group.leave() })
//                }
//            }
//        }
//
//        group.wait()
//
//        /* If there were some changes, the VPN manager is to be reloaded to apply changes */
//        if changesCount > 0 {
//            vpnManager.updateSettings { (error) in
//                if error != nil {
//                    DDLogError("(MigrationService) - setProtocolForCustomProviders, failed to reload VPN manager with error: \(error!.localizedDescription)")
//                }
//            }
//        }
    }

    // TODO: - This reset was used for Alpha and Beta testers; Is there any reason for supporting it?
    private func resetStatistics(){
//        /* Reseting statistics Start*/
//        self.activityStatisticsService.stopDb()
//        self.dnsStatisticsService.stopDb()
//
//        // delete database file
//        let url = self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db")
//        try? FileManager.default.removeItem(atPath: url.path)
//
//        /* Reseting statistics end */
//        self.activityStatisticsService.startDb()
//        self.dnsStatisticsService.startDb()
    }

    // TODO: - This method uses obsolete AntiBanner class
    private func enableGroupsWithEnabledFilters() -> Bool {
//        let result = antibanner.enableGroupsWithEnabledFilters()
//
//        filtersService.updateGroups()
//
        return true
    }

    // TODO: - This method uses obsolete AntiBanner class
    private func updateAntibanner() {
//        // removing malware filter with antibanner
//        if self.antibanner.filters().contains(where: { $0.filterId == 208 }) {
//            self.antibanner.unsubscribeFilter(NSNumber(integerLiteral: 208))
//        }
//
//        filtersService.load(refresh: true, protectionEnabled: safariProtection.safariProtectionEnabled, userFilterEnabled: resources.safariUserFilterEnabled, whitelistEnabled: resources.safariWhitelistEnabled, invertedWhitelist: resources.invertedWhitelist) {_,_ in }
    }

    // TODO: - This method uses DnsFiltersService that doesn't exist anymore
    private func updateDnsFilters() {
        //dnsFiltersService.updateFilters(networking: networking, callback: nil)
    }

    // TODO: - This method did migration for PRO version from v2->v4
    // It uses obsolete DnsFiltersService, but we can use SDK API and put old rules with it
    // Looks very old, do we need to support it?
    private func migrateProDnsUserFilters() -> Bool {
        var result = false
        let domainsConverter: DomainsConverterProtocol = DomainsConverter()
        let fm = FileManager()

        if let whitelistData = resources.loadData(fromFileRelativePath: "pro-whitelist-doamins.data"),
                whitelistData.count > 0 {
            if let domains = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(whitelistData) as? [String]{
                for domain in domains {
                    result = true
                    //dnsFiltersService.addWhitelistRule(domainsConverter.whitelistRuleFromDomain(domain))
                }
            }
            else {
                DDLogError("(MigrationService) migrateProDnsUserFilters - can not parse whitelist")
            }

            try? fm.removeItem(atPath: resources.path(forRelativePath: "pro-whitelist-doamins.data"))
        }


        if let blacklistData = resources.loadData(fromFileRelativePath: "pro-blacklist-doamins.data"),
                blacklistData.count  > 0 {
            if let domains = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(blacklistData) as? [String]{
                for domain in domains {
                    result = true
                    //dnsFiltersService.addBlacklistRule(domainsConverter.blacklistRuleFromDomain(domain))
                }
            }
            else {
                DDLogError("(MigrationService) migrateProDnsUserFilters - can not parse blacklist")
            }

            try? fm.removeItem(atPath: resources.path(forRelativePath: "pro-blacklist-doamins.data"))
        }

        return result
    }

    // TODO: - This method did migration for PRO version from v2->v4
    // There is no migrateOldVpnSettings method in VpnManager anymore
    // Looks very old, do we need to support it?

    // migrate vpn settings (dns server, tunnel mode, restart by reachability)
    private func migrateVpnSettingsFromTunnelconfiguration() -> Bool {
        DDLogInfo("(MigrationService) migrateVpnSettingsFromTunnelconfiguration")
        var result = true

//        let group = DispatchGroup()
//        group.enter()
//        vpnManager.migrateOldVpnSettings { (error) in
//            if error != nil {
//                DDLogError("(MigrationService) proFrom2To4Update - migrateVpnSettings error: \(error!)")
//                result = false
//            }
//
//            group.leave()
//        }
//
//        group.wait()

        return result
    }

    private func proFrom2To4Update() -> Bool {
        var result = true

        DDLogInfo("(MigrationService) migrate pro v2->v4")

        result = result && migrateVpnSettingsFromTunnelconfiguration()

        // TODO: - Obsolete service
        // The format for storing log entries has changed. Clear log.
//       dnsLogRecordsService.clearLog()
//
        // migrate old dns user filters(whitelist/blacklist)
        if migrateProDnsUserFilters() {

            // if the user had dns filters we enable advanced mode
            configurationService.advancedMode = true
        }

        // TODO: - Obsolete service
        // migrate old dns filter subscriptions to new dns filters
//        let manager = ProSubscriptionsMigrationService(resources: resources, dnsFiltersService: dnsFiltersService)
//        if manager.migrateIfNeeeded() {
//            DDLogInfo("(MigrationService) pro subscriptions have been successfully migrated.")
//            vpnManager.updateSettings(completion: nil)
//
//            // if the user had dns filters we enable advanced mode
//            configurationService.advancedMode = true
//        }
//
//        // turn off adguard safari filter
//        DDLogInfo("(MigrationService) disable safari adguard filter.")
//        antibanner.setFilter(12, enabled: false, fromUI: false)
//
//        // turn on groups
//        result = result && enableGroupsWithEnabledFilters()
        
        return result
    }

    // TODO: - This method is full of old objects
    private func removeOptimizeFeature() {
//        let backgroundTaskId = UIApplication.shared.beginBackgroundTask { }
//        contentBlockerService.reloadJsons(backgroundUpdate: false, protectionEnabled: safariProtection.safariProtectionEnabled, userFilterEnabled: resources.safariUserFilterEnabled, whitelistEnabled: resources.safariWhitelistEnabled, invertWhitelist: resources.invertedWhitelist) { error in
//            if let error = error {
//                DDLogError("Error while removing 'optimize' feature; Error = \(error.localizedDescription)")
//            }
//            UIApplication.shared.endBackgroundTask(backgroundTaskId)
//        }
    }
}

