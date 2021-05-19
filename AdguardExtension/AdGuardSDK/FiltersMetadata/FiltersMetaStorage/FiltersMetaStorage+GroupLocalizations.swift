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
import SQLite

/* FilterGroupLocalizationsTable; filter_group_localization table */
fileprivate struct FilterGroupLocalizationsTable {
    // Properties from table
    let groupId: Int
    let lang: String
    let name: String?
    
    // Table name
    static let table = Table("filter_group_localization")
    
    // Columns names
    static let groupId = Expression<Int>("group_id")
    static let lang = Expression<String>("lang")
    static let name = Expression<String>("name")
    
    // Initializer from DB result
    init(dbGroupLocalization: Row?) {
        self.groupId = dbGroupLocalization?[Self.groupId] ?? -1
        self.lang = dbGroupLocalization?[Self.lang] ?? ""
        self.name = dbGroupLocalization?[Self.name]
    }
}

// MARK: - FiltersMetaStorageProtocol + GroupLocalizations methods

extension FiltersMetaStorageProtocol {
    
    // Returns localized strings for specified group and language
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> ExtendedFiltersMetaLocalizations.GroupLocalization {
        // Query: select * from filter_group_localization where group_id = id and lang = lang
        let query = FilterGroupLocalizationsTable.table
                                                 .select([])
                                                 .filter(FilterGroupLocalizationsTable.groupId == id && FilterGroupLocalizationsTable.lang == lang)
        
        let dbGroulLocalization = try? filtersDb.pluck(query)
        let groupLocalization = FilterGroupLocalizationsTable(dbGroupLocalization: dbGroulLocalization)
        return ExtendedFiltersMetaLocalizations.GroupLocalization(name: groupLocalization.name ?? "")
    }
}
