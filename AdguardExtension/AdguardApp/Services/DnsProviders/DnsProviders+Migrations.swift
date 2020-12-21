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

protocol DnsProvidersServiceMigratable {
    func migrateActiveServerIfNeeded()
    func reinitializeDnsProvidersObjectsAndSetIdsAndFlags(resources: AESharedResourcesProtocol)
}

extension DnsProvidersService: DnsProvidersServiceMigratable {
    
    func migrateActiveServerIfNeeded() {
        guard let activeServer = self.activeDnsServer else {
            
            DDLogInfo("(DnsProvidersMigration) - migrateActiveServerIfNeeded. Nothing to migrate")
            return
        }
        
        let serversMapping = [
            "google-dns": 9,
            "google-doh": 10,
            "google-dot": 11,
            "cloudflare-dns": 12,
            "cloudflare": 13,
            "cloudflare-dot": 14,
            "cloudflare-family-dns": 26,
            "cloudflare-family-doh": 27,
            "open-dns": 15,
            "cisco": 16,
            "open-dns-doh": 22,
            "open-familyshield-dns": 17,
            "cisco-familyshield": 18,
            "cisco-familyshield-doh": 23,
            "quad9-dns": 19,
            "quad9-dnscryptfilter-pri": 20,
            "quad9-doh-filter-pri": 21,
            "adguard-dns": 1,
            "adguard-dnscrypt": 2,
            "adguard-doh": 3,
            "adguard-dot": 4,
            "adguard-dns-family": 5,
            "adguard-family-dnscrypt": 6,
            "adguard-family-doh": 7,
            "adguard-family-dot": 8
        ]
        
        if let mappedId = serversMapping[activeServer.serverId] {
            DDLogInfo("(DnsProvidersService)-  start active dns server migration")
            
            let mappedIdString = String(mappedId)
            
            // search server with mappedId in prdefined servers
            for provider in self.predefinedProviders {
                for server in provider.servers ?? [] {
                    if server.serverId == mappedIdString {
                        DDLogInfo("(DnsProvidersService) migration.  found new dns server with id = \(mappedId)")
                        
                        self.activeDnsServer = server
                        
                        return
                    }
                }
            }
        }
    }
    
    func reinitializeDnsProvidersObjectsAndSetIdsAndFlags(resources: AESharedResourcesProtocol) {
        migrateCurrentDnsServerInUserDefaults(resources: resources)
        setIdsForCustomProviders()
        setProviderIdForCurrentDnsServer()
    }
    
    private func migrateCurrentDnsServerInUserDefaults(resources: AESharedResourcesProtocol) {
        DDLogInfo("Get Data with NSKeyedUnarchver and resave it with JSONEncoder for AEDefaultsActiveDnsServer")
        
        defer {
            resources.sharedDefaults().removeObject(forKey: "AEDefaultsActiveDnsServer")
        }
        
        guard let data = resources.sharedDefaults().object(forKey: "AEDefaultsActiveDnsServer") as? Data else {
            DDLogWarn("Nil data for current DNS Server")
            return
        }
        if let dnsServer = NSKeyedUnarchiver.unarchiveObject(with: data) as? DnsServerInfo {
            activeDnsServer = dnsServer
        }
    }
    
    private func setIdsForCustomProviders() {
        DDLogInfo("Setting providerId for custom providers")
        customProviders.forEach { provider in
            let maxId = customProviders.map{ $0.providerId }.max() ?? 0
            let id = maxId + 1
            provider.providerId = id
            provider.servers?.forEach { $0.providerId = id }
        }
        
        /*
         When provider ids were set customProviders setter wasn't called and after reentering the app ids will be erased
         To save providers with new ids we forcibly call customProviders setter
         */
        let newCustomProviders = customProviders
        customProviders = newCustomProviders
        DDLogInfo("Finished setting providerId")
    }
    
    private func setProviderIdForCurrentDnsServer() {
        DDLogInfo("Trying to set provider id for current DNS server")
        
        guard let currentServer = activeDnsServer else {
            DDLogInfo("Current DNS server is nil")
            return
        }
        let serverId = currentServer.serverId
    
        guard let serverProvider = allProviders.first(where: { provider in
            provider.servers?.contains { $0.serverId == serverId } ?? false
        }) else {
            DDLogError("Failed to find provider for server with id = \(serverId)")
            return
        }
        currentServer.providerId = serverProvider.providerId
        activeDnsServer = currentServer
        
        DDLogInfo("Finished setting provider id for current DNS server")
    }
}
