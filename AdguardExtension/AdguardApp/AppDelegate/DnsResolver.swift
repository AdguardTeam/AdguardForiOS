import Foundation

protocol DnsResolverProtocol {
    typealias DnsResolverResult = (dnsServer: String?, dnsProtocol: DnsProtocol?)
}

extension DnsResolverProtocol {
    static func resolve(upstream: String) -> DnsResolverResult {
        var error: NSError?
                
        let dnsStamp = AGDnsUtils.parseDnsStamp(withStampStr: upstream, error: &error)
        if let error = error {
            DDLogError("Error resolving DNS protocol; Error: \(error)")
            return (nil, nil)
        }
        
        guard let dnsProtocol = dnsStamp?.proto else {
            return (nil, nil)
        }
        
        var prot: DnsProtocol?
        var dnsServer: String?
        switch dnsProtocol {
        case .AGSPT_PLAIN:
            prot = .dns
            dnsServer = dnsStamp?.serverAddr
        case .AGSPT_DOH:
            prot = .doh
            if let providerName = dnsStamp?.providerName {
                let dohPrefix = DnsProtocol.prefixByProtocol[.doh]!
                dnsServer = dohPrefix + providerName
                if let path = dnsStamp?.path {
                    dnsServer! += path
                }
            }
        case .AGSPT_TLS:
            prot = .dot
            dnsServer = dnsStamp?.providerName
        case .AGSPT_DNSCRYPT:
            prot = .dnsCrypt
            let dnsCryptPrefix = DnsProtocol.prefixByProtocol[.dnsCrypt]!
            if upstream.hasPrefix(dnsCryptPrefix) {
                dnsServer = upstream
            }
        case .AGSPT_DOQ:
            prot = .doq
            let doqPrefix = DnsProtocol.prefixByProtocol[.doq]!
            if let providerName = dnsStamp?.providerName {
                dnsServer = doqPrefix + providerName
            }
        @unknown default: prot = nil
        }
        
        return (dnsServer, prot)
    }
}

struct DnsResolver: DnsResolverProtocol {}
