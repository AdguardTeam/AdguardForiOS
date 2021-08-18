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

import SafariAdGuardSDK

typealias SafariGroupFiltersModel = (groupModel: SafariGroupStateHeaderModel, filtersModel: [SafariFilterCellModel])
struct SafariGroupFiltersModelsProvider {
    
    static func model(for group: SafariGroup, proStatus: Bool) -> SafariGroupFiltersModel {
        return models(for: [group], proStatus: proStatus).first!
    }
    
    static func models(for groups: [SafariGroup], proStatus: Bool) -> [SafariGroupFiltersModel] {
        return groups.map { group in
            let groupModel = SafariGroupStateHeaderModel(group: group, proStatus: proStatus)
            let filtersModel = group.filters.map { filter in
                return SafariFilterCellModel(
                    filterId: filter.filterId,
                    filterName: filter.name ?? "",
                    isEnabled: filter.isEnabled,
                    version: filter.version,
                    lastUpdateDate: filter.lastUpdateDate,
                    tags: filter.tags
                )
            }
            return (groupModel, filtersModel)
        }
    }
}
