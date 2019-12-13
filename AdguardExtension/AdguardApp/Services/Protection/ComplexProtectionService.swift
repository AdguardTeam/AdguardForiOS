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

protocol ComplexProtectionServiceProtocol {
    // Delegate
    var delegate: ComplexProtectionDelegate? { get set }
    
    // Turns on/off complex protection
    func switchComplexProtection(state enabled: Bool, for VC: UIViewController?)
    
    // Turns on/off safari protection
    func switchSafariProtection(state enabled: Bool)
    
    // Turns on/off system protection
    func switchSystemProtection(state enabled: Bool, for VC: UIViewController?)
    
    // Checks state of complex protection
    func checkState(completion: @escaping (Bool)->() )
    
    // Checks states of all protection modules
    func getAllStates(completion: @escaping (_ safari: Bool, _ system: Bool, _ complex: Bool)->())
}

// MARK: - Complex protection Delegate -

protocol ComplexProtectionDelegate {
    func safariProtectionChanged()
}

// MARK: - Complex protection class -

class ComplexProtectionService: ComplexProtectionServiceProtocol{
    
    var delegate: ComplexProtectionDelegate?
    
    private let resources: AESharedResourcesProtocol
    private let safariService: SafariService
    
    private let systemProtectionProcessor: TurnSystemProtectionProtocol
    
    init(resources: AESharedResourcesProtocol, safariService: SafariService, systemProtectionProcessor: TurnSystemProtectionProtocol) {
        self.resources = resources
        self.safariService = safariService
        self.systemProtectionProcessor = systemProtectionProcessor
    }
    
    func checkState(completion: @escaping (Bool)->()){
        getSystemProtectionState {[weak self] (systemEnabled) in
            guard let self = self else { return }
            
            let safaryEnabled = self.resources.safariProtectionEnabled
            let systemEnabled = systemEnabled
            
            completion(safaryEnabled || systemEnabled)
        }
    }
    
    func getAllStates(completion: @escaping (Bool, Bool, Bool) -> ()) {
        getSystemProtectionState {[weak self] (systemEnabled) in
            guard let self = self else { return }
            
            let safaryEnabled = self.resources.safariProtectionEnabled
            let systemEnabled = systemEnabled
            
            completion(safaryEnabled, systemEnabled, safaryEnabled || systemEnabled)
        }
    }
    
    func switchComplexProtection(state enabled: Bool, for VC: UIViewController?) {
        
        if !enabled {
            getSystemProtectionState {[weak self] (systemEnabled) in
                guard let self = self else { return }
                
                let safaryEnabled = self.resources.safariProtectionEnabled
                self.saveLastStates(safariState: safaryEnabled, systemState: systemEnabled)
                
                // Turning off safari and system protection
                self.switchSafariProtection(state: enabled)
                if systemEnabled {
                    self.switchSystemProtection(state: enabled, for: VC)
                }
            }
        } else {
            let statesTuple = getLastStates()
            
            let safariEnabled = statesTuple.safariEnabled
            let systemEnabled = statesTuple.systemEnabled
            
            /**
             If everything was turned off before disabling complex protection
             then we turning on just safari protection
             */
            if !(safariEnabled || systemEnabled){
                switchSafariProtection(state: true)
            } else {
                if safariEnabled {
                    switchSafariProtection(state: safariEnabled)
                }
                if systemEnabled {
                    switchSystemProtection(state: systemEnabled, for: VC)
                }
            }
        }
    }
    
    func switchSafariProtection(state enabled: Bool){
        resources.safariProtectionEnabled = enabled
        
        safariService.invalidateBlockingJsons(completion: {[weak self] (error) in
            if error != nil {
                DDLogError("(ComplexProtectionService) Error invalidating json from")
            } else {
                DDLogInfo("(ComplexProtectionService) Successfull invalidating of json")
            }
            self?.delegate?.safariProtectionChanged()
        })
    }
    
    func switchSystemProtection(state enabled: Bool, for VC: UIViewController?) {
        systemProtectionProcessor.turnSystemProtection(to: enabled, with: VC, completion: {})
    }
    
    // MARK: - Private methods
    
    private func getSystemProtectionState(completion:@escaping (Bool)->() ) {
        NETunnelProviderManager.loadAllFromPreferences {(managers, error) in
            if error != nil {
                completion(false)
                DDLogError("(ComplexProtectionService) Error loading vpn configuration: \(String(describing: error?.localizedDescription))")
            } else {
                let manager = managers?.first
                let vpnEnabled = manager?.isEnabled ?? false
                
                completion(vpnEnabled)
            }
        }
    }
    
    private func saveLastStates(safariState: Bool, systemState: Bool){
        resources.sharedDefaults().set(safariState, forKey: SafariProtectionLastState)
        resources.sharedDefaults().set(systemState, forKey: SystemProtectionLastState)
    }
    
    private func getLastStates() -> (safariEnabled: Bool, systemEnabled: Bool){
        let safaryEnabled = resources.sharedDefaults().bool(forKey: SafariProtectionLastState)
        let systemEnabled = resources.sharedDefaults().bool(forKey: SystemProtectionLastState)
        
        return (safaryEnabled, systemEnabled)
    }
}
