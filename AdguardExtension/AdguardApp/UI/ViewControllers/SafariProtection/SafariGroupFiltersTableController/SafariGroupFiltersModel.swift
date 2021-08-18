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
import SafariAdGuardSDK

protocol SafariGroupFiltersModelDelegate: AnyObject {
    func modelsChanged()
}

final class SafariGroupFiltersModel {
    
    enum DisplayType {
        case one(groupType: SafariGroup.GroupType)
        case all
    }
    
    // MARK: - Public properties
    
    var models: [(SafariGroupStateHeaderModel, [SafariFilterCellModel])] = []
    
    weak var delegate: SafariGroupFiltersModelDelegate?
    
    // MARK: - Private properties
    
    private let displayType: DisplayType
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol
    
    // MARK: - Initialization
    
    init(displayType: DisplayType, safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol) {
        self.displayType = displayType
        self.safariProtection = safariProtection
        self.configuration = configuration
        createModels()
    }
    
    // MARK: - Private methods
    
    private func createModels() {
        let groups: [SafariGroup]
        switch displayType {
        case .one(let groupType):
            let group = safariProtection.groups.first(where: { $0.groupType == groupType })!
            groups = [group as! SafariGroup]
        case .all:
            groups = safariProtection.groups as! [SafariGroup]
        }
        
        self.models = groups.map { group in
            let groupModel = SafariGroupStateHeaderModel(group: group, proStatus: configuration.proStatus)
            let filtersModels = group.filters.map {
                SafariFilterCellModel(
                    filterId: $0.filterId,
                    filterName: $0.name ?? "",
                    isEnabled: $0.isEnabled,
                    version: $0.version,
                    lastUpdateDate: $0.lastUpdateDate,
                    tags: $0.tags
                )
            }
            return (groupModel, filtersModels)
        }
    }
}
