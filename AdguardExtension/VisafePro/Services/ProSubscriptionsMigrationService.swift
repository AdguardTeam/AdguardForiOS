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

// this class is used only for migration old blockinng subscriptions(pro v 2.1.2) to new DnsFilters
class ProSubscriptionsMigrationService {
    
    private let resources:AESharedResourcesProtocol
    private let dnsFilters: DnsFiltersServiceProtocol
    
    private let subscriptionsPath = "blocking-subscriptions.db"
    
    init(resources: AESharedResourcesProtocol, dnsFiltersService: DnsFiltersServiceProtocol) {
        self.resources = resources
        self.dnsFilters = dnsFiltersService
    }
    
    /** returns true, if sucessefully migrated*/
    func migrateIfNeeeded()->Bool {
        
        let subscriptions = readSubscriptions()
        if subscriptions.count == 0 {
            return false
        }
        
        for subscription in subscriptions {
            
            let filter = DnsFilter(subscriptionUrl: subscription.url, name: subscription.name, date: subscription.updateDate, enabled: true, desc: subscription.subscriptionDescription, importantDesc: nil, version: nil, rulesCount: subscription.rulesCount, homepage: nil)
            let data = dnsFilterData(rules: subscription.rules, hosts: subscription.hosts)
            dnsFilters.addFilter(filter, data: data)
        }
        
        deleteSubscriptions()
        
        return true
    }
    
    private func readSubscriptions()->[APBlockingSubscription] {
        
        DDLogInfo("(ProSubscriptionsManager) read subscriptions data from file")
        let storedArray: [Data] = NSArray(contentsOfFile: self.resources.path(forRelativePath: subscriptionsPath)) as? [Data] ?? []
            
        let subscriptions = storedArray.compactMap { (data) -> APBlockingSubscription?  in
            let subscription = NSKeyedUnarchiver.unarchiveObject(with: data) as? APBlockingSubscription
            return subscription
        }
        
        DDLogInfo("(ProSubscriptionsManager) subscriptions read count: \(subscriptions.count)");
        
        return subscriptions
    }
    
    private func deleteSubscriptions() {
        let fm = FileManager()
        do {
            try fm.removeItem(atPath: resources.path(forRelativePath: subscriptionsPath))
        }
        catch {
            DDLogError("(ProSubscriptionsManager) Failure to delete old DNS filter files: \(error)")
        }
    }
    
    private func dnsFilterData(rules: [String]?, hosts: [String: String]?)->Data {
        let rulesString = rules?.joined(separator: "\n") ?? ""
        
        let hostsPlain = hosts?.map { (key, value) -> String in
            return "\(value) \(key)"
        } ?? []
        
        let hostsString = hostsPlain.joined(separator: "\n")
        
        let resultString = "\(rulesString)\n\(hostsString)"
        
        return resultString.data(using: .utf8) ?? Data()
    }
}
