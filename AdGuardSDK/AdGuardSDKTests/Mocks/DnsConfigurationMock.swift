import Foundation

final class DnsConfigurationMock: DnsConfigurationProtocol {

    var blocklistIsEnabled: Bool = false

    var allowlistIsEnabled: Bool = false

    var dnsFilteringIsEnabled: Bool = false

    var dnsImplementation: DnsImplementation = .adGuard

    var currentLocale: Locale = Locale(identifier: "en")

    var proStatus: Bool = false

    var lowLevelConfiguration = LowLevelDnsConfiguration(
        tunnelMode: .full,
        fallbackServers: nil,
        bootstrapServers: nil,
        blockingMode: .defaultMode,
        blockingIpv4: nil,
        blockingIpv6: nil,
        blockedTtl: 2,
        blockIpv6: false,
        restartByReachability: true
    )
}
