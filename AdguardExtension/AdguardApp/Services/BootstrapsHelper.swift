///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import DnsAdGuardSDK

/**
 This object is responsible for obtaining correct bootstraps that are able
 to resolve DNS addresses
 */
struct BootstrapsHelper {
    static var bootstraps: [String] {
        var bootstraps = NetworkUtils().systemDnsServers

        // If our Tunnel appears in system DNS servers we should remove it
        // Because the tunnel is unable to resolve DNS servers
        let tunnelIpV4 = Constants.LocalDnsAddresses.ipv4
        let tunnelIpV6 = Constants.LocalDnsAddresses.ipv6
        bootstraps.removeAll(where: { $0 == tunnelIpV4 || $0 == tunnelIpV6 })

        // If bootstraps are empty after removing our tunnel
        // Than we add AdGuard Non-filtering DNS
        if bootstraps.isEmpty {
            bootstraps = Constants.LocalDnsAddresses.defaultSystemDnsServers
        }

        return bootstraps
    }
}
