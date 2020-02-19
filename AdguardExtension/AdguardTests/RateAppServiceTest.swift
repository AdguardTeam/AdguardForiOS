import XCTest

class RateAppServiceTest: XCTestCase {
    
    var resources: AESharedResourcesProtocol!
    var userNotificationService: UserNotificationServiceProtocol!
    var configuration: ConfigurationServiceProtocol!
    var rateAppService: RateAppServiceProtocol!

    override func setUp() {
        resources = SharedResourcesMock()
        userNotificationService = UserNotificationServiceMock()
        configuration = ConfigurationServiceMock()
        
        rateAppService = RateAppService(resources: resources, configuration: configuration, userNotificationService: userNotificationService)
    }
    
    func testInit(){
        let _ = RateAppService(resources: resources, configuration: configuration, userNotificationService: userNotificationService)
        
        let firstLaunchDate = resources.sharedDefaults().value(forKey: AEDefaultsFirstLaunchDate) as? Date
        let now = Date()
        
        XCTAssertEqual(Int(now.timeIntervalSinceReferenceDate), Int(firstLaunchDate!.timeIntervalSinceReferenceDate))
    }
    
    func testShowRateDialogIfNeededWithNoLaunchDate(){
        resources.sharedDefaults().set(nil, forKey: AEDefaultsFirstLaunchDate)
        var showAlertWasCalled = false
        
        rateAppService.showRateDialogIfNeeded {
            showAlertWasCalled = true
        }
        
        XCTAssert(showAlertWasCalled == false)
    }
    
    /* Current Date() is set in init */
    func testShowRateDialogIfNeededWithUnsuitableTimeInterval(){
        var showAlertWasCalled = false
        
        rateAppService.showRateDialogIfNeeded {
            showAlertWasCalled = true
        }
        
        XCTAssert(showAlertWasCalled == false)
    }
    
    func testShowRateDialogIfNeededWithSuitableTimeIntervalWithAppNotRated(){
        configuration.appRated = false
        
        let minInterval: Double = 24.0 * 3600.0 // 1 day
        let dateToTestInt = Date().timeIntervalSinceReferenceDate - minInterval
        let dateToTest = Date(timeIntervalSinceReferenceDate: dateToTestInt)
        
        resources.sharedDefaults().set(dateToTest, forKey: AEDefaultsFirstLaunchDate)
        
        var showAlertWasCalled = false
        
        rateAppService.showRateDialogIfNeeded {
            showAlertWasCalled = true
        }
        
        XCTAssert(showAlertWasCalled == true)
    }
    
    func testShowRateDialogIfNeededWithSuitableTimeIntervalWithAppRated(){
        configuration.appRated = true
        
        let minInterval: Double = 24.0 * 3600.0 // 1 day
        let dateToTestInt = Date().timeIntervalSinceReferenceDate - minInterval
        let dateToTest = Date(timeIntervalSinceReferenceDate: dateToTestInt)
        
        resources.sharedDefaults().set(dateToTest, forKey: AEDefaultsFirstLaunchDate)
        
        var showAlertWasCalled = false
        
        rateAppService.showRateDialogIfNeeded {
            showAlertWasCalled = true
        }
        
        XCTAssert(showAlertWasCalled == false)
    }

    func testCancelTapped(){
        let week = 3600 * 7 // 7 days
        let now = Date()
        
        rateAppService.cancelTapped()
        
        let newFirstLaunchDate = resources.sharedDefaults().value(forKey: AEDefaultsFirstLaunchDate) as? Date
        XCTAssertEqual(Int(now.timeIntervalSinceReferenceDate), Int(newFirstLaunchDate!.timeIntervalSinceReferenceDate))
        
        let newMinTimeIntervalToRate = resources.sharedDefaults().value(forKey: MinTimeIntervalToRate) as? Int
        XCTAssertEqual(week, newMinTimeIntervalToRate)
    }
    
    func testRateApp(){
        for star in 1...5 {
            rateAppService.rateApp(star) {
                XCTAssert(star < 4)
            }
        }
    }
}
