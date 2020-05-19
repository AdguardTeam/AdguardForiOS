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

protocol MigrationServiceProtocol {
    func install()
    func migrateIfNeeded()
}

class MigrationService: MigrationServiceProtocol {
    
    private let currentSchemaVersion = 4
    
    private let vpnManager: VpnManagerProtocol
    private let dnsProvidersService: DnsProvidersServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let antibanner: AESAntibannerProtocol
    private let dnsFiltersService: DnsFiltersServiceProtocol
    private let networking: ACNNetworkingProtocol
    private let activityStatisticsService: ActivityStatisticsServiceProtocol
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    
    private let migrationQueue = DispatchQueue(label: "MigrationService queue", qos: .userInitiated)
    
    init(vpnManager: VpnManagerProtocol, dnsProvidersService: DnsProvidersServiceProtocol, resources: AESharedResourcesProtocol, antibanner: AESAntibannerProtocol, dnsFiltersService: DnsFiltersServiceProtocol, networking: ACNNetworkingProtocol, activityStatisticsService: ActivityStatisticsServiceProtocol, dnsStatisticsService: DnsStatisticsServiceProtocol) {
        self.vpnManager = vpnManager
        self.dnsProvidersService = dnsProvidersService
        self.resources = resources
        self.antibanner = antibanner
        self.dnsFiltersService = dnsFiltersService
        self.networking = networking
        self.activityStatisticsService = activityStatisticsService
        self.dnsStatisticsService = dnsStatisticsService
    }
    
    func install() {
        migrationQueue.async {[weak self] in
            guard let self = self else { return }
            self.resources.sharedDefaults().set(self.currentSchemaVersion, forKey: AEDefaultsProductSchemaVersion)
        }
    }
    
    func migrateIfNeeded() {
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
                result = result && enableGroupsWithEnabledFilters()
            }
            
            /* If all migrations are successfull, than save current schema version */
            if result {
                resources.sharedDefaults().set(currentSchemaVersion, forKey: AEDefaultsProductSchemaVersion)
            }
        }
    }
    
    private func minorAndPatchMigration() {
        let lastBuildVersion = resources.sharedDefaults().integer(forKey: AEDefaultsProductBuildVersion)
        let currentBuildVersion = Int(ADProductInfo.buildNumber())
        
        /**
        Migration:
         Update Antibanner and DnsFilters on every migration
        */
        if lastBuildVersion != currentBuildVersion {
            DDLogInfo("Patch migration from \(lastBuildVersion) to \(String(describing: currentBuildVersion))")
            resources.sharedDefaults().set(currentBuildVersion, forKey: AEDefaultsProductBuildVersion)
            
            updateAntibanner()
            updateDnsFilters()
        }
        
        /* If lastBuildVersion is 0, it means that it is new install and migration is not needed */
        if lastBuildVersion == 0 {
            return
        }
        
        /**
        Migration:
         In app version 4.0 (446) we began to inititalize custom dns servers with dns protocol
         for previously added custom servers we set protocol here
        */
        if lastBuildVersion < 457 {
            DDLogInfo("(MigrationService) - setProtocolForCustomProviders migration started. Current build version is: \(String(describing: currentBuildVersion)). Saved build version is: \(lastBuildVersion)")
            setProtocolForCustomProviders()
        }
        
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
    
    // MARK: - Methods for migrations
    
    private func setProtocolForCustomProviders(){
        let customProviders = dnsProvidersService.customProviders
        var changesCount = 0
        for provider in customProviders {
            if let server = provider.servers?.first, server.dnsProtocol == .dns, let upstream = server.upstreams.first {
                let newProtocol = DnsProtocol.getProtocolByUpstream(upstream)
                if newProtocol != server.dnsProtocol {
                    DDLogInfo("(MigrationService) - setProtocolForCustomProviders, name: \(server.name); upstream: \(upstream); oldProtocol: \(DnsProtocol.stringIdByProtocol[server.dnsProtocol] ?? "Unknown"); newProtocol: \(DnsProtocol.stringIdByProtocol[newProtocol] ?? "Unknown")")
                    changesCount += 1
                    server.dnsProtocol = newProtocol
                    dnsProvidersService.updateProvider(provider)
                }
            }
        }
        
        /* If there were some changes, the VPN manager is to be reloaded to apply changes */
        if changesCount > 0 {
            vpnManager.updateSettings { (error) in
                if error != nil {
                    DDLogError("(MigrationService) - setProtocolForCustomProviders, failed to reload VPN manager with error: \(error!.localizedDescription)")
                }
            }
        }
    }
    
    private func resetStatistics(){
        /* Reseting statistics Start*/
        self.activityStatisticsService.stopDb()
        self.dnsStatisticsService.stopDb()
        
        // delete database file
        let url = self.resources.sharedResuorcesURL().appendingPathComponent("dns-statistics.db")
        try? FileManager.default.removeItem(atPath: url.path)
        
        /* Reseting statistics end */
        self.activityStatisticsService.startDb()
        self.dnsStatisticsService.startDb()
    }
    
    private func enableGroupsWithEnabledFilters() -> Bool {
        return antibanner.enableGroupsWithEnabledFilters()
    }
    
    private func updateAntibanner() {
        // removing malware filter with antibanner
        antibanner.repairUpdateState { [weak self] in
            guard let self = self else { return }
            if self.antibanner.filters().contains(where: { $0.filterId == 208 }) {
                self.antibanner.unsubscribeFilter(NSNumber(integerLiteral: 208))
            }
            
            self.antibanner.beginTransaction()
            self.antibanner.startUpdatingForced(true, interactive: false)
        }
    }
    
    private func updateDnsFilters() {
        dnsFiltersService.updateFilters(networking: networking, callback: nil)
    }
}
