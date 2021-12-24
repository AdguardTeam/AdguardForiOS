import SharedAdGuardSDK

final class DnsBackgroundFetchUpdaterMock: DnsBackgroundFetchUpdateProtocol {

    var updateFiltersInBackgroundCalledCount = 0
    var updateFiltersInBackgroundError: Error? = nil
    func updateFiltersInBackground(onFiltersUpdate: @escaping (Error?) -> Void) {
        updateFiltersInBackgroundCalledCount += 1
        onFiltersUpdate(updateFiltersInBackgroundError)
    }
}
