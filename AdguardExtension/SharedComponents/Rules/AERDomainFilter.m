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

#define HASH_TABLE_SIZE                 5000
#define STRING_CONVERT_ENCODING         NSASCIIStringEncoding

/////////////////////////////////////////////////////////////////////
#pragma mark -  Private Functions Declaration

CFIndex getIndex(const char *str, size_t len);

/////////////////////////////////////////////////////////////////////
#pragma mark - AERDomainFilter Implementation

@implementation AERDomainFilter {
    
    NSPointerFunctions *_pointerFunctions;
    NSPointerArray *_domainsExactMatch[HASH_TABLE_SIZE];
    NSPointerArray *_domainsFullMatch[HASH_TABLE_SIZE];
    NSMutableArray <AERDomainFilterRule *> *_domainsMasksRules;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init]; // [super _init_];
    if (self) {
        _pointerFunctions = [NSPointerFunctions pointerFunctionsWithOptions:
                             NSPointerFunctionsMallocMemory
                             | NSPointerFunctionsCStringPersonality
                             | NSPointerFunctionsCopyIn];
        
        memset(_domainsExactMatch, 0, sizeof(_domainsExactMatch));
        memset(_domainsFullMatch, 0, sizeof(_domainsFullMatch));

        _domainsMasksRules = [NSMutableArray new];
    }

    return self;
}

- (void)dealloc {

    [self clearHash:_domainsExactMatch];
    [self clearHash:_domainsFullMatch];
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
        NSString *domain = [rule.domainPattern stringByAppendingString:@"."];
       
        [self addDomain:domain toHash:_domainsFullMatch];
    }
    else {
        
        [self addDomain:rule.domainPattern toHash:_domainsExactMatch];
    }
}

- (BOOL)filteredDomain:(NSString *)domain {

    return [self containsDomain:domain inHash:_domainsExactMatch]
    || [self fulldomainSearch:domain]
    || [self maskDomainSearch:domain];
}


/////////////////////////////////////////////////////////////////////////
#pragma mark Private methods

- (void)addDomain:(NSString *)domain toHash:(__strong NSPointerArray *[])hash {

    const char *cDomain = [domain cStringUsingEncoding:STRING_CONVERT_ENCODING];
    
    if (cDomain) {
        CFIndex index = getIndex(cDomain, strlen(cDomain));
        NSPointerArray *list = hash[index];
        
        if (list == nil) {
            // create pointer array
            list = [NSPointerArray pointerArrayWithPointerFunctions:_pointerFunctions];
            hash[index] = list;
        }
        [list addPointer:(void *)cDomain];
    }
}

- (void)clearHash:(__strong NSPointerArray *[])hash {
    
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        if (hash[i] != nil) {
            hash[i] = nil;
        }
    }
}

- (BOOL)containsDomain:(NSString *)domain inHash:(__strong NSPointerArray *[])hash{
    
    NSPointerArray *list = nil;
    
    const char *cDomain = [domain cStringUsingEncoding:STRING_CONVERT_ENCODING];
    CFIndex index = getIndex(cDomain, strlen(cDomain));
    list = hash[index];
    
    const char *cString = NULL;
    for (CFIndex i = 0; i < list.count; i++) {
        
        cString = [list pointerAtIndex:i];
        if (cString && strcmp(cString, cDomain) == 0) {
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)fulldomainSearch:(__unsafe_unretained NSString *)domain {
    
    NSArray <NSString *> *parts = [domain componentsSeparatedByString:@"."];
    
    __block NSString *searchDomain = [NSString new];
    __block BOOL result = NO;
    [parts enumerateObjectsWithOptions:NSEnumerationReverse
                            usingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                searchDomain = [NSString stringWithFormat:@"%@.%@",obj, searchDomain];
                                
                                if ([self containsDomain:searchDomain inHash:_domainsFullMatch]) {
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

/////////////////////////////////////////////////////////////////////
#pragma mark - Private functions Implementation
/////////////////////////////////////////////////////////////////////

CFIndex getIndex(const char *str, size_t len) {
    
    unsigned long hash = 5381;
    for (uint i = 0; i < len; i++) {
        hash = ((hash << 5) + hash) + *(str + i);
    }
    
    return hash % HASH_TABLE_SIZE;
}
