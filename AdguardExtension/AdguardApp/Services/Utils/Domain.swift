//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

/// This object is responsible for working with domain objects
struct Domain {

    enum ParsingError: Error, CustomDebugStringConvertible {
        case emptyInputString
        case emptyParsingResult

        var debugDescription: String {
            switch self {
            case .emptyInputString: return "Input string is empty"
            case .emptyParsingResult: return "Parsing result is empty"
            }
        }
    }

    /// Regex string domains and subdomains for any languages
    static private let regExString = "(?:[\\p{L}0-9](?:[\\p{L}0-9-]{0,}[\\p{L}0-9])?\\.)+[\\p{L}0-9][\\p{L}0-9-]{0,}[\\p{L}0-9]"

    /// Parses string and returns domains with subdomains (if it exists).
    /// Throws error if input string is empty, if parsing result is empty or if regex pattern is wrong
    static func parse(_ string: String) throws -> [String] {
        if string.isEmpty { throw ParsingError.emptyInputString }

        let regex = try NSRegularExpression(pattern: regExString)
        let range = NSRange(string.startIndex..., in: string)
        let regexResult = regex.matches(in: string, range: range)
        let allMatches: [String] = regexResult.compactMap {
            guard let range = Range($0.range, in: string) else { return nil }
            return String(string[range])
        }
        if allMatches.isEmpty { throw ParsingError.emptyParsingResult }
        return allMatches
    }
}
