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

// MARK: - data types -
@objc enum DnsProtocol: Int {
    case dns
    case dnsCrypt
    case doh
    case dot
    
    static let protocolByString: [String: DnsProtocol] = [ "dns": .dns,
                                                           "dnscrypt": .dnsCrypt,
                                                           "doh": .doh,
                                                           "dot": .dot]
    
    static let stringIdByProtocol: [DnsProtocol: String] = [.dns: "regular_dns_protocol",
                                                            .dnsCrypt: "dns_crypt_protocol",
                                                            .doh: "doh_protocol",
                                                            .dot: "dot_protocol"]
    
}

struct DnsProviderFeature {
    var name: String
    var title: String
    var summary: String
    var iconId: String
}

@objc(DnsServerInfo)
@objcMembers
class DnsServerInfo : ACObject {
    
    var dnsProtocol: DnsProtocol
    var serverId: String
    var name: String
    var upstreams: [String]
    var anycast: Bool?
    
    @objc static let adguardDnsIds: Set<String> = ["adguard-dns", "adguard-doh", "adguard-dot", "adguard-dnscrypt"]
    @objc static let adguardFamilyDnsIds: Set<String> = ["adguard-dns-family", "adguard-family-doh", "adguard-family-dot", "adguard-family-dnscrypt"]
    
    // MARK: - initializers and NSCoding methods
    
    init(dnsProtocol: DnsProtocol, serverId: String, name: String, upstreams: [String], anycast: Bool?) {
        self.serverId = serverId
        self.dnsProtocol = dnsProtocol
        self.name = name
        self.upstreams = upstreams
        self.anycast = anycast
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        serverId = aDecoder.decodeObject(forKey: "server_id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        upstreams = aDecoder.decodeObject(forKey: "upstreams") as! [String]
        dnsProtocol = DnsProtocol(rawValue: aDecoder.decodeInteger(forKey: "dns_protocol")) ?? .dns
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(serverId, forKey: "server_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(upstreams, forKey: "upstreams")
        aCoder.encode(dnsProtocol.rawValue, forKey: "dns_protocol")
    }
}

@objcMembers class DnsProviderInfo : ACObject {
    var name: String
    var logo: String?
    var logoDark: String?
    var summary: String?
    var protocols: [DnsProtocol]?
    var features: [DnsProviderFeature]?
    var website: String?
    @objc var servers: [DnsServerInfo]?
    
    // MARK: - initializers and NSCoding methods
    init(name: String) {
        self.name = name
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(name, forKey: "name")
    }
    
    func serverByProtocol(dnsProtocol: DnsProtocol) -> DnsServerInfo? {
        if servers == nil { return nil }
        for server in servers! {
            if server.dnsProtocol == dnsProtocol {
                return server
            }
        }
        
        return nil
    }
}

// MARK - service protocol -

/**
 DnsProvidersService is responsible for managing dns providers
 */
protocol DnsProvidersServiceProtocol {
    
    var providers: [DnsProviderInfo] { get }
    
    func createProvider(name: String, upstreams:[String])->DnsProviderInfo
}

@objc class DnsProvidersService: NSObject, DnsProvidersServiceProtocol {
    
    private var providersInternal: [DnsProviderInfo]?
    
    @objc var providers: [DnsProviderInfo] {
        get {
            if providersInternal == nil {
                self.readServersJson()
            }
            
            return providersInternal ?? []
        }
    }
    
    @objc func createProvider(name: String, upstreams: [String]) -> DnsProviderInfo {
        let provider = DnsProviderInfo(name: name)
        
        let server = DnsServerInfo(dnsProtocol: .dns, serverId: UUID().uuidString, name: name, upstreams: upstreams, anycast: nil)
        
        provider.servers = [server]
        
        return provider
    }
    
    @objc func defaultServer() -> DnsServerInfo? {
        return providers.first?.servers?.first
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
                
                dnsProviders.append(provider)
            }
            
            self.providersInternal = dnsProviders
        }
        catch {
            
        }
    }
    
    func protocolsFromArray(_ arr: [String]) -> [DnsProtocol] {
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
    
    func serversFromArray(_ arr:[[String: Any]]) -> [DnsServerInfo] {
        
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
}
