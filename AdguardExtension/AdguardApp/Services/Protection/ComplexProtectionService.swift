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
    
    // Turns on/off system protection
    // Is used for switching from widget
    func switchSystemProtectionFromWidget(state enabled: Bool, for VC: UIViewController?,isFromComplexSwitch: Bool)
    
    // Checks state of complex protection
    func checkState(completion: @escaping (Bool)->() )
    
    // Checks system protection state
    func getSystemProtectionState(completion:@escaping (Bool)->() )
    
    // Checks states of all protection modules
    func getAllStates(completion: @escaping (_ safari: Bool, _ system: Bool, _ complex: Bool)->())
}

// MARK: - Complex protection Delegate -

protocol ComplexProtectionDelegate {
    /**
     Method is called when safari protection status changes
     */
    func safariProtectionChanged()
    
    /**
     Method is called when trying to turn system protection on, and proStatus is false
     */
    func proStatusHandler()
}

// MARK: - Complex protection class -

class ComplexProtectionService: ComplexProtectionServiceProtocol{
    
    var delegate: ComplexProtectionDelegate?
    
    private let resources: AESharedResourcesProtocol
    private let safariService: SafariService
    private let configuration: ConfigurationService
    
    private let systemProtectionProcessor: TurnSystemProtectionProtocol
    
    private var proStatus: Bool {
        return configuration.proStatus
    }
    
    init(resources: AESharedResourcesProtocol, safariService: SafariService, systemProtectionProcessor: TurnSystemProtectionProtocol, configuration: ConfigurationService) {
        self.resources = resources
        self.safariService = safariService
        self.systemProtectionProcessor = systemProtectionProcessor
        self.configuration = configuration
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
                
                let safariEnabled = self.resources.safariProtectionEnabled
                self.saveLastStates(safariState: safariEnabled, systemState: systemEnabled)
                
                // Turning off safari and system protection
                self.switchSafariProtectionForComplex(state: enabled)
                if systemEnabled {
                    self.switchSystemProtectionForComplex(state: enabled, for: VC)
                }
            }
        } else {
            let statesTuple = getLastStates()
            
            let safariEnabledSaved = statesTuple.safariEnabled
            let systemEnabledSaved = statesTuple.systemEnabled
            
            /**
             If everything was turned off before disabling complex protection
             then we turning on just safari protection
             */
            if !(safariEnabledSaved || systemEnabledSaved){
                switchSafariProtectionForComplex(state: true)
            } else {
                /**
                 If last state of system protection was true and proStatus became false while complex protection was off
                 we turn on safari protection instead
                 */
                if safariEnabledSaved || (systemEnabledSaved && !proStatus){
                    switchSafariProtectionForComplex(state: true)
                }
                if systemEnabledSaved && proStatus {
                    switchSystemProtectionForComplex(state: systemEnabledSaved, for: VC)
                }
            }
        }
    }
    
    func switchSafariProtection(state enabled: Bool){
        resources.safariProtectionEnabled = enabled
       
        if !enabled {
            resources.sharedDefaults().set(enabled, forKey: SafariProtectionLastState)
        }
        safariInvalidateJson()
    }
    
    func switchSystemProtection(state enabled: Bool, for VC: UIViewController?) {
        if !proStatus {
            delegate?.proStatusHandler()
        } else {
            if !enabled {
               resources.sharedDefaults().set(enabled, forKey: SystemProtectionLastState)
            }
            systemProtectionProcessor.turnSystemProtection(to: enabled, with: VC, completion: {})
        }
    }
    
    func switchSystemProtectionFromWidget(state enabled: Bool, for VC: UIViewController?, isFromComplexSwitch: Bool) {
        if isFromComplexSwitch {
            switchSystemProtectionForComplex(state: enabled, for: VC)
        } else {
            switchSystemProtection(state: enabled, for: VC)
        }
    }
        
    /**
     Gets current System protection state and returns it in completion
     */
    func getSystemProtectionState(completion:@escaping (Bool)->() ) {
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
    
    // MARK: - Private methods
    
    /**
     When turning off complex protection state it is needed to save
     System and Safari protection last states to recover them
     */
    private func saveLastStates(safariState: Bool, systemState: Bool){
        resources.sharedDefaults().set(safariState, forKey: SafariProtectionLastState)
        resources.sharedDefaults().set(systemState, forKey: SystemProtectionLastState)
    }
    
    /**
     When turning on complex protection state it takes saved
     states and recovers them
     */
    private func getLastStates() -> (safariEnabled: Bool, systemEnabled: Bool){
        let safaryEnabled = resources.sharedDefaults().bool(forKey: SafariProtectionLastState)
        let systemEnabled = resources.sharedDefaults().bool(forKey: SystemProtectionLastState)
        
        return (safaryEnabled, systemEnabled)
    }
    
    /**
     This method invalidates blocking json
     */
    private func safariInvalidateJson(){
        safariService.invalidateBlockingJsons(completion: {[weak self] (error) in
            if error != nil {
                DDLogError("(ComplexProtectionService) Error invalidating json")
            } else {
                DDLogInfo("(ComplexProtectionService) Successfull invalidating of json")
            }
            self?.delegate?.safariProtectionChanged()
        })
    }
    
    /**
     We need to know where was a protection turned from
     This method is for complex protection interaction
     */
    private func switchSafariProtectionForComplex(state enabled: Bool){
        resources.safariProtectionEnabled = enabled
        safariInvalidateJson()
    }
    
    /**
    We need to know where was a protection turned from
    This method is for complex protection interaction
    */
    private func switchSystemProtectionForComplex(state enabled: Bool, for VC: UIViewController?){
        if !proStatus {
            delegate?.proStatusHandler()
        } else {
            systemProtectionProcessor.turnSystemProtection(to: enabled, with: VC, completion: {})
        }
    }
}
