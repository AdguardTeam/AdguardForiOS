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
    
    private let reachabilityHandler: Reachability
    private let dnsProxy: DnsProxyServiceProtocol
    private var providersManager: DnsProvidersManager
    private let dnsFilters: DnsFiltersManagerProtocol
    private let configuration: DnsConfigurationProtocol

    private let readPacketsQueue = DispatchQueue(label: "packettunnel.read.packets")
    private var shouldProcessPackets = false

    // settings
    private var currentServer: DnsServerMetaProtocol?
    private var currentProvider: DnsProviderMetaProtocol?
    private var tunnelMode: TunnelMode?
    private var restartByReachability: Bool?
    private var addresses: Addresses

    public init(userDefaults: UserDefaults, debugLoggs: Bool, dnsConfiguration: DnsConfigurationProtocol, addresses: Addresses, filterStorageUrl: URL, statisticsDbContainerUrl: URL) throws {

        self.configuration = dnsConfiguration
        self.addresses = addresses
        let userDefaultsStorage = UserDefaultsStorage(storage: userDefaults)

        // init dns libs logger
        AGLogger.setLevel( debugLoggs ? .AGLL_DEBUG : .AGLL_WARN )
        AGLogger.setCallback { msg, size in
            if let msg = msg {
                Logger.logInfo("(DnsLibs) \(String(cString: msg))")
            }
        }
    
        // dnsProviders manager
        providersManager = try DnsProvidersManager(configuration: dnsConfiguration, userDefaults: userDefaultsStorage)
        let filtersStorage = try FilterFilesStorage(filterFilesDirectoryUrl: filterStorageUrl)
        dnsFilters = DnsFiltersManager(userDefaults: userDefaultsStorage, filterFilesStorage: filtersStorage, configuration: dnsConfiguration)

        // init dnsProxy
        let rulesProvider = DnsLibsRulesProvider(dnsFiltersManager: dnsFilters, filterFilesStorage: filtersStorage, configuration: dnsConfiguration)
        
        let activityStatistics = try ActivityStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        let chartsStatistics = try ChartStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        let logStatistics = try DnsLogStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        let eventHandler = DnsRequestProcessedEventHandler(providersManager: providersManager, dnsLibsRulesProvider: rulesProvider, activityStatistics: activityStatistics, chartStatistics: chartsStatistics, dnsLogStatistics: logStatistics)
        dnsProxy = DnsProxyService(eventHandler: eventHandler, dnsProvidersManager: providersManager)

        // init reachability
        reachabilityHandler = try Reachability()
        
        super.init()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.reachabilityChanged, object: self, queue: nil) { [weak self]note in
            self?.reachNotify()
        }

        Logger.logInfo("(PacketTunnelProvider) init finished")
    }

    // MARK: packet tunnel lifecycle

    public override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {

        Logger.logInfo("(PacketTunnelProvider) startTunnel ")

        do {
            try reachabilityHandler.startNotifier()
        }
        catch {
            Logger.logError("eachability handler start error: \(error)")
        }

        self.upadateSettings { [weak self] (systemDnsIps) in
            self?.startPacketHandling()
            self?.startDnsProxy(systemDnsIps: systemDnsIps)
            completionHandler(nil)
        }
    }

    public override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {

        Logger.logInfo("(PacketTunnelProvider) stopTunnel with reason: \(reason)")

        reachabilityHandler.stopNotifier()
        self.stopPacketHandling()
        dnsProxy.stop {
            completionHandler()
        }
    }

    public override func sleep(completionHandler: @escaping () -> Void) {
        Logger.logInfo("(PacketTunnelProvider) Sleep Event")
        completionHandler()
    }

    public override func wake() {
        Logger.logInfo("(PacketTunnelProvider) Wake Event")
    }

    // MARK: - private methods -

    // MARK: handle packets cycle

    private func startPacketHandling() {
        readPacketsQueue.async { [weak self] in
            self?.shouldProcessPackets = true
            self?.packetFlow.readPackets { packets, protocols in
                self?.handlePackets(packets, protocols)
            }
        }
    }

    private func stopPacketHandling() {
        readPacketsQueue.async { [weak self] in
            self?.shouldProcessPackets = false
        }
    }

    private func handlePackets(_ packets: [Data], _ protocols: [NSNumber]) {
        for (index, packet) in packets.enumerated() {
            dnsProxy.resolve(dnsRequest: packet) { [weak self] reply in
                if reply != nil {
                    self?.packetFlow.writePackets([packet], withProtocols: [protocols[index]])
                }
            }
        }

        self.packetFlow.readPackets { [weak self] packets, protocols in
            if self?.shouldProcessPackets == true {
                self?.handlePackets(packets, protocols)
            }
        }
    }

    // MARK: dns proxy

    private func startDnsProxy(systemDnsIps: [String]) {
        Logger.logInfo("(PacketTunelProvider) - startDnsProxy ")

        var systemServers = systemDnsIps

        if systemDnsIps.count == 0 {
            Logger.logError("(PacketTunnelProvider) - startDnsProxy error. There is no system dns servers")
            systemServers = addresses.defaultSystemDnsServers
        }

        let upstreams = currentServer != nil && currentServer!.upstreams.count > 0 ? currentServer?.upstreams.map{ $0.upstream } : systemServers

        let network = NetworkUtils()
        let ipv6Available = network.isIpv6Available

        let userfilterId = DnsUserRuleType.blocklist.enabledRulesFilterId
        let whitelistFilterId = DnsUserRuleType.allowlist.enabledRulesFilterId

        let serverName = currentProvider?.name ?? "Default"
        
        // low level settings

        let customFallbacks = configuration.lowLevelConfiguration.fallbackServers
        let customBootstraps = configuration.lowLevelConfiguration.bootstrapServers
        let blockingMode = configuration.lowLevelConfiguration.blockingMode
        let blockedTtl = configuration.lowLevelConfiguration.blockedTtl

        let rulesBlockingMode: AGBlockingMode
        let hostsBlockingMode: AGBlockingMode

        switch blockingMode {
        case .`default`:
            rulesBlockingMode = AGDnsProxyConfig.getDefault().adblockRulesBlockingMode
            hostsBlockingMode = AGDnsProxyConfig.getDefault().hostsRulesBlockingMode
        case .refused:
            rulesBlockingMode = .AGBM_REFUSED
            hostsBlockingMode = .AGBM_REFUSED
        case .nxdomain:
            rulesBlockingMode = .AGBM_NXDOMAIN
            hostsBlockingMode = .AGBM_NXDOMAIN
        case .unspecifiedAddress:
            rulesBlockingMode = .AGBM_ADDRESS
            hostsBlockingMode = .AGBM_ADDRESS
        case .customAddress:
            rulesBlockingMode = .AGBM_ADDRESS
            hostsBlockingMode = .AGBM_ADDRESS
        }

        let customBlockingIp: [String]
        var customBlockingIpv4: String?
        var customBlockingIpv6: String?

        if rulesBlockingMode == .AGBM_ADDRESS {
            if blockingMode == .unspecifiedAddress || configuration.lowLevelConfiguration.blockingIp == nil {
                customBlockingIp = ["0.0.0.0", "::"]
            }
            else {
                customBlockingIp = configuration.lowLevelConfiguration.blockingIp!
            }
        }
        else {
            customBlockingIp = ["0.0.0.0", "::"]
        }

        for ip in customBlockingIp {
            if ACNUrlUtils.isIPv4(ip) {
                customBlockingIpv4 = ip
            }
            else if ACNUrlUtils.isIPv6(ip) {
                customBlockingIpv6 = ip
            }
        }

        let blockIpv6 = configuration.lowLevelConfiguration.blockIpv6

        dnsProxy.start(upstreams: upstreams ?? [],
                       bootstrapDns: customBootstraps ?? [],
                       fallbacks: customFallbacks ?? [],
                       serverName: serverName,
                       filtersManager: dnsFilters,
                       userFilterId: userfilterId,
                       whitelistFilterId: whitelistFilterId,
                       ipv6Available: ipv6Available,
                       rulesBlockingMode: rulesBlockingMode,
                       hostsBlockingMode: hostsBlockingMode,
                       blockedResponseTtlSecs: blockedTtl,
                       customBlockingIpv4: customBlockingIpv4,
                       customBlockingIpv6: customBlockingIpv6,
                       blockIpv6: blockIpv6)
    }

    // MARK: tunnel settings

    private func updateTunnelSettings(completion: @escaping (Error?, [String])->Void) {
        self.readSettings()

        if configuration.lowLevelConfiguration.fallbackServers?.count ?? 0 > 0 &&
            configuration.lowLevelConfiguration.bootstrapServers?.count ?? 0 > 0 &&
            currentServer?.upstreams.count ?? 0 > 0 {
            Logger.logInfo("We don't need to read system settings")

            self.updateTunnelSettingsInternal { error in
                completion(error, [])
            }
            return
        }

        Logger.logInfo("ustom bootrap or fallback server is not set -> Set empty tunnel settings")

        self.setTunnelNetworkSettings(nil) { error in
            if error != nil {
                Logger.logError("updateTunnelSettings - set empty settings error: \(error!)")
            }
            else {
                Logger.logInfo("updateTunnelSettings - empty settings is set")
            }

            // https://github.com/AdguardTeam/AdguardForiOS/issues/1499
            // sometimes we get empty list of system dns servers.
            // Here we add a pause after setting the empty settings.
            // Perhaps this will eliminate the situation with an empty dns list

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                let network = NetworkUtils()
                let systemIps = network.systemDnsServers
                self?.updateTunnelSettingsInternal { (error) in
                    completion(error, systemIps)
                }
            }
        }
    }

    private func updateTunnelSettingsInternal(completion: @escaping (Error?)->Void) {
        Logger.logInfo("updateTunnelSettingsInternal")

        let full = tunnelMode != .split
        let withoutIcon = tunnelMode == .fullWithoutVpnIcon
        let modeName = tunnelMode?.name ?? "none"

        Logger.logInfo("Start Tunnel mode: \(modeName)")

        let builder = PacketTunnelProviderSettingsBuilder(addresses: addresses)
        let settings = builder.createSettings(full: full, wihoutVPNIcon: withoutIcon)
        self.setTunnelNetworkSettings(settings) { error in
            if error != nil {
                Logger.logError("setTunnelNetworkSettings error \(error!)")
            }

            completion(error)
        }
    }

    // MARK: other private methods

    private func upadateSettings(completion: @escaping ([String])->Void) {
        dnsProxy.stop { [weak self] in
            Logger.logInfo("(PacketTunnelProvider) updateSettings - update tunnel settings")
            self?.updateTunnelSettings { error, systemDnsIps in
                if error != nil {
                    Logger.logError("upadateSettings error - \(error!)")
                }
                try? self?.reachabilityHandler.startNotifier()
                self?.startDnsProxy(systemDnsIps: systemDnsIps)
            }
        }
    }

    private func readSettings() {
        currentServer = providersManager.activeDnsServer
        currentProvider = providersManager.activeDnsProvider
        tunnelMode = configuration.lowLevelConfiguration.tunnelMode
        restartByReachability = configuration.lowLevelConfiguration.restartByReachability

        Logger.logInfo("(PacketTunnelProvider) Start Tunnel with server: \(currentServer?.predefined.name ?? "system default")")
    }
    
    private func reachNotify() {
        // todo:
    }
    
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
}

struct ServerAddress {
    let ip: String
    let port: String?
}
