/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

final class SendFeedbackRequest: RequestProtocol {
    
    private let feedBack: FeedBackProtocol
    
    init(_ feedBack: FeedBackProtocol) {
        self.feedBack = feedBack
    }
    
    var urlRequest: URLRequest? {
        let domain = "https://mobile.adtidy.org/"
        let command = "api/1.0/feedback.html"
        let key = "key=4DDBE80A3DA94D819A00523252FB6380"
        let request = domain + command + "?" + key
        
        if let url = URL(string: request) {
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let parameters: [String: Any] = [
                "applicationId" : feedBack.applicationId ?? "",
                "version" : feedBack.version ?? "",
                "email" : feedBack.email ?? "",
                "language" : feedBack.language ?? "",
                "subject" : feedBack.subject ?? "",
                "description" : feedBack.description ?? "",
                "applicationState" : feedBack.applicationState ?? "",
                "app_name" : feedBack.appName,
                "debugInfo" : feedBack.debugInfo ?? ""
            ]
            request.httpBody = parameters.percentEncoded()
            return request
        }
        return nil
    }
    
}
