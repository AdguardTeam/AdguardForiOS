
import DnsAdGuardSDK

extension LowLevelDnsConfiguration {
    static var `default`: LowLevelDnsConfiguration {
        LowLevelDnsConfiguration(
            tunnelMode: .split,
            fallbackServers: nil,
            bootstrapServers: nil,
            blockingMode: .default,
            blockingIp: nil,
            blockedTtl: 120,
            blockIpv6: true,
            restartByReachability: true
        )
    }
    
    static func fromResources(_ resources: AESharedResourcesProtocol)->LowLevelDnsConfiguration {
        return LowLevelDnsConfiguration(
            tunnelMode: resources.tunnelMode,
            blockingMode: resources.blockingMode,
            blockedTtl: resources.blockedResponseTtlSecs,
            blockIpv6: resources.blockIpv6,
            restartByReachability: resources.restartByReachability
        )
    }
}
