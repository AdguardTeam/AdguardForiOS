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
import Reachability

open class PacketTunnelProvider: NEPacketTunnelProvider {
    
    public struct Addresses {
        let interfaceIpv4: String
        let interfaceIpv6: String
        let localDnsIpv4: String
        let localDnsIpv6: String
        let defaultSystemDnsServers: [String]
        
        public init(interfaceIpv4: String, interfaceIpv6: String, localDnsIpv4: String, localDnsIpv6: String, defaultSystemDnsServers: [String]) {
            self.interfaceIpv4 = interfaceIpv4
            self.interfaceIpv6 = interfaceIpv6
            self.localDnsIpv4 = localDnsIpv4
            self.localDnsIpv6 = localDnsIpv6
            self.defaultSystemDnsServers = defaultSystemDnsServers
        }
    }

    private let tunnelProxy: PacketTunnelProviderProxyProtocol
    private let reachabilityHandler: Reachability
    
    public init(
        userDefaults: UserDefaults,
        debugLoggs: Bool,
        dnsConfiguration: DnsConfigurationProtocol,
        addresses: Addresses,
        filterStorageUrl: URL,
        statisticsDbContainerUrl: URL
    ) throws {
        let userDefaultsStorage = UserDefaultsStorage(storage: userDefaults)
        let dnsProvidersManager = try DnsProvidersManager(configuration: dnsConfiguration, userDefaults: userDefaultsStorage)
        
        let filtersFileStorage = try FilterFilesStorage(filterFilesDirectoryUrl: filterStorageUrl)
        
        let filtersManager = DnsFiltersManager(
            userDefaults: userDefaultsStorage,
            filterFilesStorage: filtersFileStorage,
            configuration: dnsConfiguration
        )
        
        let proxySettingsProvider = DnsProxyConfigurationProvider(
            dnsProvidersManager: dnsProvidersManager,
            filtersManager: filtersManager,
            dnsConfiguration: dnsConfiguration
        )
        
        let dnsLibsRulesProvider = DnsLibsRulesProvider(
            dnsFiltersManager: filtersManager,
            filterFilesStorage: filtersFileStorage,
            configuration: dnsConfiguration
        )
        
        let dnsProxy = DnsProxy(
            proxySettingsProvider: proxySettingsProvider,
            dnsLibsRulesProvider: dnsLibsRulesProvider,
            statisticsDbContainerUrl: statisticsDbContainerUrl
        )

        let tunnelSettingsProvider = PacketTunnelSettingsProvider(addresses: addresses)
        
        self.tunnelProxy = PacketTunnelProviderProxy(
            isDebugLogs: debugLoggs,
            tunnelAddresses: addresses,
            dnsProxy: dnsProxy,
            dnsConfiguration: dnsConfiguration,
            tunnelSettings: tunnelSettingsProvider,
            providersManager: dnsProvidersManager
        )
        
        self.reachabilityHandler = try Reachability()
        
        super.init()

        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: nil) { [weak self] _ in
            self?.tunnelProxy.networkChanged()
        }

        Logger.logInfo("(PacketTunnelProvider) init finished")
    }

    // MARK: packet tunnel lifecycle

    public override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
        Logger.logInfo("(PacketTunnelProvider) startTunnel")

        do {
            try reachabilityHandler.startNotifier()
        }
        catch {
            Logger.logError("Reachability handler start error: \(error)")
            completionHandler(error)
            return
        }
        
        tunnelProxy.startTunnel(options: options, completionHandler: completionHandler)
    }

    public override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        Logger.logInfo("(PacketTunnelProvider) stopTunnel with reason: \(reason)")
        reachabilityHandler.stopNotifier()
        tunnelProxy.stopTunnel(with: reason, completionHandler: completionHandler)
    }

    public override func sleep(completionHandler: @escaping () -> Void) {
        Logger.logInfo("(PacketTunnelProvider) Sleep Event")
        tunnelProxy.sleep(completionHandler: completionHandler)
    }

    public override func wake() {
        Logger.logInfo("(PacketTunnelProvider) Wake Event")
        tunnelProxy.wake()
    }
}

// MARK: - PacketTunnelProvider + PacketTunnelProviderProxyDelegate

extension PacketTunnelProvider: PacketTunnelProviderProxyDelegate {
    func setTunnelSettings(_ settings: NETunnelNetworkSettings?, _ completionHandler: ((Error?) -> Void)?) {
        setTunnelNetworkSettings(settings, completionHandler: completionHandler)
    }
    
    func readPackets(completionHandler: @escaping ([Data], [NSNumber]) -> Void) {
        packetFlow.readPackets(completionHandler: completionHandler)
    }
    
    func writePackets(_ packets: [Data], _ protocols: [NSNumber]) {
        packetFlow.writePackets(packets, withProtocols: protocols)
    }
    
    func cancelTunnel(with error: Error?) {
        cancelTunnelWithError(error)
    }
}
