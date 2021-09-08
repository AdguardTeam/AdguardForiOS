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
import ContentBlockerConverter

/* This struct is used to represent Converted Lib result and return only usefull info */
public struct FiltersConverterResult: Codable, Equatable {
    let type: ContentBlockerType // Content blocker type the result is related with
    let jsonString: String // String representation of converted JSON we receive from Converter Lib
    let totalRules: Int // Total valis rules number, because some rules that we pass can be invalid
    let totalConverted: Int // The result number of rules with Content blockers limit of 'contentBlockerRulesLimit' rules
    let overlimit: Bool // Is true if totalRules is greater than 'contentBlockerRulesLimit' rules
    let errorsCount: Int // Number of errors handled
    let advancedBlockingConvertedCount: Int // Number of entries in advanced blocking part
    let advancedBlockingJson: String? // Json string of advanced content blocker rules
    let advancedBlockingText: String? // Text of advanced content blocker rules
    let message: String // Result message
    
    init(type: ContentBlockerType, conversionResult: ConversionResult) {
        self.type = type
        self.jsonString = conversionResult.converted
        self.totalRules = conversionResult.totalConvertedCount
        self.totalConverted = conversionResult.convertedCount
        self.overlimit = conversionResult.overLimit
        self.errorsCount = conversionResult.errorsCount
        self.advancedBlockingConvertedCount = conversionResult.advancedBlockingConvertedCount
        self.advancedBlockingJson = conversionResult.advancedBlocking
        self.advancedBlockingText = conversionResult.advancedBlockingText
        self.message = conversionResult.message
    }
}

public extension ConversionResult {
    // TODO: - missing advancedBlockingText in init
    init(converterResult: FiltersConverterResult) {
        self.init(
            totalConvertedCount: converterResult.totalRules,
            convertedCount: converterResult.totalConverted,
            errorsCount: converterResult.errorsCount,
            overLimit: converterResult.overlimit,
            converted: converterResult.jsonString,
            advancedBlockingConvertedCount: converterResult.advancedBlockingConvertedCount,
            advancedBlocking: converterResult.advancedBlockingJson,
            message: converterResult.message
        )
    }
}
