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
    private var configuration: ConfigurationServiceMock!
    
    override func setUp() {
        resources = SharedResourcesMock()
        configuration = ConfigurationServiceMock()
        rateAppService = RateAppService(resources: resources, configuration: configuration)
    }
    
    // MARK: - showRateAppAlertIfNeeded test
    
    func testAppEntryCountWillIncrement() {
        // It must be 1 after initialization
        XCTAssert(resources.appEntryCount == 1)
    }
    
    func testShouldShowRateAppDialog() {
        resources.appEntryCount = 2
        resources.rateAppShown = false
        configuration.allContentBlockersEnabled = true
        XCTAssertFalse(rateAppService.shouldShowRateAppDialog)
        
        resources.appEntryCount = 4
        resources.rateAppShown = false
        configuration.allContentBlockersEnabled = true
        XCTAssert(rateAppService.shouldShowRateAppDialog)
        
        resources.appEntryCount = 4
        resources.rateAppShown = true
        configuration.allContentBlockersEnabled = true
        XCTAssertFalse(rateAppService.shouldShowRateAppDialog)
        
        resources.appEntryCount = 4
        resources.rateAppShown = false
        configuration.allContentBlockersEnabled = false
        XCTAssertFalse(rateAppService.shouldShowRateAppDialog)
    }
}
