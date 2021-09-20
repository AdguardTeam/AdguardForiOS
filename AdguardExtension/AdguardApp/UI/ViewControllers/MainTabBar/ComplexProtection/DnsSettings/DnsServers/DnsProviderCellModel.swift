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

/// Provider cell model for providers table view
struct DnsProviderCellModel {
    let name: String?
    let providerDescription: String?
    let isCustomProvider: Bool
    let providerId: Int?
    let isCurrent: Bool
    let isDefaultProvider: Bool
    
    init(name: String?, description: String?, isCurrent: Bool, isDefaultProvider: Bool, isCustomProvider: Bool, providerId: Int?) {
        self.name = name
        self.providerDescription = description
        self.isCurrent = isCurrent
        self.providerId = providerId
        self.isDefaultProvider = isDefaultProvider
        self.isCustomProvider = isCustomProvider
    }
}
