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
import NetworkExtension

enum NativeDnsProviderError: Error {
    case unsupportedDnsProtocol
    case failedToLoadManager
    case unsupportedProtocolsConfiguration
    case invalidUpstreamsNumber
}

protocol NativeProvidersServiceDelegate {
    func dnsManagerStatusChanged()
}

protocol NativeProvidersServiceProtocol {
    var providers: [DnsProviderInfo] { get }
    
    @available(iOS 14.0, *)
    func setServerAsCurrent(_ server: DnsServerInfo, name: String?, _ onErrorReceived: @escaping (_ error: Error?) -> ())
    
    /* Resets all providers and reinitialize them */
    func reset()
}


class NativeProvidersService: NativeProvidersServiceProtocol {
    
    // MARK: - Public properties
    lazy var providers: [DnsProviderInfo] = { initializeProviders() }()
    
    // MARK: - Private properties
    private var dnsManagerStatusObserver: NotificationToken?
    
    /* DNS protocols supported by native implementation */
    private var supportedProtocols = [DnsProtocol.doh, .dot, .dns]
    
    // MARK: - Services
    private let dnsProvidersService: DnsProvidersServiceProtocol
    private let networkSettingsService: NetworkSettingsServiceProtocol
    
    // MARK: - Initializer
    required init (dnsProvidersService: DnsProvidersServiceProtocol, networkSettingsService: NetworkSettingsServiceProtocol) {
        self.dnsProvidersService = dnsProvidersService
        self.networkSettingsService = networkSettingsService
        
        if #available(iOS 14.0, *) {
            addStatusObserver()
        }
    }
    
    // MARK: - Public methods
    
    @available(iOS 14.0, *)
    func setServerAsCurrent(_ server: DnsServerInfo, name: String?, _ onErrorReceived: @escaping (_ error: Error?) -> ()) {
        let dnsProtocols = server.upstreams.map { DnsProtocol.getProtocolByUpstream($0) }
        guard dnsProtocols.allElementsAreEqual() else {
            onErrorReceived(NativeDnsProviderError.unsupportedProtocolsConfiguration)
            return
        }
        let dnsProtocol = dnsProtocols.first!
        
        guard supportedProtocols.contains(dnsProtocol) else {
            DDLogError("NativeProvidersService(setProvider) trying to add server with unsupported protocol")
            onErrorReceived(NativeDnsProviderError.unsupportedDnsProtocol)
            return
        }
        loadDnsManager { [weak self] dnsManager in
            guard let manager = dnsManager else {
                DDLogError("Received nil DNS manager")
                onErrorReceived(NativeDnsProviderError.failedToLoadManager)
                return
            }
            self?.saveDnsManager(dnsManager: manager, dnsProtocol: dnsProtocol, upstreams: server.upstreams, description: name, onErrorReceived)
        }
    }
    
    func reset() {
        providers = []
    }
    
    // MARK: - Private methods
    
    private func initializeProviders() -> [DnsProviderInfo] {
        let providers = dnsProvidersService.allProviders
        var nativerProviders: [DnsProviderInfo] = []
        for provider in providers {
            let supportedServers = getSupportedServers(provider.servers ?? [])
            let protocols = supportedServers.map { $0.dnsProtocol }
            let nativeProvider = DnsProviderInfo(name: provider.name, logo: provider.logo, logoDark: provider.logoDark, summary: provider.summary, protocols: protocols, features: provider.features, website: provider.website, servers: supportedServers)
            nativerProviders.append(nativeProvider)
        }
        return nativerProviders
    }
    
    /*
     Returns only DoT and DoH servers
     Other DNS protocols are not supported by NEDnsSettings yet
     */
    private func getSupportedServers(_ servers: [DnsServerInfo]) -> [DnsServerInfo] {
        return servers.compactMap { server -> DnsServerInfo? in
            guard supportedProtocols.contains(server.dnsProtocol) else {
                return nil
            }
            return server
        }
    }
    
    // MARK: - Methods for DNS manager
    
    @available(iOS 14.0, *)
    private func saveDnsManager(dnsManager: NEDNSSettingsManager, dnsProtocol: DnsProtocol, upstreams: [String], description: String?, _ onErrorReceived: @escaping (_ error: Error?) -> ()) {
        setupDnsManager(dnsManager: dnsManager)
        
        let settings: NEDNSSettings
        switch dnsProtocol {
        case .dns: settings = NEDNSSettings(servers: upstreams)
        case .doh:
            guard upstreams.count == 1, let serverUrl = upstreams.first else {
                onErrorReceived(NativeDnsProviderError.invalidUpstreamsNumber)
                return
            }
            let dohSettings = NEDNSOverHTTPSSettings(servers: [])
            dohSettings.serverURL = URL(string: serverUrl)
            settings = dohSettings
        case .dot:
            guard upstreams.count == 1, let serverUrl = upstreams.first else {
                onErrorReceived(NativeDnsProviderError.invalidUpstreamsNumber)
                return
            }
            let dotSettings = NEDNSOverTLSSettings(servers: [])
            dotSettings.serverName = serverUrl
            settings = dotSettings
        default:
            onErrorReceived(NativeDnsProviderError.unsupportedDnsProtocol)
            return
        }
        dnsManager.dnsSettings = settings
        
        if let description = description {
            dnsManager.localizedDescription = description
        }
        dnsManager.saveToPreferences(completionHandler: onErrorReceived)
    }
    
    @available(iOS 14.0, *)
    private func loadDnsManager(_ onManagerLoaded: @escaping (_ dnsManager: NEDNSSettingsManager?) -> Void) {
        let dnsManager = NEDNSSettingsManager.shared()
        dnsManager.loadFromPreferences { error in
            if let error = error {
                DDLogError("Error loading DNS manager: \(error)")
                onManagerLoaded(nil)
                return
            }
            onManagerLoaded(dnsManager)
        }
    }
    
    @available(iOS 14.0, *)
    private func getDnsManagerStatus(_ onStatusReceived: @escaping (_ isInstalled: Bool, _ isEnabled: Bool) -> Void) {
        loadDnsManager { dnsManager in
            guard let manager = dnsManager else {
                DDLogError("Received nil DNS manager")
                onStatusReceived(false, false)
                return
            }
            onStatusReceived(manager.dnsSettings != nil, manager.isEnabled)
        }
    }
    
    @available(iOS 14.0, *)
    private func setupDnsManager(dnsManager: NEDNSSettingsManager) {
        
        var ondemandRules = [NEOnDemandRule]()
        
        let SSIDs = networkSettingsService.enabledExceptions.map{ $0.rule }
        if SSIDs.count > 0 {
            let disconnectRule = NEOnDemandRuleDisconnect()
            disconnectRule.ssidMatch = SSIDs
            ondemandRules.append(disconnectRule)
        }
        
        let wifiEnabled = networkSettingsService.filterWifiDataEnabled
        let mobileEnabled = networkSettingsService.filterMobileDataEnabled
        
        let disconnectRule = NEOnDemandRuleDisconnect()
        
        switch (wifiEnabled, mobileEnabled) {
        case (false, false):
            disconnectRule.interfaceTypeMatch = .any
            ondemandRules.append(disconnectRule)
        case (false, _):
            disconnectRule.interfaceTypeMatch = .wiFi
            ondemandRules.append(disconnectRule)
        case (_, false):
            disconnectRule.interfaceTypeMatch = .cellular
            ondemandRules.append(disconnectRule)
        default:
            break
        }
        
        let connectRule = NEOnDemandRuleConnect()
        connectRule.interfaceTypeMatch = .any
        
        ondemandRules.append(connectRule)
        
        dnsManager.onDemandRules = ondemandRules
    }
}

// MARK: - NativeProvidersService + Status observer

extension NativeProvidersService {
    
    @available(iOS 14.0, *)
    private func addStatusObserver() {
        dnsManagerStatusObserver = NotificationCenter.default.observe(name: .NEDNSSettingsConfigurationDidChange, object: nil, queue: nil, using: { [weak self] notification in
            guard let self = self else { return }
            
        })
    }
}
