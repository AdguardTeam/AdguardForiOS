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

import UIKit.UIImage
import SQLite

// MARK: - DnsProviders
struct PredefinedDnsProviders: Decodable, Equatable {
    let features: [DnsFeature]
    let providers: [PredefinedDnsProvider]
    
    enum CodingKeys: String, CodingKey {
        case features
        case providers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.features = try container.decode([DnsFeature].self, forKey: .features)
        
        var decodedProviders: [PredefinedDnsProvider] = []
        let providersDecoder = try container.superDecoder(forKey: .providers)
        var providersContainer = try providersDecoder.unkeyedContainer()
        while !providersContainer.isAtEnd {
            let providerDecoder = try providersContainer.superDecoder()
            let provider = try PredefinedDnsProvider(from: providerDecoder, allDnsFeatures: self.features)
            decodedProviders.append(provider)
        }
        self.providers = decodedProviders
    }
}

// MARK: - PredefinedDnsProvider
struct PredefinedDnsProvider: Decodable, Equatable {
    static let systemDefaultProviderId = 10000
    static let adguardDnsProviderId = 10001
    
    let name: String
    let providerDescription: String
    let servers: [PredefinedDnsServer]
    let providerId: Int
    let logo: UIImage?
    let homepage: String

    enum CodingKeys: String, CodingKey {
        case name
        case servers
        case providerId
        case logo
        case homepage
        case providerDescription = "description"
    }
    
    init(name: String, providerDescription: String, servers: [PredefinedDnsServer], providerId: Int, logo: UIImage?, homepage: String) {
        self.name = name
        self.providerDescription = providerDescription
        self.servers = servers
        self.providerId = providerId
        self.logo = logo
        self.homepage = homepage
    }
    
    init(from decoder: Decoder, allDnsFeatures: [DnsFeature]) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var decodedServers: [PredefinedDnsServer] = []
        let serversDecoder = try container.superDecoder(forKey: .servers)
        var serversContainer = try serversDecoder.unkeyedContainer()
        while !serversContainer.isAtEnd {
            let serverDecoder = try serversContainer.superDecoder()
            let server = try PredefinedDnsServer(from: serverDecoder, allDnsFeatures: allDnsFeatures)
            decodedServers.append(server)
        }
        self.servers = decodedServers
        
        self.name = try container.decode(String.self, forKey: .name)
        self.providerId = try container.decode(Int.self, forKey: .providerId)
        let logoImageName = try container.decode(String.self, forKey: .logo)
        self.logo = UIImage(named: logoImageName, in: Bundle.current, compatibleWith: nil)
        self.homepage = try container.decode(String.self, forKey: .homepage)
        self.providerDescription = try container.decode(String.self, forKey: .providerDescription)
    }
    
    init(from decoder: Decoder) throws {
        try self.init(from: decoder, allDnsFeatures: [])
    }
}

// MARK: - DnsFeature
public struct DnsFeature: Decodable, Equatable {
    let logo: UIImage
    let type: DnsFeatureType
    let name: String
    let featureDescription: String
    
    enum CodingKeys: String, CodingKey {
        case logo
        case type
        case name
        case featureDescription = "description"
    }
    
    public init(logo: UIImage, type: DnsFeatureType, name: String, featureDescription: String) {
        self.logo = logo
        self.type = type
        self.name = name
        self.featureDescription = featureDescription
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let logoImageName = try container.decode(String.self, forKey: .logo)
        self.logo = UIImage(named: logoImageName, in: Bundle.current, compatibleWith: nil)!
        self.type = try container.decode(DnsFeatureType.self, forKey: .type)
        self.name = try container.decode(String.self, forKey: .name)
        self.featureDescription = try container.decode(String.self, forKey: .featureDescription)
    }
}

// MARK: - DnsFeatureType
public enum DnsFeatureType: String, Codable, Equatable {
    case adBlocking = "ad_blocking"
    case adultContentBlocking = "adult_content_blocking"
    case encryption = "encryption"
    case noLogs = "no_logs"
    case safeSearch = "safe_search"
    case secure = "secure"
}

// MARK: - PredefinedDnsServer
struct PredefinedDnsServer: Decodable, Equatable {
    static let systemDefaultServerId = 0
    static let adguardDohServerId = 3
    
    public let features: [DnsFeature]
    public let upstreams: [DnsUpstream]
    public let providerId: Int
    public let id: Int
    public let name: String
    public let type: DnsProtocol
    
    init(features: [DnsFeature], upstreams: [DnsUpstream], providerId: Int, type: DnsProtocol, id: Int, name: String) {
        self.features = features
        self.upstreams = upstreams
        self.providerId = providerId
        self.id = id
        self.name = name
        self.type = upstreams.first?.`protocol` ?? .dns
    }
    
    init(from decoder: Decoder, allDnsFeatures: [DnsFeature]) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dnsFeaturesTypes = try container.decode([DnsFeatureType].self, forKey: .features)
        self.features = allDnsFeatures.filter { dnsFeaturesTypes.contains($0.type) }
        self.providerId = try container.decode(Int.self, forKey: .providerId)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        
        let upstrs = try container.decode([String].self, forKey: .upstreams)
        let type = try container.decode(DnsProtocol.self, forKey: .type)
        self.type = type
        self.upstreams = upstrs.map { DnsUpstream(upstream: $0, protocol: type) }
    }
}

// MARK: - DnsProtocol
public enum DnsProtocol: String, Codable, CaseIterable, Equatable {
    // IMPORTANT - DnsLogStatistics depends on raw value
    // Migrate data if changes
    case dns = "dns"
    case dnscrypt = "dnscrypt"
    case doh = "doh"
    case dot = "dot"
    case doq = "doq"
    
    var isCrypto: Bool {
        switch self {
        case .dns: return false
        default: return true
        }
    }
}

// MARK: - DnsUpstream

public struct DnsUpstream: Equatable, Codable {
    public let upstream: String // DNS upstream
    public let `protocol`: DnsProtocol // DNS upstream protocol e.g. DoH, DoT, QUIC
    
    init(upstream: String, protocol: DnsProtocol) {
        self.upstream = upstream
        self.protocol = `protocol`
    }
}

// MARK: - Bundle + current
// It's a hack to get current bundle for structs
fileprivate extension Bundle {
    static var current: Bundle {
        class __ { }
        return Bundle(for: __.self)
    }
}
