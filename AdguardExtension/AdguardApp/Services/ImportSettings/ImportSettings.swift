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

/// This struct responsible for storing import data and import statuses
struct ImportSettings: Codable {

    enum ImportSettingStatus: Int, Codable {
        case successful, unsuccessful, notImported
    }

    // MARK: - Safari protection filters object
    /// Safari protection default filters struct
    struct DefaultSafariFilterSettings: Codable {
        var id: Int
        var enable: Bool
        var isImportEnabled = true // UI flag, if true - import this settings
        var status: ImportSettingStatus = .notImported

        enum CodingKeys: String, CodingKey  {
            case id, enable
        }
    }

    // MARK: - Safari protection custom filter and DNS protection filter object

    /// Safari protection custom filter and DNS protection filter struct
    struct FilterSettings: Codable {
        var name: String
        var url: String
        var isImportEnabled = true // UI flag, if true - import this settings
        var status: ImportSettingStatus = .notImported

        enum CodingKeys: String, CodingKey  {
            case name, url
        }
    }

    // MARK: - Properties

    // override flags
    var overrideDefaultSafariFilters: Bool?
    var overrideCustomSafariFilters: Bool?
    var overrideSafariBlocklistRules: Bool?
    var overrideDnsBlocklistRules: Bool?
    var overrideDnsFilters: Bool?

    // UI flags, if true then import this settings
    var isDnsServerImportEnabled = true
    var isLicenseImportEnabled = true
    var isSafariBlocklistRulesImportEnabled = true
    var isDnsBlocklistRulesImportEnabled = true

    // settings
    var defaultSafariFilters: [DefaultSafariFilterSettings]?
    var customSafariFilters: [FilterSettings]?
    var dnsFilters: [FilterSettings]?
    var dnsServerId: Int?
    var license: String?
    var safariBlocklistRules: [String]?
    var dnsBlocklistRules: [String]?

    // import statuses
    var importDnsServerStatus: ImportSettingStatus = .notImported
    var importLicenseStatus: ImportSettingStatus = .notImported
    var importSafariBlocklistRulesStatus: ImportSettingStatus = .notImported
    var importDnsBlocklistRulesStatus: ImportSettingStatus = .notImported

    enum CodingKeys: String, CodingKey  {
        case overrideDefaultSafariFilters = "cb_filter_default_override"
        case overrideCustomSafariFilters = "cb_filter_custom_override"
        case overrideSafariBlocklistRules = "user_rules_override"
        case overrideDnsBlocklistRules = "dns_user_rules_override"
        case overrideDnsFilters = "dns_filter_list_override"

        case defaultSafariFilters = "cb_filter_default"
        case customSafariFilters = "cb_filter_custom"
        case dnsFilters = "dns_filter_list"
        case dnsServerId = "dns_server_id"
        case license = "license"
        case safariBlocklistRules = "user_rules"
        case dnsBlocklistRules = "dns_user_rules"
    }
}
