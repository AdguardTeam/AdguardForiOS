import Foundation

final class CustomDnsProvidersStorageMock: CustomDnsProvidersStorageProtocol {
    
    var providers: [CustomDnsProviderProtocol] = []
    
    var addCustomProviderCalledCount = 0
    var addCustomProviderResult: Result<(Int, Int)> = .error(CommonError.missingData)
    func addCustomProvider(name: String, upstreams: [String]) throws -> (providerId: Int, serverId: Int) {
        addCustomProviderCalledCount += 1
        switch addCustomProviderResult {
        case .success(let ids): return ids
        case .error(let error): throw error
        }
    }
    
    var updateCustomProviderCalledCount = 0
    var updateCustomProviderError: Error?
    func updateCustomProvider(withId id: Int, newName: String, newUpstreams: [String]) throws {
        updateCustomProviderCalledCount += 1
        if let error = updateCustomProviderError {
            throw error
        }
    }
    
    var removeCustomProviderCalledCount = 0
    var removeCustomProviderError: Error?
    func removeCustomProvider(withId id: Int) throws {
        removeCustomProviderCalledCount += 1
        if let error = removeCustomProviderError {
            throw error
        }
    }
    
    var resetCalledCount = 0
    var resetError: Error?
    func reset() throws {
        resetCalledCount += 1
        if let error = resetError {
            throw error
        }
    }
}
