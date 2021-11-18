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

#if canImport(AdServices)
import AdServices
#endif

protocol AppleSearchAdsServiceProtocol {
    /// Provides attribution records in string JSON format
    func provideAttributionRecords(completionHandler: @escaping (_ jsonString: String?) -> Void)
}

// MARK: - AppleSearchAdsServiceError

fileprivate enum AppleSearchAdsServiceError: Error, CustomDebugStringConvertible {
    case missingAttributionData
    case mockData

    var debugDescription: String {
        switch self {
        case .missingAttributionData: return "Attribution data was missing"
        case .mockData: return "Received mock data"
        }
    }

    /// Apples mock id
    static let campaignMockId = "1234567890"
}

// MARK: - UsedFrameworks

fileprivate enum UsedFrameworks {
    ///  for iAd framework response:
    ///  https://developer.apple.com/documentation/iad/setting_up_apple_search_ads_attribution/
    ///  for AdServices framework response:
    ///  https://developer.apple.com/documentation/adservices/aaattribution/3697093-attributiontoken

    case iAd
    case AdServices
}

/// This object is responsible for providing attribution records
final class AppleSearchAdsService: AppleSearchAdsServiceProtocol {

    // MARK: - Private properties

    private let completionQueue = DispatchQueue(label: "AdGuardApp.AppleSearchAdsServiceCompletionQueue")
    private let workingQueue = DispatchQueue(label: "AdGuardApp.AppleSearchAdsServiceQueue")
    private let httpRequestService: HttpRequestServiceProtocol
    private let adClientWrapper: AdClientWrapperProtocol

    // MARK: - Init

    init(httpRequestService: HttpRequestServiceProtocol = HttpRequestService(),
         adClientWrapper: AdClientWrapperProtocol = AdClientWrapper()) {
        self.httpRequestService = httpRequestService
        self.adClientWrapper = adClientWrapper
    }

    // MARK: - Public methods

    func provideAttributionRecords(completionHandler: @escaping (_ jsonString: String?) -> Void) {
        workingQueue.async { [weak self] in
            if #available(iOS 14.3, *) {
                self?.fetchAttributionRecordsWithAdServices { result in
                    self?.processResult(result, type: .AdServices, completionHandler: completionHandler)
                }
            } else {
                self?.fetchAttributionRecordsWithIAd { result in
                    self?.processResult(result, type: .iAd, completionHandler: completionHandler)
                }
            }
        }
    }

    // MARK: - AdServices framework methods

    @available(iOS 14.3, *)
    private func fetchAttributionRecordsWithAdServices(completionHandler: @escaping (Result<[String: String], Error>) -> Void) {
        do {
            let attributionToken = try AAAttribution.attributionToken()
            httpRequestService.getAttributionRecords(attributionToken) { result in
                switch result {
                case .success(let json):
                    if json.isEmpty {
                        DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithAdServices; Search Ads data is missing")
                        completionHandler(.failure(AppleSearchAdsServiceError.missingAttributionData))
                        return
                    }

                    if json["campaignId"] == AppleSearchAdsServiceError.campaignMockId {
                        DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithAdServices; Received mock data")
                        completionHandler(.failure(AppleSearchAdsServiceError.mockData))
                        return
                    }

                    completionHandler(.success(json))
                case .failure(let error):
                    DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithAdServices; Error")
                    completionHandler(.failure(error))
                }
            }
        } catch {
            DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithAdServices; Attribution token error occurred: \(error)")
            completionHandler(.failure(AppleSearchAdsServiceError.missingAttributionData))
        }
    }

    // MARK: - iAd Framework methods

    private func fetchAttributionRecordsWithIAd(completionHandler: @escaping (Result<[String: String], Error>) -> Void) {
        adClientWrapper.requestAttributionDetails { attributionDetails, error in
            if let error = error {
                DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithIAd; Search Ads error: \(error)")
                completionHandler(.failure(error))
                return
            }

            guard let attributionDetails = attributionDetails else {
                DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithIAd; Search Ads error:")
                completionHandler(.failure(AppleSearchAdsServiceError.missingAttributionData))
                return
            }

            var json = [String: String]()
            for (version, adDictionary) in attributionDetails {
                DDLogInfo("(AppleSearchAdsService) - fetchAttributionRecordsWithIAd; Search Ads version: \(version)")
                if let attributionInfo = adDictionary as? [String: String] {
                    json = attributionInfo
                }
            }

            if json.isEmpty {
                DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithIAd; Search Ads data is missing")
                completionHandler(.failure(AppleSearchAdsServiceError.missingAttributionData))
                return
            }

            if json["iad-campaign-id"] == AppleSearchAdsServiceError.campaignMockId {
                DDLogError("(AppleSearchAdsService) - fetchAttributionRecordsWithIAd; Received mock data")
                completionHandler(.failure(AppleSearchAdsServiceError.mockData))
                return
            }

            completionHandler(.success(json))
        }
    }

    // MARK: - Private methods

    private func convertJSONtoStringJSON(json: [String: String], type: UsedFrameworks) -> String? {
        var json = json
        switch type {
        case .iAd:
            json["v"] = "iadframework"
        case .AdServices:
            json["v"] = "adservices"
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            DDLogError("(AppleSearchAdsService) - convertJSONtoStringJSON; Error occurred while trying to serialize attribution json data with framework = \(type); Error: \(error)")
            return nil
        }
    }

    private func processResult(
        _ result: Result<[String : String], Error>,
        type: UsedFrameworks,
        completionHandler: @escaping (_ jsonString: String?) -> Void
    ) {
        let jsonString: String?
        switch result {
        case .success(let json):
            jsonString = convertJSONtoStringJSON(json: json, type: type)
        case .failure(let error):
            jsonString = nil
            DDLogError("(AppleSearchAdsService) - processResult; Error occurred while receiving attribution records for framework = \(type); Error: \(error)")
        }
        completionQueue.async { completionHandler(jsonString) }
    }
}
