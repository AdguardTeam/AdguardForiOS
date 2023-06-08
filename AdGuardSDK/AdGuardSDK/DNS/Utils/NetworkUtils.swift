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

import AGDnsProxy
import SystemLibsResolv
import SharedAdGuardSDK
import Network

public protocol NetworkUtilsProtocol {
    /* Returns list of ip addresses of system DNS servers */
    var systemDnsServers: [String] { get }

    /* Returns true if ipv4 is available */
    var isIpv4Available: Bool { get }

    /* Returns true if ipv6 is available */
    var isIpv6Available: Bool { get }

    /* Returns DNS protocol of passed upstream */
    func getProtocol(from upstream: String) throws -> DnsProtocol

    /* Checks if upstream is valid */
    func upstreamIsValid(_ upstream: String) -> Bool
}

public class NetworkUtils: NetworkUtilsProtocol {

    // We cannot use the @available attribute on properties. Therefore, we have to use a function to get it.
    private var _monitor: Any?
    @available(iOS 13.0, *)
    private func monitor() -> NWPathMonitor {
        return _monitor as! NWPathMonitor
    }

    public init() {
        if #available(iOS 13.0, *) {
            _monitor = NWPathMonitor()
            var group: DispatchGroup? = DispatchGroup()
            group?.enter()
            monitor().pathUpdateHandler = { newPath in
                Logger.logInfo("(NetworkUtils) - NWPathMonitor received the current path update")
                Logger.logInfo("(NetworkUtils) - path status: \(newPath.status)")
                Logger.logInfo("(NetworkUtils) - path debugDescription: \(newPath.debugDescription)")
                Logger.logInfo("(NetworkUtils) - path supportsIPv4: \(newPath.supportsIPv4)")
                Logger.logInfo("(NetworkUtils) - path supportsIPv6: \(newPath.supportsIPv6)")

                for gateway in newPath.gateways {
                    Logger.logInfo("(NetworkUtils) - gateway: \(gateway.debugDescription)")
                }

                for interface in newPath.availableInterfaces {
                    Logger.logInfo("(NetworkUtils) - interface: [\(interface.index)] \(interface.name)")
                    Logger.logInfo("(NetworkUtils) - interface debugDescription: \(interface.debugDescription)")
                    Logger.logInfo("(NetworkUtils) - interface type: \(interface.type)")
                }

                group?.leave()
                group = nil
            }
            Logger.logInfo("(NetworkUtils) - NWPathMonitor start")

            // We must start the monitor to have the actual value of the path at any time
            monitor().start(queue: DispatchQueue(label: "NWPathMonitor handler queue"))

            // we must wait for fist pathUpdateHandler call to get the actual network state
            // TODO: 0.5 is a magic number, at least should be explained why.
            _ = group?.wait(timeout: .now() + 0.5)
        }
    }

    deinit {
        if #available(iOS 13.0, *) {
            monitor().cancel()
        }
    }

    public var systemDnsServers: [String] {
        var state = __res_9_state()
        res_9_ninit(&state)

        defer {
            res_9_ndestroy(&state)
        }

        let maxServers = 10
        var servers = [res_9_sockaddr_union](repeating: res_9_sockaddr_union(), count: maxServers)
        let found = Int(res_9_getservers(&state, &servers, Int32(maxServers)))

        let addrs = Array(servers[0 ..< found]).filter() { $0.sin.sin_len > 0 }

        return addrs.map { convertAddrToString($0) }
    }

    public var isIpv4Available: Bool {

        if #available(iOS 13.0, *) {
            // availableInterfaces theoretically can be empty if currentPath was not initialised yet
            if !monitor().currentPath.availableInterfaces.isEmpty {
                return monitor().currentPath.supportsIPv4
            }
        }

        var result = false
        enumerateNetworkInterfaces { (cursor) -> Bool in
            if cursor.pointee.ifa_addr.pointee.sa_family == AF_INET {
                result = true
                return true
            }
            return false
        }
        return result
    }

    public var isIpv6Available: Bool {

        if #available(iOS 13.0, *) {
            // availableInterfaces theoretically can be empty if currentPath was not initialised yet
            if !monitor().currentPath.availableInterfaces.isEmpty {
                return monitor().currentPath.supportsIPv6
            }
        }

        var result = false
        enumerateNetworkInterfaces { (cursor) -> Bool in
            if cursor.pointee.ifa_addr.pointee.sa_family == AF_INET6 {
                result = true
                return true
            }
            return false
        }
        return result
    }

    public func getProtocol(from upstream: String) throws -> DnsProtocol {
        if upstream.hasPrefix("sdns://") {
            return try getDnsProtocol(from: upstream)
        }

        if upstream.hasPrefix("https://") {
            return .doh
        } else if upstream.hasPrefix("tls://") {
            return .dot
        } else if upstream.hasPrefix("quic://") {
            return .doq
        } else {
            if UrlUtils.isIpv4(upstream) || UrlUtils.isIpv6(upstream) {
                return .dns
            }
            throw CustomDnsProvidersStorageError.invalidUpstream(upstream: upstream)
        }
    }

    public func upstreamIsValid(_ upstream: String) -> Bool {
        let bootstraps = systemDnsServers

        let dnsUpstream = AGDnsUpstream()
        dnsUpstream.address = upstream
        dnsUpstream.bootstrap = bootstraps
        dnsUpstream.serverIp = Data()
        dnsUpstream.id = 0
        dnsUpstream.outboundInterfaceName = nil

        if let error = AGDnsUtils.test(dnsUpstream, timeoutMs: UInt(AGDnsProxyConfig.defaultTimeoutMs), ipv6Available: isIpv6Available, offline: false) {
            Logger.logError("(NetworkUtils) - upstreamIsValid; Error: \(error)")
            return false
        } else {
            return true
        }
    }

    private func enumerateNetworkInterfaces(process: (UnsafeMutablePointer<ifaddrs>) -> Bool) {
        var addrList : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&addrList) == 0, let firstAddr = addrList else { return }
        defer { freeifaddrs(addrList) }

        for cursor in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = cursor.pointee.ifa_flags
            if ((Int32(flags) & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) {
                if process(cursor) {
                    return
                }
            }
        }
    }

    private func convertAddrToString(_ s: res_9_sockaddr_union) -> String {
        var s = s
        var hostBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))

        let sinlen = socklen_t(s.sin.sin_len)
        let _ = withUnsafePointer(to: &s) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.getnameinfo($0, sinlen, &hostBuffer, socklen_t(hostBuffer.count), nil, 0, NI_NUMERICHOST)
            }
        }

        return String(cString: hostBuffer)
    }

    private func getDnsProtocol(from sdnsUpstream: String) throws -> DnsProtocol {
        var error: NSError?
        if let stamp = AGDnsStamp(string: sdnsUpstream, error: &error) {
            return stamp.dnsProtocol
        } else {
            throw error ?? CustomDnsProvidersStorageError.invalidUpstream(upstream: sdnsUpstream)
        }
    }
}
