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
struct FilterGroupLocalizationsTable {
    // Properties from table
    let groupId: Int
    let lang: String
    let name: String?
    
    // Table name
    static let table = Table("filter_group_localizations")
    
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
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> FilterGroupLocalizationsTable? {
        // Query: select * from filter_group_localization where group_id = id and lang = lang
        let query = FilterGroupLocalizationsTable.table.filter(FilterGroupLocalizationsTable.groupId == id && FilterGroupLocalizationsTable.lang == lang)
        
        guard let dbGroulLocalization = try? filtersDb.pluck(query) else {
            Logger.logDebug("(FiltersMetaStorage) - query result is nil for filter with id=\(id) for lang=\(lang)")
            return nil
        }
        let groupLocalization = FilterGroupLocalizationsTable(dbGroupLocalization: dbGroulLocalization)
        Logger.logDebug("(FiltersMetaStorage) - getLocalizationForGroup returning \(groupLocalization) for filter with id=\(id) for lang=\(lang)")
        return groupLocalization
    }
    
    // Updates localization for group. Adds new localization if missing.
    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws {
        // Query: INSERT OR REPLACE INTO filter_group_localization (group_id, lang, name)
        let query = FilterGroupLocalizationsTable.table.insert(or: .replace,
                                                               FilterGroupLocalizationsTable.groupId <- id,
                                                               FilterGroupLocalizationsTable.lang <- lang,
                                                               FilterGroupLocalizationsTable.name <- localization.name)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Insert localization for group with id=\(id) lang=\(lang) and name=\(localization.name)")
    }
}
