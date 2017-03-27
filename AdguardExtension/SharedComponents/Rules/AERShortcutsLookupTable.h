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

#import <Foundation/Foundation.h>

@class AERDomainFilterRule;

@interface AERShortcutsLookupTable  : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark -  Init and Class methods
/////////////////////////////////////////////////////////////////////

-(id) init;

/// Main Create Method (constructor)
+ (AERShortcutsLookupTable *)table;

/// Creates an instance of the shortcuts lookup table
+ (AERShortcutsLookupTable *)tableForRules:(id<NSFastEnumeration>)rules;

/////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and public methods
/////////////////////////////////////////////////////////////////////

/// Adds rule to shortcuts lookup table
- (BOOL)addRule:(AERDomainFilterRule *)rule;

/// Removes rule from the shortcuts table
- (void)removeRule:(AERDomainFilterRule *)rule;

/// Clears shortcuts table
- (void)clearRules;

/**
 Look up domain filter rules using this table
 
 @param url Url to check (pass it in lower case)
 */
- (NSArray *)lookupRules:(NSString*)url;

/// String representation (like c# ToString)
- (NSString *)stringValue;

@end
