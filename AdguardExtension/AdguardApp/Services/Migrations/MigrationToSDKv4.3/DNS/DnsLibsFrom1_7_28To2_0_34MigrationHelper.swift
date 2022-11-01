import Foundation
import DnsAdGuardSDK

/// Migration after updating DnsLibs from v1.7.28 to v2.0.34.
///
/// The DoQ upstream now uses the port 853 by default (was 8853), conforms to RFC-9250, and doesn't support ALPNs other than "doq".
/// That means that if a user have custom quic:// URLs stamps in their server list, they (excluding AdGuard's) should be changed from quic://example.org to quic://example.org:8853.
struct DnsLibsFrom1_7_28To2_0_34MigrationHelper {
    private let dnsProvider: DnsProvidersManagerProtocol

    init(dnsProvider: DnsProvidersManagerProtocol) {
        self.dnsProvider = dnsProvider
    }

    /// Starts migration
    func migrate() throws {
         try dnsProvider.customProviders.forEach { provider in
            let upstreams = provider.server.upstreams.map { $0.upstream }
            let adaptedUpstreams = adaptDnsDoQUpstreamIfNeeded(upstreams)

            try dnsProvider.updateCustomProvider(
                    withId: provider.providerId,
                    newName: provider.name,
                    newUpstreams: adaptedUpstreams,
                    selectAsCurrent: provider.isEnabled,
                    isMigration: true
            )
        }
    }


    private func adaptDnsDoQUpstreamIfNeeded(_ upstreams: [String]) -> [String] {
        upstreams.map { getMigrationUpstream($0) }
    }

    private func getMigrationUpstream(_ upstream: String) -> String {
        guard upstream.starts(with: "quic://"),
              !upstream.contains("adguard-dns.com") // We should not change our DNS upstreams
        else { return upstream }

        let upstreamWithoutProtocol = upstream.substringAfter("quic://")

        if upstreamWithoutProtocol.isValidIPv6Address() {
            return upstream.contains("]:") ? "\(upstream.substringBeforeLast(":")):8853" : "quic://[\(upstreamWithoutProtocol)]:8853"
        }

        return upstream.substringAfter("://").contains(":") ? "\(upstream.substringBeforeLast(":")):8853" : "\(upstream):8853"
    }
}
