import Foundation

protocol DnsResolverProtocol {
    typealias DnsResolverResult = (dnsServer: String?, dnsProtocol: DnsProtocol?)
}

extension DnsResolverProtocol {
    static func resolve(upstream: String) -> DnsResolverResult {
        var error: NSError?
        
        guard let dnsStamp = AGDnsStamp(string: upstream, error: &error) else {
            DDLogError("Error initializing AGDnsStamp")
            return (nil, nil)
        }
        
        if let error = error {
            DDLogError("Error resolving DNS protocol; Error: \(error)")
            return (nil, nil)
        }
        
        let server = String(dnsStamp.prettyUrl)
        let dnsProto = DnsProtocol(dnslibProto: dnsStamp.proto)
        return (server, dnsProto)
    }
}

struct DnsResolver: DnsResolverProtocol {}
