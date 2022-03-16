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
import DnsAdGuardSDK
import SafariAdGuardSDK
import Sentry
import AGDnsProxy

/**
 This object gives access to a virtual network interface
 The main logic of this class is implemented in `DnsAdGuardSDK.PacketTunnelProvider`
 - Seealso https://developer.apple.com/documentation/networkextension/nepackettunnelprovider
 */

private let LOG = LoggerFactory.getLoggerWrapper(TunnelProvider.self)

class TunnelProvider: PacketTunnelProvider {
    static let tunnelRemoteAddress = "127.1.1.1"

    // These addresses are meaningful and must not be changed. We use it in VPN application to determine in what mode the packet tunnel is running.
    static let interfaceFullIpv4 = "172.16.209.3"
    static let interfaceFullIpv6 = "fd12:1:1:1::3"
    static let interfaceFullWithoutIconIpv4 = "172.16.209.4"
    static let interfaceFullWithoutIconIpv6 = "fd12:1:1:1::4"
    static let interfaceSplitIpv4 = "172.16.209.5"
    static let interfaceSplitIpv6 = "fd12:1:1:1::5"

    private let resources: AESharedResourcesProtocol

    public override init() {
        // init logger
        resources = AESharedResources()
        Self.setupLogger(resources)

        let debugLogs = resources.isDebugLogs

        // TODO: consider not using Sentry or using just a part of it. Sentry's init takes 1MB RAM, a lot for a tunnel.
        // start and configure Sentry
        SentrySDK.start { options in
            options.dsn = Constants.Sentry.dsnUrl
            options.enableAutoSessionTracking = false
        }

        SentrySDK.configureScope { scope in
            scope.setTag(value: AGDnsProxy.libraryVersion(), key: "dnslibs.version")
            scope.setTag(value: debugLogs ? "true" : "false" , key: "dnslibs.debuglogs")
        }

        let urlStorage = SharedStorageUrls()
        let filterStorageUrl = urlStorage.dnsFiltersFolderUrl
        let statisticsUrl = urlStorage.statisticsFolderUrl

        let configuration = DnsConfiguration(proStatus: Bundle.main.isPro ? true : resources.isProPurchased,
                                             dnsFilteringIsEnabled: resources.systemProtectionEnabled,
                                             dnsImplementation: resources.dnsImplementation,
                                             blocklistIsEnabled: resources.systemUserFilterEnabled,
                                             allowlistIsEnabled: resources.systemWhitelistEnabled,
                                             lowLevelConfiguration: LowLevelDnsConfiguration.fromResources(resources))

        let networkUtils = NetworkUtils()

        // DNS data should be migrated before super.init is called
        Self.migrateIfNeeded(resources: resources, configuration: configuration, networkUtils: networkUtils)

        try! super.init(userDefaults: resources.sharedDefaults(),
                        debugLogs: debugLogs,
                        dnsConfiguration: configuration,
                        addresses: TunnelProvider.getAddresses(mode: resources.tunnelMode),
                        filterStorageUrl: filterStorageUrl,
                        statisticsDbContainerUrl: statisticsUrl,
                        networkUtils: networkUtils)
    }

    static func getAddresses(mode: TunnelMode)-> PacketTunnelProvider.Addresses {
        let interfaceIpv4: String
        let interfaceIpv6: String

        switch mode {
        case .full:
            interfaceIpv4 = interfaceFullIpv4
            interfaceIpv6 = interfaceFullIpv6
        case .fullWithoutVpnIcon:
            interfaceIpv4 = interfaceFullWithoutIconIpv4
            interfaceIpv6 = interfaceFullWithoutIconIpv6
        case .split:
            interfaceIpv4 = interfaceSplitIpv4
            interfaceIpv6 = interfaceSplitIpv6
        }

        return Addresses(
            tunnelRemoteAddress: tunnelRemoteAddress,
            interfaceIpv4: interfaceIpv4,
            interfaceIpv6: interfaceIpv6,
            localDnsIpv4: Constants.LocalDnsAddresses.ipv4,
            localDnsIpv6: Constants.LocalDnsAddresses.ipv6,
            defaultSystemDnsServers: Constants.LocalDnsAddresses.defaultSystemDnsServers
        )
    }

    // MARK: - private methods

    private static func setupLogger(_ resources: AESharedResourcesProtocol) {
        let debugLogs = resources.isDebugLogs
        let logManager = LoggerManagerImpl(url: resources.sharedLogsURL())
        let logLevel: LogLevel = debugLogs ? .debug : .info
        logManager.configure(logLevel)
        LOG.info("Init tunnel with loglevel: \(debugLogs ? "DEBUG" : "NORMAL")")
    }

    private static func migrateIfNeeded(resources: AESharedResourcesProtocol, configuration: DnsConfigurationProtocol, networkUtils: NetworkUtilsProtocol) {
        LOG.info("Starting migration in tunnel")
        let migrationVersionProvider = MigrationServiceVersionProvider(resources: resources)
        if migrationVersionProvider.isMigrationFrom4_1To4_3Needed {
            do {
                let dnsProvidersManager = try DnsProvidersManager(configuration: configuration, userDefaults: resources.sharedDefaults(), networkUtils: networkUtils)
                let migration = try DnsMigration4_3(resources: resources, dnsProvidersManager: dnsProvidersManager)
                migration.migrate()
                LOG.info("Migration in tunnel finished")
            }
            catch {
                LOG.error("Migration failed: \(error)")
            }
        }
    }
}
