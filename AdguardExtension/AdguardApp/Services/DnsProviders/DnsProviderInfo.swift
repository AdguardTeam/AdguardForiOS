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
@objc enum DnsProtocol: Int, Codable {
    case dns = 0
    case dnsCrypt
    case doh
    case dot
    case doq
    
    init(type: DnsType) {
        switch (type) {
        case .dns:
            self = .dns
        case .dnscrypt:
            self = .dnsCrypt
        case .doh:
            self = .doh
        case .dot:
            self = .dot
        case .doq:
            self = .doq
        }
    }
    
    static let protocolByString: [String: DnsProtocol] = [ "dns": .dns,
                                                           "dnscrypt": .dnsCrypt,
                                                           "doh": .doh,
                                                           "dot": .dot,
                                                           "doq": .doq]
    
    static let stringIdByProtocol: [DnsProtocol: String] = [.dns: "regular_dns_protocol",
                                                            .dnsCrypt: "dns_crypt_protocol",
                                                            .doh: "doh_protocol",
                                                            .dot: "dot_protocol",
                                                            .doq: "doq_protocol"]
    
    static let prefixByProtocol: [DnsProtocol: String] = [.dnsCrypt: "sdns://",
                                                          .doh: "https://",
                                                          .dot: "tls://",
                                                          .doq: "quic://"]
    
    static func getProtocolByUpstream(_ upstream: String) -> DnsProtocol {
        if let dohPrefix = DnsProtocol.prefixByProtocol[.doh], upstream.hasPrefix(dohPrefix) {
            return .doh
        }
        
        if let dotPrefix = DnsProtocol.prefixByProtocol[.dot], upstream.hasPrefix(dotPrefix) {
            return .dot
        }
        
        if let dnsCryptPrefix = DnsProtocol.prefixByProtocol[.dnsCrypt], upstream.hasPrefix(dnsCryptPrefix) {
            return .dnsCrypt
        }
        
        return .dns
    }
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
    
    init(dnsProtocol: DnsProtocol, serverId: String, name: String, upstreams: [String]) {
        self.serverId = serverId
        self.dnsProtocol = dnsProtocol
        self.name = name
        self.upstreams = upstreams
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

@objc(DnsProviderInfo)
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
    
    init(name: String, logo: String?, logoDark: String?, summary: String?, protocols: [DnsProtocol]?, features: [DnsProviderFeature]?, website: String?, servers: [DnsServerInfo]?) {
        self.name = name
        self.logo = logo
        self.logoDark = logoDark
        self.summary = summary
        self.protocols = protocols
        self.features = features
        self.website = website
        self.servers = servers
        super.init()
    }
    
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
        
        /**
         If searching a server by protocol failed
         the method will just return the first protocol of this server
         */
        return servers?.first
    }
    
    func getActiveProtocol(_ resources: AESharedResourcesProtocol) -> DnsProtocol? {
        if let protocolRawValue = resources.dnsActiveProtocols[name]{
            return DnsProtocol(rawValue: protocolRawValue)
        }
        return nil
    }
    
    func setActiveProtocol(_ resources: AESharedResourcesProtocol, protcol: DnsProtocol?) {
        resources.dnsActiveProtocols[name] = protcol?.rawValue
    }
}
