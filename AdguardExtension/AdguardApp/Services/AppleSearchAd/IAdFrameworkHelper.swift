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

protocol IAdFrameworkHelperProtocol {
    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String], Error>) -> Void)
}

final class IAdFrameworkHelper: IAdFrameworkHelperProtocol {

    private let adClientWrapper: AdClientWrapperProtocol

    init(adClientWrapper: AdClientWrapperProtocol) {
        self.adClientWrapper = adClientWrapper
    }

    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String], Error>) -> Void) {
        adClientWrapper.requestAttributionDetails { attributionDetails, error in
            if let error = error {
                DDLogError("(IAdFrameworkHelper) - fetchAttributionRecordsWithIAd; Search Ads error: \(error)")
                completionHandler(.failure(error))
                return
            }

            guard let attributionDetails = attributionDetails else {
                DDLogError("(IAdFrameworkHelper) - fetchAttributionRecordsWithIAd; Search Ads error:")
                completionHandler(.failure(AppleSearchAdsService.AdsError.missingAttributionData))
                return
            }

            var json = [String: String]()
            for (version, adDictionary) in attributionDetails {
                DDLogInfo("(IAdFrameworkHelper) - fetchAttributionRecordsWithIAd; Search Ads version: \(version)")
                if let attributionInfo = adDictionary as? [String: String] {
                    json = attributionInfo
                }
            }

            if json.isEmpty {
                DDLogError("(IAdFrameworkHelper) - fetchAttributionRecordsWithIAd; Search Ads data is missing")
                completionHandler(.failure(AppleSearchAdsService.AdsError.missingAttributionData))
                return
            }

            if json["iad-campaign-id"] == AppleSearchAdsService.AdsError.campaignMockId {
                DDLogError("(IAdFrameworkHelper) - fetchAttributionRecordsWithIAd; Received mock data")
                completionHandler(.failure(AppleSearchAdsService.AdsError.mockData))
                return
            }

            completionHandler(.success(json))
        }
    }
}
