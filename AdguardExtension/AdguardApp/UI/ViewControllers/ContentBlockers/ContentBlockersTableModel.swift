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

protocol ContentBlockersTableModelDelegate: AnyObject {
    
}

// TODO: - Handle case when CBs are already updating when initializing model
final class ContentBlockersTableModel {
    
    // MARK: - Public properties
    
    weak var delegate: ContentBlockersTableModelDelegate?
    
    private(set) var cbModels: [ContentBlockerTableViewCellModel] = []
    
    // MARK: - Private properties
    
    /* Services */
    private let safariProtection: SafariProtectionProtocol
    
    /* Observers */
    private var filtersConvertionStartObserver: SafariAdGuardSDK.NotificationToken?
    private var filtersConvertionEndObserver: SafariAdGuardSDK.NotificationToken?
    private var standaloneContentBlockerReloadStartObserver: SafariAdGuardSDK.NotificationToken?
    private var standaloneContentBlockerReloadEndObserver: SafariAdGuardSDK.NotificationToken?
    
    init(safariProtection: SafariProtectionProtocol) {
        self.safariProtection = safariProtection
        self.cbModels = getCbModels()
        addObservers()
    }
    
    private func getCbModels() -> [ContentBlockerTableViewCellModel] {
        // Enabled filters names for all Content Blockers
        let enabledFiltersByCB = getEnabledFiltersByCb()
        
        // Converter lib results
        let converterResults = safariProtection.allConverterResults
        
        // State of each Content Blocker enabled/disabled
        let cbStates = safariProtection.allContentBlockersStates
        
        return converterResults.map {
            let cbType = $0.result.type
            return ContentBlockerTableViewCellModel(
                state: cbStates[cbType]! ? .enabled : .disabled,
                cbType: cbType,
                rulesCount: $0.result.totalConverted,
                cbFilterNames: enabledFiltersByCB[cbType] ?? [],
                overLimitRulesCount: $0.result.totalRules - $0.result.totalConverted
            )
        }
    }
    
    /// Returns enabled filters names for all Content Blockers
    private func getEnabledFiltersByCb() -> [ContentBlockerType: [String]] {
        var enabledFiltersByCB: [ContentBlockerType: [String]] = [:]
        ContentBlockerType.allCases.forEach { enabledFiltersByCB[$0] = [] }
        
        for group in safariProtection.groups {
            if !group.isEnabled { continue }
            
            let enabledFilters = group.filters.filter { $0.isEnabled }
            if enabledFilters.isEmpty { continue }
            
            let cbType = group.groupType.contentBlockerType
            let enabledFiltersNames = enabledFilters.map { $0.filterName }
            enabledFiltersByCB[cbType] = enabledFiltersNames
        }
        return enabledFiltersByCB
    }
    
    private func addObservers() {
        filtersConvertionStartObserver = NotificationCenter.default.filtersConvertionStarted {
            print("🔥 START FILTERS CONVERTION")
        }
        
        filtersConvertionEndObserver = NotificationCenter.default.filtersConvertionFinished {
            print("🔥 END FILTERS CONVERTION")
        }
        
        standaloneContentBlockerReloadStartObserver = NotificationCenter.default.standaloneContentBlockerUpdateStarted { cbType in
            print("🔥 START RELOADING \(cbType)")
        }
        
        standaloneContentBlockerReloadEndObserver = NotificationCenter.default.standaloneContentBlockerUpdateFinished { cbType in
            print("🔥 END RELOADING \(cbType)")
        }
    }
}
