
import Foundation

class VpnManagerMock: NSObject, APVPNManagerProtocol {
    
    // MARK: - Variables to test functions execution
    
    var restartTunnelWasCalledCount = 0
    
    var networkingSettings: NetworkSettingsServiceProtocol?
    
    var providers: [DnsProviderInfo] = [DnsProviderInfo]()
    
    var activeDnsServer: DnsServerInfo?
    
    var activeDnsProvider: DnsProviderInfo?
    
    var connectionStatus: APVpnConnectionStatus = APVpnConnectionStatusConnected
    
    var lastError: Error?
    
    var enabled: Bool = true
    
    var tunnelMode: APVpnManagerTunnelMode = APVpnManagerTunnelModeSplit
    
    var restartByReachability: Bool = true
    
    var vpnInstalled: Bool = true
    
    func addRemoteDnsServer(_ name: String, upstreams: [String]) -> Bool {
        return true
    }
    
    func deleteCustomDnsProvider(_ provider: DnsProviderInfo) -> Bool {
        return true
    }
    
    func resetCustomDnsProvider(_ provider: DnsProviderInfo) -> Bool {
        return true
    }
    
    func restartTunnel() {
        restartTunnelWasCalledCount += 1
    }
    
    func isActiveProvider(_ provider: DnsProviderInfo) -> Bool {
        return true
    }
    
    func isCustomProvider(_ provider: DnsProviderInfo) -> Bool {
        return true
    }
    
    func isCustomServer(_ server: DnsServerInfo) -> Bool {
        return true
    }
    
    func isCustomServerActive() -> Bool {
        return true
    }
    
    func removeVpnConfiguration() {
        
    }
    
    var delayedTurn: (() -> Void)?
    
    var managerWasLoaded: Bool = true

}
