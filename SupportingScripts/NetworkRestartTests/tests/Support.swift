// GPL-3.0-or-later. External collaborators only; policy and proxy are real patched sources.
import Foundation
import Network
import NetworkExtension

struct PacketTunnelProvider {
    struct Addresses {
        let localDnsIpv4 = "198.18.0.1"
        let localDnsIpv6 = "2001:ad00:ad00::ad00"
        let defaultSystemDnsServers = ["94.140.14.140"]
    }
}
enum DnsProtocol { case dns }
enum DnsImplementation { case adGuard }
struct DnsUpstream { let upstream: String; let `protocol`: DnsProtocol }
protocol NetworkUtilsProtocol {
    var systemDnsServers: [String] { get }
    func getCurrentNetworkInterfaceSync() -> NWInterface?
    func getProtocol(from: String, _ implementation: DnsImplementation) throws -> DnsProtocol
}
protocol DnsProxyProtocol {
    func start(_ upstreams: [DnsUpstream], _ interface: NWInterface?) -> Error?
    func stop()
    func resolve(dnsRequest: Data, onRequestResolved: @escaping (Data?) -> Void)
}
enum TunnelMode { case split, fullWithoutVpnIcon }
struct LowLevelConfiguration {
    var restartByReachability = true
    var tunnelMode = TunnelMode.split
    var fallbackServers: [String]? = ["test"]
    var bootstrapServers: [String]? = ["test"]
}
protocol DnsConfigurationProtocol { var lowLevelConfiguration: LowLevelConfiguration { get } }
protocol PacketTunnelSettingsProviderProtocol {
    func createSettings(full: Bool, withoutVpnIcon: Bool) -> NEPacketTunnelNetworkSettings
}
struct DnsServer { let upstreams = ["test"] }
protocol DnsProvidersManagerProtocol { var activeDnsServer: DnsServer { get } }

final class FakeNetwork: NetworkUtilsProtocol {
    var systemDnsServers = ["system://ipsec8", "198.18.0.1", "2001:ad00:ad00::ad00"]
    func getCurrentNetworkInterfaceSync() -> NWInterface? { nil }
    func getProtocol(from: String, _ implementation: DnsImplementation) throws -> DnsProtocol { .dns }
}
final class FakeConfiguration: DnsConfigurationProtocol {
    var lowLevelConfiguration = LowLevelConfiguration()
}
final class FakeSettings: PacketTunnelSettingsProviderProtocol {
    func createSettings(full: Bool, withoutVpnIcon: Bool) -> NEPacketTunnelNetworkSettings {
        NEPacketTunnelNetworkSettings(tunnelRemoteAddress: "127.0.0.1")
    }
}
final class FakeProviders: DnsProvidersManagerProtocol { let activeDnsServer = DnsServer() }
final class FakeDNS: DnsProxyProtocol {
    var error: Error?
    var starts = 0
    var stops = 0
    var upstreams: [String] = []
    let started = DispatchSemaphore(value: 0)
    func start(_ upstreams: [DnsUpstream], _ interface: NWInterface?) -> Error? {
        starts += 1
        self.upstreams = upstreams.map(\.upstream)
        started.signal()
        return error
    }
    func stop() { stops += 1 }
    func resolve(dnsRequest: Data, onRequestResolved: @escaping (Data?) -> Void) { onRequestResolved(nil) }
}
final class FakeDelegate: PacketTunnelProviderProxyDelegate {
    private let lock = NSLock()
    private var _settings = 0
    private var _cancels = 0
    private var _reads = 0
    var settings: Int { lock.lock(); defer { lock.unlock() }; return _settings }
    var cancels: Int { lock.lock(); defer { lock.unlock() }; return _cancels }
    var reads: Int { lock.lock(); defer { lock.unlock() }; return _reads }
    var settingsError: Error?
    var cancelError: Error?
    let cancelled = DispatchSemaphore(value: 0)
    let readStarted = DispatchSemaphore(value: 0)
    func setTunnelSettings(_ settings: NETunnelNetworkSettings?, _ completionHandler: ((Error?) -> Void)?) {
        lock.lock(); _settings += 1; lock.unlock()
        completionHandler?(settingsError)
    }
    func cancelTunnel(with error: Error?) {
        lock.lock(); _cancels += 1; cancelError = error; lock.unlock()
        cancelled.signal()
    }
    func readPackets(completionHandler: @escaping ([Data], [NSNumber]) -> Void) {
        lock.lock(); _reads += 1; lock.unlock()
        readStarted.signal()
        // Keep the outstanding read pending, as on an idle real packet flow.
    }
    func writePackets(_ packets: [Data], _ protocols: [NSNumber]) {}
}
struct ProxyFixture {
    let dns = FakeDNS()
    let configuration = FakeConfiguration()
    let delegate = FakeDelegate()
    let network = FakeNetwork()
    let proxy: PacketTunnelProviderProxy
    init() {
        proxy = PacketTunnelProviderProxy(isDebugLogs: false, tunnelAddresses: .init(),
            dnsProxy: dns, dnsConfiguration: configuration, tunnelSettings: FakeSettings(),
            providersManager: FakeProviders(), networkUtils: network, addresses: .init())
        proxy.delegate = delegate
    }
    func drainAndStop() {
        let done = DispatchSemaphore(value: 0)
        proxy.stopTunnel(with: .userInitiated) { done.signal() }
        precondition(done.wait(timeout: .now() + 3) == .success, "stop timed out")
    }
}
