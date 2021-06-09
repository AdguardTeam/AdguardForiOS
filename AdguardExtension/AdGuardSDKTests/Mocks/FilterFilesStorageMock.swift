import Foundation

enum FilterFilesStorageMockError: Error {
    case error
}


class FilterFilesStorageMock: FilterFilesStorageProtocol {
    
    var updateFilterResult: Result<FilterFilesStorageMockError?> = .success(nil)
    var updateCustomFilterResult: Result<FilterFilesStorageMockError?> = .success(nil)
    var deleteResult: Result<FilterFilesStorageMockError?> = .success(nil)
    
    func setResultsToDefault() {
        updateFilterResult = .success(nil)
        updateCustomFilterResult = .success(nil)
        deleteResult = .success(nil)
    }
    
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        switch updateFilterResult {
        case .success(_): onFilterUpdated(nil)
        case .error(let error): onFilterUpdated(error)
        }
    }
    
    func updateCustomFilter(withId id: Int, subscriptionUrl: URL, onFilterUpdated: @escaping (Error?) -> Void) {
        switch updateCustomFilterResult {
        case .success(_): onFilterUpdated(nil)
        case .error(let error): onFilterUpdated(error)
        }
    }
    
    func getFilterContentForFilter(withId id: Int) -> String? {
        return nil
    }
    
    func getFiltersContentForFilters(withIds identifiers: [Int]) -> [Int : String] {
        return [:]
    }
    
    func saveFilter(withId id: Int, filterContent: String) throws {
        
    }
    
    func deleteFilter(withId id: Int) throws {
        switch deleteResult {
        case .success(_): break
        case .error(let error): throw error
        }
    }
}
