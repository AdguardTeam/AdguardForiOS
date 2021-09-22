import Foundation

final class DnsProxyConfigurationProviderMock: DnsProxyConfigurationProviderProtocol {

    var invokedDnsUpstreamByIdGetterCount = 0
    var stubbedDnsUpstreamById: [Int: DnsProxyUpstream] = [:]
    var dnsUpstreamById: [Int: DnsProxyUpstream] {
        invokedDnsUpstreamByIdGetterCount += 1
        return stubbedDnsUpstreamById
    }

    var invokedCustomDnsFilterIdsGetterCount = 0
    var stubbedCustomDnsFilterIds: [Int] = []
    var customDnsFilterIds: [Int] {
        invokedCustomDnsFilterIdsGetterCount += 1
        return stubbedCustomDnsFilterIds
    }

    var invokedDnsBlocklistFilterIdGetterCount = 0
    var stubbedDnsBlocklistFilterId = 0
    var dnsBlocklistFilterId: Int {
        invokedDnsBlocklistFilterIdGetterCount += 1
        return stubbedDnsBlocklistFilterId
    }

    var invokedDnsAllowlistFilterIdGetterCount = 0
    var stubbedDnsAllowlistFilterId = 0

    var dnsAllowlistFilterId: Int {
        invokedDnsAllowlistFilterIdGetterCount += 1
        return stubbedDnsAllowlistFilterId
    }

    var invokedGetProxyConfigCount = 0
    var invokedGetProxyConfigParameters: [DnsUpstream] = []
    var invokedGetProxyConfigParametersList: [[DnsUpstream]] = []
    var stubbedGetProxyConfigResult: DnsProxyConfiguration!
    func getProxyConfig(_ systemDnsUpstreams: [DnsUpstream]) -> DnsProxyConfiguration {
        invokedGetProxyConfigCount += 1
        invokedGetProxyConfigParameters = systemDnsUpstreams
        invokedGetProxyConfigParametersList.append(systemDnsUpstreams)
        return stubbedGetProxyConfigResult
    }

    var invokedResetCount = 0
    func reset() {
        invokedResetCount += 1
    }
}
