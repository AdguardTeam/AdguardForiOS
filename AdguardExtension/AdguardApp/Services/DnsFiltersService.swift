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

/** this class is responsible for retrieving, storing, and modifying DNS filters */
protocol DnsFiltersServiceProtocol {
    
    // list of dns filters
    var filters: [DnsFilter] { get }
    
    // json which can be used in dnsProxy. It contains only enabled filters
    var filtersJson: String { get }
    
    // dns whitelist rules
    // autoaticaly updates vpn settings when changed
    var whitelistDomains: [String] { get set }
    
    // dns user filter rules
    // autoaticaly updates vpn settings when changed
    var userRules: [String] { get set }
    
    // enable or disable filter with id
    // autoaticaly updates vpn settings when changed
    func setFilter(filterId: Int, enabled: Bool)
    
    // adds a domain to whitelist filter and restarts the tunnel
    func addWhitelistDomain(_ domain: String)
    
    // adds a domain to user filter and restarts the tunnel
    func addBlacklistDomain(_ domain: String)
    
    // removes rules(!not domains) from whitelist and restarts the tunnel
    func removeWhitelistRules(_ rules: [String])
    
    // removes rules(!not domains) from user filter and restarts the tunnel
    func removeUserRules(_ rules: [String])
}


@objc(DnsFilter)
class DnsFilter: NSObject, NSCoding {
    
    let id: Int
    let name: String
    let date: Date
    var enabled: Bool
    
    init(id: Int, name: String, date: Date, enabled: Bool) {
        self.id = id
        self.name = name
        self.date = date
        self.enabled = enabled
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(date, forKey: "date")
        coder.encode(enabled, forKey: "enabled")
    }
    
    required init?(coder: NSCoder) {
        self.id = coder.decodeInteger(forKey: "id")
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.date = coder.decodeObject(forKey: "date") as? Date ?? Date()
        self.enabled = coder.decodeBool(forKey: "enabled")
    }
}

@objcMembers
class DnsFiltersService: NSObject, DnsFiltersServiceProtocol {
    
    var filters = [DnsFilter]()
    
    private let defaultFilterId = 0
    private let userFilterId = 1
    private let whitelistFilterId = 2
    private let kSharedDefaultsDnsFiltersMetaKey = "kSharedDefaultsDnsFiltersMetaKey"
    
    private let resources: AESharedResourcesProtocol
    private let vpnManager: APVPNManagerProtocol?
    
    private let whitelistPrefix = "@@||"
    private let whitelistSuffix = "^|"
    private let blacklistPrefix = "||"
    private let blacklistSuffix = "^"
    
    init(resources: AESharedResourcesProtocol, vpnManager: APVPNManagerProtocol?) {
        self.resources = resources
        self.vpnManager = vpnManager
        
        super.init()
        readFiltersMeta()
    }
    
    var filtersJson: String  {
        get {
            
            let filtersToAdd = filters.filter { $0.enabled }
            var json = filtersToAdd.map({ (filter) -> [String:Any] in
                return ["id":filter.id, "path":filterPath(filterId: filter.id)]
            })
            
            // todo: do not read all rules to get counter
            if userRules.count > 0 {
                json.append(["id": userFilterId, "path": filterPath(filterId: userFilterId), "user_filter": true])
            }
            
            // todo: do not read all rules to get counter
            if whitelistDomains.count > 0 {
                json.append(["id": whitelistFilterId, "path": filterPath(filterId: whitelistFilterId)])
            }
            
            guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                DDLogError("(DnsFiltersService) filtersJson error - can not make json string")
                return "[]"
            }
            
            return String(data: data, encoding: .utf8) ?? "[]"
        }
    }
    
    var whitelistDomains: [String] {
        get {
            return loadWhitelistRules().map { self.whitelistDomainFromRule($0) }
        }
        set {
            saveWhitlistDomains(domains: newValue)
        }
    }
        
    var userRules: [String] {
        get {
            guard let data = resources.loadData(fromFileRelativePath: filterFileName(filterId: userFilterId)) else {
                DDLogError("(DnsFiltersService) error - can not read user filter from file")
                return []
            }
            
            guard let string = String(data: data, encoding: .utf8) else {
                DDLogError("(DnsFiltersService) error - can not convert user filter data to string")
                return []
            }
            
            return string.isEmpty ? [] : string.components(separatedBy: .newlines)
        }
        set {
            if let data = newValue.joined(separator: "\n").data(using: .utf8) {
                resources.save(data, toFileRelativePath: filterFileName(filterId: userFilterId))
                vpnManager?.restartTunnel() // update vpn settings and enable tunnel if needed
            }
            else {
                DDLogError("(DnsFiltersService) error - can not save user filter to file")
            }
        }
    }
    
    func setFilter(filterId: Int, enabled: Bool) {
        filters.forEach { (filter) in
            if filter.id == filterId {
                filter.enabled = enabled
            }
        }
        
        saveFiltersMeta()
        vpnManager?.restartTunnel() // update vpn settings and enable tunnel if needed
    }
    
    // MARK: - working with user filters
    
    func addWhitelistDomain(_ domain: String) {
        whitelistDomains.append(domain)
    }
    
    func removeWhitelistRules(_ rules: [String]) {
        var allRules = loadWhitelistRules()
        allRules.removeAll { rules.contains($0) }
        willChangeValue(for: \.whitelistDomains)
        saveWhitlistDomains(domains: allRules.map {whitelistRuleFromDomain($0)})
        didChangeValue(for: \.whitelistDomains)
    }
    
    func addBlacklistDomain(_ domain: String) {
        userRules.append(blacklistRuleFromDomain(domain))
    }
    
    func removeUserRules(_ rules: [String]) {
        userRules.removeAll { rules.contains($0)}
    }
    
    // MARK: - private methods
    
    private func readFiltersMeta() {
        let savedData = resources.sharedDefaults().object(forKey: kSharedDefaultsDnsFiltersMetaKey) as? [Data] ?? []
        filters = savedData.map {
            let obj = NSKeyedUnarchiver.unarchiveObject(with: $0)
            return obj as! DnsFilter
        }
        
        if !filters.contains { $0.id == defaultFilterId } {
            self.addDefaultFilter()
            saveFiltersMeta()
        }
    }
    
    private func saveFiltersMeta() {
        let dataToSave = filters.map { NSKeyedArchiver.archivedData(withRootObject: $0) }
        resources.sharedDefaults().set(dataToSave, forKey: kSharedDefaultsDnsFiltersMetaKey)
    }
    
    private func addDefaultFilter() {
        let defaultFilter = DnsFilter(id: defaultFilterId, name: String.localizedString("default_dns_filter_name"), date: Date(), enabled: true)
        
        filters.insert(defaultFilter, at: 0)
        
        // read default filter from bumdle and save it in right place
        
        guard let path = Bundle.main.path(forResource: "dns_filter", ofType: "txt") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            DDLogError("(DnsFiltersService) addDefaultFilter error - can not read filter from bundle")
            return
        }
        
        resources.save(data, toFileRelativePath: filterFileName(filterId: defaultFilterId))
    }
    
    private func filterFileName(filterId: Int)->String {
        return "dns_filter_\(filterId).txt"
    }
    
    private func filterPath(filterId: Int)->String {
        return resources.path(forRelativePath: filterFileName(filterId: filterId))
    }
    
    private func whitelistDomainFromRule(_ rule: String)->String {

        let start = rule.hasPrefix(whitelistPrefix) ? whitelistPrefix.count : 0
        let end = rule.hasSuffix(whitelistSuffix) ? -whitelistSuffix.count : 0
        
        let startIndex = rule.index(rule.startIndex, offsetBy: start)
        let endIndex = rule.index(rule.endIndex, offsetBy: end - 1)
        
        let domain = rule[startIndex...endIndex]
        return String(domain)
    }
    
    private func whitelistRuleFromDomain(_ domain:String)->String {
        var rule = domain.hasPrefix(whitelistPrefix) ? domain : (whitelistPrefix + domain)
        rule = domain.hasSuffix(whitelistSuffix) ? rule : (rule + whitelistSuffix)
        return rule
    }
    
    private func blacklistRuleFromDomain(_ domain: String)->String {
        var rule = domain.hasPrefix(blacklistPrefix) ? domain : (blacklistPrefix + domain)
        rule = domain.hasSuffix(blacklistSuffix) ? rule : (rule + blacklistSuffix)
        return rule
    }
    
    private func loadWhitelistRules()->[String] {
        guard let data = resources.loadData(fromFileRelativePath: filterFileName(filterId: whitelistFilterId)) else {
            DDLogError("(DnsFiltersService) error - can not read whitelist from file")
            return []
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            DDLogError("(DnsFiltersService) error - can not convert whitelist data to string")
            return []
        }
        
        let rules = string.components(separatedBy: .newlines)
        
        return rules
    }
    
    private func saveWhitlistDomains(domains:[String]) {
        let rules = domains.map { self.whitelistRuleFromDomain($0) }
        if let data = rules.joined(separator: "\n").data(using: .utf8) {
            resources.save(data, toFileRelativePath: filterFileName(filterId: userFilterId))
        }
        else {
            DDLogError("(DnsFiltersService) error - can not save user filter to file")
        }
    }
}
