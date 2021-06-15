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

// MARK: - ExtendedFilterMetaProtocol

protocol ExtendedFilterMetaProtocol: FilterMetaProtocol {
    var filterId: Int { get }
    var group: GroupMetaProtocol { get }
    var displayNumber: Int { get }
    var timeAdded: Date? { get }
    var trustLevel: ExtendedFiltersMeta.TrustLevel { get }
    var languages: [String] { get }
    var tags: [ExtendedFiltersMeta.Tag] { get }
}

// MARK: - ExtendedFiltersMeta

/* ExtendedFiltersMeta is an object representation of json from https://filters.adtidy.org/ios/filters.js */
struct ExtendedFiltersMeta: Decodable {
    let groups: [GroupMetaProtocol]
    let tags: [Tag]
    let filters: [ExtendedFilterMetaProtocol]
    
    enum CodingKeys: String, CodingKey {
        case groups
        case tags
        case filters
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.groups = try container.decode([Group].self, forKey: .groups)
        
        // Decoding tags
        var decodedTags: [Tag] = []
        let tagsDecoder = try container.superDecoder(forKey: .tags)
        var tagsContainer = try tagsDecoder.unkeyedContainer()
        while !tagsContainer.isAtEnd {
            let tagDecoder = try tagsContainer.superDecoder()
            if let tag = try? Tag(from: tagDecoder) {
                decodedTags.append(tag)
            }
        }
        self.tags = decodedTags
        
        // Decoding filters
        var decodedFilters: [Meta] = []
        let filtersDecoder = try container.superDecoder(forKey: .filters)
        var filtersContainer = try filtersDecoder.unkeyedContainer()
        while !filtersContainer.isAtEnd {
            let filterDecoder = try filtersContainer.superDecoder()
            let filter = try Meta(from: filterDecoder, tags: self.tags, groups: self.groups)
            decodedFilters.append(filter)
        }
        self.filters = decodedFilters
    }
}

// MARK: - ExtendedFiltersMeta + Meta

extension ExtendedFiltersMeta {
    struct Meta: ExtendedFilterMetaProtocol, Decodable {
        let filterId: Int
        let name: String?
        let description: String?
        let timeAdded: Date?
        let homePage: String?
        let updateFrequency: Int?
        let displayNumber: Int
        let group: GroupMetaProtocol
        let filterDownloadPage: String?
        let trustLevel: TrustLevel
        let version: String?
        let lastUpdateDate: Date?
        let languages: [String]
        let tags: [Tag]
        
        enum CodingKeys: String, CodingKey {
            case filterId
            case name
            case description
            case timeAdded
            case homePage = "homepage"
            case updateFrequency = "expires"
            case displayNumber
            case group = "groupId"
            case filterDownloadPage = "subscriptionUrl"
            case trustLevel
            case version
            case lastUpdateDate = "timeUpdated"
            case languages
            case tags
        }
        
        init(from decoder: Decoder) throws {
            try self.init(from: decoder, tags: [], groups: [])
        }
        
        init(from decoder: Decoder, tags: [Tag], groups: [GroupMetaProtocol]) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.filterId = try container.decode(Int.self, forKey: .filterId)
            self.name = try container.decode(String.self, forKey: .name)
            self.description = try container.decode(String.self, forKey: .description)
            self.homePage = try container.decode(String.self, forKey: .homePage)
            self.updateFrequency = try container.decode(Int.self, forKey: .updateFrequency)
            self.displayNumber = try container.decode(Int.self, forKey: .displayNumber)
            self.filterDownloadPage = try container.decode(String.self, forKey: .filterDownloadPage)
            self.trustLevel = try container.decode(TrustLevel.self, forKey: .trustLevel)
            self.version = try container.decode(String.self, forKey: .version)
            self.languages = try container.decode([String].self, forKey: .languages)
            
            let groupId = try container.decode(Int.self, forKey: .group)
            self.group = groups.first(where: { $0.groupId == groupId })!
            
            let intTags = try container.decode([Int].self, forKey: .tags)
            self.tags = intTags.compactMap({ intTag in
                return tags.first(where: { $0.tagId == intTag })
            })
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let timeAddedString = try container.decode(String.self, forKey: .timeAdded)
            let lastUpdateDateString = try container.decode(String.self, forKey: .lastUpdateDate)
        
            self.timeAdded = dateFormatter.date(from: timeAddedString)
            self.lastUpdateDate = dateFormatter.date(from: lastUpdateDateString)
        }
        
        init(filterId: Int, name: String?, description: String?, timeAdded: Date?, homePage: String?, updateFrequency: Int?, displayNumber: Int, group: GroupMetaProtocol, filterDownloadPage: String?, trustLevel: ExtendedFiltersMeta.TrustLevel, version: String?, lastUpdateDate: Date?, languages: [String], tags: [ExtendedFiltersMeta.Tag]) {
            self.filterId = filterId
            self.name = name
            self.description = description
            self.timeAdded = timeAdded
            self.homePage = homePage
            self.updateFrequency = updateFrequency
            self.displayNumber = displayNumber
            self.group = group
            self.filterDownloadPage = filterDownloadPage
            self.trustLevel = trustLevel
            self.version = version
            self.lastUpdateDate = lastUpdateDate
            self.languages = languages
            self.tags = tags
        }
        
        // Initializer for custom filter
        init(customFilterMeta: ExtendedCustomFilterMetaProtocol, filterId: Int, timeAdded: Date? = Date(), displayNumber: Int, group: GroupMetaProtocol) {
            self.filterId = filterId
            self.name = customFilterMeta.name
            self.description = customFilterMeta.description
            self.version = customFilterMeta.version
            self.lastUpdateDate = customFilterMeta.lastUpdateDate
            self.updateFrequency = customFilterMeta.updateFrequency
            self.homePage = customFilterMeta.homePage
            self.filterDownloadPage = customFilterMeta.filterDownloadPage
            self.timeAdded = timeAdded
            self.displayNumber = displayNumber
            self.trustLevel = .full
            self.languages = []
            self.tags = []
            self.group = group
        }
    }
}

// MARK: - ExtendedFiltersMeta + TrustLevel

extension ExtendedFiltersMeta {
    enum TrustLevel: String, Decodable {
        case full
        case high
        case low
    }
}

// MARK: - ExtendedFiltersMeta + Group

extension ExtendedFiltersMeta {
    struct Group: Decodable, GroupMetaProtocol {
        let groupId: Int
        let groupName: String
        let displayNumber: Int
    }
}

// MARK: - ExtendedFiltersMeta + Tag

extension ExtendedFiltersMeta {
    struct Tag: Decodable {
        enum TagType: String, Codable {
            case purpose
            case lang
            case recommended
            case platform
            case problematic
            case obsolete
            
            var id: Int {
                switch self {
                case .purpose: return 0
                case .lang: return 1
                case .recommended: return 2
                case .platform: return 4
                case .problematic: return 5
                case .obsolete: return 6
                }
            }
            
            init?(tagTypeId: Int) {
                switch tagTypeId {
                case 0: self = .purpose
                case 1: self = .lang
                case 2: self = .recommended
                case 4: self = .platform
                case 5: self = .problematic
                case 6: self = .obsolete
                default: return nil
                }
            }
        }
        
        let tagId: Int
        let tagType: TagType
        let tagName: String
        
        enum CodingKeys: String, CodingKey {
            case tagId
            case keyword
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.tagId = try container.decode(Int.self, forKey: .tagId)
            
            /*
             Tags can be complex and contain extra info using :
             For example:
             simple tag: 'recommended'
             complex tag: 'purpose:annoyances'
             */
            let keyword = try container.decode(String.self, forKey: .keyword)
            let tagParts = keyword.split(separator: ":").map { String($0) }
            self.tagName = tagParts.count == 2 ? tagParts[1] : tagParts[0]
            if let tagType = TagType(rawValue: tagParts[0]) {
                self.tagType = tagType
            } else {
                throw NSError(domain: "unknown.tag.type", code: 1, userInfo: nil)
            }
        }
        
        init(tagId: Int, tagType: ExtendedFiltersMeta.Tag.TagType, tagName: String) {
            self.tagId = tagId
            self.tagType = tagType
            self.tagName = tagName
        }
        
        init?(tagId: Int, tagTypeId: Int, tagName: String) {
            if let tagType = ExtendedFiltersMeta.Tag.TagType(tagTypeId: tagTypeId) {
                self.tagType = tagType
            } else {
                return nil
            }
            self.tagId = tagId
            self.tagName = tagName
        }
    }
}
