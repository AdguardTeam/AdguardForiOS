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

class AdServicesAttributionRecordsParserTest: XCTestCase {

    private var parser: AdServicesAttributionRecordsParser!

    override func setUp() {
        parser = AdServicesAttributionRecordsParser()
    }

    func testParseWithSuccess() {
        let response = HTTPURLResponse(url: URL(string: "foo")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = getAttributedData()
        let result = parser.parse(data: data, response: response)
        XCTAssertFalse(result!.isEmpty)
    }

    func testParseWithBadStatusCode() {
        let response = HTTPURLResponse(url: URL(string: "foo")!, statusCode: 500, httpVersion: nil, headerFields: nil)
        let data = getAttributedData()
        let result = parser.parse(data: data, response: response)
        XCTAssertNil(result)
    }

    func testParseWithNilResponse() {
        let data = getAttributedData()
        let result = parser.parse(data: data, response: nil)
        XCTAssertNil(result)
    }


    private func getAttributedData() -> Data {
        let records = AttributionRecords(attribution: true, orgId: 1, campaignId: 1, conversionType: "", clickDate: nil, adGroupId: 1, countryOrRegion: "", keywordId: 1, creativeSetId: 1)

        return try! JSONEncoder().encode(records)
    }
}
