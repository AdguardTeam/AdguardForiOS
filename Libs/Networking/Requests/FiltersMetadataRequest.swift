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

struct FiltersMetadataRequest: RequestProtocol {
    
    let version: String
    let id: String
    let cid: String
    let lang: String
    
    init(version: String, id: String, cid: String, lang: String) {
        self.version = version
        self.id = id
        self.cid = cid
        self.lang = lang
    }
    
    var urlRequest: URLRequest? {
        let path = "\(urlBase)filters.js"
        
        var params: [String: Any] = [
            "v": version,
            "lang": lang
        ]
        
#if os(iOS)
        params["id"] = id
        params["cid"] = cid
#endif

        guard let resultStr = params.constructLink(url: path),
            let resultUrl = URL(string: resultStr) else  {
            Logger.logError("FiltersMetadataRequest errror - can not construct url" )
            return nil
        }
        
        var request = URLRequest(url: resultUrl)
        request.httpMethod = "GET"
        
        return request
    }
}
