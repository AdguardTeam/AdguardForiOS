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
