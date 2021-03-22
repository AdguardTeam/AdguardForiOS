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

class FiltersMetadataRequest: RequestProtocol {
    
    var urlRequest: URLRequest? {
        let path = "\(ABEC_FILTER_URL_BASE)filters.js"
        
        var params: [String: Any] = [
            "v": ADProductInfo().version() ?? "",
            "lang": "\(ADLocales.lang() ?? "en")-\(ADLocales.region() ?? "US")"
        ]
        
#if os(iOS)
        params["id"] = Bundle.main.isPro ? "ios_pro" : "ios"
        params["cid"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
#endif

        guard let resultStr = params.constructLink(url: path),
            let resultUrl = URL(string: resultStr) else  {
            DDLogError("FiltersMetadataRequest errror - can not construct url" )
            return nil
        }
        
        var request = URLRequest(url: resultUrl)//, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: TimeInterval(ABEC_BACKEND_READ_TIMEOUT))
        request.httpMethod = "GET"
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
