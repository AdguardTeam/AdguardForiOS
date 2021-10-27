import Foundation

protocol INetworkManager {
    static var networkInterfaces: Set<String> { get }
    static var networkInterfacesByName: [String: String] { get }
}

extension INetworkManager {
    
    /* Returns all active network interfaces IP addresses */
    static var networkInterfaces: Set<String> { Set(Self.networkInterfacesByName.values) }
    
    /* Returns all active network interfaces by their names */
    static var networkInterfacesByName: [String: String] {
        var addresses: [String: String] = [:]
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        if getifaddrs(&ifaddr) == 0 {
            var pointer = ifaddr
            while pointer != nil {
                defer { pointer = pointer?.pointee.ifa_next }
                
                guard let interface = pointer?.pointee,
                    interface.ifa_addr.pointee.sa_family == UInt8(AF_INET),
                    let interfaceName = interface.ifa_name,
                    let interfaceNameFormatted = String(cString: interfaceName, encoding: .utf8)
                    else { continue }
                               
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                
                guard let formattedIpAddress = String(cString: hostname, encoding: .utf8), !formattedIpAddress.isEmpty else {
                    continue
                }
                addresses[interfaceNameFormatted] = formattedIpAddress
            }
        }
        freeifaddrs(ifaddr)
        return addresses
    }
}

struct NetworkManager: INetworkManager {}
