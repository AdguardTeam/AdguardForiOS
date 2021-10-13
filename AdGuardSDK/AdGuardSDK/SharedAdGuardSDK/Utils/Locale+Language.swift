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

public extension Locale {

    enum Delimiter: String {
        case underScore = "_"
        case dash = "-"
    }

    /// Return list of suitable languages ordered by priority
    func provideSuitableLanguages(delimiter: Delimiter) -> [String] {
        var result: [String] = []

        let chinesMap = ["Hans" : "CN",
                         "Hant" : "TW"]

        let defaultLanguageCode = "en"
        let defaultRegionCode = "US"

        let languageCode = languageCode ?? defaultLanguageCode
        let scriptCode = scriptCode
        let variantCode = variantCode
        let regionCode = regionCode ?? defaultRegionCode

        result.append(languageCode)

        if let _ = variantCode, let script = scriptCode {
            result.append(languageCode + delimiter.rawValue + regionCode)
            if let mapValue = chinesMap[script] {
                result.append(languageCode + delimiter.rawValue + mapValue)
            }
        } else if let _ = variantCode, scriptCode == nil {
            result.append(languageCode + delimiter.rawValue + regionCode)
        } else if let scrip = scriptCode, variantCode == nil {
            if let mapValue = chinesMap[scrip] {
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
