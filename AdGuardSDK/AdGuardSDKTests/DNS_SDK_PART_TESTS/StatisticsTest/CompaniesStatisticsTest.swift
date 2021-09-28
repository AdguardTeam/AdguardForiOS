import XCTest

class CompaniesStatisticsTest: XCTestCase {

    var activityStatistics: ActivityStatisticsMock!
    var dnsTrackersProvider: DnsTrackersProviderMock!
    var companiesStatistics: CompaniesStatisticsProtocol!

    override func setUp() {
        activityStatistics = ActivityStatisticsMock()
        dnsTrackersProvider = DnsTrackersProviderMock()
        companiesStatistics = CompaniesStatistics(activityStatistics: activityStatistics, dnsTrackersProvider: dnsTrackersProvider)
    }

    func testTrackerWasNotFoundInJson() {
        let tracker = DnsTracker(jsonType: .adGuard, name: "tracker", category: .advertising, url: nil)
        let stubbedGetTrackerResult = ["domain": tracker]
        dnsTrackersProvider.stubbedGetTrackerResult = stubbedGetTrackerResult

        let counters1 = CountersStatisticsRecord(requests: 10, encrypted: 5, blocked: 5, elapsedSumm: 10)
        let counters2 = CountersStatisticsRecord(requests: 20, encrypted: 10, blocked: 10, elapsedSumm: 20)
        activityStatistics.stubbedGetDomainsResult = [
            DomainsStatisticsRecord(domain: "domain", counters: counters1),
            DomainsStatisticsRecord(domain: "domain2", counters: counters2)
        ]

        let stat = try! companiesStatistics.getCompaniesStatistics(for: .month)
        XCTAssertEqual(activityStatistics.invokedGetDomainsCount, 1)
        XCTAssertEqual(activityStatistics.invokedGetDomainsParameter, .month)
        XCTAssertEqual(dnsTrackersProvider.invokedGetTrackerCount, 2)
        XCTAssertEqual(dnsTrackersProvider.invokedGetTrackerParameters, ["domain", "domain2"])

        let expectedRecord1 = CompaniesStatisticsRecord(company: "domain2", tracker: nil, counters: counters2, domains: Set(["domain2"]))
        let expectedRecord2 = CompaniesStatisticsRecord(company: "tracker", tracker: tracker, counters: counters1, domains: Set(["domain"]))
        XCTAssertEqual(stat.count, 2)
        XCTAssertEqual(stat[0], expectedRecord1)
        XCTAssertEqual(stat[1], expectedRecord2)
    }

    func testTrackerForMultipleDomains() {
        let tracker1 = DnsTracker(jsonType: .adGuard, name: "tracker", category: .advertising, url: nil)
        let tracker2 = DnsTracker(jsonType: .whoTracksMe, name: "tracker2", category: .comments, url: "someurl")
        let stubbedGetTrackerResult = ["domain": tracker1,
                                       "domain2": tracker1,
                                       "domain3": tracker2]
        dnsTrackersProvider.stubbedGetTrackerResult = stubbedGetTrackerResult

        let counters1 = CountersStatisticsRecord(requests: 10, encrypted: 5, blocked: 5, elapsedSumm: 10)
        let counters2 = CountersStatisticsRecord(requests: 20, encrypted: 10, blocked: 10, elapsedSumm: 20)
        let counters3 = CountersStatisticsRecord(requests: 25, encrypted: 15, blocked: 10, elapsedSumm: 30)
        activityStatistics.stubbedGetDomainsResult = [
            DomainsStatisticsRecord(domain: "domain", counters: counters1),
            DomainsStatisticsRecord(domain: "domain2", counters: counters2),
            DomainsStatisticsRecord(domain: "domain3", counters: counters3)
        ]

        let stat = try! companiesStatistics.getCompaniesStatistics(for: .all)
        XCTAssertEqual(activityStatistics.invokedGetDomainsCount, 1)
        XCTAssertEqual(activityStatistics.invokedGetDomainsParameter, .all)
        XCTAssertEqual(dnsTrackersProvider.invokedGetTrackerCount, 3)
        XCTAssertEqual(dnsTrackersProvider.invokedGetTrackerParameters, ["domain", "domain2", "domain3"])

        let expectedRecord1 = CompaniesStatisticsRecord(company: "tracker", tracker: tracker1, counters: counters1 + counters2, domains: Set(["domain", "domain2"]))
        let expectedRecord2 = CompaniesStatisticsRecord(company: "tracker2", tracker: tracker2, counters: counters3, domains: Set(["domain3"]))
        XCTAssertEqual(stat.count, 2)
        XCTAssertEqual(stat[0], expectedRecord1)
        XCTAssertEqual(stat[1], expectedRecord2)
    }

    func testGetDomainsThrowsError() {
        activityStatistics.stubbedGetDomainsError = CommonError.missingData
        XCTAssertThrowsError(try companiesStatistics.getCompaniesStatistics(for: .all)) { error in
            if case CommonError.missingData = error as! CommonError {}
            else {
                XCTFail()
            }
        }
    }
}
