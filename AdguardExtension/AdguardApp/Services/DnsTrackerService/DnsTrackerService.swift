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

// MARK: - DnsTrackers
struct DnsTrackers: Codable {
    let timeUpdated: String
    let categories: [String: String]
    let trackers: [String: Tracker]
    let trackerDomains: [String: String]
}

// MARK: - Tracker
struct Tracker: Codable {
    let name: String
    let categoryId: Int
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case categoryId
        case url
    }
}

protocol DnsTrackerServiceProtocol {
    func getCategoryAndName(by domain: String?) -> (categoryKey: String?, name: String?, isTracked: Bool?)
}

class DnsTrackerService: DnsTrackerServiceProtocol {
    
    private var dnsTrackers: DnsTrackers?
    
    init() {
        initializeDnsTrackers()
    }
    
    func getCategoryAndName(by domain: String?) -> (categoryKey: String?, name: String?, isTracked: Bool?) {
        let nilReturn: (categoryKey: String?, name: String?, isTracked: Bool?) = (nil, nil, nil)
        
        let trackerDomains = dnsTrackers?.trackerDomains
        
        guard let domain = domain else { return nilReturn }
        guard let domainKey = trackerDomains?[domain] else { return nilReturn }
        
        let trackers = dnsTrackers?.trackers
        guard let info = trackers?[domainKey] else { return nilReturn }
        
        let categories = dnsTrackers?.categories
        
        let categoryId = info.categoryId
        guard let categoryKey = categories?[String(categoryId)] else { return nilReturn }
        
        let isTracked = categoryId == 3 || categoryId == 4 || categoryId == 6 || categoryId == 7
        
        return (categoryKey, info.name, isTracked)
    }
    
    // MARK: - Initialization of dns trackers object
    
    private func initializeDnsTrackers(){
        guard let path = Bundle.main.path(forResource: "whotracksme", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            dnsTrackers = try JSONDecoder().decode(DnsTrackers.self, from: data)
        } catch {
            DDLogError("Failed to decode whotracksme.json")
        }
    }
    
}
