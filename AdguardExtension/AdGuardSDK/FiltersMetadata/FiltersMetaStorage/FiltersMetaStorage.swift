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

typealias FiltersMetaStorageMultiProtocol = FiltersMetaStorageProtocol_Filters &
    FiltersMetaStorageProtocol_Groups &
    FiltersMetaStorageProtocol_Tags &
    FiltersMetaStorageProtocol_Tags &
    FiltersMetaStorageProtocol_Langs &
    FiltersMetaStorageProtocol_GroupLocalizations &
    FiltersMetaStorageProtocol_FiltersLocalizations

protocol FiltersMetaStorageProtocol: FiltersMetaStorageMultiProtocol, AnyObject {
    static var defaultDbLanguage: String { get }
    var filtersDb: Connection { get }
}

// MARK: - FiltersMetaStorageProtocol + Filters methods
protocol FiltersMetaStorageProtocol_Filters {
    var nextCustomFilterId: Int { get }
    
    func getLocalizedFiltersForGroup(withId id: Int, forLanguage lang: String) throws -> [FiltersTable]
    func setFilter(withId id: Int, enabled: Bool) throws
    func updateAll(filters: [ExtendedFilterMetaProtocol]) throws
    func update(filter: ExtendedFilterMetaProtocol) throws
    func add(filter: ExtendedFilterMetaProtocol, enabled: Bool) throws
    func deleteFilter(withId id: Int) throws
    func deleteFilters(withIds ids: [Int]) throws
    func renameFilter(withId id: Int, name: String) throws
}

// MARK: - FiltersMetaStorageProtocol + Groups methods
protocol FiltersMetaStorageProtocol_Groups {
    func getAllLocalizedGroups(forLanguage lang: String) throws -> [FilterGroupsTable]
    func setGroup(withId id: Int, enabled: Bool) throws
    func updateAll(groups: [GroupMetaProtocol]) throws
    func update(group: GroupMetaProtocol) throws
}

// MARK: - FiltersMetaStorageProtocol + Tags methods
protocol FiltersMetaStorageProtocol_Tags {
    func getAllTags() throws -> [FilterTagsTable]
    func getTagsForFilter(withId id: Int) throws -> [FilterTagsTable]
    func updateAll(tags: [ExtendedFiltersMeta.Tag], forFilterWithId id: Int) throws
    func update(tag: ExtendedFiltersMeta.Tag, forFilterWithId id: Int) throws
    func deleteTagsForFilters(withIds ids: [Int]) throws
}

// MARK: - FiltersMetaStorageProtocol + Langs methods
protocol FiltersMetaStorageProtocol_Langs {
    func getLangsForFilter(withId id: Int) throws -> [String]
    func updateAll(langs: [String], forFilterWithId id: Int) throws
    func update(lang: String, forFilterWithId id: Int) throws
    func deleteLangsForFilters(withIds ids: [Int]) throws
}

// MARK: - FiltersMetaStorageProtocol + Group localizations methods
protocol FiltersMetaStorageProtocol_GroupLocalizations {
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> FilterGroupLocalizationsTable?
    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws
}

// MARK: - FiltersMetaStorageProtocol + Filters localizations methods
protocol FiltersMetaStorageProtocol_FiltersLocalizations {
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable?
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws
    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws
    func deleteAllLocalizationForFilter(withId id: Int) throws
}

final class FiltersMetaStorage: FiltersMetaStorageProtocol {
    // MARK: - Public properties
    static var defaultDbLanguage: String = "en"
    
    let filtersDb: Connection
    
    // MARK: - Initialization
    
    init(productionDbManager: ProductionDatabaseManagerProtocol) {
        self.filtersDb = productionDbManager.filtersDb
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
}
