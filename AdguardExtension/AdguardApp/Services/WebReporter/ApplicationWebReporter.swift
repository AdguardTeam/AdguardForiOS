///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import SafariAdGuardSDK

/// Application web reporter
final class ApplicationWebReporter: WebReporterProtocol {

    // MARK: - Private properties

    private let safariFiltersWrapper: WebReporterWrapperProtocol
    private let dnsProtectionWrapper = WebReporterDnsProtectionWrapper()
    private let reportUrl = "https://reports.adguard.com/new_issue.html" // TODO: - It should be TDS link

    // MARK: - Init

    init() {
        let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
        self.safariFiltersWrapper = WebReporterSafariFiltersWrapper(safariProtection: safariProtection)
    }

    // MARK: - Public methods

    func createUrl() -> URL {
        var params: [String: String] = [
            "product_type": "iOS",
            "product_version": ADProductInfo().version(),
            "browser": "Safari"
        ]

        let safariFiltersParams = safariFiltersWrapper.collectParams()
        assembleParams(result: &params, params: safariFiltersParams)

        let dnsProtectionParams = dnsProtectionWrapper.collectParams()
        assembleParams(result: &params, params: dnsProtectionParams)

        let paramString = ABECRequest.createString(fromParameters: params)
        let url = "\(reportUrl)?\(paramString)"

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
}
