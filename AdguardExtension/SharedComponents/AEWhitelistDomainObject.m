/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

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
#import "AEWhitelistDomainObject.h"
#import "AEFilterRuleSyntaxConstants.h"
#import "ACommons/ACLang.h"
#import "ASDFilterObjects.h"

@implementation AEWhitelistDomainObject

- (id)initWithDomain:(NSString *)domain{
    
    self = [super init]; // [super _init_];
    if (self)
    {
        _domain = domain;
        _rule = [self ruleFromDomain:domain];
    }
    
    return self;

}

- (id)initWithRule:(ASDFilterRule *)rule{
    
    if ([self checkURLRule:rule]) {
        
        self = [super init]; // [super _init_];
        if (self)
        {
            _rule = rule;
            _domain = [self domainFromRule:rule];
        }
        
        return self;
    }
        
    return nil;
}


- (NSString *)domain{
    
    return [_domain copy];
}

- (void)setDomain:(NSString *)domain{
    
    @synchronized(self){
  
        [self willChangeValueForKey:@"domain"];
        [self willChangeValueForKey:@"rule"];
        _domain = domain;
        @autoreleasepool {
            
            ASDFilterRule *rule = [self ruleFromDomain:domain];
            if (_rule) {
                
                _rule.isEnabled = rule.isEnabled;
                _rule.ruleText = rule.ruleText;
            }else{
                
                _rule = rule;
            }
        }
        [self didChangeValueForKey:@"rule"];
        [self didChangeValueForKey:@"domain"];
    }
}

- (ASDFilterRule *)rule{
    
    return _rule;
}

- (void)setRule:(ASDFilterRule *)rule{
    
    @synchronized(self){
        
        [self willChangeValueForKey:@"domain"];
        [self willChangeValueForKey:@"rule"];
        _rule = rule;
        _domain = [self domainFromRule:rule];
        [self didChangeValueForKey:@"rule"];
        [self didChangeValueForKey:@"domain"];
    }
}

- (BOOL)isEqual:(id)object{

    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]])
        return [_domain isEqualToString:[object domain]];

    else
        return NO;
}

- (NSUInteger)hash
{
    return [_domain hash];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods
/////////////////////////////////////////////////////////////////////

- (BOOL)checkURLRule:(ASDFilterRule *)rule{
    
    return ([rule.ruleText hasPrefix:self.ruleDomainPrefix]
            && [rule.ruleText hasSuffix:self.ruleDomainSufix]
            && [rule.isEnabled boolValue]);
}

- (NSString *)domainFromRule:(ASDFilterRule *)rule{

    @autoreleasepool {

        if ([rule.ruleText hasPrefix:COMMENT]) {
            
            return rule.ruleText;
        }
        
        NSRange range = [rule.ruleText rangeOfString:self.ruleDomainPrefix];
        if (range.location != NSNotFound) {
            
            NSString *result = [rule.ruleText substringFromIndex:(range.location + range.length)];
            range = [result rangeOfString:self.ruleDomainSufix];
            if (range.location != NSNotFound) {
                
                return [result substringToIndex:range.location];
            }
        }
        
        return @"";
    }
}

- (ASDFilterRule *)ruleFromDomain:(NSString *)domain{

    if (![NSString isNullOrEmpty:domain]) {
        
        ASDFilterRule *rule = [ASDFilterRule new];
        rule.ruleText = [NSString stringWithFormat:@"%@%@%@", self.ruleDomainPrefix, domain, self.ruleDomainSufix];
        rule.isEnabled = @(YES);
        return rule;
    }

    return nil;
}

- (NSString *)ruleDomainPrefix {
    
    return MASK_WHITE_LIST AFRU_MASK_START_URL;
}
- (NSString *)ruleDomainSufix {
    return AFRU_OPTIONS_DELIMITER AFRU_DOCUMENT_OPTION;
}

@end
