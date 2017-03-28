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

/////////////////////////////////////////////////////////////////////
#pragma mark - AERDomainFilter Implementation

@implementation AERDomainFilter {
    
    NSMutableSet <NSString *> *_domainsExactMatch;
    NSMutableSet <NSString *> *_domainsFullMatch;
    NSMutableArray <AERDomainFilterRule *> *_domainsMasksRules;
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
        
        [_domainsMasksRules addObject:rule];
    }
    else if (rule.withSubdomainsRule) {
        // add '.' on tail for optimisation
        [_domainsFullMatch addObject:[rule.domainPattern stringByAppendingString:@"."]];
    }
    else {
        
        [_domainsExactMatch addObject:rule.domainPattern];
    }
}

- (BOOL)filteredDomain:(NSString *)domain {

    return [_domainsExactMatch containsObject:domain]
    || [self fulldomainSearch:domain]
    || [self maskDomainSearch:domain];
}

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

