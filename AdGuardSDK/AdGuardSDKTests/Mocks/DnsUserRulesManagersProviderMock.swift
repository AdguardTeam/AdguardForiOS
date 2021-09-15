final class DnsUserRulesManagersProviderMock: DnsUserRulesManagersProviderProtocol {

    var invokedBlocklistRulesManagerGetter = false
    var invokedBlocklistRulesManagerGetterCount = 0
    var stubbedBlocklistRulesManager: UserRulesManagerProtocol!

    var blocklistRulesManager: UserRulesManagerProtocol {
        invokedBlocklistRulesManagerGetter = true
        invokedBlocklistRulesManagerGetterCount += 1
        return stubbedBlocklistRulesManager
    }

    var invokedAllowlistRulesManagerGetter = false
    var invokedAllowlistRulesManagerGetterCount = 0
    var stubbedAllowlistRulesManager: UserRulesManagerProtocol!

    var allowlistRulesManager: UserRulesManagerProtocol {
        invokedAllowlistRulesManagerGetter = true
        invokedAllowlistRulesManagerGetterCount += 1
        return stubbedAllowlistRulesManager
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
