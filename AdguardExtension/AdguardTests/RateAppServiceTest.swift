import XCTest

class RateAppServiceTest: XCTestCase {
    
    var resources: AESharedResourcesProtocol!
    var userNotificationService: UserNotificationServiceProtocol!
    var configuration: ConfigurationServiceProtocol!
    var rateAppService: RateAppServiceProtocol!
    var testableDate: TestableDateProtocol!

    override func setUp() {
        resources = SharedResourcesMock()
        userNotificationService = UserNotificationServiceMock()
        configuration = ConfigurationServiceMock()
        testableDate = TestableDateMock()
        
        rateAppService = RateAppService(resources: resources, configuration: configuration, userNotificationService: userNotificationService, testableDate)
    }
    
    func testInit(){
        let _ = RateAppService(resources: resources, configuration: configuration, userNotificationService: userNotificationService)
        
        let firstLaunchDate = resources.sharedDefaults().value(forKey: AEDefaultsFirstLaunchDate) as? Date
        let now = testableDate.currentDate
        
        XCTAssertEqual(Int(now.timeIntervalSinceReferenceDate), Int(firstLaunchDate!.timeIntervalSinceReferenceDate))
    }
    
    func testRateAppAlertNeedsShowingWithNoLaunchDate(){
        configuration.appRated = false
        resources.sharedDefaults().set(nil, forKey: AEDefaultsFirstLaunchDate)
        XCTAssert(rateAppService.rateAppAlertNeedsShowing == false)
    }
    
    /* Current Date() is set in init */
    func testRateAppAlertNeedsShowingWithUnsuitableTimeInterval(){
        configuration.appRated = false
        XCTAssert(rateAppService.rateAppAlertNeedsShowing == false)
    }
    
    func testRateAppAlertNeedsShowingWithSuitableTimeIntervalWithAppNotRated(){
        configuration.appRated = false
        
        let minInterval: Double = 24.0 * 3600.0 // 1 day
        let dateToTestInt = testableDate.currentDate.timeIntervalSinceReferenceDate - minInterval
        let dateToTest = Date(timeIntervalSinceReferenceDate: dateToTestInt)
        
        resources.sharedDefaults().set(dateToTest, forKey: AEDefaultsFirstLaunchDate)
                
        XCTAssert(rateAppService.rateAppAlertNeedsShowing == true)
    }
    
    func testShowRateDialogIfNeededWithSuitableTimeIntervalWithAppRated(){
        configuration.appRated = true
        
        let minInterval: Double = 24.0 * 3600.0 // 1 day
        let dateToTestInt = testableDate.currentDate.timeIntervalSinceReferenceDate - minInterval
        let dateToTest = Date(timeIntervalSinceReferenceDate: dateToTestInt)
        
        resources.sharedDefaults().set(dateToTest, forKey: AEDefaultsFirstLaunchDate)

        XCTAssert(rateAppService.rateAppAlertNeedsShowing == false)
    }
    
    func testShowRateNotificationIfNeededCallsPostNotification(){
        // Create appropriate conditions for showing alert
        resources.appRatingNotificationShown = false
        testRateAppAlertNeedsShowingWithSuitableTimeIntervalWithAppNotRated()
        
        if let userNotificationService = userNotificationService as? UserNotificationServiceMock {
            XCTAssert(userNotificationService.postNotificationWasCalled == false)
            rateAppService.showRateNotificationIfNeeded()
            XCTAssert(resources.appRatingNotificationShown == true)
            XCTAssert(userNotificationService.postNotificationWasCalled == true)
            return
        }
        XCTAssert(false)
    }
    
    func testShowRateNotificationIfNeededDoesntCallPostNotification(){
        // Create appropriate conditions for showing alert and app was already rated
        resources.appRatingNotificationShown = true
        testRateAppAlertNeedsShowingWithSuitableTimeIntervalWithAppNotRated()
        
        if let userNotificationService = userNotificationService as? UserNotificationServiceMock {
            XCTAssert(userNotificationService.postNotificationWasCalled == false)
            rateAppService.showRateNotificationIfNeeded()
            XCTAssert(resources.appRatingNotificationShown == true)
            XCTAssert(userNotificationService.postNotificationWasCalled == false)
            return
        }
        XCTAssert(false)
    }
    
    func testShowRateNotificationIfNeededDoesntCallPostNotificationAndNotificationIsNotShown(){
        // Create inappropriate conditions for showing alert
        resources.appRatingNotificationShown = false
        testShowRateDialogIfNeededWithSuitableTimeIntervalWithAppRated()
        
        if let userNotificationService = userNotificationService as? UserNotificationServiceMock {
            XCTAssert(userNotificationService.postNotificationWasCalled == false)
            rateAppService.showRateNotificationIfNeeded()
            XCTAssert(resources.appRatingNotificationShown == false)
            XCTAssert(userNotificationService.postNotificationWasCalled == false)
            return
        }
        XCTAssert(false)
    }
    
    func testShowRateNotificationIfNeededDoesntCallPostNotificationAndNotificationIsShown(){
        // Create inappropriate conditions for showing alert
        resources.appRatingNotificationShown = true
        testShowRateDialogIfNeededWithSuitableTimeIntervalWithAppRated()
        
        if let userNotificationService = userNotificationService as? UserNotificationServiceMock {
            XCTAssert(userNotificationService.postNotificationWasCalled == false)
            rateAppService.showRateNotificationIfNeeded()
            XCTAssert(resources.appRatingNotificationShown == true)
            XCTAssert(userNotificationService.postNotificationWasCalled == false)
            return
        }
        XCTAssert(false)
    }

    func testCancelTappedFirstTime(){
        // Check if cancelTappedWhenAppRating is nil
        XCTAssertNil(resources.cancelTappedWhenAppRating)
        
        rateAppService.cancelTapped()
        
        guard let firstLaunchDate = resources.firstLaunchDate else { return }
        let firstLaunch = firstLaunchDate.timeIntervalSinceReferenceDate
        let now = testableDate.currentDate.timeIntervalSinceReferenceDate
        let week: Double = 3600.0 * 7.0 // 7 days
        let newTimeInterval = now - firstLaunch + week
        
        XCTAssert(resources.minTimeIntervalToRate == Int(newTimeInterval))
    }
    
    func testCancelTappedSecondTime(){
        // Check if cancelTappedWhenAppRating is nil
        XCTAssertNil(resources.cancelTappedWhenAppRating)
        
        // Tapping first time
        rateAppService.cancelTapped()
        
        guard let firstLaunchDate = resources.firstLaunchDate else { return }
        let firstLaunch = firstLaunchDate.timeIntervalSinceReferenceDate
        let now = testableDate.currentDate.timeIntervalSinceReferenceDate
        let week: Double = 3600.0 * 7.0 // 7 days
        let newTimeInterval = now - firstLaunch + week
        
        XCTAssert(resources.minTimeIntervalToRate == Int(newTimeInterval))
        
        // Check if cancelTappedWhenAppRating is not nil
        XCTAssertNotNil(resources.cancelTappedWhenAppRating)
        
        /**
         Tapping second time must do nothing to minTimeIntervalToRate and just exit the method
         */
        rateAppService.cancelTapped()
        XCTAssert(resources.minTimeIntervalToRate == Int(newTimeInterval))
    }
    
    func testRateApp(){
        for star in 1...5 {
            rateAppService.rateApp(star) {
                XCTAssert(star < 4)
            }
        }
    }
}
