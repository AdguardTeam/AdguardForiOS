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

struct StoryCategory: Decodable, Equatable {
    
    enum CategoryType: String, CaseIterable, Codable {
        case whatsNew = "WhatsNew"
        case dnsProtection = "DnsProtection"
        case vpnProtection = "VpnProtection"
        case safariProtection = "SafariProtection"
        case youtubeAds = "YouTubeAds"
        case dnsServers = "DnsServers"
    }
    
    let title: String
    let type: CategoryType
    let categoryImage: UIImage?
    
    init(type: CategoryType) {
        self.type = type
        self.title = ""
        self.categoryImage = nil
    }
    
    init(title: String, type: StoryCategory.CategoryType, categoryImage: UIImage?) {
        self.title = title
        self.type = type
        self.categoryImage = categoryImage
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case categoryImage = "category_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeKey = try container.decode(String.self, forKey: .type)
        let titleKey = try container.decode(String.self, forKey: .title)
        let imageKey = try container.decode(String.self, forKey: .categoryImage)
        
        self.type = CategoryType(rawValue: typeKey)!
        self.title = String.localizedString(titleKey)
        self.categoryImage = UIImage(named: imageKey)
    }
}

// MARK: - AESharedResourcesProtocol + watchedStoriesCategories

fileprivate extension AESharedResourcesProtocol {
    var watchedStoriesCategoriesKey: String { "watchedStoriesCategoriesKey" }
}

extension AESharedResourcesProtocol {
    dynamic var watchedStoriesCategories: Set<StoryCategory.CategoryType> {
        get {
            if let savedSetDate = sharedDefaults().object(forKey: watchedStoriesCategoriesKey) as? Data {
                let decoder = JSONDecoder()
                let savedSet = try? decoder.decode(Set<StoryCategory.CategoryType>.self, from: savedSetDate)
                return savedSet ?? Set()
            }
            return Set()
        }
        set {
            let encoder = JSONEncoder()
            if let encodedSet = try? encoder.encode(newValue) {
                sharedDefaults().set(encodedSet, forKey: watchedStoriesCategoriesKey)
            }
        }
    }
}
