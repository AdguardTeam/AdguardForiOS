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

public protocol SafariProtectionConfigurationProtocol {
    // Application user configuration
    
    /* Shows if user has Premium app version */
    var proStatus: Bool { get }
    
    var safariProtectionEnabled: Bool { get }
    var blocklistIsEnabled: Bool { get }
    var allowlistIsEnbaled: Bool { get }
    var allowlistIsInverted: Bool { get }
    var updateOverWifiOnly: Bool { get set }
    
    /* Updates pro status in configuration and reloads content blockers */
    func update(proStatus: Bool, onProStatusUpdated: @escaping (_ error: Error?) -> Void)
    
    /* Updates Safari protection state and reloads content blockers */
    func update(safariProtectionEnabled: Bool, onSafariProtectionStateUpdated: @escaping (_ error: Error?) -> Void)
    
    /* Updates block list state and reloads content blockers */
    func update(blocklistIsEnabled: Bool, onBlocklistStateUpdated: @escaping (_ error: Error?) -> Void)
    
    /* Updates allow list state and reloads content blockers */
    func update(allowlistIsEnbaled: Bool, onAllowlistStateUpdated: @escaping (_ error: Error?) -> Void)
    
    /* Updates state of allowlist invertion and reloads content blockers */
    func update(allowlistIsInverted: Bool, onInvertionStateUpdated: @escaping (_ error: Error?) -> Void)
}

extension SafariProtection {
    public var proStatus: Bool {
        return workingQueue.sync { return configuration.proStatus }
    }
    
    public var safariProtectionEnabled: Bool {
        return workingQueue.sync { return configuration.safariProtectionEnabled }
    }
    
    public var blocklistIsEnabled: Bool {
        return workingQueue.sync { return configuration.blocklistIsEnabled }
    }
    
    public var allowlistIsEnbaled: Bool {
        return workingQueue.sync { return configuration.allowlistIsEnbaled }
    }
    
    public var allowlistIsInverted: Bool {
        return workingQueue.sync { return configuration.allowlistIsInverted }
    }
    
    public var updateOverWifiOnly: Bool {
        get {
            return workingQueue.sync { return configuration.updateOverWifiOnly }
        }
        set {
            workingQueue.sync {
                if newValue != updateOverWifiOnly {
                    configuration.updateOverWifiOnly = updateOverWifiOnly
                }
            }
        }
    }
    
    public func update(proStatus: Bool, onProStatusUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+Configuration) - update proStatus; self is missing!")
                DispatchQueue.main.async { onProStatusUpdated(CommonError.missingSelf) }
                return
            }
            
            Logger.logInfo("(SafariProtection+Configuration) - updateProStatus; Updating proStatus from=\(self.configuration.proStatus) to=\(proStatus)")
            
            guard self.configuration.proStatus != proStatus else {
                self.completionQueue.async { onProStatusUpdated(nil) }
                return
            }
            
            self.configuration.proStatus = proStatus
            self.reloadContentBlockers { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.proStatus.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onProStatusUpdated(CommonError.missingSelf) }
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateProStatus; Error reloading CBs when updating proStatus; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateProStatus; Successfully reloaded CBs after updating proStatus")
                }
                self.completionQueue.async { onProStatusUpdated(error) }
            }
        }
    }
    
    public func update(safariProtectionEnabled: Bool, onSafariProtectionStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+Configuration) - update.safariProtection; self is missing!")
                DispatchQueue.main.async { onSafariProtectionStateUpdated(CommonError.missingSelf) }
                return
            }
            
            Logger.logInfo("(SafariProtection+Configuration) - updateSafariProtection; Updating safariProtection from=\(self.configuration.safariProtectionEnabled) to=\(safariProtectionEnabled)")
            
            guard self.configuration.safariProtectionEnabled != safariProtectionEnabled else {
                self.completionQueue.async { onSafariProtectionStateUpdated(nil) }
                return
            }
            
            self.configuration.safariProtectionEnabled = safariProtectionEnabled
            self.reloadContentBlockers { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.safariProtection.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onSafariProtectionStateUpdated(CommonError.missingSelf) }
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateSafariProtection; Error reloading CBs when updating safariProtection; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateSafariProtection; Successfully reloaded CBs after updating safariProtection")
                }
                self.completionQueue.async { onSafariProtectionStateUpdated(error) }
            }
        }
    }
    
    public func update(blocklistIsEnabled: Bool, onBlocklistStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+Configuration) - update.blocklistIsEnabled; self is missing!")
                DispatchQueue.main.async { onBlocklistStateUpdated(CommonError.missingSelf) }
                return
            }
            
            Logger.logInfo("(SafariProtection+Configuration) - updateBlocklistIsEnabled; Updating blocklist state from=\(self.configuration.blocklistIsEnabled) to=\(blocklistIsEnabled)")
            
            guard self.configuration.blocklistIsEnabled != blocklistIsEnabled else {
                self.completionQueue.async { onBlocklistStateUpdated(nil) }
                return
            }
            
            self.configuration.blocklistIsEnabled = blocklistIsEnabled
            self.reloadContentBlockers { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.blocklistIsEnabled.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onBlocklistStateUpdated(CommonError.missingSelf) }
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateBlocklistIsEnabled; Error reloading CBs when updating blocklist state; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateBlocklistIsEnabled; Successfully reloaded CBs after updating blocklist state")
                }
                self.completionQueue.async { onBlocklistStateUpdated(error) }
            }
        }
    }
    
    public func update(allowlistIsEnbaled: Bool, onAllowlistStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+Configuration) - update.allowlistIsEnbaled; self is missing!")
                DispatchQueue.main.async { onAllowlistStateUpdated(CommonError.missingSelf) }
                return
            }
            
            Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsEnbaled; Updating allowlist state from=\(self.configuration.allowlistIsEnbaled) to=\(allowlistIsEnbaled)")
            guard self.configuration.allowlistIsEnbaled != allowlistIsEnbaled else {
                self.completionQueue.async { onAllowlistStateUpdated(nil) }
                return
            }
            
            self.configuration.allowlistIsEnbaled = allowlistIsEnbaled
            self.reloadContentBlockers { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.allowlistIsEnbaled.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onAllowlistStateUpdated(CommonError.missingSelf) }
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateAllowlistIsEnbaled; Error reloading CBs when updating allowlist state; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsEnbaled; Successfully reloaded CBs after updating allowlist state")
                }
                self.completionQueue.async { onAllowlistStateUpdated(error) }
            }
        }
    }
    
    public func update(allowlistIsInverted: Bool, onInvertionStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection+Configuration) - update.allowlistIsInverted; self is missing!")
                DispatchQueue.main.async { onInvertionStateUpdated(CommonError.missingSelf) }
                return
            }
            
            Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsInverted; Updating allowlist invertion state from=\(self.configuration.allowlistIsInverted) to=\(allowlistIsInverted)")
            
            guard self.configuration.allowlistIsInverted != allowlistIsInverted else {
                self.completionQueue.async { onInvertionStateUpdated(nil) }
                return
            }
            
            self.configuration.allowlistIsInverted = allowlistIsInverted
            self.reloadContentBlockers { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.allowlistIsInverted.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onInvertionStateUpdated(CommonError.missingSelf) }
                    return
                }
                
                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateAllowlistIsEnbaled; Error reloading CBs when updating allowlist invertion; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsEnbaled; Successfully reloaded CBs after updating allowlist invertion")
                }
                self.completionQueue.async { onInvertionStateUpdated(error) }
            }
        }
    }
}
