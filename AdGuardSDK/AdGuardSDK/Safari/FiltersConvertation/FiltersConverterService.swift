//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK
import ContentBlockerConverter

protocol FiltersConverterServiceProtocol {
    /* Returns true if filters are converting now */
    var filtersAreConverting: Bool { get }

    /* Converts enabled filters and user rules to jsons objects for every content blocker */
    func convertFiltersAndUserRulesToJsons() -> [FiltersConverterResult]
}

/**
 This class is responsible for converting all enabled filters and user rules (blocklist / allowlist / inverted allowlist) to jsons objects
 */
final class FiltersConverterService: FiltersConverterServiceProtocol {

    private(set) var filtersAreConverting: Bool = false {
        didSet {
            if oldValue == filtersAreConverting {
                return
            }

            if filtersAreConverting {
                NotificationCenter.default.filtersConvertionStarted()
            } else {
                NotificationCenter.default.filtersConvertionFinished()
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
         filtersConverter: FiltersConverterProtocol)
    {
        self.configuration = configuration
        self.filtersService = filtersService
        self.filterFilesStorage = filterFilesStorage
        self.safariManagers = safariManagers
        self.filtersConverter = filtersConverter
    }

    // MARK: - Internal methods

    func convertFiltersAndUserRulesToJsons() -> [FiltersConverterResult] {
        filtersAreConverting = true
        defer { filtersAreConverting = false }

        // Run converter with empty data if Safari protection is disabled
        guard configuration.safariProtectionEnabled else {
            return filtersConverter.convert(filters: [], blocklistRules: nil, allowlistRules: nil, invertedAllowlistRules: nil)
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
        var enabledBlockListRules: [String] = []
        if configuration.blocklistIsEnabled {
            enabledBlockListRules = blocklistRulesManager.allRules.filter { $0.isEnabled }.map { $0.ruleText }
        }

        // Get either allowlist rules or inverted allowlist rules (they aren't working at the same time)
        var enabledAllowlistRules: [String]?
        var enabledInvertedAllowlistRules: [String]?

        if !configuration.allowlistIsEnabled {
            enabledAllowlistRules = nil
            enabledInvertedAllowlistRules = nil
        } else if configuration.allowlistIsInverted {
            let invertedAllowlistRulesManager = safariManagers.invertedAllowlistRulesManager
            enabledInvertedAllowlistRules = invertedAllowlistRulesManager.allRules.filter { $0.isEnabled }
                                                                                  .map { $0.ruleText }
        } else {
            let allowlistRulesManager = safariManagers.allowlistRulesManager
            enabledAllowlistRules = allowlistRulesManager.allRules.filter { $0.isEnabled }
                                                                  .map { $0.ruleText }
        }

        // Run converter with all enabled rules
        let safariFilters = filtersConverter.convert(
            filters: filesContent,
            blocklistRules: enabledBlockListRules,
            allowlistRules: enabledAllowlistRules,
            invertedAllowlistRules: enabledInvertedAllowlistRules
        )
        return safariFilters
    }
}

// MARK: - SafariGroup.GroupType + contentBlockerType

public extension SafariGroup.GroupType {
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

// MARK: - NotificationCenter + Filters convertion notifications

fileprivate extension NSNotification.Name {
    static var filtersConvertionStarted: NSNotification.Name { .init(rawValue: "AdGuardSDK.filtersConvertionStarted") }
    static var filtersConvertionFinished: NSNotification.Name { .init(rawValue: "AdGuardSDK.filtersConvertionFinished") }
}

fileprivate extension NotificationCenter {
    func filtersConvertionStarted() {
        self.post(name: .filtersConvertionStarted, object: self, userInfo: nil)
    }

    func filtersConvertionFinished() {
        self.post(name: .filtersConvertionFinished, object: self, userInfo: nil)
    }
}

public extension NotificationCenter {
    func filtersConvertionStarted(queue: OperationQueue? = .main, handler: @escaping () -> Void) -> NotificationToken {
        return self.observe(name: .filtersConvertionStarted, object: nil, queue: queue) { _ in
            handler()
        }
    }

    func filtersConvertionFinished(queue: OperationQueue? = .main, handler: @escaping () -> Void) -> NotificationToken {
        return self.observe(name: .filtersConvertionFinished, object: nil, queue: queue) { _ in
            handler()
        }
    }
}
