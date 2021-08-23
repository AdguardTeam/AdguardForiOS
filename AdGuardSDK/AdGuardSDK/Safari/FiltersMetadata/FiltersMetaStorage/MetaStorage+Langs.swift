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

// MARK: - MetaStorage + Langs
protocol LangsMetaStorageProtocol {
    func getLangsForFilter(withId id: Int) throws -> [String]
    func updateAll(langs: [String], forFilterWithId id: Int) throws
    func update(lang: String, forFilterWithId id: Int) throws
    func deleteLangsForFilters(withIds ids: [Int]) throws
}

extension MetaStorage: LangsMetaStorageProtocol {
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
    
    /*
     Updates all passed languages for filter.
     Adds new languages if some are missing.
     If there are some languages from database that are not present in passed list than they will be deleted
     */
    func updateAll(langs: [String], forFilterWithId id: Int) throws {
        for lang in langs {
            try update(lang: lang, forFilterWithId: id)
        }
        let langsToDelete = FilterLangsTable.table.filter(FilterLangsTable.filterId == id && !langs.contains(FilterLangsTable.lang))
        let deletedRows = try filtersDb.run(langsToDelete.delete())
        Logger.logDebug("(FiltersMetaStorage) - updateAll langs; deleted \(deletedRows) rows")
    }
    
    // Updates passed language for filter. If language is missing adds it
    func update(lang: String, forFilterWithId id: Int) throws {
        let query = FilterLangsTable.table.insert(or: .replace ,FilterLangsTable.filterId <- id, FilterLangsTable.lang <- lang)
        // Query: INSERT OR REPLACE INTO filter_langs (filter_id, lang)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) -  Insert row with filterID \(id) and lang \(lang)")
    }
    
    // Deletes langs for filters with passed ids
    func deleteLangsForFilters(withIds ids: [Int]) throws {
        let langsToDelete = FilterLangsTable.table.filter(ids.contains(FilterLangsTable.filterId))
        let deletedRows = try filtersDb.run(langsToDelete.delete())
        Logger.logDebug("(FiltersMetaStorage) - deleteLangsForFilters; deleted \(deletedRows) filters")
    }
}
