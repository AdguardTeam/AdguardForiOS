import Foundation

enum FilterFilesStorageMockError: Error {
    case updateFilterError
    case updateCustomFilterError
    case deleteError
    case resetError
    case error
}

class FilterFilesStorageMock: FilterFilesStorageProtocol {

    var updateFilterCalledCount = 0
    var updateFilterResultError: Error?
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        updateFilterCalledCount += 1
        onFilterUpdated(updateFilterResultError)
    }
    
    var updateCustomFilterCalledCount = 0
    var updateCustomFilterError: Error?
    func updateCustomFilter(withId id: Int, subscriptionUrl: URL, onFilterUpdated: @escaping (Error?) -> Void) {
        updateCustomFilterCalledCount += 1
        onFilterUpdated(updateCustomFilterError)
    }
    
    var getFilterContentForFilterCalledCount = 0
    var getFilterResultHandler: ((_ id: Int) -> String?)?
    func getFilterContentForFilter(withId id: Int) -> String? {
        getFilterContentForFilterCalledCount += 1
        return getFilterResultHandler?(id)
    }
    
    var getFiltersContentForFiltersCalledCount = 0
    func getFiltersContentForFilters(withIds identifiers: [Int]) -> [Int : String] {
        getFiltersContentForFiltersCalledCount += 1
        return [:]
    }
    
    var saveFilterCalled = false
    func saveFilter(withId id: Int, filterContent: String) throws {
        saveFilterCalled = true
    }
    
    var deleteFilterCalledCount = 0
    var deleteResultError: Error?
    func deleteFilter(withId id: Int) throws {
        deleteFilterCalledCount += 1
        if let error = deleteResultError {
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
