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
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Utils.h"
#import "NSException+Utils.h"
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#define CHARSET_ARRAY_CAPACITY 5
#define RANGE_REALLOC_SIZE 50

// helper function
static inline char itoh(int i) {
    if (i > 9)
        return 'a' + (i - 10);
    return '0' + i;
}

BOOL asciiContains(NSString *self, char *chars, CFIndex length, BOOL ignoreCase);

@interface NSString (Utils_Private)

/**
 *  Getting a list of ranges occurrences of the strings from the input array. In
 *array, valid range have value of length > 0
 *
 *  @param strings       Array of strings, that will be finding in receiver
 *  @param anyString     Type of finding, if YES then stop processing on first
 *occurrence of any string from strings
 *  @param startIndex    Index, from it will be performed search.
 *  @param selfChars     Returning parameter. Pointer to unicode chars of SELF
 *  @param charsNeedFree Retunring parameter. If YES caller must free memory for
 *selfChars
 *  @param ranges        Retunring parameter. Pointer to array of ranges or nil
 *if not found occurrences
 *
 *  @warning Method allocates memory for ranges array and selfChars. But caller
 *responds for free memory (using "free" function)
 *
 *  @return Length of ranges array or NSNotFound if not found occurrences
 */
- (CFIndex)rangesForSplitByArray:(NSArray *)strings
                             any:(BOOL)anyString
                            from:(CFIndex)startIndex
                       selfChars:(unichar **)selfChars
               selfCharsNeedFree:(BOOL *)charsNeedFree
                          ranges:(NSRange **)ranges;

- (BOOL)uniContains:(NSString *)string;

@end

@implementation NSString (Utils)

/// Gets encoding from the encoding name. If not found - returns default
+ (NSStringEncoding)encodingFromString:(NSString *)encodingName
                               default:(NSStringEncoding)defaultEncoding {

    NSString *code = [encodingName uppercaseString];
    NSSet *codes;

    if ([code isEqualToString:@"UTF-8"])
        return NSUTF8StringEncoding;

    if ([code isEqualToString:@"WINDOWS-1251"])
        return NSWindowsCP1251StringEncoding;

    if ([code isEqualToString:@"WINDOWS-1252"])
        return NSWindowsCP1252StringEncoding;

    if ([code isEqualToString:@"WINDOWS-1253"])
        return NSWindowsCP1253StringEncoding;

    if ([code isEqualToString:@"WINDOWS-1254"])
        return NSWindowsCP1254StringEncoding;

    if ([code isEqualToString:@"WINDOWS-1250"])
        return NSWindowsCP1250StringEncoding;

    codes = [NSSet setWithObjects:@"CP819", @"ISO-8859-1", @"CSISOLATIN1",
                                  @"IBM819", @"ISO-IR-100", @"ISO_8859-1",
                                  @"L1", @"LATIN1", nil];
    if ([codes containsObject:code])
        return NSISOLatin1StringEncoding;

    codes = [NSSet setWithObjects:@"ISO-8859-2", @"CSISOLATIN2", @"ISO-IR-101",
                                  @"ISO_8859-2", @"L2", @"LATIN2", nil];
    if ([codes containsObject:code])
        return NSISOLatin2StringEncoding;

    codes = [NSSet setWithObjects:@"CSEUCPKDFMTJAPANESE", @"EUC-JP", nil];
    if ([codes containsObject:code])
        return NSJapaneseEUCStringEncoding;

    codes = [NSSet setWithObjects:@"CSISO2022JP", @"ISO-2022-JP", nil];
    if ([codes containsObject:code])
        return NSISO2022JPStringEncoding;

    codes = [NSSet setWithObjects:@"CSSHIFTJIS", @"EUC-JP", @"MS_KANJI",
                                  @"SHIFT_JIS", nil];
    if ([codes containsObject:code])
        return NSShiftJISStringEncoding;

    codes = [NSSet setWithObjects:@"MAC", @"MACINTOSH", @"CSMACINTOSH", nil];
    if ([codes containsObject:code])
        return NSMacOSRomanStringEncoding;

    if ([code isEqualToString:@"UTF-16LE"])
        return NSUTF16LittleEndianStringEncoding;

    if ([code isEqualToString:@"UTF-32LE"])
        return NSUTF32LittleEndianStringEncoding;

    if ([code isEqualToString:@"UTF-32BE"])
        return NSUTF32BigEndianStringEncoding;

    codes = [NSSet
        setWithObjects:@"ISO-10646-UCS-2", @"CSUNICODE", @"UTF-16BE", nil];
    if ([codes containsObject:code])
        return NSUTF16BigEndianStringEncoding;

    codes =
        [NSSet setWithObjects:@"ASCII", @"US-ASCII", @"ANSI_X3.4-1986",
                              @"CP367", @"CSASCII", @"IBM367", @"ISO-IR-6",
                              @"ISO646-US", @"ISO_646.IRV:1991", @"US", nil];
    if ([codes containsObject:code])
        return NSASCIIStringEncoding;

    return defaultEncoding;
}

//////////////////////////////////////////////////////////////
#pragma mark - C# and other sugar
//////////////////////////////////////////////////////////////
+ (BOOL)isNullOrEmpty:(NSString *)str {
    return (!str || str.length == 0);
}

//////////////////////////////////////////////////////////////
+ (BOOL)isNullOrWhiteSpace:(NSString *)str {
    return (!str ||
            [[str stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]] length] == 0);
}

//////////////////////////////////////////////////////////////
+ (NSString *)stringByTrim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//////////////////////////////////////////////////////////////
+ (NSString *)hexStringFromData:(NSData *)data {

    NSUInteger i, len;
    Byte *buf, *bytes;

    len = data.length;
    bytes = (Byte *)data.bytes;
    buf = malloc(len * 2);

    for (i = 0; i < len; i++) {
        buf[i * 2] = itoh((bytes[i] >> 4) & 0xF);
        buf[i * 2 + 1] = itoh(bytes[i] & 0xF);
    }

    return [[NSString alloc] initWithBytesNoCopy:buf
                                          length:len * 2
                                        encoding:NSASCIIStringEncoding
                                    freeWhenDone:YES];
}

//////////////////////////////////////////////////////////////
- (NSString *)replace:(NSString *)from to:(NSString *)to {
    return [self stringByReplacingOccurrencesOfString:from withString:to];
}

//////////////////////////////////////////////////////////////
/// return index of string into receiver, or -1 if not found
- (NSInteger)indexOf:(NSString *)string fromIndex:(NSUInteger)index {
    NSRange range =
        [self rangeOfString:string
                    options:NSLiteralSearch
                      range:NSMakeRange(index, self.length - index)];

    if (range.location == NSNotFound)
        return -1;
    return range.location;
}
- (NSInteger)indexOf:(NSString *)string {
    return [self indexOf:string fromIndex:0];
}

- (NSArray *)splitByArray:(NSArray *)strings
                    count:(NSUInteger)count
                omitEmpty:(BOOL)omitEmpty {
    // Simple (Slow) method
    if (count == 0)
        return @[];
    if (!--count || !strings.count)
        return @[ [self copy] ];

    UniChar *selfChars;
    BOOL selfCharsCopied = NO;
    CFIndex selfLength = CFStringGetLength((__bridge CFStringRef)self);

    NSRange *inputRanges = nil;

    CFIndex rangesCount = [self rangesForSplitByArray:strings
                                                  any:NO
                                                 from:0
                                            selfChars:&selfChars
                                    selfCharsNeedFree:&selfCharsCopied
                                               ranges:&inputRanges];

    // Get output array ////////////////////////////
    //////////////////////////////////////////
    CFIndex start = 0;
    CFIndex length;

    NSMutableArray *separatedStrings = [NSMutableArray array];
    NSUInteger counter = 0;
    NSRange aRange;
    for (CFIndex indexA = 0; indexA < rangesCount && counter < count;
         indexA++) {

        aRange = inputRanges[indexA];
        if (aRange.location >= start && aRange.length > 0) {

            length = aRange.location - start;
            if (!omitEmpty || length) {

                [separatedStrings
                    addObject:[NSString stringWithCharacters:(selfChars + start)
                                                      length:length]];
                counter++;
            }
            start = aRange.location + aRange.length;
        }
    }

    length = selfLength - start;
    if (!omitEmpty || length)
        [separatedStrings
            addObject:[NSString stringWithCharacters:(selfChars + start)
                                              length:length]];

    // free memory
    if (selfCharsCopied)
        free(selfChars);

    free(inputRanges);

    return separatedStrings;
}

- (BOOL)contains:(NSString *)str {
    //    return [self contains:str caseSensitive:YES];
    return [self uniContains:str];
}

- (BOOL)contains:(NSString *)str caseSensitive:(BOOL)sensitive {
    if (!str) {

        [[NSException argumentException:@"str"] raise];
    }
    if (sensitive)
        return ([self rangeOfString:str]).location != NSNotFound;

    return ([self rangeOfString:str options:NSCaseInsensitiveSearch])
               .location != NSNotFound;
}

- (BOOL)containsAny:(NSArray *)strings {
    // Simple (Slow) method

    NSRange range = [self rangeOfAny:strings];

    return (range.location != NSNotFound);
}

- (BOOL)asciiContains:(NSString *)string ignoreCase:(BOOL)ignoreCase {

    // Fast special method

    if (!string)
        return NO;


    CFIndex length = CFStringGetLength((__bridge CFStringRef)string);

    BOOL charsNeedFree = NO;
    char *chars = (char *)CFStringGetCStringPtr((__bridge CFStringRef)string,
                                                kCFStringEncodingASCII);
    if (chars == NULL) {

        chars = malloc((length + 1) * sizeof(char));
        if (chars == NULL) {

            @throw [NSException mallocException:@"chars"];
        }

        if (!CFStringGetCString((__bridge CFStringRef)string, chars,
                                (length + 1), kCFStringEncodingASCII)) {

            free(chars);
            return NO;
        }

        charsNeedFree = YES;
    }

    BOOL foundFor = asciiContains(self, chars, length, ignoreCase);
    
    if (charsNeedFree) {
        free(chars);
    }

    return foundFor;
}

- (NSArray *)asciiSplitByDelimiter:(char)delimiter escapeCharacter:(char)escapeCharacter{
    
    if ([NSString isNullOrEmpty:self]) {
        return @[];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    
    // Prepare pointers or buffers
    CFIndex selfLength = CFStringGetLength((__bridge CFStringRef)self);
    
    BOOL selfCharsNeedFree = NO;
    char *selfChars = (char *)CFStringGetCStringPtr((__bridge CFStringRef)self,
                                                    kCFStringEncodingASCII);
    if (selfChars == NULL) {
        
        selfChars = malloc((selfLength + 1) * sizeof(char));
        if (selfChars == NULL)
            @throw [NSException mallocException:@"selfChars"];
        
        if (!CFStringGetCString((__bridge CFStringRef)self, selfChars,
                                (selfLength + 1), kCFStringEncodingASCII)) {
            
            free(selfChars);
            return nil;
        }
        
        selfCharsNeedFree = YES;
    }
    
    char *buffer = malloc((selfLength + 1) * sizeof(char));
    NSString *out;
    
    int j = 0;
    for (int i = 0; i < selfLength; i++) {
        
        if (selfChars[i] == delimiter){
            
            if (i == 0){
                // Ignore
            }
            else if (selfChars[i - 1] == escapeCharacter){
                buffer[j-1] = selfChars[i];
            }
            else{
                if (j > 0){
                    
                    out = [[NSString alloc] initWithBytes:buffer length:j encoding:NSASCIIStringEncoding];
                    [list addObject:out];
                    j = 0;
                }
            }
        }
        else
        {
            buffer[j++] = selfChars[i];
        }
    }
    
    if (j > 0){
        out = [[NSString alloc] initWithBytes:buffer length:j encoding:NSASCIIStringEncoding];
        [list addObject:out];
    }
    
    // free memory
    free(buffer);
    
    if (selfCharsNeedFree) {
        free(selfChars);
    }
    
    return list;
}

- (NSRange)rangeOfAny:(NSArray *)strings {

    return [self rangeOfAny:strings from:0];
}

- (NSRange)rangeOfAny:(NSArray *)strings from:(NSUInteger)startIndex {

    NSRange range = NSMakeRange(NSNotFound, 0);

    // Simple (Slow) method
    if (!strings.count)
        return range;

    UniChar *selfChars;
    BOOL selfCharsCopied = NO;

    NSRange *inputRanges = nil;

    CFIndex rangesCount = [self rangesForSplitByArray:strings
                                                  any:YES
                                                 from:startIndex
                                            selfChars:&selfChars
                                    selfCharsNeedFree:&selfCharsCopied
                                               ranges:&inputRanges];

    if (rangesCount && rangesCount != NSNotFound)
        for (CFIndex i = 0; i < rangesCount; i++) {
            if (inputRanges[i].length > 0) {
                range = inputRanges[i];
                break;
            }
        }

    // free memory
    if (selfCharsCopied)
        free(selfChars);
    free(inputRanges);

    return range;
}

// TODO[Performance]: Check if it is being used in runtime
- (NSArray *)substringsBetween:(NSString *)start
                           and:(NSString *)end
                    ignoreCase:(BOOL)ignoreCase {

    NSStringCompareOptions options = NSLiteralSearch;
    NSMutableArray *result = [NSMutableArray array];

    if (ignoreCase)
        options |= NSCaseInsensitiveSearch;

    NSRange endRange;
    NSRange range = [self rangeOfString:start
                                options:options
                                  range:NSMakeRange(0, self.length)];
    NSUInteger index;
    while (range.location != NSNotFound) {

        index = range.location + range.length;
        endRange = [self rangeOfString:end
                               options:options
                                 range:NSMakeRange(index, self.length - index)];
        if (endRange.location == NSNotFound)
            return result;

        [result
            addObject:[self substringWithRange:NSMakeRange(index,
                                                           endRange.location -
                                                               index)]];
        index = endRange.location + endRange.length;
        range = [self rangeOfString:start
                            options:options
                              range:NSMakeRange(index, self.length - index)];
    }
    return result;
}

- (NSArray *)substringsBetween:(NSString *)start and:(NSString *)end {

    return [self substringsBetween:start and:end ignoreCase:NO];
}

- (NSString *)md5Digest {

    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);

    return [NSString
        stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5],
            result[6], result[7], result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (NSString *)sha256Digest {
    
    const char *cstr = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString
            stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5],
            result[6], result[7], result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19], result[20], result[21],
            result[22], result[23], result[24], result[25], result[26], result[27],
            result[28], result[29], result[30], result[31]];
}

- (NSUInteger )countOccurencesOfString:(NSString *)str {
    
    NSUInteger count = 0;
    NSUInteger length = [self length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [self rangeOfString: str options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    
    return count;
}

+ (NSString *)repeat:(NSString *)string separator:(NSString *)separator repeat:(NSInteger)repeat {
    
    NSMutableString* result = [NSMutableString new];
    
    for(int i = 0; i < repeat; ++i) {
        
        if(i != 0) [result appendString:separator];
        
        [result appendString:string];
    }
    
    return result.copy;
}

@end

@implementation NSString (Utils_Private)

- (CFIndex)rangesForSplitByArray:(NSArray *)strings
                             any:(BOOL)anyString
                            from:(CFIndex)startIndex
                       selfChars:(unichar **)selfChars
               selfCharsNeedFree:(BOOL *)charsNeedFree
                          ranges:(NSRange **)ranges {
    // Simple (Slow) method

    *ranges = nil;
    if (!strings.count)
        return 0;

    // Prepare pointers or buffers
    //    UniChar *selfChars;
    *charsNeedFree = NO;
    CFIndex selfLength = CFStringGetLength((__bridge CFStringRef)self);

    *selfChars =
        (UniChar *)CFStringGetCharactersPtr((__bridge CFStringRef)self);
    if (*selfChars == NULL) {
        *selfChars = malloc(selfLength * sizeof(UniChar));
        if (*selfChars == nil)
            @throw [NSException mallocException:@"selfChars"];

        CFStringGetCharacters((__bridge CFStringRef)self,
                              CFRangeMake(0, selfLength), *selfChars);
        *charsNeedFree = YES;
    }

    UniChar **inputCharsArray = malloc((strings.count) * sizeof(UniChar *));
    if (inputCharsArray == nil)
        @throw [NSException mallocException:@"inputCharsArray"];

    BOOL *inputCharsCopiedArray = malloc((strings.count) * sizeof(BOOL));
    if (inputCharsCopiedArray == nil)
        @throw [NSException mallocException:@"inputCharsCopiedArray"];

    CFIndex *inputCharsLengthArray = malloc((strings.count) * sizeof(CFIndex));
    if (inputCharsLengthArray == nil)
        @throw [NSException mallocException:@"inputCharsLengthArray"];

    CFIndex *inputCharsIndexArray = calloc((strings.count), sizeof(CFIndex));
    if (inputCharsIndexArray == nil)
        @throw [NSException mallocException:@"inputCharsIndexArray"];

    CFIndex *inputCharsAIndexArray = calloc((strings.count), sizeof(CFIndex));
    if (inputCharsAIndexArray == nil)
        @throw [NSException mallocException:@"inputCharsAIndexArray"];
    
    CFIndex *inputCharsRangePosArray =
        malloc((strings.count) * sizeof(CFIndex));
    if (inputCharsRangePosArray == nil)
        @throw [NSException mallocException:@"inputCharsIndexArray"];

    NSUInteger inputCharsArraySize = 0;

    @try {
        UniChar *inputChars;
        CFIndex length;
        for (NSString *item in strings) {
            if (item.length == 0)
                continue;

            inputCharsLengthArray[inputCharsArraySize] = length =
                CFStringGetLength((__bridge CFStringRef)item);
            inputChars =
                (UniChar *)CFStringGetCharactersPtr((__bridge CFStringRef)item);
            if (inputChars == NULL) {

                inputChars = malloc(length * sizeof(UniChar));
                if (inputChars == nil)
                    @throw [NSException mallocException:@"inputChars"];

                CFStringGetCharacters((__bridge CFStringRef)item,
                                      CFRangeMake(0, length), inputChars);

                inputCharsCopiedArray[inputCharsArraySize] = YES;
            } else
                inputCharsCopiedArray[inputCharsArraySize] = NO;

            inputCharsArray[inputCharsArraySize] = inputChars;

            inputCharsArraySize++;
        }
    }
    @catch (NSException *exception) {
        @throw [NSException argumentException:@"strings"];
    }

    // Check for return
    if (inputCharsArraySize == 0)
        return 0;

    // Get Ranges ////////////////////////////
    //////////////////////////////////////////
    NSRange *inputRanges = malloc(RANGE_REALLOC_SIZE * sizeof(NSRange));
    if (inputRanges == NULL)
        @throw [NSException mallocException:@"inputRanges"];

    BOOL foundFor = !anyString;

    CFIndex rangesSize = RANGE_REALLOC_SIZE;
    CFIndex rangesCount = 0;

    for (CFIndex indexA = startIndex; indexA < selfLength; indexA++) {

        for (CFIndex indexB = 0; indexB < inputCharsArraySize; indexB++) {

            // Prevent comparison of the symbols if indexA was shifted back.
            if (indexA < inputCharsAIndexArray[indexB]) {
                continue;
            }

            // Main comparison
            if ((*selfChars)[indexA] ==
                inputCharsArray[indexB][inputCharsIndexArray[indexB]]) {

                // Equel
                if (inputCharsIndexArray[indexB] == 0) {
                    // begin way
                    inputRanges[rangesCount] = NSMakeRange(indexA, 0);
                    inputCharsRangePosArray[indexB] = rangesCount;

                    rangesCount++;
                    if (rangesCount == rangesSize) {

                        // realloc memory
                        rangesSize += RANGE_REALLOC_SIZE;
                        inputRanges =
                            reallocf(inputRanges, rangesSize * sizeof(NSRange));
                        if (inputRanges == nil)
                            @throw [NSException
                                mallocException:@"inputRanges realloc"];
                    }
                }

                if (++(inputCharsIndexArray[indexB]) ==
                    inputCharsLengthArray[indexB]) {

                    // we found end way
                    inputRanges[inputCharsRangePosArray[indexB]].length =
                        inputCharsLengthArray[indexB];
                    inputCharsIndexArray[indexB] = 0;

                    if (anyString) {

                        foundFor = YES;
                        // break from loops
                        indexA = selfLength;
                        break;
                    }
                }
            } else {

                // Fail
                indexA -= inputCharsIndexArray[indexB];
                inputCharsIndexArray[indexB] = 0;
            }
            // Holding indexA locally.
            inputCharsAIndexArray[indexB] = indexA + 1;
        }
    }

    // free memory
    for (CFIndex indexB = 0; indexB < inputCharsArraySize; indexB++)
        if (inputCharsCopiedArray[indexB])
            free(inputCharsArray[indexB]);

    free(inputCharsArray);
    free(inputCharsCopiedArray);
    free(inputCharsLengthArray);
    free(inputCharsIndexArray);
    free(inputCharsAIndexArray);
    free(inputCharsRangePosArray);

    // return
    if (foundFor) {

        *ranges = inputRanges;
        return rangesCount;
    }

    free(inputRanges);
    return NSNotFound;
}

- (BOOL)uniContains:(NSString *)string {

    // Simple (Slow) method

    if (!string)
        return NO;

    // Prepare pointers or buffers
    CFIndex selfLength = CFStringGetLength((__bridge CFStringRef)self);
    BOOL selfCharsNeedFree = NO;

    UniChar *selfChars =
        (UniChar *)CFStringGetCharactersPtr((__bridge CFStringRef)self);
    if (selfChars == NULL) {
        selfChars = malloc(selfLength * sizeof(UniChar));
        if (selfChars == NULL)
            @throw [NSException mallocException:@"selfChars"];

        CFStringGetCharacters((__bridge CFStringRef)self,
                              CFRangeMake(0, selfLength), selfChars);
        selfCharsNeedFree = YES;
    }

    CFIndex length = CFStringGetLength((__bridge CFStringRef)string);
    BOOL charsNeedFree = NO;

    UniChar *chars =
        (UniChar *)CFStringGetCharactersPtr((__bridge CFStringRef)string);
    if (chars == NULL) {
        chars = malloc(length * sizeof(UniChar));
        if (chars == NULL)
            @throw [NSException mallocException:@"chars"];

        CFStringGetCharacters((__bridge CFStringRef)string,
                              CFRangeMake(0, length), chars);
        charsNeedFree = YES;
    }

    BOOL foundFor = NO;

    for (CFIndex indexA = 0, indexB = 0; indexA < selfLength; indexA++) {

        if (selfChars[indexA] == chars[indexB]) {

            // increment B counter
            if (++indexB == length) {
                // found
                foundFor = YES;
                break;
            }
        } else{
            
            indexA -= indexB;
            // reset B counter
            indexB = 0;
        }
    }

    if (charsNeedFree)
        free(chars);

    if (selfCharsNeedFree)
        free(selfChars);

    return foundFor;
}

- (NSMutableAttributedString *)attributedStringFromHtml {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithData:data
                                                                 options:options
                                                      documentAttributes:nil error:&error];
    
    return string;
}

@end

#pragma mark - Private Fuctions

 BOOL asciiContains(NSString *self, char *chars, CFIndex length, BOOL ignoreCase) {
    
    // Fast special method
    
    if (!chars)
        return NO;
    
    // Prepare pointers or buffers
    CFIndex selfLength = CFStringGetLength((__bridge CFStringRef)self);
    
    BOOL selfCharsNeedFree = NO;
    char *selfChars = (char *)CFStringGetCStringPtr((__bridge CFStringRef)self,
                                                    kCFStringEncodingASCII);
    if (selfChars == NULL) {
        
        selfChars = malloc((selfLength + 1) * sizeof(char));
        if (selfChars == NULL)
            @throw [NSException mallocException:@"selfChars"];
        
        if (!CFStringGetCString((__bridge CFStringRef)self, selfChars,
                                (selfLength + 1), kCFStringEncodingASCII)) {
            
            free(selfChars);
            return NO;
        }
        
        selfCharsNeedFree = YES;
    }
    
    char _selfChar = 0, _char = 0;
    BOOL foundFor = NO;
    
    for (CFIndex indexA = 0, indexB = 0; indexA < selfLength; indexA++) {
        
        _selfChar = selfChars[indexA];
        if (ignoreCase && _selfChar >= 0x41 && _selfChar <= 0x5A)
            _selfChar += 0x20;
        
        _char = chars[indexB];
        if (ignoreCase && _char >= 0x41 && _char <= 0x5A)
            _char += 0x20;
        
        if (_selfChar == _char) {
            
            // increment B counter
            if (++indexB == length) {
                // found
                foundFor = YES;
                break;
            }
        } else{
            
            indexA -= indexB;
            // reset B counter
            indexB = 0;
        }
    }
    
    if (selfCharsNeedFree) {
        free(selfChars);
    }
    
    return foundFor;
}

NSString* ACLocalizedString(NSString* key, NSString* comment) {
    
    NSString* localizedString = NSLocalizedString(key, nil);
    
    if (![[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"en"] && [localizedString isEqualToString:key]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        localizedString = [languageBundle localizedStringForKey:key value:@"" table:nil];
    }
    return localizedString;
}
