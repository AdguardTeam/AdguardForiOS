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
    
    // Counts enabled filters
    var enabledFiltersCount: Int { get }
    
    // json which can be used in dnsProxy. It contains only enabled filters
    var filtersJson: String { get }
    
    // dns whitelist rules
    // automaticaly updates vpn settings when changed
    var whitelistRules: [String] { get set }
    
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
    func updateFilters(networking: ACNNetworkingProtocol, callback: (()->Void)?)
    
    // resets service settings
    func reset()
    
    // adds a rule to whitelist filter and restarts the tunnel
    func addWhitelistRule(_ rule: String)
    
    // adds a rule to user filter and restarts the tunnel
    func addBlacklistRule(_ rule: String)
    
    // removes rules(!not domains) from whitelist and restarts the tunnel
    func removeWhitelistRules(_ rules: [String])
    
    // removes rules(!not domains) from user filter and restarts the tunnel
    func removeUserRules(_ rules: [String])
}

@objc(DnsFilter)
@objcMembers
class DnsFilter: NSObject, NSCoding, FilterDetailedInterface {
    
    // First 1000 filters are predefined filters
    static let predefinedFiltersRange = 0..<1000
    
    // From 1000 to 2000 are user filters
    static let userFiltersRange = 1000..<2000
    
    // From 2000 to 3000 are whitelist filters
    static let whitelistFiltersRange = 2000..<3000
    
    // From 3000 to infinity are custom filters
    static let customFiltersRange = 3000..<1000000
    
    
    static let basicFilterId = 0
    static let strictFilterId = 1
    static let googleFilterId = 2
    static let facebookFilterId = 3
    
    static let userFilterId = userFiltersRange.lowerBound
    static let whitelistFilterId = whitelistFiltersRange.lowerBound
    
    var id: Int = customFiltersRange.lowerBound
    var subscriptionUrl: String?
    var name: String?
    var attributedString: NSAttributedString? = nil
    var updateDate: Date?
    var enabled: Bool
    var desc: String?
    var importantDesc: String?
    var version: String?
    var rulesCount: Int?
    var homepage: String?
    var removable: Bool {
        get {
            // Check if filter id is in range of predefined filters
            return DnsFilter.predefinedFiltersRange ~= id
        }
    }
    
    // MARK: - Initialization
    
    init(subscriptionUrl: String?, name: String, date: Date, enabled: Bool, desc: String?, importantDesc: String? = nil, version: String?, rulesCount: Int?, homepage: String?) {
        
        self.subscriptionUrl = subscriptionUrl
        self.name = name
        self.updateDate = date
        self.enabled = enabled
        self.desc = desc
        self.importantDesc = importantDesc
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
        coder.encode(importantDesc, forKey: "importantDesc")
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
        self.importantDesc = coder.decodeObject(forKey: "importantDesc") as? String
        self.version = coder.decodeObject(forKey: "version") as? String? ?? ""
        self.rulesCount = coder.decodeObject(forKey: "rulesCount") as? Int? ?? 0
        self.homepage = coder.decodeObject(forKey: "homepage") as? String? ?? ""
    }
}

@objcMembers
class DnsFiltersService: NSObject, DnsFiltersServiceProtocol {
    
    var filters = [DnsFilter]()

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
    
    private let kSharedDefaultsDnsFiltersMetaKey = "kSharedDefaultsDnsFiltersMetaKey"
    
    private let resources: AESharedResourcesProtocol
    private let vpnManager: VpnManagerProtocol?
    private let configuration: ConfigurationServiceProtocol
    private let parser = AASFilterSubscriptionParser()
    private let complexProtection: ComplexProtectionServiceProtocol?
        
    init(resources: AESharedResourcesProtocol, vpnManager: VpnManagerProtocol?, configuration: ConfigurationServiceProtocol, complexProtection: ComplexProtectionServiceProtocol?) {
        self.resources = resources
        self.vpnManager = vpnManager
        self.configuration = configuration
        self.complexProtection = complexProtection
        super.init()
        readFiltersMeta()
    }
    
    private var idCounter: Int {
        get {
            var currentValue = resources.sharedDefaults().integer(forKey: DnsFilterUniqueId)
            // predefinedFiltersRange = 0..<1000, userFiltersRange = 1000..<2000, whitelistFiltersRange = 2000..<3000, customFiltersRange begins from 3000
            currentValue = currentValue < DnsFilter.customFiltersRange.lowerBound ? DnsFilter.customFiltersRange.lowerBound : currentValue
            resources.sharedDefaults().set(currentValue + 1, forKey: DnsFilterUniqueId)
            return currentValue
        }
    }
    
    var filtersJson: String  {
        get {
            let filtersToAdd = filters.filter { $0.enabled }
            var json = filtersToAdd.map({ (filter) -> [String:Any] in
                return ["id":filter.id, "path":filterPath(filterId: filter.id)]
            })
            
            let systemBlackListEnabled = resources.systemUserFilterEnabled
            if userRules.count > 0 && systemBlackListEnabled {
                json.append(["id": DnsFilter.userFilterId, "path": filterPath(filterId: DnsFilter.userFilterId), "user_filter": true])
            }

            let systemWhiteListEnabled = resources.systemWhitelistEnabled
            if whitelistRules.count > 0 && systemWhiteListEnabled {
                json.append(["id": DnsFilter.whitelistFilterId, "path": filterPath(filterId: DnsFilter.whitelistFilterId), "whitelist": true])
            }
            
            guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
                DDLogError("(DnsFiltersService) filtersJson error - can not make json string")
                return "[]"
            }
            
            return String(data: data, encoding: .utf8) ?? "[]"
        }
    }
    
    var whitelistRules: [String] {
        get {
            return loadWhitelistRules()
        }
        set {
            saveWhitlistRules(rules: newValue)
        }
    }
        
    var userRules: [String] {
        get {
            guard let data = resources.loadData(fromFileRelativePath: filterFileName(filterId: DnsFilter.userFilterId)) else {
                DDLogError("(DnsFiltersService) error - can not read user filter from file")
                return []
            }
            
            guard let string = String(data: data, encoding: .utf8) else {
                DDLogError("(DnsFiltersService) error - can not convert user filter data to string")
                return []
            }
            
            return string.isEmpty ? [] : string.components(separatedBy: .newlines).filter { !$0.isEmpty }
        }
        set {
            var rules = newValue
            rules.append("") // temporary fix dnslibs bug
            if let data = rules.joined(separator: "\n").data(using: .utf8) {
                resources.save(data, toFileRelativePath: filterFileName(filterId: DnsFilter.userFilterId))
                vpnManager?.updateSettings { error in
                    if error != nil {
                        DDLogError("(DsnFiltersService) set userRules error: \(error!)")
                    }
                } // update vpn settings and enable tunnel if needed
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
        
        DDLogInfo("(DsnFiltersService) setFilter(enabled) - update vpn settings")
        vpnManager?.updateSettings{ error in
            if error != nil {
                DDLogError("(DsnFiltersService) setFilter(enabled) error: \(error!)")
            }
        }
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
        
        vpnManager?.updateSettings{ error in
            if error != nil {
                DDLogError("(DsnFiltersService) addFilter error: \(error!)")
            }
        }
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
        
        DDLogInfo("(DsnFiltersService) deleteFilter - update vpn settings")
        vpnManager?.updateSettings{ error in
            if error != nil {
                DDLogError("(DsnFiltersService) deleteFilter error: \(error!)")
            }
        }
    }
    
    func updateFilters(networking: ACNNetworkingProtocol, callback: (()->Void)?){
        
        if !configuration.proStatus {
            callback?()
            return
        }
        
        DispatchQueue(label: "update dns filters").async { [weak self] in
            
            defer {
                callback?()
            }
            
            guard let self = self else { return }
            
            self.filtersAreUpdating = true
            
            let group = DispatchGroup()
            
            for (i,filter) in self.filters.enumerated() {
                guard let url = URL(string: filter.subscriptionUrl ?? "") else { return }
                
                group.enter()
                
                self.parser.parse(from: url, networking: networking) {[weak self] (result, error) in
                    
                    defer {
                        group.leave()
                    }
                    
                    guard let self = self else { return }
                    
                    if let parserError = error {
                        DDLogError("Failed updating dns filters with error: \(parserError)")
                        return
                    }
                    if let parserResult = result {
                        let meta = parserResult.meta
                        let dnsFilter = DnsFilter(subscriptionUrl: meta.subscriptionUrl, name: filter.name ?? meta.name, date: meta.updateDate ?? Date(), enabled: filter.enabled, desc: filter.desc ?? meta.descr, importantDesc: filter.importantDesc, version: meta.version, rulesCount: parserResult.rules.count, homepage: meta.homepage)
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
            
            group.wait()
            if self.complexProtection?.systemProtectionEnabled ?? false {
                DDLogInfo("(DsnFiltersService) updateFilters - filters are updated. Start updating vpn settings")
                self.vpnManager?.updateSettings(completion: nil)
            }
            
            self.filtersAreUpdating = false
        }
    }
    
    func reset() {
        readFiltersMeta()
    }
    
    // MARK: - working with user filters
    
    func addWhitelistRule(_ rule: String) {
        whitelistRules.append(rule)
    }
    
    func removeWhitelistRules(_ rules: [String]) {
        var allRules = loadWhitelistRules()
        allRules.removeAll { rules.contains($0) }
        willChangeValue(for: \.whitelistRules)
        saveWhitlistRules(rules: allRules)
        didChangeValue(for: \.whitelistRules)
    }
    
    func addBlacklistRule(_ rule: String) {
        userRules.append(rule)
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
        
        if !filters.contains { $0.id == DnsFilter.basicFilterId } {
            self.addBasicFilter()
            saveFiltersMeta()
        }
        
        if !filters.contains { $0.id == DnsFilter.strictFilterId } {
            self.addStrictFilter()
            saveFiltersMeta()
        }
        
        if !filters.contains { $0.id == DnsFilter.googleFilterId } {
            self.addGoogleFilter()
            saveFiltersMeta()
        }
        
        if !filters.contains { $0.id == DnsFilter.facebookFilterId } {
            self.addFacebookFilter()
            saveFiltersMeta()
        }
    }
    
    private func saveFiltersMeta() {
        let dataToSave = filters.map { NSKeyedArchiver.archivedData(withRootObject: $0) }
        resources.sharedDefaults().set(dataToSave, forKey: kSharedDefaultsDnsFiltersMetaKey)
    }
    
    private func addBasicFilter() {
        guard let path = Bundle.main.path(forResource: "basic", ofType: "txt") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            DDLogError("(DnsFiltersService) addBasicFilter error - can not read filter from bundle")
            return
        }
        
        let filterUrl = "https://filters.adtidy.org/hosts/ios/basic.txt"
        let result = parser.parse(from: data, with: filterUrl)
        let meta = result?.meta
        
        let name = String.localizedString("basic_filter_title")
        let descr = String.localizedString("basic_filter_description")
        
        let basicFilter = DnsFilter(subscriptionUrl: meta?.subscriptionUrl ?? "", name: name, date: meta?.updateDate ?? Date(), enabled: true, desc: descr, version: meta?.version ?? "", rulesCount: result?.rules.count ?? 0, homepage: meta?.homepage ?? "")
        basicFilter.id = DnsFilter.basicFilterId
        
        filters.insert(basicFilter, at: basicFilter.id)
        
        resources.save(data, toFileRelativePath: filterFileName(filterId: basicFilter.id))
    }
    
    private func addStrictFilter() {
        guard let path = Bundle.main.path(forResource: "strict", ofType: "txt") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            DDLogError("(DnsFiltersService) addStrictFilter error - can not read filter from bundle")
            return
        }
        
        let filterUrl = "https://filters.adtidy.org/hosts/ios/strict.txt"
        let result = parser.parse(from: data, with: filterUrl)
        let meta = result?.meta
        
        let name = String.localizedString("strict_filter_title")
        let descr = String.localizedString("strict_filter_description")
        let importantDesc = String.localizedString("google_filter_important_description")
        
        let strictFilter = DnsFilter(subscriptionUrl: meta?.subscriptionUrl ?? "", name: name, date: meta?.updateDate ?? Date(), enabled: true, desc: descr, importantDesc: importantDesc, version: meta?.version ?? "", rulesCount: result?.rules.count ?? 0, homepage: meta?.homepage ?? "")
        strictFilter.id = DnsFilter.strictFilterId
        
        filters.insert(strictFilter, at: strictFilter.id)
        
        resources.save(data, toFileRelativePath: filterFileName(filterId: strictFilter.id))
    }
    
    private func addGoogleFilter() {
        guard let path = Bundle.main.path(forResource: "google", ofType: "txt") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            DDLogError("(DnsFiltersService) addGoogleFilter error - can not read filter from bundle")
            return
        }
        
        let filterUrl = "https://filters.adtidy.org/hosts/ios/google.txt"
        let result = parser.parse(from: data, with: filterUrl)
        let meta = result?.meta
        
        let name = String.localizedString("google_filter_title")
        let descr = String.localizedString("google_filter_description")
        let importantDesc = String.localizedString("google_filter_important_description")
        
        let googleFilter = DnsFilter(subscriptionUrl: meta?.subscriptionUrl ?? "", name: name, date: meta?.updateDate ?? Date(), enabled: true, desc: descr, importantDesc: importantDesc, version: meta?.version ?? "", rulesCount: result?.rules.count ?? 0, homepage: meta?.homepage ?? "")
        googleFilter.id = DnsFilter.googleFilterId
        
        filters.insert(googleFilter, at: googleFilter.id)
        
        resources.save(data, toFileRelativePath: filterFileName(filterId: googleFilter.id))
    }
    
    private func addFacebookFilter() {
        guard let path = Bundle.main.path(forResource: "facebook", ofType: "txt") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            DDLogError("(DnsFiltersService) addFacebookFilter error - can not read filter from bundle")
            return
        }
        
        let filterUrl = "https://filters.adtidy.org/hosts/ios/facebook.txt"
        let result = parser.parse(from: data, with: filterUrl)
        let meta = result?.meta
        
        let name = String.localizedString("facebook_filter_title")
        let descr = String.localizedString("facebook_filter_description")
        let importantDesc = String.localizedString("facebook_filter_important_description")
        
        let facebookFilter = DnsFilter(subscriptionUrl: meta?.subscriptionUrl ?? "", name: name, date: meta?.updateDate ?? Date(), enabled: true, desc: descr, importantDesc: importantDesc, version: meta?.version ?? "", rulesCount: result?.rules.count ?? 0, homepage: meta?.homepage ?? "")
        facebookFilter.id = DnsFilter.facebookFilterId
        
        filters.insert(facebookFilter, at: facebookFilter.id)
        
        resources.save(data, toFileRelativePath: filterFileName(filterId: facebookFilter.id))
    }
    
    private func filterFileName(filterId: Int)->String {
        return "dns_filter_\(filterId).txt"
    }
    
    private func filterPath(filterId: Int)->String {
        return resources.path(forRelativePath: filterFileName(filterId: filterId))
    }
        
    private func loadWhitelistRules()->[String] {
        guard let data = resources.loadData(fromFileRelativePath: filterFileName(filterId: DnsFilter.whitelistFilterId)) else {
            DDLogError("(DnsFiltersService) error - can not read whitelist from file")
            return []
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            DDLogError("(DnsFiltersService) error - can not convert whitelist data to string")
            return []
        }
        
        if string.count == 0 {
            return []
        }
        
        var rules = string.components(separatedBy: .newlines)
        rules = rules.filter { !$0.isEmpty }
        
        return rules
    }
    
    private func saveWhitlistRules(rules:[String]) {
        if let data = rules.joined(separator: "\n").data(using: .utf8) {
            resources.save(data, toFileRelativePath: filterFileName(filterId: DnsFilter.whitelistFilterId))
            vpnManager?.updateSettings{ error in
                if error != nil {
                    DDLogError("(DsnFiltersService) saveWhitlistRules error: \(error!)")
                }
            }
        }
        else {
            DDLogError("(DnsFiltersService) saveWhitlistRules error - can not save user filter to file")
        }
    }
}
