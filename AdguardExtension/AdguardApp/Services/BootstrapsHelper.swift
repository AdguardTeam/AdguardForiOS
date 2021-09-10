
import DnsAdGuardSDK

class BootstrapsHelper {
    static var bootstraps: [String] {
        var bootstraps = NetworkUtils().systemDnsServers
        
        // If our Tunnel appears in system bootstraps we should remove it
        let tunnelIpV4 = LocalDnsAddresses.ipv4
        let tunnelIpV6 = LocalDnsAddresses.ipv6
        bootstraps.removeAll(where: { $0 == tunnelIpV4 || $0 == tunnelIpV6 })
        
        // If bootstraps are empty after removing our tunnel
        // Than we add AdGuard Non-filtering DNS
        if bootstraps.isEmpty {
            bootstraps.append("94.140.14.140")
            bootstraps.append("94.140.14.141")
            bootstraps.append("2a10:50c0::1:ff")
            bootstraps.append("2a10:50c0::2:ff")
        }
        
        return bootstraps
    }
}
