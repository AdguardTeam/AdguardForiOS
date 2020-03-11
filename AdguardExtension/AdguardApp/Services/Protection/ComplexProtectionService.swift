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
}

// MARK: - Complex protection class -
class ComplexProtectionService: ComplexProtectionServiceProtocol{
    
    var safariProtectionEnabled: Bool {
        return safariProtection.safariProtectionEnabled
    }
    
    let safariProtection: SafariProtectionServiceProtocol
    
    var systemProtectionEnabled: Bool {
        return configuration.proStatus
            && resources.systemProtectionEnabled
            && resources.complexProtectionEnabled
            && vpnManager.vpnInstalled
    }
    
    var complexProtectionEnabled: Bool {
        return resources.complexProtectionEnabled
    }
    
    private let resources: AESharedResourcesProtocol
    private let safariService: SafariServiceProtocol
    private let configuration: ConfigurationServiceProtocol
    private let vpnManager: VpnManagerProtocol
    
    private var vpnConfigurationObserver: NotificationToken!
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    init(resources: AESharedResourcesProtocol, safariService: SafariServiceProtocol, configuration: ConfigurationServiceProtocol, vpnManager: VpnManagerProtocol, safariProtection: SafariProtectionService) {
        self.resources = resources
        self.safariService = safariService
        self.configuration = configuration
        self.vpnManager = vpnManager
        self.safariProtection = safariProtection
        
        vpnConfigurationObserver = NotificationCenter.default.observe(name: VpnManager.configurationRemovedNotification, object: nil, queue: nil) { [weak self] (note) in
            guard let self = self else { return }
            self.resources.systemProtectionEnabled = false
        }
        
        vpnManager.checkVpnInstalled { (_) in
            if !vpnManager.vpnInstalled {
                resources.systemProtectionEnabled = false
            }
        }
    }
    
    func switchComplexProtection(state enabled: Bool, for VC: UIViewController?, completion: @escaping (_ safariError: Error?,_ systemError: Error?)->Void) {
        
        resources.complexProtectionEnabled = enabled
                    
        let safariEnabled = resources.safariProtectionEnabled
        let systemEnabled = resources.systemProtectionEnabled
        
        if enabled && !safariEnabled && !systemEnabled {
            resources.safariProtectionEnabled = true
            resources.systemProtectionEnabled = configuration.proStatus
        }
        
        updateProtections(safari: true, system: true, vc: VC) { [weak self] (safariError, systemError) in
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
        
        var needsUpdateSystemProtection = false
        let needsUpdateSafari = resources.safariProtectionEnabled != enabled
        
        let systemOld = resources.systemProtectionEnabled
        let safariOld = resources.safariProtectionEnabled
        
        resources.safariProtectionEnabled = enabled
        
        if enabled && !resources.complexProtectionEnabled {
            resources.complexProtectionEnabled = true
            needsUpdateSystemProtection = resources.systemProtectionEnabled
        }

        if !enabled && !systemProtectionEnabled {
            resources.complexProtectionEnabled = false
        }
        
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
        
        var needsUpdateSafari = false
        let needsUpdateSystem = resources.systemProtectionEnabled != enabled
        
        let systemOld = resources.systemProtectionEnabled
        let safariOld = resources.safariProtectionEnabled
        
        resources.systemProtectionEnabled = enabled
         
        if enabled && !resources.complexProtectionEnabled {
            resources.complexProtectionEnabled = true
            needsUpdateSafari = resources.safariProtectionEnabled
        }
        
        if !enabled && !safariProtection.safariProtectionEnabled {
            self.resources.complexProtectionEnabled = false
        }
        
        updateProtections(safari: needsUpdateSafari, system: needsUpdateSystem, vc: VC) { [weak self] (safariError, systemError) in
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
    
    // MARK: - Private methods
    
    func updateProtections(safari:Bool, system: Bool, vc: UIViewController?, completion: @escaping (_ safariError: Error?, _ systemError: Error?)->Void) {
        
        DispatchQueue(label: "complex protection queue").async { [weak self] in
            guard let self = self else { return }
            
            var safariError: Error?
            var systemError: Error?
            
            let group = DispatchGroup()
            if safari {
                group.enter()
                self.safariInvalidateJson { error in
                    safariError = error
                    group.leave()
                }
            }
            
            if system {
                group.enter()
                self.updateVpnSettings(vc: vc) { error in
                    systemError = error
                    group.leave()
                }
            }
            
            group.wait()
            
            completion(safariError, systemError)
        }
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
        if !configuration.proStatus {
            completion(nil)
            return
        }
        
        let updateClosure = { [weak self] in
            self?.vpnManager.updateSettings { (error) in
                completion(error)
            }
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
                
                self.vpnManager.installVpnConfiguration { (error) in
                    if error != nil {
                        completion(error)
                        return
                    }
                    
                    updateClosure()
                }
            }
            #endif
        }
        else {
            updateClosure()
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
                UIApplication.shared.openAdguardUrl(action: "privacy", from: "DnsSettingsController")
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
