import Foundation

enum AdGuardVpnOperatingMode: CaseIterable {
    case general
    case ipSec
    
    /* ACNCidrRange objects represent IP address range with network mask  */
    var networkInterfaces: [ACNCidrRange] {
        switch self {
        case .general: return [ACNCidrRange(cidrString: "172.16.209.2/30"), ACNCidrRange(cidrString: "fd12:1:1:1::2/64")]
        case .ipSec: return [ACNCidrRange(cidrString: "10.40.32.0/19")]
        }
    }
    
    /* All available AdGuard VPN network interfaces */
    static var allAvailableInterfaces: [ACNCidrRange] { AdGuardVpnOperatingMode.allCases.flatMap { $0.networkInterfaces } }
    
    /* Checks if there is AdGuard VPN tunnel interface among all active interfaces */
    static func containsAdGuardVpnInterface(_ allInterfaces: Set<String>) -> Bool {
        for adgInterface in allAvailableInterfaces {
            for interface in allInterfaces {
                guard let cidrRange = ACNCidrRange(cidrString: interface) else { continue }
                
                if adgInterface.contains(cidrRange) {
                    return true
                }
            }
        }
        return false
    }
}
