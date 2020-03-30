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

#import "AEInvertedWhitelistDomainsObject.h"
#import "ASDFilterObjects.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEInvertedWhitelistDomainsObject

@implementation AEInvertedWhitelistDomainsObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithRules:(NSArray<ASDFilterRule *> *)rules {
    
    if(self = [super init]) {
        
        _rules = rules;
        _rule = [self ruleFromRules:rules];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark private methods

- (NSString*) rulePrefix {
    
    return @"@@||*$document,domain=";
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    // migration 3.1.4 -> 4.0.0
    // in old versions we store "domains", now we store "rules"
    NSArray<NSString*> *domains = [aDecoder decodeObjectForKey:@"domains"];
    if (domains != nil) {
        NSMutableArray<ASDFilterRule*> *rules = [NSMutableArray new];
        for (NSString* domain in domains) {
            [rules addObject:[[ASDFilterRule alloc] initWithText:domain enabled:YES]];
        }
        self.rules = [rules copy];
    }
    
    _rule = [self ruleFromRules:self.rules];

    return self;
}

- (ASDFilterRule*) ruleFromRules:(NSArray<ASDFilterRule*>*) rules {
    
    NSMutableString* ruleString = [[self rulePrefix] mutableCopy];
    
    for(int i = 0; i < rules.count; ++i) {
        
        if(rules[i].ruleText.length == 0 || rules[i].isEnabled.boolValue == NO)
            continue;
        
        if(i > 0)
            [ruleString appendString:@"|"];
        
        [ruleString appendFormat:@"~%@", rules[i].ruleText];
    }
    
    ASDFilterRule *rule = [ASDFilterRule new];
    rule.ruleText = [ruleString copy];
    rule.isEnabled = @(YES);
    return rule;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)addDomain:(NSString *)domain {
    
    if(!_rules) {
        _rules = [NSArray new];
    }
    ASDFilterRule *newRule = [[ASDFilterRule alloc] initWithText:domain enabled:YES];
    _rules = [_rules arrayByAddingObject: newRule];
    _rule = [self ruleFromRules: _rules];
}

@end
