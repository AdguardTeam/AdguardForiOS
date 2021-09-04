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
struct DnsTrackers: Decodable {
    let jsonType: JsonType
    let categories: [DnsTracker.Category]
    let trackers: [String: DnsTracker]
    let trackerDomains: [String: String]
    
    enum JsonType: String, Decodable {
        case adGuard = "adguard"
        case whoTracksMe = "whotracksme"
    }
    
    enum CodingKeys: String, CodingKey {
        case jsonType
        case categories
        case trackers
        case trackerDomains
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.jsonType = try container.decode(JsonType.self, forKey: .jsonType)
        let categoriesDict = try container.decode([String: String].self, forKey: .categories)
        self.categories = categoriesDict.keys.compactMap { idStr in
            if let id = Int(idStr) {
                return DnsTracker.Category(rawValue: id)
            }
            return nil
        }
        
        self.trackers = try container.decode([String: DnsTracker].self, forKey: .trackers)
        self.trackerDomains = try container.decode([String: String].self, forKey: .trackerDomains)
    }
}

// MARK: - DnsTracker
struct DnsTracker: Decodable {
    let name: String
    let category: Category
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case category = "categoryId"
        case url
    }
    
    enum Category: Int, Decodable {
        case audioVideoPlayer = 0
        case comments = 1
        case customerInteraction = 2
        case pornvertising = 3
        case advertising = 4
        case essential = 5
        case siteAnalytics = 6
        case socialMedia = 7
        case misc = 8
        case cdn = 9
        case hosting = 10
        case unknown = 11
        case extensions = 12
        case mobileAnalytics = 101
    }
}
