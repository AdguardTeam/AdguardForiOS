import Foundation

final class DnsFiltersManagerMock: DnsFiltersManagerProtocol {

    var invokedFiltersGetter = false
    var invokedFiltersGetterCount = 0
    var stubbedFilters: [DnsFilter]! = []

    var filters: [DnsFilter] {
        invokedFiltersGetter = true
        invokedFiltersGetterCount += 1
        return stubbedFilters
    }

    var invokedSetFilter = false
    var invokedSetFilterCount = 0
    var invokedSetFilterParameters: (id: Int, enabled: Bool)?
    var invokedSetFilterParametersList = [(id: Int, enabled: Bool)]()
    var stubbedSetFilterError: Error?

    func setFilter(withId id: Int, to enabled: Bool) throws {
        invokedSetFilter = true
        invokedSetFilterCount += 1
        invokedSetFilterParameters = (id, enabled)
        invokedSetFilterParametersList.append((id, enabled))
        if let error = stubbedSetFilterError {
            throw error
        }
    }

    var invokedRenameFilter = false
    var invokedRenameFilterCount = 0
    var invokedRenameFilterParameters: (id: Int, name: String)?
    var invokedRenameFilterParametersList = [(id: Int, name: String)]()
    var stubbedRenameFilterError: Error?

    func renameFilter(withId id: Int, to name: String) throws {
        invokedRenameFilter = true
        invokedRenameFilterCount += 1
        invokedRenameFilterParameters = (id, name)
        invokedRenameFilterParametersList.append((id, name))
        if let error = stubbedRenameFilterError {
            throw error
        }
    }

    var invokedAddFilter = false
    var invokedAddFilterCount = 0
    var invokedAddFilterParameters: (name: String, url: URL, isEnabled: Bool)?
    var invokedAddFilterParametersList = [(name: String, url: URL, isEnabled: Bool)]()
    var stubbedAddFilterOnFilterAddedResult: (Error?, Void)?

    func addFilter(withName name: String, url: URL, isEnabled: Bool, onFilterAdded: @escaping (Error?) -> Void) {
        invokedAddFilter = true
        invokedAddFilterCount += 1
        invokedAddFilterParameters = (name, url, isEnabled)
        invokedAddFilterParametersList.append((name, url, isEnabled))
        if let result = stubbedAddFilterOnFilterAddedResult {
            onFilterAdded(result.0)
        }
    }

    var invokedRemoveFilter = false
    var invokedRemoveFilterCount = 0
    var invokedRemoveFilterParameter: Int?
    var invokedRemoveFilterParametersList = [Int]()
    var stubbedRemoveFilterError: Error?

    func removeFilter(withId id: Int) throws {
        invokedRemoveFilter = true
        invokedRemoveFilterCount += 1
        invokedRemoveFilterParameter = id
        invokedRemoveFilterParametersList.append(id)
        if let error = stubbedRemoveFilterError {
            throw error
        }
    }

    var invokedUpdateFilter = false
    var invokedUpdateFilterCount = 0
    var invokedUpdateFilterParameter: Int?
    var invokedUpdateFilterParametersList = [Int]()

    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        invokedUpdateFilter = true
        invokedUpdateFilterCount += 1
        invokedUpdateFilterParameter = id
        invokedUpdateFilterParametersList.append(id)
    }

    var invokedUpdateAllFilters = false
    var invokedUpdateAllFiltersCount = 0
    
    func updateAllFilters(onFilterUpdated: @escaping (DnsFiltersManager.UpdateResult) -> Void) {
        invokedUpdateAllFilters = true
        invokedUpdateAllFiltersCount += 1
    }

    var invokedGetDnsLibsFilters = false
    var invokedGetDnsLibsFiltersCount = 0
    var stubbedGetDnsLibsFiltersResult: [Int: String]! = [:]

    func getDnsLibsFilters() -> [Int: String] {
        invokedGetDnsLibsFilters = true
        invokedGetDnsLibsFiltersCount += 1
        return stubbedGetDnsLibsFiltersResult
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
