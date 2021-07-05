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

/**
 All filters that we store have their own Group.
 Filters are grouped in order to make navigation easier for user and somehow devide them by Content Blockers
 Filters rules are not always grouped by Content Blockers directly. For more information you can look here **AffinityRulesParser.swift**
 */
public protocol SafariGroupProtocol: GroupMetaProtocol {
    var filters: [SafariFilterProtocol] { get } // Filters that belong to this group
    var isEnabled: Bool { get set } // State of the group. If group is disabled we won't use it's filters
    var groupType: SafariGroup.GroupType { get } // Type of the group. We use it when sending filters to the Content Blockers and some other operations
}

public struct SafariGroup: SafariGroupProtocol {
    public let groupId: Int
    public var filters: [SafariFilterProtocol]
    public var isEnabled: Bool
    public let groupType: SafariGroup.GroupType
    public let groupName: String
    public let displayNumber: Int
    
    // MARK: Initialization
    
    init(filters: [SafariFilterProtocol], isEnabled: Bool, groupId: Int, groupName: String, displayNumber: Int) {
        self.groupId = groupId
        self.filters = filters
        self.isEnabled = isEnabled
        self.groupType = GroupType(rawValue: groupId)!
        self.groupName = groupName
        self.displayNumber = displayNumber
    }
    
    init(filters: [SafariFilterProtocol], isEnabled: Bool, groupType: SafariGroup.GroupType, groupName: String, displayNumber: Int) {
        self.groupId = groupType.id
        self.filters = filters
        self.isEnabled = isEnabled
        self.groupType = groupType
        self.groupName = groupName
        self.displayNumber = displayNumber
    }
    
    init(dbGroup: FilterGroupsTable, filters: [SafariFilterProtocol]) {
        self.groupId = dbGroup.groupId
        self.filters = filters
        self.isEnabled = dbGroup.isEnabled
        self.groupType = GroupType(rawValue: dbGroup.groupId) ?? .ads
        self.groupName = dbGroup.name
        self.displayNumber = dbGroup.displayNumber
    }
}
