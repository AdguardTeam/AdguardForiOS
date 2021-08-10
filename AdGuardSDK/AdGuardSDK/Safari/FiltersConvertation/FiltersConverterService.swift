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

protocol FiltersConverterServiceProtocol {
    /* Converts enabled filters and user rules to jsons objects for every content blocker */
    func convertFiltersAndUserRulesToJsons() throws -> [FiltersConverter.Result]
}

/**
 This class is responsible for converting all enabled filters and user rules (blocklist / allowlist / inverted allowlist) to jsons objects
 */
final class FiltersConverterService: FiltersConverterServiceProtocol {
    
    // MARK: - ConvertionError
    
    enum ConvertionError: Error, CustomDebugStringConvertible {
        case failedToConvertRules
        
        var debugDescription: String {
            switch self {
            case .failedToConvertRules: return "An error occured while converting rules to jsons"
            }
        }
    }
    
    // MARK: - Services
    
    private let configuration: SafariConfigurationProtocol
    private let filtersService: FiltersServiceProtocol
    private let filterFilesStorage: FilterFilesStorageProtocol
    private let safariManagers: SafariUserRulesManagersProviderProtocol
    private let filtersConverter: FiltersConverterProtocol
    
    // MARK: - Initialization
    
    init(configuration: SafariConfigurationProtocol,
         filtersService: FiltersServiceProtocol,
         filterFilesStorage: FilterFilesStorageProtocol,
         safariManagers: SafariUserRulesManagersProviderProtocol,
         filtersConverter: FiltersConverterProtocol = FiltersConverter())
    {
        self.configuration = configuration
        self.filtersService = filtersService
        self.filterFilesStorage = filterFilesStorage
        self.safariManagers = safariManagers
        self.filtersConverter = filtersConverter
    }
    
    // MARK: - Internal methods
    
    func convertFiltersAndUserRulesToJsons() throws -> [FiltersConverter.Result] {
        // Run converter with empty data if Safari protection is disabled
        guard configuration.safariProtectionEnabled else {
            let emptySafatiFilters = filtersConverter.convert(filters: [], blocklistRules: nil, allowlistRules: nil, invertedAllowlistRulesString: nil)
            return emptySafatiFilters ?? []
        }
        
        // Get active filters info. It is an array of tuples [(filter id, group type)]
        let activeFiltersInfo = filtersService.groups.filter {
            if configuration.proStatus {
                return $0.isEnabled
            } else {
                return $0.isEnabled && !$0.groupType.proOnly
            }
        }
        .flatMap { $0.filters }
        .filter { $0.isEnabled }
        .map { ($0.filterId, SafariGroup.GroupType(rawValue: $0.group.groupId)!) }
        
        // Get active filters file's text
        let filesContent: [FilterFileContent] = activeFiltersInfo.compactMap {
            if let filterFileString = filterFilesStorage.getFilterContentForFilter(withId: $0.0) {
                return FilterFileContent(text: filterFileString, group: $0.1)
            } else {
                Logger.logError("(ContentBlockerService) - convertFiltersAndUserRulesToJsons; Received nil file content for filter with id=\($0.0)")
                return nil
            }
        }
        
        // Get enabled blocklist rules
        let blocklistRulesManager = safariManagers.blocklistRulesManager
        let enabledBlockListRules = blocklistRulesManager.allRules.filter { $0.isEnabled }
                                                                  .map { $0.ruleText }
        // Get either allowlist rules or inverted allowlist rules (they aren't working at the same time)
        var enabledAllowlistRules: [String]?
        var enabledInvertedAllowlistRulesString: String?
        if configuration.allowlistIsInverted {
            // Inverted allowlist rules are composed to the single rule that contains all of them
            let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager
            enabledInvertedAllowlistRulesString = invertedAllowlistRulesManager.rulesString
        } else {
            let allowlistRulesManager = safariManagers.allowlistRulesManager
            enabledAllowlistRules = allowlistRulesManager.allRules.filter { $0.isEnabled }
                                                                  .map { $0.ruleText }
        }
        
        // Run converter with all enabled rules
        if let safariFilters = filtersConverter.convert(filters: filesContent,
                                                     blocklistRules: enabledBlockListRules,
                                                     allowlistRules: enabledAllowlistRules,
                                                     invertedAllowlistRulesString: enabledInvertedAllowlistRulesString)
        {
            return safariFilters
        }
        else {
            throw ConvertionError.failedToConvertRules
        }
    }
}

// MARK: - SafariGroup.GroupType + contentBlockerType

extension SafariGroup.GroupType {
    var contentBlockerType: ContentBlockerType {
        switch self {
        case .ads: return .general
        case .privacy: return .privacy
        case .socialWidgets: return .socialWidgetsAndAnnoyances
        case .annoyances: return .socialWidgetsAndAnnoyances
        case .security: return .security
        case .other: return .other
        case .languageSpecific: return .general
        case .custom: return .custom
        }
    }
}
