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

enum ContentBlockerCellState {
    case enabled
    case disabled
    case convertingFilters
    case updatingContentBlockers
    case overlimited
    case failedUpdating
    
    fileprivate var image: UIImage? {
        switch self {
        case .enabled: return UIImage(named: "logocheck")
        case .disabled: return UIImage(named: "attention")
        case .convertingFilters, .updatingContentBlockers: return UIImage(named: "loading")
        case .failedUpdating, .overlimited: return UIImage(named: "errorAttention")
        }
    }
    
    fileprivate func getDescription(_ rulesCount: Int, _ overLimitRulesCount: Int) -> String {
        switch self {
        case .enabled:
            let format = String.localizedString("enabled_current_content_blocker_state_label")
            return String(format: format, String(rulesCount))
        case .disabled:
            return String.localizedString("disabled_current_state_label")
        case .convertingFilters:
            return String.localizedString("converting_rules")
        case .updatingContentBlockers:
            return String.localizedString("update_current_state_label")
        case .overlimited:
            let format = String.localizedString("over_limit_current_state_label")
            return String(format: format, overLimitRulesCount)
        case .failedUpdating:
            return String.localizedString("failed_updating_current_state_label")
        }
    }
}

// MARK: - ContentBlockerTableViewCellModel

struct ContentBlockerTableViewCellModel {
    let image: UIImage?
    let name: String
    let description: String
    let filtersString: String?
    
    init(state: ContentBlockerCellState, cbType: ContentBlockerType, rulesCount: Int, cbFilterNames: [String], overLimitRulesCount: Int) {
        self.image = state.image
        self.name = cbType.localizedName
        self.description = state.getDescription(rulesCount, overLimitRulesCount)
        if cbFilterNames.isEmpty {
            self.filtersString = nil
        } else {
            let filtersString = String.localizedString("content_blocker_filters")
            self.filtersString = filtersString + "\n" + cbFilterNames.joined(separator: "\n")
        }
    }
    
    init() {
        self.image = nil
        self.name = ""
        self.description = ""
        self.filtersString = nil
    }
}
