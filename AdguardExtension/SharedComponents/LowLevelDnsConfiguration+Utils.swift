
import DnsAdGuardSDK

extension LowLevelDnsConfiguration {
    static func fromResources(_ resources: AESharedResourcesProtocol)->LowLevelDnsConfiguration {
        return LowLevelDnsConfiguration(tunnelMode: resources.tunnelMode, blockingMode: resources.blockingMode, blockedTtl: resources.blockedResponseTtlSecs, blockIpv6: resources.blockIpv6, restartByReachability: resources.restartByReachability)
    }
}
