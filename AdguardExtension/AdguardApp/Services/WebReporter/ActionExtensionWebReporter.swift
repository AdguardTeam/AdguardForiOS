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

import SafariAdGuardSDK

/// Action extension web reporter
final class ActionExtensionWebReporter: WebReporterProtocol {

    private static let adguardForwarderUrl = "https://link.adtidy.org/forward.html"

    // MARK: - Private properties

    private let url: URL
    private let webReporterSafariFiltersWrapper: WebReporterWrapperProtocol
    private let productInfo: ADProductInfoProtocol

    // MARK: - Init

    init(url: URL, safariProtection: SafariProtectionProtocol, productInfo: ADProductInfoProtocol) {
        self.url = url
        self.webReporterSafariFiltersWrapper = WebReporterSafariFiltersWrapper(safariProtection: safariProtection)
        self.productInfo = productInfo
    }

    // MARK: - Public methods

    func createUrl() -> URL {
        var params: [String: String] = [
            "url": url.absoluteString,
            "product_type": "iOS",
            "product_version": productInfo.version(),
            "browser": "Safari"
        ]

        let safariFiltersParams = webReporterSafariFiltersWrapper.collectParams()
        assembleParams(result: &params, params: safariFiltersParams)

        let paramString = ABECRequest.createString(fromParameters: params)
        let url = "\(adguardUrl(action: "report", from: "action_extension", buildVersion: productInfo.buildVersion()))&\(paramString)"

        return URL(string: url)!
    }

    // MARK: - Private methods

    private func assembleParams(result: inout [String: String], params: [String: String]) {
        for key in params.keys {
            if let param = params[key] {
                result[key] = param
            }
        }
    }

    private func adguardUrl(action: String, from: String, buildVersion: String)->String {
        var params: Dictionary<String, String> = [:]

        params["app"] = "ios"
        params["v"] = buildVersion
        params["action"] = action
        params["from"] = from

        let paramsString = ABECRequest.createString(fromParameters: params)

        return ActionExtensionWebReporter.adguardForwarderUrl + "?" + paramsString
    }
}
