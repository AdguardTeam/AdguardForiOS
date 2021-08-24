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
@_implementationOnly import SQLite

/* FilterTagsTable; filter_tags table */
struct FilterTagsTable {
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

// MARK: - MetaStorage + Tags

protocol TagsMetaStorageProtocol {
    func getAllTags() throws -> [FilterTagsTable]
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable]
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws
    func deleteTagsForFilters(withIds ids: [Int]) throws
}

extension MetaStorage: TagsMetaStorageProtocol {
    
    // Returns all tags from database
    func getAllTags() throws -> [FilterTagsTable] {
        // Query: SELECT * FROM filter_tags OREDER BY filter_id
        let query = FilterTagsTable.table.order(FilterTagsTable.filterId)
        
        let result: [FilterTagsTable] = try filtersDb.prepare(query).map { FilterTagsTable(dbTag: $0) }
        Logger.logDebug("(FiltersMetaStorage) - allTags returning \(result.count) tags objects")
        return result
    }
    
    // Returns array of tags for filter with specified id
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable] {
        // Query: SELECT * FROM filter_tags WHERE filter_id = id ORDER BY tag_id
        let query = FilterTagsTable.table
                                   .filter(id == FilterTagsTable.filterId)
                                   .order(FilterTagsTable.tagId)
        
        let result: [FilterTagsTable] = try filtersDb.prepare(query).map { FilterTagsTable(dbTag: $0) }
        Logger.logDebug("(FiltersMetaStorage) - getTagsForFilter returning \(result.count) tags objects for filter with id=\(id)")
        return result
    }
    
    /*
     Updates all passed tags for filter.
     Adds new tags if some are missing.
     If there are some tags from database that are not present in passed list than they will be deleted
     */
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws {
        for tag in tags {
            try update(tag: tag, forFilterWithId: id)
        }
        
        // Remove tags
        let tagsIds = tags.map { $0.tagId }
        let tagsToDelete = FilterTagsTable.table.filter(FilterTagsTable.filterId == id && !tagsIds.contains(FilterTagsTable.tagId))
        let deletedRows = try filtersDb.run(tagsToDelete.delete())
        Logger.logDebug("(FiltersMetaStorage) - updateAll tags; deleted \(deletedRows) rows")
    }
    
    // Updates passed tag for filter. If tag is missing adds it
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws {
        // Query: INSERT OR REPLACE INTO filter_tags (filter_id, tag_id, type, name)
        let query = FilterTagsTable.table.insert(or: .replace,
                                                 FilterTagsTable.filterId <- id,
                                                 FilterTagsTable.tagId <- tag.tagId,
                                                 FilterTagsTable.type <- tag.tagType.id,
                                                 FilterTagsTable.name <- tag.tagName)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Insert tag with tagId = \(tag.tagId) and name \(tag.tagName)")
    }
    
    // Deletes tags for filters with passed ids
    func deleteTagsForFilters(withIds ids: [Int]) throws {
        let tagsToDelete = FilterTagsTable.table.filter(ids.contains(FilterTagsTable.filterId))
        let deletedRows = try filtersDb.run(tagsToDelete.delete())
        Logger.logDebug("(FiltersMetaStorage) - deleteTagsForFilters; deleted \(deletedRows) filters")
    }
}
