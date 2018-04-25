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
#import "ACLLogger.h"
#import "NSString+Utils.h"
#import "NSException+Utils.h"
#import "ACLWildcard.h"

#define MASK_ANY_SYMBOLS        @"*"
#define MASK_ANY_SYMBOL         @"?"

@interface ACLWildcard()

/// Extracts longest string that does not contain * or ? symbols.
- (NSString *)extractShortcut:(NSString *)fromPattern;

@end

@implementation ACLWildcard

/////////////////////////////////////////////////////////////////////
#pragma mark -  Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)initWithWildcard:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError *__autoreleasing *)error
{
    self = [super initWithPattern:[ACLWildcard regexFromWildcard:pattern] options:options error:error];
    if (self) {

        _patternString = pattern;
        _shortcut = [self extractShortcut:pattern];
    }
    return self;
}

/// Main Create Method (constructor)
+ (ACLWildcard *)wildcard:(NSString *)pattern options:(NSRegularExpressionOptions)options
{
    NSError *err;
    ACLWildcard *wildcard = [[ACLWildcard alloc] initWithWildcard:pattern options:options error:&err];
    
    if  (err){
        
        DDLogWarn(@"Can't create regex for: %@", pattern);
        DDLogWarn(@"Regex creation error: %@", [err localizedDescription]);
        return nil;
    }
    
    return wildcard;
}

/// Create Method without options (constructor)
+ (ACLWildcard *)wildcard:(NSString *)pattern
{
    return [ACLWildcard wildcard:pattern options:0];
}
/////////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and query methods
/////////////////////////////////////////////////////////////////////////

/// Converts a wildcard to a regex.
/// pattern - The wildcard pattern to convert.
/// A regex equivalent of the given wildcard.
+ (NSString *)regexFromWildcard:(NSString *)pattern
{
    return [NSString stringWithFormat:@"^%@$", [[[ACLWildcard escapedPatternForString:pattern] replace:@"\\*" to:@".*"] replace:@"\\?" to:@"."]];
}

/// Returns "true" if input text is matching wildcard.
/// This method first checking shortcut -- if shortcut exists in input string -- than it checks regexp.
- (BOOL)matchWildcard:(NSString *)input
{
    if ([NSString isNullOrEmpty:input])
        return NO;

    if (![NSString isNullOrEmpty:_shortcut] && ![input contains:_shortcut])
        return NO;
    
    
    NSRange result = [self rangeOfFirstMatchInString:input options:0 range:NSMakeRange(0, input.length)];
    return result.location != NSNotFound;
    
}


- (NSString *)stringValue
{
    return [[self class] description];
}

////////////////////////////////////////////////////////////////////////////
#pragma mark -  Private methods
////////////////////////////////////////////////////////////////////////////

/// Extracts longest string that does not contain * or ? symbols.
- (NSString *)extractShortcut:(NSString *)fromPattern
{
    NSString *longest = @"";
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%@%@", MASK_ANY_SYMBOLS, MASK_ANY_SYMBOL]];
    NSArray *parts = [fromPattern componentsSeparatedByCharactersInSet:cSet];
    
    for (NSString *part in parts)
        if (part.length > longest.length)
        {
            longest = part;
        }
    
    return longest;
}

@end
