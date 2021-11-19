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

protocol AdServicesWrapperProtocol {
    @available(iOS 14.3, *)
    /// Get attribution records token
    func getAttributionToken() throws -> String
}

/// This object is a wrapper for supporting unit tests
final class AdServicesWrapper: AdServicesWrapperProtocol {
    @available(iOS 14.3, *)
    func getAttributionToken() throws -> String {
        return try AAAttribution.attributionToken()
    }
}
