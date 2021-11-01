///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import SharedAdGuardSDK
import SQLite

/* FilterLocalizationsTable; filter_localizations table */
struct FilterLocalizationsTable {
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

// MARK: - MetaStorage + FiltersLocalizations methods

protocol FiltersLocalizationsMetaStorageProtocol {
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable?
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws
    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws
    func deleteAllLocalizationForFilter(withId id: Int) throws
    func collectFiltersMetaLocalizationLanguage(from suitableLanguages: [String]) throws -> String
}

extension MetaStorage: FiltersLocalizationsMetaStorageProtocol {

    // Returns localized strings for specified filter and language
    func getLocalizationForFilter(withId id: Int, forLanguage lang: String) throws -> FilterLocalizationsTable? {
        // Query: SELECT * FROM filter_localizations WHERE filter_id = id AND lang = lang
        let query = FilterLocalizationsTable.table.filter(FilterLocalizationsTable.filterId == id && FilterLocalizationsTable.lang == lang)

        guard let dbFilterLocalization = try? filtersDb.pluck(query) else {
            return nil
        }
        let filterLocalization = FilterLocalizationsTable(dbFilterLocalization: dbFilterLocalization)
        Logger.logDebug("(FiltersMetaStorage) - getLocalizationForFilter returning \(filterLocalization.name ?? "none") for filter with id=\(id) for lang=\(lang)")
        return filterLocalization
    }

    // Updates localization for filter. Adds new localization if missing.
    func updateLocalizationForFilter(withId id: Int, forLanguage lang: String, localization: ExtendedFiltersMetaLocalizations.FilterLocalization) throws {
        // Query: INSERT OR REPLACE INTO filter_localizations (filter_id, lang, name, description)
        let query = FilterLocalizationsTable.table
                                            .insert(or: .replace,
                                                    FilterLocalizationsTable.filterId <- id,
                                                    FilterLocalizationsTable.lang <- lang,
                                                    FilterLocalizationsTable.name <- localization.name,
                                                    FilterLocalizationsTable.description <- localization.description)
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Insert localization for filter with id=\(id) for lang=\(lang)")
    }

    func deleteAllLocalizationForFilters(withIds ids: [Int]) throws {
        for id in ids {
            try deleteAllLocalizationForFilter(withId: id)
        }
    }

    func deleteAllLocalizationForFilter(withId id: Int) throws {
        // Query: DELETE FROM filter_localizations WHERE filter_id = id
        let query = FilterLocalizationsTable.table.where(FilterLocalizationsTable.filterId == id).delete()
        try filtersDb.run(query)
        Logger.logDebug("(FiltersMetaStorage) - Delete all localization for filter with id=\(id)")
    }

    // MARK: - MetaStorage filters meta localization

    /**
     This function iterates over `filter_localization` table and returns language if DB contains records with first matched language from `suitableLanguages` list.
     If there are no matching languages, then we are looking for similar languages.
     End if there is no similar languages return default `en` language.
     */
    func collectFiltersMetaLocalizationLanguage(from suitableLanguages: [String]) throws -> String {

        // Trying to find full match language
        for lang in suitableLanguages {
            // Query: SELECT count(filter_id) FROM filter_localization WHERE lang == lang
            let query: ScalarQuery = FilterLocalizationsTable
                .table
                .select(FilterLocalizationsTable.filterId.count)
                .where(FilterLocalizationsTable.lang == lang)
            let count = try filtersDb.scalar(query)
            guard count > 0 else { continue }
            return lang
        }

        var foundLanguage = MetaStorage.defaultDbLanguage
        /*
         Trying to find similar languages if language is still missed
         The last element of the `suitableLanguages` list is a simple language code such as `se` or `en`.
         */
        let similarLanguages = try collectSimilarFiltersMetaLanguages(for: suitableLanguages.last ?? foundLanguage)
        if let similarLanguage = similarLanguages.first {
            foundLanguage = similarLanguage
        }

        return foundLanguage
    }

    /**
     Returns list of similar languages.
     Example: if input language `pt` then returns [pt_BR, pt_PT].
     */
    private func collectSimilarFiltersMetaLanguages(for language: String) throws -> [String] {
        // Query: SELECT DISTINCT lang FROM filter_localizations WHERE (lang LIKE 'language%') AND (lang != 'language') ORDER by lang
        let query = FilterLocalizationsTable
            .table
            .select(distinct: [FilterLocalizationsTable.lang])
            .where(FilterLocalizationsTable.lang.like("\(language)%") && FilterLocalizationsTable.lang != language)
            .order(FilterLocalizationsTable.lang)

        return try filtersDb.prepare(query).compactMap { row in
            return row[FilterLocalizationsTable.lang]
        }
    }
}
