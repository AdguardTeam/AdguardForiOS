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

struct YouTubeAdsJsResult {

    enum Status: String {
        case success
        case wrongDomain
        case alreadyExecuted
        case error

        var title: String {
            switch self {
            case .success: return String.localizedString("youtube_script_success_title")
            case .wrongDomain: return String.localizedString("youtube_script_wrong_domain_title")
            case .alreadyExecuted: return String.localizedString("youtube_script_already_executed_title")
            case .error: return String.localizedString("youtube_script_error_title")
            }
        }
    }

    let successfullyExecuted: Bool
    let status: Status

    init?(jsDict: [String: Any]) {
        guard let successfullyExecuted = jsDict["success"] as? Bool,
              let statusString = jsDict["status"] as? String,
              let status = Status(rawValue: statusString)
                else {
            return nil
        }

        self.successfullyExecuted = successfullyExecuted
        self.status = status
    }
}