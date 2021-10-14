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

/// Transform given language codes into suitable for our provider and filter json localization files
public extension Locale {

    enum Delimiter: String {
        case underScore = "_"
        case dash = "-"
    }

    /**
     Function  returns list of sorted by priority suitable languages

     For example:
     Input language identifier     Result
     1. pt                                    -> [pt]
     2. pt_RU                            -> [pt_RU, pt]
     3. pt-BR_RU                      -> [pt_BR, pt]
     4. pt-Hans_RU                   -> [pt_CN, pt]
     5. pt-Hans-HK_RU             -> [pt_CN, pt_HK, pt]
     7. pt-Hans                          -> [pt_CN, pt]
     */
    func getSuitableLanguages(delimiter: Delimiter) -> [String] {
        var result: [String] = []

        let chineseMap = ["Hans" : "CN",
                          "Hant" : "TW"]

        let defaultLanguageCode = "en"
        let defaultRegionCode = "US"

        let languageCode = languageCode ?? defaultLanguageCode
        let regionCode = regionCode ?? defaultRegionCode

        result.append(languageCode)

        if variantCode != nil, let script = scriptCode {
            result.append(languageCode + delimiter.rawValue + regionCode)
            if let mapValue = chineseMap[script] {
                result.append(languageCode + delimiter.rawValue + mapValue)
            }
        } else if variantCode != nil, scriptCode == nil {
            result.append(languageCode + delimiter.rawValue + regionCode)
        } else if let scrip = scriptCode, variantCode == nil {
            if let mapValue = chineseMap[scrip] {
                result.append(languageCode + delimiter.rawValue + mapValue)
            }
        } else {
            if regionCode != defaultRegionCode {
                result.append(languageCode + delimiter.rawValue + regionCode)
            }
        }
        
        return result.reversed()
    }
}
