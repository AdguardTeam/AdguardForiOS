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

protocol CustomDnsProvidersStorageProtocol: ResetableSyncProtocol {
    /* Returns saved custom DNS providers objects */
    var providers: [CustomDnsProviderProtocol] { get }
    
    /**
     Adds new custom provider to storage
     - Parameter name: Name of provider to add
     - Parameter upstreams: List of provider upstreams
     - Throws: Throws an error if upstreams are invalid or have different protocols
     - Returns: Provider and server id of newly created object
     */
    func addCustomProvider(name: String, upstreams: [String]) throws -> (providerId: Int, serverId: Int)
    
    /**
     Updates custom provider in the storage
     - Parameter id: Unique identifier of custom DNS provider that should be updated
     - Parameter newName: New name of provider to update
     - Parameter newUpstreams: New upstreams of provider to update
     - Throws: Throws an error if custom provider with the specified **id** is not in the storage
     */
    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String]) throws
    
    /**
     Removes custom provider by its **id** from storage
     - Parameter id: Unique identifier of custom DNS provider that should be removed from the storage
     - Throws: Throws an error if custom provider with passed **id** is not in the storage
     */
    func removeCustomProvider(withId id: Int) throws
}

/**
 This object stores Custom DNS providers
 Also it is responsible for adding new providers and removing existing ones
 */
final class CustomDnsProvidersStorage: CustomDnsProvidersStorageProtocol {
    
    // MARK: - CustomDnsProvidersStorageError
    
    enum CustomDnsProvidersStorageError: Error, CustomDebugStringConvertible {
        case providerAbsent(providerId: Int)
        case invalidUpstream(upstream: String)
        case differentDnsProtocols(upstreams: [String])
        case emptyUpstreams
        
        var debugDescription: String {
            switch self {
            case .providerAbsent(let providerId): return "Custom provider with id=\(providerId) is absent"
            case .invalidUpstream(let upstream): return "Invalid upstream=\(upstream)"
            case .differentDnsProtocols(let upstreams): return "Upstreams with different protocols are forbidden; Upstreams: \(upstreams.joined(separator: "; "))"
            case .emptyUpstreams: return "Upstreams list is empty"
            }
        }
    }
    
    // MARK: - Internal variables
    
    var providers: [CustomDnsProviderProtocol] { userDefaults.customProviders }
    
    // MARK: - Private variables
    
    private let customProviderBaseId = 0
    private let customServerBaseId = 100000
    
    private var nextCustomIds: (providerId: Int, serverId: Int) {
        let providers = userDefaults.customProviders
        var maxProviderId = customProviderBaseId
        var maxServerId = customServerBaseId
        providers.forEach {
            if $0.providerId > maxProviderId {
                maxProviderId = $0.providerId
            }
            if $0.server.id > maxServerId {
                maxServerId = $0.server.id
            }
        }
        return (maxProviderId + 1, maxServerId + 1)
    }
    
    /* Services */
    private let userDefaults: UserDefaultsStorageProtocol
    private let networkUtils: NetworkUtilsProtocol
    
    // MARK: - Initialization
    
    init(userDefaults: UserDefaultsStorageProtocol, networkUtils: NetworkUtilsProtocol = NetworkUtils()) {
        self.userDefaults = userDefaults
        self.networkUtils = networkUtils
    }
    
    // MARK: - Internal methods

    func addCustomProvider(name: String, upstreams: [String]) throws -> (providerId: Int, serverId: Int) {
        let dnsProtocol = try checkProviderInfo(name: name, upstreams: upstreams)
        let dnsUpstreams = upstreams.map { DnsUpstream(upstream: $0, protocol: dnsProtocol) }
        
        let ids = nextCustomIds
        let customServer = CustomDnsServer(upstreams: dnsUpstreams, providerId: ids.providerId, type: dnsProtocol, id: ids.serverId, isEnabled: false)
        let customProvider = CustomDnsProvider(name: name, server: customServer, providerId: ids.providerId, isEnabled: false)
        userDefaults.customProviders.append(customProvider)
        return (ids.providerId, ids.serverId)
    }
    
    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String]) throws {
        // Make sure that provider exists
        guard let providerIndex = userDefaults.customProviders.firstIndex(where: { $0.providerId == id }) else {
            throw CustomDnsProvidersStorageError.providerAbsent(providerId: id)
        }
        
        let oldProvider = userDefaults.customProviders[providerIndex]
        let newDnsProtocol = try checkProviderInfo(name: newName, upstreams: newUpstreams)
        let newDnsUpstreams = newUpstreams.map { DnsUpstream(upstream: $0, protocol: newDnsProtocol) }
        
        let customServer = CustomDnsServer(upstreams: newDnsUpstreams,
                                           providerId: oldProvider.providerId,
                                           type: newDnsProtocol,
                                           id: oldProvider.server.id,
                                           isEnabled: false)
        let customProvider = CustomDnsProvider(name: newName, server: customServer, providerId: oldProvider.providerId, isEnabled: false)
        userDefaults.customProviders[providerIndex] = customProvider
    }
    
    func removeCustomProvider(withId id: Int) throws {
        // Make sure that provider exists
        guard let providerIndex = userDefaults.customProviders.firstIndex(where: { $0.providerId == id }) else {
            throw CustomDnsProvidersStorageError.providerAbsent(providerId: id)
        }
        
        // Remove provider if exists
        userDefaults.customProviders.remove(at: providerIndex)
    }
    
    func reset() throws {
        userDefaults.customProviders = []
    }
    
    // MARK: - Private methods
    
    private func checkProviderInfo(name: String, upstreams: [String]) throws -> DnsProtocol {
        guard !upstreams.isEmpty else {
            throw CustomDnsProvidersStorageError.emptyUpstreams
        }
        
        let protocols = try upstreams.map { try networkUtils.getProtocol(from: $0) }
        guard protocols.allElementsAreEqual else {
            throw CustomDnsProvidersStorageError.differentDnsProtocols(upstreams: upstreams)
        }
        
        try upstreams.forEach {
            let isValid = networkUtils.upstreamIsValid($0)
            if !isValid {
                throw CustomDnsProvidersStorageError.invalidUpstream(upstream: $0)
            }
        }
        return protocols.first!
    }
    
}

// MARK: - UserDefaultsStorageProtocol + customProviders

fileprivate extension UserDefaultsStorageProtocol {
    private var customProvidersKey: String { "DnsAdGuardSDK.customProvidersKey" }
    
    var customProviders: [CustomDnsProvider] {
        get {
            if let providersData = storage.data(forKey: customProvidersKey) {
                let decoder = JSONDecoder()
                let providers = try? decoder.decode([CustomDnsProvider].self, from: providersData)
                return providers ?? []
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let providersData = try? encoder.encode(newValue) {
                storage.set(providersData, forKey: customProvidersKey)
                return
            }
            storage.set([], forKey: customProvidersKey)
        }
    }
}
