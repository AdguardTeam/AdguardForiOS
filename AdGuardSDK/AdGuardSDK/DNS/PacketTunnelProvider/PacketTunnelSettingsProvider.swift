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

protocol PacketTunnelSettingsProviderProtocol {
    func createSettings(full: Bool, withoutVpnIcon: Bool) -> NEPacketTunnelNetworkSettings
}

private let LOG = LoggerFactory.getLoggerWrapper(PacketTunnelSettingsProvider.self)

/// This object creates `NEPacketTunnelNetworkSettings` for `PacketTunnelProvider`
/// Used to incapsulate settings creation logic
final class PacketTunnelSettingsProvider: PacketTunnelSettingsProviderProtocol {

    private let addresses: PacketTunnelProvider.Addresses
    private let networkUtils: NetworkUtilsProtocol

    init(addresses: PacketTunnelProvider.Addresses, networkUtils: NetworkUtilsProtocol) {
        self.addresses = addresses
        self.networkUtils = networkUtils
    }

    func createSettings(full: Bool, withoutVpnIcon: Bool) -> NEPacketTunnelNetworkSettings {
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: addresses.tunnelRemoteAddress)

        let ipv4Available = networkUtils.isIpv4Available
        let ipv6Available = networkUtils.isIpv6Available

        LOG.info("Create tunnel settings. ipv4: \(ipv4Available ? "true": "false") ipv6: \(ipv6Available ? "true": "false")")

        let localDnsAddress = ipv4Available ? addresses.localDnsIpv4 : addresses.localDnsIpv6
        let dns = NEDNSSettings(servers: [localDnsAddress])

        dns.matchDomains = [""]
        settings.dnsSettings = dns

        let ipv4 = NEIPv4Settings(addresses: [addresses.interfaceIpv4], subnetMasks: ["255.255.255.252"])
        let ipv6 = NEIPv6Settings(addresses: [addresses.interfaceIpv6], networkPrefixLengths: [64])

        // exclude/include routes

        if full {
            ipv4.includedRoutes = [NEIPv4Route.default()]
            ipv6.includedRoutes = [NEIPv6Route.default()]

            ipv4.excludedRoutes = ipv4ExcludedRoutes(withoutVPNIcon: withoutVpnIcon)
            ipv6.excludedRoutes = ipv6ExcludedRoutes(withoutVPNIcon: withoutVpnIcon)
        }
        else {
            if ipv4Available {
                let dnsProxyIpv4Route = NEIPv4Route(destinationAddress: addresses.localDnsIpv4, subnetMask: "255.255.255.255")
                ipv4.includedRoutes = [dnsProxyIpv4Route]
            }
            else {
                let dnsProxyIpv6Route = NEIPv6Route(destinationAddress: addresses.localDnsIpv6, networkPrefixLength: 64)
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
    private func ipv4ExcludedRoutes(withoutVPNIcon: Bool) -> [NEIPv4Route] {
        let defaultRoute = ACNCidrRange(cidrString: "0.0.0.0/0")
        var dnsRanges:[ACNCidrRange] = [ACNCidrRange(cidrString: addresses.localDnsIpv4)]

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

    private func ipv6ExcludedRoutes(withoutVPNIcon: Bool) -> [NEIPv6Route] {
        let defaultRoute = ACNCidrRange(cidrString: "::/0")
        var dnsRanges:[ACNCidrRange] = [ACNCidrRange(cidrString: addresses.localDnsIpv6)]

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
}

extension NEIPv4Route {
    static func routeWithCidr(_ cidr: String) -> NEIPv4Route? {
        let components = cidr.components(separatedBy: "/")
        guard components.count == 2 else { return nil }

        let dest = components[0]

        guard UrlUtils.isIpv4(dest) else { return nil }

        guard let maskLength = Int(components[1]),
               (0...32).contains(maskLength) else {
                   return nil
               }
        var maskLong: in_addr_t = 0xffffffff >> (32 - maskLength)
        maskLong = maskLong << (32 - maskLength)
        maskLong = maskLong.byteSwapped
        guard let buf = addr2ascii(AF_INET, &maskLong, Int32(MemoryLayout.size(ofValue: maskLong)), nil) else {
            return nil
        }
        let maskStr = String(cString: buf)
        return NEIPv4Route(destinationAddress: dest, subnetMask: maskStr)
    }
}

extension NEIPv6Route {
    static func routeWithCidr(_ cidr: String) -> NEIPv6Route? {
        let components = cidr.components(separatedBy: "/")
        guard components.count == 2 else { return nil }

        let dest = components[0]

        guard UrlUtils.isIpv6(dest) else { return nil }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let mask = formatter.number(from: components[1]),
              (0...128).contains(mask.intValue) else {
                  return nil
              }
        return NEIPv6Route(destinationAddress: dest, networkPrefixLength: mask)
    }
}
