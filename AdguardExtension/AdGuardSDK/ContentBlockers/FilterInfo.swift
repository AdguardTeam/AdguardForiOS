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
public class Filter: NSObject, NSCopying, FilterDetailedInterface {
    
    public let filterId: Int
    
    public var name: String?
    public var desc: String?
    public var version: String?
    public var enabled: Bool = false
    public var homepage: String?
    public var subscriptionUrl: String?
    public var tags:[(name: String, highlighted: Bool)]?
    public var langs:[(name: String, highlighted: Bool)]?
    public var rulesCount: Int?
    public var groupId: Int
    public var displayNumber: Int?
    public var updateDate: Date?
    public var searchAttributedString: NSAttributedString?
    public var removable: Bool {
        get {
            return groupId == AdGuardFilterGroup.custom.rawValue
        }
    }
    public var editable: Bool {
        get {
            return groupId == AdGuardFilterGroup.custom.rawValue
        }
    }
    
    public init(filterId: Int, groupId: Int) {
        self.filterId = filterId
        self.groupId = groupId
        super.init()
    }
    
    // MARK: - NSCopying protocol
    /* Creates copy of a class with another reference */
    public func copy(with zone: NSZone? = nil) -> Any {
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

public class Group: Hashable, NSCopying {
    
    public let groupId: Int
    
    public var name: String?
    public var subtitle: String?
    public var enabled: Bool = false
    public var iconName: String?
    public var disabledIconName: String?
    public var proOnly: Bool = false
    
    public var filters: [Filter] = [Filter]()
    
    init(_ groupId: Int) {
        self.groupId = groupId
    }
    
    // MARK: - Hashable protocol
    public static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.groupId == rhs.groupId
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(groupId)
    }

    // MARK: - NSCopying protocol
    /* Creates copy of a class with another reference */
    public func copy(with zone: NSZone? = nil) -> Any {
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
