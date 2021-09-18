import Foundation

final class DnsProxyMock: DnsProxyProtocol {

    var invokedStartCount = 0
    var invokedStartParameters: [DnsUpstream] = []
    var invokedStartParametersList: [[DnsUpstream]] = []
    var stubbedStartResult: Error?
    func start(_ systemDnsUpstreams: [DnsUpstream]) -> Error? {
        invokedStartCount += 1
        invokedStartParameters = systemDnsUpstreams
        invokedStartParametersList.append(systemDnsUpstreams)
        return stubbedStartResult
    }

    var invokedStopCount = 0
    func stop(_ onProxyStopped: @escaping () -> Void) {
        invokedStopCount += 1
        onProxyStopped()
    }

    var invokedResolveCount = 0
    var invokedResolveParameter: Data!
    var invokedResolveParametersList: [Data] = []
    var stubbedResolveResult: Data?
    func resolve(dnsRequest: Data, onRequestResolved: @escaping (Data?) -> Void) {
        invokedResolveCount += 1
        invokedResolveParameter = dnsRequest
        invokedResolveParametersList.append(dnsRequest)
        onRequestResolved(stubbedResolveResult)
    }
}
