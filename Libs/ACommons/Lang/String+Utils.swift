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
    
    static func fromHtml(_ html: String, fontSize: CGFloat, color: UIColor, attachmentImage: UIImage?)->NSMutableAttributedString? {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
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
    
    // Adds space every 3 symbols
    // Use for formatting numbers
    static func formatSringNumber(number: Int) -> String{
        let stringNumber = String(number)
        var str = String(stringNumber.reversed())
        str = String(str.enumerated().map { $0 > 0 && $0 % 3 == 0 ? [",", $1] : [$1]}.joined())
        str = String(str.reversed())
        return str
    }
    
    func checkIfValidDnsServer() -> Bool {
        let charSet = CharacterSet(charactersIn: self)
        let validCharsSet = CharacterSet.urlPathAllowed
        return charSet.isSubset(of: validCharsSet) && self.count > 0
    }
    
    static func localizedString(_ key: String)->String {
        return ACLocalizedString(key, nil)
    }
    
    /**
     Converts kBytes to text and appropriate units
     */
    static func dataUnitsConverter(_ kBytes: Int) -> String {
        
        let mBytePower = pow(2.0, 10.0) // 2^10 (1024) kBytes in 1 mByte
        let gBytePower = pow(2.0, 20.0) // 2^20 (1048576) kBytes in 1gByte
        
        let gBytes = Double(kBytes) / gBytePower
        if gBytes > 1 {
            let gBytesString = String.formatNumberBySpace(NSNumber(floatLiteral: gBytes))
            return String(format: String.localizedString("gb_unit"), gBytesString)
        }
        
        let mBytes = Double(kBytes) / mBytePower
        if mBytes > 1 {
            let mBytesString = String.formatNumberBySpace(NSNumber(floatLiteral: mBytes))
            return String(format: String.localizedString("mb_unit"), mBytesString)
        }
        
        let kBytesString = String.formatNumberBySpace(NSNumber(integerLiteral: kBytes))
        return String(format: String.localizedString("kb_unit"), kBytesString)
    }
    
    /**
    Converts number to string and devides thousands by space, ignores decimal part
    Example: 202089,34 -> 202 089
    */
    static func formatNumberBySpace(_ number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.groupingSeparator = " "
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
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
}
