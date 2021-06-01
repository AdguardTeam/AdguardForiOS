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

protocol SafariGroupProtocol {
    var filters: [SafariFilterProtocol] { get }
    var isEnabled: Bool { get set }
    var groupType: SafariGroup.GroupType { get }
    var groupName: String { get }
    var displayNumber: Int { get }
}

struct SafariGroup: SafariGroupProtocol {
    var filters: [SafariFilterProtocol]
    var isEnabled: Bool
    let groupType: SafariGroup.GroupType
    let groupName: String
    let displayNumber: Int
    
    // MARK: Initialization
    
    init(filters: [SafariFilterProtocol], isEnabled: Bool, groupId: Int, groupName: String, displayNumber: Int) {
        self.filters = filters
        self.isEnabled = isEnabled
        self.groupType = GroupType(rawValue: groupId)!
        self.groupName = groupName
        self.displayNumber = displayNumber
    }
    
    init(filters: [SafariFilterProtocol], isEnabled: Bool, groupType: SafariGroup.GroupType, groupName: String, displayNumber: Int) {
        self.filters = filters
        self.isEnabled = isEnabled
        self.groupType = groupType
        self.groupName = groupName
        self.displayNumber = displayNumber
    }
    
    init(dbGroup: FilterGroupsTable, filters: [SafariFilterProtocol]) {
        self.filters = filters
        self.isEnabled = dbGroup.isEnabled
        self.groupType = GroupType(rawValue: dbGroup.groupId)!
        self.groupName = dbGroup.name
        self.displayNumber = dbGroup.displayNumber
    }
}
