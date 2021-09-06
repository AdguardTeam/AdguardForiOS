import Foundation

final class ActivityStatisticsMock: ActivityStatisticsProtocol {

    var invokedProcessRecordCount = 0
    var invokedProcessRecordPassedParameter: ActivityStatisticsRecord?
    func process(record: ActivityStatisticsRecord) {
        invokedProcessRecordCount += 1
        invokedProcessRecordPassedParameter = record
    }

    var invokedGetDomainsCount = 0
    var invokedGetDomainsParameter: StatisticsPeriod?
    var stubbedGetDomainsError: Error?
    var stubbedGetDomainsResult: [DomainsStatisticsRecord] = []
    func getDomains(for period: StatisticsPeriod) throws -> [DomainsStatisticsRecord] {
        invokedGetDomainsCount += 1
        invokedGetDomainsParameter = period
        if let error = stubbedGetDomainsError {
            throw error
        }
        return stubbedGetDomainsResult
    }

    var invokedGetCountersCount = 0
    var invokedGetCountersParameter: StatisticsPeriod?
    var stubbedGetCountersError: Error?
    var stubbedGetCountersResult: CountersStatisticsRecord!
    func getCounters(for period: StatisticsPeriod) throws -> CountersStatisticsRecord {
        invokedGetCountersCount += 1
        invokedGetCountersParameter = period
        if let error = stubbedGetCountersError {
            throw error
        }
        return stubbedGetCountersResult
    }

    var invokedResetCount = 0
    var stubbedResetError: Error?
    func reset() throws {
        invokedResetCount += 1
        if let error = stubbedResetError {
            throw error
        }
    }
}
