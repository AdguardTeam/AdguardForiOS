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

extension DnsProvidersService {
    
    static let serversMapping = [
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
    
    func migrateActiveServerIfNeeded() {
        guard let activeServer = self.activeDnsServer else {
            
            DDLogInfo("(DnsProvidersMigration) - migrateActiveServerIfNeeded. Nothing to migrate")
            return
        }
        
        if let mappedId = DnsProvidersService.serversMapping[activeServer.serverId] {
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
}
