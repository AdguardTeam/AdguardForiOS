import XCTest

class DnsTrackersProviderTest: XCTestCase {

    let dnsTrackerProvider: DnsTrackersProviderProtocol = try! DnsTrackersProvider()

    func testTrackersFromAdGuardJson() {
        let domainsFromAdguardJson = [
            "akadns.net",
            "icloud.com",
            "adjust.com",
            "bttn.io"
        ]

        domainsFromAdguardJson.forEach {
            let tracker = dnsTrackerProvider.getTracker(by: $0)
            XCTAssertNotNil(tracker)
            XCTAssertEqual(tracker?.jsonType, .adGuard)
        }
    }

    func testTrackersFromWhotracksmeJson() {
        let domainsFromWhotracksmeJson = [
            "mmtro.com",
            "247-inc.net",
            "a8.net",
            "abtasty.com"
        ]

        domainsFromWhotracksmeJson.forEach {
            let tracker = dnsTrackerProvider.getTracker(by: $0)
            XCTAssertNotNil(tracker)
            XCTAssertEqual(tracker?.jsonType, .whoTracksMe)
        }
    }

    func testTrackerNotFound() {
        let domain = "dkdkdkld.pjkfj"
        let tracker = dnsTrackerProvider.getTracker(by: domain)
        XCTAssertNil(tracker)
    }

    func testWithEmptyString() {
        let domain = ""
        let tracker = dnsTrackerProvider.getTracker(by: domain)
        XCTAssertNil(tracker)
    }
}
