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

// MARK: - RequestConfig

struct RequestConfig<Parser> where Parser: ParserProtocol {
    let request: RequestProtocol
    let parser: Parser
}

// MARK: - RequestSenderError

enum RequestSenderError: Error {
    case stringToUrlError
    case receivedDataParsingError
    
    var localizedDescription: String {
        switch self {
        case .stringToUrlError:
            return "Failed to cast string to URL"
        case .receivedDataParsingError:
            return "Failed to parse response data"
        }
    }
}

// MARK: - RequestSenderProtocol

protocol RequestSenderProtocol {
    func send<Parser>(requestConfig: RequestConfig<Parser>,
                      completion: @escaping(Result<Parser.Model>) -> Void)
}

// MARK: - RequestSender

/**
 This class is responsible for sending requests
 `send` method accepts `requestConfig` with `Parser` so it knows
 where to send request and how to parse the data from request's response
 */
final class RequestSender: RequestSenderProtocol{
    
    private let session: URLSession
    
    // Queue to send all HTTP requests concurrently
    private let requestQueue = DispatchQueue(label: "request sender queue", qos: .userInitiated, attributes: .concurrent)
    
    // MARK: - Initialization
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Internal method
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model>) -> Void) where Parser : ParserProtocol {
        let group = DispatchGroup()
        
        // Process HTTP requests in background
        // todo: ProcessInfo().performExpiringActivity if not availiable for mac os build
//        ProcessInfo().performExpiringActivity(withReason: "Sending HTTP request") { [weak self, group] expired in
//            Logger.logDebug("Sending request with URL = \(requestConfig.request.urlRequest?.url?.absoluteString ?? "nil"); expired = \(expired)")
            
            group.enter()
            /*self?.*/requestQueue.async {
//                if expired {
//                    let error = NSError(domain: "request.send.expired", code: 1, userInfo: nil)
//                    completion(.error(error))
//                } else {
                /*self?.*/self.sendInternal(requestConfig: requestConfig, completion: completion)
//                }
                group.leave()
            }
            group.wait()
//        }
    }
    
    // MARK: - Private method
    
    private func sendInternal<Parser>(requestConfig: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model>) -> Void) where Parser : ParserProtocol {
        guard let urlRequest = requestConfig.request.urlRequest else {
            let error = RequestSenderError.stringToUrlError
            Logger.logError("Error: \(error)")
            completion(.error(error))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                Logger.logError("Error: \(error)")
                completion(.error(error))
                return
            }
            guard let data = data,
                let parsedModel: Parser.Model = requestConfig.parser.parse(data: data, response: response)
                else {
                    let error = RequestSenderError.receivedDataParsingError
                    Logger.logError(error.localizedDescription)
                    completion(.error(error))
                    return
            }
            
            completion(.success(parsedModel))
        }
        
        task.resume()
    }
}
