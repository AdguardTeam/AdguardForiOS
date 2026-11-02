import Network
import Foundation
import Darwin

public class NetworkStateInfo : CustomStringConvertible {

    public let internetState: InternetState
    public let interface: NWInterface?
    var physicalNetwork: PhysicalNetworkState?
    var routeChanged = false


    public init(_ internetState: InternetState, _ interface: NWInterface?) {
        self.internetState = internetState
        self.interface = interface
    }

    public init() {
        self.internetState = .unavailable
        self.interface = nil
    }



    public var description: String {
        "Internet state: \(internetState); interface: \(interface?.name ?? "null")"
    }
}

// Only the monitor excluding virtual interfaces supplies this fingerprint.
struct PhysicalNetworkState: Equatable {
    let available: Bool
    let interfaces: [String]
    let gateways: [String]
    let addresses: [String]

    static func capture(_ path: Network.NWPath) -> PhysicalNetworkState? {
        let interfaces = path.availableInterfaces.filter {
            ($0.type == .wifi || $0.type == .cellular || $0.type == .wiredEthernet)
                && path.usesInterfaceType($0.type)
        }
        let names = Set(interfaces.map { $0.name })
        var addresses = Set<String>()
        var list: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&list) == 0 else { return nil }
        do {
            defer { freeifaddrs(list) }
            var cursor = list
            while let item = cursor {
                defer { cursor = item.pointee.ifa_next }
                guard let address = item.pointee.ifa_addr,
                      names.contains(String(cString: item.pointee.ifa_name)),
                      address.pointee.sa_family == AF_INET || address.pointee.sa_family == AF_INET6,
                      item.pointee.ifa_flags & UInt32(IFF_UP | IFF_RUNNING) == UInt32(IFF_UP | IFF_RUNNING)
                else { continue }
                var host = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(address, socklen_t(address.pointee.sa_len), &host,
                               socklen_t(host.count), nil, 0, NI_NUMERICHOST) == 0 {
                    addresses.insert(String(cString: item.pointee.ifa_name) + ":" + String(cString: host))
                }
            }
        }
        // shortcut: equal network addresses/gateways do not identify the SSID; route callbacks still refresh DNS.
        return PhysicalNetworkState(
            available: path.status == .satisfied,
            interfaces: interfaces.map { "\($0.name):\($0.index)" },
            gateways: path.gateways.map { String(describing: $0) }.sorted(),
            addresses: addresses.sorted()
        )
    }
}

// Used on the provider's serial event queue; an outage is remembered until recovery.
struct NetworkChangeTracker {
    enum Action { case none, refreshProxy, restartTunnel }
    private var available: Bool
    private var interfaceName: String?
    private var physicalNetwork: PhysicalNetworkState?
    private var pendingPhysicalChange = false

    init(available: Bool, interfaceName: String?, physicalNetwork: PhysicalNetworkState?) {
        self.available = available
        self.interfaceName = interfaceName
        self.physicalNetwork = physicalNetwork
    }

    mutating func update(available: Bool, interfaceName: String?,
                         physicalNetwork: PhysicalNetworkState?, routeChanged: Bool = false,
                         physicalMonitoringSupported: Bool = true) -> Action {
        let egressChanged = available != self.available || interfaceName != self.interfaceName
        if let previous = self.physicalNetwork, let current = physicalNetwork, previous != current {
            pendingPhysicalChange = true
        }
        self.available = available
        self.interfaceName = interfaceName
        if let physicalNetwork = physicalNetwork { self.physicalNetwork = physicalNetwork }

        guard available else { return .none }
        // iOS 13 has no monitor that can exclude virtual interfaces.
        guard physicalMonitoringSupported else { return egressChanged ? .restartTunnel : .none }
        guard self.physicalNetwork?.available != false else { return .none }
        if pendingPhysicalChange {
            pendingPhysicalChange = false
            return .restartTunnel
        }
        // Unknown underlay is not evidence for cancelling another working VPN.
        return egressChanged || routeChanged ? .refreshProxy : .none
    }
}
