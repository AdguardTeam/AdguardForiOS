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

//TODO: Add comments
@available(iOS 14.0, *)
public protocol DnsSettingsManagerProtocol {
    func saveDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void)
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void)
    func reset()
}

@available(iOS 14.0, *)
final class DnsSettingsManager: DnsSettingsManagerProtocol {
    
    struct DnsSettingsManagerStatus {
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
    
    // Serial queue to avoid races in services
    let workingQueue = DispatchQueue(label: "AdGuardSDK.DnsSettingsManager.workingQueue")
    // Queue to call completion handlers
    let completionQueue = DispatchQueue.main
    
    private var dnsImplementationObserver: NotificationToken?

    private let networkSettingsService: NetworkSettingsServiceProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let resources: AESharedResourcesProtocol
    
    //MARK: - Init
    init(networkSettingsService: NetworkSettingsServiceProtocol,
         dnsProvidersManager: DnsProvidersManagerProtocol,
         resource: AESharedResourcesProtocol) {
        
        self.networkSettingsService = networkSettingsService
        self.dnsProvidersManager = dnsProvidersManager
        self.resources = resource
    }
    
    
    //MARK: - Public methods
    func saveDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
       
        let server = dnsProvidersManager.activeDnsServer
        let upstreams = server.upstreams.map { $0.upstream }
        
        loadDnsManager { [weak self] dnsManager in
            guard let manager = dnsManager else {
                DDLogError("(DnsSettingsManager) - saveDnsManager; Received nil DNS manager")
                onErrorReceived(NativeDnsProviderError.failedToLoadManager)
                return
            }
            self?.workingQueue.async {
                self?.saveDnsManagerInternal(dnsManager: manager, dnsProtocol: server.type, upstreams: upstreams, onErrorReceived)
            }
        }
    }
    
    func removeDnsManager(_ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        loadDnsManager { [weak self] dnsManager in
            guard let dnsManager = dnsManager else {
                DDLogError("(DnsSettingsManager) - removeDnsManager; Received nil DNS manager")
                self?.completionQueue.async { onErrorReceived(NativeDnsProviderError.failedToLoadManager) }
                return
            }
            
            dnsManager.removeFromPreferences(completionHandler: onErrorReceived)
        }
    }
    
    func reset() {
        removeDnsManager { error in
            if let error = error {
                DDLogError("(DnsSettingsManager) - reset; Error when resetting settings; Error: \(error)")
            }
        }
    }
    
    //MARK: - Private methods
    
    private func loadDnsManager(_ onManagerLoaded: @escaping (_ dnsManager: NEDNSSettingsManager?) -> Void) {
        let dnsManager = NEDNSSettingsManager.shared()
        dnsManager.loadFromPreferences { [weak self] error in
            if let error = error {
                DDLogError("(DnsSettingsManager) - loadDnsManager; Loading error: \(error)")
                self?.completionQueue.async { onManagerLoaded(nil) }
                return
            }
            self?.completionQueue.async { onManagerLoaded(dnsManager) }
        }
    }
    
    private func getDnsManagerStatus(_ onStatusReceived: @escaping (_ status: DnsSettingsManagerStatus) -> Void) {
        loadDnsManager { [weak self] dnsManager in
            guard let manager = dnsManager else {
                DDLogError("(DnsSettingsManager) - getDnsManagerStatus; Received nil DNS manager")
                self?.completionQueue.async { onStatusReceived(DnsSettingsManagerStatus()) }
                return
            }
            self?.completionQueue.async { onStatusReceived(DnsSettingsManagerStatus(manager: manager)) }
        }
    }
    
    private func setupDnsManager(dnsManager: NEDNSSettingsManager) {
        let onDemandRuled = networkSettingsService.onDemandRules
        dnsManager.onDemandRules = onDemandRuled
    }
    
    
    private func saveDnsManagerInternal(dnsManager: NEDNSSettingsManager, dnsProtocol: DnsAdGuardSDK.DnsProtocol, upstreams: [String], _ onErrorReceived: @escaping (_ error: Error?) -> Void) {
        setupDnsManager(dnsManager: dnsManager)
        
        let settings: NEDNSSettings
        switch dnsProtocol {
        case .dns: settings = NEDNSSettings(servers: upstreams)
        case .doh, .dot:
            guard upstreams.count == 1, let serverUrl = upstreams.first else {
                completionQueue.async { onErrorReceived(NativeDnsProviderError.invalidUpstreamsNumber) }
                return
            }
           settings = processSecuredProtocols(dnsProtocol: dnsProtocol, serverUrl: serverUrl)
        default:
            completionQueue.async { onErrorReceived(NativeDnsProviderError.unsupportedDnsProtocol) }
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
}

@available(iOS 14.0, *)
extension DnsSettingsManager {
    private func addObservers() {
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            if self?.resources.dnsImplementation == .native {
                self?.saveDnsManager({ error in
                    if let error = error {
                        DDLogError("(DnsSettingsManager) - dnsImplementationObserver; Saving dns manager error: \(error)")
                    }
                })
            } else {
                self?.removeDnsManager({ error in
                    if let error = error {
                        DDLogError("(DnsSettingsManager) - dnsImplementationObserver; Removing dns manager error: \(error)")
                    }
                })
            }
        }
    }
}
