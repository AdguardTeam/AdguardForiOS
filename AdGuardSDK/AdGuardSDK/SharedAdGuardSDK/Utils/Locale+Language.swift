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
    func getSuitableLanguages(delimiter: Delimiter) -> [String] {
        var result: [String] = []

        let chineseMap = ["Hans" : "CN",
                          "Hant" : "TW"]

        let defaultLanguageCode = "en"
        let defaultRegionCode = "US"
        let exclusionSpanishLanguage = "es"

        let languageCode = languageCode ?? defaultLanguageCode
        let regionCode = regionCode ?? defaultRegionCode

        let isSpanish = languageCode == exclusionSpanishLanguage
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

        // if language is Spanish than create language like es_ES or es-ES
        if isSpanish {
            result.append(exclusionSpanishLanguage + delimiter.rawValue + exclusionSpanishLanguage.uppercased())
        }

        return result.reversed()
    }
}
