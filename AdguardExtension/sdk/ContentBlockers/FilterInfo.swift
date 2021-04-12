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

// MARK: - data types -
class Filter: NSObject, NSCopying, FilterDetailedInterface {
    
    let filterId: Int
    
    var name: String?
    var desc: String?
    var version: String?
    var enabled: Bool = false
    var homepage: String?
    var subscriptionUrl: String?
    var tags:[(name: String, highlighted: Bool)]?
    var langs:[(name: String, highlighted: Bool)]?
    var rulesCount: Int?
    var groupId: Int
    var displayNumber: Int?
    var updateDate: Date?
    var searchAttributedString: NSAttributedString?
    var removable: Bool {
        get {
            return groupId == FilterGroupId.custom
        }
    }
    var editable: Bool {
        get {
            return groupId == FilterGroupId.custom
        }
    }
    
    init(filterId: Int, groupId: Int) {
        self.filterId = filterId
        self.groupId = groupId
        super.init()
    }
    
    // MARK: - NSCopying protocol
    /* Creates copy of a class with another reference */
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Filter(filterId: filterId, groupId: groupId)
        
        copy.name = name
        copy.desc = desc
        copy.version = version
        copy.enabled = enabled
        copy.homepage = homepage
        copy.subscriptionUrl = subscriptionUrl
        copy.tags = tags
        copy.langs = langs
        copy.rulesCount = rulesCount
        copy.displayNumber = displayNumber
        copy.updateDate = updateDate
        copy.searchAttributedString = searchAttributedString
        
        return copy
    }
}

class Group: Hashable, NSCopying {
    
    let groupId: Int
    
    var name: String?
    var subtitle: String?
    var enabled: Bool = false
    var iconName: String?
    var disabledIconName: String?
    var proOnly: Bool = false
    
    var filters: [Filter] = [Filter]()
    
    init(_ groupId: Int) {
        self.groupId = groupId
    }
    
    // MARK: - Hashable protocol
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.groupId == rhs.groupId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(groupId)
    }

    // MARK: - NSCopying protocol
    /* Creates copy of a class with another reference */
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Group(groupId)
        copy.name = name
        copy.subtitle = subtitle
        copy.enabled = enabled
        copy.iconName = iconName
        copy.disabledIconName = disabledIconName
        copy.proOnly = proOnly
        copy.filters = filters
        return copy
    }
}
