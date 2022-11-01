import DnsAdGuardSDK

final class InAppDnsProvidersManagerMock: DnsProvidersManagerProtocol {

    var invokedAllProvidersGetter = false
    var invokedAllProvidersGetterCount = 0
    var stubbedAllProviders: [DnsProviderMetaProtocol]! = []

    var allProviders: [DnsProviderMetaProtocol] {
        invokedAllProvidersGetter = true
        invokedAllProvidersGetterCount += 1
        return stubbedAllProviders
    }

    var invokedPredefinedProvidersGetter = false
    var invokedPredefinedProvidersGetterCount = 0
    var stubbedPredefinedProviders: [DnsProviderProtocol]! = []

    var predefinedProviders: [DnsProviderProtocol] {
        invokedPredefinedProvidersGetter = true
        invokedPredefinedProvidersGetterCount += 1
        return stubbedPredefinedProviders
    }

    var invokedCustomProvidersGetter = false
    var invokedCustomProvidersGetterCount = 0
    var stubbedCustomProviders: [CustomDnsProviderProtocol]! = []

    var customProviders: [CustomDnsProviderProtocol] {
        invokedCustomProvidersGetter = true
        invokedCustomProvidersGetterCount += 1
        return stubbedCustomProviders
    }

    var invokedActiveDnsProviderGetter = false
    var invokedActiveDnsProviderGetterCount = 0
    var stubbedActiveDnsProvider: DnsProviderMetaProtocol!

    var activeDnsProvider: DnsProviderMetaProtocol {
        invokedActiveDnsProviderGetter = true
        invokedActiveDnsProviderGetterCount += 1
        return stubbedActiveDnsProvider
    }

    var invokedActiveDnsServerGetter = false
    var invokedActiveDnsServerGetterCount = 0
    var stubbedActiveDnsServer: DnsServerMetaProtocol!

    var activeDnsServer: DnsServerMetaProtocol {
        invokedActiveDnsServerGetter = true
        invokedActiveDnsServerGetterCount += 1
        return stubbedActiveDnsServer
    }

    var invokedUpdate = false
    var invokedUpdateCount = 0
    var invokedUpdateParameters: (dnsImplementation: DnsImplementation, Void)?
    var invokedUpdateParametersList = [(dnsImplementation: DnsImplementation, Void)]()

    func update(dnsImplementation: DnsImplementation) {
        invokedUpdate = true
        invokedUpdateCount += 1
        invokedUpdateParameters = (dnsImplementation, ())
        invokedUpdateParametersList.append((dnsImplementation, ()))
    }

    var invokedSelectProvider = false
    var invokedSelectProviderCount = 0
    var invokedSelectProviderParameters: (id: Int, serverId: Int)?
    var invokedSelectProviderParametersList = [(id: Int, serverId: Int)]()
    var stubbedSelectProviderError: Error?

    func selectProvider(withId id: Int, serverId: Int) throws {
        invokedSelectProvider = true
        invokedSelectProviderCount += 1
        invokedSelectProviderParameters = (id, serverId)
        invokedSelectProviderParametersList.append((id, serverId))
        if let error = stubbedSelectProviderError {
            throw error
        }
    }

    var invokedAddCustomProvider = false
    var invokedAddCustomProviderCount = 0
    var invokedAddCustomProviderParameters: (name: String, upstreams: [String], selectAsCurrent: Bool)?
    var invokedAddCustomProviderParametersList = [(name: String, upstreams: [String], selectAsCurrent: Bool)]()
    var stubbedAddCustomProviderError: Error?

    func addCustomProvider(name: String, upstreams: [String], selectAsCurrent: Bool, isMigration: Bool) throws {
        invokedAddCustomProvider = true
        invokedAddCustomProviderCount += 1
        invokedAddCustomProviderParameters = (name, upstreams, selectAsCurrent)
        invokedAddCustomProviderParametersList.append((name, upstreams, selectAsCurrent))
        if let error = stubbedAddCustomProviderError {
            throw error
        }
    }

    var invokedUpdateCustomProvider = false
    var invokedUpdateCustomProviderCount = 0
    var invokedUpdateCustomProviderParameters: (id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool)?
    var invokedUpdateCustomProviderParametersList = [(id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool)]()
    var stubbedUpdateCustomProviderError: Error?

    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String], selectAsCurrent: Bool, isMigration: Bool) throws {
        invokedUpdateCustomProvider = true
        invokedUpdateCustomProviderCount += 1
        invokedUpdateCustomProviderParameters = (id, newName, newUpstreams, selectAsCurrent)
        invokedUpdateCustomProviderParametersList.append((id, newName, newUpstreams, selectAsCurrent))
        if let error = stubbedUpdateCustomProviderError {
            throw error
        }
    }

    var invokedRemoveCustomProvider = false
    var invokedRemoveCustomProviderCount = 0
    var invokedRemoveCustomProviderParameters: (id: Int, Void)?
    var invokedRemoveCustomProviderParametersList = [(id: Int, Void)]()
    var stubbedRemoveCustomProviderError: Error?

    func removeCustomProvider(withId id: Int) throws {
        invokedRemoveCustomProvider = true
        invokedRemoveCustomProviderCount += 1
        invokedRemoveCustomProviderParameters = (id, ())
        invokedRemoveCustomProviderParametersList.append((id, ()))
        if let error = stubbedRemoveCustomProviderError {
            throw error
        }
    }

    var invokedReset = false
    var invokedResetCount = 0
    var stubbedResetError: Error?

    func reset() throws {
        invokedReset = true
        invokedResetCount += 1
        if let error = stubbedResetError {
            throw error
        }
    }
}
