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

protocol MainPageProtectionModelDelegate: AnyObject {
    func protectionStateChanged()
    
    /* Safari protection events */
    func safariProtectionStateUpdateStarted()
    func safariProtectionStateUpdateFinished(withError error: Error?)
    
    /* System protection events */
    func systemProtectionStateUpdateStarted()
    func systemProtectionStateUpdateFinished(withError error: Error?)
    
    /* Complex protection events */
    func complexProtectionStateUpdateStarted()
    func complexProtectionStateUpdateFinished(_ safariError: Error?, _ systemError: Error?)
}

protocol MainPageProtectionModelProtocol: AnyObject {
    /* Protection icons visibility status */
    var visibleProtectionButtons: MainPageProtectionModel.VisibleProtectionButtons { get set }
    
    /* All protections actual states, all changes are pushed through delegate */
    var protection: MainPageProtectionModel.Protection { get }
    
    /* True if safari or system protection are in process of update */
    var protectionsAreUpdating: Bool { get }
    
    /* Enables or disables Safari protection */
    func turnSafariProtection(to state: Bool) throws
    
    /* Enables or disables System protection */
    func turnSystemProtection(to state: Bool, for VC: UIViewController) throws
    
    /* Enables or disables Complex protection */
    func turnComplexPtotection(to state: Bool, for VC: UIViewController) throws
    
    /* Checks protections actual states, notifies about changes through delegate */
    func checkProtectionsState()
}

final class MainPageProtectionModel: MainPageProtectionModelProtocol {
    
    // MARK: - Public properties
    
    weak var delegate: MainPageProtectionModelDelegate?
    
    var visibleProtectionButtons = VisibleProtectionButtons()
    
    var protectionsAreUpdating: Bool { safariProtectionIsUpdating || systemProtectionIsUpdating || complexProtectionIsUpdating }
    
    var protection: Protection {
        didSet {
            if oldValue != protection {
                delegate?.protectionStateChanged()
            }
        }
    }
    
    // MARK: - Private properties
    
    /* Helper variables */
    private var safariProtectionIsUpdating = false
    private var systemProtectionIsUpdating = false
    private var complexProtectionIsUpdating = false
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    private let complexProtection: ComplexProtectionServiceProtocol
    private let nativeProviders: NativeProvidersServiceProtocol
    
    /* Observers */
    private var appWillEnterForegroundObserver: NotificationToken?
    private var systemProtectionObserver: NotificationToken?
    
    // MARK: - Initialization
    
    init(resources: AESharedResourcesProtocol, complexProtection: ComplexProtectionServiceProtocol, nativeProviders: NativeProvidersServiceProtocol) {
        self.resources = resources
        self.complexProtection = complexProtection
        self.nativeProviders = nativeProviders
        self.protection = Protection(safariProtectionEnabled: complexProtection.safariProtectionEnabled,
                                     systemProtectionEnabled: complexProtection.systemProtectionEnabled,
                                     vpnProtectionEnabled: UIApplication.adGuardVpnIsActive)
        
        addObservers()
    }
    
    // MARK: - Public methods
    
    func turnSafariProtection(to state: Bool) throws {
        DDLogDebug("(MainPageProtectionModel) - Turning Safari protection to \(state); current state = \(complexProtection.safariProtectionEnabled)")
        guard complexProtection.safariProtectionEnabled != state else {
            throw MainPageProtectionModelError.safariStateError
        }
        
        safariProtectionIsUpdating = true
        delegate?.safariProtectionStateUpdateStarted()
        
        complexProtection.switchSafariProtection(state: state, for: nil) { error in
            DispatchQueue.main.async { [weak self] in
                let newSafariState = self?.complexProtection.safariProtectionEnabled ?? false
                DDLogDebug("(MainPageProtectionModel) - Safari protection update finished with error: \(error.debugDescription); New state = \(newSafariState)")
                self?.protection.safariProtectionEnabled = newSafariState
                self?.safariProtectionIsUpdating = false
                self?.delegate?.safariProtectionStateUpdateFinished(withError: error)
            }
        }
    }
    
    func turnSystemProtection(to state: Bool, for VC: UIViewController) throws {
        DDLogDebug("(MainPageProtectionModel) - Turning System protection to \(state); current state = \(complexProtection.systemProtectionEnabled)")
        guard complexProtection.systemProtectionEnabled != state else {
            throw MainPageProtectionModelError.systemStateError
        }
        
        systemProtectionIsUpdating = true
        delegate?.systemProtectionStateUpdateStarted()
        
        var resultError: Error?
        let group = DispatchGroup()
        group.enter()
        
        if resources.dnsImplementation == .native {
            if #available(iOS 14.0, *) {
                if !state {
                    nativeProviders.removeDnsManager { error in
                        DDLogError("Error removing dns manager: \(error.debugDescription)")
                        resultError = error
                        group.leave()
                    }
                } else {
                    nativeProviders.saveDnsManager { error in
                        DDLogError("Received error when turning system protection on; Error: \(error.debugDescription)")
                        resultError = error
                        group.leave()
                        DispatchQueue.main.async {
                            AppDelegate.shared.presentHowToSetupController()
                        }
                    }
                }
                throw MainPageProtectionModelError.nativeImplementationError
            } else { group.leave() }
        } else {
            complexProtection.switchSystemProtection(state: state, for: VC) { error in
                DDLogDebug("(MainPageProtectionModel) - System protection update finished with error: \(error.debugDescription)")
                resultError = error
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.protection.systemProtectionEnabled = self?.complexProtection.systemProtectionEnabled ?? false
            self?.systemProtectionIsUpdating = false
            self?.delegate?.systemProtectionStateUpdateFinished(withError: resultError)
        }
    }
    
    func turnComplexPtotection(to state: Bool, for VC: UIViewController) throws {
        DDLogDebug("(MainPageProtectionModel) - Turning Complex protection to \(state); current state = \(complexProtection.complexProtectionEnabled)")
        guard complexProtection.complexProtectionEnabled != state else {
            throw MainPageProtectionModelError.complexStateError
        }
        
        complexProtectionIsUpdating = true
        delegate?.complexProtectionStateUpdateStarted()
        
        complexProtection.switchComplexProtection(state: state, for: VC) { safariError, systemError in
            DispatchQueue.main.async { [weak self] in
                let newSafariState = self?.complexProtection.safariProtectionEnabled ?? false
                let newSystemState = self?.complexProtection.systemProtectionEnabled ?? false
                DDLogDebug("(MainPageProtectionModel) - Complex protection update finished with safari error: \(safariError.debugDescription); system error: \(systemError.debugDescription)")
                DDLogDebug("(MainPageProtectionModel) - Safari state = \(newSafariState); System state = \(newSystemState)")
                self?.protection = Protection(safariProtectionEnabled: newSafariState, systemProtectionEnabled: newSystemState, vpnProtectionEnabled: UIApplication.adGuardVpnIsActive)
                self?.complexProtectionIsUpdating = false
                self?.delegate?.complexProtectionStateUpdateFinished(safariError, systemError)
            }
        }
    }
    
    func checkProtectionsState() {
        let currentSafariState = complexProtection.safariProtectionEnabled
        let currentSystemState = complexProtection.systemProtectionEnabled
        let currentVpnState = UIApplication.adGuardVpnIsActive
        protection = Protection(safariProtectionEnabled: currentSafariState, systemProtectionEnabled: currentSystemState, vpnProtectionEnabled: currentVpnState)
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        /* Check AdGuard VPN status upon each app entry */
        appWillEnterForegroundObserver = NotificationCenter.default.observe(name: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
            self?.protection.vpnProtectionEnabled = UIApplication.adGuardVpnIsActive
        }
        
        systemProtectionObserver = NotificationCenter.default.observe(name: ComplexProtectionService.systemProtectionChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.protection.systemProtectionEnabled = self?.complexProtection.systemProtectionEnabled ?? false
        }
    }
}

// MARK: - MainPageProtectionModel + Protection

extension MainPageProtectionModel {
    struct Protection: Equatable {
        var safariProtectionEnabled: Bool
        var systemProtectionEnabled: Bool
        var vpnProtectionEnabled: Bool
        var complexProtectionEnabled: Bool { safariProtectionEnabled || systemProtectionEnabled }
        
        var protectionState: String {
            if safariProtectionEnabled || systemProtectionEnabled {
                return String.localizedString("protection_enabled_caption")
            } else {
                return String.localizedString("protection_disabled_caption")
            }
        }
        
        var protectionStatus: String {
            switch (safariProtectionEnabled, systemProtectionEnabled) {
            case (true, true): return String.localizedString("complex_enabled")
            case (false, false): return String.localizedString("complex_disabled")
            case (true, false): return String.localizedString("safari_enabled")
            case (false, true): return String.localizedString("system_enabled")
            }
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.safariProtectionEnabled == rhs.safariProtectionEnabled &&
                   lhs.systemProtectionEnabled == rhs.systemProtectionEnabled &&
                   lhs.vpnProtectionEnabled == rhs.vpnProtectionEnabled
        }
    }
}

// MARK: - MainPageProtectionModel + VisibleProtectionButtons

extension MainPageProtectionModel {
    struct VisibleProtectionButtons {
        var safariProtectionIsVisible: Bool = true
        var systemProtectionIsVisible: Bool = true
        var vpnProtectionIsVisible: Bool = true
    }
}

// MARK: - MainPageProtectionModel + MainPageProtectionModelError

extension MainPageProtectionModel {
    enum MainPageProtectionModelError: Error, CustomDebugStringConvertible, LocalizedError {
        case safariStateError
        case systemStateError
        case nativeImplementationError
        case complexStateError
        
        var debugDescription: String {
            switch self {
            case .safariStateError: return "Trying to modify Safari protection with the same state"
            case .systemStateError: return "Trying to modify System protection with the same state"
            case .nativeImplementationError: return "Native implementation should be enabled manually"
            case .complexStateError: return "Trying to modify Complex protection with the same state"
            }
        }
        
        var errorDescription: String? { debugDescription }
    }
}
