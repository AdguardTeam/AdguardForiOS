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
#pragma mark - FilterRuleLookupTable Declaration

/**
 * Encapsulates different lookup tables used to speed up basic rules search
 */
@interface FilterRuleLookupTable : NSObject

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
 * @param domain                 domain to check
 * @return First matching rule or null if no match found
 */
- (AERDomainFilterRule *)findRuleWithDomain:(__unsafe_unretained NSString *)domain;

@end


/////////////////////////////////////////////////////////////////////
#pragma mark - AERDomainFilter Implementation

@implementation AERDomainFilter {
    
    FilterRuleLookupTable *_basicRulesTable;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init]; // [super _init_];
    if (self) {
        _basicRulesTable = [FilterRuleLookupTable new];
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

- (AERDomainFilterRule *)filteredDomain:(NSString *)domain {


    return [_basicRulesTable findRuleWithDomain:domain];
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - FilterRuleLookupTable Implementation

@implementation FilterRuleLookupTable {
    
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

- (AERDomainFilterRule *)findRuleWithDomain:(__unsafe_unretained NSString *)domain {
    
    if ([NSString isNullOrEmpty:domain]) {
        return nil;
    }
    
    NSString *domainLowerCase = [domain lowercaseString];
    
    NSArray <AERDomainFilterRule *> *rules = [_shortcutsLookupTable lookupRules:domainLowerCase];
    
    // Check against rules with shortcuts
    if (rules.count) {
        AERDomainFilterRule *rule = [self findRuleWithDomain:domain
                                          domainLowerCase:domainLowerCase
                                                 rules:rules];
        if (rule) {
            return rule;
        }
    }
    
    // Check against rules without shortcuts
    if (_rulesWithoutShortcuts.count) {
        AERDomainFilterRule *rule = [self findRuleWithDomain:domain
                                          domainLowerCase:domainLowerCase
                                                 rules:_rulesWithoutShortcuts];
        if (rule) {
            return rule;
        }
    }
    
    return nil;
}


/**
 Checks domain against collection of rules

 @param domain                 Request domain
 @param domainLowerCase        Request domain in lowercase
 @param rules               Rules to check
 
 @return First matching rule or null if nothing found
 */
- (AERDomainFilterRule *)findRuleWithDomain:(__unsafe_unretained NSString *)domain
                            domainLowerCase:(__unsafe_unretained NSString *)domainLowerCase
                                   rules:(__unsafe_unretained NSArray <AERDomainFilterRule *> *)rules{

    for (AERDomainFilterRule *rule in rules) {
        if ([self filteredRule:rule domain:domain domainLowerCase:domainLowerCase]) {
            return rule;
        }
        
    }

    return nil;
}

/**
 * Checks if rule filters request
 *
 * @param rule                Rule
 * @param domain                 Request domain
 * @param domainLowerCase        Request domain in lower case
 * @return YES if rule should filter this request
 */
- (BOOL)filteredRule:(__unsafe_unretained AERDomainFilterRule *)rule
                 domain:(__unsafe_unretained NSString *)domain
        domainLowerCase:(__unsafe_unretained NSString *)domainLowerCase {
    
    return ((!rule.shortcut || [domainLowerCase contains:rule.shortcut])
            && [rule filteredForDomain:domain]);
}

@end

