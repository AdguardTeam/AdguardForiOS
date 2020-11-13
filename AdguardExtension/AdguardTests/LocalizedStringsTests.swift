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

import XCTest

enum FormatSpecifier: Equatable {
    case string(position: Int?)
    case digit(position: Int?)
    
    private static let stringSpecifier = "@"
    private static let digitSpecifier = "d"
    private static let longIntegerSpecifier = "lu"
    
    var position: Int? {
        switch self {
        case .string(position: let pos): return pos
        case .digit(position: let pos): return pos
        }
    }
    
    init?(specifier: String) {
        if let formatSpecifier = Self.processSpecifier(specifier) {
            self = formatSpecifier
        } else {
            return nil
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (let .string(lhsPosition), let .string(rhsPosition)): return lhsPosition == rhsPosition
        case (let .digit(lhsPosition), let .digit(rhsPosition)): return lhsPosition == rhsPosition
        default: return false
        }
        
    }
    
    private static func processSpecifier(_ specifier: String) -> Self? {
        switch specifier {
        case "%" + stringSpecifier: return .string(position: nil)
        case "%" + digitSpecifier: return .digit(position: nil)
        case "%" + longIntegerSpecifier: return .digit(position: nil)
        default: return processPositionalSpecifier(specifier)
        }
    }
    
    private static func processPositionalSpecifier(_ specifier: String) -> Self? {
        guard specifier.count == 4 else {
            XCTFail("Unknown specifier = \(specifier)")
            return nil
        }
        let characters = Array(specifier)
        // Positional specifiers look like %2$@, we need 2nd character to reveal position and 4th to reveal type
        let position = Int(String(characters[1]))
        let typeSpecifier = String(characters[3])
        
        switch typeSpecifier {
        case stringSpecifier: return .string(position: position)
        case digitSpecifier: return .digit(position: position)
        default:
            XCTFail("Unknown specifier = \(typeSpecifier)")
            return nil
        }
    }
}

class LocalizedStringsTests: XCTestCase {
    
    var bundle: Bundle { Bundle(for: type(of: self)) }
    
    /*
     \%[1-9]\$[a-zA-Z@]|\%[a-zA-Z]{1,2}|\%\@
     Regular expression for format specifiers such as %s, %d, %@, %2$@, %1$s, %lu
     */
    
    let pattern = "\\%[1-9]\\$[a-z@]|\\%[a-z]{1,2}|\\%\\@"
    lazy var regEx: NSRegularExpression = { try! NSRegularExpression(pattern: pattern) }()
    
    func testStrings() {
        
        let allSupportedLocalizations = bundle.localizations
        
        let enDict = getNormalStringsDictionary(forLocale: "en")
        let enFormatSpecifiers: [String: [FormatSpecifier]] = getFormats(enDict)
        
        for locale in allSupportedLocalizations {
            processNormalStrings(forLocale: locale, enFormatSpecifiers: enFormatSpecifiers)
        }
    }
    
    private func getNormalStringsDictionary(forLocale locale: String) -> NSDictionary {
        let path = bundle.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: locale)!
        return NSDictionary(contentsOfFile: path)!
    }
    
    private func getStringsDictDictionary(forLocale locale: String) -> NSDictionary {
        let path = bundle.path(forResource: "Localizable", ofType: "stringsdict", inDirectory: nil, forLocalization: locale)!
        return NSDictionary(contentsOfFile: path)!
    }
    
    private func processNormalStrings(forLocale locale: String, enFormatSpecifiers: [String: [FormatSpecifier]]) {
        let dict = getNormalStringsDictionary(forLocale: locale)
        let formatSpecifiers = getFormats(dict)
        
        compareFormats(enFormatSpecifiers: enFormatSpecifiers, formatSpecifiers: formatSpecifiers, locale: locale)
    }
    
    private func getFormats(_ dict: NSDictionary) -> [String: [FormatSpecifier]] {
        var arguments: [String: [FormatSpecifier]] = [:]
        for (key, string) in dict {
            let args = process(string: string as! String)
            arguments[key as! String] = args
        }
        return arguments
    }
    
    private func process(string: String) -> [FormatSpecifier] {
        let range = NSRange(string.startIndex..., in: string)
        
        var specifiersFound: [FormatSpecifier] = []
        regEx.enumerateMatches(in: string, options: [], range: range) { result, _, _ in
            let specifierRange = result!.range
            let str = string as NSString
            let specifier = str.substring(with: specifierRange)
            let formatSpecifier = FormatSpecifier(specifier: specifier)!
            specifiersFound.append(formatSpecifier)
        }

        return specifiersFound
    }
    
    private func compareFormats(enFormatSpecifiers: [String: [FormatSpecifier]], formatSpecifiers: [String: [FormatSpecifier]], locale: String) {
        for (key, enSpecifiers) in enFormatSpecifiers {
            if let localeSpecs = formatSpecifiers[key] {
                compareFormats(enFormatSpecifiers: enSpecifiers, formatSpecifiers: localeSpecs, locale: locale, key: key)
            }
        }
    }
    
    private func compareFormats(enFormatSpecifiers: [FormatSpecifier], formatSpecifiers: [FormatSpecifier], locale: String, key: String) {
        XCTAssertEqual(enFormatSpecifiers.count, formatSpecifiers.count, "Specifiers number differs from en for locale = \(locale), string key = \(key)")
        
        guard enFormatSpecifiers.count == formatSpecifiers.count else {
            return
        }
        
        let enAreNonPositional = enFormatSpecifiers.reduce(true, { $0 && $1.position == nil })
        let areNonPositional = formatSpecifiers.reduce(true, { $0 && $1.position == nil })
        
        let enArePositional = enFormatSpecifiers.reduce(true, { $0 && $1.position != nil })
        let arePositional = formatSpecifiers.reduce(true, { $0 && $1.position != nil })
        
        XCTAssertEqual(enAreNonPositional, areNonPositional, "Different specifiers type for locale = \(locale), string key = \(key)")
        XCTAssertEqual(enArePositional, arePositional, "Different specifiers type for locale = \(locale), string key = \(key)")
        
        guard enAreNonPositional == areNonPositional, enArePositional == arePositional else {
            return
        }
        
        let allNonPositional = areNonPositional
        let allPositional = arePositional
        
        let specifiersNumber = formatSpecifiers.count
        
        if allNonPositional {
            for i in 0..<specifiersNumber {
                let enSpecifier = enFormatSpecifiers[i]
                let localizedSpecifier = formatSpecifiers[i]
                
                XCTAssertNil(enSpecifier.position, "Different specifiers order for locale = \(locale), string key = \(key)")
                XCTAssertEqual(enSpecifier, localizedSpecifier, "Posotion is not nil for locale = \(locale), string key = \(key)")
            }
        }
        
        if allPositional {
            let enSortedSpecifiers = enFormatSpecifiers.sorted(by: { $0.position! < $1.position! })
            let localizedSortedSpecifier = formatSpecifiers.sorted(by: { $0.position! < $1.position! })
            
            XCTAssertEqual(enSortedSpecifiers, localizedSortedSpecifier, "Wrong specifiers position for locale = \(locale), string key = \(key)")
        }
    }
}
