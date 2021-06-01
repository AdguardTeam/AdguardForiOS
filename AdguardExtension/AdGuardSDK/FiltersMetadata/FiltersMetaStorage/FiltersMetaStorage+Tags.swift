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

// MARK: - FiltersMetaStorageProtocol + Tags methods

extension FiltersMetaStorageProtocol {
    
    // Returns all tags from database
    func getAllTags() throws -> [ExtendedFiltersMeta.Tag] {
        // Query: SELECT * FROM filter_tags OREDER BY tag_id
        let query = FilterTagsTable.table.order(FilterTagsTable.tagId)
        
        let result: [ExtendedFiltersMeta.Tag] = try filtersDb.prepare(query).compactMap { tag in
            let dbTag = FilterTagsTable(dbTag: tag)
            return ExtendedFiltersMeta.Tag(tagId: dbTag.tagId, tagTypeId: dbTag.type, tagName: dbTag.name)
        }
        Logger.logDebug("(FiltersMetaStorage) - allTags returning \(result.count) tags objects")
        return result
    }
    
    // Returns array of tags for filter with specified id
    func getTagsForFilter(withId id: Int) throws -> [ExtendedFiltersMeta.Tag] {
        // Query: SELECT * FROM filter_tags WHERE filter_id = id ORDER BY tag_id
        let query = FilterTagsTable.table.filter(id == FilterTagsTable.filterId)
                                         .order(FilterTagsTable.tagId)
        
        let result: [ExtendedFiltersMeta.Tag] = try filtersDb.prepare(query).compactMap { tag in
            let dbTag = FilterTagsTable(dbTag: tag)
            return ExtendedFiltersMeta.Tag(tagId: dbTag.tagId, tagTypeId: dbTag.type, tagName: dbTag.name)
        }
        Logger.logDebug("(FiltersMetaStorage) - getTagsForFilter returning \(result.count) tags objects for filter with id=\(id)")
        return result
    }
    
    func insertTagsForFilter(withId filterId: Int, tags: [ExtendedFiltersMeta.Tag]) throws {
        
        for tag in tags {
            // Query: INSERT OR REPLACE INTO filter_tags (filter_id, tag_id, type, name)
            let query = FilterTagsTable.table.insert(or: .replace, FilterTagsTable.filterId <- filterId,
                                                     FilterTagsTable.tagId <- tag.tagId,
                                                     FilterTagsTable.type <- tag.tagTypeIntValue,
                                                     FilterTagsTable.name <- tag.tagName)
            try filtersDb.run(query)
            Logger.logDebug("(FiltersMetaStorage) - Insert tag with tagId = \(tag.tagId) and name \(tag.tagName)")
        }
    }
    
    func updateTagsForFilter(withId filterId: Int, oldTag: ExtendedFiltersMeta.Tag, newTag: ExtendedFiltersMeta.Tag) throws {
        // Query: UPDATE filter_tags SET "tagId" = newTag.tagId, "type" = newTag.type, "name" = newTag.name WHERE filter_id = filterId AND tagId = oldTag.tagId
        let query = FilterTagsTable.table.where(FilterTagsTable.filterId == filterId && FilterTagsTable.tagId == oldTag.tagId)
            .update(FilterTagsTable.type <- newTag.tagTypeIntValue,
                    FilterTagsTable.name <- newTag.tagName)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Update old tag with tagId \(oldTag.tagId) and name \(oldTag.tagName) to new tagId  \(newTag.tagId) with name \(newTag.tagName)")
    }
    
    func deleteAllTagsForFilter(withId filterId: Int) throws {
        //Query: DELETE FROM filter_langs WHERE ("filter_id" = tag.filterId)
        let query = FilterTagsTable.table.where(FilterTagsTable.filterId == filterId).delete()
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Delete tags for fitler with id = \(filterId)")
    }
    
    
    func deleteTagsForFilter(withId filterId: Int, tags: [ExtendedFiltersMeta.Tag]) throws {
        for tag in tags {
            // Query: DELETE FROM filter_langs WHERE ("filter_id" = withId AND tagId = tag.tagId)
            let query = FilterTagsTable.table.where(FilterTagsTable.filterId == filterId && FilterTagsTable.tagId == tag.tagId).delete()
            try filtersDb.run(query)
            Logger.logDebug("(FiltersMetaStorage) - Delete tags with tag Id = \(tag.tagId) for fitler with id = \(filterId)")
        }
    }
}
