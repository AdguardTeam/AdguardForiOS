import XCTest

final class ContentBlockersManagerMock: ContentBlockersManagerProtocol {
    
    var reloadContentBlockerCalledCount = 0
    var reloadContentBlockerError: Error?
    func reloadContentBlocker(withId id: String, _ onContentBlockerReloaded: @escaping (Error?) -> Void) {
        reloadContentBlockerCalledCount += 1
        onContentBlockerReloaded(reloadContentBlockerError)
    }
    
    var getStateOfContentBlockerCalledCount = 0
    var getStateOfContentBlockerResult: Result<Bool> = .success(true)
    func getStateOfContentBlocker(withId id: String, _ onContentBlockerStateRevealed: @escaping (Result<Bool>) -> Void) {
        getStateOfContentBlockerCalledCount += 1
        onContentBlockerStateRevealed(getStateOfContentBlockerResult)
    }
}

class ContentBlockerServiceTest: XCTestCase {
    
    var configuration: SafariConfigurationMock!
    var cbInfoStorage: ContentBlockersInfoStorageMock!
    var manager: ContentBlockersManagerMock!
    var contentBlockerService: ContentBlockerServiceProtocol!
    
    override func setUp() {
        configuration = SafariConfigurationMock()
        cbInfoStorage = ContentBlockersInfoStorageMock()
        manager = ContentBlockersManagerMock()
        contentBlockerService = ContentBlockerService(configuration: configuration, jsonStorage: cbInfoStorage, contentBlockersManager: manager)
    }
    
    func testAllContentBlockersStatesWithSuccess() {
        XCTAssertEqual(manager.getStateOfContentBlockerCalledCount, 0)
        
        manager.getStateOfContentBlockerResult = .success(true)
        let states = contentBlockerService.allContentBlockersStates
        
        XCTAssertEqual(states.count, 6)
        XCTAssertEqual(manager.getStateOfContentBlockerCalledCount, states.count)
        states.forEach { XCTAssert($0.value) }
    }
    
    func testAllContentBlockersStatesWithFailure() {
        XCTAssertEqual(manager.getStateOfContentBlockerCalledCount, 0)
        
        manager.getStateOfContentBlockerResult = .error(NSError(domain: "test", code: 1, userInfo: nil))
        let states = contentBlockerService.allContentBlockersStates
        
        XCTAssertEqual(states.count, 6)
        XCTAssertEqual(manager.getStateOfContentBlockerCalledCount, states.count)
        states.forEach { XCTAssertFalse($0.value) }
    }
    
    func testUpdateContentBlockersWithSuccess() {
        XCTAssertEqual(manager.reloadContentBlockerCalledCount, 0)
        manager.reloadContentBlockerError = nil

        let contentBlockersUpdateStarted = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.contentBlockersUpdateStarted"))
        let contentBlockersUpdateFinished = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.contentBlockersUpdateFinished"))
        let expectation = XCTestExpectation()

        contentBlockerService.updateContentBlockers { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
    
        wait(for: [expectation, contentBlockersUpdateStarted, contentBlockersUpdateFinished], timeout: 0.5)
        
        XCTAssertEqual(manager.reloadContentBlockerCalledCount, 6)
    }
    
    func testUpdateContentBlockersWithError() {
        XCTAssertEqual(manager.reloadContentBlockerCalledCount, 0)
        let testError = NSError(domain: "test", code: 1, userInfo: nil)
        manager.reloadContentBlockerError = testError
        
        let contentBlockersUpdateStarted = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.contentBlockersUpdateStarted"))
        let contentBlockersUpdateFinished = XCTNSNotificationExpectation(name: NSNotification.Name.init("AdGuardSDK.contentBlockersUpdateFinished"))
        let expectation = XCTestExpectation()
        contentBlockerService.updateContentBlockers { error in
            XCTAssertEqual(testError, error! as NSError)
            expectation.fulfill()
        }
        wait(for: [expectation, contentBlockersUpdateStarted, contentBlockersUpdateFinished], timeout: 0.5)
        
        // Try to reload every content blocker twice if error occured
        XCTAssertEqual(manager.reloadContentBlockerCalledCount, 12)
    }
    
    func testGetStateWithSuccess() {
        XCTAssertEqual(manager.reloadContentBlockerCalledCount, 0)
        manager.getStateOfContentBlockerResult = .success(true)
        
        let state = contentBlockerService.getState(for: .custom)
        
        XCTAssertEqual(manager.getStateOfContentBlockerCalledCount, 1)
        XCTAssert(state)
    }
    
    func testGetStateWithError() {
        XCTAssertEqual(manager.reloadContentBlockerCalledCount, 0)
        manager.getStateOfContentBlockerResult = .error(NSError(domain: "test", code: 1, userInfo: nil))
        
        let state = contentBlockerService.getState(for: .custom)
        
        XCTAssertEqual(manager.getStateOfContentBlockerCalledCount, 1)
        XCTAssertFalse(state)
    }
}
