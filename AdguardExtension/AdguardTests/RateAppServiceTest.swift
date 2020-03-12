/**
            This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
            Copyright © Adguard Software Limited. All rights reserved.

            Adguard for iOS is free software: you can redistribute it and/or modify
            it under the terms of the GNU General Public License as published by
            the Free Software Foundation, either version 3 of the License, or
            (at your option) any later version.

            Adguard for iOS is distributed in the hope that it will be useful,
            but WITHOUT ANY WARRANTY; without even the implied warranty of
            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
            GNU General Public License for more details.

            You should have received a copy of the GNU General Public License
            along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import XCTest

class RateAppServiceTest: XCTestCase {

    private var resources: AESharedResourcesProtocol!
    private var rateAppService: RateAppServiceProtocol!
    
    private var currentBuild: Int {
        get {
            if let currentBuild = Int(ADProductInfo.buildNumber()) {
                return currentBuild
            }
            return 0
        }
    }
    
    override func setUp() {
        resources = SharedResourcesMock()
        rateAppService = RateAppService(resources: resources)
    }
    
    // MARK: - showRateAppAlertIfNeeded test
    
    func testAppEntryCountWillIncrement() {
        XCTAssert(resources.appEntryCount == 0)
        
        let lastBuildRateAppRequested = currentBuild - 1
        resources.lastBuildRateAppRequested = lastBuildRateAppRequested
        
        rateAppService.showRateAppAlertIfNeeded()
        
        XCTAssert(resources.appEntryCount == 1)
    }
    
    func testAppEntryCountWillNotIncrement() {
        resources.appEntryCount = 1
        
        let lastBuildRateAppRequested = currentBuild
        resources.lastBuildRateAppRequested = lastBuildRateAppRequested
        
        rateAppService.showRateAppAlertIfNeeded()
        
        XCTAssert(resources.appEntryCount == 1)
    }
    
    func testWillCallRequestReview() {
        resources.appEntryCount = 4
        
        let lastBuildRateAppRequested = currentBuild - 1
        resources.lastBuildRateAppRequested = lastBuildRateAppRequested
        
        rateAppService.showRateAppAlertIfNeeded()
        
        XCTAssert(resources.appEntryCount == 0)
        XCTAssertEqual(resources.lastBuildRateAppRequested, currentBuild)
    }
    
    func testWillNotCallRequestReview() {
        resources.appEntryCount = 2
        
        let lastBuildRateAppRequested = currentBuild - 1
        resources.lastBuildRateAppRequested = lastBuildRateAppRequested
        
        rateAppService.showRateAppAlertIfNeeded()
        
        XCTAssert(resources.appEntryCount == 3)
        XCTAssertNotEqual(resources.lastBuildRateAppRequested, currentBuild)
    }
}
