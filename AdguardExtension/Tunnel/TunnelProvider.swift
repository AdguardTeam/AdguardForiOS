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
class TunnelProvider: PacketTunnelProvider {
    static let tunnelRemoteAddress = "127.1.1.1"

    // These addresses are meaningful and must not be changed. We use it in VPN application to determine in what mode the packet tunnel is running.
    static let interfaceFullIpv4 = "172.16.209.3"
    static let interfaceFullIpv6 = "fd12:1:1:1::3"
    static let interfaceFullWithoutIconIpv4 = "172.16.209.4"
    static let interfaceFullWithoutIconIpv6 = "fd12:1:1:1::4"
    static let interfaceSplitIpv4 = "172.16.209.5"
    static let interfaceSplitIpv6 = "fd12:1:1:1::5"

    public override init() {
        // init logger
        let resources = AESharedResources()
        Self.setupLogger(resources)

        let debugLoggs = resources.isDebugLogs

        // start and configure Sentry
        SentrySDK.start { options in
            options.dsn = Constants.Sentry.dsnUrl
            options.enableAutoSessionTracking = false
        }

        SentrySDK.configureScope { scope in
            scope.setTag(value: AGDnsProxy.libraryVersion(), key: "dnslibs.version")
            scope.setTag(value: debugLoggs ? "true" : "false" , key: "dnslibs.debuglogs")
        }

        let urlStorage = SharedStorageUrls()
        let filterStorageUrl = urlStorage.dnsFiltersFolderUrl
        let statisticsUrl = urlStorage.statisticsFolderUrl

        let configuration = DnsConfiguration(proStatus: true,
                                             dnsFilteringIsEnabled: resources.systemProtectionEnabled,
                                             dnsImplementation: resources.dnsImplementation,
                                             blocklistIsEnabled: true,
                                             allowlistIsEnabled: true,
                                             lowLevelConfiguration: LowLevelDnsConfiguration.fromResources(resources))

        try! super.init(userDefaults: resources.sharedDefaults(),
                        debugLoggs: debugLoggs,
                        dnsConfiguration: configuration,
                        addresses: TunnelProvider.getAddresses(mode: resources.tunnelMode),
                        filterStorageUrl: filterStorageUrl,
                        statisticsDbContainerUrl: statisticsUrl,
                        networkUtils: NetworkUtils()
        )
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

    private static func setupLogger(_ resources: AESharedResourcesProtocol) {
        let debugLoggs = resources.isDebugLogs
        ACLLogger.singleton().initLogger(resources.sharedAppLogsURL())
        ACLLogger.singleton().logLevel = debugLoggs ? ACLLDebugLevel : ACLLDefaultLevel
        DDLogInfo("Init tunnel with loglevel: \(debugLoggs ? "DEBUG" : "NORMAL")")

        Logger.logInfo = { msg in
            DDLogInfo(msg)
        }

        Logger.logDebug = { msg in
            DDLogDebug(msg)
        }

        Logger.logError = { msg in
            DDLogError(msg)
        }
    }
}
