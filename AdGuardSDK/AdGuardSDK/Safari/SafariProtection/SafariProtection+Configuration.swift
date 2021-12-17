//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK

/// Application user configuration
public protocol SafariProtectionConfigurationProtocol {

    /// Shows if user has Premium app version
    var proStatus: Bool { get }

    /// State of the whole Safari protection. If it is false nothing will be filtered
    var safariProtectionEnabled: Bool { get }

    /// State of advanced protection. If it is true than there will be added extra rules for more precise safari blocking
    var advancedProtectionIsEnabled: Bool { get }

    /// State of the list that is responsible for blocking rules. In UI it is called User rules
    var blocklistIsEnabled: Bool { get }

    /// State of the list that is responsible for the rules that cancel blocklist rules actions
    var allowlistIsEnabled: Bool { get }

    /// Allowlist rules can be inverted. That means that blocklist rules will work on all sites except the sites from the inverted allowlist
    var allowlistIsInverted: Bool { get }

    /// Updates pro status in configuration and reloads content blockers
    func update(proStatus: Bool, onCbReloaded: ((_ error: Error?) -> Void)?)

    /// Updates Safari protection state and reloads content blockers
    func update(safariProtectionEnabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?)

    /// Updates Advanced protection state
    func update(advancedProtectionEnabled: Bool)

    /// Updates Advanced protection state and reloads content blockers
    func update(advancedProtectionEnabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?)

    /// Updates block list state and reloads content blockers
    func update(blocklistIsEnabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?)

    /// Updates allow list state and reloads content blockers
    func update(allowlistIsEnabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?)

    /// Updates state of allowlist invertion and reloads content blockers
    func update(allowlistIsInverted: Bool, onCbReloaded: ((_ error: Error?) -> Void)?)

    /// Update configuration with new one
    func updateConfig(with newConfig: SafariConfigurationProtocol)
}

/* Extension is used to properly process all configuration changes */
extension SafariProtection {
    public var proStatus: Bool {
        return workingQueue.sync { return configuration.proStatus }
    }

    public var safariProtectionEnabled: Bool {
        return workingQueue.sync { return configuration.safariProtectionEnabled }
    }

    public var advancedProtectionIsEnabled: Bool {
        return workingQueue.sync { return configuration.advancedBlockingIsEnabled }
    }

    public var blocklistIsEnabled: Bool {
        return workingQueue.sync { return configuration.blocklistIsEnabled }
    }

    public var allowlistIsEnabled: Bool {
        return workingQueue.sync { return configuration.allowlistIsEnabled }
    }

    public var allowlistIsInverted: Bool {
        return workingQueue.sync { return configuration.allowlistIsInverted }
    }

    public func update(proStatus: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateProStatus; Updating proStatus from=\(self.configuration.proStatus) to=\(proStatus)")

            executeBlockAndReloadCbs {
                if configuration.proStatus != proStatus {
                    configuration.proStatus = proStatus
                    return true
                } else {
                    return false
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.proStatus.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateProStatus; Error reloading CBs when updating proStatus; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateProStatus; Successfully reloaded CBs after updating proStatus")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func update(safariProtectionEnabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateSafariProtection; Updating safariProtection from=\(self.configuration.safariProtectionEnabled) to=\(safariProtectionEnabled)")

            executeBlockAndReloadCbs {
                if configuration.safariProtectionEnabled != safariProtectionEnabled {
                    configuration.safariProtectionEnabled = safariProtectionEnabled
                    return true
                } else {
                    return false
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.safariProtection.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateSafariProtection; Error reloading CBs when updating safariProtection; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateSafariProtection; Successfully reloaded CBs after updating safariProtection")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func update(advancedProtectionEnabled: Bool) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateAdvancedProtection; Updating updateAdvancedProtection from=\(self.configuration.advancedBlockingIsEnabled) to=\(advancedProtectionEnabled)")
            let result = updateInternal(advancedProtectionEnabled: advancedProtectionEnabled)
            Logger.logInfo("(SafariProtection+Configuration - updateAdvancedProtection; advancedProtection was updated = \(result)")
        }
    }

    public func update(advancedProtectionEnabled: Bool, onCbReloaded: ((Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateAdvancedProtection; Updating updateAdvancedProtection from=\(self.configuration.advancedBlockingIsEnabled) to=\(advancedProtectionEnabled)")

            executeBlockAndReloadCbs {
                return updateInternal(advancedProtectionEnabled: advancedProtectionEnabled)
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.advancedProtection.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateAdvancedProtection; Error reloading CBs when updating advancedProtection; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateAdvancedProtection; Successfully reloaded CBs after updating advancedProtection")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func update(blocklistIsEnabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateBlocklistIsEnabled; Updating blocklist state from=\(self.configuration.blocklistIsEnabled) to=\(blocklistIsEnabled)")

            executeBlockAndReloadCbs {
                if configuration.blocklistIsEnabled != blocklistIsEnabled {
                    configuration.blocklistIsEnabled = blocklistIsEnabled
                    return true
                } else {
                    return false
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.blocklistIsEnabled.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateBlocklistIsEnabled; Error reloading CBs when updating blocklist state; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateBlocklistIsEnabled; Successfully reloaded CBs after updating blocklist state")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func update(allowlistIsEnabled: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsEnabled; Updating allowlist state from=\(self.configuration.allowlistIsEnabled) to=\(allowlistIsEnabled)")

            executeBlockAndReloadCbs {
                if configuration.allowlistIsEnabled != allowlistIsEnabled {
                    configuration.allowlistIsEnabled = allowlistIsEnabled
                    return true
                } else {
                    return false
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.allowlistIsEnabled.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateAllowlistIsEnabled; Error reloading CBs when updating allowlist state; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsEnabled; Successfully reloaded CBs after updating allowlist state")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func update(allowlistIsInverted: Bool, onCbReloaded: ((_ error: Error?) -> Void)?) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsInverted; Updating allowlist invertion state from=\(self.configuration.allowlistIsInverted) to=\(allowlistIsInverted)")

            executeBlockAndReloadCbs {
                if configuration.allowlistIsInverted != allowlistIsInverted {
                    configuration.allowlistIsInverted = allowlistIsInverted
                    return true
                } else {
                    return false
                }
            } onCbReloaded: { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection+Configuration) - update.allowlistIsInverted.reloadContentBlockers; self is missing!")
                    DispatchQueue.main.async { onCbReloaded?(CommonError.missingSelf) }
                    return
                }

                if let error = error {
                    Logger.logError("(SafariProtection+Configuration) - updateAllowlistIsEnabled; Error reloading CBs when updating allowlist invertion; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection+Configuration) - updateAllowlistIsEnabled; Successfully reloaded CBs after updating allowlist invertion")
                }
                self.completionQueue.async { onCbReloaded?(error) }
            }
        }
    }

    public func updateConfig(with newConfig: SafariConfigurationProtocol) {
        workingQueue.sync {
            Logger.logInfo("(SafariProtection+Configuration) - updateConfig;")
            configuration.updateConfig(with: newConfig)
        }
    }

    // MARK: - Private methods

    private func updateInternal(advancedProtectionEnabled: Bool) -> Bool {
        if configuration.advancedBlockingIsEnabled != advancedProtectionEnabled {
            configuration.advancedBlockingIsEnabled = advancedProtectionEnabled
            return true
        } else {
            Logger.logInfo("(SafariProtection+Configuration) - updateInternalAdvancedProtection; Advanced protection hasn't been updated; reason - old value is equal to new value")
            return false
        }
    }
}
