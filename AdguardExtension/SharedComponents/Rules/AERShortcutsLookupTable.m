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

#import "AERShortcutsLookupTable.h"
#import "AERDomainFilterRule.h"
#import "ACommons/ACLang.h"

#define HASH_TABLE_SIZE     100000
#define SHORTCUT_LENGTH             6

#define ANY_HTTP_URL        @"http:/"
#define ANY_HTTPS_URL       @"https:"


/////////////////////////////////////////////////////////////////////
#pragma mark -  Init and Class methods
/////////////////////////////////////////////////////////////////////

@interface AERShortcutsLookupTable () {
    
    NSMutableDictionary *_hashTable;
}

@end

@implementation AERShortcutsLookupTable

- (id)init {
    self = [super init]; // [super _init_];
    if (self) {
        
        _hashTable = [NSMutableDictionary dictionaryWithCapacity:HASH_TABLE_SIZE];
    }
    
    return self;
}

- (void)dealloc{
    
    [self clearRules];
}

/// Creates empty shortcuts lookup table
+ (AERShortcutsLookupTable *)table {
    
    AERShortcutsLookupTable *table = [[AERShortcutsLookupTable alloc] init];
    
    return table;
}

/// Creates an instance of the shortcuts lookup table
+ (AERShortcutsLookupTable *)tableForRules:(id <NSFastEnumeration>)rules {
    AERShortcutsLookupTable *table = [AERShortcutsLookupTable table];
    for (AERDomainFilterRule *rule in rules)
        [table addRule:rule];
    
    return table;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and public methods
/////////////////////////////////////////////////////////////////////////

/// Adds rule to shortcuts lookup table
- (BOOL)addRule:(AERDomainFilterRule *)rule {
    @autoreleasepool {
        NSString *shortcut = rule.shortcut;
        if (shortcut.length < SHORTCUT_LENGTH) {
            return NO;
        }
        
        shortcut = [rule.shortcut substringToIndex:SHORTCUT_LENGTH];
        
        if ([ANY_HTTP_URL isEqualToString:shortcut] || [ANY_HTTPS_URL isEqualToString:shortcut]) {
            // There's no need to keep rules matching any HTTP or HTTPS url here.
            return NO;
        }
        
        
        NSMutableArray *list = _hashTable[shortcut];
        if (!list) {
            list = [NSMutableArray array];
            _hashTable[shortcut] = list;
        }
        [list addObject:rule];
        
        return YES;
    }
}

/// Removes rule from the shortcuts table
- (void)removeRule:(AERDomainFilterRule *)rule {
    NSString *shortcut = rule.shortcut;
    if (shortcut.length >= SHORTCUT_LENGTH) {

        NSMutableArray *list = _hashTable[[shortcut substringToIndex:SHORTCUT_LENGTH]];
        [list removeObject:rule];
    }
}

/// Clears shortcuts table
- (void)clearRules {
    [_hashTable removeAllObjects];
}

- (NSArray *)lookupRules:(NSString *)url {
    if (!url) {
        return nil;
    }
    
    NSMutableArray *lookuped;

    NSInteger count = url.length - SHORTCUT_LENGTH;
    if (count < 0) {
        return nil;
    }
    
    for (NSInteger i = 0; i <= count; i++) {
        NSString *key = [url substringWithRange:NSMakeRange(i, SHORTCUT_LENGTH)];
        NSMutableArray *list = _hashTable[key];
        if (list.count) {
            for (AERDomainFilterRule *rule in list) {
                if ([url contains:rule.shortcut]) {
                    if (!lookuped) {
                        lookuped = [NSMutableArray array];
                    }
                    [lookuped addObject:rule];
                }
            }
        }
    }
    
    return lookuped;
}


- (NSString *)stringValue {
    return [[self class] description];
}

@end
