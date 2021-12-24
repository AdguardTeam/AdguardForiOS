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

import Foundation

/// `MessageType` is a type of message that we receive from JS
/// Knowing the `Message.type` tells us what to do with `Message.data`
enum MessageType: String {
    case getInitData = "get_init_data"
    case getAdvancedRules = "get_advanced_rules_text"
    case shouldUpdateAdvancedRules = "should_update_advanced_rules"

    // Response cases
    case success = "success"
    case error = "error"
}

// MARK: - Message
// Object representation of message that we receive from JS

struct Message {
    static let messageTypeKey = "type"
    static let messageDataKey = "data"

    static let protectionEnabled = "protection_enabled"
    static let hasUserRules = "has_user_rules"
    static let premiumApp = "premium_app"
    static let appearanceTheme = "appearance_theme"
    static let contentBlockersEnabled = "content_blockers_enabled"
    static let advancedBlockingEnabled = "advanced_blocking_enabled"
    static let shouldUpdateAdvancedRules = "should_update_advanced_rules"
    static let allowlistIsInverted = "allowlist_inverted"
    static let platform = "platform"
    static let safariProtectionEnabled = "safari_protection_enabled"

    // Links
    static let enableSiteProtectionLink = "enable_site_protection_link"
    static let disableSiteProtectionLink = "disable_site_protection_link"
    static let addToBlocklistLink = "add_to_blocklist_link"
    static let removeAllBlocklistRulesLink = "remove_all_blocklist_rules_link"
    static let upgradeAppLink = "upgrade_app_link"
    static let enableAdvancedBlockingLink = "enable_advanced_blocking_link"
    static let reportProblemLink = "report_problem_link"
    static let enableSafariProtectionLink = "enable_safari_protection_link"

    // Advanced rules
    static let advancedRulesKey = "advanced_rules"

    let type: MessageType
    let data: Any?
}

/// Initializer from Dictionary. We receive message as dictionary from JS
extension Message {
    init?(message: [String: Any]) {
        guard let typeString = message[Self.messageTypeKey] as? String,
              let type = MessageType(rawValue: typeString)
        else {
            return nil
        }
        self.type = type
        self.data = message[Self.messageDataKey]
    }
}

// MARK: - ThemeMode + messageName

extension ThemeMode {
    var messageName: String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        case .systemDefault: return "system"
        }
    }
}
