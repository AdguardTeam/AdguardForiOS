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

#ifdef DEBUG
#import <malloc/malloc.h>
#endif
#import "ACommons/ACNetwork.h"
#import "ACommons/ACLang.h"
#import "AERDomainFilter.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AERDomainFilter Implementation

@implementation AERDomainFilter {
    
    NSMutableSet <NSString *> *_domainsExactMatch;
    NSMutableSet <NSString *> *_domainsFullMatch;
    NSMutableArray <AERDomainFilterRule *> *_domainsMasksRules;
#ifdef DEBUG
    NSUInteger _maskSize;
    NSUInteger _fullSize;
    NSUInteger _exactSize;
#endif
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init]; // [super _init_];
    if (self) {
        _domainsExactMatch = [NSMutableSet new];
        _domainsFullMatch = [NSMutableSet new];
        _domainsMasksRules = [NSMutableArray new];
        
#ifdef DEBUG
        _maskSize = _fullSize = _exactSize = 0;
#endif
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

    if ([NSString isNullOrEmpty:rule.domainPattern]) {
        return;
    }
    
    if (rule.maskRule) {
        
#ifdef DEBUG
        _maskSize += malloc_size((__bridge const void *) rule.domainPattern) + malloc_size((__bridge const void *) rule);
#endif
        [_domainsMasksRules addObject:rule];
    }
    else if (rule.withSubdomainsRule) {
        // add '.' on tail for optimisation
        NSString *domain = [rule.domainPattern stringByAppendingString:@"."];
#ifdef DEBUG
        _fullSize += malloc_size((__bridge const void *) domain);
#endif
        [_domainsFullMatch addObject:domain];
    }
    else {
        
#ifdef DEBUG
        _exactSize += malloc_size((__bridge const void *) rule.domainPattern);
#endif
        [_domainsExactMatch addObject:rule.domainPattern];
    }
}

- (BOOL)filteredDomain:(NSString *)domain {

    return [_domainsExactMatch containsObject:domain]
    || [self fulldomainSearch:domain]
    || [self maskDomainSearch:domain];
}

#ifdef DEBUG
- (void)printMemoryUsage {
    
    NSUInteger val = _exactSize + malloc_size((__bridge const void *) _domainsExactMatch);
    NSLog(@"ProTunnel exact domains: %lu", val);
    val = _fullSize + malloc_size((__bridge const void *) _domainsFullMatch);
    NSLog(@"ProTunnel full domains: %lu", val);
    val = _maskSize + malloc_size((__bridge const void *) _domainsMasksRules);
    NSLog(@"ProTunnel mask domains: %lu", val);
}
#endif

/////////////////////////////////////////////////////////////////////////
#pragma mark Private methods

- (BOOL)fulldomainSearch:(__unsafe_unretained NSString *)domain {
    
    NSArray <NSString *> *parts = [domain componentsSeparatedByString:@"."];
    
    __block NSString *searchDomain = [NSString new];
    __block BOOL result = NO;
    [parts enumerateObjectsWithOptions:NSEnumerationReverse
                            usingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                searchDomain = [NSString stringWithFormat:@"%@.%@",obj, searchDomain];
                                
                                if ([_domainsFullMatch containsObject:searchDomain]) {
                                    *stop = YES;
                                    result = YES;
                                }
                            }];
    
    return result;
}

- (BOOL)maskDomainSearch:(__unsafe_unretained NSString *)domain {
    
    for (AERDomainFilterRule *rule in _domainsMasksRules) {
        if ([rule filteredForDomain:domain]) {
            return YES;
        }
    }
    
    return NO;
}

@end

