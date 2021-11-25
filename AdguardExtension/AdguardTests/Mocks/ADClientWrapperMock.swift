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

import Foundation

class ADClientWrapperMock: AdClientWrapperProtocol {

    var adClientAttributionRecords: [String: NSObject] {
        let copy = attributionRecords.copy() as! NSDictionary
        return ["Version3.1": copy]
    }

     let attributionRecords: NSMutableDictionary = [
        "iad-attribution": "true",
        "iad-campaign-id": "1234567890",
        "iad-org-name": "org name",
        "iad-org-id": "555555",
        "iad-campaign-id": "11111111",
        "iad-campaign-name": "campaign name",
        "iad-purchase-date": "2020-08-04T17:18:07Z",
        "iad-conversion-date": "2020-08-04T17:18:07Z",
        "iad-conversion-type": "newdownload",
        "iad-click-date": "2020-08-04T17:17:00Z",
        "iad-adgroup-id": "12345678",
        "iad-adgroup-name": "adgroup name",
        "iad-country-or-region": "US",
        "iad-keyword": "keyword",
        "iad-keyword-id": "12345678",
        "iad-keyword-matchtype": "Broad",
        "iad-creativeset-id": "12345678",
        "iad-creativeset-name": "Creative Set name"
    ]

    var invokedRequestAttributionDetails = false
    var invokedRequestAttributionDetailsCount = 0
    var stubbedRequestAttributionDetailsCompletionHanderResult: Result<[String: NSObject], Error> = .success([:])

    func requestAttributionDetails(completionHander: @escaping (Result<[String: NSObject], Error>) -> Void) {
        invokedRequestAttributionDetails = true
        invokedRequestAttributionDetailsCount += 1
        completionHander(stubbedRequestAttributionDetailsCompletionHanderResult)
    }
}
