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
    func getLangsForFilter(withId id: Int) -> [String] {
        // Query: select * from filter_langs where filter_id = id
        let query = FilterLangsTable.table.select([])
                                         .filter(id == FilterLangsTable.filterId)
        
        let result: [String]? = try? filtersDb.prepare(query).compactMap { lang in
            let dbLang = FilterLangsTable(dbLang: lang)
            return dbLang.lang
        }
        Logger.logDebug("(FiltersMetaStorage) - getLangsForFilter returning \(result?.count ?? 0) langs objects for filter with id=\(id)")
        return result ?? []
    }
}
