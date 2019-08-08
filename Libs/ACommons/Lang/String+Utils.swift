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

extension NSMutableAttributedString {
    
    func alignCenter(){
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.paragraphStyle: paragraph]
        self.addAttributes(attributes, range: NSRange(location: 0, length: length))
    }
}

extension String {
    
    func dataFromHex()-> Data {
        var hex = self
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    /* Func used in Filters to highlight search string */
    func highlight(search strings: [String?]?) -> NSAttributedString? {
        guard let searchStrings = strings else { return nil }
        
        let attributedString = NSMutableAttributedString(string: self)
        let highlightColor = UIColor(hexString: "#67b279")
        
        for string in searchStrings {
            guard let searchString = string else { continue }
            let nsString = self.lowercased() as NSString
            let nsRange = nsString.localizedStandardRange(of: searchString)

            if nsRange.location + nsRange.length > self.count{
                continue
            }
            
            attributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: highlightColor, range: nsRange)
        }
        
        return attributedString
    }
}

extension String {
    // Adds space every 3 symbols
    // Use for formatting numbers
    static func formatSringNumber(number: Int) -> String{
        let stringNumber = String(number)
        var str = String(stringNumber.reversed())
        str = String(str.enumerated().map { $0 > 0 && $0 % 3 == 0 ? [" ", $1] : [$1]}.joined())
        str = String(str.reversed())
        return str
    }
}
