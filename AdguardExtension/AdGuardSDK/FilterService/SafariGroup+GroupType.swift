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

public extension SafariGroup {
    public enum GroupType: Int, Equatable {
        case ads = 1
        case privacy = 2
        case socialWidgets = 3
        case annoyances = 4
        case security = 5
        case other = 6
        case languageSpecific = 7
        case custom = 101
        
        var id: Int { self.rawValue }
        
        var proOnly: Bool {
            switch self {
            case .security, .custom: return true
            default: return false
            }
        }
    }
}
