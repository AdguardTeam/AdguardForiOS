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

import NetworkExtension
import SharedAdGuardSDK

/**
 This object gives access to a virtual network interface
 It contains all thelogic needed for tunnel to be run
 To make it work just subclass and initialize
 - Seealso https://developer.apple.com/documentation/networkextension/nepackettunnelprovider
 */
open class PacketTunnelProvider: NEPacketTunnelProvider {

    public struct Addresses {
        let tunnelRemoteAddress: String
        let interfaceIpv4: String
        let interfaceIpv6: String
        let localDnsIpv4: String
        let localDnsIpv6: String
        let defaultSystemDnsServers: [String]

        public init(
            tunnelRemoteAddress: String,
            interfaceIpv4: String,
            interfaceIpv6: String,
            localDnsIpv4: String,
            localDnsIpv6: String,
            defaultSystemDnsServers: [String]
        ) {
            self.tunnelRemoteAddress = tunnelRemoteAddress
            self.interfaceIpv4 = interfaceIpv4
            self.interfaceIpv6 = interfaceIpv6
            self.localDnsIpv4 = localDnsIpv4
            self.localDnsIpv6 = localDnsIpv6
            self.defaultSystemDnsServers = defaultSystemDnsServers
        }
    }

    private var networkUtils: NetworkUtilsProtocol?
    private var tunnelProxy: PacketTunnelProviderProxyProtocol!
    private var onNetworkStateChangedObserver: NotificationToken?

    private let networkEventQueue = DispatchQueue(label: "PacketTunnelProvider.networkEvents")
    private var networkChanges: NetworkChangeTracker?
    private var stopping = false // Access only on networkEventQueue.


    override public init() {
        assertionFailure("This initializer shouldn't be called")
        super.init()
    }

    public init(
        userDefaults: UserDefaults,
        debugLogs: Bool,
        dnsConfiguration: DnsConfigurationProtocol,
        addresses: Addresses,
        filterStorageUrl: URL,
        statisticsDbContainerUrl: URL,
        networkUtils: NetworkUtilsProtocol
    ) throws {
        Logger.logInfo("(PacketTunnelProvider) init start")

        let userDefaultsStorage = UserDefaultsStorage(storage: userDefaults)
        let dnsProvidersManager = try DnsProvidersManager(configuration: dnsConfiguration, userDefaults: userDefaultsStorage, networkUtils: networkUtils)

        let filtersFileStorage = try FilterFilesStorage(filterFilesDirectoryUrl: filterStorageUrl)

        let filtersManager = DnsFiltersManager(
            userDefaults: userDefaultsStorage,
            filterFilesStorage: filtersFileStorage,
            configuration: dnsConfiguration
        )

        let userRulesProvider = DnsUserRulesManagersProvider(fileStorage: filtersFileStorage, readOnly: true)

        let dnsLibsRulesProvider = DnsLibsRulesProvider(
            dnsFiltersManager: filtersManager,
            filterFilesStorage: filtersFileStorage,
            userRulesProvider: userRulesProvider
        )

        let proxySettingsProvider = DnsProxyConfigurationProvider(
            dnsProvidersManager: dnsProvidersManager,
            dnsLibsRulesProvider: dnsLibsRulesProvider,
            dnsConfiguration: dnsConfiguration,
            networkUtils: networkUtils
        )

        let dnsProxy = DnsProxy(
            proxySettingsProvider: proxySettingsProvider,
            statisticsDbContainerUrl: statisticsDbContainerUrl
        )

        let tunnelSettingsProvider = PacketTunnelSettingsProvider(addresses: addresses, networkUtils: networkUtils)

        self.tunnelProxy = PacketTunnelProviderProxy(
            isDebugLogs: debugLogs,
            tunnelAddresses: addresses,
            dnsProxy: dnsProxy,
            dnsConfiguration: dnsConfiguration,
            tunnelSettings: tunnelSettingsProvider,
            providersManager: dnsProvidersManager,
            networkUtils: networkUtils,
            addresses: addresses
        )

        self.networkUtils = networkUtils

        super.init()

        tunnelProxy.delegate = self

        Logger.logInfo("(PacketTunnelProvider) init finished")
    }

    // MARK: packet tunnel lifecycle

    public override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {
        Logger.logInfo("(PacketTunnelProvider) startTunnel")

        networkEventQueue.sync { stopping = false }
        tunnelProxy.startTunnel(options: options) { [weak self] error in
            if error == nil {
                Logger.logInfo("(PacketTunnelProvider) startTunnel; finished starting")
            } else {
                Logger.logInfo("(PacketTunnelProvider) startTunnel; finished starting with error: \(error!)")
            }
            if error == nil { self?.startObservingNetworkStateChanging() }
            completionHandler(error)
        }
    }

    public override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        Logger.logInfo("(PacketTunnelProvider) stopTunnel with reason: \(reason)")
        networkEventQueue.sync {
            stopping = true
            onNetworkStateChangedObserver = nil
            networkChanges = nil
        }
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



    private func startObservingNetworkStateChanging() {
        guard let networkUtils = networkUtils else { return }

        networkEventQueue.sync {
            guard !stopping else { return }
            let initial = networkUtils.getCurrentNetworkStateSync()
            networkChanges = NetworkChangeTracker(available: initial.internetState == .available,
                interfaceName: initial.interface?.name, physicalNetwork: initial.physicalNetwork)
            onNetworkStateChangedObserver = NotificationCenter.default.observe(name: .networkStateChanged, object: nil, queue: nil) { [weak self] notification in
                guard let state = notification.object as? NetworkStateInfo else { return }
                self?.networkEventQueue.async { [weak self] in
                    guard let self = self, self.networkChanges != nil else { return }
                    let supported: Bool
                    if #available(iOS 14.0, macOS 11.0, *) { supported = true } else { supported = false }
                    let action = self.networkChanges?.update(available: state.internetState == .available,
                        interfaceName: state.interface?.name, physicalNetwork: state.physicalNetwork,
                        routeChanged: state.routeChanged, physicalMonitoringSupported: supported)
                    switch action {
                    case .restartTunnel:
                        Logger.logInfo("Network change: physical network changed or recovered")
                        self.tunnelProxy.networkChanged(physicalNetworkChanged: true)
                    case .refreshProxy:
                        Logger.logInfo("Network change: refreshing DNS egress without changing tunnel settings")
                        self.tunnelProxy.networkChanged(physicalNetworkChanged: false)
                    default: break
                    }
                }
            }
        }
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
