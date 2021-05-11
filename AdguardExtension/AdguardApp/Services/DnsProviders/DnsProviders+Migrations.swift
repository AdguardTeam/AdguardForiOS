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
    func changeQuicCustomServersPort()
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
    
    /*
     Change a port for custom servers with the 'quic' schema to 784
     New port is 8853. Now an address like quic://dns.adguard.com is transformed into quic://dns.adguard.com:8853.
     So to force the use of the old port 784 specify it strictly - quic://dns.adguard.com:784.
     
     That means that if you have custom quic:// URLs and DoQ sdns:// stamps in your server list,
     they (excluding AdGuard's) should be changed from `quic://example.org` to `quic://example.org:784`.
     DoQ sdns:// stamps should also be patched to include port, if they are in list
     */
    func changeQuicCustomServersPort() {
        DDLogInfo("Migrating custom DoQ servers, changing port to 784")
        
        let allCustomServers = customProviders.flatMap { $0.servers ?? [] }
        DDLogDebug("All custom servers: \(allCustomServers.flatMap { $0.upstreams }.joined(separator: "; "))")
        
        let adguardDoqHosts = ["quic://dns.adguard.com", "quic://dns-family.adguard.com", "quic://dns-unfiltered.adguard.com"]
        
        for provider in customProviders {
            guard provider.servers?.count == 1,
                  let serverToMigrate = provider.servers?.first
            else { continue }
            
            // Add port to DoQ server if needed
            if serverToMigrate.dnsProtocol == .doq,
               let upstream = serverToMigrate.upstreams.first,
               !adguardDoqHosts.contains(upstream) {
                
                let newUpstream = addPortToUpstreamIfNeeded(upstream)
                if newUpstream != upstream {
                    serverToMigrate.upstreams = [newUpstream]
                    vpnManager?.updateSettings(completion: nil)
                }
            }
            // Process sdns link
            else if serverToMigrate.dnsProtocol == .dnsCrypt,
                    let sdnsUpstream = serverToMigrate.upstreams.first,
                    let decodedServerUpstream = DnsResolver.resolve(upstream: sdnsUpstream).dnsServer {
                
                let upstreamProtocol = DnsProtocol.getProtocolByUpstream(decodedServerUpstream)
                if upstreamProtocol == .doq {
                    let newUpstream = addPortToUpstreamIfNeeded(decodedServerUpstream)
                    if newUpstream != decodedServerUpstream {
                        // TODO: - encode upstream to sdns
                        serverToMigrate.upstreams = [decodedServerUpstream]
                        vpnManager?.updateSettings(completion: nil)
                    }
                }
            }
            else {
                continue
            }
        }
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
    
    /*
     Returns passed upstream if the port in upstream was stated or upstream is not DoQ
     Returns upstream with 784 port otherwise
     */
    private func addPortToUpstreamIfNeeded(_ upstream: String) -> String {
        guard let doqPrefix = DnsProtocol.prefixByProtocol[.doq], upstream.hasPrefix(doqPrefix) else {
            return upstream
        }
        
        let upstreamWithoutPrefix = String(upstream.dropFirst(doqPrefix.count))
        
        if upstreamWithoutPrefix.contains(":") {
            return upstream
        }
        
        return upstream + ":784"
    }
}
