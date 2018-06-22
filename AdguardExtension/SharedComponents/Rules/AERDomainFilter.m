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
#include <sys/queue.h>

#import "ACommons/ACNetwork.h"
#import "ACommons/ACLang.h"
#import "AERDomainFilter.h"

#define HASH_TABLE_SIZE                 5000
#define STRING_CONVERT_ENCODING         NSASCIIStringEncoding

typedef struct qEntry {
    char *domain;
    SLIST_ENTRY(qEntry) list;
} qEntry;

SLIST_HEAD(DomainQ, qEntry);

typedef struct DomainQ DomainQueue;

/////////////////////////////////////////////////////////////////////
#pragma mark -  Private Functions Declaration

CFIndex getIndex(const char *str, size_t len);

/////////////////////////////////////////////////////////////////////
#pragma mark - AERDomainFilter Implementation

@implementation AERDomainFilter {
    
    NSPointerFunctions *_pointerFunctions;
    DomainQueue *_domainsExactMatch[HASH_TABLE_SIZE];
    DomainQueue *_domainsFullMatch[HASH_TABLE_SIZE];
    NSMutableArray <AERDomainFilterRule *> *_domainsMasksRules;
    NSUInteger _rulesCount;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init {
    self = [super init]; // [super _init_];
    if (self) {
        
        _rulesCount = 0;
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

- (NSUInteger)rulesCount {
    
    return _rulesCount;
}

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
    
    _rulesCount++;
}

- (BOOL)filteredDomain:(NSString *)domain {

    return [self containsDomain:domain inHash:_domainsExactMatch]
    || [self fulldomainSearch:domain]
    || [self maskDomainSearch:domain];
}


/////////////////////////////////////////////////////////////////////////
#pragma mark Private methods

- (void)addDomain:(__unsafe_unretained NSString *)domain toHash:(DomainQueue *[])hash {

    qEntry *entry = malloc(sizeof(qEntry));
    if (entry) {
        size_t size = domain.length + 1;
        entry->domain = malloc(sizeof(*(entry->domain)) * size);
        if (entry->domain) {
            
            if ([domain getCString:entry->domain maxLength:size encoding:STRING_CONVERT_ENCODING]) {
                
                CFIndex index = getIndex(entry->domain, size - 1);
                DomainQueue *queue = hash[index];
                
                if (queue == nil) {
                    // create
                    queue = malloc(sizeof(DomainQueue));
                    if (queue) {
                        
                        SLIST_INIT(queue);
                        hash[index] = queue;
                        
                        SLIST_INSERT_HEAD(queue, entry, list);
                        return;
                    }
                }
                else {
                    
                    SLIST_INSERT_HEAD(queue, entry, list);
                    return;
                }
            }
            
            free(entry->domain);
        }
        free(entry);
    }
}

- (void)clearHash:(DomainQueue *[])hash {
    
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        if (hash[i]) {
            DomainQueue *queue = hash[i];
            
            while (!SLIST_EMPTY(queue)) {           /* List Deletion. */
                qEntry *entry = SLIST_FIRST(queue);
                SLIST_REMOVE_HEAD(queue, list);
                free(entry->domain);
                free(entry);
            }
            free(queue);
            hash[i] = NULL;
        }
    }
}

- (BOOL)containsDomain:(NSString *)domain inHash:(DomainQueue *[])hash{
    
    const char *cDomain = [domain cStringUsingEncoding:STRING_CONVERT_ENCODING];
    CFIndex index = getIndex(cDomain, strlen(cDomain));
    
    DomainQueue *queue = hash[index];
    
    if (queue) {

        qEntry *entry = NULL;
        SLIST_FOREACH(entry, queue, list){

            if (entry->domain && strcmp(entry->domain, cDomain) == 0) {
                
                return YES;
            }
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
