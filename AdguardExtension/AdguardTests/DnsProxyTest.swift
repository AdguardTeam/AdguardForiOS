
import XCTest
import Mobile

class LogWriterMock: NSObject, DnsLogRecordsWriterProtocol {
    
    var server: String = ""
    
    func dnsRequestProcessed(_ e: MobileDNSRequestProcessedEvent!) {
        
//        Thread.sleep(until: Date(timeIntervalSinceNow: 1.0))
    }
}

class DnsProxyTest: XCTestCase {
    
    var proxyService = DnsProxyService(logWriter: LogWriterMock());
    let request = Data(base64Encoded: "3H4BAAABAAAAAAAAB2dhdGV3YXkCZmUJYXBwbGUtZG5zA25ldAAAHAAB")

    override func setUp() {
        XCTAssert(proxyService.start(upstreams: ["1.1.1.1"], listenAddr: "127.0.0.1", bootstrapDns: "8.8.8.8", fallback: "8.8.8.8", serverName: "cloudflare", maxQueues: 5))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResolve() {
        
        let expectation = XCTestExpectation(description: "expectation")
        
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNotNil(response)
            XCTAssert(response!.count > 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15)
    }
    
    func testRestart() {
        
        let expectation = XCTestExpectation(description: "expectation")
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNotNil(response)
            XCTAssert(response!.count > 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15)
        
        proxyService.stop() {}
        XCTAssert(proxyService.start(upstreams: ["1.1.1.1"], listenAddr: "127.0.0.1", bootstrapDns: "8.8.8.8", fallback: "8.8.8.8", serverName: "cloudflare", maxQueues: 5))
        
        let expectation2 = XCTestExpectation(description: "expectation2")
        
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNotNil(response)
            XCTAssert(response!.count > 0)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 15)
    }
    
    func testStopAndResolve() {
        
        let expectation = XCTestExpectation(description: "expectation")
        
        proxyService.stop() {}
        
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNil(response)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 15)
        
    }
    
    func testStopDuringWork() {
        
        var expectations: [XCTestExpectation] = []
        
        var count = 0
        for _ in 0...600 {
            
            let expectation = XCTestExpectation(description: "expectation")
            expectations.append(expectation)
            proxyService.resolve(dnsRequest: request!) { (response) in
                
                if response != nil && response!.count > 0 {
                    count += 1
                }
                expectation.fulfill()
            }
        }
        
        proxyService.stop() { }
        
        wait(for: expectations, timeout: 15)
        
        // only first 5(maxQueues) request must be processed
        XCTAssert(count == 5)
    }
    
    func testResolveAfterStop() {
        
        let expectation = XCTestExpectation(description: "expectation")
        
        proxyService.stop() { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 15)
        
        let expectation2 = XCTestExpectation(description: "expectation2")
        
        proxyService.resolve(dnsRequest: request!) { (response) in
            XCTAssertNil(response)
            expectation2.fulfill()
        }
        
        wait(for: [expectation2], timeout: 15)
    }
    
    
    func testPerformance() {
        measure {
            var expectations: [XCTestExpectation] = []
            
            var count = 0
            for _ in 0...100 {
                
                let expectation = XCTestExpectation(description: "expectation")
                expectations.append(expectation)
                proxyService.resolve(dnsRequest: request!) { (response) in
                    
                    if response != nil && response!.count > 0 {
                        count += 1
                    }
                    expectation.fulfill()
                }
            }
            
            wait(for: expectations, timeout: 15)
        }
    }
    
    
}
