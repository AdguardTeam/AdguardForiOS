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

/* FilterTagsTable; filter_tags table */
fileprivate struct FilterTagsTable {
    // Properties from table
    let filterId: Int
    let tagId: Int
    let type: Int
    let name: String
    
    // Table name
    static let table = Table("filter_tags")
    
    // Columns names
    static let filterId = Expression<Int>("filter_id")
    static let tagId = Expression<Int>("tag_id")
    static let type = Expression<Int>("type")
    static let name = Expression<String>("name")
    
    // Initializer from DB result
    init(dbTag: Row) {
        self.filterId = dbTag[Self.filterId]
        self.tagId = dbTag[Self.tagId]
        self.type = dbTag[Self.type]
        self.name = dbTag[Self.name]
    }
}

// MARK: - FiltersMetaStorageProtocol + Tags


extension FiltersMetaStorageProtocol {
    var allTags: [ExtendedFiltersMeta.Tag] {
        // Query: select * from filter_tags order by tag_id
        let query = FilterTagsTable.table.select([])
                                         .order(FilterTagsTable.tagId)
        
        let result: [ExtendedFiltersMeta.Tag]? = try? filtersDb.prepare(query).compactMap { tag in
            let dbTag = FilterTagsTable(dbTag: tag)
            return ExtendedFiltersMeta.Tag(tagId: dbTag.tagId, tagTypeId: dbTag.type, tagName: dbTag.name)
        }
        return result ?? []
    }
    
    // Returns array of tags for filter with specified id
    func getTagsForFilter(withId id: Int) -> [ExtendedFiltersMeta.Tag] {
        // Query: select * from filter_tags where filter_id = id order by tag_id
        let query = FilterTagsTable.table.select([])
                                         .filter(id == FilterTagsTable.filterId)
                                         .order(FilterTagsTable.tagId)
        
        let result: [ExtendedFiltersMeta.Tag]? = try? filtersDb.prepare(query).compactMap { tag in
            let dbTag = FilterTagsTable(dbTag: tag)
            return ExtendedFiltersMeta.Tag(tagId: dbTag.tagId, tagTypeId: dbTag.type, tagName: dbTag.name)
        }
        return result ?? []
    }
}
