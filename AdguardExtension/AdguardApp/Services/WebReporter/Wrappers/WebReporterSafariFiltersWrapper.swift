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

//TODO: Need write tests
/// Safari filters web reporter wrapper
struct WebReporterSafariFiltersWrapper: WebReporterWrapperProtocol {
    // MARK: - Private properties

    private let safariProtection: SafariProtectionProtocol

    // MARK: - Init

    init(safariProtection: SafariProtectionProtocol) {
        self.safariProtection = safariProtection
    }

    // MARK: - Public methods

    func collectParams() -> [String : String] {
        var params: [String: String] = [:]
        let filterIds = collectPreparedFiltersIds()
        params["filters"] = filterIds
        return params
    }

    // MARK: - Private methods

    private func collectPreparedFiltersIds() -> String {
        return safariProtection.groups
            .filter { $0.isEnabled }
            .flatMap { $0.filters }
            .reduce("") { partialResult, filter in
                if filter.isEnabled {
                    let separator = partialResult.isEmpty ? "" : "."
                    return partialResult + "\(separator)\(filter.filterId)"
                }
                return partialResult
            }
    }
}
