import Foundation


class FilterFilesStorageMock: FilterFilesStorageProtocol {
    func updateFilter(withId id: Int, onFilterUpdated: @escaping (Error?) -> Void) {
        onFilterUpdated(nil)
    }
    
    func updateCustomFilter(withId id: Int, subscriptionUrl: URL, onFilterUpdated: @escaping (Error?) -> Void) {
        onFilterUpdated(nil)
    }
    
    func getFilterContentForFilter(withId id: Int) -> String? {
        return nil
    }
    
    func getFiltersContentForFilters(withIds identifiers: [Int]) -> [Int : String] {
        return [:]
    }
    
    func saveFilter(withId id: Int, filterContent: String) throws {
        
    }
    
    func deleteFitler(withId id: Int) throws {
        
    }
}
