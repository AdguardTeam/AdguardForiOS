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

import UIKit
import SafariAdGuardSDK

/// This enum represents all Safari Content Blocker states to display for user
enum ContentBlockerCellState {
    case enabled(rulesCount: Int, filterNames: [String])
    case disabled(isAdvancedProtection: Bool)
    case convertingFilters
    case updatingContentBlockers
    case overlimited(overlimitRulesCount: Int)

    fileprivate var image: UIImage? {
        switch self {
        case .enabled: return UIImage(named: "logocheck")
        case .disabled: return UIImage(named: "attention")
        case .convertingFilters, .updatingContentBlockers: return UIImage(named: "loading")
        case .overlimited: return UIImage(named: "errorAttention")
        }
    }

    fileprivate var description: String {
        switch self {
        case .enabled(let rulesCount, filterNames: _):
            let format = String.localizedString("enabled_current_content_blocker_state_label")
            return String(format: format, String(rulesCount))
        case .disabled(let isAdvancedProtection):
            if isAdvancedProtection {
                return String.localizedString("disabled_current_state_advanced_protection")
            } else {
                return String.localizedString("disabled_current_state_label")
            }
        case .convertingFilters:
            return String.localizedString("converting_rules")
        case .updatingContentBlockers:
            return String.localizedString("update_current_state_label")
        case .overlimited(let overLimitRulesCount):
            let format = String.localizedString("over_limit_current_state_label")
            return String(format: format, overLimitRulesCount)
        }
    }

    fileprivate var filtersDescription: String? {
        switch self {
        case .enabled(rulesCount: _, filterNames: let filterNames):
            if filterNames.isEmpty { return nil }

            let filtersString = String.localizedString("content_blocker_filters")
            return filtersString + "\n" + filterNames.joined(separator: "\n")
        default:
            return nil
        }
    }

    fileprivate var shouldRotateImage: Bool {
        switch self {
        case .updatingContentBlockers, .convertingFilters: return true
        default: return false
        }
    }
}

// MARK: - ContentBlockerTableViewCellModel

/// This object is a view model for `ContentBlockerTableViewCell`
struct ContentBlockerTableViewCellModel {
    let image: UIImage?
    let shouldRotateImage: Bool
    let name: String
    let description: String
    let filtersString: String?

    /// Intializer for Content Blocker
    init(state: ContentBlockerCellState, cbType: ContentBlockerType) {
        self.image = state.image
        self.shouldRotateImage = state.shouldRotateImage
        self.name = cbType.localizedName
        self.description = state.description
        self.filtersString = state.filtersDescription
    }

    /// Initializer for Advanced Protection
    init(state: ContentBlockerCellState, name: String) {
        self.image = state.image
        self.shouldRotateImage = state.shouldRotateImage
        self.name = name
        self.description = state.description
        self.filtersString = nil
    }

    init() {
        self.image = nil
        self.shouldRotateImage = false
        self.name = ""
        self.description = ""
        self.filtersString = nil
    }
}
