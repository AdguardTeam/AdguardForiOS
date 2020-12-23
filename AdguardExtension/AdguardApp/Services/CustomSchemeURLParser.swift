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
    func parceAuthUrl(_ url: URL) -> (command: String?, params:[String: String]?)
    func parceUrl(_ url: URL) -> (command: String?, params:[String: String]?)
}

class CustomSchemeURLPareser: CustomSchemeURLParserProtocol {
    
    //MARK: - Methods
    func parceAuthUrl(_ url: URL) -> (command: String?, params:[String: String]?) {
        guard let components = splitURLByChar(url, separator: "#") else { return (nil, nil) }
        return prepareParams(components: components)
    }
    
    func parceUrl(_ url: URL) -> (command: String?, params:[String: String]?) {
        guard let components = splitURLByChar(url, separator: ":") else { return (nil, nil) }
        return prepareParams(components: components)
    }
    
    //MARK: - Private methods
    private func splitURLByChar(_ url: URL, separator: Character) -> [String.SubSequence]? {
        let components = url.absoluteString.split(separator: separator, maxSplits: 1)
        if components.count != 2 {
            DDLogError("(CustomSchemeURLPareser) parseCustomUrlScheme error - unsopported url format")
            return nil
        }
        return components
    }
    
    private func prepareParams(components: [String.SubSequence]) -> (command: String?, params:[String: String]?) {
        let querry = components.last
        
        // try to parse url with question (adguard:subscribe?location=https://easylist.to/easylist/easylist.txt&title=EasyList)
        let questionComponents = querry?.split(separator: "?", maxSplits: 1)
        
        if questionComponents?.count == 2 {
            let command = String((questionComponents?.first)!)
            let params = ACNUrlUtils.parameters(fromQueryString: String((questionComponents?.last)!))
            
            return (command, params)
        }
        else if questionComponents?.count == 1 {
            // try to parse url without question (adguard:license=AAAA)
            let params = ACNUrlUtils.parameters(fromQueryString: String((questionComponents?.last)!))
            let command = String(params.first!.key)
            return (command, params)
        }
        
        DDLogError("(CustomSchemeURLPareser) parseCustomUrlScheme error - unsopported url format")
        return (nil, nil)
    }
}
