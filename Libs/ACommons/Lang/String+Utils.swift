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
    
    static func fromHtml(_ html: String, fontSize: CGFloat, color: UIColor, attachmentImage: UIImage?, textAlignment: NSTextAlignment = .left) -> NSMutableAttributedString? {
        
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        
        let format = NSMutableString(string: html)
        let wrapped = "<span style=\"font-family: -apple-system; font-size: \(fontSize); color: \(color.hex())\">\(format)</span>"
        guard let htmlData = wrapped.data(using: .utf8) else { return nil}
        
        guard let resultText = try? NSMutableAttributedString(
            data: htmlData,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding:NSNumber(value:String.Encoding.utf8.rawValue)],
            documentAttributes: nil) else { return nil }
        
        if attachmentImage != nil {
            
            let imageRange = resultText.mutableString.range(of: "%@")
            resultText.replaceCharacters(in: imageRange, with: "")
            
            let attachment = NSTextAttachment()
            attachment.image = attachmentImage
            attachment.bounds = CGRect(x: 0, y: -5, width: Double(attachmentImage!.cgImage!.width) / 2.5, height: Double(attachmentImage!.cgImage!.height) / 2.5)
            
            let attachmentString = NSAttributedString(attachment: attachment)
            resultText.insert(attachmentString, at: imageRange.location)
        }
        
        resultText.addAttributes([NSAttributedString.Key.paragraphStyle : style], range: NSRange(location: 0, length: resultText.length))
                
        return resultText
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
        let highlightColor = UIColor.AdGuardColor.green
        
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
    
    // Adds space every 3 symbols
    // Use for formatting numbers
    static func formatSringNumber(number: Int) -> String{
        let stringNumber = String(number)
        var str = String(stringNumber.reversed())
        str = String(str.enumerated().map { $0 > 0 && $0 % 3 == 0 ? [",", $1] : [$1]}.joined())
        str = String(str.reversed())
        return str
    }
    
    func isValidUpstream() -> Bool {
        let charSet = CharacterSet(charactersIn: self)
        var validCharsSet = CharacterSet.urlPathAllowed
        validCharsSet.insert("%")
        validCharsSet.insert("[")
        validCharsSet.insert("]")
        return charSet.isSubset(of: validCharsSet) && self.count > 0
    }
    
    /*
     Discards port from IP address
     94.140.14.15:52 -> 94.140.14.15
     [2a10:50c0::bad1:ff]:53 -> 2a10:50c0::bad1:ff
     Returns initial string if fails to fetch IP address
     */
    func discardPortFromIpAddress() -> String {
        /// Check if string looks like ip address
        guard let firstChar = self.first, firstChar == "[" || firstChar.isNumber else {
            return self
        }
        
        if self.contains("[") && self.contains("]") {
            let leftQuotePosition = self.firstIndex(of: "[")!
            let rightQuotePosition = self.firstIndex(of: "]")!
            
            let leftQuoteIndex = self.index(leftQuotePosition, offsetBy: 1)
            let rightQuoteIndex = self.index(rightQuotePosition, offsetBy: -1)
            
            guard leftQuoteIndex < rightQuoteIndex else {
                return self
            }
            let ipAddress = self[leftQuoteIndex...rightQuoteIndex]
            return String(ipAddress)
        } else {
            let parts = self.split(separator: ":")
            guard parts.count == 2 else {
                return self
            }
            return String(parts[0])
        }
    }
    
    static func localizedString(_ key: String)->String {
        return ACLocalizedString(key, nil)
    }
    
    
    static func simpleSecondsFormatter(_ number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.minimumFractionDigits = 0
        
        let seconds = number.doubleValue / 1000000
        if seconds >= 1 {
            formatter.maximumFractionDigits = 0
            let formatterString = formatter.string(from: NSNumber(floatLiteral: seconds)) ?? "\(number.intValue)"
            return String(format: String.localizedString("s_unit"), formatterString)
        }
        
        let miliseconds = number.doubleValue / 1000
        if miliseconds >= 1 {
            formatter.maximumFractionDigits = 1
            let formatterString = formatter.string(from: NSNumber(floatLiteral: miliseconds)) ?? "\(number.intValue)"
            return String(format: String.localizedString("ms_unit"), formatterString)
        }
        
        formatter.maximumFractionDigits = 0
        let formatterString = formatter.string(from: number) ?? "\(number.intValue)"
        return String(format: String.localizedString("ms_unit"), formatterString)
    }
    
    /*
     Formats a number, devides thousands with separator, depending on current locale
     */
    static func simpleThousandsFormatting(_ number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: number) ?? "\(number.intValue)"
    }
    
    /**
    Converts number to string, ignores decimal part
    Formatted by locale
    */
    static func formatNumberByLocale(_ number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        let decimalNumber: Double = number.doubleValue
        
        /* Asian countries from this array have a different way of formatting numbers */
        let specialAsianCountriesCodes = ["zh", "ko", "ja"]
        let currentLocaleLanguageCode = Locale.current.languageCode ?? ""
        
        if specialAsianCountriesCodes.contains(currentLocaleLanguageCode) {
            
            let hundredMillions = decimalNumber / 100000000
            if hundredMillions > 1 {
                let hundredMillionsString = formatter.string(from: NSNumber(floatLiteral: hundredMillions)) ?? "0"
                return String(format: String.localizedString("hundred_millions_unit"), hundredMillionsString)
            }
            
            let tenThousands = decimalNumber / 10000
            if tenThousands > 100 {
                let tenThousandsString = formatter.string(from: NSNumber(floatLiteral: tenThousands)) ?? "0"
                return String(format: String.localizedString("ten_thousands_unit"), tenThousandsString)
            }
            
            return formatter.string(from: number) ?? "0"
        }
        
        /* This is normal formatting */
        let millions = decimalNumber / 1000000
        if millions > 1 {
            let millionsString = formatter.string(from: NSNumber(floatLiteral: millions)) ?? "0"
            return String(format: String.localizedString("millions_unit"), millionsString)
        }
        
        let thousands = decimalNumber / 1000
        if thousands > 100 {
            let thousandsString = formatter.string(from: NSNumber(floatLiteral: thousands)) ?? "0"
            return String(format: String.localizedString("thousands_unit"), thousandsString)
        }
        
        return formatter.string(from: number) ?? "0"
    }
    
    /**
    Generates subdomains from top level domain
    */
    static func generateSubDomains(from domain: String) -> [String] {
        let newDomain = domain.hasSuffix(".") ? String(domain.dropLast()) : domain
        
        var subdomains = newDomain.split(separator: ".")
        var domainsToReturn: [String] = []
        
        while subdomains.count >= 2{
            let newSubDomain = subdomains.joined(separator: ".")
            domainsToReturn.append(newSubDomain)
            subdomains = Array(subdomains.dropFirst())
        }
        return domainsToReturn
    }
    
    /* Checks if the string is valid email */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func getQueryParametersFromQueryString() -> [String: String]? {
        var params: [String: String] = [:]
        let pairs = self.components(separatedBy: "&")
        for pair in pairs {
            let values = pair.components(separatedBy: "=")
            if values.count == 2 {
                params[values[0]] = values[1]
            }
            
            if values.count == 1 {
                continue
            }
        }
        
        return params.count > 0 ? params : nil
    }
}
