//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import XCTest

class AppleSearchAdsServiceTest: XCTestCase {

    private var service: AppleSearchAdsServiceProtocol!
    private var adServicesHelper: AdServicesHelperMock!
    private var iAdFrameworkHelper: IAdFrameworkHelperMock!

    private let testError = NSError(domain: "test_domain", code: 1, userInfo: nil)

    override func setUp() {
        adServicesHelper = AdServicesHelperMock()
        iAdFrameworkHelper = IAdFrameworkHelperMock()

        service = AppleSearchAdsService(adServicesHelper: adServicesHelper, iAdFrameworkHelper: iAdFrameworkHelper)
    }

    func testProvideAttributionRecordsWithSuccess() {
        let expectation = XCTestExpectation()
        if #available(iOS 14.3, *) {
            adServicesHelper.stubbedFetchAttributionRecordsCompletionHandlerResult = .success(["foo": "bar"])
        } else {
            iAdFrameworkHelper.stubbedFetchAttributionRecordsCompletionHandlerResult = .success(["foo": "bar"])
        }
        service.provideAttributionRecords { jsonString in
            XCTAssertNotNil(jsonString)
            XCTAssertFalse(jsonString!.isEmpty)
            XCTAssert(jsonString!.contains("foo=bar"))
            if #available(iOS 14.3, *) {
                XCTAssert(jsonString!.contains("v=adservices"))
            } else {
                XCTAssert(jsonString!.contains("v=iadframework"))
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        if #available(iOS 14.3, *) {
            XCTAssertEqual(adServicesHelper.invokedFetchAttributionRecordsCount, 1)
        } else {
            XCTAssertEqual(iAdFrameworkHelper.invokedFetchAttributionRecordsCount, 1)
        }
    }

    func testProvideAttributionRecordsWithEmptyRecords() {
        let expectation = XCTestExpectation()
        if #available(iOS 14.3, *) {
            adServicesHelper.stubbedFetchAttributionRecordsCompletionHandlerResult = .success([:])
        } else {
            iAdFrameworkHelper.stubbedFetchAttributionRecordsCompletionHandlerResult = .success([:])
        }
        service.provideAttributionRecords { jsonString in
            XCTAssertNotNil(jsonString)
            XCTAssertFalse(jsonString!.isEmpty)
            if #available(iOS 14.3, *) {
                XCTAssert(jsonString! == "v=adservices")
            } else {
                XCTAssert(jsonString! == "v=iadframework")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        if #available(iOS 14.3, *) {
            XCTAssertEqual(adServicesHelper.invokedFetchAttributionRecordsCount, 1)
        } else {
            XCTAssertEqual(iAdFrameworkHelper.invokedFetchAttributionRecordsCount, 1)
        }
    }

    func testProvideAttributionRecordsWithError() {
        let expectation = XCTestExpectation()
        if #available(iOS 14.3, *) {
            adServicesHelper.stubbedFetchAttributionRecordsCompletionHandlerResult = .failure(testError)
        } else {
            iAdFrameworkHelper.stubbedFetchAttributionRecordsCompletionHandlerResult = .failure(testError)
        }

        service.provideAttributionRecords { jsonString in
            XCTAssertNil(jsonString)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        if #available(iOS 14.3, *) {
            XCTAssertEqual(adServicesHelper.invokedFetchAttributionRecordsCount, 1)
        } else {
            XCTAssertEqual(iAdFrameworkHelper.invokedFetchAttributionRecordsCount, 1)
        }
    }
}
