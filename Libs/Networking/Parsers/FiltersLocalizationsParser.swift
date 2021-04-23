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

class FiltersLocalizationsParser: ParserProtocol {
    typealias Model = ABECFilterClientLocalization
    
    func parse(data: Data, response: URLResponse?) -> FiltersLocalizationsParser.Model? {
        if let response = response as? HTTPURLResponse {
            if response.statusCode != 200 {
                Logger.logError("FiltersMetadataParser load error. Status code: \(response.statusCode)")
                return nil
            }
            
            let jsonParser = JSONI18nParser()
            guard jsonParser.parse(with: data) else {
                Logger.logError("FiltersMetadataParser parse failed")
                return nil
            }
            
            let result = ABECFilterClientLocalization()
            result.date = Date()
            result.filters = jsonParser.filtersI18n()
            result.groups = jsonParser.groupsI18n()
            
            return result
        }
        return nil
    }
}
