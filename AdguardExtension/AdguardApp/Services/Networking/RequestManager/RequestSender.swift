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

final class RequestSender: RequestSenderProtocol{
    
    let session = URLSession.shared
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) where Parser : ParserProtocol {
        
        guard let urlRequest = requestConfig.request.urlRequest else {
            completionHandler(Result.error(RequestSenderErrors.stringToUrlError))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.error(error))
                return
            }
            guard let data = data,
                let parsedModel: Parser.Model = requestConfig.parser.parse(data: data)
                else {
                    completionHandler(Result.error(RequestSenderErrors.receivedDataParsingError))
                    return
            }
            
            completionHandler(Result.success(parsedModel))
        }
        
        task.resume()
    }
}
