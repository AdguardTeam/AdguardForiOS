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
    
    // MARK: - Public properties
    
    var models: [SafariFilterCellModel] = []
    
    weak var delegate: SafariGroupFiltersModelDelegate?
    
    // MARK: - Private properties
    
    private let group: SafariGroup
    private let safariProtection: SafariProtectionProtocol
    
    // MARK: - Initialization
    
    init(safariProtection: SafariProtectionProtocol, group: SafariGroup) {
        self.group = group
        self.safariProtection = safariProtection
        createModels()
    }
    
    // MARK: - Private methods
    
    private func createModels() {
        let filters = group.filters
        self.models = filters.map {
            SafariFilterCellModel(
                filterId: $0.filterId,
                filterName: $0.name ?? "",
                isEnabled: $0.isEnabled,
                version: $0.version,
                lastUpdateDate: $0.lastUpdateDate,
                tags: $0.tags
            )
        }
    }
}
