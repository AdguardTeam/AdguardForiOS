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

@available(iOS 14.3, *)
class AdServicesHelperTest: XCTestCase {

    private var helper: AdServicesHelperProtocol!
    private var httpRequestService: HttpRequestServiceMock!
    private var adServicesWrapper: AdServicesWrapperMock!

    private let testError = NSError(domain: "test_domain", code: 1, userInfo: nil)

    override func setUp() {
        httpRequestService = HttpRequestServiceMock()
        adServicesWrapper = AdServicesWrapperMock()
        helper = AdServicesHelper(httpRequestService: httpRequestService,
                                  adServicesWrapper: adServicesWrapper)
    }

    func testFetchAttributionRecordsWithSuccess() {
        let expectation = XCTestExpectation()
        let attributionData = getAttributionData(withClickDate: false)
        let sender = RequestSenderMock(valueToReturn: .success(attributionData))
        httpRequestService.stubbedRequestSender = sender
        adServicesWrapper.stubbedGetAttributionTokenResult = "token"
        helper.fetchAttributionRecords { result in
            switch result {
            case .success(let json):
                XCTAssertFalse(json.isEmpty)
                XCTAssertNil(json["clickDate"])
                XCTAssertEqual(json, attributionData)
                expectation.fulfill()
            case .failure(let error): XCTFail("\(error)")
            }
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(adServicesWrapper.invokedGetAttributionTokenCount, 1)
        XCTAssertEqual(httpRequestService.invokedRequestSenderGetterCount, 1)
    }

    func testFetchAttributionRecordsWithSuccessClickDate() {
        let expectation = XCTestExpectation()
        let attributionData = getAttributionData(withClickDate: true)
        let sender = RequestSenderMock(valueToReturn: .success(attributionData))
        httpRequestService.stubbedRequestSender = sender
        adServicesWrapper.stubbedGetAttributionTokenResult = "token"
        helper.fetchAttributionRecords { result in
            switch result {
            case .success(let json):
                XCTAssertFalse(json.isEmpty)
                XCTAssertNotNil(json["clickDate"])
                XCTAssertEqual(json["clickDate"], attributionData["clickDate"])
                XCTAssertEqual(json, attributionData)
                expectation.fulfill()
            case .failure(let error): XCTFail("\(error)")
            }
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(adServicesWrapper.invokedGetAttributionTokenCount, 1)
        XCTAssertEqual(httpRequestService.invokedRequestSenderGetterCount, 1)
    }

    func testFetchAttributionRecordsWithRequestError() {
        let expectation = XCTestExpectation()
        let sender = RequestSenderMock(valueToReturn: .failure(testError))
        httpRequestService.stubbedRequestSender = sender
        adServicesWrapper.stubbedGetAttributionTokenResult = "token"
        helper.fetchAttributionRecords { result in
            switch result {
            case .success(_): XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as NSError, self.testError)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(adServicesWrapper.invokedGetAttributionTokenCount, 1)
        XCTAssertEqual(httpRequestService.invokedRequestSenderGetterCount, 1)
    }

    func testFetchAttributionRecordsWithEmptyData() {
        let expectation = XCTestExpectation()
        let sender = RequestSenderMock(valueToReturn: .success([:]))
        httpRequestService.stubbedRequestSender = sender
        adServicesWrapper.stubbedGetAttributionTokenResult = "token"
        helper.fetchAttributionRecords { result in
            switch result {
            case .success(_): XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! AppleSearchAdsService.AdsError,
                               AppleSearchAdsService.AdsError.missingAttributionData)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(adServicesWrapper.invokedGetAttributionTokenCount, 1)
        XCTAssertEqual(httpRequestService.invokedRequestSenderGetterCount, 1)
    }

    func testFetchAttributionRecordsWithAdServiceError() {
        let expectation = XCTestExpectation()
        let attributionData = getAttributionData(withClickDate: true)
        let sender = RequestSenderMock(valueToReturn: .success(attributionData))
        httpRequestService.stubbedRequestSender = sender
        adServicesWrapper.stubbedGetAttributionTokenError = testError
        adServicesWrapper.stubbedGetAttributionTokenResult = "token"
        helper.fetchAttributionRecords { result in
            switch result {
            case .success(_): XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as NSError, self.testError)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(adServicesWrapper.invokedGetAttributionTokenCount, 1)
        XCTAssertEqual(httpRequestService.invokedRequestSenderGetterCount, 0)
    }

    private func getAttributionData(withClickDate: Bool) -> [String: String] {
        let clickDate = withClickDate ? "2020-04-08T17:17Z" : nil
        let records = AttributionRecords(attribution: true, orgId: 40669820, campaignId: 542370539, conversionType: "Download", clickDate: clickDate, adGroupId: 542317095, countryOrRegion: "US", keywordId: 87675432, creativeSetId: 542317136)
        return records.jsonMap
    }
}
