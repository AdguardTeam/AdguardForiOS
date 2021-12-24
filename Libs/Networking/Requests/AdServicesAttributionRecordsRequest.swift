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

/// This object represent URL request
final class AdServicesAttributionRecordsRequest: RequestProtocol {

    //MARK: - Public properties

    /// URL request with Apple API to receive attribution records
    var urlRequest: URLRequest? {
        let request = "https://api-adservices.apple.com/api/v1/"

        if let url = URL(string: request) {
            var request = URLRequest(url: url)
            request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = Data(attributionToken.utf8)
            return request
        }
        return nil
    }

    // MARK: - Private properties

    private let attributionToken: String

    // MARK: - Init

    init(_ attributionToken: String) {
        self.attributionToken = attributionToken
    }
}
