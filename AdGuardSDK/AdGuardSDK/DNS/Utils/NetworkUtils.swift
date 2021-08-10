/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

protocol NetworkUtilsProtocol {
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

struct NetworkUtils: NetworkUtilsProtocol {
    
    var systemDnsServers: [String] {
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
    
    var isIpv4Available: Bool {
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
    
    var isIpv6Available: Bool {
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
    
    func getProtocol(from upstream: String) throws -> DnsProtocol {
        var error: NSError?
        if let stamp = AGDnsStamp(string: upstream, error: &error) {
            return stamp.dnsProtocol
        } else {
            throw error!
        }
    }
    
    func upstreamIsValid(_ upstream: String) -> Bool {
        let bootstraps = systemDnsServers
        
        let dnsUpstream = AGDnsUpstream(address: upstream, bootstrap: bootstraps, timeoutMs: 2000, serverIp: Data(), id: 0, outboundInterfaceName: nil)
        
        // TODO: - find ipv6Available somewhere
        if let error = AGDnsUtils.test(dnsUpstream, ipv6Available: false) {
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
}

extension AGDnsStamp {
    var dnsProtocol: DnsProtocol { proto.dnsProtocol }
}

extension AGStampProtoType {
    var dnsProtocol: DnsProtocol {
        switch self {
        case .AGSPT_PLAIN: return .dns
        case .AGSPT_DOH: return .doh
        case .AGSPT_TLS: return .dot
        case .AGSPT_DNSCRYPT: return .dnscrypt
        case .AGSPT_DOQ: return .doq
        @unknown default: return .dns
        }
    }
}
