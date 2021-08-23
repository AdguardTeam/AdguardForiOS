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

// MARK - service protocol -

/**
 DnsProvidersService is responsible for managing dns providers
 */
@objc protocol DnsProvidersServiceProtocol {
    var delegate: DnsProvidersServiceDelegate? { get set }
    
    var vpnManager: VpnManagerProtocol? { get set }
    
    var allProviders: [DnsProviderInfo] { get }
    var predefinedProviders: [DnsProviderInfo] { get }
    var customProviders: [DnsProviderInfo] { get set }
    var adguardDohServer: DnsServerInfo? { get }
    var adguardFamilyDohServer: DnsServerInfo? { get }
    
    var activeDnsServer: DnsServerInfo? { get set }
    var activeDnsProvider: DnsProviderInfo? { get }
    var currentServerName: String { get }
    
    func addCustomProvider(name: String, upstream: String, _ onProviderAdded: @escaping () -> Void)
    func deleteProvider(_ provider: DnsProviderInfo, _ onProviderDeleted: @escaping () -> Void)
    func updateProvider(_ provider: DnsProviderInfo, _ onProviderUpdated: @escaping () -> Void)
    func isCustomServer(_ server: DnsServerInfo) -> Bool
    func isActiveProvider(_ provider: DnsProviderInfo) -> Bool
    func getServer(serverId: Int) -> DnsServerInfo?
    func getServerName(serverId: Int) -> String?
    
    func reset()
}

@objc protocol DnsProvidersServiceDelegate: AnyObject {
    func dnsProvidersChanged()
}

@objc class DnsProvidersService: NSObject, DnsProvidersServiceProtocol {
    
    static let customProviderIdUpperRange = 9999
    static let systemDefaultProviderId = 10000
    
    private var predefinedProvidersInternal: [DnsProviderInfo]?
    private var customProvidersInternal: [DnsProviderInfo]?
    private let workingQueue = DispatchQueue(label: "dns providers queue")
    
    @objc private let resources: AESharedResourcesProtocol
    weak var delegate: DnsProvidersServiceDelegate?
    weak var vpnManager: VpnManagerProtocol?
    
    private let APDefaultsCustomDnsProviders = "APDefaultsCustomDnsProviders"
    
    /*
     Language map for providers_i18n.json
     Some languages codes from json differ from apple ones
    */
    private var languageMap = ["es": "es-ES",
                               "zh-Hans": "zh-CN",
                               "zh-Hant": "zh-TW"]
    
    private var currentLocaleCode: String
    
    @objc convenience init(resources: AESharedResourcesProtocol) {
        self.init(resources: resources, locale: Bundle.main.preferredLocaleCode)
    }
    
    @objc init(resources: AESharedResourcesProtocol, locale: String) {
        self.resources = resources
        
        // migration:
        // in app version 3.1.4 and below we mistakenly used the name Adguard.DnsProviderInfo with namespace
        // now we use DnsProviderInfo
        NSKeyedUnarchiver.setClass(DnsProviderInfo.self, forClassName: "Adguard.DnsProviderInfo")
        
        self.currentLocaleCode = locale
        
        super.init()
        
        // TODO: - Remove?
        //self.migrateActiveServerIfNeeded()
    }
    
    @objc var predefinedProviders: [DnsProviderInfo] {
        get {
            if predefinedProvidersInternal == nil {
                self.initializeDnsProviders()
            }
            
            return predefinedProvidersInternal ?? []
        }
    }
    
    var customProviders: [DnsProviderInfo] {
        get {
            if customProvidersInternal == nil {
                if let data = resources.sharedDefaults().object(forKey: APDefaultsCustomDnsProviders) as? Data {
                    customProvidersInternal = NSKeyedUnarchiver.unarchiveObject(with: data) as? [DnsProviderInfo] ?? []
                }
            }
            
            return customProvidersInternal ?? []
        }
        
        set {
            customProvidersInternal = newValue
            if customProvidersInternal != nil {
                let data = NSKeyedArchiver.archivedData(withRootObject: customProvidersInternal!)
                resources.sharedDefaults().set(data, forKey: APDefaultsCustomDnsProviders)
                resources.sharedDefaults().synchronize()
            }
        }
    }
    
    var allProviders: [DnsProviderInfo] {
        return predefinedProviders + customProviders
    }
    
    @objc var activeDnsServer: DnsServerInfo? {
        get {
            return resources.currentAdGuardImplementationDnsServer
        }
        set {
            resources.currentAdGuardImplementationDnsServer = newValue
        }
    }
    
    var activeDnsProvider: DnsProviderInfo? {
        get {
            return allProviders.first { provider in
                provider.providerId == activeDnsServer?.providerId
            }
        }
    }
    
    /* True if there is no saved server id among fetched providers */
    private var providerIsMissing: Bool { activeDnsProvider == nil && activeDnsServer != nil }
    
    func addCustomProvider(name: String, upstream: String, _ onProviderAdded: @escaping () -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            let maxId = self.customProviders.map{ $0.providerId }.max() ?? 0
            let providerId = maxId + 1
            let provider = DnsProviderInfo(name: name, providerId: providerId)
            let serverProtocol = DnsProtocol.getProtocolByUpstream(upstream)
        
            let customServersCount = self.customProviders.flatMap({ $0.servers ?? [] }).count
            let serverId = String(customServersCount + 100000)
            let server = DnsServerInfo(dnsProtocol: serverProtocol, serverId: serverId, name: name, upstreams: [upstream], providerId: providerId)
    
            provider.servers = [server]
            
            self.customProviders.append(provider)
            self.activeDnsServer = server
            self.delegate?.dnsProvidersChanged()
            onProviderAdded()
        }
    }
    
    func deleteProvider(_ provider: DnsProviderInfo, _ onProviderDeleted: @escaping () -> Void)  {
        workingQueue.async { [weak self] in
            guard let self = self else { return }

            // search provider by server id.
            self.customProviders = self.customProviders.filter {
                $0.servers?.first?.serverId != provider.servers?.first?.serverId
            }
            self.delegate?.dnsProvidersChanged()
            onProviderDeleted()
        }
    }
    
    func updateProvider(_ provider: DnsProviderInfo, _ onProviderUpdated: @escaping () -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            
            // search provider by server id.
            self.customProviders = self.customProviders.map { currentProvider -> DnsProviderInfo in
                guard let server = currentProvider.servers?.first else { return currentProvider }
                if server.serverId == provider.servers?.first?.serverId {
                    server.name = provider.servers?.first?.name ?? ""
                    server.upstreams = provider.servers?.first?.upstreams ?? []
                    server.dnsProtocol = provider.servers?.first?.dnsProtocol ?? .dns
                    
                    if server.serverId == self.activeDnsServer?.serverId {
                        self.activeDnsServer = server
                    }
                }
                return currentProvider
            }
            self.delegate?.dnsProvidersChanged()
            onProviderUpdated()
        }
    }
    
    @objc
    func isCustomServer(_ server: DnsServerInfo) -> Bool {
        return customProviders.contains {
            $0.servers?.first?.serverId == server.serverId
        }
    }
    
    func isActiveProvider(_ provider: DnsProviderInfo) -> Bool {
        guard let server = activeDnsServer else { return false }
        return provider.servers?.contains { $0.serverId == server.serverId } ?? false
    }
    
    var currentServerName: String {
        guard let server = activeDnsServer, !providerIsMissing else {
            return String.localizedString("system_dns_server")
        }
        
        let provider = activeDnsProvider
        
        return createServerName(server: server, provider: provider)
    }
    
    func getServer(serverId: Int) -> DnsServerInfo? {
        for provider in allProviders {
            for server in provider.servers ?? [] {
                if Int(server.serverId) == serverId {
                    return server
                }
            }
        }
        
        return nil
    }
    
    func getServerName(serverId: Int) -> String? {
        for provider in allProviders {
            for server in provider.servers ?? [] {
                if Int(server.serverId) == serverId {
                    return createServerName(server: server, provider: provider)
                }
            }
        }
        
        return nil
    }
    
    func reset() {
        customProvidersInternal = nil
        predefinedProvidersInternal = nil
    }
    
    var adguardDohServer: DnsServerInfo? {
        return serverWithId("adguard-doh")
    }
    
    var adguardFamilyDohServer: DnsServerInfo? {
        return serverWithId("adguard-family-doh")
    }
    
    // MARK: - private methods
    
    private func createServerName(server: DnsServerInfo, provider: DnsProviderInfo?)->String {
        if isCustomServer(server) {
            return provider?.name ?? server.name
        }
        
        let protocolName = String.localizedString(DnsProtocol.stringIdByProtocol[server.dnsProtocol]!)
        return "\(provider?.name ?? server.name) (\(protocolName))"
    }
    
    private func serverWithId(_ id: String) -> DnsServerInfo? {
        for provider in allProviders {
            for server in provider.servers ?? [] {
                if server.serverId == id {
                    return server
                }
            }
        }
        return nil
    }
    
    private func defaultProtocol(_ provider: DnsProviderInfo) -> DnsProtocol {
        
        let doh = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.doh
        }
        
        if doh != nil {
            return .doh
        }
        
        let dot = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.dot
        }

        if dot != nil {
            return .dot
        }
        
        let dnsCrypt = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.dnsCrypt
        }
        
        if dnsCrypt != nil {
            return .dnsCrypt
        }
        
        let regular = provider.servers?.first { (dns) -> Bool in
            return dns.dnsProtocol == DnsProtocol.dns
        }
        
        if regular != nil {
            return .dns
        }
        
        return provider.servers?.first?.dnsProtocol ?? .dns
    }
    
    /* Initializes providers from providers.json */
    private func initializeDnsProviders() {
        guard  let jsonData = getData(forFileName: "providers") else {
            DDLogError("Got nil json data")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let decodedObject = try decoder.decode(DnsProviders.self, from: jsonData)
            let dnsProviders = decodedObject.providers.filter { (provider) -> Bool in
                provider.providerId != DnsProvidersService.systemDefaultProviderId
            }
            let features = decodedObject.features
            localize(dnsProviders: dnsProviders, features: features)
        }
        catch {
            DDLogError("Failed to parse providers.json; error: \(error.localizedDescription)")
        }
    }
    
    /* Gets localizations for providers from providers_i18n.json */
    private func localize(dnsProviders: [DnsProvider], features: [DnsFeature]) {
        guard  let jsonData = getData(forFileName: "providers_i18n") else {
            DDLogError("Got nil json data")
            return
        }
        
        var json: [String: Any] = [:]
        do {
            json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
        } catch {
            DDLogError(error.localizedDescription)
            return
        }
        
        // Fill providers from json
        let dnsProviders = getLocalizedProvidersForCurrentLocale(dnsProviders: dnsProviders, features: features, localizationsJson: json)
        
        self.predefinedProvidersInternal = dnsProviders.map { provider -> DnsProviderInfo in
            let providerInfo = DnsProviderInfo(name: provider.localizedName ?? "", providerId: provider.provider.providerId)
            
            providerInfo.logo = provider.provider.logo
            providerInfo.logoDark = "\(provider.provider.logo)_dark"
            providerInfo.protocols = provider.provider.servers.map { DnsProtocol(type: $0.type) }
            providerInfo.summary = provider.localizedDescription
            
            providerInfo.features = provider.features?.map {
                DnsProviderFeature(name: $0.featureId, title: $0.localizedName ?? "", summary: $0.localizedDescription ?? "", iconId: $0.logo ?? "")
            }
            
            providerInfo.servers = provider.provider.servers.map {
                return DnsServerInfo(dnsProtocol: DnsProtocol(type: $0.type), serverId: String($0.id), name: "", upstreams: $0.upstreams, providerId: $0.providerId)
            }
            
            let protcol = providerInfo.getActiveProtocol(resources)
            if protcol == nil {
                let prot = defaultProtocol(providerInfo)
                providerInfo.setActiveProtocol(resources, protcol: prot)
            }
            
            return providerInfo
        }
    }
    
    /* Returns json Data from file name */
    private func getData(forFileName fileName: String) -> Data? {
        guard let pathString = Bundle.main.path(forResource: fileName, ofType: "json") else {
            DDLogError("Failed to get \(fileName).json path")
            return nil
        }
        
        let pathUrl = URL(fileURLWithPath: pathString)
        
        guard let jsonData = try? Data(contentsOf: pathUrl) else {
            DDLogError("Failed to get json data from path: \(pathString)")
            return nil
        }
        
        return jsonData
    }
    
    /* Fills dns providers with localizations for current locale */
    private func getLocalizedProvidersForCurrentLocale(dnsProviders: [DnsProvider], features: [DnsFeature], localizationsJson: [String: Any]) -> [LocalizedDnsProviderInfo] {
        guard let providersJson = localizationsJson["providers"] as? [String: Any] else {
            DDLogError("There is no field 'providers' in providers_i18n json")
            return []
        }
        
        guard let featuresLocalizationsJson = localizationsJson["features"] as? [String: Any] else {
            DDLogError("There is no field 'features' in providers_i18n json")
            return []
        }
        
        let localizedDnsProviders = dnsProviders.compactMap { dnsProvider -> LocalizedDnsProviderInfo? in
            return localize(dnsProvider: dnsProvider, features: features, fromJson: providersJson, featuresLocalizationsJson: featuresLocalizationsJson)
        }
        
        return localizedDnsProviders
    }
    
    /* Localizes dns provider from json with localizations */
    private func localize(dnsProvider: DnsProvider, features:[DnsFeature], fromJson json: [String: Any], featuresLocalizationsJson: [String: Any]) -> LocalizedDnsProviderInfo? {
        let localeCode = languageMap[currentLocaleCode] ?? currentLocaleCode
        
        let providerId = String(dnsProvider.providerId)
        
        guard let providerLocalizationsJson = json[providerId] as? [String: Any] else {
            DDLogError("There is no json for provider with id = \(providerId)")
            return nil
        }
        
        let translation = getTranslation(fromJson: providerLocalizationsJson, forLocale: localeCode)
        
        let name = translation?.name
        let description = translation?.description
        
        var featuresSet = Set<String>()
        for server in dnsProvider.servers {
            for feature in server.features {
                featuresSet.insert(feature)
            }
        }
        
        let featuresArray = Array<String>(featuresSet)
        
        var featureLogos = [String:String]()
        for featureInfo in features {
            featureLogos[featureInfo.type] = featureInfo.logo
        }
        
        let localizedFeatures = featuresArray.compactMap { (feature) -> LocalizedDnsFeature? in
            guard let featureJson = featuresLocalizationsJson[feature] as? [String: Any] else {
                DDLogError("There is no localization for reature with id = \(feature)")
                return nil
            }
            let translation = getTranslation(fromJson: featureJson, forLocale: localeCode)
            let localizedFeature = LocalizedDnsFeature(featureId: feature, name: translation?.name, description: translation?.description, logo: featureLogos[feature])
            return localizedFeature
        }
        
        return LocalizedDnsProviderInfo(provider: dnsProvider, name: name, description: description, features: localizedFeatures)
    }
    
    private func getTranslation(fromJson json: [String: Any], forLocale locale: String) -> (name: String?, description: String?)? {
        // Get english translations
        guard let enLocaleJson = json["en"] as? [String: Any] else {
            DDLogError("English description for provider is missing")
            return nil
        }
        let enName = enLocaleJson["name"] as? String
        let enDescription = enLocaleJson["description"] as? String
        
        guard let currentLocaleJson = json[locale] as? [String: Any] else {
            // If json for current locale is missing return english translations
            return (enName, enDescription)
        }
        
        let nameForLocale = currentLocaleJson["name"] as? String
        let descriptionForLocale = currentLocaleJson["description"] as? String
        
        return (nameForLocale ?? enName, descriptionForLocale ?? enDescription)
    }
}

// MARK: - AESharedResourcesProtocol extension

extension AESharedResourcesProtocol {
    dynamic var currentAdGuardImplementationDnsServer: DnsServerInfo? {
        get {
            if let serverData = sharedDefaults().data(forKey: ActiveDnsServer) {
                let decoder = JSONDecoder()
                let serverInfo = try? decoder.decode(DnsServerInfo.self, from: serverData)
                return serverInfo
            }
            return nil
        }
        set {
            var dataToSave: Data?
            if let serverToSave = newValue {
                let encoder = JSONEncoder()
                let serverData = try? encoder.encode(serverToSave)
                dataToSave = serverData
            }
            sharedDefaults().setValue(dataToSave, forKey: ActiveDnsServer)
            NotificationCenter.default.post(name: .currentDnsServerChanged, object: nil)
        }
    }
}

extension Notification.Name {
    static var currentDnsServerChanged: Notification.Name { return .init(rawValue: "currentDnsServerChanged") }
}
