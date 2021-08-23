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

import UIKit

// MARK: - DnsProviderMetaProtocol

/// This protocol covers both Predefined and Custom providers
public protocol DnsProviderMetaProtocol {
    var name: String { get set } // DNS provider name e.g Google DNS
    var providerId: Int { get } // Unique identifier of the provider
    var isEnabled: Bool { get set } // State of the provider enabled/disabled
}

public extension DnsProviderMetaProtocol {
    var isCustom: Bool { self is CustomDnsProviderProtocol }
    var custom: CustomDnsProviderProtocol { self as! CustomDnsProviderProtocol }
    var predefined: DnsProviderProtocol { self as! DnsProviderProtocol }
    var dnsServers: [DnsServerMetaProtocol] { isCustom ? [custom.server] : predefined.servers }
}

// MARK: - DnsServerMetaProtocol

/// This protocol covers both Predefined and Custom servers
public protocol DnsServerMetaProtocol {
    var upstreams: [DnsUpstream] { get } // DNS upstreams of the server
    var providerId: Int { get } // Provider unique identifier the server is related
    var id: Int { get } // DNS server unique identifier
    var isEnabled: Bool { get set } // State of the provider enabled/disabled
}

extension DnsServerMetaProtocol {
    var isPredefined: Bool { self is DnsServerProtocol }
    var predefined: DnsServerProtocol { self as! DnsServerProtocol }
    var type: DnsProtocol { upstreams.first?.`protocol` ?? .dns } // Upstreams are empty for system default server
}

// MARK: - PREDEFINED -

// MARK: - DNS provider

public protocol DnsProviderProtocol: DnsProviderMetaProtocol {
    var providerDescription: String { get } // DNS provider description
    var servers: [DnsServer] { get } // Available DNS servers user can use
    var logo: UIImage? { get } // Logo image of the DNS provider. It is nil only for system default
    var homepage: String { get } // Web site of the DNS provider
}

public struct DnsProvider: DnsProviderProtocol {
    public var name: String
    public let providerDescription: String
    public var servers: [DnsServer]
    public let providerId: Int
    public let logo: UIImage?
    public let homepage: String
    public var isEnabled: Bool
    
    init(name: String, providerDescription: String, servers: [DnsServer], providerId: Int, logo: UIImage?, homepage: String, isEnabled: Bool) {
        self.name = name
        self.providerDescription = providerDescription
        self.servers = servers
        self.providerId = providerId
        self.logo = logo
        self.homepage = homepage
        self.isEnabled = isEnabled
    }
    
    init(provider: PredefinedDnsProvider, servers: [DnsServer], isEnabled: Bool) {
        self.name = provider.name
        self.providerDescription = provider.providerDescription
        self.servers = servers
        self.providerId = provider.providerId
        self.logo = provider.logo
        self.homepage = provider.homepage
        self.isEnabled = isEnabled
    }
    
    mutating func makeActiveServer(with id: Int) {
        for i in 0..<servers.count {
            servers[i].isEnabled = servers[i].id == id
        }
    }
}

// MARK: - DnsServer

public protocol DnsServerProtocol: DnsServerMetaProtocol {
    var name: String { get } // DNS server name e.g. AdGuard DoH
    var features: [DnsFeature] { get } // Features of predefined DNS server e.g. Ad blocking
}

public struct DnsServer: DnsServerProtocol {
    public let features: [DnsFeature]
    public let upstreams: [DnsUpstream]
    public let providerId: Int
    public let id: Int
    public let name: String
    public var isEnabled: Bool
    
    init(features: [DnsFeature], upstreams: [DnsUpstream], providerId: Int, type: DnsProtocol, id: Int, name: String, isEnabled: Bool) {
        self.features = features
        self.upstreams = upstreams
        self.providerId = providerId
        self.id = id
        self.name = name
        self.isEnabled = isEnabled
    }
    
    init(server: PredefinedDnsServer, isEnabled: Bool) {
        self.features = server.features
        self.upstreams = server.upstreams
        self.providerId = server.providerId
        self.id = server.id
        self.name = server.name
        self.isEnabled = isEnabled
    }
}

// MARK: - CUSTOM -

// MARK: - Custom DNS provider

public protocol CustomDnsProviderProtocol: DnsProviderMetaProtocol {
    var server: CustomDnsServer { get } // DNS server user created
}

public struct CustomDnsProvider: CustomDnsProviderProtocol, Codable, Equatable {
    public var name: String
    public var server: CustomDnsServer
    public let providerId: Int
    public var isEnabled: Bool
    
    init(name: String, server: CustomDnsServer, providerId: Int, isEnabled: Bool) {
        self.name = name
        self.server = server
        self.providerId = providerId
        self.isEnabled = isEnabled
    }
}

// MARK: - CustomDnsServer

public struct CustomDnsServer: DnsServerMetaProtocol, Codable, Equatable {
    public var upstreams: [DnsUpstream]
    public let providerId: Int
    public let type: DnsProtocol
    public let id: Int
    public var isEnabled: Bool
    
    init(upstreams: [DnsUpstream], providerId: Int, type: DnsProtocol, id: Int, isEnabled: Bool) {
        self.upstreams = upstreams
        self.providerId = providerId
        self.type = type
        self.id = id
        self.isEnabled = isEnabled
    }
}

