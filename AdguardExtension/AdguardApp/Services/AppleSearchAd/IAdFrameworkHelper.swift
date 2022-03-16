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

protocol IAdFrameworkHelperProtocol {
    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String]>) -> Void)
}

private let LOG = LoggerFactory.getLoggerWrapper(IAdFrameworkHelper.self)

/// This object is a helper for `AppleSearchAdsService` and works with iAd framework
final class IAdFrameworkHelper: IAdFrameworkHelperProtocol {

    // MARK: - Private properties

    private let adClientWrapper: AdClientWrapperProtocol

    // MARK: - Init

    init(adClientWrapper: AdClientWrapperProtocol) {
        self.adClientWrapper = adClientWrapper
    }

    // MARK: - Public methods

    func fetchAttributionRecords(completionHandler: @escaping (Result<[String: String]>) -> Void) {
        adClientWrapper.requestAttributionDetails { [weak self] result in
            switch result {
            case .success(let details):
                self?.processAttributionDetails(details, completionHandler: completionHandler)
            case .failure(let error):
                LOG.error("Search Ads error: \(error)")
                completionHandler(.error(error))
                return
            }
        }
    }

    private func processAttributionDetails(_ attributionDetails: [String: NSObject], completionHandler: @escaping (Result<[String: String]>) -> Void) {

        var json = [String: String]()
        for (version, adDictionary) in attributionDetails {
            LOG.info("Search Ads version: \(version)")
            if let attributionInfo = adDictionary as? [String: String] {
                json = attributionInfo
            }
        }

        if json.isEmpty {
            LOG.error("Search Ads data is missing")
            completionHandler(.error(AppleSearchAdsService.AdsError.missingAttributionData))
            return
        }

        completionHandler(.success(json))
    }
}
