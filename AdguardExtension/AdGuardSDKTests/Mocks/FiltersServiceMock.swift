import Foundation

final class FiltersServiceMock: FiltersServiceProtocol {
    var groups: [SafariGroup] = []
    
    var updateAllMetaCalledCount = 0
    var updateAllMetaResult: Result<FiltersUpdateResult> = .success(FiltersUpdateResult())
    func updateAllMeta(forcibly: Bool, onFiltersUpdated: @escaping (Result<FiltersUpdateResult>) -> Void) {
        updateAllMetaCalledCount += 1
        DispatchQueue.global().async {
            onFiltersUpdated(self.updateAllMetaResult)
        }
    }
    
    var setGroupCalledCount = 0
    var setGroupError: Error?
    func setGroup(withId id: Int, enabled: Bool) throws {
        setGroupCalledCount += 1
        if let error = setGroupError {
            throw error
        }
    }
    
    var setFilterCalledCount = 0
    var setFilterError: Error?
    func setFilter(withId id: Int, _ groupId: Int, enabled: Bool) throws {
        setFilterCalledCount += 1
        if let error = setFilterError {
            throw error
        }
    }
    
    var addCustomFilterCalledCount = 0
    var addCustomFilterError: Error?
    func add(customFilter: ExtendedCustomFilterMetaProtocol, enabled: Bool, _ onFilterAdded: @escaping (Error?) -> Void) {
        addCustomFilterCalledCount += 1
        onFilterAdded(addCustomFilterError)
    }
    
    var deleteCustomFilterCalledCount = 0
    var deleteCustomFilterError: Error?
    func deleteCustomFilter(withId id: Int) throws {
        deleteCustomFilterCalledCount += 1
        if let error = deleteCustomFilterError {
            throw error
        }
    }
    
    var renameCustomFilterCalledCount = 0
    var renameCustomFilterError: Error?
    func renameCustomFilter(withId id: Int, to name: String) throws {
        renameCustomFilterCalledCount += 1
        if let error = renameCustomFilterError {
            throw error
        }
    }
    
    var resetCalledCount = 0
    var resetError: Error?
    func reset(_ onResetFinished: @escaping (Error?) -> Void) {
        resetCalledCount += 1
        onResetFinished(resetError)
    }
}
