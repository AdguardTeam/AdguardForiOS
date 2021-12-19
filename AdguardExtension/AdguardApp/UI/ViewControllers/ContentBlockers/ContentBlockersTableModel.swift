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
import SafariAdGuardSDK

protocol ContentBlockersTableModelDelegate: AnyObject {
    func cbStatesChanged()
}

/// This object is a view model for `ContentBlockersTableController`
final class ContentBlockersTableModel {

    // MARK: - Public properties

    weak var delegate: ContentBlockersTableModelDelegate?

    private(set) var cbModels: [ContentBlockerTableViewCellModel] = []

    // MARK: - Private properties

    /* Services */
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol

    /* Observers */
    private var filtersConvertionStartObserver: SharedAdGuardSDK.NotificationToken?
    private var filtersConvertionEndObserver: SharedAdGuardSDK.NotificationToken?
    private var standaloneContentBlockerReloadStartObserver: SharedAdGuardSDK.NotificationToken?
    private var standaloneContentBlockerReloadEndObserver: SharedAdGuardSDK.NotificationToken?
    private var contentBlockersStateChangedObserver: SharedAdGuardSDK.NotificationToken?
    private var advancedProtectionStateObserver: SharedAdGuardSDK.NotificationToken?

    init(safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol) {
        self.safariProtection = safariProtection
        self.configuration = configuration
        self.cbModels = getModels()
        addObservers()
    }

    private func getModels() -> [ContentBlockerTableViewCellModel] {
        // Enabled filters names for all Content Blockers
        let enabledFiltersByCB = getEnabledFiltersByCb()

        // Converter lib results
        let converterResults = safariProtection.allConverterResults.sorted(by: { $0.type.rawValue < $1.type.rawValue })

        // Reloading state for each CB
        let cbReloadingStates = safariProtection.reloadingContentBlockers

        // State of each Content Blocker enabled/disabled
        let cbStates = safariProtection.allContentBlockersStates

        // True if filters are being converted now
        let filtersAreConverting = safariProtection.filtersAreConverting

        var cbModels: [ContentBlockerTableViewCellModel] = converterResults.map { converterResult in
            let cbType = converterResult.type

            // Reveal number of rules that are not in CB
            var overLimitCount = converterResult.totalRules - converterResult.totalConverted
            if overLimitCount < 0 { overLimitCount = 0 }

            // Reveal CB state
            let state: ContentBlockerCellState
            if filtersAreConverting {
                state = .convertingFilters
            } else if cbReloadingStates[cbType] == true {
                state = .updatingContentBlockers
            } else if cbStates[cbType] == true {
                if overLimitCount > 0 {
                    let maxRulesLimit = UIDevice.current.iosVersion < 15 ? 50_000 : 150_000
                    state = .overlimited(maxRulesLimit: maxRulesLimit, currentRulesCount: converterResult.totalConverted, totalRulesInCB: converterResult.totalRules, overlimitRulesCount: overLimitCount)
                } else {
                    state = .enabled(
                        rulesCount: converterResult.totalConverted,
                        filterNames: enabledFiltersByCB[cbType] ?? []
                    )
                }
            } else {
                state = .disabled(isAdvancedProtection: false)
            }

            return ContentBlockerTableViewCellModel(state: state, cbType: cbType)
        }

        // Construct Advanced Protection model
        let advancedProtectionState: ContentBlockerCellState
        if !configuration.isAdvancedProtectionEnabled {
            advancedProtectionState = .disabled(isAdvancedProtection: true)
        } else if filtersAreConverting {
            advancedProtectionState = .convertingFilters
        } else {
            let advancedRulesCount = safariProtection.advancedRulesCount
            advancedProtectionState = .enabled(rulesCount: advancedRulesCount, filterNames: [])
        }

        let advancedProtectionModel = ContentBlockerTableViewCellModel(
            state: advancedProtectionState,
            name: String.localizedString("cb_screen_advanced_protection_title")
        )

        cbModels.append(advancedProtectionModel)
        return cbModels
    }

    /// Returns enabled filters names for all Content Blockers
    private func getEnabledFiltersByCb() -> [ContentBlockerType: [String]] {
        var enabledFiltersByCB: [ContentBlockerType: [String]] = [:]
        ContentBlockerType.allCases.forEach { enabledFiltersByCB[$0] = [] }

        // Add enabled rules to corresponding CB
        for group in safariProtection.groups {
            if !group.isEnabled { continue }

            let enabledFilters = group.filters.filter { $0.isEnabled }
            if enabledFilters.isEmpty { continue }

            let cbType = group.groupType.contentBlockerType
            let enabledFiltersNames = enabledFilters.map { $0.filterName }
            enabledFiltersByCB[cbType]?.append(contentsOf: enabledFiltersNames)
        }

        // Add user rules if they are on and enabled rules exist
        let enabledUserRules = safariProtection.allRules(for: .blocklist).filter { $0.isEnabled }
        if !enabledUserRules.isEmpty && safariProtection.blocklistIsEnabled {
            let userFilterName = String.localizedString("safari_userfilter_title")
            ContentBlockerType.allCases.forEach { enabledFiltersByCB[$0]?.append(userFilterName) }
        }

        // Add allowlist rules if they are on and enabled rules exist
        if safariProtection.allowlistIsInverted {
            let enabledInvAllowlistRules = safariProtection.allRules(for: .invertedAllowlist).filter { $0.isEnabled }
            if !enabledInvAllowlistRules.isEmpty && safariProtection.allowlistIsEnabled {
                let invAllowlistName = String.localizedString("inverted_whitelist_title")
                ContentBlockerType.allCases.forEach { enabledFiltersByCB[$0]?.append(invAllowlistName) }
            }
        } else {
            let enabledAllowlistRules = safariProtection.allRules(for: .allowlist).filter { $0.isEnabled }
            if !enabledAllowlistRules.isEmpty && safariProtection.allowlistIsEnabled {
                let allowlistName = String.localizedString("allowlist_title")
                ContentBlockerType.allCases.forEach { enabledFiltersByCB[$0]?.append(allowlistName) }
            }
        }

        return enabledFiltersByCB
    }

    private func addObservers() {
        // Called when Safari filters started to convert
        filtersConvertionStartObserver = NotificationCenter.default.filtersConvertionStarted { [weak self] in
            self?.reinitModels()
        }

        // Called when Safari filters finished to convert
        filtersConvertionEndObserver = NotificationCenter.default.filtersConvertionFinished { [weak self] in
            self?.reinitModels()
        }

        // Called when a certain Safari Content Blocker started to reload
        standaloneContentBlockerReloadStartObserver = NotificationCenter.default.standaloneContentBlockerUpdateStarted { [weak self] cbType in
            self?.reinitModels()
        }

        // Called when a certain Safari Content Blocker finished to reload
        standaloneContentBlockerReloadEndObserver = NotificationCenter.default.standaloneContentBlockerUpdateFinished { [weak self] cbType in
            self?.reinitModels()
        }

        // Called when Safari Content Blockers states changed in System settings
        contentBlockersStateChangedObserver = NotificationCenter.default.observe(name: .contentBlockersStateChanged, object: nil, queue: .main) { [weak self] _ in
            self?.reinitModels()
        }

        // Called when Advanced Protection state changes
        advancedProtectionStateObserver = NotificationCenter.default.observe(name: .advancedProtectionStateChanged, object: nil, queue: .main) { [weak self] _ in
            self?.reinitModels()
        }
    }

    private func reinitModels() {
        cbModels = getModels()
        delegate?.cbStatesChanged()
    }
}
