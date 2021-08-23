import Foundation

final class NetworkUtilsMock: NetworkUtilsProtocol {
    var systemDnsServers: [String] = []
    var isIpv4Available: Bool = false
    var isIpv6Available: Bool = false
    
    var upstreamIsValidCalledCount = 0
    var upstreamIsValidResult = true
    func upstreamIsValid(_ upstream: String) -> Bool {
        upstreamIsValidCalledCount += 1
        return upstreamIsValidResult
    }
    
    var getProtocolCalledCount = 0
    var getProtocolResult: Result<DnsProtocol> = .success(.dns)
    var getProtocolListResult: IndexingIterator<[DnsProtocol]>?
    func getProtocol(from upstream: String) throws -> DnsProtocol {
        getProtocolCalledCount += 1
        
        if getProtocolListResult != nil {
            return getProtocolListResult!.next()!
        }
        
        switch getProtocolResult {
        case .success(let prot): return prot
        case .error(let error): throw error
        }
    }
}
