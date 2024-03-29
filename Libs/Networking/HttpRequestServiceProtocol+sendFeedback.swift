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

extension HttpRequestServiceProtocol {
    func sendFeedback(_ feedback: FeedBackProtocol, completion: @escaping (_ success: Bool)->()) {
        let config = RequestFactory.sendFeedbackConfig(feedback)
        requestSender.send(requestConfig: config) { (result: Result<Bool, Error>) in
            switch result{
            case .success(let isSuccess):
                completion(isSuccess)
            case .failure(_):
                completion(false)
            }
        }
    }

    /// HTTP POST request for getting attribution records
    func getAttributionRecords(_ attributionToken: String, completion: @escaping (_ result: Result<[String: String], Error>) -> Void) {
        let config = RequestFactory.attributionRecordsConfig(attributionToken)
        requestSender.send(requestConfig: config, completionHandler: completion)
    }
}
