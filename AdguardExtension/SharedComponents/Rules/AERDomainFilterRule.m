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

#import "AERDomainFilterRule.h"
#import "ACommons/ACLang.h"

@implementation AERDomainFilterRule {
    
    NSUInteger *_partsLength;
    NSUInteger _partsCount;
}

/////////////////////////////////////////////////////////////////////
#pragma mark -  Constructor (parsing rule text)
/////////////////////////////////////////////////////////////////////

/// Init (parsing rule text)
- (id)initWithRule:(NSString *)rule {
    
    @autoreleasepool {
        
        if ([self isValidRuleText:rule] == NO) {
            DDLogWarn(@"Error creating invalid rule: %@", rule);
            return nil;
        }
        
        if ([self isComment:rule]) {
            return nil;
        }
        
        self = [super init];
        if (self) {
            
            _whiteListRule = _withSubdomainsRule = _maskRule = NO;
            _partsCount = 0;
            _partsLength = NULL;
            
            if ([rule hasPrefix:MASK_WHITE_LIST]) {
                rule = [rule substringFromIndex:MASK_WHITE_LIST.length];
                _whiteListRule = YES;
            }
            
            //check head
            NSString *head = [rule substringToIndex:(rule.length > 9) ? 9 : rule.length];
            NSInteger idx = [head indexOf:AFRU_URL_SCHEME_SEPARATOR];
            if (idx != -1) {

                rule = [rule substringFromIndex:idx + 2];
            }
            else if ([rule hasPrefix:AFRU_MASK_START_URL]) {
                
                rule = [rule substringFromIndex:AFRU_MASK_START_URL.length];
                _withSubdomainsRule = YES;
            }
            else if ([rule hasPrefix:AFRU_MASK_PIPE]) {
                
                rule = [rule substringFromIndex:AFRU_MASK_PIPE.length];
            }
            else if ([rule hasPrefix:AFRU_MASK_ANY_SYMBOL] == NO) {
                
                rule = [AFRU_MASK_ANY_SYMBOL stringByAppendingString:rule];
            }
            
            //check tail
            if ([rule hasSuffix:AFRU_MASK_SEPARATOR]
                || [rule hasSuffix:AFRU_MASK_PIPE]
                || [rule hasSuffix:AFRU_URL_PATH_SEPARATOR]) {
                
                rule = [rule substringToIndex:(rule.length - 1)];
            }
            else if ([rule hasSuffix:AFRU_MASK_ANY_SYMBOL] == NO){
                
                rule = [rule stringByAppendingString:AFRU_MASK_ANY_SYMBOL];
            }
            
            if (rule.length == 0  || [rule isEqualToString:AFRU_MASK_ANY_SYMBOL]) {
                // Rule matches everything and does not have any domain restriction
                DDLogWarn(@"Too wide basic rule: %@", rule);
                return nil;
            }
            
            // punycoding here
            rule = [rule IDNAEncodedString];
            
            // Searching for shortcut
            [self findParts:rule];
            
            _domainPattern = rule;
        }
    }
    return self;

}
+ (AERDomainFilterRule *)rule:(NSString *)ruleText{
    AERDomainFilterRule *rule = [[AERDomainFilterRule alloc] initWithRule:ruleText];

    return rule;

}

- (void)dealloc {
    
    free(_partsLength);
}

/////////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and query methods
/////////////////////////////////////////////////////////////////////////


- (BOOL)filteredForDomain:(NSString *)domain {

    NSUInteger idx = 0;
    NSUInteger len = 0;
    NSRange range;
    NSInteger domainIdx = 0;
    NSString *part;
    for (int i = 0; i < _partsCount; i++) {
        
        len = _partsLength[i];
        range = NSMakeRange(idx, len);
        
        if (len) {
            
            part = [_domainPattern substringWithRange:range];
            
            //first part
            if (idx == 0) {
                domainIdx  = [domain hasPrefix:part] ? 0 : -1;
            }
            else {
                //other parts
                domainIdx = [domain indexOf:part fromIndex:domainIdx];
            }
            
            if (domainIdx == -1) {
                
                // if this is subdomain rule
                // and we on first part
                if (idx == 0 && _withSubdomainsRule) {
                    
                    part = [@"." stringByAppendingString:part];
                    domainIdx = [domain indexOf:part];
                    
                    if (domainIdx == -1) {
                        return NO;
                    }
                    
                    domainIdx ++; // compensation of '.'
                }
                else {
                    return NO;
                }
            }
        }
        
        idx += len + 1;
        domainIdx += len;
    }
    
    return YES;
}

/////////////////////////////////////////////////////////////////////
#pragma mark -  Private methods
/////////////////////////////////////////////////////////////////////


- (BOOL)isValidRuleText:(__unsafe_unretained NSString *)ruleText {
    
    if ([NSString isNullOrEmpty:ruleText]
        || [ruleText contains:MASK_OBSOLETE_SCRIPT_INJECTION]) {
        
        return NO;
    }

    if ([ruleText hasPrefix:MASK_WHITE_LIST]) {
        return YES;
    }
    
    if ([ruleText contains:MASK_CONTENT_RULE]
        || [ruleText contains:MASK_CONTENT_EXCEPTION_RULE]
        || [ruleText contains:MASK_CSS_INJECT_RULE]
        || [ruleText contains:MASK_CSS_INJECT_EXCEPTION_RULE]
        || [ruleText contains:MASK_SCRIPT_RULE]
        || [ruleText contains:MASK_SCRIPT_EXCEPTION_RULE]
        || [ruleText contains:MASK_CSS_RULE]
        || [ruleText contains:MASK_CSS_EXCEPTION_RULE]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isComment:(__unsafe_unretained NSString *)ruleText {
    
    return [[NSString stringByTrim:ruleText] hasPrefix:COMMENT];
}

- (void)findParts:(NSString *)urlmask {
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString: AFRU_MASK_ANY_SYMBOL];
    NSArray *parts = [urlmask componentsSeparatedByCharactersInSet:cSet];
    
    _partsCount = parts.count;
    _partsLength = malloc(sizeof(*_partsLength) * _partsCount);
    
    if (_partsCount > 1) {
        _maskRule = YES;
    }
    
    int i = 0;
    for (NSString *part in parts) {
        
        _partsLength[i++] = part.length;
        
    }
    
}

@end
