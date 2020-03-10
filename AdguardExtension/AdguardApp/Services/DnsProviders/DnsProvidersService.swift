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
@objc
protocol DnsProvidersServiceProtocol {
    
    var allProviders: [DnsProviderInfo] { get }
    var predefinedProviders: [DnsProviderInfo] { get }
    var customProviders: [DnsProviderInfo] { get }
    
    var activeDnsServer: DnsServerInfo? { get set }
    var activeDnsProvider: DnsProviderInfo? { get }
    var currentServerName: String { get }
    
    func addProvider(name: String, upstreams:[String])->DnsProviderInfo
    func deleteProvider(_ provider: DnsProviderInfo)
    func updateProvider(_ provider: DnsProviderInfo)
    func isCustomProvider(_ provider: DnsProviderInfo)->Bool
    func isCustomServer(_ server: DnsServerInfo)->Bool
    func isActiveProvider(_ provider: DnsProviderInfo)->Bool
}

@objc class DnsProvidersService: NSObject, DnsProvidersServiceProtocol {
    
    private var predefinedProvidersInternal: [DnsProviderInfo]?
    private var customProvidersInternal: [DnsProviderInfo]?
    private let workingQueue = DispatchQueue(label: "dns providers queue")
    
    @objc private let resources: AESharedResourcesProtocol
    
    private let APDefaultsCustomDnsProviders = "APDefaultsCustomDnsProviders"
    
    @objc init(resources: AESharedResourcesProtocol) {
        self.resources = resources
    }
    
    @objc var predefinedProviders: [DnsProviderInfo] {
        get {
            if predefinedProvidersInternal == nil {
                self.readServersJson()
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
    
    @objc var allProviders: [DnsProviderInfo] {
        return predefinedProviders + customProviders
    }
    
    @objc var activeDnsServer: DnsServerInfo? {
        get {
            guard let data = resources.sharedDefaults().object(forKey:AEDefaultsActiveDnsServer) as? Data else { return nil }
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? DnsServerInfo
            
        }
        set {
            guard let server = newValue else {
                resources.sharedDefaults().removeObject(forKey: AEDefaultsActiveDnsServer)
                return
            }
            
            let data = NSKeyedArchiver.archivedData(withRootObject:server)
            
            willChangeValue(for: \.activeDnsServer)
            resources.sharedDefaults().set(data, forKey: AEDefaultsActiveDnsServer)
            didChangeValue(for: \.activeDnsServer)
        }
    }
    
    var activeDnsProvider: DnsProviderInfo? {
        get {
            let activeServer = activeDnsServer
            return allProviders.first { (provider) in
                provider.servers?.contains { $0.serverId == activeServer?.serverId } ?? false
            }
        }
    }
    
    @objc func addProvider(name: String, upstreams: [String]) -> DnsProviderInfo {
        let provider = DnsProviderInfo(name: name)
        
        let server = DnsServerInfo(dnsProtocol: .dns, serverId: UUID().uuidString, name: name, upstreams: upstreams, anycast: nil)
        
        provider.servers = [server]
        
        workingQueue.sync { [weak self] in
            self?.customProviders.append(provider)
        }
        
        return provider
    }
    
    func deleteProvider(_ provider: DnsProviderInfo)  {
        
        workingQueue.sync { [weak self] in
            guard let self = self else { return }

            self.willChangeValue(forKey: "allProviders")
            
            // search provider by server id.
            customProviders = customProviders.filter {
                $0.servers?.first?.serverId == provider.servers?.first?.serverId
            }
            
            self.didChangeValue(forKey: "allProviders")
        }
    }
    
    func updateProvider(_ provider: DnsProviderInfo)  {
        workingQueue.sync { [weak self] in
            guard let self = self else { return }

            self.willChangeValue(forKey: "allProviders")
            
            // search provider by server id.
            customProviders = customProviders.map { (currentProvider)->DnsProviderInfo in
                guard let server = currentProvider.servers?.first else { return currentProvider }
                if server.serverId == provider.servers?.first?.serverId {
                    server.name = provider.servers?.first?.name ?? ""
                    server.upstreams = provider.servers?.first?.upstreams ?? []
                }
                
                return currentProvider
            }
            
            self.didChangeValue(forKey: "allProviders")
        }
    }
    
    func isCustomProvider(_ provider: DnsProviderInfo)->Bool {
        return customProviders.contains {
            $0.servers?.first?.serverId == provider.servers?.first?.serverId
        }
    }
    
    @objc
    func isCustomServer(_ server: DnsServerInfo)->Bool {
        return customProviders.contains {
            $0.servers?.first?.serverId == server.serverId
        }
    }
    
    func isActiveProvider(_ provider: DnsProviderInfo)->Bool {
        guard let server = activeDnsServer else { return false }
        return provider.servers?.contains { $0.serverId == server.serverId } ?? false
    }
    
    var currentServerName: String {
        guard let server = activeDnsServer else {
            return String.localizedString("system_dns_server")
        }
        
        let provider = activeDnsProvider
        let protocolName = String.localizedString(DnsProtocol.stringIdByProtocol[server.dnsProtocol]!)
        
        return "\(provider?.name ?? server.name) (\(protocolName))"
    }
    
    // MARK: - private methods
    
    private func readServersJson() {
        
        guard let path = Bundle.main.path(forResource: "providers", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, AnyObject> else { return }
            
            // parse features
            guard let featuresJson = json["features"] as? Array<Dictionary<String, String>> else { return }
            
            var featuresMap = Dictionary<String, DnsProviderFeature>()
            for featureJson in featuresJson {
                guard   let name = featureJson["name"],
                        let title = featureJson["title"],
                        let summary = featureJson["summary"],
                        let iconId = featureJson["icon_id"]
                    else { return }
                
                let feature = DnsProviderFeature(name: name, title: title, summary: summary, iconId: iconId)
                featuresMap[name] = feature
            }
            
            // parse providers
            guard let providersJson = json["dnsProviders"] as? Array<Dictionary<String, Any>> else { return }
            
            var dnsProviders = [DnsProviderInfo]()
            for providerJson in providersJson {
                guard   let name = providerJson["name"] as? String,
                        let logo = providerJson["logo"] as? String,
                        let summary = providerJson["summary"] as? String,
                        let website = providerJson["website"] as? String
                    else { return }
                
                // parse protocols
                guard let protocolsJson = providerJson["protocols"] as? [String] else { return }
                let protocols = self.protocolsFromArray(protocolsJson)
                
                // parse features
                guard let featuresJson = providerJson["features"] as? [String] else { return }
                let features = self.featuresFromArray(featuresJson, featuresMap: featuresMap)
             
                guard let serversJson = providerJson["servers"] as? [[String: Any]] else { return }
                let servers = self.serversFromArray(serversJson)
                
                let provider = DnsProviderInfo(name: name)
                let logoDark = logo + "_white"
                
                provider.logo = logo
                provider.logoDark = logoDark
                provider.summary = summary
                provider.protocols = protocols
                provider.features = features
                provider.servers = servers
                provider.website = website
                
                let protcol = provider.getActiveProtocol(resources)
                if protcol == nil {
                    let prot = defaultProtocol(provider)
                    provider.setActiveProtocol(resources, protcol: prot)
                }
                
                dnsProviders.append(provider)
            }
            
            self.predefinedProvidersInternal = dnsProviders
        }
        catch {
            
        }
    }
    
    private func protocolsFromArray(_ arr: [String]) -> [DnsProtocol] {
        var protocols = [DnsProtocol] ()
        
        for protocolName in arr {
            protocols.append(DnsProtocol.protocolByString[protocolName]!)
        }
        
        return protocols
    }
    
    func featuresFromArray(_ arr: [String], featuresMap: [String: DnsProviderFeature]) -> [DnsProviderFeature] {
        var features = [DnsProviderFeature]()
        
        for featureName in arr {
            features.append(featuresMap[featureName]!)
        }
        
        return features
    }
    
    private func serversFromArray(_ arr:[[String: Any]]) -> [DnsServerInfo] {
        
        var servers = [DnsServerInfo]()
        
        for serverJson in arr {
            guard   let serverProtocolId = serverJson["protocol"] as? String,
                    let serverId = serverJson["id"] as? String,
                    let name = serverJson["name"] as? String,
                    let upstreams = serverJson["upstreams"] as? [String]
                else { continue }
            
            let anycast = serverJson["anycast"] as? Bool
            
            let server = DnsServerInfo(dnsProtocol: DnsProtocol.protocolByString[serverProtocolId]!, serverId: serverId, name: name, upstreams: upstreams, anycast: anycast)
            
            servers.append(server)
        }
        
        return servers
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
}
