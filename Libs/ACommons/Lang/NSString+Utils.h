/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

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

@interface NSString (Utils)

//////////////////////////////////////////////////////////////
#pragma mark - Utilities
//////////////////////////////////////////////////////////////

/** 
 Gets encoding from the encoding name. If not found - returns default
*/
+ (NSStringEncoding)encodingFromString:(NSString *)encodingName default:(NSStringEncoding)defaultEncoding;


//////////////////////////////////////////////////////////////
#pragma mark - C# and other sugar
//////////////////////////////////////////////////////////////
+ (BOOL)isNullOrEmpty:(NSString *)str;
+ (BOOL)isNullOrWhiteSpace:(NSString *)str;
+ (NSString *)stringByTrim:(NSString *)str;

/// Returns NSString object, which contains hex representation of data.
+ (NSString * )hexStringFromData:(NSData *)data;

- (NSString *)replace:(NSString *)from to:(NSString *)to;

/** 
 @return index of string into receiver, or -1 if not found
*/
- (NSInteger)indexOf:(NSString *)string fromIndex:(NSUInteger)index;
/**
 @return index of string into receiver, or -1 if not found
 */
- (NSInteger)indexOf:(NSString *)string;

/** Returns a string array that contains the substrings in this string that are delimited by elements of a specified string array. Parameters specify the maximum number of substrings to return and whether to return empty array elements.

 @param strings The separator array. An array of strings that delimit the substrings in this string, an empty array that contains no delimiters, or nil.

 @param count The maximum number of substrings to return.

 @param omitEmpty Set YES to omit empty array elements from the array returned.
 
 */
- (NSArray *)splitByArray:(NSArray *)strings count:(NSUInteger)count omitEmpty:(BOOL)omitEmpty;

- (BOOL)contains:(NSString *)str;

- (BOOL)contains:(NSString *)str caseSensitive:(BOOL)sensitive;

- (BOOL)asciiContains:(NSString *)string ignoreCase:(BOOL)ignoreCase;


/**
 Splits string in ascii mode by the delimiter, ignoring escaped delimiters (and empty parts).
 
 @return List with string parts, where escaped characters became unescaped.
 
 Exemples:
 
 NSArray *test = @[];
 XCTAssert([[@"    " asciiSplitByDelimiter:' ' escapeCharacter:'\\'] isEqual:@[]]);
 test = @[@" "];
 XCTAssert([test isEqualToArray:[@"\\     " asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str", @"str"];
 XCTAssert([test isEqualToArray:[@"str str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str", @"str"];
 XCTAssert([test isEqualToArray:[@" str str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str str"];
 XCTAssert([test isEqualToArray:[@"str\\ str" asciiSplitByDelimiter:' ' escapeCharacter:'\\']]);
 test = @[@"str,", @" ", @"\\st,r"];
 XCTAssert([test isEqualToArray:[@"str\\,, ,\\st\\,r" asciiSplitByDelimiter:',' escapeCharacter:'\\']]);
 
 */
- (NSArray *)asciiSplitByDelimiter:(char)delimiter escapeCharacter:(char)escapeCharacter;

/**
 *  Find any string from string array as substring in receiver.
 *
 *  @param strings An array of strings that finding in this string, an empty array that contains no strings, or nil.
 *
 *  @return YES if receiver contains any string from string array, otherwise NO.
 */
- (BOOL)containsAny:(NSArray *)strings;

/**
 *  Find any string from string array as substring in receiver.
 *
 *  @param strings An array of strings that finding in this string, an empty array that contains no strings, or nil.
 *
 *  @return Range of first occurence of any string from string array, otherwise range where range.location equals NSNotFound.
 */
- (NSRange)rangeOfAny:(NSArray *)strings;

/**
    Find any string from string array as substring in receiver.
 
    @param strings An array of strings that finding in this string, an empty array that contains no strings, or nil.
    @param startIndex Index, from it will be performed search.
 
    @return Range of first occurence of any string from string array, otherwise range where range.location equals NSNotFound.
 */
- (NSRange)rangeOfAny:(NSArray *)strings from:(NSUInteger)startIndex;

/// Searches a source string for substrings delimited by a start and end string.
/// Example [@"<a>123</a>" substringsBetween:@"<a>" and:@"</a>" ignoreCase:YES] --> @[@"123"]
/// @return All matching substrings in an list
- (NSArray *)substringsBetween:(NSString *)start and:(NSString *)end ignoreCase:(BOOL)ignoreCase;
/// Searches a source string for substrings delimited by a start and end string.
/// Example [@"<a>123</a>" substringsBetween:@"<a>" and:@"</a>"] --> @[@"123"]
/// @return All matching substrings in an list
- (NSArray *)substringsBetween:(NSString *)start and:(NSString *)end;

/// Gets MD5 digest, max string length 4GB.
- (NSString *)md5Digest;

/// Gets SHA256 digest, max string length 4GB.
- (NSString *)sha256Digest;

@end
