
import Foundation

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

@objc
@objcMembers
class Dns64Utils: NSObject {
    
    private let SECTION_INDEX_ANSWER = 1
    private let IPV4_ONLY_ARPA_NAME = "ipv4only.arpa";
    private let PREFIX_SEPARATOR = "::"
    
    /**
      Byte representation of IPv4 addresses we are looking for after DNS64 prefix while dns response parsing
      It's two "well-known IPv4" addresses defined for Dns64Prefix::/n
      -192.0.0.171
      -192.0.0.170
     */
    private let WELL_KNOWN_IPV4_FIRST: [UInt8] = [192, 0, 0, 171];
    private let WELL_KNOWN_IPV4_SECOND: [UInt8] = [192, 0, 0, 170];
    
    /**
      Parses answer for ipv6 prefix
      Valid answer must contains the following AAAA record:
      -16 bytes record
      -First 12 bytes are DNS64 prefix
      -Last 4 bytes are required Ipv4: WELL_KNOWN_IPV4_FIRST or WELL_KNOWN_IPV4_SECOND
      We use simplified algorithm and consider the first matched prefix to be valid
     
      @param ipv6AddressData DNS response
      @return ipv6 prefix if current network is DNS64 enabled
     */
    public func getDns64Prefix(ipv6AddressData: Data) -> Data? {
        var prefixString = String()
        var prefixData: Data?
        
        if (ipv6AddressData.count == 16) {
            let ipv4AddressData = Array(ipv6AddressData[12...])
            if ipv4AddressData == WELL_KNOWN_IPV4_FIRST || ipv4AddressData == WELL_KNOWN_IPV4_SECOND {
                prefixData = ipv6AddressData[0...11]
                for i in 0...5 {
                    let begin = i * 2
                    let end = begin + 1
                    prefixString.append(prefixData![begin...end].hexEncodedString())
                    if i != 5 { prefixString.append(":") }
                }
                NSLog("current Current network DNS64 prefix is: \(prefixString)")
            }
        }
        
        return prefixData
    }
    
    public func dns64Prefix()->Data? {
        let resolvedIpData = ACDnsUtils.ipv6Addresses(forHostname: IPV4_ONLY_ARPA_NAME)
        if resolvedIpData == nil || resolvedIpData!.count == 0 {
            return nil
        }
        
        let prefixData = getDns64Prefix(ipv6AddressData: (resolvedIpData?.first)!)
        return prefixData
    }
    
    public func dns64MappedIpData(ipv4Data: Data, prefix: Data) -> Data {
        return prefix + ipv4Data;
    }
}
