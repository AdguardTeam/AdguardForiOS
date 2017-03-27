/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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

#import "AERDomainFilterRule.h"
#import "ACommons/ACLang.h"

@implementation AERDomainFilterRule

/////////////////////////////////////////////////////////////////////
#pragma mark -  Constructor (parsing rule text)
/////////////////////////////////////////////////////////////////////

+ (void)initialize {

    if (self == [AERDomainFilterRule class]) {

    }
}

/// Init (parsing rule text)
- (id)initWithRule:(NSString *)rule {
    
    @autoreleasepool {
        
        if ([self isValidRuleText:rule] == NO) {
            DDLogWarn(@"Error creating invalid rule: %@", rule);
            return nil;
        }
        
        self = [super init];
        if (self) {
            
            _incorrectRule = _isWhiteListRule = NO;
            
            if ([rule hasPrefix:MASK_WHITE_LIST]) {
                rule = [rule substringFromIndex:MASK_WHITE_LIST.length];
                _isWhiteListRule = YES;
            }
            
            NSString *ruleText;
            NSString *options;
            if ([self findOptions:rule urlText:&ruleText options:&options]){
                
                if (![self loadOptions:options]) {
                    DDLogError(@"(AFRUrlFilterRule) Can't parse options for rule: \"%@\"", rule);
                    return nil;
                }
                
                rule = ruleText;
            }
            
            // More about regex rules http://jira.performix.ru/browse/AG-6604
            BOOL isRegexRule = [rule hasPrefix:MASK_REGEX_RULE] && [rule hasSuffix:MASK_REGEX_RULE];
            NSString *regex;
            
            if (isRegexRule) {
                
                NSUInteger length = [MASK_REGEX_RULE length];
                regex = [rule substringWithRange:NSMakeRange(length, rule.length - (length * 2))];
                
                _urlRegexp = [self regexpFromString:regex case:NO];
                if (!_urlRegexp) {
                    
                    DDLogWarn(@"Incorrect rule: %@", rule);
                    return nil;
                }
                
            }
            else {
                // punycoding here
                rule = [self asciiDomainRule:rule];
                
                // Searching for shortcut
                [self findShortcut:rule];
                
                // Replacing regex special symbols
                regex = [self createRegexFromRule:rule];
            }
            
            if ([regex isEqualToString:AFRU_REGEXP_ANY_SYMBOL]) {
                // Rule matches everything and does not have any domain restriction
                DDLogWarn(@"Too wide basic rule: %@", rule);
                return nil;
            }
            
            _urlRegexpText = regex;
        }
    }
    return self;

}

+ (AERDomainFilterRule *)rule:(NSString *)ruleText{
    AERDomainFilterRule *rule = [[AERDomainFilterRule alloc] initWithRule:ruleText];

    return rule;

}

/////////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and query methods
/////////////////////////////////////////////////////////////////////////


- (BOOL)filteredForURL:(NSString *)requestUrl {

    if (_incorrectRule) {
        return NO;
    }
    
    return [self matchesRegexp:requestUrl];
}

/////////////////////////////////////////////////////////////////////
#pragma mark -  Private methods
/////////////////////////////////////////////////////////////////////


- (BOOL)isValidRuleText:(NSString *)ruleText {
    
    if ([NSString isNullOrEmpty:ruleText]
        || [[NSString stringByTrim:ruleText] hasPrefix:COMMENT]
        || [ruleText contains:MASK_OBSOLETE_SCRIPT_INJECTION]) {
        
        return NO;
    }

    if ([ruleText hasPrefix:MASK_WHITE_LIST]) {
        return YES;
    }
    
    if ([ruleText contains:MASK_CONTENT_RULE]
        || [ruleText contains:MASK_CONTENT_EXCEPTION_RULE]
        || [ruleText contains:MASK_CSS_INJECT_RULE]
        || [ruleText contains:MASK_CSS_INJECT_EXCEPTION_RULE]
        || [ruleText contains:MASK_SCRIPT_RULE]
        || [ruleText contains:MASK_SCRIPT_EXCEPTION_RULE]
        || [ruleText contains:MASK_CSS_RULE]
        || [ruleText contains:MASK_CSS_EXCEPTION_RULE]) {
        return NO;
    }
    
    return YES;
}

/// Searches for the shortcut of this url mask.
/// Shortcut is the longest part of the mask without special characters:
/// *,^,|.
/// If not found anything with the length
/// greater or equal to AFRU_SHORTCUT_LENGTH characters - shortcut is not used.
- (void)findShortcut:(NSString *)urlmask {
    NSString *longest; // = @"";
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%@%@%@", AFRU_MASK_PIPE, AFRU_MASK_ANY_SYMBOL, AFRU_MASK_SEPARATOR]];
    NSArray *parts = [urlmask componentsSeparatedByCharactersInSet:cSet];

    for (NSString *part in parts)
        if (part.length > longest.length) {
            longest = part;
        }

    if ([NSString isNullOrEmpty:longest])
        return;

    _shortcut = [longest lowercaseString];
}

/**
 Helper method that looks for an "options" string in the rule text.
 This method takes into account that delimiter symbod ($) may be escaped with a backslash.
 
 @param ruleText        Rule text
 @param urlText         Contains first part of the rule (before options modifier)
 
 @return    YES if options found.
 */
- (BOOL)findOptions:(NSString *)ruleText urlText:(NSString **)urlText options:(NSString **)options{
    
    *urlText = ruleText;
    *options = nil;
    BOOL found = NO;
    BOOL foundEscaped = NO;
    
    // Prepare pointers or buffers
    CFIndex length = CFStringGetLength((__bridge CFStringRef)ruleText);
    
    BOOL charsNeedFree = NO;
    char *chars = (char *)CFStringGetCStringPtr((__bridge CFStringRef)ruleText,
                                                    kCFStringEncodingASCII);
    if (chars == NULL) {
        
        chars = malloc((length + 1) * sizeof(char));
        if (chars == NULL)
            @throw [NSException mallocException:@"chars"];
        
        if (!CFStringGetCString((__bridge CFStringRef)ruleText, chars,
                                (length + 1), kCFStringEncodingASCII)) {
            
            free(chars);
            return [self uniFindOptions:ruleText urlText:urlText options:options];
        }
        
        charsNeedFree = YES;
    }
    
    // Start looking from the prev to last symbol
    // If dollar sign is the last symbol - we simply ignore it.
    for (CFIndex i = (length - 2); i >= 0; i--)
    {
        if (chars[i] == AFRU_OPTIONS_MARKER_SYM){
            if (i > 0 && chars[i - 1] == AFRU_OPTIONS_ESCAPE_SYM){
                foundEscaped = YES;
            }
            else{
                *urlText = [ruleText substringToIndex:i];
                *options = [ruleText substringFromIndex:(i + 1)];
                // Find and replace escaped options delimiter
                
                if (foundEscaped){
                    
                    *options = [*options stringByReplacingOccurrencesOfString:AFRU_OPTIONS_ESCAPE AFRU_OPTIONS_DELIMITER withString:AFRU_OPTIONS_DELIMITER];
                }
                
                found = YES;
                break;
            }
        }
    }
    
    if (charsNeedFree) {
        free(chars);
    }
    
    return found;
}

/// Unicode workaround
- (BOOL)uniFindOptions:(NSString *)ruleText urlText:(NSString **)urlText options:(NSString **)options{
    
    *urlText = ruleText;
    *options = nil;
    BOOL foundEscape = NO;
    
    NSRange range = [ruleText rangeOfString:AFRU_OPTIONS_DELIMITER options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return NO;
    }
    
    NSString *str = [ruleText copy];
    str = [str substringToIndex:range.location];
    
    while ([str hasSuffix:AFRU_OPTIONS_ESCAPE]) {
        
        foundEscape = YES;
        range = [str rangeOfString:AFRU_OPTIONS_DELIMITER options:NSBackwardsSearch];
        if (range.location == NSNotFound) {
            return NO;
        }
        
        str = [str substringToIndex:range.location];

    }
    
    *urlText = str;
    str = [ruleText substringFromIndex:(str.length + 1)];
    if (foundEscape) {
        *options = [str  stringByReplacingOccurrencesOfString:AFRU_OPTIONS_ESCAPE AFRU_OPTIONS_DELIMITER withString:AFRU_OPTIONS_DELIMITER];
    }
    else{
        *options = str;
    }
    
    return YES;
}

/// Loads filter rule options
- (BOOL)loadOptions:(NSString *)options {
  
    // At this moment no options
    return YES;
}

/// Checks if request url matches regexp
- (BOOL)matchesRegexp:(NSString *)requestUrl {
    NSRegularExpression *regex = self.urlRegexp;
    if (!regex) {

        @synchronized(self) {
            regex = self.urlRegexp;
            if (!regex) {
                regex =
                [self regexpFromString:self.urlRegexpText case:NO];
                if (!regex) {
                    
                    DDLogWarn(@"Incorrect rule with regexp: %@", self.urlRegexpText);
                    return NO;
                }
                
                _urlRegexp = regex;
            }
        }
    }

    NSRange result = [regex rangeOfFirstMatchInString:requestUrl options:0 range:NSMakeRange(0, requestUrl.length)];

    return result.location != NSNotFound;
}

/// Creates regexp from rule text
- (NSString *)createRegexFromRule:(NSString *)ruleText {
    
    if ([NSString isNullOrEmpty:ruleText] || [AFRU_MASK_ANY_SYMBOL isEqualToString:ruleText]) {
        return AFRU_REGEXP_ANY_SYMBOL;
    }

    // Replacing regex special symbols
    NSString *regex = [[[[[[[[[[[[[ruleText replace:@"\\" to:@"\\\\"]
            replace:@"?" to:@"\\?"]
            replace:@"." to:@"\\."]
            replace:@"+" to:@"\\+"]
            replace:@"[" to:@"\\["]
            replace:@"]" to:@"\\]"]
            replace:@"$" to:@"\\$"]
            replace:@"{" to:@"\\{"]
            replace:@"}" to:@"\\}"]
            replace:@" " to:@"\\ "]
            replace:@"#" to:@"\\#"]
            replace:@"(" to:@"\\("]
            replace:@")" to:@"\\)"];

    NSInteger bodyLength = regex.length - [AFRU_MASK_START_URL length] - 1;
    if (bodyLength > 0) {

        regex = [regex stringByReplacingOccurrencesOfString:@"|" withString:@"\\|" options:NSLiteralSearch range:NSMakeRange(AFRU_MASK_START_URL.length, bodyLength)];
    }

    // Replacing special url masks
    regex = [regex replace:AFRU_MASK_ANY_SYMBOL to:AFRU_REGEXP_ANY_SYMBOL];
    regex = [regex replace:AFRU_MASK_SEPARATOR to:AFRU_REGEXP_SEPARATOR];
    if ([regex hasPrefix:AFRU_MASK_START_URL]) {

        regex = [AFRU_REGEXP_START_URL stringByAppendingString:
                [regex substringFromIndex:AFRU_MASK_START_URL.length]];
    }
    else if ([regex hasPrefix:AFRU_MASK_PIPE]) {

        regex = [AFRU_REGEXP_START_STRING stringByAppendingString:[regex substringFromIndex:AFRU_MASK_PIPE.length]];
    }
    if ([regex hasSuffix:AFRU_MASK_PIPE]) {

        regex = [[regex substringToIndex:(regex.length - AFRU_MASK_PIPE.length)] stringByAppendingString:AFRU_REGEXP_END_STRING];
    }

    return regex;
}

- (NSString *)asciiDomainRule:(NSString *)rule {

    NSArray *startWith = @[@"http://", @"https://", @"||"];
    NSArray *endWith = @[@"/", @"^"];


    NSRange range = [rule rangeOfAny:startWith];

    if (range.location == 0) {

        NSRange endHostRange = [rule rangeOfAny:endWith from:range.length];

        if (endHostRange.location != NSNotFound) {

            NSString *punyCode = [rule substringWithRange:NSMakeRange(range.length, (endHostRange.location - range.length))];
            
            if (punyCode.length) {
                punyCode = [punyCode IDNAEncodedString];
            }

            return [NSString stringWithFormat:@"%@%@%@"

                    , [rule substringToIndex:range.length]

                    , punyCode

                    , [rule substringFromIndex:endHostRange.location]

            ];
        }
    }

    return rule;
}

/// Create regexrp object
- (NSRegularExpression *)regexpFromString:(NSString *)regexpText case:(BOOL)caseSensitive {

    NSError *err = nil;
    NSRegularExpressionOptions regexOptions = NSRegularExpressionDotMatchesLineSeparators;
    if (!caseSensitive)
        regexOptions = regexOptions | NSRegularExpressionCaseInsensitive;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexpText options:regexOptions error:&err];
    if (err) {

        DDLogWarn(@"Can't create regex for: %@", regexpText);
        DDLogWarn(@"Regex creation error: %@", [err localizedDescription]);
        
        _incorrectRule = YES;
        
        return nil;
    }

    return regex;
}

@end
