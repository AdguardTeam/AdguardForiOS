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

import UIKit.UIImage

enum PremiumFeature: CaseIterable, Equatable {
    case advancedProtection
    case securityFilters
    case dnsPrivacy
    case customFilters

    var icon: UIImage? {
        switch self {
        case .advancedProtection: return UIImage(named: "advanced_protection_icon")
        case .securityFilters: return UIImage(named: "adguard-small-icon")
        case .dnsPrivacy: return UIImage(named: "dns")
        case .customFilters: return UIImage(named: "custom")
        }
    }

    var localizedName: String {
        switch self {
        case .advancedProtection: return String.localizedString("advanced_protection_feature_name")
        case .securityFilters: return String.localizedString("security_filters_feature_name")
        case .dnsPrivacy: return String.localizedString("dns_privacy_feature_name")
        case .customFilters: return String.localizedString("custom_filters_feature_name")
        }
    }

    var localizedDescr: String {
        switch self {
        case .advancedProtection: return String.localizedString("advanced_protection_feature_description")
        case .securityFilters: return String.localizedString("security_filters_feature_description")
        case .dnsPrivacy: return String.localizedString("dns_privacy_feature_description")
        case .customFilters: return String.localizedString("custom_filters_feature_description")
        }
    }
}
