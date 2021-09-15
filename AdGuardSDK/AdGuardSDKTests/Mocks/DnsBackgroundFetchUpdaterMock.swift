final class DnsBackgroundFetchUpdaterMock: DnsBackgroundFetchUpdateProtocol {
    
    var updateFiltersInBackgroundCalledCount = 0
    var updateFiltersInBackgroundResult: Result<Error?> = .error(CommonError.error(message: ""))
    func updateFiltersInBackground(onFiltersUpdate: @escaping (Error?) -> Void) {
        updateFiltersInBackgroundCalledCount += 1
        switch updateFiltersInBackgroundResult {
        case .success( _): onFiltersUpdate(nil)
        case .error(let error): onFiltersUpdate(error)
        }
    }
}
