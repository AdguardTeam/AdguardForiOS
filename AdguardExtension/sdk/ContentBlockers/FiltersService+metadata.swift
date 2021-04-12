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

extension FiltersService {
    
    private static let updatePeriod = 3600 * 6
    
    func metadata(refresh: Bool)->ABECFilterClientMetadata? {
        var savedMeta = resources.filtersMetadataCache
        let lastUpdate = savedMeta?.date ?? Date(timeIntervalSince1970: 0)
        if savedMeta == nil || refresh || Int(lastUpdate.timeIntervalSinceNow) * -1 > FiltersService.updatePeriod  {
            DDLogInfo("FiltersService - start updating metadata")
            
            let group = DispatchGroup()
            group.enter()
            httpRequestService.loadFiltersMetadata { [weak self] metadata in
                if metadata != nil {
                    DDLogInfo("FiltersService - metadata loaded successfull")
                    self?.resources.filtersMetadataCache = metadata
                    savedMeta = metadata
                }
                group.leave()
            }
            
            group.wait()
        }
        
        if savedMeta != nil {
            return savedMeta
        }
        
        // get metadata from database
        
        DDLogInfo("FiltersService - can not obtain filters metadata. Get metadata from default database")
        
        let meta = ABECFilterClientMetadata()
        meta.filters = antibanner?.defaultDbFilters()
        meta.groups = antibanner?.defaultDbGroups()

        return meta
    }
    
    func filtersI18n(refresh: Bool)->ABECFilterClientLocalization? {
        
        var savedI18n = resources.i18nCacheForFilterSubscription
        let lastUpdate = savedI18n?.date ?? Date(timeIntervalSince1970: 0)
        if savedI18n == nil || refresh || Int(lastUpdate.timeIntervalSinceNow * -1) > FiltersService.updatePeriod {
            
            // trying load i18n from backend service.
            
            DDLogInfo("FiltersService - start updating i18n")
            
            let group = DispatchGroup()
            group.enter()
            httpRequestService.loadFiltersLocalizations { [weak self] i18n in
                if i18n != nil {
                    DDLogInfo("FiltersService - i18n loaded successfull")
                    self?.resources.i18nCacheForFilterSubscription = i18n
                    savedI18n = i18n
                }
                group.leave()
            }
            
            group.wait()
        }
        
        if savedI18n != nil {
            return savedI18n
        }
            
        // Trying obtain filters metadata from default DB.
        let i18n = ABECFilterClientLocalization()
        i18n.filters = antibanner?.defaultDbFiltersI18n()
        i18n.groups = antibanner?.defaultDbGroupsI18n()
        
        return i18n
    }
}
