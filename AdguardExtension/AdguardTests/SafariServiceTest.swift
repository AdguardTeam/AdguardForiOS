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

class SafariServiceTest: XCTestCase {
    
    var safariService: SafariService!
    var safariManager: SafariManagerMock!

    override func setUp() {
        safariManager = SafariManagerMock()
        let resources = SharedResourcesMock()
        safariService = SafariService(resources: resources)
        safariService.contentBlockerManager = safariManager
    }

    override func tearDown() {
        
    }
    
    
    func testInvalidateOneCB() {
        testInvalidateOne(errors: [false], expectError: false)
    }
    
    func testInvalidateOneCBWithError() {
        testInvalidateOne(errors: [true, true/*for second try*/], expectError: true)
    }
    
    func testInvalidateOneCBWithErrorOnFirstTry() {
        testInvalidateOne(errors: [true, false/*for second try*/], expectError: false)
    }
    
    func testInvalidateOneCBWithErrorOnFirstTryManytimes() {
        testInvalidateManyTimes(errors: [true, false/*for second try*/], expectError: false)
    }
    
    func testInvalidateAllSuccess() {
        testInvalidateAll(errors: [Bool](), expectError: false) 
    }
    
    func testInvalidateAllFailure() {
        testInvalidateAll(errors: [true, true], expectError: true)
    }
    
    func testInvalidateAllManyTimesSuccess() {
        testInvalidateAllManyTimes(errors: [true, false], expectError: false)
    }
    
    func testInvalidateAllManyTimesFailure() {
        testInvalidateAllManyTimes(errors: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true], expectError: true)
    }
    
    // MARK: - private methods
    
    func testInvalidateOne(errors:[Bool], expectError: Bool) {
        
        let expectation = XCTestExpectation()
        
        let bundleId = SafariService.contenBlockerBundleIdByType[.general]
        safariManager.errors = [bundleId!: errors]
        
        safariService.invalidateBlockingJson(type: .general) { (error) in
            
            expectError ? XCTAssertNotNil(error) : XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testInvalidateManyTimes(errors:[Bool], expectError: Bool) {
        
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 10
        
        let bundleId = SafariService.contenBlockerBundleIdByType[.general]
        safariManager.errors = [bundleId!: errors]
        
        for _ in 0..<10 {
            safariService.invalidateBlockingJson(type: .general) { (error) in
                
                expectError ? XCTAssertNotNil(error) : XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        
        XCTAssertTrue(safariManager.maximumCount == 1)
    }
    
    func testInvalidateAll(errors:[Bool], expectError: Bool) {
        
        let expectation = XCTestExpectation()
        
        let bundleId = SafariService.contenBlockerBundleIdByType[.general]
        safariManager.errors = [bundleId!: errors]
        
        safariService.invalidateBlockingJsons { (error) in
            
            expectError ? XCTAssertNotNil(error) : XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testInvalidateAllManyTimes(errors:[Bool], expectError: Bool) {
        
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 10
        
        let bundleId = SafariService.contenBlockerBundleIdByType[.general]
        safariManager.errors = [bundleId!: errors]
        safariManager.sleepTime = 0.1
        
        for _ in 0..<10 {
            safariService.invalidateBlockingJsons { (error) in
                
                expectError ? XCTAssertNotNil(error) : XCTAssertNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 15.0)
        
        XCTAssertTrue(safariManager.maximumCount == 1)
    }
}
