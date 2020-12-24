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

protocol CustomSchemeURLParserProtocol {
    func parceAuthUrl() -> URLParserResult
    func parceUrl() -> URLParserResult
}

struct URLParserResult {
    var command: String?
    var params: [String: String]?
}

extension URL: CustomSchemeURLParserProtocol {
    
    func parceAuthUrl() -> URLParserResult {
        guard let components = splitURLByChar(separator: "#") else { return URLParserResult() }
        return prepareParams(components: components)
    }
    
    func parceUrl() -> URLParserResult {
        guard let components = splitURLByChar(separator: ":") else { return URLParserResult() }
        return prepareParams(components: components)
    }
    
    //MARK: - Private methods
    private func splitURLByChar(separator: Character) -> [String]? {
        let components = self.absoluteString.split(separator: separator, maxSplits: 1)
        if components.count != 2 {
            DDLogError("(CustomSchemeURLPareser) parseCustomUrlScheme error - unsupported url format")
            return nil
        }
        return components.compactMap { String($0) }
    }
    
    private func prepareParams(components: [String]) -> URLParserResult {
        let querry = components.last
        
        // try to parse url with question (adguard:subscribe?location=https://easylist.to/easylist/easylist.txt&title=EasyList)
        let questionComponents = querry?.split(separator: "?", maxSplits: 1)
        
        if questionComponents?.count == 2 {
            let command = String((questionComponents?.first)!)
            let queryString = String((questionComponents?.last)!)
            let params = queryString.getQueryParametersFromQueryString()
            
            return URLParserResult(command: command, params: params)
        }
        else if questionComponents?.count == 1 {
            // try to parse url without question (adguard:license=AAAA)
            let queryString = String((questionComponents?.last)!)
            let params = queryString.getQueryParametersFromQueryString()
            let command = params?.first?.key != nil ? params?.first!.key : nil
            return URLParserResult(command: command, params: params)
        }
        
        DDLogError("(CustomSchemeURLPareser) parseCustomUrlScheme error - unsupported url format")
        return URLParserResult()
    }
}
