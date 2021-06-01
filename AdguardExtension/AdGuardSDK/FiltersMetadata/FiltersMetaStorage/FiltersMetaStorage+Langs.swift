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

/* FilterLangsTablel; filter_langs table */
fileprivate struct FilterLangsTable {
    // Properties from table
    let filterId: Int
    let lang: String
    
    // Table name
    static let table = Table("filter_langs")
    
    // Columns names
    static let filterId = Expression<Int>("filter_id")
    static let lang = Expression<String>("lang")
    
    // Initializer from DB result
    init(dbLang: Row) {
        self.filterId = dbLang[Self.filterId]
        self.lang = dbLang[Self.lang]
    }
}

// MARK: - FiltersMetaStorageProtocol + Langs methods

extension FiltersMetaStorageProtocol {
    // Returns array of languages for filter with specified id
    func getLangsForFilter(withId id: Int) throws -> [String] {
        // Query: SELECT * FROM filter_langs WHERE filter_id = id
        let query = FilterLangsTable.table.filter(id == FilterLangsTable.filterId)
        
        let result: [String] = try filtersDb.prepare(query).compactMap { lang in
            let dbLang = FilterLangsTable(dbLang: lang)
            return dbLang.lang
        }
        Logger.logDebug("(FiltersMetaStorage) - getLangsForFilter returning \(result.count) langs objects for filter with id=\(id)")
        return result
    }
    
    func insertLangsIntoFilter(langs: [String], forFilterId filterId: Int) throws {
        for lang in langs {
            let query = FilterLangsTable.table.insert(or: .replace ,FilterLangsTable.filterId <- filterId, FilterLangsTable.lang <- lang)
            // Query: INSERT INTO filter_langs (filter_id, lang)
            try filtersDb.run(query)
            Logger.logDebug("(FiltersMetaStorage) -  Insert row with filterID \(filterId) and lang \(lang)")
        }
    }
    
    func updateFiltersLang(oldLang: String, newLang: String, forFilterId filterId: Int) throws {
        let query = FilterLangsTable.table.where(FilterLangsTable.filterId == filterId && FilterLangsTable.lang == oldLang).update(FilterLangsTable.lang <- newLang)
        // Query: UPDATE filter_langs SET "lang" = newLang WHERE ("filter_id = filterId" AND "lang" == oldLang)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) -  Update row with filterID \(filterId) and old lang \(oldLang) with new lang \(newLang)")
    }
    
    func deleteAllLangsForFilter(withId filterId: Int) throws {
        let query = FilterLangsTable.table.where(FilterLangsTable.filterId == filterId).delete()
        // Query: DELETE FROM filter_langs WHERE ("filter_id" = fitlerId)

        let rowId = try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) -  row number \(rowId) deleted for filter with id=\(filterId)")
    }
    
    func deleteLangsForFilter(withId filterId: Int, langs: [String]) throws {
        for lang in langs {
            let query = FilterLangsTable.table.where(FilterLangsTable.filterId == filterId && FilterLangsTable.lang == lang).delete()
            let rowId = try filtersDb.run(query)
            Logger.logDebug("(FiltersMetaStorage) -  row number \(rowId) deleted for filter with id=\(filterId) and lang = \(lang)")
        }
    }
}
