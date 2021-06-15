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

// MARK: - ExtendedFiltersMetaLocalizations

/* ExtendedFiltersMetaLocalizations is an object representation of json from https://filters.adtidy.org/ios/filters_i18n.js */
struct ExtendedFiltersMetaLocalizations: Decodable {
    let groups: [Int: [String: GroupLocalization]] // [groupId: [lang: GroupLocalization]]
    let tags: [Int: [String: TagLocalization]] // [tagId: [lang: GroupLocalization]]
    let filters: [Int: [String: FilterLocalization]] // [filterId: [lang: FilterLocalization]]
}

// MARK: - ExtendedFiltersMetaLocalizations + FilterLocalization

extension ExtendedFiltersMetaLocalizations {
    struct FilterLocalization: Decodable {
        let name: String
        let description: String
    }
}

// MARK: - ExtendedFiltersMetaLocalizations + TagLocalization

extension ExtendedFiltersMetaLocalizations {
    struct TagLocalization: Decodable {
        let name: String
        let description: String
    }
}

// MARK: - ExtendedFiltersMetaLocalizations + GroupLocalization

extension ExtendedFiltersMetaLocalizations {
    struct GroupLocalization: Decodable {
        let name: String
        
        init(name: String) {
            self.name = name
        }
    }
}
