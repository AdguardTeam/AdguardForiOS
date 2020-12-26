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

protocol NativeProvidersServiceDelegate: class {
    func dnsManagerStatusChanged()
}

protocol NativeProvidersServiceProtocol: class {
    var delegate: NativeProvidersServiceDelegate? { get set }
    
    var managerIsEnabled: Bool { get }
    
    var currentServer: DnsServerInfo? { get }
    var serverName: String { get }
    var currentProvider: DnsProviderInfo? { get }
    var providers: [DnsProviderInfo] { get }
    
    @available(iOS 14.0, *)
    func saveDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void)
    
    @available(iOS 14.0, *)
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void)
    
    /* Reinitializes all providers */
    func reinitializeProviders()
    
    /* Called when resetting settings */
    @available(iOS 14.0, *)
    func reset()
}

class NativeProvidersService: NativeProvidersServiceProtocol {
    
    /* DNS protocols supported by native implementation */
    static let supportedProtocols = [DnsProtocol.doh, .dot, .dns]
    
    // MARK: - Public properties
    weak var delegate: NativeProvidersServiceDelegate?
    
    var managerIsEnabled: Bool = false {
        didSet {
            if managerIsEnabled != oldValue {
                delegate?.dnsManagerStatusChanged()
            }
        }
    }
    
    var currentServer: DnsServerInfo? {
        if let server = dnsProvidersService.activeDnsServer {
            if NativeProvidersService.supportedProtocols.contains(server.dnsProtocol) {
                return server
            }
        }
        return adguardDnsServer
    }
    
    var serverName: String {
        guard let server = currentServer else {
            return ""
        }
        
        if dnsProvidersService.isCustomServer(server) {
            return currentProvider?.name ?? server.name
        }
        
        let protocolName = String.localizedString(DnsProtocol.stringIdByProtocol[server.dnsProtocol]!)
        return "\(currentProvider?.name ?? server.name) (\(protocolName))"
    }
    
    var currentProvider: DnsProviderInfo? {
        providers.first(where: { $0.providerId == currentServer?.providerId })
    }
    
    var providers: [DnsProviderInfo] = []
    
    // MARK: - Private properties
    
    // Use it as default if selected is not supported
    private lazy var adguardDnsServer: DnsServerInfo? = {
        let adguardDnsProviderId = 10001
        let adguardProvider = providers.first(where: { $0.providerId == adguardDnsProviderId })
        let dnsServer = adguardProvider?.servers?.first(where: { $0.dnsProtocol == .doh })
        return dnsServer
    }()
    
    // Observers
    private var dnsManagerStatusObserver: NotificationToken?
    private var appWillEnterForeground: NotificationToken?
    private var dnsImplementationObserver: NotificationToken?
    private var proObservation: NSKeyValueObservation?
    
    // MARK: - Services
    private let dnsProvidersService: DnsProvidersServiceProtocol
    private let networkSettingsService: NetworkSettingsServiceProtocol
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationServiceProtocol
    
    // MARK: - Initializer
    required init (dnsProvidersService: DnsProvidersServiceProtocol, networkSettingsService: NetworkSettingsServiceProtocol, resources: AESharedResourcesProtocol, configuration: ConfigurationServiceProtocol) {
        self.dnsProvidersService = dnsProvidersService
        self.networkSettingsService = networkSettingsService
        self.resources = resources
        self.configuration = configuration
        self.providers = initializeProviders()
        
        if #available(iOS 14.0, *) {
            addObservers()
            
            getDnsManagerStatus({ [weak self] isInstalled, isEnabled in
                self?.managerIsEnabled = isInstalled && isEnabled
            })
        }
    }
    
    // MARK: - Public methods
    
    @available(iOS 14.0, *)
    func saveDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        guard let server = currentServer else {
            onErrorReceived(NativeDnsProviderError.failedToLoadManager)
            return
        }

        guard let upstream = server.upstreams.first else {
            onErrorReceived(NativeDnsProviderError.unsupportedDnsProtocol)
            return
        }
        
        let dnsProtocol = DnsProtocol.getProtocolByUpstream(upstream)
        
        guard NativeProvidersService.supportedProtocols.contains(dnsProtocol) else {
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
            self?.saveDnsManager(dnsManager: manager, dnsProtocol: dnsProtocol, upstreams: server.upstreams, onErrorReceived)
        }
    }
    
    @available(iOS 14.0, *)
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        loadDnsManager { [weak self] dnsManager in
            guard let dnsManager = dnsManager else {
                DDLogError("Received nil DNS manager")
                onErrorReceived(NativeDnsProviderError.failedToLoadManager)
                return
            }
            dnsManager.removeFromPreferences(completionHandler: onErrorReceived)
            // Check manager status after delete
            self?.getDnsManagerStatus({ [weak self] isInstalled, isEnabled in
                self?.managerIsEnabled = isInstalled && isEnabled
            })
        }
    }
    
    func reinitializeProviders() {
        providers = initializeProviders()
    }
    
    @available(iOS 14.0, *)
    func reset() {
        removeDnsManager { [weak self] error in
            if let error = error {
                DDLogError("Error when resetting settings; Error: \(error.localizedDescription)")
            }
            self?.reinitializeProviders()
        }
    }
    
    // MARK: - Private methods
    
    private func initializeProviders() -> [DnsProviderInfo] {
        let providers = dnsProvidersService.allProviders
        var nativerProviders: [DnsProviderInfo] = []
        for provider in providers {
            let supportedServers = getSupportedServers(provider.servers ?? [])
            
            guard supportedServers.count > 0 else {
                continue
            }
            
            let protocols = supportedServers.map { $0.dnsProtocol }
            let nativeProvider = DnsProviderInfo(name: provider.name, logo: provider.logo, logoDark: provider.logoDark, summary: provider.summary, protocols: protocols, features: provider.features, website: provider.website, servers: supportedServers, providerId: provider.providerId)
            nativerProviders.append(nativeProvider)
        }
        return nativerProviders
    }
    
    /*
     Returns only DoT, DoH and Regular servers
     Other DNS protocols are not supported by NEDnsSettings yet
     */
    private func getSupportedServers(_ servers: [DnsServerInfo]) -> [DnsServerInfo] {
        return servers.compactMap { server -> DnsServerInfo? in
            guard NativeProvidersService.supportedProtocols.contains(server.dnsProtocol) else {
                return nil
            }
            return server
        }
    }
    
    // MARK: - Methods for DNS manager
    
    @available(iOS 14.0, *)
    private func saveDnsManager(dnsManager: NEDNSSettingsManager, dnsProtocol: DnsProtocol, upstreams: [String], _ onErrorReceived: @escaping (_ error: Error?) -> ()) {
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
        
        dnsManager.localizedDescription = Bundle.main.applicationName ?? "AdGuard"
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
        let onDemandRuled = networkSettingsService.onDemandRules
        dnsManager.onDemandRules = onDemandRuled
    }
}

// MARK: - NativeProvidersService + Status observer

extension NativeProvidersService {
    
    @available(iOS 14.0, *)
    private func addObservers() {
        dnsManagerStatusObserver = NotificationCenter.default.observe(name: .NEDNSSettingsConfigurationDidChange, object: nil, queue: nil, using: { [weak self] notification in
            if let dnsManager = notification.object as? NEDNSSettingsManager {
                self?.managerIsEnabled = dnsManager.isEnabled
            }
        })
        
        appWillEnterForeground = NotificationCenter.default.observe(name: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using: {[weak self] notification in
            self?.getDnsManagerStatus({ [weak self] isInstalled, isEnabled in
                self?.managerIsEnabled = isInstalled && isEnabled
            })
        })
        
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: nil) { [weak self] _ in
            if self?.resources.dnsImplementation == .native {
                self?.saveDnsManager({ _ in })
            } else {
                self?.removeDnsManager({ _ in })
            }
        }
        
        if let config = configuration as? ConfigurationService {
            proObservation = config.observe(\.proStatus) {[weak self] (_, _) in
                guard let self = self else { return }
                if !self.configuration.proStatus {
                    self.removeDnsManager({ _ in })
                } else if self.resources.dnsImplementation == .native && self.configuration.proStatus {
                    self.saveDnsManager({ _ in })
                }
            }
        }
    }
}

// MARK: - NativeProvidersService + DnsProvidersServiceDelegate

extension NativeProvidersService: DnsProvidersServiceDelegate {
    func dnsProvidersChanged() {
        reinitializeProviders()
        NotificationCenter.default.post(name: .currentDnsServerChanged, object: nil)
    }
}
