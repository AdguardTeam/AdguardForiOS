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

class IAdFrameworkHelperTest: XCTestCase {

    private var helper: IAdFrameworkHelperProtocol!
    private var adClientWrapper: ADClientWrapperMock!

    private let testError = NSError(domain: "test_domain", code: 1, userInfo: nil)

    override func setUp() {
        adClientWrapper = ADClientWrapperMock()
        helper = IAdFrameworkHelper(adClientWrapper: adClientWrapper)
    }

    func testFetchAttributionRecordsWithSuccess() {
        adClientWrapper.stubbedRequestAttributionDetailsCompletionHanderResult = .success(adClientWrapper.adClientAttributionRecords)

        helper.fetchAttributionRecords { records in
            switch records {
            case .success(let json):
                XCTAssertFalse(json.isEmpty)
                XCTAssertEqual(json, self.adClientWrapper.attributionRecords as! [String: String])
            case .error(let error): XCTFail("\(error)")
            }
        }

        XCTAssertEqual(adClientWrapper.invokedRequestAttributionDetailsCount, 1)
    }

    func testFetchAttributionRecordsWithEmptyData() {
        adClientWrapper.stubbedRequestAttributionDetailsCompletionHanderResult = .success([:])

        helper.fetchAttributionRecords { records in
            switch records {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as! AppleSearchAdsService.AdsError,
                               AppleSearchAdsService.AdsError.missingAttributionData)
            }
        }

        XCTAssertEqual(adClientWrapper.invokedRequestAttributionDetailsCount, 1)
    }

    func testFetchAttributionRecordsWithError() {
        adClientWrapper.stubbedRequestAttributionDetailsCompletionHanderResult = .failure(testError)

        helper.fetchAttributionRecords { records in
            switch records {
            case .success(_): XCTFail()
            case .error(let error):
                XCTAssertEqual(error as NSError, self.testError)
            }
        }

        XCTAssertEqual(adClientWrapper.invokedRequestAttributionDetailsCount, 1)
    }
}
