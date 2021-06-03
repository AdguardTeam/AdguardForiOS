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
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) throws -> ExtendedFiltersMetaLocalizations.GroupLocalization? {
        // Query: select * from filter_group_localization where group_id = id and lang = lang
        let query = FilterGroupLocalizationsTable.table.filter(FilterGroupLocalizationsTable.groupId == id && FilterGroupLocalizationsTable.lang == lang)
        
        guard let dbGroulLocalization = try filtersDb.pluck(query) else {
            Logger.logDebug("(FiltersMetaStorage) - query result is nil for filter with id=\(id) for lang=\(lang)")
            return nil
        }
        let groupLocalization = FilterGroupLocalizationsTable(dbGroupLocalization: dbGroulLocalization)
        Logger.logDebug("(FiltersMetaStorage) - getLocalizationForGroup returning \(groupLocalization.name ?? "none") for filter with id=\(id) for lang=\(lang)")
        return ExtendedFiltersMetaLocalizations.GroupLocalization(name: groupLocalization.name ?? "")
    }
    
    //TODO: Remove this method if it would not be used
    func insertOrReplaceLocalizationForGroup(groupId: Int, lang: String, name: String) throws {
        // Query: INSERT OR REPLACE INTO filter_group_localization (group_id, lang, name)
        let query = FilterGroupLocalizationsTable.table.insert(or: .replace,
                                                               FilterGroupLocalizationsTable.groupId <- groupId,
                                                               FilterGroupLocalizationsTable.lang <- lang,
                                                               FilterGroupLocalizationsTable.name <- name)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Insert localization for group with id=\(groupId) lang=\(lang) and name=\(name)")
    }
    
    //TODO: Remove this method if it would not be used
    func updateLocalizationForGroup(groupId: Int, lang: String, name: String) throws {
        // Query: UPDATE filter_group_localization SET lang = lang, name = name WHERE group_id = groupdId
        let query = FilterGroupLocalizationsTable.table
            .where(FilterGroupLocalizationsTable.groupId == groupId &&
                    FilterGroupLocalizationsTable.lang == lang)
            .update(FilterGroupLocalizationsTable.lang <- lang,
                    FilterGroupLocalizationsTable.name <- name)
        
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Update group localization with id=\(groupId) lang=\(lang) and name=\(name)")
    }
    
    //TODO: Remove this method if it would not be used
    func deleteAllLocalizationForGroup(groupId: Int) throws {
        // Query: DELETE FROM filter_group_localization WHERE group_id = groupId
        let query = FilterGroupLocalizationsTable.table.where(FilterGroupLocalizationsTable.groupId == groupId).delete()
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Delete group localizations with id=\(groupId)")
    }
    
    //TODO: Remove this method if it would not be used
    func deleteLocalizationForGroup(groupId: Int, lang: String) throws {
        // Query: DELTE FROM filter_group_localization WHERE group_id = groupId AND lang = lang
        let query = FilterGroupLocalizationsTable.table.where(FilterGroupLocalizationsTable.groupId == groupId &&
                                                                FilterGroupLocalizationsTable.lang == lang).delete()
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Delete group localization with group id=\(groupId) and lang=\(lang)")
    }
}
