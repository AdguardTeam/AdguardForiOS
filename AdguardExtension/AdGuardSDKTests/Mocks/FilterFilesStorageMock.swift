import Foundation

enum FilterFilesStorageMockError: Error {
    case updateFilterError
    case updateCustomFilterError
    case deleteError
    case error
}

class FilterFilesStorageMock: FilterFilesStorageProtocol {
    
    var updateFilterResult: Result<FilterFilesStorageMockError?> = .success(nil)
    var updateCustomFilterResult: Result<FilterFilesStorageMockError?> = .success(nil)
    var deleteResult: Result<FilterFilesStorageMockError?> = .success(nil)
    
    var customFilters: Set<Int> = Set()
    
    var updateFilterCalled = false
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        updateFilterCalled = true
        switch updateFilterResult {
        case .success(_): onFilterUpdated(nil)
        case .error(let error): onFilterUpdated(error)
        }
    }
    
    var updateCustomFilterCalled = false
    func updateCustomFilter(withId id: Int, subscriptionUrl: URL, onFilterUpdated: @escaping (Error?) -> Void) {
        updateCustomFilterCalled = true
        switch updateCustomFilterResult {
        case .success(_):
            customFilters.insert(id)
            onFilterUpdated(nil)
        case .error(let error): onFilterUpdated(error)
        }
    }
    
    var getFilterContentForFilterCalled = false
    var getFilterResultHandler: ((_ id: Int) -> String?)?
    func getFilterContentForFilter(withId id: Int) -> String? {
        getFilterContentForFilterCalled = true
        return getFilterResultHandler?(id)
    }
    
    var getFiltersContentForFiltersCalled = false
    func getFiltersContentForFilters(withIds identifiers: [Int]) -> [Int : String] {
        getFiltersContentForFiltersCalled = true
        return [:]
    }
    
    var saveFilterCalled = false
    func saveFilter(withId id: Int, filterContent: String) throws {
        saveFilterCalled = true
    }
    
    var deleteFilterCalled = false
    func deleteFilter(withId id: Int) throws {
        deleteFilterCalled = true
        switch deleteResult {
        case .success(_):
            customFilters.remove(id)
            break
        case .error(let error): throw error
        }
    }
}
