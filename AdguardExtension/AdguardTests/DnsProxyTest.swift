
import XCTest

class LogWriterMock: NSObject, DnsLogRecordsWriterProtocol {
    var server: String = ""
    
    func handleEvent(_ event: AGDnsRequestProcessedEvent) {
        
    }
}

class DnsProxyTest: XCTestCase {
    
    var proxyService = DnsProxyService(logWriter: LogWriterMock());
    let request = Data(base64Encoded: "RQAAQkGPAAD/ETb1rBDRAsYSAAHOlAA1AC47HU+xAQAAAQAAAAAAAAdjbGllbnRzAWwGZ29vZ2xlA2NvbQAAAQAB")

    override func setUp() {
        XCTAssert(proxyService.start(upstreams: ["1.1.1.1"], listenAddr: "127.0.0.1", bootstrapDns: "8.8.8.8", fallback: "8.8.8.8", serverName: "cloudflare", filtersJson: "", maxQueues: 5))
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
        XCTAssert(proxyService.start(upstreams: ["1.1.1.1"], listenAddr: "127.0.0.1", bootstrapDns: "8.8.8.8", fallback: "8.8.8.8", serverName: "cloudflare", filtersJson: "", maxQueues: 5))
        
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
