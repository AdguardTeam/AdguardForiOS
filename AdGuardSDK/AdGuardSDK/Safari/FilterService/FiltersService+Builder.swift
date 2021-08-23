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

protocol FiltersServiceForBuilderProtocol {
    func downloadAndSaveFiltersMeta() throws
}

extension FiltersService: FiltersServiceForBuilderProtocol {
    
    /// This function should be used only in builder
    func downloadAndSaveFiltersMeta() throws {
        var resultError: Error?
        let group = DispatchGroup()
        group.enter()
        apiMethods.loadFiltersMetadata(version: configuration.appProductVersion,
                                       id: configuration.appId,
                                       cid: configuration.cid,
                                       lang: configuration.currentLanguage) { [unowned self] filtersMeta in
            
            if let meta = filtersMeta {
                do {
                    try saveFiltersMetaToDB(meta)
                } catch {
                    resultError = error
                }
            } else {
                resultError = Self.FilterServiceError.unknownError
            }
            group.leave()
        }
        group.wait()
        
        if let resultError = resultError {
            throw resultError
        }
        
        group.enter()
        apiMethods.loadFiltersLocalizations { [unowned self] filtersMetaLocalizations in
            if let localizations = filtersMetaLocalizations {
                do {
                    try save(localizations: localizations)
                } catch {
                    resultError = error
                }
            }
            group.leave()
        }
        group.wait()
        
        if let resultError = resultError {
            throw resultError
        }
    }
    
    private func saveFiltersMetaToDB(_ meta: ExtendedFiltersMeta) throws {
        // Meta received from the server
        let allGroupsMeta = meta.groups
        let allFiltersMeta = meta.filters
        
        // Update Groups meta
        try metaStorage.add(groups: allGroupsMeta)
        let addedIds = add(filters: allFiltersMeta)
        assert(addedIds.count == allFiltersMeta.count, "Feels like some filters failed to load")
    }
    
    /* Updates filters and groups localizations in database that were downloaded */
    private func save(localizations: ExtendedFiltersMetaLocalizations) throws {
        // Groups localizations received from the server
        let allGroupsLocalizations = localizations.groups
        let allGroupIdsReceived = allGroupsLocalizations.keys
        
        // Updating groups localizations in database
        for groupId in allGroupIdsReceived {
            let localizationsByLangs = allGroupsLocalizations[groupId] ?? [:]
            let langs = localizationsByLangs.keys
            for lang in langs {
                let localization = localizationsByLangs[lang]!
                try metaStorage.updateLocalizationForGroup(withId: groupId, forLanguage: lang, localization: localization)
            }
        }
        
        // Filters localizations received from the server
        let allFilterLocalizations = localizations.filters
        let allFilterIdsReceived = allFilterLocalizations.keys
        
        // Updating filters localizations in database
        for filterId in allFilterIdsReceived {
            let localizationsByLangs = allFilterLocalizations[filterId] ?? [:]
            let langs = localizationsByLangs.keys
            for lang in langs {
                let localization = localizationsByLangs[lang]!
                try metaStorage.updateLocalizationForFilter(withId: filterId, forLanguage: lang, localization: localization)
            }
        }
    }
}
