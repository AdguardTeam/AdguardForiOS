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
    public let type: ContentBlockerType // Content blocker type the result is related with
    public let jsonString: String // String representation of converted JSON we receive from Converter Lib
    public let totalRules: Int // Total valis rules number, because some rules that we pass can be invalid
    public let totalConverted: Int // The result number of rules with Content blockers limit of 'contentBlockerRulesLimit' rules
    public let overlimit: Bool // Is true if totalRules is greater than 'contentBlockerRulesLimit' rules
    public let errorsCount: Int // Number of errors handled
    public let advancedBlockingConvertedCount: Int // Number of entries in advanced blocking part
    public let advancedBlockingJson: String? // Json string of advanced content blocker rules
    public let advancedBlockingText: String? // Text of advanced content blocker rules
    public let message: String // Result message
    
    public init(type: ContentBlockerType, jsonString: String, totalRules: Int, totalConverted: Int, overlimit: Bool, errorsCount: Int, advancedBlockingConvertedCount: Int, advancedBlockingJson: String?, advancedBlockingText: String?, message: String) {
        self.type = type
        self.jsonString = jsonString
        self.totalRules = totalRules
        self.totalConverted = totalConverted
        self.overlimit = overlimit
        self.errorsCount = errorsCount
        self.advancedBlockingConvertedCount = advancedBlockingConvertedCount
        self.advancedBlockingJson = advancedBlockingJson
        self.advancedBlockingText = advancedBlockingText
        self.message = message
    }
    
    public init(type: ContentBlockerType, conversionResult: ConversionResult) {
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
    init(converterResult: FiltersConverterResult) {
        self.init(
            totalConvertedCount: converterResult.totalRules,
            convertedCount: converterResult.totalConverted,
            errorsCount: converterResult.errorsCount,
            overLimit: converterResult.overlimit,
            converted: converterResult.jsonString,
            advancedBlockingConvertedCount: converterResult.advancedBlockingConvertedCount,
            advancedBlocking: converterResult.advancedBlockingJson,
            advancedBlockingText: converterResult.advancedBlockingText,
            message: converterResult.message
        )
    }
}
