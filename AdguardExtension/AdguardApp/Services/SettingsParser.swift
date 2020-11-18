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

enum ImportSettingStatus: Int, Codable {
    typealias RawValue = Int
    
    case enabled, disabled, successful, unsuccessful
}

struct DefaultCBFilterSettings: Codable {
    var id: Int
    var enable: Bool
    
    var status: ImportSettingStatus = .enabled
    
    enum CodingKeys:String, CodingKey  {
        case id, enable
    }
}

struct CustomCBFilterSettings: Codable {
    var name: String
    var url: String
    
    var status: ImportSettingStatus = .enabled
    
    enum CodingKeys:String, CodingKey  {
        case name
        case url
    }
}

struct DnsFilterSettings: Codable {
    var name: String
    var url: String
    
    var status: ImportSettingStatus = .enabled
    
    enum CodingKeys:String, CodingKey  {
        case name
        case url
    }
}

struct DnsFilteringSettings: Codable {
    var name: DnsNameSetting?
    var dnsProtocol: DnsProtocolSetting?
    
    enum CodingKeys:String, CodingKey  {
        case name
        case dnsProtocol = "protocol"
    }
}

enum DnsNameSetting: String, Codable {
    typealias RawValue = String
    
    case adguardDefault = "default"
    case adguardFamily = "adguard-dns-family"
    case adguardNonFiltering = "adguard-dns-non-filtering"
}

enum DnsProtocolSetting: String, Codable {
    typealias RawValue = String
    
    case dns = "DNS"
    case dnsCrypt = "DNSCRYPT"
    case doh = "DOH"
    case dot = "DOT"
    case doq = "DOQ"
}

struct Settings: Codable {
    
    // override flags
    var overrideCbFilters:Bool?
    var overrideCustomFilters:Bool?
    var overrideUserRules:Bool?
    var overrideDnsUserRules:Bool?
    
    // settings
    var defaultCbFilters:[DefaultCBFilterSettings]?
    var customCbFilters:[CustomCBFilterSettings]?
    var dnsFilters:[DnsFilterSettings]?
    var dnsSetting: DnsFilteringSettings?
    var license: String?
    var userRules: [String]?
    var dnsUserRules: [String]?
    var allowlistRules: [String]?
    
    // import statuses
    var dnsStatus: ImportSettingStatus = .enabled
    var licenseStatus: ImportSettingStatus = .enabled
    var userRulesStatus: ImportSettingStatus = .enabled
    var dnsRulesStatus: ImportSettingStatus = .enabled

    enum CodingKeys:String, CodingKey  {
        case overrideCbFilters = "cb_filter_default_override"
        case overrideCustomFilters = "cb_filter_custom_override"
        case overrideUserRules = "user_rules_override"
        case overrideDnsUserRules = "dns_user_rules_override"
        case defaultCbFilters = "cb_filter_default"
        case customCbFilters = "cb_filter_custom"
        case dnsFilters = "dns_filter_list"
        case dnsSetting = "dns_filtering"
        case license = "license"
        case userRules = "user_rules"
        case dnsUserRules = "dns_user_rules"
        case allowlistRules = "allowlist_rules"
    }
}


/** this class is responsible for parsing app settings which recieved via custom url scheme */
protocol SettingsParserProtocol {
    
    func parse(querry: String)->Settings?
}

class SettingsParser: SettingsParserProtocol {
    
    func parse(querry: String) -> Settings? {
        
        let json = querry.removingPercentEncoding
        let settings = try? JSONDecoder().decode(Settings.self, from: json?.data(using: .utf8) ?? Data())
        
        return settings;
    }
}
