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

import NetworkExtension

protocol PacketTunnelProviderProxyDelegate: AnyObject {
    func setTunnelSettings(_ settings: NETunnelNetworkSettings?, _ completionHandler: ((Error?) -> Void)?)
    func readPackets(completionHandler: @escaping ([Data], [NSNumber]) -> Void)
    func writePackets(_ packets: [Data], _ protocols: [NSNumber])
    func cancelTunnel(with error: Error?)
}

// MARK: - PacketTunnelProviderProxy

/// This methods are taken from `NEPacketTunnelProvider`, look it up for more information
protocol PacketTunnelProviderProxyProtocol: AnyObject {
    func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void)
    func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void)
    func sleep(completionHandler: @escaping () -> Void)
    func wake()
    func networkChanged()
}

/**
 Proxy is a design pattern, that perfectly fits it this case. You can find more info here https://refactoring.guru/design-patterns/proxy
 We use this tunnel proxy to be able to test tunnel behaviour
 */
final class PacketTunnelProviderProxy: PacketTunnelProviderProxyProtocol {
    
    weak var delegate: PacketTunnelProviderProxyDelegate?
    
    // MARK: - Private variables
    
    private var shouldProcessPackets = false
    private let readPacketsQueue = DispatchQueue(label: "DnsAdGuardSDK.PacketTunnelProviderProxy.readPacketsQueue")
    
    /* Services */
    private let tunnelAddresses: PacketTunnelProvider.Addresses
    private let dnsProxy: DnsProxyProtocol
    private let dnsConfiguration: DnsConfigurationProtocol
    private let tunnelSettings: PacketTunnelSettingsProviderProtocol
    private let providersManager: DnsProvidersManagerProtocol
    private let networkUtils: NetworkUtilsProtocol
    
    // MARK: - Initialization
    
    init(
        isDebugLogs: Bool,
        tunnelAddresses: PacketTunnelProvider.Addresses,
        dnsProxy: DnsProxyProtocol,
        dnsConfiguration: DnsConfigurationProtocol,
        tunnelSettings: PacketTunnelSettingsProviderProtocol,
        providersManager: DnsProvidersManagerProtocol,
        networkUtils: NetworkUtilsProtocol = NetworkUtils()
    ) {
        self.tunnelAddresses = tunnelAddresses
        self.dnsProxy = dnsProxy
        self.dnsConfiguration = dnsConfiguration
        self.tunnelSettings = tunnelSettings
        self.providersManager = providersManager
        self.networkUtils = networkUtils
        
        setupLogger(isDebugLogs: isDebugLogs)
    }
    
    // MARK: - Internal methods
    
    func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        startTunnel(completionHandler)
    }
    
    func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        stopPacketHanding()
        dnsProxy.stop {
            completionHandler()
        }
    }
    
    func sleep(completionHandler: @escaping () -> Void) {
        // Maybe we will use it, like we do in VPN
    }
    
    func wake() {
        // Maybe we will use it, like we do in VPN
    }
    
    func networkChanged() {
        let shouldRestartWhenNetworkChanges = dnsConfiguration.lowLevelConfiguration.restartByReachability
        Logger.logInfo("(PacketTunnelProviderProxy) - networkChanged; shouldRestartWhenNetworkChanges=\(shouldRestartWhenNetworkChanges)")
        guard !shouldRestartWhenNetworkChanges else { return }
        
        // Restart tunnel internally without reinitializing PacketTunnelProvider
        stopPacketHanding()
        dnsProxy.stop { [weak self] in
            self?.startTunnel { error in
                if let error = error {
                    Logger.logError("(PacketTunnelProviderProxy) - networkChanged; Error: \(error)")
                    self?.delegate?.cancelTunnel(with: error)
                } else {
                    Logger.logInfo("(PacketTunnelProviderProxy) - networkChanged; Successfully restarted tunnel after network change")
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    /// Starts tunnel. Returns error if occurred
    private func startTunnel(_ onTunnelStarted: @escaping (Error?) -> Void) {
        updateTunnelSettings { [weak self] result in
            guard let self = self else {
                let error = CommonError.missingSelf
                Logger.logError("(PacketTunnelProviderProxy) - startTunnel; Error: \(error)")
                onTunnelStarted(error)
                return
            }
            
            switch result {
            case .success(let systemDnsAddresses):
                let error = self.startDnsProxy(with: systemDnsAddresses)
                if error == nil {
                    self.startPacketHanding()
                }
                onTunnelStarted(error)
            case .error(let error):
                onTunnelStarted(error)
            }
        }
    }
    
    /// Updates tunnel settings. Returns system DNS addresses if success and error occurred otherwise
    private func updateTunnelSettings(_ onSettingsUpdated: @escaping (_ result: Result<[String]>) -> Void) {
        let lowLevelConfig = dnsConfiguration.lowLevelConfiguration
        
        // Check if user's already provided all needed settings
        if lowLevelConfig.fallbackServers?.count ?? 0 > 0,
           lowLevelConfig.bootstrapServers?.count ?? 0 > 0,
           providersManager.activeDnsServer.upstreams.count > 0 {
            Logger.logInfo("(PacketTunnelProviderProxy) - updateTunnelSettings; All settings we need are set by the user, starting tunnel now")
            
            // Setting tunnel settings
            setTunnelSettings { error in
                if let error = error {
                    onSettingsUpdated(.error(error))
                } else {
                    onSettingsUpdated(.success([]))
                }
            }
            return
        }
        
        Logger.logInfo("(PacketTunnelProviderProxy) - updateTunnelSettings; Upstreams or fallbacks are not set by the user. Get system DNS now")
        
        // Setting empty settings to read system DNS servers
        // If we don't set them we wil be unable to read system DNS servers
        // and will be reading servers that we did set previously
        delegate?.setTunnelSettings(nil) { error in
            if let error = error {
                Logger.logError("(PacketTunnelProviderProxy) - updateTunnelSettings; Error setting empty settings; Error: \(error)")
                onSettingsUpdated(.error(error))
                return
            } else {
                Logger.logInfo("(PacketTunnelProviderProxy) - updateTunnelSettings; Successfully set empty settings")
            }
        
            // https://github.com/AdguardTeam/AdguardForiOS/issues/1499
            // sometimes we get empty list of system dns servers.
            // Here we add a pause after setting the empty settings.
            // Perhaps this will eliminate the situation with an empty dns list
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                
                // Reading system DNS servers with empty tunnel settings
                let systemIps = self?.networkUtils.systemDnsServers ?? []
                
                // Setting tunnel settings when system DNS servers obtained
                self?.setTunnelSettings { error in
                    if let error = error {
                        onSettingsUpdated(.error(error))
                    } else {
                        onSettingsUpdated(.success(systemIps))
                    }
                }
            }
        }
    }
    
    /// Sets tunnel settings based on user settings
    private func setTunnelSettings(_ onSettingsSet: @escaping (Error?) -> Void) {
        // Get tunnel mode user did select
        let tunnelMode = dnsConfiguration.lowLevelConfiguration.tunnelMode
        Logger.logInfo("(PacketTunnelProviderProxy) - setTunnelSettings; Start with tunnelMode=\(tunnelMode)")
        
        let full = tunnelMode != .split
        let withoutIcon = tunnelMode == .fullWithoutVpnIcon
        
        // Create tunnel settings based on user settings
        let tunnelSettings = tunnelSettings.createSettings(full: full, withoutVpnIcon: withoutIcon)
        
        // Tell tunnel to set new tunnel settings
        delegate?.setTunnelSettings(tunnelSettings) { error in
            if let error = error {
                Logger.logError("(PacketTunnelProviderProxy) - setTunnelSettings; Error setting settings=\(tunnelSettings); Error: \(error)")
            } else {
                Logger.logInfo("(PacketTunnelProviderProxy) - setTunnelSettings; Successfully set settings=\(tunnelSettings)")
            }
            onSettingsSet(error)
        }
    }
    
    /// Starts DNS-lib proxy. Returns error if occurred or nil otherwise
    private func startDnsProxy(with systemDnsAddresses: [String]) -> Error? {
        let systemUpstreams = getSystemDnsAddresses(systemDnsAddresses)
        return dnsProxy.start(systemUpstreams)
    }
    
    /// Initializes DNS-lib logger
    private func setupLogger(isDebugLogs: Bool) {
        AGLogger.setLevel(isDebugLogs ? .AGLL_DEBUG : .AGLL_WARN )
        AGLogger.setCallback { msg, size in
            if let msg = msg {
                Logger.logInfo("(DnsLibs) -> \(String(cString: msg))")
            }
        }
    }
    
    /// Returns `DnsUpstream` objects from system DNS servers
    private func getSystemDnsAddresses(_ systemDnsAddresses: [String]) -> [DnsUpstream] {
        var systemServers = systemDnsAddresses
        if systemServers.isEmpty {
            systemServers = tunnelAddresses.defaultSystemDnsServers
        }
        let networkUtils = NetworkUtils()
        return systemServers.map {
            let prot = try? networkUtils.getProtocol(from: $0)
            return DnsUpstream(upstream: $0, protocol: prot ?? .dns)
        }
    }
    
    /// Starts processing packets
    private func startPacketHanding() {
        readPacketsQueue.async { [weak self] in
            self?.shouldProcessPackets = true
            self?.delegate?.readPackets { [weak self] packets, protocols in
                self?.handlePackets(packets, protocols)
            }
        }
    }
    
    /// Stops processing packets
    private func stopPacketHanding() {
        readPacketsQueue.async { [weak self] in
            self?.shouldProcessPackets = false
        }
    }
    
    /// Processes passed packets with DNS-lib, writes them if response is received
    private func handlePackets(_ packets: [Data], _ protocols: [NSNumber]) {
        for (index, packet) in packets.enumerated() {
            dnsProxy.resolve(dnsRequest: packet) { [weak self] reply in
                if reply != nil {
                    self?.delegate?.writePackets([packet], [protocols[index]])
                }
            }
        }

        delegate?.readPackets { [weak self] packets, protocols in
            if self?.shouldProcessPackets == true {
                self?.handlePackets(packets, protocols)
            }
        }
    }
}
