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

import SharedAdGuardSDK

protocol AdServicesHelperProtocol {
    @available(iOS 14.3, *)
    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String]>) -> Void)
}

private let LOG = LoggerFactory.getLoggerWrapper(AdServicesHelper.self)

/// This object is a helper for `AppleSearchAdsService` and works with AdService framework
final class AdServicesHelper: AdServicesHelperProtocol {

    // MARK: - Private properties

    private let httpRequestService: HttpRequestServiceProtocol
    private let adServicesWrapper: AdServicesWrapperProtocol

    // MARK: - Init

    init(httpRequestService: HttpRequestServiceProtocol,
         adServicesWrapper: AdServicesWrapperProtocol) {
        self.httpRequestService = httpRequestService
        self.adServicesWrapper = adServicesWrapper
    }

    // MARK: - Public methods

    @available(iOS 14.3, *)
    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String]>) -> Void) {
        do {
            let attributionToken = try adServicesWrapper.getAttributionToken()
            httpRequestService.getAttributionRecords(attributionToken) { result in
                switch result {
                case .success(let json):
                    if json.isEmpty {
                        LOG.error("Search Ads data is missing")
                        completionHandler(.error(AppleSearchAdsService.AdsError.missingAttributionData))
                        return
                    }

                    completionHandler(.success(json))
                case .failure(let error):
                    LOG.error("On http request error: \(error)")
                    completionHandler(.error(error))
                }
            }
        } catch {
            LOG.error("Attribution token error occurred: \(error)")
            completionHandler(.error(error))
        }
    }
}
