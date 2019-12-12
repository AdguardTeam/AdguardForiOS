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
@objc
protocol DnsFiltersServiceProtocol {
    
    // list of dns filters
    var filters: [DnsFilter] { get }
    
    // Counts all filters
    var allFiltersCount: Int { get }
    
    // Counts enabled filters
    var enabledFiltersCount: Int { get }
    
    // json which can be used in dnsProxy. It contains only enabled filters
    var filtersJson: String { get }
    
    // dns whitelist rules
    // automaticaly updates vpn settings when changed
    var whitelistDomains: [String] { get set }
    
    // dns user filter rules
    // automaticaly updates vpn settings when changed
    var userRules: [String] { get set }
    
    // Shows whether filters are updating not to start
    // second update
    var filtersAreUpdating: Bool { get }
    
    // enable or disable filter with id
    // auto,aticaly updates vpn settings when changed
    func setFilter(filterId: Int, enabled: Bool)
    
    // adds filter to array of filters
    // automaticaly updates vpn settings when changed
    func addFilter(_ filter: DnsFilter, data: Data?)
    
    // deletes filter from array of filters
    // automaticaly updates vpn settings when changed
    func deleteFilter(_ filter: DnsFilter)
    
    // Updates filters with new meta
    func updateFilters(networking: ACNNetworkingProtocol)
}

@objc(DnsFilter)
class DnsFilter: NSObject, NSCoding, FilterDetailedInterface {
    
    private let defaultFilterId = 0
    
    // defaultFilterId = 0, userFilterId = 1, whitelistFilterId = 2 , next available id is 3
    var id: Int = 3
    var subscriptionUrl: String?
    var name: String?
    var attributedString: NSAttributedString? = nil
    var updateDate: Date?
    var enabled: Bool
    var desc: String?
    var version: String?
    var rulesCount: Int?
    var homepage: String?
    var removable: Bool {
        get {
            return id != defaultFilterId
        }
    }
    
    // MARK: - Initialization
    
    init(subscriptionUrl: String?, name: String, date: Date, enabled: Bool, desc: String?, version: String?, rulesCount: Int?, homepage: String?) {
        
        self.subscriptionUrl = subscriptionUrl
        self.name = name
        self.updateDate = date
        self.enabled = enabled
        self.desc = desc
        self.version = version
        self.rulesCount = rulesCount
        self.homepage = homepage
    }
    
    // MARK: - Debug description
    
    override var debugDescription: String {
        return "\n id = \(self.id) \n name = \(String(describing: self.name)) \n version = \(String(describing: self.version)) \n rulesCount = \(String(describing: self.rulesCount))"
    }
    
    // MARK: - Equatable protocol method
    
    static func == (lhs: DnsFilter, rhs: DnsFilter) -> Bool {
        return lhs.subscriptionUrl == rhs.subscriptionUrl
    }
    
    // MARK: - NSCoding protocol methods
    
    func encode(with coder: NSCoder) {
        coder.encode(subscriptionUrl, forKey: "subscriptionUrl")
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(updateDate, forKey: "updateDate")
        coder.encode(enabled, forKey: "enabled")
        coder.encode(desc, forKey: "desc")
        coder.encode(version, forKey: "version")
        coder.encode(rulesCount, forKey: "rulesCount")
        coder.encode(homepage, forKey: "homepage")
    }
    
    required init?(coder: NSCoder) {
        self.subscriptionUrl = coder.decodeObject(forKey: "subscriptionUrl") as? String ?? ""
        self.id = coder.decodeInteger(forKey: "id")
        self.name = coder.decodeObject(forKey: "name") as? String ?? ""
        self.updateDate = coder.decodeObject(forKey: "updateDate") as? Date ?? Date()
        self.enabled = coder.decodeBool(forKey: "enabled")
        self.desc = coder.decodeObject(forKey: "desc") as? String ?? ""
        self.version = coder.decodeObject(forKey: "version") as? String? ?? ""
        self.rulesCount = coder.decodeObject(forKey: "rulesCount") as? Int? ?? 0
        self.homepage = coder.decodeObject(forKey: "homepage") as? String? ?? ""
    }
}

@objcMembers
class DnsFiltersService: NSObject, DnsFiltersServiceProtocol {
    
    var filters = [DnsFilter]()
    
    var allFiltersCount: Int {
        get {
            return filters.count
        }
    }
    
    var enabledFiltersCount: Int {
        get {
            var count = 0
            filters.forEach { (filter) in
                if filter.enabled {
                    count += 1
                }
            }
            return count
        }
    }
    
    var filtersAreUpdating: Bool = false
    
    private let defaultFilterId = 0
    private let userFilterId = 1
    private let whitelistFilterId = 2
    private let kSharedDefaultsDnsFiltersMetaKey = "kSharedDefaultsDnsFiltersMetaKey"
    
    private let resources: AESharedResourcesProtocol
    private let vpnManager: APVPNManagerProtocol?
    private let parser = AASFilterSubscriptionParser()
    
    init(resources: AESharedResourcesProtocol, vpnManager: APVPNManagerProtocol?) {
        self.resources = resources
        self.vpnManager = vpnManager
        
        super.init()
        readFiltersMeta()
    }
    
    private var idCounter: Int {
        get {
            var currentValue = resources.sharedDefaults().integer(forKey: DnsFilterUniqueId)
            // defaultFilterId = 0, userFilterId = 1, whitelistFilterId = 2 , next available id is 3
            currentValue = currentValue < 3 ? 3 : currentValue
            resources.sharedDefaults().set(currentValue + 1, forKey: DnsFilterUniqueId)
            return currentValue
        }
    }
    
    var filtersJson: String  {
        get {
            // If DNS requests blocking option is off, we return empty json
            let dnsRequestsBlockingEnabled = resources.sharedDefaults().bool(forKey: AEDefaultsDNSRequestsBlocking)
            if !dnsRequestsBlockingEnabled {
                return "[]"
            }
            
            let filtersToAdd = filters.filter { $0.enabled }
            var json = filtersToAdd.map({ (filter) -> [String:Any] in
                return ["id":filter.id, "path":filterPath(filterId: filter.id)]
            })
            
            // todo: do not read all rules to get counter
            let systemBlackListEnabled = resources.sharedDefaults().bool(forKey: AEDefaultsDnsBlacklistEnabled)
            if userRules.count > 0 && systemBlackListEnabled {
                json.append(["id": userFilterId, "path": filterPath(filterId: userFilterId)])
            }
            
            // todo: do not read all rules to get counter
            let systemWhiteListEnabled = resources.sharedDefaults().bool(forKey: AEDefaultsDnsWhitelistEnabled)
            if whitelistDomains.count > 0 && systemWhiteListEnabled {
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
            guard let data = resources.loadData(fromFileRelativePath: filterFileName(filterId: whitelistFilterId)) else {
                DDLogError("(DnsFiltersService) error - can not read whitelist from file")
                return []
            }
            
            guard let string = String(data: data, encoding: .utf8) else {
                DDLogError("(DnsFiltersService) error - can not convert whitelist data to string")
                return []
            }
            
            return string.isEmpty ? [] : string.components(separatedBy: .newlines)
        }
        set {
            if let data = newValue.joined(separator: "\n").data(using: .utf8) {
                resources.save(data, toFileRelativePath: filterFileName(filterId: whitelistFilterId))
                vpnManager?.restartTunnel() // update vpn settings and enable tunnel if needed
                
            }
            else {
                DDLogError("(DnsFiltersService) error - can not save whitelist to file")
            }
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
        
        for filter in filters {
            if filter.id == filterId {
                filter.enabled = enabled
                break
            }
        }
        
        saveFiltersMeta()
        vpnManager?.restartTunnel() // update vpn settings and enable tunnel if needed
    }
    
    func addFilter(_ filter: DnsFilter, data: Data?) {
        // Check if there are no identical filters
        for filt in filters{
            if filter == filt {
                return
            }
        }
        
        filter.id = idCounter
        filters.append(filter)
        
        if let dataToSave = data {
            let fileName = filterFileName(filterId: filter.id)
            resources.save(dataToSave, toFileRelativePath: fileName)
        }
        
        saveFiltersMeta()
        vpnManager?.restartTunnel()
    }
    
    func deleteFilter(_ filter: DnsFilter) {
        let fileName = filterFileName(filterId: filter.id)
        
        for (i, filt) in filters.enumerated(){
            if filt.id == filter.id {
                filters.remove(at: i)
                resources.save(Data(), toFileRelativePath: fileName)
                saveFiltersMeta()
                return
            }
        }
        vpnManager?.restartTunnel()
    }
    
    func updateFilters(networking: ACNNetworkingProtocol){
        
        filtersAreUpdating = true
        
        for (i,filter) in filters.enumerated() {
            if let url = URL(string: filter.subscriptionUrl ?? ""){
                parser.parse(from: url, networking: networking) {[weak self] (result, error) in
                    guard let self = self else { return }
                    if let parserError = error {
                        DDLogError("Failed updating dns filters with error: \(parserError)")
                        return
                    }
                    if let parserResult = result {
                        let meta = parserResult.meta
                        let dnsFilter = DnsFilter(subscriptionUrl: meta.subscriptionUrl, name: meta.name, date: meta.updateDate ?? Date(), enabled: filter.enabled, desc: meta.descr, version: meta.version, rulesCount: parserResult.rules.count, homepage: meta.homepage)
                        dnsFilter.id = filter.id
                            
                        self.filters[i] = dnsFilter
                        
                        if let dataToSave = parserResult.filtersData {
                            let fileName = self.filterFileName(filterId: dnsFilter.id)
                            self.resources.save(dataToSave, toFileRelativePath: fileName)
                        }
                        
                        self.saveFiltersMeta()
                                                    
                        return
                    }
                }
            }
        }
        filtersAreUpdating = false
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
        // read default filter from bundle and save it in right place
        guard let path = Bundle.main.path(forResource: "dns_filter", ofType: "txt") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            DDLogError("(DnsFiltersService) addDefaultFilter error - can not read filter from bundle")
            return
        }
        
        let filterUrl = "https://filters.adtidy.org/ios/filters/15_optimized.txt"
        let result = parser.parse(from: data, with: filterUrl)
        let meta = result?.meta
        
        let defaultFilter = DnsFilter(subscriptionUrl: meta?.subscriptionUrl ?? "", name: meta?.name ?? "", date: meta?.updateDate ?? Date(), enabled: true, desc: meta?.descr ?? "", version: meta?.version ?? "", rulesCount: result?.rules.count ?? 0, homepage: meta?.homepage ?? "")
        defaultFilter.id = defaultFilterId
        
        filters.insert(defaultFilter, at: 0)
        
        resources.save(data, toFileRelativePath: filterFileName(filterId: defaultFilter.id))
    }
    
    private func filterFileName(filterId: Int)->String {
        return "dns_filter_\(filterId).txt"
    }
    
    private func filterPath(filterId: Int)->String {
        return resources.path(forRelativePath: filterFileName(filterId: filterId))
    }
}
