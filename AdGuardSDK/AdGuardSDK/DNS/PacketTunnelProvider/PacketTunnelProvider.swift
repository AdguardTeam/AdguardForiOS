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
    
    private let userDefaults: UserDefaultsStorageProtocol
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

    let V_DNS_IPV6_ADDRESS = "2001:ad00:ad00::ad00"
    let V_DNS_IPV4_ADDRESS = "198.18.0.1"

    public init(userDefaults: UserDefaults, debugLoggs: Bool, dnsConfiguration: DnsConfigurationProtocol, filterStorageUrl: URL, statisticsDbContainerUrl: URL) {

        self.configuration = dnsConfiguration
        self.userDefaults = UserDefaultsStorage(storage: userDefaults)

        // init dns libs logger
        AGLogger.setLevel( debugLoggs ? .AGLL_DEBUG : .AGLL_WARN )
        AGLogger.setCallback { msg, size in
            if let msg = msg {
                Logger.logInfo("(DnsLibs) \(String(cString: msg))")
            }
        }
    
        // dnsProviders manager
        providersManager = try! DnsProvidersManager(configuration: dnsConfiguration, userDefaults: self.userDefaults)
        let filtersStorage = try! FilterFilesStorage(filterFilesDirectoryUrl: filterStorageUrl)
        dnsFilters = DnsFiltersManager(userDefaults: self.userDefaults, filterFilesStorage: filtersStorage, configuration: dnsConfiguration)

        // init dnsProxy
        let rulesProvider = DnsLibsRulesProvider(dnsFiltersManager: dnsFilters, filterFilesStorage: filtersStorage, configuration: dnsConfiguration)
        
        let activityStatistics = try! ActivityStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        let chartsStatistics = try! ChartStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        let logStatistics = try! DnsLogStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        let eventHandler = DnsRequestProcessedEventHandler(providersManager: providersManager, dnsLibsRulesProvider: rulesProvider, activityStatistics: activityStatistics, chartStatistics: chartsStatistics, dnsLogStatistics: logStatistics)
        dnsProxy = DnsProxyService(eventHandler: eventHandler, dnsProvidersManager: providersManager)

        // init reachability
        reachabilityHandler = try! Reachability()
        
        super.init()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.reachabilityChanged, object: self, queue: nil) { [weak self]note in
            self?.reachNotify()
        }

        Logger.logInfo("(PacketTunnelProvider) init finished")
    }

    // MARK: packet tunnel lifecycle

    public override func startTunnel(options: [String : NSObject]? = nil, completionHandler: @escaping (Error?) -> Void) {

        Logger.logInfo("(PacketTunnelProvider) startTunnel ")

        try? reachabilityHandler.startNotifier()

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
            systemServers = ["9.9.9.9", "149.112.112.112", "2620:fe::fe", "2620:fe::9"]
        }

        let upstreams = currentServer != nil && currentServer!.upstreams.count > 0 ? currentServer?.upstreams.map{ $0.upstream } : systemServers

        let ipv6Available = ACNIPUtils.isIpv6Available()

        // todo: magic numbers
        let userfilterId = 1
        let whitelistFilterId = 2

        let serverName = currentProvider?.name ?? "Default"
        // todo: String.localizedString("default_dns_server_name")

        // low level settings

        let customFallbacks = configuration.fallbackServers
        let customBootstraps = configuration.bootstrapServers
        let blockingMode = configuration.blockingMode
        let blockedTtl = configuration.blockedTtl

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
            if blockingMode == .unspecifiedAddress || configuration.blockingIp == nil {
                customBlockingIp = ["0.0.0.0", "::"]
            }
            else {
                customBlockingIp = configuration.blockingIp!
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

        let blockIpv6 = configuration.blockIpv6

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

        if configuration.fallbackServers?.count ?? 0 > 0 &&
            configuration.bootstrapServers?.count ?? 0 > 0 &&
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
                let systemIps = self?.getSystemDnsIps()
                self?.updateTunnelSettingsInternal { (error) in
                    completion(error, systemIps ?? [])
                }
            }
        }
    }

    private func updateTunnelSettingsInternal(completion: @escaping (Error?)->Void) {
        Logger.logInfo("updateTunnelSettingsInternal")

        var full = false
        var withoutIcon = false

        var modeName = ""

        switch tunnelMode {
        case .split:
            modeName = "SPLIT"
        case .full:
            modeName = "FULL"
            full = true
        case .fullWithoutVpnIcon:
            modeName = "FULL without VPN icon"
            full = true
            withoutIcon = true
        default:
            break
        }

        Logger.logInfo("Start Tunnel mode: \(modeName)")

        let settings = self.createSettings(full: full, wihoutVPNIcon: withoutIcon)
        self.setTunnelNetworkSettings(settings) { error in
            if error != nil {
                Logger.logError("setTunnelNetworkSettings error \(error!)")
            }

            completion(error)
        }
    }

    private func createSettings(full: Bool, wihoutVPNIcon: Bool)->NEPacketTunnelNetworkSettings {

        let settings = NEPacketTunnelNetworkSettings()

        let ipv4Available = ACNIPUtils.isIpv4Available()
        let ipv6Available = ACNIPUtils.isIpv6Available()

        Logger.logInfo("create tunnel settings. ipv4: \(ipv4Available ? "true": "false") ipv6: \(ipv6Available ? "true": "false")")

        let localDnsAddress = ipv4Available ? V_DNS_IPV4_ADDRESS : V_DNS_IPV6_ADDRESS
        let dns = NEDNSSettings(servers: [localDnsAddress])

        dns.matchDomains = [""]
        settings.dnsSettings = dns

        var interfaceIpv4: String = ""
        var interfaceIpv6: String = ""

        switch(tunnelMode!) {
        case .full:
            interfaceIpv4 = "172.16.209.3"
            interfaceIpv6 = "fd12:1:1:1::3"
        case .fullWithoutVpnIcon:
            interfaceIpv4 = "172.16.209.4"
            interfaceIpv6 = "fd12:1:1:1::4"
        case .split:
            interfaceIpv4 = "172.16.209.5"
            interfaceIpv6 = "fd12:1:1:1::5"
        default:
            assertionFailure("unknown tunnelMode")
        }

        let ipv4 = NEIPv4Settings(addresses: [interfaceIpv4], subnetMasks: ["255.255.255.252"])
        let ipv6 = NEIPv6Settings(addresses: [interfaceIpv6], networkPrefixLengths: [64])

        // exclude/include routes

        if full {
            ipv4.includedRoutes = [NEIPv4Route.default()]
            ipv6.includedRoutes = [NEIPv6Route.default()]

            ipv4.excludedRoutes = self.ipv4ExcludedRoutes(withoutVPNIcon: wihoutVPNIcon)
            ipv6.excludedRoutes = self.ipv6ExcludedRoutes(withoutVPNIcon: wihoutVPNIcon)
        }
        else {
            if ipv4Available {
                let dnsProxyIpv4Route = NEIPv4Route(destinationAddress: V_DNS_IPV4_ADDRESS, subnetMask: "255.255.255.255")
                ipv4.includedRoutes = [dnsProxyIpv4Route]
            }
            else {
                let dnsProxyIpv6Route = NEIPv6Route(destinationAddress: V_DNS_IPV6_ADDRESS, networkPrefixLength: 64)
                ipv6.includedRoutes = [dnsProxyIpv6Route]
            }

            ipv4.excludedRoutes = [NEIPv4Route.default()]
            ipv6.excludedRoutes = [NEIPv6Route.default()]
        }

        if ipv4Available {
            settings.ipv4Settings = ipv4
        }

        if ipv6Available {
            settings.ipv6Settings = ipv6
        }

        return settings
    }

    /**
     returns array of ipv4 exclude ranges for full tunnel modes

     withoutVPNIcon - it is a hack. If we add range 0.0.0.0 with mask 31 or lower to exclude routes, then vpn icon appears.
     It is important to understand that it's not just about the icon itself.
     The appearance and disappearance of the icon causes different strangeness in the behavior of the system.
     In mode "with the icon" does not work facetime(https://github.com/AdguardTeam/AdguardForiOS/issues/501).
     Perhaps some other apple services use the address 0.0.0.0 and does not work.
     In the "no icon" mode, you can not disable wi-fi(https://github.com/AdguardTeam/AdguardForiOS/issues/674).
     This behavior leads to crashes in ios 11.3 beta.

     NOTE. To show VPN icon it's enough to add either 0.0.0.0/(0-31) to ipv4 excludes or ::/(0-127) to ipv6 exclude routes.
     */
    func ipv4ExcludedRoutes(withoutVPNIcon: Bool)->[NEIPv4Route] {

        let defaultRoute = ACNCidrRange(cidrString: "0.0.0.0/0")
        var dnsRanges:[ACNCidrRange] = [ACNCidrRange(cidrString: V_DNS_IPV4_ADDRESS)]

        if !withoutVPNIcon {
            dnsRanges.append(ACNCidrRange(cidrString: "0.0.0.0/31"))
        }

        let excluded = ACNCidrRange.exclude(from: [defaultRoute!], excludedRanges: dnsRanges)

        let ranges: [NEIPv4Route]? = excluded!.compactMap {
            let cidr = $0.toString()!
            return NEIPv4Route.routeWithCidr(cidr)
        }

        return ranges ?? []
    }

    func ipv6ExcludedRoutes(withoutVPNIcon: Bool)->[NEIPv6Route] {
        let defaultRoute = ACNCidrRange(cidrString: "::/0")
        var dnsRanges:[ACNCidrRange] = [ACNCidrRange(cidrString: V_DNS_IPV6_ADDRESS)]

        if !withoutVPNIcon {
            dnsRanges.append(ACNCidrRange(cidrString: "::/127"))
        }

        let excluded = ACNCidrRange.exclude(from: [defaultRoute!], excludedRanges: dnsRanges)

        let ranges: [NEIPv6Route]? = excluded!.compactMap {
            let cidr = $0.toString()!
            return NEIPv6Route.routeWithCidr(cidr)
        }

        return ranges ?? []
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
        tunnelMode = configuration.tunnelMode
        restartByReachability = configuration.restartByReachability

        Logger.logInfo("(PacketTunnelProvider) Start Tunnel with server: \(currentServer?.predefined.name ?? "system default")")
    }


    private func getSystemDnsIps()->[String] {

        let addresses = self.getDNSServers()

        var ips = [String] ()

        for addr in addresses.ipv4 {
            ips.append(addr.ip)
        }

        for addr in addresses.ipv6 {
            ips.append(addr.ip)
        }

        return ips
    }

    private func getDNSServers()->(ipv4:[ServerAddress], ipv6: [ServerAddress]) {
        var ipv4s = [ServerAddress]()
        var ipv6s = [ServerAddress]()

        ACNIPUtils.enumerateSystemDns { ip, port, ipv4, stop in
            if ipv4 {
                ipv4s.append(ServerAddress(ip: ip!, port: port))
            }
            else {
                let components = ip?.components(separatedBy: ":")
                if components?.first == "fe80" {
                    // skip link-local
                    return
                }
                ipv6s.append(ServerAddress(ip: ip!, port: port))
            }
        }

        return (ipv4s, ipv6s)
    }
    
    private func reachNotify() {
        // todo:
    }
}

extension NEIPv4Route {
    static func routeWithCidr(_ cidr: String)->NEIPv4Route? {
        let components = cidr.components(separatedBy: "/")
        guard components.count == 2 else { return nil }

        let dest = components[0]
        let maskLength = Int(components[1])
        var maskLong: in_addr_t = 0xffffffff >> (32 - maskLength!)
        maskLong = maskLong << (32 - maskLength!)
        maskLong = maskLong.byteSwapped
        let buf = addr2ascii(AF_INET, &maskLong, 32, nil)!
        let maskStr = String(cString: buf)
        return NEIPv4Route(destinationAddress: dest, subnetMask: maskStr)
    }
}

extension NEIPv6Route {
    static func routeWithCidr(_ cidr: String)->NEIPv6Route? {
        let components = cidr.components(separatedBy: "/")
        guard components.count == 2 else { return nil }

        let dest = components[0]
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let mask = formatter.number(from: components[1])!
        return NEIPv6Route(destinationAddress: dest, networkPrefixLength: mask)
    }
}

struct ServerAddress {
    let ip: String
    let port: String?
}
