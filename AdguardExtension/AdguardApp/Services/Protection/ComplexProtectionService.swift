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


// MARK: - Complex protection Interface -

@objc
protocol ComplexProtectionServiceProtocol: class {
    
    // Turns on/off complex protection
    func switchComplexProtection(state enabled: Bool, for VC: UIViewController?,  completion: @escaping (_ safariError: Error?,_ systemError: Error?)->Void)
    
    // Turns on/off safari protection
    func switchSafariProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void)
    
    // Turns on/off tracking protection
    func switchSystemProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void)
    
    var safariProtectionEnabled: Bool { get }
    var systemProtectionEnabled: Bool { get }
    var complexProtectionEnabled: Bool { get }
}

enum ComplexProtectionError: Error {
    case cancelledAddingVpnConfiguration
    case invalidDnsImplementation
}

// MARK: - Complex protection class -
class ComplexProtectionService: ComplexProtectionServiceProtocol{
    
    static let systemProtectionChangeNotification = Notification.Name(rawValue: "systemProtectionChangeNotification")
    
    var safariProtectionEnabled: Bool {
        return safariProtection.safariProtectionEnabled
    }
    
    let safariProtection: SafariProtectionServiceProtocol
    
    var systemProtectionEnabled: Bool {
        if resources.dnsImplementation == .adGuard {
            return proStatus
                && resources.systemProtectionEnabled
                && resources.complexProtectionEnabled
                && vpnManager.vpnInstalled
        } else {
            return nativeProvidersService.managerIsEnabled
        }
    }
    
    var complexProtectionEnabled: Bool {
        return resources.complexProtectionEnabled
    }
    
    private let resources: AESharedResourcesProtocol
    private let safariService: SafariServiceProtocol
    private let configuration: ConfigurationServiceProtocol
    private let vpnManager: VpnManagerProtocol
    private let productInfo: ADProductInfoProtocol
    private let nativeProvidersService: NativeProvidersServiceProtocol
    
    private var vpnConfigurationObserver: NotificationToken!
    private var vpnStateChangeObserver: NotificationToken!
    private var dnsImplementationObserver: NotificationToken!
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    init(resources: AESharedResourcesProtocol, safariService: SafariServiceProtocol, configuration: ConfigurationServiceProtocol, vpnManager: VpnManagerProtocol, safariProtection: SafariProtectionService, productInfo: ADProductInfoProtocol, nativeProvidersService: NativeProvidersServiceProtocol) {
        self.resources = resources
        self.safariService = safariService
        self.configuration = configuration
        self.vpnManager = vpnManager
        self.safariProtection = safariProtection
        self.productInfo = productInfo
        self.nativeProvidersService = nativeProvidersService
        
        nativeProvidersService.delegate = self
        
        addObservers()
        checkVpnInstalled()
        DDLogInfo("(ComplexProtectionService) - ComplexProtectionService was initialized")
    }
    
    func switchComplexProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (_ safariError: Error?,_ systemError: Error?)->Void) {
        let complexEnabled = resources.complexProtectionEnabled
        let safariEnabled = resources.safariProtectionEnabled
        let systemEnabled = resources.systemProtectionEnabled
        resources.complexProtectionEnabled = enabled
        
        DDLogInfo("(ComplexProtectionService) - complexProtection state: \(complexEnabled)")
        DDLogInfo("(ComplexProtectionService) - safariEnabled state: \(safariEnabled)")
        DDLogInfo("(ComplexProtectionService) - systemProtection state: \(systemEnabled)")
        DDLogInfo("(ComplexProtectionService) - switchComplexProtection to state: \(enabled)")
        
        if enabled && !safariEnabled && !systemEnabled {
            resources.safariProtectionEnabled = true
            if resources.dnsImplementation == .adGuard {
                resources.systemProtectionEnabled = proStatus
            }
        }
        
        if #available(iOS 14.0, *) {
            if resources.dnsImplementation == .native {
                if enabled {
                    nativeProvidersService.saveDnsManager { _ in }
                } else {
                    nativeProvidersService.removeDnsManager { _ in }
                }
            }
        }
        
        // We can't control native DNS configuration, we can only check it's state
        let shouldUpdateSystemProtection = resources.dnsImplementation == .adGuard
        
        updateProtections(safari: true, system: shouldUpdateSystemProtection, vc: VC) { [weak self] (safariError, systemError) in
            guard let self = self else { return }
            
            if safariError != nil {
                self.resources.safariProtectionEnabled = safariEnabled
            }
            
            if systemError != nil {
                self.resources.systemProtectionEnabled = systemEnabled
            }
            
            completion(safariError, systemError)
        }
    }
    
    func switchSafariProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void){
        let needsUpdateSystemProtection = false
        let needsUpdateSafari = true
        
        let systemOld = resources.systemProtectionEnabled
        let safariOld = resources.safariProtectionEnabled
        
        DDLogInfo("(ComplexProtectionService) - complexProtection state: \(resources.complexProtectionEnabled)")
        DDLogInfo("(ComplexProtectionService) - systemProtection state: \(systemOld)")
        DDLogInfo("(ComplexProtectionService) - safariProtection state: \(safariOld)")
        DDLogInfo("(ComplexProtectionService) - switchSafariProtection to state: \(enabled)")
        
        if enabled && !resources.complexProtectionEnabled {
            resources.complexProtectionEnabled = true
            
            if resources.systemProtectionEnabled {
                resources.systemProtectionEnabled = false
            }
        }

        if !enabled && !systemProtectionEnabled {
            resources.complexProtectionEnabled = false
        }
        
        resources.safariProtectionEnabled = enabled
        
        updateProtections(safari: needsUpdateSafari, system: needsUpdateSystemProtection, vc: VC) { [weak self] (safariError, systemError) in
            guard let self = self else { return }
            
            if safariError != nil {
                self.resources.safariProtectionEnabled = safariOld
            }
            
            if systemError != nil {
                self.resources.systemProtectionEnabled = systemOld
            }
            
            completion(safariError)
        }
    }
    
    func switchSystemProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void) {
        switchSystemProtectionInternal(state: enabled, for: VC, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func switchSystemProtectionInternal(state enabled: Bool, for VC: UIViewController?, completion: @escaping (Error?)->Void) {
        let systemOld = resources.systemProtectionEnabled
        let safariOld = resources.safariProtectionEnabled
        
        let needsUpdate = updateSystemProtectionResources(toEnabledState: enabled)
        
        updateProtections(safari: needsUpdate.needsUpdateSafari, system: needsUpdate.needsUpdateSystem, vc: VC) { [weak self] (safariError, systemError) in
            guard let self = self else { return }
            
            if safariError != nil {
                self.resources.safariProtectionEnabled = safariOld
            }
            
            if systemError != nil {
                self.resources.systemProtectionEnabled = systemOld
            }
            
            completion(systemError)
        }
    }
    
    private func updateProtections(safari:Bool, system: Bool, vc: UIViewController?, completion: @escaping (_ safariError: Error?, _ systemError: Error?)->Void) {
        
        DispatchQueue(label: "complex protection queue").async { [weak self] in
            guard let self = self else { return }
            
            var safariError: Error?
            var systemError: Error?
            
            let group = DispatchGroup()
            if safari {
                DDLogInfo("(ComplexProtectionService) - Begining updating safari protection")
                group.enter()
                self.safariInvalidateJson { error in
                    safariError = error
                    DDLogInfo("(ComplexProtectionService) - Ending updating safari protection with error - \(error?.localizedDescription ?? "nil")")
                    group.leave()
                }
            }
            
            if system {
                DDLogInfo("(ComplexProtectionService) - Begining updating dns protection")
                group.enter()
                self.updateVpnSettings(vc: vc) { error in
                    systemError = error
                    DDLogInfo("(ComplexProtectionService) - Ending updating safari protection with error - \(error?.localizedDescription ?? "nil")")
                    group.leave()
                }
            }
            
            group.wait()
            
            completion(safariError, systemError)
        }
    }
    
    private func updateSystemProtectionResources(toEnabledState enabled: Bool) -> (needsUpdateSafari: Bool, needsUpdateSystem: Bool){
        let needsUpdateSafari = false
        let needsUpdateSystem = true
        
        DDLogInfo("(ComplexProtectionService) - complexProtection state: \(resources.complexProtectionEnabled)")
        DDLogInfo("(ComplexProtectionService) - systemProtection state: \(resources.systemProtectionEnabled)")
        DDLogInfo("(ComplexProtectionService) - safariProtection state: \(resources.safariProtectionEnabled)")
        DDLogInfo("(ComplexProtectionService) - switchSystemProtection to state: \(enabled)")
        
        if enabled && !resources.complexProtectionEnabled {
            resources.complexProtectionEnabled = true
            if resources.safariProtectionEnabled {
                resources.safariProtectionEnabled = false
            }
        }
        
        if !enabled && !safariProtection.safariProtectionEnabled {
            self.resources.complexProtectionEnabled = false
        }
        
        resources.systemProtectionEnabled = enabled
        
        return (needsUpdateSafari, needsUpdateSystem)
    }
    
    /**
     This method invalidates blocking json
     */
    private func safariInvalidateJson(completion: @escaping (Error?)->Void){
        safariService.invalidateBlockingJsons { (error) in
            if error != nil {
                DDLogError("(ComplexProtectionService) Error invalidating json")
            } else {
                DDLogInfo("(ComplexProtectionService) Successfull invalidating of json")
            }
            completion(error)
        }
    }
    
    private func updateVpnSettings(vc: UIViewController?, completion: @escaping (Error?)->Void) {
        if !proStatus {
            DDLogInfo("(ComplexProtectionService) Failed \(#function) with reason: proStatus - \(proStatus)")
            completion(nil)
            return
        }
        
        if !vpnManager.vpnInstalled && resources.systemProtectionEnabled && vc != nil {
            
            #if !APP_EXTENSION
            self.showConfirmVpnAlert(for: vc!) { [weak self] (confirmed) in
                guard let self = self else { return }
                
                if !confirmed {
                    self.resources.systemProtectionEnabled = false
                    completion(ComplexProtectionError.cancelledAddingVpnConfiguration)
                    return
                }
                
                self.vpnManager.installVpnConfiguration(completion: completion)
            }
            #endif
        }
        else {
            vpnManager.updateSettings { (error) in
                if error as? VpnManagerError == VpnManagerError.managerNotInstalled {
                    completion(nil)
                }
                else {
                    completion(error)
                }
            }
        }
    }
    
    private func addObservers() {
        vpnConfigurationObserver = NotificationCenter.default.observe(name: VpnManager.configurationRemovedNotification, object: nil, queue: nil) { [weak self] (note) in
            DDLogInfo("(ComplexProtectionService) configurationRemovedNotification called")
            guard let self = self else { return }
            self.resources.systemProtectionEnabled = false
            NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
        }
        
        vpnStateChangeObserver = NotificationCenter.default.observe(name: VpnManager.stateChangedNotification, object: nil, queue: nil) { [weak self] (note) in
            DDLogInfo("(ComplexProtectionService) stateChangedNotification called")
            guard let self = self else { return }
            if let enabled = note.object as? Bool {
                self.resources.systemProtectionEnabled = enabled
                if !self.complexProtectionEnabled { self.resources.complexProtectionEnabled = enabled }
            }
            
            NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
        }
        
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: nil) { [weak self] _ in
            DDLogInfo("(ComplexProtectionService) dnsImplementationChanged called")
            guard let self = self else { return }
        
            if self.resources.dnsImplementation == .adGuard {
                self.checkVpnInstalled()
            } else {
                self.switchSystemProtectionInternal(state: false, for: nil) { [weak self] error in
                    guard let self = self else { return }
                
                    if let error = error {
                        DDLogError("Failed to turn off system protection, error: \(error.localizedDescription)")
                    }
                
                    let managerIsEnabled = self.nativeProvidersService.managerIsEnabled
                    let _ = self.updateSystemProtectionResources(toEnabledState: managerIsEnabled)
                    NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
                }
            }
        }
    }
    
    private func checkVpnInstalled() {
        vpnManager.checkVpnInstalled { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                DDLogError("(ComplexProtectionService) checkVpnInstalled error: \(error!)")
            }
            else {
                if !self.vpnManager.vpnInstalled {
                    self.resources.systemProtectionEnabled = false
                    NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
                }
            }
        }
    }
    
#if !APP_EXTENSION
    private func showConfirmVpnAlert(for vc: UIViewController, confirmed: @escaping (Bool)->Void){
        
        DispatchQueue.main.async {
            let title: String = String.localizedString("vpn_confirm_title")
            let message: String = String.localizedString("vpn_confirm_message")
            let okTitle: String = String.localizedString("common_action_ok")
            let cancelTitle: String = String.localizedString("common_action_cancel")
            let privacyTitle: String = String.localizedString("privacy_policy_action")
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: okTitle, style: .default) {(alert) in
                confirmed(true)
            }
            
            let privacyAction = UIAlertAction(title: privacyTitle, style: .default) { (alert) in
                UIApplication.shared.openAdguardUrl(action: "privacy", from: "DnsSettingsController", buildVersion: self.productInfo.buildVersion())
                confirmed(false)
            }
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alert) in
                confirmed(false)
            }
            
            alert.addAction(okAction)
            alert.addAction(privacyAction)
            alert.addAction(cancelAction)
            
            alert.preferredAction = okAction
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
#endif
}

extension ComplexProtectionService: NativeProvidersServiceDelegate {
    func dnsManagerStatusChanged() {
        if resources.dnsImplementation == .native {
            let managerIsEnabled = nativeProvidersService.managerIsEnabled
            let _ = updateSystemProtectionResources(toEnabledState: managerIsEnabled)
            NotificationCenter.default.post(name: ComplexProtectionService.systemProtectionChangeNotification, object: self)
        }
    }
}
