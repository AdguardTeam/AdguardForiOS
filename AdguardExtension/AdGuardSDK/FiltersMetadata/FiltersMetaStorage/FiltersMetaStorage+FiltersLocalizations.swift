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

/* FilterLocalizationsTable; filter_localizations table */
fileprivate struct FilterLocalizationsTable {
    // Properties from table
    let filterId: Int
    let lang: String?
    let name: String?
    let description: String?
    
    // Table name
    static let table = Table("filter_localizations")
    
    // Columns names
    static let filterId = Expression<Int>("filter_id")
    static let lang = Expression<String>("lang")
    static let name = Expression<String>("name")
    static let description = Expression<String>("description")
    
    // Initializer from DB result
    init(dbFilterLocalization: Row?) {
        self.filterId = dbFilterLocalization?[FilterLocalizationsTable.filterId] ?? -1
        self.lang = dbFilterLocalization?[FilterLocalizationsTable.lang]
        self.name = dbFilterLocalization?[FilterLocalizationsTable.name]
        self.description = dbFilterLocalization?[FilterLocalizationsTable.description]
    }
}

// MARK: - FiltersMetaStorageProtocol + FiltersLocalizations
 
extension FiltersMetaStorageProtocol {
    
    // Returns localized strings for specified filter and language
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> ExtendedFiltersMetaLocalizations.FilterLocalization {
        // Query: select * from filter_localizations where filter_id = id and lang = lang
        let query = FilterLocalizationsTable.table
                                            .select([])
                                            .filter(FilterLocalizationsTable.filterId == id && FilterLocalizationsTable.lang == lang)
        
        let dbFilterLocalization = try filtersDb.pluck(query)
        let filterLocalization = FilterLocalizationsTable(dbFilterLocalization: dbFilterLocalization)
        Logger.logDebug("(FiltersMetaStorage) - getLocalizationForFilter returning \(filterLocalization.name ?? "none") for filter with id=\(id) for lang=\(lang)")
        return ExtendedFiltersMetaLocalizations.FilterLocalization(name: filterLocalization.name ?? "", description: filterLocalization.description ?? "")
    }
}
