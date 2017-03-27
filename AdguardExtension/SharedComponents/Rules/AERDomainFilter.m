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

#import "ACommons/ACNetwork.h"
#import "ACommons/ACLang.h"
#import "AERDomainFilter.h"
#import "AERShortcutsLookupTable.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - UrlFilterRuleLookupTable Declaration

/**
 * Encapsulates different lookup tables used to speed up basic rules search
 */
@interface UrlFilterRuleLookupTable : NSObject

/**
 * Adds rule to the table
 *
 * @param rule Rule to add
 */
- (void)addRule:(__unsafe_unretained AERDomainFilterRule *)rule;

/**
 * Removes rule from the table
 *
 * @param rule Rule to remove
 */
- (void)removeRule:(__unsafe_unretained AERDomainFilterRule *)rule;

/**
 * Clears rules
 */
- (void)clearRules;

/**
 * Returns filtering rule if request is filtered or NULL if nothing found
 *
 * @param url                 Url to check
 * @return First matching rule or null if no match found
 */
- (AERDomainFilterRule *)findRuleWithUrl:(__unsafe_unretained NSString *)url;

@end


/////////////////////////////////////////////////////////////////////
#pragma mark - AFRUrlFilter Implementation

@implementation AERDomainFilter {
    
    UrlFilterRuleLookupTable *_basicRulesTable;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init]; // [super _init_];
    if (self) {
        _basicRulesTable = [UrlFilterRuleLookupTable new];
    }

    return self;
}

+ (AERDomainFilter *)filter {

    AERDomainFilter *filter = [AERDomainFilter new];

    return filter;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (void)addRule:(AERDomainFilterRule *)rule {

    if (rule == nil) {
        return;
    }
    [_basicRulesTable addRule:rule];
}

- (AERDomainFilterRule *)filteredURL:(NSString *)url {


    return [_basicRulesTable findRuleWithUrl:url];
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - UrlFilterRuleLookupTable Implementation

@implementation UrlFilterRuleLookupTable {
    
    AERShortcutsLookupTable *_shortcutsLookupTable;
    NSMutableArray <AERDomainFilterRule *> *_rulesWithoutShortcuts;
}

- (id)init {
    
    self = [super init];
    if (self) {
        _shortcutsLookupTable = [AERShortcutsLookupTable table];
        _rulesWithoutShortcuts = [NSMutableArray array];
    }
    
    return self;
}

- (void)addRule:(__unsafe_unretained AERDomainFilterRule *)rule {
    
    if (![_shortcutsLookupTable addRule:rule]) {
            [_rulesWithoutShortcuts addObject:rule];
    }
}

- (void)removeRule:(__unsafe_unretained AERDomainFilterRule *)rule {
    
    [_shortcutsLookupTable removeRule:rule];
    [_rulesWithoutShortcuts removeObject:rule];
}

- (void)clearRules {
    
    [_shortcutsLookupTable clearRules];
    [_rulesWithoutShortcuts removeAllObjects];
}

- (AERDomainFilterRule *)findRuleWithUrl:(__unsafe_unretained NSString *)url {
    
    if ([NSString isNullOrEmpty:url]) {
        return nil;
    }
    
    NSString *urlLowerCase = [url lowercaseString];
    
    NSArray <AERDomainFilterRule *> *rules = [_shortcutsLookupTable lookupRules:urlLowerCase];
    
    // Check against rules with shortcuts
    if (rules.count) {
        AERDomainFilterRule *rule = [self findRuleWithUrl:url
                                          urlLowerCase:urlLowerCase
                                                 rules:rules];
        if (rule) {
            return rule;
        }
    }
    
    // Check against rules without shortcuts
    if (_rulesWithoutShortcuts.count) {
        AERDomainFilterRule *rule = [self findRuleWithUrl:url
                                          urlLowerCase:urlLowerCase
                                                 rules:_rulesWithoutShortcuts];
        if (rule) {
            return rule;
        }
    }
    
    return nil;
}


/**
 Checks url against collection of rules

 @param url                 Request url
 @param urlLowerCase        Request url in lowercase
 @param rules               Rules to check
 
 @return First matching rule or null if nothing found
 */
- (AERDomainFilterRule *)findRuleWithUrl:(__unsafe_unretained NSString *)url
                            urlLowerCase:(__unsafe_unretained NSString *)urlLowerCase
                                   rules:(__unsafe_unretained NSArray <AERDomainFilterRule *> *)rules{

    for (AERDomainFilterRule *rule in rules) {
        if ([self filteredRule:rule url:url urlLowerCase:urlLowerCase]) {
            return rule;
        }
        
    }

    return nil;
}

/**
 * Checks if rule filters request
 *
 * @param rule                Rule
 * @param url                 Request url
 * @param urlLowerCase        Request url in lower case
 * @return YES if rule should filter this request
 */
- (BOOL)filteredRule:(__unsafe_unretained AERDomainFilterRule *)rule
                 url:(__unsafe_unretained NSString *)url
        urlLowerCase:(__unsafe_unretained NSString *)urlLowerCase {
    
    return ((!rule.shortcut || [urlLowerCase contains:rule.shortcut])
            && [rule filteredForURL:url]);
}

@end

