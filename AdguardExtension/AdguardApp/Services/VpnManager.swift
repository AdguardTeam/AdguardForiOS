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

@objc
protocol VpnManagerProtocol {
    
    /** updates vpn settings and restarts the tunnel */
    func updateSettings(completion: ((Error?)->Void)?)
    
    /** removes vpn configuration from ios settings */
    func removeVpnConfiguration(completion: @escaping (Error?)->Void)
    
    /** creates new vpn configuration and installs it to sysstem settings
        removes old configurations if it needed
     */
    func installVpnConfiguration(completion: @escaping (Error?)->Void)

    /** returns vpn cpnfiguration installed status */
    var vpnInstalled: Bool { get }
    
    /** checks vpn cpnfiguration is installed */
    func checkVpnInstalled(completion: @escaping (Error?)->Void)
    
    /** returns actual state of vpn configuration */
    func getConfigurationStatus(callback: @escaping (VpnConfigurationStatus)->Void)
    
    /** migrate settings pro 2.1.2 and freee 3.0 settings to universal app v4.0 */
    func migrateOldVpnSettings(completion: @escaping (Error?)->Void)
}

enum VpnManagerError: Error {
    case managerNotInstalled
}

class VpnManager: VpnManagerProtocol {
    
    static let configurationRemovedNotification = NSNotification.Name("configurationRemovedNotification")
    static let stateChangedNotification = NSNotification.Name("stateChangedNotification")
    
    // MARK: - private properties
       
    private let resources: AESharedResourcesProtocol
    private let appConfiguration: ConfigurationServiceProtocol
    private let networkSettings: NetworkSettingsServiceProtocol
    
    private let workingQueue = DispatchQueue(label: "vpn manager queue")
    
    private var timer: Timer?
    
    // Save callback from updateSettings func to prevent memory leaks in queue that waiting this callback
    private var updateSettingsCallback: ((Error?) -> Void)?
    
    // this property is public only for tests
    var providerManagerType: NETunnelProviderManager.Type = NETunnelProviderManager.self
    
    private var configurationObserver: NotificationToken?
    private var configurationObserver2: NotificationToken?
    private var dnsProviders: DnsProvidersServiceProtocol
    
    weak var complexProtection: ComplexProtectionServiceProtocol?
    
    private var vpnInstalledValue: Bool?
    
    /*
     When Tunnel is in process of restarting this variable contains function to start tunnel
     */
    private var startTunnel: (() -> Void)?
            
    // MARK: - initialize
    
    init(resources: AESharedResourcesProtocol ,configuration: ConfigurationServiceProtocol, networkSettings: NetworkSettingsServiceProtocol, dnsProviders: DnsProvidersServiceProtocol) {
        self.resources = resources
        self.appConfiguration = configuration
        self.networkSettings = networkSettings
        self.dnsProviders = dnsProviders
        
        configurationObserver = NotificationCenter.default.observe(name: NSNotification.Name.NEVPNStatusDidChange, object: nil, queue: nil) { [weak self] note in
            guard let self = self else { return }
            
            guard let session = note.object as? NETunnelProviderSession else {
                DDLogError("Invalid note when vpn status received")
                return
            }
            let vpnStatus = session.status
            
            // When Tunnel is stopped we should start it
            if vpnStatus == .disconnected, self.startTunnel != nil {
                self.startTunnel?()
                self.startTunnel = nil // Set to nil when restart is finished
            }
            
            if vpnStatus == .invalid {
                self.workingQueue.async { [weak self] in
                    guard let self = self else { return }
                    
                    // check configuration still installed
                    _ = self.loadManager()
                    if !self.vpnInstalled {
                        NotificationCenter.default.post(name:VpnManager.configurationRemovedNotification, object: self)
                    }
                }
            }
        }
        
        configurationObserver2 = NotificationCenter.default.observe(name: NSNotification.Name.NEVPNConfigurationChange, object: nil, queue: nil) { [weak self] (note) in
            guard let self = self else { return }
            
            self.workingQueue.async { [weak self] in
                guard let self = self else { return }
                let (manager, _) = self.loadManager()
                if let manager = manager {
                    self.checkState(manager)
                }
            }
        }
    }
    
    // MARK: - VpnManagerProtocol methods
    
    func checkVpnInstalled(completion: @escaping (Error?)->Void) {
        DDLogInfo("(VpnManager) checkVpnInstalled called")
        
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            
            // get manager from system preferences
            let (manager, error) = self.loadManager()
            
            if let manager = manager {
                self.checkState(manager)
            }
            
            completion(error)
        }
    }
    
    func updateSettings(completion: ((Error?) -> Void)?) {
        DDLogInfo("(VpnManager) updateSettings called waiting for 1 second before restart")
        
        /* There was a problem when user could produce lots of VPN restarts in a row. To avoid multiple restarts for every user action we wait for 1 second for next restart, if there weren't any than we restart it.
         Issue link: https://github.com/AdguardTeam/AdguardForiOS/issues/1719
         Use processInfo for handling that application entered in background
         */
        
        ProcessInfo().performExpiringActivity(withReason: "vpn updating in background") { exprired in
            if exprired { return }
            // Sleep com.apple.expiringTaskExecutionQueue (concurrent) for updating settings if application entered in background
            sleep(2)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.timer?.invalidate()
            self?.timer = nil
            // Call and save completion to prevent memory leaks in queue that waiting this completion
            self?.updateSettingsCallback?(nil)
            self?.updateSettingsCallback = completion
            
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                DDLogInfo("(VpnManager) 1 second passed calling updateSettings now")
                self?.updateSettingsInternal { error in
                    DispatchQueue.main.async {
                        self?.timer?.invalidate()
                        self?.timer = nil
                        self?.updateSettingsCallback?(error)
                        self?.updateSettingsCallback = nil                        
                    }
                }
            })
        }
    }
    
    func removeVpnConfiguration(completion: @escaping (Error?) -> Void) {
        DDLogInfo("(VpnManager) removeVpnConfiguration called")
        
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            
            let (manager, error) = self.loadManager()
            
            if error != nil {
                completion(error!)
                return
            }
            
            if manager == nil {
                completion(nil)
                return
            }
            
            completion(self.removeManager(manager!))
        }
    }
    
    func installVpnConfiguration(completion: @escaping (Error?) -> Void) {
        
        DDLogInfo("(VpnManager) installVpnConfiguration")
        
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            
            // remove previous configuration if needed
            let (oldManager, _) = self.loadManager()
            if oldManager != nil {
                _ = self.removeManager(oldManager!)
            }
            
            let newManager = self.createManager()
            
            self.setupConfiguration(newManager)
            
            let error = self.saveManager(newManager)
            
            self.vpnInstalledValue = error == nil
            completion(error)
        }
    }
    
    var vpnInstalled: Bool {
        return vpnInstalledValue ?? true
    }
    
    func getConfigurationStatus(callback: @escaping (VpnConfigurationStatus) -> Void) {
        DDLogInfo("(VpnManager) getConfigurationStatus called")
        
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            let (manager, _) = self.loadManager()
            let status = VpnConfigurationStatus(vpnManager: manager, isInstalled: manager != nil)
            callback(status)
        }
    }
    
    func migrateOldVpnSettings(completion: @escaping (Error?) -> Void) {
        DDLogInfo("(VpnManager) migrateOldVpnSettings called")
        
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            
            // get manager from system preferences
            let (manager, error) = self.loadManager()
            if let providerConfiguration = (manager?.protocolConfiguration as? NETunnelProviderProtocol)?.providerConfiguration {
                VpnManagerMigration.migrateSettingsIfNeeded(resources: self.resources, dnsProviders: self.dnsProviders, providerConfiguration: providerConfiguration)
            }
            
            completion(error)
        }
    }
    
    // MARK: - private methods
    
    private func updateSettingsInternal(completion: ((Error?) -> Void)?) {
        
        workingQueue.async { [weak self] in
            guard let self = self else { return }
            
            DDLogInfo("(VpnManager) updateSettings")
            
            let (manager, error) = self.loadManager()
            
            if error != nil {
                completion?(error!)
                return
            }
            
            if manager == nil {
                DDLogError("(VpnManager) updateSettings error - there is no installed vpn configurations to update")
                let error = VpnManagerError.managerNotInstalled
                completion?(error)
                
                return
            }
            
            self.setupConfiguration(manager!)
            
            let saveError = self.saveManager(manager!)
            completion?(saveError)
            
            self.restartTunnel(manager!)
        }
    }
    
    private func loadManager()->(NETunnelProviderManager?, Error?) {
        DDLogInfo("(VpnManager) loadManager ")
        
        var manager: NETunnelProviderManager?
        var resultError: Error?
        let group = DispatchGroup()
        group.enter()
        
        providerManagerType.self.loadAllFromPreferences { [weak self] (managers, error) in
            
            defer { group.leave() }
            
            guard let self = self else { return }
            if error != nil {
                resultError = error
                DDLogError("(VpnManager) loadManager error: \(error!)")
                return
            }
            
            if managers?.count ?? 0 == 0 {
                DDLogInfo("(VpnManager) loadManager - manager not installed")
                return
            }
            
            if managers!.count > 1 {
                DDLogError("(VpnManager) loadManager error - there are \(managers!.count) managers installed. Delete all managers")
                
                for manager in managers! {
                    _ = self.removeManager(manager)
                }
                
                manager = self.createManager()
                
                return
            }
            
            DDLogInfo("(VpnManager) loadManager success)")
            manager = managers?.first
        }
        
        group.wait()
        
        vpnInstalledValue = manager != nil
        return (manager, resultError)
    }
    
    private func createManager()->NETunnelProviderManager {
        
        DDLogInfo("(VpnManager) createManager")
        
        let manager = providerManagerType.self.init()
        
        return manager
    }
    
    private func setupConfiguration(_ manager: NETunnelProviderManager) {
        DDLogInfo("(VpnManager) setupConfiguration called")
        
        // do not update configuration for not premium users
        if !appConfiguration.proStatus {
            return
        }
        
        // setup protocol configuration
        let protocolConfiguration = NETunnelProviderProtocol()
        protocolConfiguration.providerBundleIdentifier = AP_TUNNEL_ID
        protocolConfiguration.serverAddress = "127.0.0.1"
        
        manager.protocolConfiguration = protocolConfiguration
        
        let onDemandRuled = networkSettings.onDemandRules
        manager.onDemandRules = onDemandRuled
        
        let enabled: Bool
        
        if !vpnInstalled {
            enabled = true // install configuration with enable = true
        }
        else {
           enabled = self.complexProtection?.systemProtectionEnabled ?? false || !vpnInstalled
        }
        
        if resources.dnsImplementation == .native {
            DDLogInfo("(VpnManager) set manager isEnabled = false because native mode is enabled ")
        }

        manager.isEnabled = resources.dnsImplementation == .native ? false : enabled
        manager.isOnDemandEnabled = resources.dnsImplementation == .native ? false : enabled
        
        manager.localizedDescription = Constants.aeProductName()
    }
    
    private func saveManager(_ manager: NETunnelProviderManager)->Error? {
        
        DDLogInfo("(VpnManager) saveManager")
        var resultError: Error?
        
        let group = DispatchGroup()
        group.enter()
        
        manager.saveToPreferences { (error) in
            resultError = error
            if error != nil {
                DDLogError("(VpnManager) saveManager error: \(error!)")
            }
            else {
                DDLogInfo("(VpnManager) saveManager success")
            }
            
            group.leave()
        }
        
        group.wait()
        
        return resultError
    }
    
    private func removeManager(_ manager: NETunnelProviderManager)->Error? {
        DDLogInfo("(VpnManager) - removeManager called")
        
        var resultError: Error?
        let group = DispatchGroup()
        group.enter()
        
        manager.removeFromPreferences { (error) in
            resultError = error
            group.leave()
        }
        
        group.wait()
        
        return resultError
    }
    
    private func restartTunnel(_ manager: NETunnelProviderManager) {
        DDLogInfo("(VpnManager) - restartTunnel called")
        
        // Assigning start tunnel function to call it in observer
        startTunnel = {
            DDLogInfo("(VpnManager) - Trying to start VPN tunnel after restart")
            do {
                try manager.connection.startVPNTunnel()
            } catch {
                DDLogError("(VpnManager) - start tunnel error: \(error.localizedDescription)")
            }
        }
        manager.connection.stopVPNTunnel()
    }
    
    // check if vpn enabled state was changed outside the application
    private func checkState(_ manager: NETunnelProviderManager) {
        
        let savedEnabled = self.complexProtection?.systemProtectionEnabled ?? false
        var actualEnabled = false
        if manager.isEnabled && manager.isOnDemandEnabled {
            actualEnabled = true
        } else if manager.isEnabled && !manager.isOnDemandEnabled {
            actualEnabled = manager.connection.status == .connected || manager.connection.status == .connecting
        }
        
        DDLogInfo("(VpnManager) savedState: \(savedEnabled) actual: \(actualEnabled)")
        
        if actualEnabled != savedEnabled {
            DDLogInfo("(VpnManager) vpn enabled state was changed outside the application to state: \(actualEnabled)")
            NotificationCenter.default.post(name:VpnManager.stateChangedNotification, object: actualEnabled)
        }
    }
}

@objc
class VpnManagerMigration: NSObject {
    
    private static let oldAdguardUUID = "AGDEF01"
    private static let oldAdguardFamilyUUID = "AGDEF02"
    private static let oldAdguardDnsCryptIdIpv4 = "adguard-dns"
    private static let oldAdguardDnsCryptIdIpv6 = "adguard-dns-ipv6"
    private static let oldAdguardFamilyDnsCryptIdIpv4 = "adguard-dns-family"
    private static let oldAdguardFamilyDnsCryptIdIpv6 = "adguard-dns-family-ipv6"

    @objc
    class func migrateSettingsIfNeeded(resources: AESharedResourcesProtocol, dnsProviders: DnsProvidersServiceProtocol, providerConfiguration: [String : Any]) {
        // in app version below 4.0.0 we stored tunnel settings(activeDnsServer, tunnelMode, restartByReachability) in protocol configuration.
        // now we store it in shared defaults
        
        let tunnelModeOld = providerConfiguration[APVpnManagerParameterTunnelMode] as? UInt
        let restartOld = providerConfiguration[APVpnManagerRestartByReachability] as? Bool
        let activeDnsServerData = providerConfiguration[APVpnManagerParameterRemoteDnsServer] as? Data
        
        if tunnelModeOld != nil || activeDnsServerData != nil || restartOld != nil {
            
            DDLogInfo("(VpnManagerMigration) there are not new settings in shared resources. Try to read it from protocol configuration")
            if tunnelModeOld != nil {
                DDLogInfo("(VpnManagerMigration) save tunnelModeOld in resources")
                resources.tunnelMode = APVpnManagerTunnelMode(tunnelModeOld!)
            }
            
            if restartOld != nil {
                DDLogInfo("(VpnManagerMigration) save restartOld in resources")
                resources.restartByReachability = restartOld!
            }
            
            if activeDnsServerData != nil {
                
                let oldServer = NSKeyedUnarchiver.unarchiveObject(with: activeDnsServerData!)
                if let activeDnsServerOld = oldServer as? DnsServerInfo {
                    DDLogInfo("(VpnManagerMigration) save activeDnsServerOld in resources")
                    dnsProviders.activeDnsServer = activeDnsServerOld
                }
            }
        }
    }
}

