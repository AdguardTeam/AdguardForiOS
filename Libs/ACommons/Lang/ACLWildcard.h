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


@interface ACLWildcard : NSRegularExpression

/////////////////////////////////////////////////////////////////////
#pragma mark -  Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)initWithWildcard:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError *__autoreleasing *)error;

/// Main Create Method (constructor)
+ (ACLWildcard *)wildcard:(NSString *)pattern options:(NSRegularExpressionOptions)options;

/// Converts a wildcard to a regex.
/// pattern - The wildcard pattern to convert.
/// A regex equivalent of the given wildcard.
+ (NSString *)regexFromWildcard:(NSString *)pattern;

/// Create Method without options (constructor)
+ (ACLWildcard *)wildcard:(NSString *)pattern;

/////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and query methods
/////////////////////////////////////////////////////////////////////

/// Longest string inside wildcard that does not contain * and ? symbols.
@property (nonatomic) NSString *shortcut;
/// Wildcard pattern
@property (nonatomic, readonly) NSString *patternString;

/// Returns "true" if input text is matching wildcard.
/// This method first checking shortcut -- if shortcut exists in input string -- than it checks regexp.
- (BOOL)matchWildcard:(NSString *)input;

@end
