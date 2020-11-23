import Foundation

// MARK: - DnsProviders
struct DnsProviders: Codable, Equatable {
    let providers: [DnsProvider]
    let features: [DnsFeature]
}

// MARK: - DnsFeature
struct DnsFeature: Codable, Equatable, Hashable {
    let logo: String
    let type: String
    let name: String
    let featureDescription: String

    enum CodingKeys: String, CodingKey {
        case logo
        case type
        case name
        case featureDescription = "description"
    }
}

// MARK: - DnsProvider
struct DnsProvider: Codable, Equatable {
    let name: String
    let servers: [DnsServer]
    let providerId: Int
    let logo: String
    let homepage: String
    let providerDescription: String

    enum CodingKeys: String, CodingKey {
        case name, servers
        case providerId = "providerId"
        case logo, homepage
        case providerDescription = "description"
    }
}

// MARK: - DnsServer
struct DnsServer: Codable, Equatable {
    let features: [String]
    let upstreams: [String]
    let providerId: Int
    let type: DnsType
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case features
        case upstreams
        case providerId = "providerId"
        case type
        case id
        case name
    }
}

enum DnsType: String, Codable {
    case dns = "dns"
    case dnscrypt = "dnscrypt"
    case doh = "doh"
    case dot = "dot"
    case doq = "doq"
}
