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

protocol AppleSearchAdsServiceProtocol {
    /// Provides attribution records in string JSON format
    func provideAttributionRecords(completionHandler: @escaping (_ paramString: String?) -> Void)
}

// MARK: - UsedFrameworks

fileprivate enum UsedFrameworks {
    case iAd
    case adServices
}

/// This object is responsible for providing attribution records
/// for iAd framework response:
/// https://developer.apple.com/documentation/iad/setting_up_apple_search_ads_attribution/
/// for AdServices framework response:
/// https://developer.apple.com/documentation/adservices/aaattribution/3697093-attributiontoken
final class AppleSearchAdsService: AppleSearchAdsServiceProtocol {

    // MARK: - AppleSearchAdsServiceError

     enum AdsError: Error, CustomDebugStringConvertible {
        case missingAttributionData

        var debugDescription: String {
            switch self {
            case .missingAttributionData: return "Attribution data was missing"
            }
        }
    }

    // MARK: - Private properties

    private let completionQueue = DispatchQueue(label: "AdGuardApp.AppleSearchAdsServiceCompletionQueue")
    private let workingQueue = DispatchQueue(label: "AdGuardApp.AppleSearchAdsServiceQueue")

    private let adServicesHelper: AdServicesHelperProtocol
    private let iAdFrameworkHelper: IAdFrameworkHelperProtocol


    // MARK: - Init

    init(adServicesHelper: AdServicesHelperProtocol,
         iAdFrameworkHelper: IAdFrameworkHelperProtocol) {
        self.adServicesHelper = adServicesHelper
        self.iAdFrameworkHelper = iAdFrameworkHelper
    }

    // MARK: - Public methods

    func provideAttributionRecords(completionHandler: @escaping (_ paramString: String?) -> Void) {
        workingQueue.async { [weak self] in
            if #available(iOS 14.3, *) {
                self?.adServicesHelper.fetchAttributionRecords{ result in
                    self?.processResult(result, type: .adServices, completionHandler: completionHandler)
                }
            } else {
                self?.iAdFrameworkHelper.fetchAttributionRecords { result in
                    self?.processResult(result, type: .iAd, completionHandler: completionHandler)
                }
            }
        }
    }

    // MARK: - Private methods

    private func convertJSONtoParameterString(json: [String: String], type: UsedFrameworks) -> String {
        var json = json
        switch type {
        case .iAd:
            json["v"] = "iadframework"
        case .adServices:
            json["v"] = "adservices"
        }

        let result = json.map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
            .joined(separator: "&")
        return result
    }

    private func processResult(
        _ result: Result<[String : String], Error>,
        type: UsedFrameworks,
        completionHandler: @escaping (_ jsonString: String?) -> Void
    ) {
        let jsonString: String?
        switch result {
        case .success(let json):
            jsonString = convertJSONtoParameterString(json: json, type: type)
        case .failure(let error):
            jsonString = nil
            DDLogError("(AppleSearchAdsService) - processResult; Error occurred while receiving attribution records for framework = \(type); Error: \(error)")
        }
        completionQueue.async { completionHandler(jsonString) }
    }
}
