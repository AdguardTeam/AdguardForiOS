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

protocol DnsProvidersManagerProtocol: ResetableSyncProtocol {
    /* Providers */
    var allProviders: [DnsProviderMetaProtocol] { get }
    var predefinedProviders: [DnsProviderProtocol] { get }
    var customProviders: [CustomDnsProviderProtocol] { get }
    
    /* Active */
    var activeDnsProvider: DnsProviderMetaProtocol { get }
    var activeDnsServer: DnsServerMetaProtocol { get }
    
    /**
     This method should be called when implementation changes
     All inner objects will be reconstructed according to implementation
     */
    func dnsImplementationChanged()

    /**
     Makes provider with **id** active
     
     All predefined providers can have multiple DNS servers so to reveal the server to make active
     we need **provider id** to find a provider and **server id** to find a server
     - Parameter id: Unique provider identifier
     - Parameter type: Unique identifier of server to select
     - Throws: throws error if provider or server id is invalid
     */
    func selectProvider(withId id: Int, serverId: Int) throws

    /**
     Adds new custom provider to storage
     - Parameter name: Name of provider to add
     - Parameter upstreams: List of provider upstreams
     - Parameter selectAsCurrent: If true than provider will be set as active
     - Throws: Throws an error if upstreams are invalid or have different protocols
     */
    func addCustomProvider(name: String, upstreams: [String], selectAsCurrent: Bool) throws
    
    /**
     Updates custom provider in the storage
     - Parameter id: Unique identifier of custom DNS provider that should be updated
     - Parameter newName: New name of provider to update
     - Parameter newUpstreams: New upstreams of provider to update
     - Parameter selectAsCurrent: If true than provider will be set as active
     - Throws: Throws an error if custom provider with the specified **id** is not in the storage
     */
    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool) throws
    
    /**
     Removes custom provider by its **id** from storage
     
     If current provider is removed than the default one or AdGuard DoH will be set depending on the
     current DNS implementation
     
     - Parameter id: Unique identifier of custom DNS provider that should be removed from the storage
     - Throws: Throws an error if custom provider with passed **id** is not in the storage
     */
    func removeCustomProvider(withId id: Int) throws
}

final class DnsProvidersManager: DnsProvidersManagerProtocol {
    
    // MARK: - Internal variables
    
    var allProviders: [DnsProviderMetaProtocol] { predefinedProviders + customProviders }
    var predefinedProviders: [DnsProviderProtocol]
    var customProviders: [CustomDnsProviderProtocol]
    
    var activeDnsProvider: DnsProviderMetaProtocol
    var activeDnsServer: DnsServerMetaProtocol
    
    // MARK: - Private variables
    
    /* Services */
    private let configuration: DnsConfigurationProtocol
    private let userDefaults: UserDefaultsStorageProtocol
    private let customProvidersStorage: CustomDnsProvidersStorageProtocol
    private let providersVendor: DnsProvidersVendorProtocol
    
    // MARK: - Initialization
    
    init(configuration: DnsConfigurationProtocol,
         userDefaults: UserDefaultsStorageProtocol,
         customProvidersStorage: CustomDnsProvidersStorageProtocol,
         predefinedProviders: PredefinedDnsProvidersDecoderProtocol) {
        
        self.configuration = configuration
        self.userDefaults = userDefaults
        self.customProvidersStorage = customProvidersStorage
        self.providersVendor = DnsProvidersVendor(predefinedProviders: predefinedProviders, customProvidersStorage: self.customProvidersStorage)
        
        let providersWithState = providersVendor.getProvidersWithState(for: configuration.dnsImplementation,
                                                                       activeDns: userDefaults.activeDnsInfo)
        
        self.predefinedProviders = providersWithState.predefined
        self.customProviders = providersWithState.custom
        self.activeDnsProvider = providersWithState.activeDnsProvider
        self.activeDnsServer = providersWithState.activeDnsServer
    }
    
    // MARK: - Public methods
    
    func dnsImplementationChanged() {
        Logger.logInfo("(DnsProvidersManager) - dnsImplementationChanged; Changed to \(configuration.dnsImplementation)")
        reinitializeProviders()
    }
    
    func selectProvider(withId id: Int, serverId: Int) throws {
        Logger.logInfo("(DnsProvidersManager) - selectProvider; Selecting provider with id=\(id) serverId=\(serverId)")
        
        guard let provider = allProviders.first(where: { $0.providerId == id }) else {
            throw DnsProviderError.invalidProvider(providerId: id)
        }
    
        guard provider.dnsServers.contains(where: { $0.id == serverId }) else {
            throw DnsProviderError.invalidCombination(providerId: id, serverId: serverId)
        }
        
        let newActiveDnsInfo = DnsProvidersManager.ActiveDnsInfo(providerId: id, serverId: serverId)
        userDefaults.activeDnsInfo = newActiveDnsInfo
        makeProviderActive(newActiveDnsInfo)
        
        Logger.logInfo("(DnsProvidersManager) - selectProvider; Selected provider with id=\(id) serverId=\(serverId)")
    }
    
    func addCustomProvider(name: String, upstreams: [String], selectAsCurrent: Bool) throws {
        Logger.logInfo("(DnsProvidersManager) - addCustomProvider; Trying to add custom provider with name=\(name), upstreams=\(upstreams.joined(separator: "; ")) selectAsCurrent=\(selectAsCurrent)")
        
        let ids = try customProvidersStorage.addCustomProvider(name: name, upstreams: upstreams)
        if selectAsCurrent {
            userDefaults.activeDnsInfo = DnsProvidersManager.ActiveDnsInfo(providerId: ids.providerId, serverId: ids.serverId)
        }
        reinitializeProviders()
        
        Logger.logInfo("(DnsProvidersManager) - addCustomProvider; Added custom provider with name=\(name), upstreams=\(upstreams.joined(separator: "; ")) selectAsCurrent=\(selectAsCurrent)")
    }
    
    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool) throws {
        Logger.logInfo("(DnsProvidersManager) - updateCustomProvider; Trying to update custom provider with id=\(id) name=\(newName), upstreams=\(newUpstreams.joined(separator: "; ")) selectAsCurrent=\(selectAsCurrent)")
        
        try customProvidersStorage.updateCustomProvider(withId: id, newName: newName, newUpstreams: newUpstreams)
        if selectAsCurrent, let provider = customProviders.first(where: { $0.providerId == id }) {
            userDefaults.activeDnsInfo = DnsProvidersManager.ActiveDnsInfo(providerId: provider.providerId, serverId: provider.server.id)
        }
        reinitializeProviders()
        
        Logger.logInfo("(DnsProvidersManager) - updateCustomProvider; Updated custom provider with id=\(id) name=\(newName), upstreams=\(newUpstreams.joined(separator: "; ")) selectAsCurrent=\(selectAsCurrent)")
    }
    
    func removeCustomProvider(withId id: Int) throws {
        Logger.logInfo("(DnsProvidersManager) - removeCustomProvider; Trying to remove provider with id=\(id)")
        
        try customProvidersStorage.removeCustomProvider(withId: id)
        
        let activeProviderId = userDefaults.activeDnsInfo.providerId
        if id == activeProviderId {
            let defaultProviderId = PredefinedDnsProvider.systemDefaultProviderId
            let defaultServerId = PredefinedDnsServer.systemDefaultServerId
            userDefaults.activeDnsInfo = DnsProvidersManager.ActiveDnsInfo(providerId: defaultProviderId, serverId: defaultServerId)
        }
        reinitializeProviders()
        
        Logger.logInfo("(DnsProvidersManager) - removeCustomProvider; Removed provider with id=\(id)")
    }
    
    func reset() throws {
        Logger.logInfo("(DnsProvidersManager) - reset; Start")
        
        let defaultProviderId = PredefinedDnsProvider.systemDefaultProviderId
        let defaultServerId = PredefinedDnsServer.systemDefaultServerId
        userDefaults.activeDnsInfo = DnsProvidersManager.ActiveDnsInfo(providerId: defaultProviderId, serverId: defaultServerId)
        
        try! customProvidersStorage.reset()
        reinitializeProviders()
        
        Logger.logInfo("(DnsProvidersManager) - reset; Finish")
    }
    
    // MARK: - Private methods
    
    private func makeProviderActive(_ activeDnsInfo: DnsProvidersManager.ActiveDnsInfo) {
        for i in 0..<predefinedProviders.count {
            let providerIsEnabled = predefinedProviders[i].providerId == activeDnsInfo.providerId
            predefinedProviders[i].isEnabled = providerIsEnabled
            
            var provider = predefinedProviders[i] as! DnsProvider
            provider.makeActiveServer(with: activeDnsInfo.serverId)
            predefinedProviders[i] = provider
        }
    }
    
    private func reinitializeProviders() {
        let providersWithState = providersVendor.getProvidersWithState(for: configuration.dnsImplementation,
                                                                       activeDns: userDefaults.activeDnsInfo)
        
        self.predefinedProviders = providersWithState.predefined
        self.customProviders = providersWithState.custom
        self.activeDnsProvider = providersWithState.activeDnsProvider
        self.activeDnsServer = providersWithState.activeDnsServer
    }
}

// MARK: - DnsProvidersManager + Helper objects

extension DnsProvidersManager {
    
    struct ActiveDnsInfo: Codable {
        let providerId: Int
        let serverId: Int
    }
    
    enum DnsProviderError: Error, CustomDebugStringConvertible {
        case invalidProvider(providerId: Int)
        case invalidCombination(providerId: Int, serverId: Int)
        case unsupportedProtocol(prot: DnsProtocol)
        
        var debugDescription: String {
            switch self {
            case .invalidProvider(let providerId): return "DNS provider with id=\(providerId) doesn't exist"
            case .invalidCombination(let providerId, let serverId): return "DNS provider with id=\(providerId) doesn't have server with id=\(serverId)"
            case .unsupportedProtocol(let prot): return "Native DNS implementation doesn't support \(prot.rawValue)"
            }
        }
    }
}

// MARK: - UserDefaultsStorageProtocol + DnsProvidersManager variables

fileprivate extension UserDefaultsStorageProtocol {
    private var activeDnsInfoKey: String { "DnsAdGuardSDK.activeDnsInfoKey" }
    
    var activeDnsInfo: DnsProvidersManager.ActiveDnsInfo {
        get {
            if let infoData = storage.value(forKey: activeDnsInfoKey) as? Data {
                let decoder = JSONDecoder()
                if let info = try? decoder.decode(DnsProvidersManager.ActiveDnsInfo.self, from: infoData) {
                    return info
                }
            }
            let defaultProviderId = PredefinedDnsProvider.systemDefaultProviderId
            let defaultServerId = PredefinedDnsServer.systemDefaultServerId
            return DnsProvidersManager.ActiveDnsInfo(providerId: defaultProviderId, serverId: defaultServerId)
        }
        set {
            let encoder = JSONEncoder()
            if let infoData = try? encoder.encode(newValue) {
                storage.setValue(infoData, forKey: activeDnsInfoKey)
                return
            }
            let defaultProviderId = PredefinedDnsProvider.systemDefaultProviderId
            let defaultServerId = PredefinedDnsServer.systemDefaultServerId
            let info = DnsProvidersManager.ActiveDnsInfo(providerId: defaultProviderId, serverId: defaultServerId)
            storage.setValue(info, forKey: activeDnsInfoKey)
        }
    }
}
