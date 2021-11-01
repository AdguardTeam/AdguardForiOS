///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import NetworkExtension

enum VpnConfigurationState: CustomStringConvertible {
    case enabled, connecting, disconnecting, disabled

    var description: String {
        switch self {
        case .enabled: return "Enabled"
        case .connecting: return "Connecting"
        case .disconnecting: return "Disconnecting"
        case .disabled: return "Disabled"
        }
    }

    init(status: NEVPNStatus) {
        switch status {
        case .connected: self = .enabled
        case .disconnected: self = .disabled
        case .connecting: self = .connecting
        case .disconnecting: self = .disconnecting
        case .invalid: self = .disabled
        case .reasserting: self = .connecting
        @unknown default:
            DDLogError("Unknown NEVPNStatus case")
            self = .disabled
        }
    }
}

@objc
@objcMembers
class VpnConfigurationStatus: NSObject {
    let isInstalled: Bool /// true if configuration exists in System settings
    let isSelected: Bool /// Blue tick on our configuration
    let onDemandEnabled: Bool /// Connect on demand switch is on
    let connectionStatus: VpnConfigurationState /// Status is displayed on VPN settings screen

    var tunnelIsRunning: Bool { isSelected && connectionStatus == .enabled }
    var configurationIsActive: Bool { isSelected && onDemandEnabled }

    override var description: String { "isInstalled: \(isInstalled); isSelected: \(isSelected); onDemandEnabled: \(onDemandEnabled); connectionStatus: \(connectionStatus)" }

    init(isInstalled: Bool, isSelected: Bool, onDemandEnabled: Bool, connectionStatus: VpnConfigurationState) {
        self.isInstalled = isInstalled
        self.isSelected = isSelected
        self.onDemandEnabled = onDemandEnabled
        self.connectionStatus = connectionStatus
    }

    init(vpnManager: NEVPNManager?, isInstalled: Bool) {
        self.isInstalled = isInstalled
        self.isSelected = vpnManager?.isEnabled ?? false
        self.onDemandEnabled = vpnManager?.isOnDemandEnabled ?? false
        if let neVpnStatus = vpnManager?.connection.status {
            self.connectionStatus = VpnConfigurationState(status: neVpnStatus)
        } else {
            self.connectionStatus = .disabled
        }
    }
}
