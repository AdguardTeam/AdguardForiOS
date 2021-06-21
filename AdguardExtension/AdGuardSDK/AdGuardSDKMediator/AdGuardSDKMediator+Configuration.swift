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

public protocol AdGuardSDKMediatorConfigurationProtocol {
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

extension AdGuardSDKMediator: AdGuardSDKMediatorConfigurationProtocol {
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
        workingQueue.async { [unowned self] in
            Logger.logInfo("(AdGuardSDKMediator) - updateProStatus; Updating proStatus from=\(configuration.proStatus) to=\(proStatus)")
            guard configuration.proStatus != proStatus else {
                completionQueue.async { onProStatusUpdated(nil) }
                return
            }
            
            configuration.proStatus = proStatus
            reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - updateProStatus; Error reloading CBs when updating proStatus; Error: \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - updateProStatus; Successfully reloaded CBs after updating proStatus")
                }
                completionQueue.async { onProStatusUpdated(error) }
            }
        }
    }
    
    public func update(safariProtectionEnabled: Bool, onSafariProtectionStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [unowned self] in
            Logger.logInfo("(AdGuardSDKMediator) - updateSafariProtection; Updating safariProtection from=\(configuration.safariProtectionEnabled) to=\(safariProtectionEnabled)")
            guard configuration.safariProtectionEnabled != safariProtectionEnabled else {
                completionQueue.async { onSafariProtectionStateUpdated(nil) }
                return
            }
            
            configuration.safariProtectionEnabled = safariProtectionEnabled
            reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - updateSafariProtection; Error reloading CBs when updating safariProtection; Error: \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - updateSafariProtection; Successfully reloaded CBs after updating safariProtection")
                }
                completionQueue.async { onSafariProtectionStateUpdated(error) }
            }
        }
    }
    
    public func update(blocklistIsEnabled: Bool, onBlocklistStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [unowned self] in
            Logger.logInfo("(AdGuardSDKMediator) - updateBlocklistIsEnabled; Updating blocklist state from=\(configuration.blocklistIsEnabled) to=\(blocklistIsEnabled)")
            guard configuration.blocklistIsEnabled != blocklistIsEnabled else {
                completionQueue.async { onBlocklistStateUpdated(nil) }
                return
            }
            
            configuration.blocklistIsEnabled = blocklistIsEnabled
            reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - updateBlocklistIsEnabled; Error reloading CBs when updating blocklist state; Error: \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - updateBlocklistIsEnabled; Successfully reloaded CBs after updating blocklist state")
                }
                completionQueue.async { onBlocklistStateUpdated(error) }
            }
        }
    }
    
    public func update(allowlistIsEnbaled: Bool, onAllowlistStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [unowned self] in
            Logger.logInfo("(AdGuardSDKMediator) - updateAllowlistIsEnbaled; Updating allowlist state from=\(configuration.allowlistIsEnbaled) to=\(allowlistIsEnbaled)")
            guard configuration.allowlistIsEnbaled != allowlistIsEnbaled else {
                completionQueue.async { onAllowlistStateUpdated(nil) }
                return
            }
            
            configuration.allowlistIsEnbaled = allowlistIsEnbaled
            reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - updateAllowlistIsEnbaled; Error reloading CBs when updating allowlist state; Error: \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - updateAllowlistIsEnbaled; Successfully reloaded CBs after updating allowlist state")
                }
                completionQueue.async { onAllowlistStateUpdated(error) }
            }
        }
    }
    
    public func update(allowlistIsInverted: Bool, onInvertionStateUpdated: @escaping (Error?) -> Void) {
        workingQueue.async { [unowned self] in
            Logger.logInfo("(AdGuardSDKMediator) - updateAllowlistIsInverted; Updating allowlist invertion state from=\(configuration.allowlistIsInverted) to=\(allowlistIsInverted)")
            guard configuration.allowlistIsInverted != allowlistIsInverted else {
                completionQueue.async { onInvertionStateUpdated(nil) }
                return
            }
            
            configuration.allowlistIsInverted = allowlistIsInverted
            reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - updateAllowlistIsEnbaled; Error reloading CBs when updating allowlist invertion; Error: \(error)")
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - updateAllowlistIsEnbaled; Successfully reloaded CBs after updating allowlist invertion")
                }
                completionQueue.async { onInvertionStateUpdated(error) }
            }
        }
    }
}
