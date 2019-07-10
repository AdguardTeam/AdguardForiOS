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
#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - AESFiltersConverter Constants
/////////////////////////////////////////////////////////////////////

/**
    Error domain for problem in converter.
 */
extern NSString * _Nonnull AESFConverterError;

#define AESF_ERROR_WRONG_DICTIONARY     10

/**
 Dictionary key, it value represents converter error.
 Value type is NSError.
 */
extern NSString * _Nonnull AESFConvertedErrorKey;

/**
 Dictionary key, it value represents total count of the converted rules
 (before truncation to limit).
 Value type is NSNumber.
 */
extern NSString * _Nonnull AESFTotalConvertedCountKey;
/**
 Dictionary key, it value represents count of the converted rules.
 Value type is NSNumber.
 */
extern NSString * _Nonnull AESFConvertedCountKey;
/**
 Dictionary key, it value represents count of the erros during convertion.
 Value type is NSNumber.
 */
extern NSString * _Nonnull AESErrorsCountKey;
/**
 Dictionary key, it value represents json with converted rules. 
 Value type is NSString.
 */
extern NSString * _Nonnull AESFConvertedRulesKey;

/**
 Dictionary key, it value represents flag, 
 which indicates that maximum count of rules was exceeded. 
 Value type is NSNumber (bool).
 */
extern NSString * _Nonnull AESFCOverLimitKey;

/////////////////////////////////////////////////////////////////////
#pragma mark - AESFiltersConverter
/////////////////////////////////////////////////////////////////////


@protocol AESFilterConverterProtocol <NSObject>

/**
 Converts array of the filter rules to JSON string.
 
 @param rules       Array of ASDFilterRule objects, each object represents filter rule.
 @param limit       Maximum count of the rules, which may be converted.
 @param optimize    If true - "wide" rules will be ignored
 
 @return Returns dictionary with results or nil if error occured.
 Dictionary contains keys: AESFConvertedCountKey, AESFConvertedRulesKey, AESFCOoverLimitKey
 */
- (nullable NSDictionary *)jsonFromRules:(nonnull NSArray *)rules upTo:(NSUInteger)limit optimize:(BOOL)optimize;

@end

/**
 Converter from Adguard filter rules 
 to Apple content-blocking extension rules format.
 */
@interface AESFilterConverter : NSObject<AESFilterConverterProtocol>

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and Public methods
/////////////////////////////////////////////////////////////////////

- (null_unspecified instancetype)init;


@end
