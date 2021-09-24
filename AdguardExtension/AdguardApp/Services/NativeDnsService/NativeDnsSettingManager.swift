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

import NetworkExtension
import DnsAdGuardSDK

@available(iOS 14.0, *)
protocol NativeDnsSettingManagerProtocol {
    /// State of saved dns manager
    var dnsManagerIsEnabled: Bool { get }
    
    /// Save dns manager with active provider into system preferences
    func saveDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void)
    /// Remove dns manager from system preferences
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void)
    /// Reset dns manager
    func reset()
}

/// Manager that control state of dns manager
@available(iOS 14.0, *)
final class NativeDnsSettingManager: NativeDnsSettingManagerProtocol {
    
    private struct ManagerStatus {
        let isInstalled: Bool
        let isEnabled: Bool
        
        init() {
            self.isInstalled = false
            self.isEnabled = false
        }
        
        init(manager: NEDNSSettingsManager) {
            self.isInstalled = manager.dnsSettings != nil
            self.isEnabled = manager.isEnabled
        }
    }
    
    //MARK: - Properties
    var dnsManagerIsEnabled: Bool = false
    
    private var dnsImplementationObserver: NotificationToken?
    private var dnsManagerStatusObserver: NotificationToken?
    private var appWillEnterForeground: NotificationToken?
    private var proObservation: NotificationToken?

    private let networkSettingsService: NetworkSettingsServiceProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let configuration: ConfigurationServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    //MARK: - Init
    init(networkSettingsService: NetworkSettingsServiceProtocol,
         dnsProvidersManager: DnsProvidersManagerProtocol,
         configuration: ConfigurationServiceProtocol,
         resources: AESharedResourcesProtocol) {
        
        self.networkSettingsService = networkSettingsService
        self.dnsProvidersManager = dnsProvidersManager
        self.configuration = configuration
        self.resources = resources
        addObservers()
        
        getDnsManagerStatus { [weak self] status in
            self?.dnsManagerIsEnabled = status.isInstalled && status.isEnabled
        }
    }
    
    //MARK: - Public methods
    func saveDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
       
        let server = dnsProvidersManager.activeDnsServer
        
        loadDnsManager { [weak self] dnsManager in
            guard let manager = dnsManager else {
                DDLogError("(NativeDnsSettingManager) - saveDnsManager; Received nil DNS manager")
                onErrorReceived(NativeDnsProviderError.failedToLoadManager)
                return
            }
            
            self?.saveDnsManagerInternal(dnsManager: manager, dnsProtocol: server.type, upstreams: server.upstreams, onErrorReceived)
        }
    }
    
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        loadDnsManager { [weak self] dnsManager in
            guard let dnsManager = dnsManager else {
                DDLogError("(NativeDnsSettingManager) - removeDnsManager; Received nil DNS manager")
                onErrorReceived(NativeDnsProviderError.failedToLoadManager)
                return
            }
            
            dnsManager.removeFromPreferences(completionHandler: onErrorReceived)
            // Check manager status after delete
            self?.getDnsManagerStatus({ [weak self] status in
                self?.dnsManagerIsEnabled = status.isInstalled && status.isEnabled
            })
        }
    }
    
    func reset() {
        removeDnsManager { error in
            if let error = error {
                DDLogError("(NativeDnsSettingManager) - reset; Error when resetting settings; Error: \(error)")
            }
        }
    }
    
    //MARK: - Private methods
    
    private func loadDnsManager(_ onManagerLoaded: @escaping (_ dnsManager: NEDNSSettingsManager?) -> Void) {
        let dnsManager = NEDNSSettingsManager.shared()
        dnsManager.loadFromPreferences { error in
            if let error = error {
                DDLogError("(NativeDnsSettingManager) - loadDnsManager; Loading error: \(error)")
                onManagerLoaded(nil)
                return
            }
            onManagerLoaded(dnsManager)
        }
    }
    
    private func getDnsManagerStatus(_ onStatusReceived: @escaping (_ status: ManagerStatus) -> Void) {
        loadDnsManager { dnsManager in
            guard let manager = dnsManager else {
                DDLogError("(NativeDnsSettingManager) - getDnsManagerStatus; Received nil DNS manager")
                onStatusReceived(ManagerStatus())
                return
            }
            onStatusReceived(ManagerStatus(manager: manager))
        }
    }
    
    private func setupDnsManager(dnsManager: NEDNSSettingsManager) {
        let onDemandRules = networkSettingsService.onDemandRules
        dnsManager.onDemandRules = onDemandRules
    }
    
    private func saveDnsManagerInternal(dnsManager: NEDNSSettingsManager, dnsProtocol: DnsAdGuardSDK.DnsProtocol, upstreams: [DnsUpstream], _ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        setupDnsManager(dnsManager: dnsManager)
        let upstreams = upstreams.map { $0.upstream }
        let settings: NEDNSSettings
        switch dnsProtocol {
        case .dns: settings = NEDNSSettings(servers: upstreams)
        case .doh, .dot:
            guard upstreams.count == 1, let serverUrl = upstreams.first else {
                onErrorReceived(NativeDnsProviderError.invalidUpstreamsNumber)
                return
            }
           settings = processSecuredProtocols(dnsProtocol: dnsProtocol, serverUrl: serverUrl)
        default:
            onErrorReceived(NativeDnsProviderError.unsupportedDnsProtocol)
            return
        }
        
        dnsManager.dnsSettings = settings
        dnsManager.localizedDescription = Bundle.main.applicationName
        dnsManager.saveToPreferences(completionHandler: onErrorReceived)
    }
    
    private func processSecuredProtocols(dnsProtocol: DnsAdGuardSDK.DnsProtocol, serverUrl: String) -> NEDNSSettings {
        let settings: NEDNSSettings
        if dnsProtocol == .doh {
            let dohSettings = NEDNSOverHTTPSSettings(servers: [])
            dohSettings.serverURL = URL(string: serverUrl)
            settings = dohSettings
        } else {
            var url = serverUrl
            let dotSettings = NEDNSOverTLSSettings(servers: [])
            if let range = url.range(of: "tls://") {
                url.removeSubrange(range)
            }
            dotSettings.serverName = url
            settings = dotSettings
        }
        
        return settings
    }
    
    //MARK: - Observers
    private func addObservers() {
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            if self?.resources.dnsImplementation == .native {
                self?.saveDnsManager({ error in
                    if let error = error {
                        DDLogError("(NativeDnsSettingManager) - dnsImplementationObserver; Saving dns manager error: \(error)")
                    }
                })
            } else {
                self?.removeDnsManager({ error in
                    if let error = error {
                        DDLogError("(NativeDnsSettingManager) - dnsImplementationObserver; Removing dns manager error: \(error)")
                    }
                })
            }
        }
        
        dnsManagerStatusObserver = NotificationCenter.default.observe(name: .NEDNSSettingsConfigurationDidChange, object: nil, queue: .main) { [weak self] notification in
            if let dnsManager = notification.object as? NEDNSSettingsManager {
                self?.dnsManagerIsEnabled = dnsManager.isEnabled
            }
        }
        
        appWillEnterForeground = NotificationCenter.default.observe(name: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            self?.getDnsManagerStatus( { [weak self] status in
                self?.dnsManagerIsEnabled = status.isInstalled && status.isEnabled
            })
        }
        
        proObservation = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            if !self.configuration.proStatus {
                self.removeDnsManager{ error in
                    if let error = error {
                        DDLogError("(NativeDnsSettingManager) - proObservation; Removing dns manager error: \(error)")
                    }
                }
            } else if self.resources.dnsImplementation == .native && self.configuration.proStatus {
                self.saveDnsManager { error in
                    if let error = error {
                        DDLogError("(NativeDnsSettingManager) - proObservation; Saving dns manager error: \(error)")
                    }
                }
            }
        }
    }
}
