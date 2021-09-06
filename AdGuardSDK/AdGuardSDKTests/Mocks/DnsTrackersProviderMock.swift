import Foundation

final class DnsTrackersProviderMock: DnsTrackersProviderProtocol {

    var invokedGetTrackerCount = 0
    var invokedGetTrackerParameters: [String] = []
    var stubbedGetTrackerResult: [String: DnsTracker] = [:]
    func getTracker(by domain: String) -> DnsTracker? {
        invokedGetTrackerParameters.append(domain)
        invokedGetTrackerCount += 1
        return stubbedGetTrackerResult[domain]
    }
}
