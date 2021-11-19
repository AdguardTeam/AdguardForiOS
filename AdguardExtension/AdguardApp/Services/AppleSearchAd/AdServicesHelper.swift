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

protocol AdServicesHelperProtocol {
    @available(iOS 14.3, *)
    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String], Error>) -> Void)
}

final class AdServicesHelper: AdServicesHelperProtocol {

    private let httpRequestService: HttpRequestServiceProtocol
    private let adServicesWrapper: AdServicesWrapperProtocol

    init(httpRequestService: HttpRequestServiceProtocol,
         adServicesWrapper: AdServicesWrapperProtocol) {
        self.httpRequestService = httpRequestService
        self.adServicesWrapper = adServicesWrapper
    }

    @available(iOS 14.3, *)
    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String], Error>) -> Void) {
        do {
            let attributionToken = try adServicesWrapper.getAttributionToken()
            httpRequestService.getAttributionRecords(attributionToken) { result in
                switch result {
                case .success(let json):
                    if json.isEmpty {
                        DDLogError("(AdServicesHelper) - fetchAttributionRecordsWithAdServices; Search Ads data is missing")
                        completionHandler(.failure(AppleSearchAdsService.AdsError.missingAttributionData))
                        return
                    }

                    if json["campaignId"] == AppleSearchAdsService.AdsError.campaignMockId {
                        DDLogError("(AdServicesHelper) - fetchAttributionRecordsWithAdServices; Received mock data")
                        completionHandler(.failure(AppleSearchAdsService.AdsError.mockData))
                        return
                    }

                    completionHandler(.success(json))
                case .failure(let error):
                    DDLogError("(AdServicesHelper) - fetchAttributionRecordsWithAdServices; Error")
                    completionHandler(.failure(error))
                }
            }
        } catch {
            DDLogError("(AdServicesHelper) - fetchAttributionRecordsWithAdServices; Attribution token error occurred: \(error)")
            completionHandler(.failure(error))
        }
    }
}
