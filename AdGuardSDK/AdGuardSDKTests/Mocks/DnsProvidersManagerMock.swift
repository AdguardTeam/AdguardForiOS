import Foundation

final class DnsProvidersManagerMock: DnsProvidersManagerProtocol {

    var invokedAllProvidersGetterCount = 0
    var stubbedAllProviders: [DnsProviderMetaProtocol]! = []
    var allProviders: [DnsProviderMetaProtocol] {
        invokedAllProvidersGetterCount += 1
        return stubbedAllProviders
    }

    var invokedPredefinedProvidersGetterCount = 0
    var stubbedPredefinedProviders: [DnsProviderProtocol]! = []
    var predefinedProviders: [DnsProviderProtocol] {
        invokedPredefinedProvidersGetterCount += 1
        return stubbedPredefinedProviders
    }

    var invokedCustomProvidersGetterCount = 0
    var stubbedCustomProviders: [CustomDnsProviderProtocol] = []
    var customProviders: [CustomDnsProviderProtocol] {
        invokedCustomProvidersGetterCount += 1
        return stubbedCustomProviders
    }
    
    var invokedActiveDnsProviderGetterCount = 0
    var stubbedActiveDnsProvider: DnsProviderMetaProtocol!
    var activeDnsProvider: DnsProviderMetaProtocol {
        invokedActiveDnsProviderGetterCount += 1
        return stubbedActiveDnsProvider
    }

    var invokedActiveDnsServerGetterCount = 0
    var stubbedActiveDnsServer: DnsServerMetaProtocol!
    var activeDnsServer: DnsServerMetaProtocol {
        invokedActiveDnsServerGetterCount += 1
        return stubbedActiveDnsServer
    }

    var invokedDnsImplementationChangedCount = 0
    func dnsImplementationChanged() {
        invokedDnsImplementationChangedCount += 1
    }

    var invokedSelectProviderCount = 0
    var invokedSelectProviderParameters: (id: Int, serverId: Int)?
    var invokedSelectProviderParametersList = [(id: Int, serverId: Int)]()
    var stubbedSelectProviderError: Error?
    func selectProvider(withId id: Int, serverId: Int) throws {
        invokedSelectProviderCount += 1
        invokedSelectProviderParameters = (id, serverId)
        invokedSelectProviderParametersList.append((id, serverId))
        if let error = stubbedSelectProviderError {
            throw error
        }
    }

    var invokedAddCustomProviderCount = 0
    var invokedAddCustomProviderParameters: (name: String, upstreams: [String], selectAsCurrent: Bool)?
    var invokedAddCustomProviderParametersList = [(name: String, upstreams: [String], selectAsCurrent: Bool)]()
    var stubbedAddCustomProviderError: Error?
    func addCustomProvider(name: String, upstreams: [String], selectAsCurrent: Bool) throws {
        invokedAddCustomProviderCount += 1
        invokedAddCustomProviderParameters = (name, upstreams, selectAsCurrent)
        invokedAddCustomProviderParametersList.append((name, upstreams, selectAsCurrent))
        if let error = stubbedAddCustomProviderError {
            throw error
        }
    }

    var invokedUpdateCustomProviderCount = 0
    var invokedUpdateCustomProviderParameters: (id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool)?
    var invokedUpdateCustomProviderParametersList = [(id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool)]()
    var stubbedUpdateCustomProviderError: Error?
    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool) throws {
        invokedUpdateCustomProviderCount += 1
        invokedUpdateCustomProviderParameters = (id, newName, newUpstreams, selectAsCurrent)
        invokedUpdateCustomProviderParametersList.append((id, newName, newUpstreams, selectAsCurrent))
        if let error = stubbedUpdateCustomProviderError {
            throw error
        }
    }

    var invokedRemoveCustomProviderCount = 0
    var invokedRemoveCustomProviderParameter: Int!
    var invokedRemoveCustomProviderParametersList: [Int] = []
    var stubbedRemoveCustomProviderError: Error?
    func removeCustomProvider(withId id: Int) throws {
        invokedRemoveCustomProviderCount += 1
        invokedRemoveCustomProviderParameter = id
        invokedRemoveCustomProviderParametersList.append(id)
        if let error = stubbedRemoveCustomProviderError {
            throw error
        }
    }

    var invokedResetCount = 0
    var stubbedResetError: Error?
    func reset() throws {
        invokedResetCount += 1
        if let error = stubbedResetError {
            throw error
        }
    }
}
