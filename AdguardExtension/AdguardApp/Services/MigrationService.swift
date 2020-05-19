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
    private let dnsLogRecordsService: DnsLogRecordsServiceProtocol
    private let configurationService: ConfigurationServiceProtocol
    
    private let migrationQueue = DispatchQueue(label: "MigrationService queue", qos: .userInitiated)
    
    init(vpnManager: VpnManagerProtocol, dnsProvidersService: DnsProvidersServiceProtocol, resources: AESharedResourcesProtocol, antibanner: AESAntibannerProtocol, dnsFiltersService: DnsFiltersServiceProtocol, networking: ACNNetworkingProtocol, activityStatisticsService: ActivityStatisticsServiceProtocol, dnsStatisticsService: DnsStatisticsServiceProtocol, dnsLogService: DnsLogRecordsServiceProtocol, configuration: ConfigurationServiceProtocol) {
        self.vpnManager = vpnManager
        self.dnsProvidersService = dnsProvidersService
        self.resources = resources
        self.antibanner = antibanner
        self.dnsFiltersService = dnsFiltersService
        self.networking = networking
        self.activityStatisticsService = activityStatisticsService
        self.dnsStatisticsService = dnsStatisticsService
        self.dnsLogRecordsService = dnsLogService
        self.configurationService = configuration
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
                
                if Bundle.main.isPro {
                    result = result && proFrom2To4Update()
                }
                else {
                    result = result && enableGroupsWithEnabledFilters()
                    result = result && migrateVpnSettingsFromTunnelconfiguration()
                }
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
        
        if Bundle.main.isPro {
            
        }
        else {
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
        antibanner.unsubscribeFilter(NSNumber(integerLiteral: 208))
        
        antibanner.beginTransaction()
        antibanner.startUpdatingForced(true, interactive: false)
    }
    
    private func updateDnsFilters() {
        dnsFiltersService.updateFilters(networking: networking, callback: nil)
    }
    
    private func migrateProDnsUserFilters()->Bool {
        
        var result = false
        let domainsConverter: DomainsConverterProtocol = DomainsConverter()
        let fm = FileManager()
        
        if let whitelistData = resources.loadData(fromFileRelativePath: "pro-whitelist-doamins.data"),
                whitelistData.count > 0 {
            if let domains = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(whitelistData) as? [String]{
                for domain in domains {
                    result = true
                    dnsFiltersService.addWhitelistRule(domainsConverter.whitelistRuleFromDomain(domain))
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
                    dnsFiltersService.addBlacklistRule(domainsConverter.blacklistRuleFromDomain(domain))
                }
            }
            else {
                DDLogError("(MigrationService) migrateProDnsUserFilters - can not parse blacklist")
            }
            
            try? fm.removeItem(atPath: resources.path(forRelativePath: "pro-blacklist-doamins.data"))
        }
        
        return result
    }
    
    // migrate vpn settings (dns server, tunnel mode, restart by reachability)
    private func migrateVpnSettingsFromTunnelconfiguration() ->Bool {
        
        DDLogInfo("(MigrationService) migrateVpnSettingsFromTunnelconfiguration")
        var result = true
        
        let group = DispatchGroup()
        group.enter()
        vpnManager.migrateOldVpnSettings { (error) in
            if error != nil {
                DDLogError("(MigrationService) proFrom2To4Update - migrateVpnSettings error: \(error!)")
                result = false
            }
            
            group.leave()
        }
        
        group.wait()
        
        return result
    }
    
    private func proFrom2To4Update()->Bool {
        
        var result = true
        
        DDLogInfo("(MigrationService) migrate pro v2->v4")
        
        result = result && migrateVpnSettingsFromTunnelconfiguration()
        
        // The format for storing log entries has changed. Clear log.
        dnsLogRecordsService.clearLog()
        
        // migrate old dns user filters(whitelist/blacklist)
        if migrateProDnsUserFilters() {
            
            // if the user had dns filters we enable advanced mode
            configurationService.advancedMode = true
        }
        
        // migrate old dns filter subscriptions to new dns filters
        let manager = ProSubscriptionsManager(resources: resources, dnsFiltersService: dnsFiltersService)
        if manager.migrateIfNeeeded() {
            DDLogInfo("(MigrationService) pro subscriptions have been successfully migrated.")
            vpnManager.updateSettings(completion: nil)
            
            // if the user had dns filters we enable advanced mode
            configurationService.advancedMode = true
        }
        
        // turn off adguard safari filter
        DDLogInfo("(MigrationService) disable safari adguard filter.")
        antibanner.setFilter(12, enabled: false, fromUI: false)
        
        // turn on groups
        result = result && enableGroupsWithEnabledFilters()
        
        return result
    }
}
