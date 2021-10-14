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

// MARK: - MetaStorage + GroupLocalizations
protocol GroupLocalizationsMetaStorageProtocol {
    func getLocalizationForGroup(withId id: Int, forLanguage lang: String) -> FilterGroupLocalizationsTable?
    func updateLocalizationForGroup(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.GroupLocalization) throws
    func collectGroupsMetaLocalizationLanguage(from suitableLanguages: [String]) throws -> String
}

extension MetaStorage: GroupLocalizationsMetaStorageProtocol {

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


    // MARK: - MetaStorage groups meta localization

    // This function iterate over `filter_group_localization` table and return language if DB contains records with first matched language from `suitableLanguages` list
    // If they're no matching languages, then we are looking for similar languages.
    // End if there is no similar languages return default `en` language
    
    func collectGroupsMetaLocalizationLanguage(from suitableLanguages: [String]) throws -> String {
        // Trying to find full match language
        for lang in suitableLanguages{
            // Query: SELECT count(filter_id) FROM filter_group_localization WHERE lang == lang
            let query: ScalarQuery = FilterGroupLocalizationsTable.table.select(FilterLocalizationsTable.filterId.count).where(FilterLocalizationsTable.lang == lang)
            let count = try filtersDb.scalar(query)
            guard count > 0 else { continue }
            return lang
        }

        var foundLanguage = MetaStorage.defaultDbLanguage
        // If language still missed lets try to find similar languages
        let similarLanguages = try collectSimilarGroupsMetaLanguages(for: suitableLanguages.last ?? foundLanguage)
        if let similarLanguage = similarLanguages.first {
            foundLanguage = similarLanguage
        }

        return foundLanguage
    }

    // Return list of similar languages
    // example: if input language `pt` than return [pt-BR, pt-PT]
    private func collectSimilarGroupsMetaLanguages(for language: String) throws -> [String] {
        // Query: SELECT DISTINCT lang FROM filter_group_localizations WHERE (lang LIKE 'language%') AND (lang != 'language') ORDER by lang
        let query = FilterGroupLocalizationsTable
            .table
            .select(distinct: [FilterGroupLocalizationsTable.lang])
            .where(FilterGroupLocalizationsTable.lang.like("\(language)%") && FilterGroupLocalizationsTable.lang != language).order(FilterGroupLocalizationsTable.lang)

        return try filtersDb.prepare(query).compactMap { row in
            return row[FilterGroupLocalizationsTable.lang]
        }
    }
}
