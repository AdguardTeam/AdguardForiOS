import XCTest

class DnsTrackersProviderTest: XCTestCase {
    
    var dnsTrackerService: DnsTrackersProvider!
    
    override func setUp() {
        dnsTrackerService = try! DnsTrackersProvider()
    }
    
    func test() {
        
    }
}
